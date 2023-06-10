from django import forms
from django.contrib.auth.forms import UserCreationForm
from department.models import DepartmentTrainingCoordinator

from django.contrib.auth import get_user_model
User = get_user_model()


class CoordinatorSignupForm(UserCreationForm):
  class Meta:
    model = User
    fields = ['first_name', 'middle_name', 'last_name', 'gender', 'date_of_birth', 'identification_num', 'email', 'phone_number', 'country', 'password1', 'password2']
