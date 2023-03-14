from django.db import models
from django.utils import timezone
from phonenumber_field.modelfields import PhoneNumberField

from django.contrib.auth import get_user_model
User = get_user_model()


class TrainingUnitRequest(models.Model):
  """e.g siwes unit send request for list of student that will carry out training in that session"""
  training_category = [('siwes', 'Student industrial work experience (SIWES)'), ('tp', 'Teaching practice (TP)')]
  training = models.CharField(max_length=100, default='siwes', choices=training_category)
  title = models.CharField(max_length=300, blank=True, null=True)
  message = models.TextField(blank=True, null=True)
  timestamp = models.DateTimeField(default=timezone.now)
  # This  is_msg_added, we use it to mate our filter well organize, it didn't do anything else apart from that
  is_msg_added = models.BooleanField(default=False)
  # This is_new_message, we use it to see if the sender of a message, send another additional message, before he/she get reply from who he/she sent a message to
  is_new_message = models.BooleanField(default=False)
  # At this we filter to see if a user reply a message, before the user that sent him/her a message send another one again
  is_msg_replied = models.BooleanField(default=False)
  # This one it let us know if a message is seen
  # is_view = models.BooleanField(default=False)
  viewers = models.ManyToManyField(User, blank=True, related_name='coordinators_training')
  
  def __str__(self):
    return f'We request for student list that will carry out {self.training} to {self.training_receiver} on {self.timestamp} ({self.message})'

    
class TrainingDirector(models.Model):
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
  description = models.TextField(blank=True, null=True)

  def __str__(self):
    return f"Training director"
