from django.urls import reverse
from django.shortcuts import render, redirect, HttpResponseRedirect
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.contrib.auth.views import LoginView, LogoutView
from django.contrib.sites.shortcuts import get_current_site
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth import update_session_auth_hash
from django.contrib.auth import get_user_model
from .forms import (
    PasswordChangeForm, AdministratorSignupForm, FacultySignupForm, FacultyDeanSignupForm, DepartmentSignupForm, DepartmentHODSignupForm, DepartmentCoordinatorSignupForm, StudentSupervisorSignupForm, StudentSignupForm, UpdateStudentProfile)
from administrator.models import (
    Administrator)
from faculty.models import (
    Faculty, FacultyDean)
from department.models import (
    Department, DepartmentHOD, DepartmentTrainingCoordinator, StudentSupervisor, Letter)
from student.models import (
    TrainingStudent, AcceptanceLetter, WeekReader, WeekScannedLogbook, CommentOnLogbook)
from toolkit.decorators import (
    admin_required, dean_required, hod_required, coordinator_required, supervisor_required, schoolstaff_required, student_required, check_phone_number, block_student_update_profile, restrict_access_student_profile, val_id_num)


User = get_user_model()


@login_required
def generalProfile(request, id_no):
    """general profile"""

    # querying user using identification number
    user = User.objects.filter(identification_num=id_no).first()
    
    if user.is_admin:
        uuu = Administrator.objects.filter(id_no=id_no).first()
    if user.is_dean:
        uuu = FacultyDean.objects.filter(id_no=id_no).first()
    if user.is_hod:
        uuu = DepartmentHOD.objects.filter(id_no=id_no).first()
    if user.is_coordinator:
        uuu = DepartmentTrainingCoordinator.objects.filter(id_no=id_no).first()
    if user.is_supervisor:
        uuu = StudentSupervisor.objects.filter(id_no=id_no).first()
    if user.is_student:
        uuu = TrainingStudent.objects.filter(matrix_no=id_no).first()

    context = {
        'uuu': uuu,
        'user': user,
    }
    return render(request, 'auth/general_profile.html', context=context)
