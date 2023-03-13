from django.db import models
from django.utils import timezone
from department.models import DepartmentTrainingCoordinator


from django.contrib.auth import get_user_model
User = get_user_model()


class StudentLetterRequest(models.Model):
  """if he didn't see training letter, he/she should make request"""
  sender_req = models.ForeignKey(User, related_name='sender_req', on_delete=models.CASCADE)
  receiver_req = models.ForeignKey(User, related_name='receiver_req', on_delete=models.CASCADE)
  timestamp = models.DateTimeField(default=timezone.now)

  def __str__(self):
    return f'{self.sender} send request for training letter'


class AcceptanceLetter(models.Model):
  sender_acept = models.ForeignKey(User, related_name='sender_acept', on_delete=models.CASCADE)
  receiver_acept = models.ForeignKey(User, related_name='receiver_acept', on_delete=models.CASCADE)
  timestamp = models.DateTimeField(default=timezone.now)
  title = models.CharField(max_length=255, blank=True, null=True)
  image = models.ImageField(blank=True, null=True, upload_to='acceptance_letter')
  text = models.TextField(blank=True, null=True,)
  is_reviewed = models.BooleanField(default=False)
  
  def __str__(self):
    return f"Student acceptance letter (approved)"
