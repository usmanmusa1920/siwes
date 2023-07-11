from django.db import models
from django.utils import timezone
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
    level_choices = [('200', '200 level'), ('300', '300 level'),]
    level = models.CharField(max_length=100, default='200', choices=level_choices)
    email = models.EmailField(max_length=255, unique=False)
    phone_number = models.CharField(max_length=100, unique=False)
    date_joined = models.DateTimeField(auto_now_add=True) # date_joined (not editable)
    last_modified = models.DateTimeField(auto_now=True) # last modified (not editable)
    is_in_school = models.BooleanField(default=False)

    def __str__(self):
        return f'Training student with matrix number of {self.matrix_no}'


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
    level = models.CharField(max_length=255, blank=False, null=False)
    # avoid updating student acceptance letter on admin page (because of the image file route won`t save correctly`)
    image = models.ImageField(blank=True, null=True,upload_to=f'acceptance-letters')
    text = models.TextField(blank=True, null=True,)
    is_reviewed = models.BooleanField(default=False)
    can_change = models.BooleanField(default=False)

    def __str__(self):
        return f'Student ({self.sender_acept.matrix_no}) acceptance letter (approved)'


class WeekReader(models.Model):
    student = models.ForeignKey(TrainingStudent, related_name='student_week_reader', on_delete=models.CASCADE)
    week_no = models.IntegerField(default=0)  # later max_length will be set

    def __str__(self):
        return f'Week {self.week_no} of student training out of 12 weeks'


class WeekScannedLogbook(models.Model):
    week = models.ForeignKey(WeekReader, related_name='week_reader', on_delete=models.CASCADE)
    student_lg = models.ForeignKey(TrainingStudent, related_name='student_lg', on_delete=models.CASCADE)
    timestamp = models.DateTimeField(default=timezone.now)
    title = models.CharField(max_length=255, blank=True, null=True)
    week_no = models.IntegerField(blank=True, null=True)
    # avoid updating student scanned logbook on admin page (because of the image file route won`t save correctly`)
    image = models.ImageField(blank=True, null=True, upload_to=f'weekly-scanned-logbook')
    text = models.TextField(blank=True, null=True,)  # references
    level_choices = [('200', '200 level'), ('300', '300 level'),]
    level = models.CharField(max_length=100, default='200', choices=level_choices)
    is_reviewed = models.BooleanField(default=False)

    def __str__(self):
        return f'{self.student_lg.first_name}\'s logbook of the {self.week} week out of 12 weeks'


class CommentOnLogbook(models.Model):
    commentator = models.ForeignKey(User, on_delete=models.CASCADE)
    timestamp = models.DateTimeField(default=timezone.now)
    logbook = models.ForeignKey(WeekScannedLogbook, on_delete=models.CASCADE)  # Week scanned logbook
    # grade of that week logbook
    grade = models.IntegerField(blank=True, null=True)
    comment = models.TextField(blank=False, null=False)

    def __str__(self):
        return f'Comment of {self.commentator.identification_num} on {self.logbook.student_lg.matrix_no} logbook'
