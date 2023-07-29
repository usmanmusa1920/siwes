from django import forms
from django.contrib.auth.forms import PasswordChangeForm, UserCreationForm
from django.contrib.auth import get_user_model
from account.models import Profile
# from administrator.all_models import(
#     Faculty, Department
# )
from administrator.tables import (
    Session, Faculty, Department, Vc, Hod, Coordinator, Supervisor, Student, Letter, Acceptance, WeekReader, WeekEntry, WeekEntryImage, Result
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


class DepartmentSignupForm(forms.ModelForm):
    """department signup form class"""
    class Meta:
        model = Department
        # note we didn`t include `faculty` in the field below
        # because we want to assign it in the view
        fields = ['name', 'email', 'website', 'phone_number', 'description']


class VcDeanHodSignupForm(UserCreationForm):
    """VC, dean, and HOD signup form class"""
    ranks = forms.CharField(required=False)  # it is not part of User model fields
    level_rank_title_1 = forms.CharField(required=False)  # it is not part of User model fields
    level_rank_title_2 = forms.CharField(required=False)  # it is not part of User model fields

    class Meta:
        model = User
        fields = ['first_name', 'middle_name', 'last_name', 'gender', 'date_of_birth', 'identification_num', 'email', 'phone_number', 'country', 'password1', 'password2', 'ranks', 'level_rank_title_1', 'level_rank_title_2']


class CoordinatorSignupForm(UserCreationForm):
    """student training coordinator signup form class"""
    class Meta:
        model = User
        fields = ['first_name', 'middle_name', 'last_name', 'gender', 'date_of_birth', 'identification_num', 'email', 'phone_number', 'country', 'password1', 'password2']


class SupervisorSignupForm(UserCreationForm):
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


class UpdateProfileImage(forms.ModelForm):
    """update profile image form class"""
    class Meta:
        model = Profile
        fields = ['image']
