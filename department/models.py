from django.db import models
from django.utils import timezone
from faculty.models import Faculty
from phonenumber_field.modelfields import PhoneNumberField

from django.contrib.auth import get_user_model
User = get_user_model()


class Department(models.Model):
  """This is department database table"""
  faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE)
  date_joined = models.DateTimeField(default=timezone.now)
  last_modified = models.DateTimeField(auto_now=True)
  name = models.CharField(max_length=300, blank=True, null=True)
  email = models.EmailField(max_length=255, unique=True)
  website = models.CharField(max_length=300, blank=True, null=True)
  phone_number = PhoneNumberField(max_length=100, unique=True)
  description = models.TextField(blank=True, null=True)
  
  def __str__(self):
    return f"Department of {self.name}"


class DepartmentHOD(models.Model):
  """This is departmental h.o.d database table"""
  department = models.ForeignKey(Department, on_delete=models.CASCADE)
  first_name = models.CharField(max_length=100, unique=False)
  middle_name = models.CharField(max_length=100, unique=False, blank=True, null=True)
  last_name = models.CharField(max_length=100, unique=False)
  gender_choices = [('female', 'Female'), ('male', 'Male'),]
  gender = models.CharField(max_length=100, default='male', choices=gender_choices)
  date_of_birth = models.DateField(max_length=100, blank=True, null=True)
  id_no = models.CharField(max_length=255, unique=True)
  email = models.EmailField(max_length=255, unique=True)
  phone_number = PhoneNumberField(max_length=100, unique=True)
  date_joined = models.DateTimeField(default=timezone.now)
  date_leave = models.DateTimeField(auto_now=True)
  is_active = models.BooleanField(default=False)

  def __str__(self):
    return f"H.O.D of {self.department} department"


class DepartmentTrainingCoordinator(models.Model):
  """This is departmental training (siwes/tp) coordinator database table"""
  dept_hod = models.ForeignKey(DepartmentHOD, on_delete=models.CASCADE)
  first_name = models.CharField(max_length=100, unique=False)
  middle_name = models.CharField(max_length=100, unique=False, blank=True, null=True)
  last_name = models.CharField(max_length=100, unique=False)
  gender_choices = [('female', 'Female'), ('male', 'Male'),]
  gender = models.CharField(max_length=100, default='male', choices=gender_choices)
  date_of_birth = models.DateField(max_length=100, blank=True, null=True)
  id_no = models.CharField(max_length=255, unique=True)
  email = models.EmailField(max_length=255, unique=True)
  phone_number = PhoneNumberField(max_length=100, unique=True)
  date_joined = models.DateTimeField(default=timezone.now)
  date_leave = models.DateTimeField(auto_now=True)
  is_active = models.BooleanField(default=False)
  training_students = models.ManyToManyField(User, blank=True, related_name='training_students')

  def __str__(self):
    return f"{self.dept_hod.department} {self.dept_hod.department.faculty.training} coordinator"


class Letter(models.Model):
  """This is departmental training (siwes/tp) letter database table"""
  coordinator = models.ForeignKey(DepartmentTrainingCoordinator, on_delete=models.CASCADE)
  release_date = models.DateTimeField(default=timezone.now)
  last_modified = models.DateTimeField(auto_now=True)
  letter_type = [('placement letter', 'Placement letter'), ('acceptance letter', 'Acceptance letter'),]
  letter = models.CharField(max_length=100, default='placement letter', choices=letter_type)
  text = models.TextField(blank=True, null=True)
  viewers = models.ManyToManyField(User, blank=True, related_name='viewers')
  session = models.CharField(max_length=255, blank=False, null=False)
  
  def __str__(self):
    return f"Letter of ({self.letter})"
