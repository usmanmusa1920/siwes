from django.db import models
from django.utils import timezone
from phonenumber_field.modelfields import PhoneNumberField

from django.contrib.auth import get_user_model
User = get_user_model()


class TrainingDirector(models.Model):
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
  description = models.TextField(blank=True, null=True)

  def __str__(self):
    return f"Training director {self.first_name} {self.last_name} ({self.id_no})"
