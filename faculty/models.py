from django.db import models
from django.utils import timezone
from phonenumber_field.modelfields import PhoneNumberField

from django.contrib.auth import get_user_model
User = get_user_model()


class Faculty(models.Model):
  date_joined = models.DateTimeField(default=timezone.now)
  last_modified = models.DateTimeField(auto_now=True)
  training_category = [('siwes', 'Student industrial work experience (SIWES)'), ('tp', 'Teaching practice (TP)')]
  training = models.CharField(max_length=100, default='siwes', choices=training_category)
  name = models.CharField(max_length=300, blank=True, null=True)
  email = models.EmailField(max_length=255, unique=True)
  website = models.CharField(max_length=300, blank=True, null=True)
  phone_number = PhoneNumberField(max_length=100, unique=True)
  description = models.TextField(blank=True, null=True)
  
  def __str__(self):
    return f'Faculty of {self.name}'


class FacultyDean(models.Model):
  dean = models.ForeignKey(User, on_delete=models.CASCADE)
  faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE)
  first_name = models.CharField(max_length=100, unique=False)
  middle_name = models.CharField(max_length=100, unique=False, blank=True, null=True)
  last_name = models.CharField(max_length=100, unique=False)
  gender_choices = [('female', 'Female'), ('male', 'Male'),]
  gender = models.CharField(max_length=100, default='male', choices=gender_choices)
  date_of_birth = models.DateField(max_length=100, blank=True, null=True)
  id_no = models.CharField(max_length=255, unique=True)
  email = models.EmailField(max_length=255, unique=False)
  phone_number = PhoneNumberField(max_length=100, unique=False)
  date_joined = models.DateTimeField(default=timezone.now)
  date_leave = models.DateTimeField(auto_now=True)
  is_active = models.BooleanField(default=False)

  def __str__(self):
    return f'Dean faculty of {self.faculty}'
