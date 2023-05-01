from django import forms
from django.contrib.auth.forms import PasswordChangeForm, UserCreationForm

from django.contrib.auth import get_user_model
User = get_user_model()


class PasswordChangeForm(PasswordChangeForm):
  class Meta:
    model = User
    

class SignupForm(UserCreationForm):
  student_level = forms.CharField(required=True) # it is not part of User model fields
  class Meta:
    model = User
    fields = ["first_name", "middle_name", "last_name", "gender", "date_of_birth", "identification_num", "email", "phone_number", "country", "password1", "password2", "student_level"]
