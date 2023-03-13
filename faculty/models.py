from django.db import models
from django.utils import timezone
from training.models import TrainingUnitRequest
from phonenumber_field.modelfields import PhoneNumberField


class Faculty(models.Model):
  # "Faculty of Science": 
  # "Faculty of Humanities": 
  # "Faculty of Education": 
  # "Faculty of Management & Social science":
  date_joined = models.DateTimeField(default=timezone.now)
  last_modified = models.DateTimeField(auto_now=True)
  faculty_training = models.ForeignKey(TrainingUnitRequest, related_name='faculty_training', on_delete=models.CASCADE)
  name = models.CharField(max_length=300, blank=True, null=True)
  email = models.EmailField(max_length=255, unique=False)
  website = models.CharField(max_length=300, blank=True, null=True)
  phone_number = PhoneNumberField(max_length=100, unique=True)
  description = models.TextField(blank=True, null=True)
  
  def __str__(self):
    return f"Faculty of {self.name}"


class FacultyDean(models.Model):
  faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE)
  first_name = models.CharField(max_length=100, unique=False)
  middle_name = models.CharField(max_length=100, unique=False, blank=True, null=True)
  last_name = models.CharField(max_length=100, unique=False)
  gender_choices = [('female', 'Female'), ('male', 'Male'),]
  gender = models.CharField(max_length=100, default='male', choices=gender_choices)
  date_of_birth = models.DateField(max_length=100, blank=True, null=True)
  id_no = models.CharField(max_length=255, unique=True)
  email = models.EmailField(max_length=255, unique=False)
  phone_number = PhoneNumberField(max_length=100, unique=True)
  date_joined = models.DateTimeField(default=timezone.now)
  date_leave = models.DateTimeField(auto_now=True)

  def __str__(self):
    return f"Faculty dean"
