# -*- coding: utf-8 -*-
from django.db import models
from django.utils import timezone
from django.contrib.auth import get_user_model
from toolkit import y_session

# from django.conf import settings
# User = settings.AUTH_USER_MODEL

User = get_user_model()


"""
NOTE: arrangement of the below models matter to avoid circular import (one block the other)
"""
    

class Session(models.Model):
    session = models.CharField(
        max_length=255, blank=False, null=False, default=y_session())
    
    # is current school session
    is_current_session = models.BooleanField(default=False)
    timestamp = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return f'This is {self.session} session, Is current: {self.is_current_session}'


class Faculty(models.Model):
    """This is faculty table of database"""
    
    training_category = [('siwes', 'Student industrial work experience (SIWES)'), ('tp', 'Teaching practice (TP)')]
    training = models.CharField(max_length=100, default='siwes', choices=training_category)
    date_joined = models.DateTimeField(default=timezone.now)
    last_modified = models.DateTimeField(auto_now=True)
    name = models.CharField(max_length=300, blank=True, null=True, unique=True)
    email = models.EmailField(max_length=255, unique=True)
    website = models.CharField(max_length=300, blank=True, null=True)
    phone_number = models.CharField(max_length=100, unique=False)
    description = models.TextField(blank=True, null=True)

    def __str__(self):
        return f'Faculty of {self.name}'
    


class Department(models.Model):
    """This is department table of database"""
    
    faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE)
    date_joined = models.DateTimeField(default=timezone.now)
    last_modified = models.DateTimeField(auto_now=True)
    name = models.CharField(max_length=300, blank=True, null=True, unique=True)
    email = models.EmailField(max_length=255, unique=True)
    website = models.CharField(max_length=300, blank=True, null=True)
    phone_number = models.CharField(max_length=100, unique=False)
    description = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"Department of {self.name}"
    


class SchoolVC(models.Model):
    """This is school VC table of database"""
    
    vc = models.ForeignKey(User, on_delete=models.CASCADE)
    faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE)
    department = models.ForeignKey(Department, on_delete=models.CASCADE)

    # this is staff ranks or universities he/she attended them e.g
    # B.Sc (Ed), (UDUSOK Nig); PGDIP (BUK, Nig.); Msc, PhD (USIM Malaysia); CFTO
    ranks = models.CharField(max_length=100, unique=False, blank=True, null=True)

    # `level_rank_title_1` is the title that is prefix before the first name of a staff like `PROF` or `Dr` e.g  PROF. MU'AZU ABUBAKAR GUSAU  or  Dr Lawal Saad.
    level_rank_title_1 = models.CharField(max_length=100, unique=False, blank=True, null=True)

    # `level_rank_title_2` is the title that is prefix after the name of a staff like `Ph.D.` e.g  Lawal Saad Ph.D.
    level_rank_title_2 = models.CharField(max_length=100, unique=False, blank=True, null=True)

    professorship = models.CharField(max_length=100, unique=False, blank=True, null=True)

    first_name = models.CharField(max_length=100, unique=False)
    middle_name = models.CharField(max_length=100, unique=False, blank=True, null=True)
    last_name = models.CharField(max_length=100, unique=False)
    gender_choices = [('female', 'Female'), ('male', 'Male'),]
    gender = models.CharField(max_length=100, default='male', choices=gender_choices)
    date_of_birth = models.DateField(max_length=100, blank=True, null=True)
    id_no = models.CharField(max_length=255, unique=True)
    email = models.EmailField(max_length=255, unique=False)
    email_other = models.EmailField(max_length=255, unique=False, blank=True, null=True)
    phone_number = models.CharField(max_length=100, unique=False)
    phone_number_other = models.CharField(max_length=100, unique=False, blank=True, null=True)
    date_joined = models.DateTimeField(default=timezone.now)
    date_leave = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=False)

    def __str__(self):
        return f'VC of the school, is active: {self.is_active}'
    


class FacultyDean(models.Model):
    """This is dean faculty table of database"""
    
    dean = models.ForeignKey(User, on_delete=models.CASCADE)
    faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE)
    department = models.ForeignKey(Department, on_delete=models.CASCADE)

    # this is staff ranks or universities he/she attended them e.g
    # B.Sc (Ed), (UDUSOK Nig); PGDIP (BUK, Nig.); Msc, PhD (USIM Malaysia); CFTO
    ranks = models.CharField(max_length=100, unique=False, blank=True, null=True)

    # `level_rank_title_1` is the title that is prefix before the first name of a staff like `PROF` or `Dr` e.g  PROF. MU'AZU ABUBAKAR GUSAU  or  Dr Lawal Saad.
    level_rank_title_1 = models.CharField(max_length=100, unique=False, blank=True, null=True)

    # `level_rank_title_2` is the title that is prefix after the name of a staff like `Ph.D.` e.g  Lawal Saad Ph.D.
    level_rank_title_2 = models.CharField(max_length=100, unique=False, blank=True, null=True)

    first_name = models.CharField(max_length=100, unique=False)
    middle_name = models.CharField(max_length=100, unique=False, blank=True, null=True)
    last_name = models.CharField(max_length=100, unique=False)
    gender_choices = [('female', 'Female'), ('male', 'Male'),]
    gender = models.CharField(max_length=100, default='male', choices=gender_choices)
    date_of_birth = models.DateField(max_length=100, blank=True, null=True)
    id_no = models.CharField(max_length=255, unique=True)
    email = models.EmailField(max_length=255, unique=False)
    phone_number = models.CharField(max_length=100, unique=False)
    date_joined = models.DateTimeField(default=timezone.now)
    date_leave = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=False)

    def __str__(self):
        return f'Dean faculty of {self.faculty}'
    


class DepartmentHOD(models.Model):
    """This is department H.O.D table of database"""
    
    hod = models.ForeignKey(User, on_delete=models.CASCADE)
    faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE)
    department = models.ForeignKey(Department, on_delete=models.CASCADE)

    # this is staff ranks or universities he/she attended them e.g
    # B.Sc (Ed), (UDUSOK Nig); PGDIP (BUK, Nig.); Msc, PhD (USIM Malaysia); CFTO
    ranks = models.CharField(max_length=100, unique=False, blank=True, null=True)

    # `level_rank_title_1` is the title that is prefix before the first name of a staff like `PROF` or `Dr` e.g  PROF. MU'AZU ABUBAKAR GUSAU  or  Dr Lawal Saad.
    level_rank_title_1 = models.CharField(max_length=100, unique=False, blank=True, null=True)

    # `level_rank_title_2` is the title that is prefix after the name of a staff like `Ph.D.` e.g  Lawal Saad Ph.D.
    level_rank_title_2 = models.CharField(max_length=100, unique=False, blank=True, null=True)

    first_name = models.CharField(max_length=100, unique=False)
    middle_name = models.CharField(max_length=100, unique=False, blank=True, null=True)
    last_name = models.CharField(max_length=100, unique=False)
    gender_choices = [('female', 'Female'), ('male', 'Male'),]
    gender = models.CharField(max_length=100, default='male', choices=gender_choices)
    date_of_birth = models.DateField(max_length=100, blank=True, null=True)
    id_no = models.CharField(max_length=255, unique=True)
    email = models.EmailField(max_length=255, unique=False)
    email_other = models.EmailField(max_length=255, unique=False, blank=True, null=True)
    phone_number = models.CharField(max_length=100, unique=False)
    phone_number_other = models.CharField(max_length=100, unique=False, blank=True, null=True)
    date_joined = models.DateTimeField(default=timezone.now)
    date_leave = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=False)

    def __str__(self):
        return f'H.O.D of {self.department} department'
    


class TrainingStudent(models.Model):
    """This is studnt table of database"""
    
    student = models.ForeignKey(User, on_delete=models.CASCADE)
    faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE)
    department = models.ForeignKey(Department, on_delete=models.CASCADE)
    student_training_coordinator = models.ForeignKey(User, on_delete=models.CASCADE, related_name='student_training_coordinator')
    
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

    # bank details
    bank_name = models.CharField(max_length=100, unique=False, blank=False, null=False)
    account_name = models.CharField(max_length=100, unique=False, blank=False, null=False)
    account_number = models.CharField(max_length=100, unique=False, blank=False, null=False)
    bank_sort_code = models.CharField(max_length=100, unique=False, blank=False, null=False)

    # sessions
    session = models.CharField(max_length=255, blank=False, null=False, default=y_session())
    # sessions student did his 200 level training
    session_200 = models.CharField(max_length=255, blank=False, null=False, default=y_session())
    # sessions student did his 300 level training
    session_300 = models.CharField(max_length=255, blank=False, null=False, default=y_session())

    # student supervisor id at 200 level training program
    supervisor_id_200 = models.CharField(max_length=255, blank=False, null=False)
    # student supervisor id at 300 level training program
    supervisor_id_300 = models.CharField(max_length=255, blank=False, null=False)

    is_apply_training_200 = models.BooleanField(default=False)
    is_apply_training_300 = models.BooleanField(default=False)

    # did student finish his 200 level training program?
    is_finish_200 = models.BooleanField(default=False)
    # did student finish his 200 level training program?
    is_finish_300 = models.BooleanField(default=False)

    # is the student in the school currently
    is_in_school = models.BooleanField(default=False)

    # to avoid assigning the student if already have a supervisor (when assigning in html page) for each level
    is_assign_supervisor_200 = models.BooleanField(default=False)
    is_assign_supervisor_300 = models.BooleanField(default=False)

    def __str__(self):
        return f'Training student with matrix number of {self.matrix_no}'
    


class StudentSupervisor(models.Model):
    """
    This is supervisor table of database
    
    That departmental training coordinator will assign a set of student to
    """
    supervisor = models.ForeignKey(User, on_delete=models.CASCADE)
    first_name = models.CharField(max_length=100, unique=False)
    middle_name = models.CharField(max_length=100, unique=False, blank=True, null=True)
    last_name = models.CharField(max_length=100, unique=False)
    gender_choices = [('female', 'Female'), ('male', 'Male'),]
    gender = models.CharField(max_length=100, default='male', choices=gender_choices)
    date_of_birth = models.DateField(max_length=100, blank=True, null=True)
    id_no = models.CharField(max_length=255, unique=True)
    small_desc = models.CharField(max_length=100, default='200')
    email = models.EmailField(max_length=255, unique=False)
    phone_number = models.CharField(max_length=100, unique=False)
    date_joined = models.DateTimeField(default=timezone.now)
    date_leave = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=False)
    training_students = models.ManyToManyField(
        TrainingStudent, blank=True, related_name='supervisor_training_students') # students assign to him

    def __str__(self):
        return f'{self.first_name} {self.last_name} is a student supervisor'
    


class DepartmentTrainingCoordinator(models.Model):
    """This is departmental training (siwes/tp) coordinator table of database"""
    
    coordinator = models.ForeignKey(User, on_delete=models.CASCADE)
    faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE)
    department = models.ForeignKey(Department, on_delete=models.CASCADE)
    dept_hod = models.ForeignKey(DepartmentHOD, on_delete=models.CASCADE)
    
    first_name = models.CharField(max_length=100, unique=False)
    middle_name = models.CharField(max_length=100, unique=False, blank=True, null=True)
    last_name = models.CharField(max_length=100, unique=False)
    gender_choices = [('female', 'Female'), ('male', 'Male'),]
    gender = models.CharField(max_length=100, default='male', choices=gender_choices)
    date_of_birth = models.DateField(max_length=100, blank=True, null=True)
    id_no = models.CharField(max_length=255, unique=True)
    email = models.EmailField(max_length=255, unique=False)
    phone_number = models.CharField(max_length=100, unique=False)
    date_joined = models.DateTimeField(default=timezone.now)
    date_leave = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=False)

    training_supervisors = models.ManyToManyField(StudentSupervisor, blank=True, related_name='training_supervisors')
    training_students = models.ManyToManyField(TrainingStudent, blank=True, related_name='training_students')

    def __str__(self):
        return f'{self.dept_hod.department} {self.dept_hod.department.faculty.training} coordinator'
    


class Letter(models.Model):
    """This is letter (acceptance/placement) table of database"""
    
    coordinator = models.ForeignKey(DepartmentTrainingCoordinator, on_delete=models.CASCADE)
    dept_hod = models.ForeignKey(DepartmentHOD, on_delete=models.CASCADE)
    vc = models.ForeignKey(SchoolVC, on_delete=models.CASCADE)

    release_date = models.DateTimeField(default=timezone.now)
    last_modified = models.DateTimeField(auto_now=True)
    letter_type = [('placement letter', 'Placement letter'), ('acceptance letter', 'Acceptance letter'),]
    letter = models.CharField(max_length=100, default='placement letter', choices=letter_type)
    duration = models.CharField(max_length=100, default='3', blank=False, null=False)
    start_of_training = models.DateTimeField(default=timezone.now)  # start date of the programm
    end_of_training = models.DateTimeField(default=timezone.now)  # end date of the programm
    text = models.TextField(blank=True, null=True)
    viewers = models.ManyToManyField(TrainingStudent, blank=True, related_name='viewers')

    session = models.CharField(max_length=255, blank=False, null=False, default=y_session())
    # is_200 = models.BooleanField(default=False)
    # is_300 = models.BooleanField(default=False)

    def __str__(self):
        return f'Letter of ({self.letter}) in {self.session} session'
    


class AcceptanceLetter(models.Model):
    """
    This is student acceptance letter table of database, of
    where he/she will do his/her (siwes/tp) programme
    """
    
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

    session = models.CharField(max_length=255, blank=False, null=False, default=y_session())
    is_200 = models.BooleanField(default=False)
    is_300 = models.BooleanField(default=False)

    def __str__(self):
        return f'Student ({self.sender_acept.matrix_no}) acceptance letter (approved)'
    


class WeekReader(models.Model):
    """This is student week reader table of database"""
    
    student = models.ForeignKey(TrainingStudent, related_name='student_week_reader', on_delete=models.CASCADE)
    week_no = models.IntegerField(default=0)  # later max_length will be set

    session = models.CharField(max_length=255, blank=False, null=False, default=y_session())
    is_200 = models.BooleanField(default=False)
    is_300 = models.BooleanField(default=False)

    def __str__(self):
        return f'Week {self.week_no} of student training out of 12 weeks, 200:{self.is_200}, 300:{self.is_300}'
    


class WeekScannedLogbook(models.Model):
    """This is student weekly logbook entry table of database"""
    
    week = models.ForeignKey(WeekReader, related_name='week_reader', on_delete=models.CASCADE)
    student_lg = models.ForeignKey(TrainingStudent, related_name='student_lg', on_delete=models.CASCADE)
    timestamp = models.DateTimeField(default=timezone.now)
    title = models.CharField(max_length=255, blank=True, null=True)
    week_no = models.IntegerField(blank=True, null=True)
    # avoid updating student scanned logbook on admin page (because of the image file route won`t save correctly`)

    session = models.CharField(max_length=255, blank=False, null=False, default=y_session())
    text = models.TextField(blank=True, null=True,)  # references
    level_choices = [('200', '200 level'), ('300', '300 level'),]
    level = models.CharField(max_length=100, default='200', choices=level_choices)
    is_reviewed = models.BooleanField(default=False)

    def __str__(self):
        return f'{self.student_lg.first_name}\'s logbook of the {self.week} week out of 12 weeks'
    

class WeekScannedImage(models.Model):
    """This is student weekly logbook (image) entry table of database"""
    
    student = models.ForeignKey(TrainingStudent, on_delete=models.CASCADE)
    logbook = models.ForeignKey(WeekScannedLogbook, related_name='week_reader', on_delete=models.CASCADE)
    timestamp = models.DateTimeField(default=timezone.now)
    image = models.ImageField(blank=True, null=True, upload_to=f'weekly-scanned-logbook')

    def __str__(self):
        return f'{self.logbook} (image)'
    

class CommentOnLogbook(models.Model):
    """This is student weekly logbook comment table of database"""
    
    commentator = models.ForeignKey(StudentSupervisor, on_delete=models.CASCADE)
    timestamp = models.DateTimeField(default=timezone.now)
    # Week scanned logbook
    logbook = models.OneToOneField(WeekScannedLogbook, on_delete=models.CASCADE)
    # grade of that week logbook
    grade = models.IntegerField(blank=True, null=True)
    comment = models.TextField(blank=False, null=False)
    session = models.CharField(max_length=255, blank=False, null=False, default=y_session())

    def __str__(self):
        return f'Comment of {self.commentator.id_no} on {self.logbook.student_lg.matrix_no} logbook'
    


class StudentResult(models.Model):
    """This is the result of student (siwes/tp)"""
    student = models.ForeignKey(
        TrainingStudent, related_name='sender_req', on_delete=models.CASCADE)
    
    # cordinator info when he was doing the programme, all in text form no
    # any foreign key or many-to-many, or other table relations, except for th student
    c_first_name = models.CharField(max_length=100, unique=False, blank=False, null=False)
    c_middle_name = models.CharField(max_length=100, unique=False, blank=True, null=True)
    c_last_name = models.CharField(max_length=100, unique=False, blank=False, null=False)
    c_id_no = models.CharField(max_length=255, unique=True, blank=False, null=False)
    c_email = models.EmailField(max_length=255, unique=False, blank=False, null=False)
    c_phone_number = models.CharField(max_length=100, unique=False, blank=False, null=False)

    # supervisor info when he was doing the programme, all in text form no
    # any foreign key or many-to-many, or other table relations, except for th student
    s_first_name = models.CharField(max_length=100, unique=False, blank=False, null=False)
    s_middle_name = models.CharField(max_length=100, unique=False, blank=True, null=True)
    s_last_name = models.CharField(max_length=100, unique=False, blank=False, null=False)
    s_id_no = models.CharField(max_length=255, unique=True, blank=False, null=False)
    s_email = models.EmailField(max_length=255, unique=False, blank=False, null=False)
    s_phone_number = models.CharField(max_length=100, unique=False, blank=False, null=False)

    # result status
    status = models.CharField(max_length=100, unique=False, blank=False, null=False)
    # result grade
    grade = models.CharField(max_length=100, unique=False, blank=False, null=False)
    
    session = models.CharField(
        max_length=255, blank=False, null=False, default=y_session())
    level = models.CharField(max_length=100, unique=False, blank=False, null=False)
    timestamp = models.DateTimeField(default=timezone.now)

    # coordinator will approve student result
    is_approve = models.BooleanField(default=False)

    def __str__(self):
        return f'{self.student} training result for {self.level}'
