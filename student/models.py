from django.db import models
from django.utils import timezone
from phonenumber_field.modelfields import PhoneNumberField
from department.models import DepartmentTrainingCoordinator


from django.contrib.auth import get_user_model
User = get_user_model()


class TrainingStudent(models.Model):
  student = models.ForeignKey(User, on_delete=models.CASCADE)
  student_training_coordinator = models.ForeignKey(DepartmentTrainingCoordinator, on_delete=models.CASCADE)
  first_name = models.CharField(max_length=100, unique=False)
  middle_name = models.CharField(max_length=100, unique=False, blank=True, null=True)
  last_name = models.CharField(max_length=100, unique=False)
  gender_choices = [('female', 'Female'), ('male', 'Male'),]
  gender = models.CharField(max_length=100, default='male', choices=gender_choices)
  date_of_birth = models.DateField(max_length=100, blank=True, null=True)
  matrix_no = models.CharField(max_length=255, unique=True)
  email = models.EmailField(max_length=255, unique=True)
  phone_number = PhoneNumberField(max_length=100, unique=True)
  date_joined = models.DateTimeField(default=timezone.now)
  date_leave = models.DateTimeField(auto_now=True)
  is_in_school = models.BooleanField(default=False)

  def __str__(self):
    return f"Training student with matrix number of {self.matrix_no}"


class StudentLetterRequest(models.Model):
  """if he didn't see training letter, he/she should make request"""
  sender_req = models.ForeignKey(TrainingStudent, related_name='sender_req', on_delete=models.CASCADE)
  receiver_req = models.ForeignKey(DepartmentTrainingCoordinator, related_name='receiver_req', on_delete=models.CASCADE)
  timestamp = models.DateTimeField(default=timezone.now)
  in_seen = models.BooleanField(default=False)

  def __str__(self):
    return f'{self.sender_req} sent letter request for training'


class AcceptanceLetter(models.Model):
  sender_acept = models.ForeignKey(TrainingStudent, related_name='sender_acept', on_delete=models.CASCADE)
  receiver_acept = models.ForeignKey(DepartmentTrainingCoordinator, related_name='receiver_acept', on_delete=models.CASCADE)
  timestamp = models.DateTimeField(default=timezone.now)
  title = models.CharField(max_length=255, blank=True, null=True)
  image = models.ImageField(blank=True, null=True, upload_to='acceptance_letter')
  text = models.TextField(blank=True, null=True,)
  is_reviewed = models.BooleanField(default=False)
  
  def __str__(self):
    return f"Student ({self.sender_acept.matrix_no}) acceptance letter (approved)"
