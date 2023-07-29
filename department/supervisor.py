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
# from administrator.all_models import(
#     Session, Faculty, Department, SchoolVC, FacultyDean, DepartmentHOD, TrainingStudent, StudentSupervisor, DepartmentTrainingCoordinator, Letter, AcceptanceLetter, WeekReader, WeekScannedLogbook, CommentOnLogbook, StudentResult
# )
from administrator.tables import (
    Session, Faculty, Department, Vc, Hod, Coordinator, Supervisor, Student, Letter, Acceptance, WeekReader, WeekEntry, WeekEntryImage, Result
)


User = get_user_model()


def supervisor_student(request):
    """this view query supervisor`s student assign to him"""
    supervisor = Supervisor.objects.filter(supervisor=request.user).first()

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

    student = Student.objects.filter(matrix_no=matrix_no).first()
    coordinator = Coordinator.objects.filter(coordinator=student.student_coordinator).first()
    supervisor = request.user
    acceptance = Acceptance.objects.filter(
        sender=student, receiver=coordinator, level=str(student.level)).last()

    is_result = Result.objects.filter(
        student=student, level=student.level, acceptance=acceptance).first()
    # checking result
    if is_result:
        messages.warning(
            request, f'You already released out this student ({student.first_name}) result of {student.level} level')
        return redirect('department:supervisor_student')
    def train_calc():
        if student.level == 200:
            WKSL = WeekEntry.objects.filter(
                student=student, session=student.session_200)
        else:
            WKSL = WeekEntry.objects.filter(
                student=student, session=student.session_300)
        total_comment_score = 0
        for scanned in WKSL:
            # comment_grade = WeekEntry.objects.filter(logbook=scanned).first()
            total_comment_score += int(scanned.grade)
        
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
    if student.level == 200 or student.level == '200':
        new_result = Result(
            student=student, acceptance=acceptance, c_first_name=coordinator.first_name, c_middle_name=coordinator.middle_name, c_last_name=coordinator.last_name, c_id_no=coordinator.id_no, c_email=coordinator.email, c_phone_number=coordinator.phone_number, s_first_name=supervisor.first_name, s_middle_name=supervisor.middle_name, s_last_name=supervisor.last_name, s_id_no=supervisor.identification_num, s_email=supervisor.email, s_phone_number=supervisor.phone_number, level=student.level, session=student.session_200, status=grade_and_status['Status'], grade=grade_and_status['Grade']
            )
    else:
        new_result = Result(
            student=student, acceptance=acceptance, c_first_name=coordinator.first_name, c_middle_name=coordinator.middle_name, c_last_name=coordinator.last_name, c_id_no=coordinator.id_no, c_email=coordinator.email, c_phone_number=coordinator.phone_number, s_first_name=supervisor.first_name, s_middle_name=supervisor.middle_name, s_last_name=supervisor.last_name, s_id_no=supervisor.identification_num, s_email=supervisor.email, s_phone_number=supervisor.phone_number, level=student.level, session=student.session_300, status=grade_and_status['Status'], grade=grade_and_status['Grade']
            )
    new_result.save()

    # once coordinator submit student logbook, that student will be remove from the list of that supervisor student `training_students`, so that in the next session he will be assign with different student
    Supervisor.objects.filter(
        supervisor=request.user).first().students.remove(student)

    messages.success(
        request, f'You just released ({student}) result for {student.level})')
    return redirect('department:supervisor_student')

