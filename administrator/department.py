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
    Session, Faculty, Department, FacultyDean, DepartmentHOD, TrainingStudent, StudentSupervisor, DepartmentTrainingCoordinator, Letter, AcceptanceLetter, WeekReader, WeekScannedLogbook, CommentOnLogbook, StudentResult
)


User = get_user_model()


class DepartmentCls:
    """department related views"""

    @admin_required
    @staticmethod
    def students(request, dept_name):
        """department list of students"""
        depart = Department.objects.filter(name=dept_name).first()
        all_students = TrainingStudent.objects.filter(department=depart).order_by('-date_joined')

        # for student
        paginator_student = Paginator(all_students, 10)
        page_student = request.GET.get('page')
        students = paginator_student.get_page(page_student)

        context = {
            'depart': depart,
            'students': students,
        }
        return render(request, 'administrator/students_list.html', context=context)

    @admin_required
    @staticmethod
    def students_level(request, level):
        """department list of students base on level"""
        depart_coord = DepartmentTrainingCoordinator.objects.filter(coordinator=request.user).first()
        all_students = TrainingStudent.objects.filter(student_training_coordinator=depart_coord, level=level).order_by('-date_joined')

        # for student
        paginator_student = Paginator(all_students, 10)
        page_student = request.GET.get('page')
        students = paginator_student.get_page(page_student)

        context = {
            'level': level,
            'students': students,
        }
        return render(request, 'administrator/students_level.html', context=context)
