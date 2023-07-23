from django.db import models
from django.utils import timezone
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager
from django_countries.fields import CountryField
from django.conf import settings
from toolkit import y_session


User = settings.AUTH_USER_MODEL


class UserAccountManager(BaseUserManager):
    def create_user(self, first_name, last_name, identification_num, email, password=None, **kwargs):
        """
        we provide `**kwargs` to accept other keyword argument, even though it is not in this way in the django default create_user method of user class
        """
        if not first_name:
            raise ValueError('User first name is required')
        if not last_name:
            raise ValueError('User last name is required')
        if not identification_num:
            raise ValueError('User identification number is required')
        if not email:
            raise ValueError('User email address is required')

        user = self.model(
            first_name=first_name,
            last_name=last_name,
            identification_num=identification_num,
            email=self.normalize_email(email),
            **kwargs
        )

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, first_name, last_name, identification_num, email, password=None, **kwargs):
        """
        we provide `**kwargs` to accept other keyword argument, even though it is not in this way in the django default create_superuser method of user class
        """
        user = self.create_user(
            first_name=first_name,
            last_name=last_name,
            identification_num=identification_num,
            email=self.normalize_email(email),
            password=password,
            **kwargs
        )

        user.is_staff = True
        user.is_superuser = True
        user.save(using=self._db)
        return user


class UserAccount(AbstractBaseUser):
    first_name = models.CharField(max_length=100, unique=False)
    middle_name = models.CharField(
        max_length=100, unique=False, blank=True, null=True)
    last_name = models.CharField(max_length=100, unique=False)
    gender_choices = [('female', 'Female'), ('male', 'Male'),]
    gender = models.CharField(
        max_length=100, default='male', choices=gender_choices)
    date_of_birth = models.DateField(max_length=100, blank=True, null=True)
    identification_num = models.CharField(max_length=255, unique=True)
    email = models.EmailField(max_length=255, unique=False)
    phone_number = models.CharField(max_length=100, unique=False)
    country = CountryField(max_length=100, blank_label='Select your country',)
    date_joined = models.DateTimeField(auto_now_add=True) # date_joined (not editable)
    last_modified = models.DateTimeField(auto_now=True) # last modified (not editable)

    """
    `date_joined` above is not editable, also
    `last_modified` above is not editable too! but,

    the default `last_login` for users is editable, like wise
    the `pub_date` below is editable

    pub_date = models.DateTimeField(default=timezone.now) # (editable)
    """

    # Default django permissions (is_active, is_staff, is_superuser)
    is_active = models.BooleanField(default=True)
    # Designates whether this user account should be considered active.
    # We recommend that you set this flag to False instead of deleting accounts;
    # that way, if your applications have any foreign keys to users, the foreign keys won`t break.

    is_staff = models.BooleanField(default=False)
    # Designates whether the user can log into this admin site.

    is_superuser = models.BooleanField(default=False)
    # Designates that this user has all permissions without explicitly assigning them.

    # Our custom permissions (ranks)
    is_admin = models.BooleanField(default=False)  # administrator
    is_vc = models.BooleanField(default=False)  # vice cancellor
    is_dean = models.BooleanField(default=False)  # faculty dean
    is_hod = models.BooleanField(default=False)  # department HOD
    is_coordinator = models.BooleanField(default=False)  # department training coordinator
    is_supervisor = models.BooleanField(default=False)  # student supervisor
    is_schoolstaff = models.BooleanField(default=False)  # school staff
    is_student = models.BooleanField(default=False)  # training student

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
    session = models.CharField(max_length=255, default=y_session())
    image = models.ImageField(
        default='default_pic.png', upload_to=f'users_profile_pics')

    def __str__(self):
        return f'{self.user.identification_num}\'s profile'
