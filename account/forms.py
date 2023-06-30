from django import forms
from django.contrib.auth.forms import PasswordChangeForm, UserCreationForm
from faculty.models import Faculty
from department.models import Department, DepartmentTrainingCoordinator, StudentSupervisor
from student.models import TrainingStudent
from django.contrib.auth import get_user_model


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
    ranks = forms.CharField(required=True)  # it is not part of User model fields

    class Meta:
        model = User
        fields = ['first_name', 'middle_name', 'last_name', 'gender', 'date_of_birth', 'identification_num', 'email', 'phone_number', 'country', 'password1', 'password2', 'ranks']


class DepartmentSignupForm(forms.ModelForm):
    """department signup form class"""
    class Meta:
        model = Department
        fields = ['faculty', 'name', 'email', 'website', 'phone_number', 'description']


class DepartmentHODSignupForm(UserCreationForm):
    """department H O D signup form class"""
    ranks = forms.CharField(required=True)  # it is not part of User model fields

    class Meta:
        model = User
        fields = ['first_name', 'middle_name', 'last_name', 'gender', 'date_of_birth', 'identification_num', 'email', 'phone_number', 'country', 'password1', 'password2', 'ranks']


class DepartmentCoordinatorSignupForm(UserCreationForm):
    """student training coordinator signup form class"""
    class Meta:
        model = User
        fields = ['first_name', 'middle_name', 'last_name', 'gender', 'date_of_birth', 'identification_num', 'email', 'phone_number', 'country', 'password1', 'password2']


class StudentSupervisorSignupForm(UserCreationForm):
    """student supervisor signup form class"""
    class Meta:
        model = User
        fields = ['first_name', 'middle_name', 'last_name', 'gender', 'date_of_birth', 'identification_num', 'email', 'phone_number', 'country', 'password1', 'password2']


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
