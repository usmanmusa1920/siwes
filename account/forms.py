from django import forms
from django.contrib.auth.forms import PasswordChangeForm, UserCreationForm
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


class PasswordChangeForm(PasswordChangeForm):
    """password change form class"""
    class Meta:
        model = User


class AdministratorSignupForm(UserCreationForm):
    """administrator signup form class"""
    description = forms.CharField(required=True)  # it is not part of User model fields

    class Meta:
        model = User
        fields = ['first_name', 'middle_name', 'last_name', 'gender', 'date_of_birth', 'identification_num', 'email', 'phone_number', 'country', 'password1', 'password2', 'description']


class FacultySignupForm(forms.ModelForm):
    """faculty signup form class"""
    class Meta:
        model = Faculty
        fields = ['training', 'name', 'email', 'website', 'phone_number', 'description']


class FacultyDeanSignupForm(UserCreationForm):
    """faculty dean signup form class"""
    ranks = forms.CharField(required=False)  # it is not part of User model fields
    level_rank_title_1 = forms.CharField(required=False)  # it is not part of User model fields
    level_rank_title_2 = forms.CharField(required=False)  # it is not part of User model fields

    class Meta:
        model = User
        fields = ['first_name', 'middle_name', 'last_name', 'gender', 'date_of_birth', 'identification_num', 'email', 'phone_number', 'country', 'password1', 'password2', 'ranks', 'level_rank_title_1', 'level_rank_title_2']


class DepartmentSignupForm(forms.ModelForm):
    """department signup form class"""
    class Meta:
        model = Department
        # note we didn`t include `faculty` in the field below
        # because we want to assign it in the view
        fields = ['name', 'email', 'website', 'phone_number', 'description']


class DepartmentHODSignupForm(UserCreationForm):
    """department H O D signup form class"""
    ranks = forms.CharField(required=False)  # it is not part of User model fields
    level_rank_title_1 = forms.CharField(required=False)  # it is not part of User model fields
    level_rank_title_2 = forms.CharField(required=False)  # it is not part of User model fields

    class Meta:
        model = User
        fields = ['first_name', 'middle_name', 'last_name', 'gender', 'date_of_birth', 'identification_num', 'email', 'phone_number', 'country', 'password1', 'password2', 'ranks', 'level_rank_title_1', 'level_rank_title_2']


class DepartmentCoordinatorSignupForm(UserCreationForm):
    """student training coordinator signup form class"""
    class Meta:
        model = User
        fields = ['first_name', 'middle_name', 'last_name', 'gender', 'date_of_birth', 'identification_num', 'email', 'phone_number', 'country', 'password1', 'password2']


class StudentSupervisorSignupForm(UserCreationForm):
    """student supervisor signup form class"""
    small_desc = forms.CharField(required=True)  # it is not part of User model fields

    class Meta:
        model = User
        fields = ['first_name', 'middle_name', 'last_name', 'gender', 'date_of_birth', 'identification_num', 'email', 'phone_number', 'country', 'password1', 'password2', 'small_desc']


class StudentSignupForm(UserCreationForm):
    """student signup form class"""
    class Meta:
        model = User
        fields = ['identification_num']


class UpdateStudentProfile(forms.ModelForm):
    """update student profile form class"""
    class Meta:
        model = User
        fields = ['first_name', 'middle_name', 'last_name', 'gender', 'date_of_birth', 'email', 'phone_number', 'country']
        # by using the below widgets dictionary, it will make our gender field to appear in radio field instead of choices field if we just put {{form.gender}} in our html template file, but i didn`t use it because it appear in vertical, and me i want it in horizontal, that is why i just write them (radio input tag) manually on the template file of student update page
        widgets = {
            'gender': forms.RadioSelect(),
        }
