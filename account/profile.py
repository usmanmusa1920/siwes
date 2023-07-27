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
    PasswordChangeForm, AdministratorSignupForm, FacultySignupForm, VcDeanHodSignupForm, DepartmentSignupForm, DepartmentCoordinatorSignupForm, StudentSupervisorSignupForm, StudentSignupForm, UpdateStudentProfile)
from toolkit import (picture_name, y_session)
from toolkit.decorators import (
    block_student_update_profile, restrict_access_student_profile, val_id_num, check_phone_number, admin_required, dean_required, hod_required, coordinator_required, supervisor_required, schoolstaff_required, student_required, supervisor_or_student_required, coordinator_or_supervisor_or_student_required
)
from administrator.models import Administrator
from administrator.all_models import(
    Session, Faculty, Department, SchoolVC, FacultyDean, DepartmentHOD, TrainingStudent, StudentSupervisor, DepartmentTrainingCoordinator, Letter, AcceptanceLetter, WeekReader, WeekScannedLogbook, CommentOnLogbook, StudentResult
)


User = get_user_model()


@login_required
def generalProfile(request, id_no):
    """general profile for any user"""

    # querying user using identification number
    user = User.objects.filter(identification_num=id_no).first()
    
    if user.is_admin:
        uuu = Administrator.objects.filter(id_no=id_no).first()
    if user.is_vc:
        uuu = SchoolVC.objects.filter(id_no=id_no).first()
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
