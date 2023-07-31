from django.shortcuts import render, redirect, reverse
from django.contrib import messages
from django.core.paginator import Paginator
from django.contrib.auth import get_user_model
from toolkit import (y_session)
from toolkit.decorators import (
    block_student_update_profile, restrict_access_student_profile, val_id_num, check_phone_number,staff_required, admin_required, vc_required, hod_required, coordinator_required, supervisor_required, schoolstaff_required, student_required, coordinator_or_student_required, supervisor_or_student_required, coordinator_or_supervisor_or_student_required
)
from administrator.tables import (
    Session, Vc, Hod, Coordinator, Supervisor, Student, Letter, Acceptance, Result
)


User = get_user_model()


class CoordinatorCls:
    """coordinator related views"""
    
    @coordinator_required
    @staticmethod
    def profile(request, id_no):
        """coordinator profile"""
        # current school session
        current_sch_sess = Session.objects.filter(is_current_session=True).last()
        coordinator_user = User.objects.filter(identification_num=id_no).first()
        coordinator = Coordinator.objects.filter(
            id_no=coordinator_user.identification_num).first()
        # filtering coordinator training student base on session
        coordinator_students = Student.objects.filter(
            student_coordinator=coordinator_user, session_200=current_sch_sess.session).order_by('-date_joined') | Student.objects.filter(student_coordinator=coordinator_user, session_300=current_sch_sess.session).order_by('-date_joined')
        # filtering coordinator training student that upload acceptance letter
        students_acceptances = Acceptance.objects.filter(
            receiver=coordinator, is_reviewed=False).order_by('-timestamp')
        # filtering coordinator training student whose their level is 200
        student_of_200 = Student.objects.filter(
            student_coordinator=coordinator_user, level='200')
        # filtering coordinator training student whose their level is 300
        student_of_300 = Student.objects.filter(
            student_coordinator=coordinator_user, level='300')
        student_result = Result.objects.filter(
            c_id_no=coordinator.id_no, session=current_sch_sess.session, is_approve=False).order_by('-timestamp')
        context = {
            'student_of_200': student_of_200,
            'student_of_300': student_of_300,
            'student_result': student_result,
            'coordinator': coordinator,
            'coordinator_students': coordinator_students,
            'students_acceptances': students_acceptances,
        }
        return render(request, 'department/coordinator_profile.html', context=context)
    
    @coordinator_required
    @staticmethod
    def session_student(request):
        """coordinator list of student page"""
        # current school session
        school_session = Session.objects.filter(is_current_session=True).last()
        coordinator = Coordinator.objects.filter(
            coordinator=request.user).first()
        coordinator_user = User.objects.filter(
            identification_num=coordinator.id_no).first()
        # filtering coordinator session student
        students_paginator = Student.objects.filter(
            student_coordinator=coordinator_user, session_200=school_session.session).order_by('-date_joined') | Student.objects.filter(student_coordinator=coordinator_user, session_300=school_session.session).order_by('-date_joined')
        paginator = Paginator(students_paginator, 10) # paginating by 10
        page = request.GET.get('page')
        coordinator_students = paginator.get_page(page)
        context = {
            'coordinator': coordinator,
            'coordinator_students': coordinator_students,
        }
        return render(request, 'department/coordinator_session_student.html', context=context)
    
    @coordinator_required
    @staticmethod
    def coordinator_student_acceptance_letter(request):
        """
        coordinator list of student that upload acceptance letter, whether viwed or not
        """
        # current school session
        school_session = Session.objects.filter(is_current_session=True).last()
        coordinator = Coordinator.objects.filter(coordinator=request.user).first()
        # filtering students acceptance letter
        students_acceptances = Acceptance.objects.filter(
            receiver=coordinator, session=school_session.session).order_by('timestamp')
        # paginating by 10
        paginator = Paginator(students_acceptances, 10)
        page = request.GET.get('page')
        students_letters = paginator.get_page(page)
        context = {
            'students_letters': students_letters,
        }
        return render(request, 'department/coordinator_student_accpetance_letter.html', context=context)
    
    @coordinator_required
    @staticmethod
    def view_student_letter(request, letter_id):
        """
        If student coordinator view his/her acceptance letter, it will automatically mark it as reviewed using this view
        """
        letter = Acceptance.objects.get(id=letter_id)
        letter.is_reviewed = True
        letter.can_change = False
        letter.save()
        context = {
            'letter': letter,
        }
        return render(request, 'department/student_upload_acceptance_letter.html', context=context)
    
    @coordinator_required
    @staticmethod
    def assign_supervisor(request, id_no):
        """for 200 and 300 level"""
        # departmental training coordinator instance
        coordinator = Coordinator.objects.filter(id_no=id_no).first()
        # blocking in active coordinator from releasing letter
        if coordinator.is_active == False:
            return False
        if request.method == 'POST':
            # grabbing data from html form
            raw_supervisor = request.POST['raw_supervisor'] # supervisor id
            supervisor = Supervisor.objects.filter(id_no=raw_supervisor).first()
            
            # convert request data to python dictionary, since if we use `request.POST['raw_students']` will only capture the last item, but we, we want all
            req_dict = dict(request.POST)
            # set of students matrix number
            raw_students = req_dict['raw_students']
            # Making sure atmost coordinator select a maximum of 10 student in a go
            if len(raw_students) > 10:
                messages.warning(
                    request, f'Atmost you are to select a maximum of 10 student in a go, but you select {len(raw_students)}')
                return redirect('department:assign_supervisor', id_no=id_no)
            # looping over the raw_students data in other to add them to a selected supervisor
            for student in raw_students:
                student = Student.objects.filter(matrix_no=student).first()
                # making sure to check `is_assign_supervisor_*00` boolean filed of a student
                if student.level == 200 or student.level == '200':
                    student.is_assign_supervisor_200 = True
                    student.supervisor_id_200 = raw_supervisor
                else:
                    student.is_assign_supervisor_300 = True
                    student.supervisor_id_300 = raw_supervisor
                student.save()
                supervisor.students.add(student)
            messages.success(
                request, f'You just assign {len(raw_students)} ({raw_students}) students to a supervisor `{supervisor.first_name} {supervisor.last_name}` ({supervisor.id_no})')
            return redirect('department:assign_supervisor', id_no=id_no)
        context = {
            'coordinator': coordinator,
        }
        return render(request, 'department/assign_supervisor.html', context=context)
    
    @coordinator_required
    @staticmethod
    def approve_student_result(request, matrix_no):
        """this is view that approve student result"""
        student = Student.objects.filter(matrix_no=matrix_no).first()
        # current school session
        school_session = Session.objects.filter(is_current_session=True).last()
        # filtering student result base using his level
        if student.level == 200 or student.level == '200':
            result = Result.objects.filter(student=student, level=student.level).first()
        else:
            result = Result.objects.filter(student=student, level=student.level).first()
        result.is_approve = True
        result.save()
        # incrementing student level by 100, if he is 200 level
        if student.level == 200 or student.level == '200':
            # finish 200 level training
            student.is_finish_200 = True
            student.level = '300'
            student.save()
        else:
            # finish 300 level training
            student.is_finish_300 = True
            student.is_in_school = False
            student.save()
        messages.success(
            request, f'You just approve student ({student.matrix_no}) result for {school_session.session} session')
        return redirect('landing')
    
    @coordinator_or_supervisor_or_student_required
    @staticmethod
    def student_result_page(request, matrix_no, level):
        """student result page"""
        student = Student.objects.filter(matrix_no=matrix_no).first()
        result = Result.objects.filter(student=student, level=level).first()
        # blocking other user from viewing student training result, if he/she is not the student or the student coordinator
        if request.user == student.student:
            pass
        elif request.user == student.student_coordinator:
            pass
        else:
            return False
        # checking result
        if not result:
            messages.success(
                request, f'The result is not out for ({student}) of {student.level})')
            return redirect(
                'auth:general_profile', id_no=request.user.identification_num)
        context = {
            'result': result,
            'student': student,
        }
        return render(request, 'student/student_result.html', context=context)
    
    @coordinator_required
    @staticmethod
    def new_letter(request):
        """new letter view"""
        coordinator = Coordinator.objects.filter(coordinator=request.user).first()
        # blocking in active coordinator from releasing letter
        if coordinator.is_active == False:
            return False
        # current school session
        current_sch_sess = Session.objects.filter(is_current_session=True).last()

        # last department letter, blocking coordinator from releasing new letter if there is his department letter that match this session.
        last_letter = Letter.objects.filter(coordinator=coordinator, session=current_sch_sess.session).last()
        if last_letter:
            messages.success(
                request, f'Letter for this session ({current_sch_sess.session}) was already released!')
            return redirect(reverse(
                'department:training_coordinator_profile', kwargs={'id_no': coordinator.id_no}))
        # getting active department hod
        hod = Hod.objects.filter(department=coordinator.department, is_active=True).last()
        # getting active school vc
        active_vc = Vc.objects.filter(is_active=True).last()
        
        if request.method == 'POST':
            # getting values from html templates
            duration = request.POST['duration']
            start_of_training = request.POST['start_of_training']
            end_of_training = request.POST['end_of_training']
            # letter
            letter = Letter(
                coordinator=coordinator, hod=hod, vc=active_vc, start_of_training=start_of_training, end_of_training=end_of_training, session=current_sch_sess.session, duration=duration)
            letter.save()
            messages.success(
                request, f'Your release new letter of your student for {current_sch_sess.session} session')
            return redirect(reverse(
                'department:training_coordinator_profile', kwargs={'id_no': coordinator.id_no}))
        context = {
            'coordinator': coordinator,
            'school_session': current_sch_sess.session,
        }
        return render(request, 'department/new_letter.html', context=context)
