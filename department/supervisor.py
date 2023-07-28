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


def supervisor_student(request):
    """this view query supervisor`s student assign to him"""
    supervisor = StudentSupervisor.objects.filter(supervisor=request.user).first()

    # paginator = Paginator(supervisor.training_students, 10)  # paginating by 10
    # page = request.GET.get('page')
    # student_list = paginator.get_page(page)

    context = {
        'supervisor': supervisor,
        # 'student_list': student_list,
    }
    return render(request, 'department/supervisor_student.html', context=context)


@supervisor_required
def submit_student_logbook(request, matrix_no):
    """this is view that create student result"""
    student_user = TrainingStudent.objects.filter(matrix_no=matrix_no).first()
    student_coord = student_user.student_training_coordinator
    if student_coord.is_active == False:
        return False
    student_supervisor = student_user.student_training_coordinator

    is_result = StudentResult.objects.filter(
        student=student_user, level=student_user.level).first()
    # checking result
    if is_result:
        messages.warning(
            request, f'You already released out this student ({student_user.first_name}) result of {student_user.level} level')
        return redirect('department:supervisor_student')
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

        # calculating percentage
        calc_1 = student_total_mark * 100
        calc_2 = calc_1 / total_expected

        def grade_func(t_grade, score):
            match t_grade:
                # A `match` statement takes an expression and compares it to successive patterns given as one or more `case` blocks. This is superficially similar to a `switch` statement in C, Java or JavaScript (and many other languages), but much more powerful.
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
                # Note the last block: the "variable name" `_` acts as a *wildcard* and never fails to match. You can combine several literals in a single pattern using `|` ("or"):

                # case 'Excellent'|'Very good'|'Good'|:
                #   return f'Status: Good, Score: 53.0'

        status = {
            'A': 'Excellent',
            'B': 'Very good',
            'C': 'Good',
            'D': 'Pass',
            'E': 'Poor',
            'F': 'Fail',
        }

        # checking percentage
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

    # once coordinator submit student logbook, that student will be remove from the list of that supervisor student `training_students`, so that in the next session he will be assign with different student
    StudentSupervisor.objects.filter(
        supervisor=request.user).first().training_students.remove(student_user)

    # incrementing student level by 100, if he is 200 level
    if student_user.level == 200:
        # finish 200 level training
        student_user.is_finish_200 = True
        student_user.level += 100
        student_user.save()

    messages.success(
        request, f'You just released ({student_user}) result for {student_user.level})')
    return redirect('department:supervisor_student')

