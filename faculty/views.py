from django.shortcuts import render, redirect, reverse
from django.core.paginator import Paginator
from django.db.models import Q
from django.contrib.auth.decorators import login_required
from django.contrib.auth import get_user_model
from .models import (
    Faculty, FacultyDean)
from department.models import (
    Department, DepartmentHOD, DepartmentTrainingCoordinator, StudentSupervisor, Letter)
from administrator.models import (
    Administrator)
from student.models import (
    TrainingStudent, AcceptanceLetter, WeekReader, WeekScannedLogbook, CommentOnLogbook)
from toolkit.decorators import (
    admin_required, dean_required, hod_required, coordinator_required, supervisor_required, schoolstaff_required, student_required, check_phone_number, block_student_update_profile, restrict_access_student_profile, val_id_num)


User = get_user_model()


class FacultyCls:
    """Faculties related views"""

    @admin_required
    @staticmethod
    def profile(request, faculty_name):
        """faculty profile page"""

        # querying a faculty
        faculty = Faculty.objects.filter(name=faculty_name).first()

        # querying all faculties
        faculties = Faculty.objects.all()

        # querying all departments
        departments = Department.objects.filter(faculty=faculty).order_by('-date_joined')

        # querying all student that are currently in school using `TrainingStudent` models
        all_students = TrainingStudent.objects.filter(is_in_school=True).order_by('-date_joined')
        
        # querying all staff that are currently in school using `TrainingStudent` models
        all_staff = User.objects.filter(is_staff=True).order_by('-date_joined')

        # for student
        paginator_student = Paginator(all_students, 10)
        page_student = request.GET.get('page')
        students = paginator_student.get_page(page_student)

        # for staff
        paginator_staff = Paginator(all_staff, 10)
        page_staff = request.GET.get('page')
        staffs = paginator_staff.get_page(page_staff)

        # grab department filter
        if request.method == 'POST':
            dept_raw = request.POST['filter_dept']
            return redirect('administrator:department_students', dept_name=dept_raw)
            # return redirect(reverse('administrator:department_students', kwargs={'dept_name': dept_raw}))

        context = {
            'faculty': faculty,
            'faculties': faculties,
            'departments': departments,
            'students': students,
            'staffs': staffs,
        }
        return render(request, 'faculty/profile.html', context=context)
