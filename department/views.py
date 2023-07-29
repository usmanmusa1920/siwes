from django.shortcuts import render, redirect, reverse
from django.contrib import messages
from django.core.paginator import Paginator
from django.contrib.auth.decorators import login_required
from django.contrib.auth import get_user_model
from toolkit import (picture_name, y_session)
from toolkit.decorators import (
    block_student_update_profile, restrict_access_student_profile, val_id_num, check_phone_number, admin_required, dean_required, hod_required, coordinator_required, supervisor_required, schoolstaff_required, student_required, supervisor_or_student_required, coordinator_or_supervisor_or_student_required
)
from administrator.models import Administrator
from administrator.tables import (
    Session, Faculty, Department, Vc, Hod, Coordinator, Supervisor, Student, Letter, Acceptance, WeekReader, WeekEntry, WeekEntryImage, Result
)


User = get_user_model()


class CoordinatorCls:
    """Trianing coordinator related views"""

    @coordinator_required
    @staticmethod
    def profile(request, id_no):
        """coordinator profile"""
        
        # current school session
        current_sch_sess = Session.objects.filter(is_current_session=True).last()

        training_tutor = User.objects.filter(identification_num=id_no).first()
        coordinator = Coordinator.objects.filter(
            id_no=training_tutor.identification_num).first()

        # filtering coordinator training student
        coordinator_students = Student.objects.filter(student_coordinator=training_tutor).order_by('-date_joined')

        # filtering coordinator training student that upload acceptance letter
        students_acceptances = Acceptance.objects.filter(
            receiver=coordinator, is_reviewed=False).order_by('-timestamp')

        # filtering coordinator training student base on session
        student_session = Student.objects.filter(student_coordinator=training_tutor, session_200=y_session()).order_by('-date_joined') | Student.objects.filter(student_coordinator=training_tutor, session_300=y_session()).order_by('-date_joined')

        # filtering coordinator training student whose their level is 200
        student_of_200 = Student.objects.filter(
            student_coordinator=training_tutor, level='200')

        # filtering coordinator training student whose their level is 300
        student_of_300 = Student.objects.filter(
            student_coordinator=training_tutor, level='300')
        
        student_result = Result.objects.filter(
            c_id_no=coordinator.id_no, session=current_sch_sess.session, is_approve=False).order_by('-timestamp')
        
        context = {
            'coordinator': coordinator,
            'coordinator_students': coordinator_students,
            'students_acceptances': students_acceptances,
            'student_of_200': student_of_200,
            'student_of_300': student_of_300,
            'student_session': student_session,
            'student_result': student_result,
        }
        return render(request, 'department/coordinator_profile.html', context=context)

    @coordinator_required
    @staticmethod
    def session_student(request, which_session=y_session()):
        """coordinator list of student page"""
        coord_dept_request_user = request.user
        training_tutor = Coordinator.objects.filter(
            coordinator=coord_dept_request_user).first()
        training_tutor_tab = User.objects.filter(
            identification_num=training_tutor.id_no).first()

        # filtering coordinator training student
        students_paginator = Student.objects.filter(student_coordinator=training_tutor_tab, session=which_session).order_by('-date_joined')

        paginator = Paginator(students_paginator, 10)  # paginating by 10
        page = request.GET.get('page')
        coordinator_students = paginator.get_page(page)

        context = {
            'training_tutor': training_tutor,
            'coordinator_students': coordinator_students,
        }
        return render(request, 'department/training_coordinator_session_student.html', context=context)

    @coordinator_required
    @staticmethod
    def students_acceptance_letter(request):
        """
        coordinator list of student that upload acceptance letter, whether viwed or not
        """
        coord_dept_request_user = request.user
        training_tutor = Coordinator.objects.filter(coordinator=coord_dept_request_user).first()

        # filtering students acceptance letter
        students_acceptances = Acceptance.objects.filter(receiver=training_tutor).order_by('timestamp')

        # paginating by 10
        paginator = Paginator(students_acceptances, 10)
        page = request.GET.get('page')
        students_letters = paginator.get_page(page)

        context = {
            'training_tutor': training_tutor,
            'students_letters': students_letters,
        }
        return render(request, 'department/training_coordinator_student_accpetance_letter.html', context=context)
    
    @coordinator_required
    @staticmethod
    def view_student_letter(request, letter_id):
        """
        If student `active` departmental training coordinator view student acceptance letter,
        it will automatically mark it as reviewed using this view
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
    def acknowledge_student(request, student_id):
        """accept student as (coordinator add student in his list)"""
        # filtering student in user model using id
        student_to_add_usr = User.objects.get(id=student_id)
        student_to_add = Student.objects.filter(
            matrix_no=student_to_add_usr).first()

        # filtering coordinator in user model using id
        coord_in_usr = User.objects.get(id=request.user.id)
        coord = Coordinator.objects.filter(id_no=coord_in_usr.identification_num).first()
        coord.training_students.add(student_to_add)
        if student_to_add in coord.training_students.all():
            messages.success(request, f'You alrady acknowledged ({student_to_add.matrix_no}) into your this session student')
        else:
            messages.success(request, f'You acknowledged ({student_to_add.matrix_no}) into your this session student')
        return redirect('department:training_coordinator_session_student')
    
    @coordinator_required
    @staticmethod
    def assign_supervisor(request, id_no):
        """for 200 and 300 level"""
        # departmental training coordinator instance
        coordinator = Coordinator.objects.filter(id_no=id_no).first()

        if request.method == 'POST':
            # grabbing data from html form
            raw_supervisor = request.POST['raw_supervisor'] # supervisor id
            supervisor = Supervisor.objects.filter(id_no=raw_supervisor).first()
            
            # convert request data to python dictionary, since if
            # we use `request.POST['raw_students']` will only capture the last
            # item, but we, we want all
            req_dict = dict(request.POST)
            # set of students matrix number
            raw_students = req_dict['raw_students']
            
            # looping over the raw_students data in other to add them to a supervisor
            for student in raw_students:
                student = Student.objects.filter(matrix_no=student).first()
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
        """this is view that create student result"""
        student = Student.objects.filter(matrix_no=matrix_no).first()
        # student_coord = student.student_coordinator
        
        if student.level == 200 or student.level == '200':
            result = Result.objects.filter(student=student, level=student.level).first()
        else:
            result = Result.objects.filter(student=student, level=student.level).first()
        result = Result.objects.filter(student=student, level='200').first()
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
            student.save()

        # current school session
        school_session = Session.objects.filter(is_current_session=True).last()
        messages.success(
            request, f'You just approve student ({student.matrix_no}) result for {school_session.session} session')
        return redirect('landing')
    

    # @coordinator_required
    @staticmethod
    def student_result(request, matrix_no, level):
        student = Student.objects.filter(matrix_no=matrix_no).first()
        result = Result.objects.filter(student=student, level=level).first()

        # blocking other user from viewing student training letter, if he/she is not the student or the student coordinator
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
        # active department hod
        hod = Hod.objects.filter(department=coordinator.department, is_active=True).last()
        # active school vc
        active_vc = Vc.objects.filter(is_active=True).last()
        
        if request.method == 'POST':
            # getting values from html templates
            duration = request.POST['duration']
            start_of_training = request.POST['start_of_training']
            end_of_training = request.POST['end_of_training']

            # letter is for both acceptance and placement
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
