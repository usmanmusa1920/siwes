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
from administrator.all_models import(
    Session, Faculty, Department, SchoolVC, FacultyDean, DepartmentHOD, TrainingStudent, StudentSupervisor, DepartmentTrainingCoordinator, Letter, AcceptanceLetter, WeekReader, WeekScannedLogbook, CommentOnLogbook, StudentResult
)


User = get_user_model()


class Coordinator:
    """Trianing coordinator related views"""

    @coordinator_required
    @staticmethod
    def profile(request, id_no):
        """coordinator profile"""
        
        training_tutor = User.objects.filter(identification_num=id_no).first()
        training_tutor_tab = DepartmentTrainingCoordinator.objects.filter(
            id_no=training_tutor.identification_num).first()

        # filtering coordinator training student
        coordinator_students = TrainingStudent.objects.filter(student_training_coordinator=training_tutor).order_by('-date_joined')

        # filtering coordinator training student that upload acceptance letter
        students_acceptances = AcceptanceLetter.objects.filter(receiver_acept=training_tutor_tab).order_by('-timestamp')

        # filtering coordinator training student base on session
        student_session = TrainingStudent.objects.filter(
            student_training_coordinator=training_tutor, session=y_session()).order_by('-date_joined')

        # filtering coordinator training student whose their level is 200
        student_of_200 = TrainingStudent.objects.filter(
            student_training_coordinator=training_tutor, level='200')

        # filtering coordinator training student whose their level is 300
        student_of_300 = TrainingStudent.objects.filter(
            student_training_coordinator=training_tutor, level='300')
        
        context = {
            'training_tutor': training_tutor_tab,
            'coordinator_students': coordinator_students,
            'students_acceptances': students_acceptances,
            'student_of_200': student_of_200,
            'student_of_300': student_of_300,
            'student_session': student_session,
        }
        return render(request, 'department/coordinator_profile.html', context=context)

    @coordinator_required
    @staticmethod
    def sessionStudent(request, which_session=y_session()):
        """coordinator list of student page"""
        coord_dept_request_user = request.user
        training_tutor = DepartmentTrainingCoordinator.objects.filter(
            coordinator=coord_dept_request_user).first()
        training_tutor_tab = User.objects.filter(
            identification_num=training_tutor.id_no).first()

        # filtering coordinator training student
        students_paginator = TrainingStudent.objects.filter(student_training_coordinator=training_tutor_tab, session=which_session).order_by('-date_joined')

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
        training_tutor = DepartmentTrainingCoordinator.objects.filter(coordinator=coord_dept_request_user).first()

        # filtering students acceptance letter
        students_acceptances = AcceptanceLetter.objects.filter(receiver_acept=training_tutor).order_by('timestamp')

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
    def viewStudentLetter(request, letter_id):
        """
        If student `active` departmental training coordinator view student acceptance letter,
        it will automatically mark it as reviewed using this view
        """
        letter = AcceptanceLetter.objects.get(id=letter_id)
        letter.is_reviewed = True
        letter.can_change = False
        letter.save()
        context = {
            'letter': letter,
        }
        return render(request, 'department/student_upload_acceptance_letter.html', context=context)

    @coordinator_required
    @staticmethod
    def acknowledgeStudent(request, student_id):
        """accept student as (coordinator add student in his list)"""
        # filtering student in user model using id
        student_to_add_usr = User.objects.get(id=student_id)
        student_to_add = TrainingStudent.objects.filter(
            matrix_no=student_to_add_usr).first()

        # filtering coordinator in user model using id
        coord_in_usr = User.objects.get(id=request.user.id)
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_in_usr.identification_num).first()
        coord.training_students.add(student_to_add)
        if student_to_add in coord.training_students.all():
            messages.success(request, f'You alrady acknowledged ({student_to_add.matrix_no}) into your this session student')
        else:
            messages.success(request, f'You acknowledged ({student_to_add.matrix_no}) into your this session student')
        return redirect('department:training_coordinator_session_student')
    
    @coordinator_required
    @staticmethod
    def assign_supervisor(request, id_no, level):
        """for 200 and 300 level"""

        # departmental training coordinator instance
        training_tutor = DepartmentTrainingCoordinator.objects.filter(id_no=id_no).first()

        if request.method == 'POST':
            
            # grabbing data from html form
            req_supervisor = request.POST['raw_supervisors']
            supervisor = StudentSupervisor.objects.filter(id_no=req_supervisor).first()
            
            # convert request data to python dictionary, since if
            # we use `request.POST['raw_students']` will only capture the last
            # item, but we, we want all
            req_dict = dict(request.POST)
            req_student = req_dict['raw_students']
            
            # looping over the req_student data in other to add them to a supervisor
            for student in req_student:
                student_user = TrainingStudent.objects.filter(matrix_no=student).first()
                if level == 200 or level == '200':
                    student_user.is_assign_supervisor_200 = True
                    student_user.supervisor_id_200 = req_supervisor
                else:
                    student_user.is_assign_supervisor_300 = True
                    student_user.supervisor_id_300 = req_supervisor
                student_user.save()
                supervisor.training_students.add(student_user)
            messages.success(
                request, f'You just assign ({req_student}) to a supervisor `{supervisor.first_name} {supervisor.last_name}` ({supervisor.id_no})')
            return redirect('department:assign_supervisor', id_no=id_no, level=level)
        context = {
            'level': level,
            'training_tutor': training_tutor,
        }
        return render(request, 'department/assign_supervisor.html', context=context)
    

    @coordinator_required
    @staticmethod
    def release_student_result(request, matrix_no):
        """this is view that create student result"""
        student_user = TrainingStudent.objects.filter(matrix_no=matrix_no).first()
        student_coord = student_user.student_training_coordinator
        student_supervisor = student_user.student_training_coordinator

        is_result = StudentResult.objects.filter(
            student=student_user, level=student_user.level).first()
        # checking result
        if is_result:
            messages.warning(
                request, f'You already released out this student ({student_user.first_name}) result of {student_user.level} level')
            return redirect(
                'department:student_result_page', matrix_no=matrix_no, level=student_user.level)
        def train_calc():
            if student_user.level == 200:
                WKSL = WeekScannedLogbook.objects.filter(
                    student_lg=student_user, session=student_user.session_200)
            else:
                WKSL = WeekScannedLogbook.objects.filter(
                    student_lg=student_user, session=student_user.session_300)
            total_comment_score = 0
            for scanned in WKSL:
                comment_grade = CommentOnLogbook.objects.filter(logbook=scanned).first()
                total_comment_score += int(comment_grade.grade)
            
            # total score for student in a training
            student_total_mark = total_comment_score

            # here we assume each day mark is 1 mark, so in a week student may get 5 mark for 1 week, if we times 5 day with 12 weeks number (5 * 12), we will get 60, which is overall score expected that a student will have (100%)
            total_expected = 60

            calc_1 = student_total_mark * 100
            calc_2 = calc_1 / total_expected
            def grade_func(t_grade, score):
                match t_grade:
                    case 'Excellent':
                        return f'Status: {t_grade}, Score: {score}'
                    case 'Very good':
                        return f'Status: {t_grade}, Score: {score}'
                    case 'Good':
                        return f'Status: {t_grade}, Score: {score}'
                    case 'Pass':
                        return f'Status: {t_grade}, Score: {score}'
                    case 'Poor':
                        return f'Status: {t_grade}, Score: {score}'
                    case 'Fail':
                        return f'Status: {t_grade}, Score: {score}'
                    case _:
                        return f'Status: Absent, Score: {score}'
            status = {
                'A': 'Excellent',
                'B': 'Very good',
                'C': 'Good',
                'D': 'Pass',
                'E': 'Poor',
                'F': 'Fail',
            }
            if calc_2 >= 70 and calc_2 <= 100:
                grade = "A"
                g_status = grade_func(status[grade], calc_2)
            elif calc_2 >= 60 and calc_2 <= 69:
                grade = "B"
                g_status = grade_func(status[grade], calc_2)
            elif calc_2 >= 50 and calc_2 <= 59:
                grade = "C"
                g_status = grade_func(status[grade], calc_2)
            elif calc_2 >= 45 and calc_2 <= 49:
                grade = "D"
                g_status = grade_func(status[grade], calc_2)
            elif calc_2 >= 35 and calc_2 <= 44:
                grade = "E"
                g_status = grade_func(status[grade], calc_2)
            else:
                grade = "F"
                g_status = grade_func(status[grade], calc_2)
            return {'Grade': grade, 'Status': g_status}
        
        # student training result
        grade_and_status = train_calc()
        new_result = StudentResult(
            student=student_user, c_first_name=student_coord.first_name, c_middle_name=student_coord.middle_name, c_last_name=student_coord.last_name, c_id_no=student_coord.identification_num, c_email=student_coord.email, c_phone_number=student_coord.phone_number, s_first_name=student_supervisor.first_name, s_middle_name=student_supervisor.middle_name, s_last_name=student_supervisor.last_name, s_id_no=student_supervisor.identification_num, s_email=student_supervisor.email, s_phone_number=student_supervisor.phone_number, level=student_user.level, session=student_user.session, status=grade_and_status['Status'], grade=grade_and_status['Grade']
            )
        new_result.save()

        # incrementing student level by 100, if it is 200
        if student_user.level == 200:
            # finish 200 level training
            student_user.is_finish_200 = True
            student_user.level += 100
            student_user.save()

        # deactivating any `is_current_session` which is True to False
        prev_sess = Session.objects.filter(is_current_session=True)
        last_prev_sess = Session.objects.filter(is_current_session=True).last()
        for sess in prev_sess:
            sess.is_current_session = False
            sess.save()

        # if we find the query, we will use it for the following tricks
        if last_prev_sess:
            # grabing data from `last_prev_sess`
            a_sess = last_prev_sess.session
            b_sess = a_sess.split('/') # making it a list
            c_sess = int(b_sess[0])+1 # taking index 0 of the list and plus it with one
            d_sess = int(b_sess[1])+1 # taking index 1 of the list and plus it with one
            e_sess = '/'.join([str(c_sess), str(d_sess)]) # new session
            final_sess = e_sess
            # creating new session
            new_sess = Session(session=final_sess, is_current_session=True)
            new_sess.save()
        else:
            # if we don`t find the query we, will create new one
            new_sess = Session(is_current_session=True)
            new_sess.save()

        messages.success(
            request, f'You just released ({student_user}) result for {student_user.level})')
        return redirect(
            'department:student_result_page', matrix_no=matrix_no, level=student_user.level)
    

    # @coordinator_required
    @staticmethod
    def student_result(request, matrix_no, level):
        student = TrainingStudent.objects.filter(matrix_no=matrix_no).first()
        result = StudentResult.objects.filter(student=student, level=level).first()

        # checking result
        if not result:
            messages.success(
                request, f'The result is not out for ({student}) of {student.level})')
            return redirect(
                'student:logbook_entry', matrix_no=matrix_no, student_level=student.level)
        
        context = {
            'result': result,
            'student': student,
        }
        return render(request, 'student/student_result.html', context=context)
    

    @coordinator_required
    @staticmethod
    def new_letter(request):
        usr_tab = request.user
        usr = DepartmentTrainingCoordinator.objects.filter(
            coordinator=usr_tab).first()
            
        # current school session
        current_sch_sess = Session.objects.filter(is_current_session=True).last()
        # current faculty dean
        dept_hod = DepartmentHOD.objects.filter(
            department=usr.department, is_active=True).last()
        # active school vc
        active_vc = SchoolVC.objects.filter(is_active=True).last()
        
        if request.method == 'POST':
            # letter
            placement_lett = Letter(
                coordinator=usr, session=current_sch_sess.session, text='This is our students placement letter', dept_hod=dept_hod, vc=active_vc)
            acceptance_lett = Letter(
                coordinator=usr, session=current_sch_sess.session, text='This is our students acceptance letter', letter='acceptance letter', dept_hod=dept_hod, vc=active_vc)

            placement_lett.save()
            acceptance_lett.save()
            messages.success(
                request, f'Your release new acceptance and placement letter of your student for {current_sch_sess.session} session')
            return redirect(reverse(
                'department:training_coordinator_profile', kwargs={'id_no': usr.id_no}))
        context = {
            'usr': usr,
            'school_session': current_sch_sess.session,
        }
        return render(request, 'department/new_letter.html', context=context)
