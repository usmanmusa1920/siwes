from datetime import datetime
from django.db import models
from django.utils import timezone
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from phonenumber_field.modelfields import PhoneNumberField
from django_countries.fields import CountryField
from django.conf import settings


User = settings.AUTH_USER_MODEL


class UserAccountManager(BaseUserManager):
  def create_user(self, first_name, last_name, identification_num, email, password=None):
    if not first_name:
      raise ValueError('Your first name is required')
    if not last_name:
      raise ValueError('Your last name is required')
    if not identification_num:
      raise ValueError('Your identification_num is required')
    if not email:
      raise ValueError('You must provide your email address')
    if not password:
      raise ValueError('You must include password')
    
    user = self.model(
      first_name = first_name,
      last_name = last_name,
      identification_num = identification_num,
      email = self.normalize_email(email),
    )
    
    user.set_password(password)
    user.save(using=self._db)
    return user
    
  def account_verified(self, first_name, last_name, identification_num, email, password):
    user = self.create_user(
      first_name = first_name,
      last_name = last_name,
      identification_num = identification_num,
      email = self.normalize_email(email),
      password = password,
    )
    
    user.save(using=self._db)
    return user
    
  def create_staffuser(self, first_name, last_name, identification_num, email, password):
    user = self.create_user(
      first_name = first_name,
      last_name = last_name,
      identification_num = identification_num,
      email = self.normalize_email(email),
      password = password,
    )
    
    user.is_staff = True
    user.save(using=self._db)
    return user
    
  def create_adminuser(self, first_name, last_name, identification_num, email, password=None):
    user = self.create_user(
      first_name = first_name,
      last_name = last_name,
      identification_num = identification_num,
      email = self.normalize_email(email),
      password = password,
    )
    
    user.is_staff = True
    user.is_admin = True
    user.save(using=self._db)
    return user
    
  def create_superuser(self, first_name, last_name, identification_num, email, password=None):
    user = self.create_user(
      first_name = first_name,
      last_name = last_name,
      identification_num = identification_num,
      email = self.normalize_email(email),
      password = password,
    )
    
    user.is_staff = True
    user.is_admin = True
    user.is_superuser = True
    user.save(using=self._db)
    return user
    

class UserAccount(AbstractBaseUser):
  first_name = models.CharField(max_length=100, unique=False)
  middle_name = models.CharField(max_length=100, unique=False, blank=True, null=True)
  last_name = models.CharField(max_length=100, unique=False)
  gender_choices = [('female', 'Female'), ('male', 'Male'),]
  gender = models.CharField(max_length=100, default='male', choices=gender_choices)
  date_of_birth = models.DateField(max_length=100, blank=True, null=True)
  identification_num = models.CharField(max_length=255, unique=True)
  email = models.EmailField(max_length=255, unique=False)
  phone_number = PhoneNumberField(max_length=100, unique=False)
  country = CountryField(max_length=100, blank_label='Select your country',)
  date_joined = models.DateTimeField(default=timezone.now)
  
  # permissions
  is_active = models.BooleanField(default=True)
  is_staff = models.BooleanField(default=False)
  is_admin = models.BooleanField(default=False)
  is_superuser = models.BooleanField(default=False)

  # ranks
  is_faculty_dean = models.BooleanField(default=False)
  is_dept_hod = models.BooleanField(default=False)
  is_training_coordinator = models.BooleanField(default=False)
  is_supervisor = models.BooleanField(default=False)
  is_student = models.BooleanField(default=False)
  
  objects = UserAccountManager()
  
  USERNAME_FIELD = 'identification_num'
  REQUIRED_FIELDS = ['first_name', 'last_name', 'email']
  
  def __str__(self):
    return self.identification_num
    
  def has_perm(self, perm, obj=None):
    return True
    
  def has_module_perms(self, app_label):
    return True
    

"""
  Whenever you use blank=True and null=True in a models.py field, make sure you replace it with required=False in forms.py field or in html file.
"""

class Profile(models.Model):
  user = models.OneToOneField(User, on_delete=models.CASCADE)
  session = models.CharField(max_length=255, default=datetime.today().year)
  image = models.ImageField(default='default_pic.png', upload_to=f'users_profile_pics')
  
  def __str__(self):
    return f'{self.user.identification_num}\'s profile'
