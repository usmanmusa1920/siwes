# -*- coding: utf-8 -*-
from django.db import models
from django.utils import timezone
from django.contrib.auth import get_user_model
from django.conf import settings
from toolkit import y_session


# User = settings.AUTH_USER_MODEL
User = get_user_model()


"""
NOTE: arrangement of the below models matter to avoid circular import (one block the other)
"""


class Session(models.Model):
    """school training session"""
    session = models.CharField(max_length=255, blank=False, null=False, default=y_session())
    # is current school session
    is_current_session = models.BooleanField(default=False)
    timestamp = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return f'This is {self.session} session, Is current: {self.is_current_session}'
    

class Faculty(models.Model):
    """This is faculty table of database"""
    training_category = [
        ('siwes', 'Student industrial work experience (SIWES)'), ('tp', 'Teaching practice (TP)')]
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
    

class Vc(models.Model):
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
        return f'VC of the school ({self.first_name}), is active: {self.is_active}'
    

class Hod(models.Model):
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
        return f'H.O.D of {self.department.name} department'
    

class Student(models.Model):
    """This is studnt table of database"""
    student = models.ForeignKey(User, on_delete=models.CASCADE)
    faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE)
    department = models.ForeignKey(Department, on_delete=models.CASCADE)
    student_coordinator = models.ForeignKey(
        User, on_delete=models.CASCADE, related_name='student_coordinator')
    
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

    # sessions student did his 200 and 300 level training
    session_200 = models.CharField(max_length=255, blank=False, null=False)
    session_300 = models.CharField(max_length=255, blank=False, null=False)

    # student supervisor id at 200 and 300 level training program
    supervisor_id_200 = models.CharField(max_length=255, blank=False, null=False)
    supervisor_id_300 = models.CharField(max_length=255, blank=False, null=False)

    # apply indicators for 200 and 300 level
    is_apply_training_200 = models.BooleanField(default=False)
    is_apply_training_300 = models.BooleanField(default=False)

    # did student finish his 200 or 300 level training program?
    is_finish_200 = models.BooleanField(default=False)
    is_finish_300 = models.BooleanField(default=False)

    # is the student in the school currently, it will be false as soon as student 300 level training result is approved
    is_in_school = models.BooleanField(default=False)
    
    # it will be true base on student level, to avoid displaying student name when coordinator assigning student to a supervisor (when assigning in html page)
    is_assign_supervisor_200 = models.BooleanField(default=False)
    is_assign_supervisor_300 = models.BooleanField(default=False)

    def __str__(self):
        return f'Student with matrix number of {self.matrix_no}'
    

class Supervisor(models.Model):
    """
    This is supervisor table of the database, that departmental training coordinator will assign a set of student to him
    """
    supervisor = models.ForeignKey(User, on_delete=models.CASCADE)
    students = models.ManyToManyField(Student, blank=True) # students assign to him
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
    
    def __str__(self):
        return f'{self.first_name} {self.last_name} is a supervisor'
    

class Coordinator(models.Model):
    """This is departmental training (siwes/tp) coordinator table of database"""
    coordinator = models.ForeignKey(User, on_delete=models.CASCADE)
    faculty = models.ForeignKey(Faculty, on_delete=models.CASCADE)
    department = models.ForeignKey(Department, on_delete=models.CASCADE)
    
    supervisors = models.ManyToManyField(Supervisor, blank=True)
    students = models.ManyToManyField(Student, blank=True)
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
        return f'{self.department} {self.department.faculty.training} coordinator'
    

class Letter(models.Model):
    """This is letter (acceptance/placement) table of database"""
    coordinator = models.ForeignKey(Coordinator, on_delete=models.CASCADE)
    hod = models.ForeignKey(Hod, on_delete=models.CASCADE)
    vc = models.ForeignKey(Vc, on_delete=models.CASCADE)

    # student that apply for this letter (those who view it)
    approvals = models.ManyToManyField(Student, blank=True)
    release_date = models.DateTimeField(default=timezone.now)
    last_modified = models.DateTimeField(auto_now=True)
    
    # duration in weeks
    duration = models.CharField(max_length=100, default='12', blank=False, null=False)
    start_of_training = models.DateField(max_length=100, blank=True, null=True)
    end_of_training = models.DateField(max_length=100, blank=True, null=True)
    session = models.CharField(max_length=255, blank=False, null=False)
    def __str__(self):
        return f'{self.hod.department} student letter of {self.session} session'
    

class Acceptance(models.Model):
    """
    This is student acceptance letter table of database, of where he/she will do his/her (siwes/tp) programme
    """
    sender = models.ForeignKey(Student, on_delete=models.CASCADE)
    receiver = models.ForeignKey(Coordinator, on_delete=models.CASCADE)
    letter = models.ForeignKey(Letter, on_delete=models.CASCADE)

    # NOTE avoid updating student acceptance letter on admin page (because of the image file route won`t save correctly`)
    image = models.ImageField(blank=True, null=True, upload_to=f'acceptance-letters')
    is_reviewed = models.BooleanField(default=False)
    can_change = models.BooleanField(default=False)
    session = models.CharField(max_length=255, blank=False, null=False)
    timestamp = models.DateTimeField(default=timezone.now)
    level_choices = [('200', '200 level'), ('300', '300 level'),]
    level = models.CharField(max_length=100, default='200', choices=level_choices)

    def __str__(self):
        return f'{self.sender.first_name} ({self.sender.matrix_no}) acceptance letter'
    

class WeekReader(models.Model):
    """This is student week reader table of database"""
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    acceptance = models.ForeignKey(Acceptance, on_delete=models.CASCADE)

    # NOTE max_length will be set later
    week_no = models.IntegerField(default=0)
    session = models.CharField(max_length=255, blank=False, null=False)
    level_choices = [('200', '200 level'), ('300', '300 level'),]
    level = models.CharField(max_length=100, default='200', choices=level_choices)

    def __str__(self):
        return f'{self.student.first_name} is in week {self.week_no} out of 12 weeks, for {self.level} programm'
    

class WeekEntry(models.Model):
    """This is student weekly logbook entry table of database"""
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    week_reader = models.ForeignKey(WeekReader, on_delete=models.CASCADE)
    commentator = models.ForeignKey(Supervisor, on_delete=models.CASCADE)
    timestamp = models.DateTimeField(default=timezone.now)
    week_no = models.IntegerField(blank=True, null=True)

    # for supervisor
    grade = models.IntegerField(blank=True, null=True)
    comment = models.TextField(blank=True, null=True)
    session = models.CharField(max_length=255, blank=False, null=False)
    level_choices = [('200', '200 level'), ('300', '300 level'),]
    level = models.CharField(max_length=100, default='200', choices=level_choices)
    is_reviewed = models.BooleanField(default=False)

    def __str__(self):
        return f'{self.student.first_name}\'s logbook of week {self.week_no} out of 12 weeks'
    

class WeekEntryImage(models.Model):
    """This is student weekly logbook (image) entry table of database"""
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    week_entry = models.ForeignKey(WeekEntry, on_delete=models.CASCADE)

    # NOTE avoid updating student scanned week entry on admin page (because of the image file route won`t save correctly`)
    image = models.ImageField(blank=True, null=True, upload_to=f'weekly-scanned-logbook')
    timestamp = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return f'{self.week_entry} (image)'
    

class Result(models.Model):
    """This is the result of student (siwes/tp)"""
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    acceptance = models.ForeignKey(Acceptance, on_delete=models.CASCADE)
    
    # student coordinator info, when he was doing the programme, all in text form no any foreign key or many-to-many, or other table relations, except for the student, reason is to make it unchangable when that coordinator change something in his profile
    c_first_name = models.CharField(max_length=100, unique=False, blank=False, null=False)
    c_middle_name = models.CharField(max_length=100, unique=False, blank=True, null=True)
    c_last_name = models.CharField(max_length=100, unique=False, blank=False, null=False)
    c_id_no = models.CharField(max_length=255, unique=True, blank=False, null=False)
    c_email = models.EmailField(max_length=255, unique=False, blank=False, null=False)
    c_phone_number = models.CharField(max_length=100, unique=False, blank=False, null=False)

    # student supervisor info, when he was doing the programme, all in text form no any foreign key or many-to-many, or other table relations, except for the student, reason is to make it unchangable when that supervisor change something in his profile
    s_first_name = models.CharField(max_length=100, unique=False, blank=False, null=False)
    s_middle_name = models.CharField(max_length=100, unique=False, blank=True, null=True)
    s_last_name = models.CharField(max_length=100, unique=False, blank=False, null=False)
    s_id_no = models.CharField(max_length=255, unique=True, blank=False, null=False)
    s_email = models.EmailField(max_length=255, unique=False, blank=False, null=False)
    s_phone_number = models.CharField(max_length=100, unique=False, blank=False, null=False)

    # result status
    status = models.CharField(max_length=100, unique=False, blank=False, null=False)
    grade = models.CharField(max_length=100, unique=False, blank=False, null=False)
    session = models.CharField(max_length=255, blank=False, null=False)
    level_choices = [('200', '200 level'), ('300', '300 level'),]
    level = models.CharField(max_length=100, default='200', choices=level_choices)
    timestamp = models.DateTimeField(default=timezone.now)

    # coordinator will approve student result
    is_approve = models.BooleanField(default=False)
    
    def __str__(self):
        return f'{self.student} training result for {self.level}'
