import os
from datetime import datetime
from django.shortcuts import render, redirect, reverse
from django.contrib import messages
from django.db.models import Q
from django.contrib.auth.decorators import login_required
from .models import TrainingStudent, AcceptanceLetter, WeekReader, WeekScannedLogbook, CommentOnLogbook
from .forms import UploadAcceptanceLetter, UploadLogbookEntry, LogbookEntryComment
from django.contrib.auth import get_user_model
from toolkit import picture_name
from faculty.models import FacultyDean
from department.models import DepartmentHOD, Letter

User = get_user_model()


class Student:
  """Students' related views"""
  @login_required
  @staticmethod
  def profile(request):
    """student profile"""
    the_student_request_user = request.user
    std = TrainingStudent.objects.filter(student=the_student_request_user).first()
    dean = FacultyDean.objects.filter(faculty=std.student_training_coordinator.dept_hod.department.faculty).last()
    hod = DepartmentHOD.objects.filter(department=std.student_training_coordinator.dept_hod.department).last()

    acceptance_200 = AcceptanceLetter.objects.filter(sender_acept=std, level="200").last()
    acceptance_300 = AcceptanceLetter.objects.filter(sender_acept=std, level="300").last()
    
    context = {
      "std": std,
      "dean": dean,
      "hod": hod,
      "acceptance_200": acceptance_200,
      "acceptance_300": acceptance_300,
    }
    return render(request, "student/profile.html", context=context)
    

  @login_required
  @staticmethod
  def otherViewProfile(request, student_id):
    """student profile (for other when they view it, such as coordinator, training manager, etc)"""
    std = TrainingStudent.objects.filter(matrix_no=student_id).first()
    dean = FacultyDean.objects.filter(faculty=std.student_training_coordinator.dept_hod.department.faculty).last()
    hod = DepartmentHOD.objects.filter(department=std.student_training_coordinator.dept_hod.department).last()

    context = {
      "std": std,
      "dean": dean,
      "hod": hod,
    }
    return render(request, "student/profile_other.html", context=context)


  @login_required
  @staticmethod
  def placementLetter(request):
    the_student_request_user = request.user
    std = TrainingStudent.objects.filter(student=the_student_request_user).first()
    letter = Letter.objects.filter(letter="placement letter", coordinator=std.student_training_coordinator).first()
    dean = FacultyDean.objects.filter(faculty=std.student_training_coordinator.dept_hod.department.faculty).last()
    hod = DepartmentHOD.objects.filter(department=std.student_training_coordinator.dept_hod.department).last()

    context = {
      "std": std,
      "letter": letter,
      "dean": dean,
      "hod": hod,
    }
    return render(request, "student/placement_letter.html", context=context)


  @login_required
  @staticmethod
  def acceptanceLetter(request):
    the_student_request_user = request.user
    std = TrainingStudent.objects.filter(student=the_student_request_user).first()
    letter = Letter.objects.filter(letter="acceptance letter", coordinator=std.student_training_coordinator).first()
    dean = FacultyDean.objects.filter(faculty=std.student_training_coordinator.dept_hod.department.faculty).last()
    hod = DepartmentHOD.objects.filter(department=std.student_training_coordinator.dept_hod.department).last()

    context = {
      "std": std,
      "letter": letter,
      "dean": dean,
      "hod": hod,
    }
    return render(request, "student/acceptance_letter.html", context=context)


  @login_required
  @staticmethod
  def uploadedAcceptanceLetter200(request):
    """This view show 200 level student acceptance letter"""
    stu_usr = User.objects.get(id=request.user.id) # student user
    std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first() # training student
    coord = std.student_training_coordinator

    # acceptance letter for the student
    acceptance_200 = AcceptanceLetter.objects.filter(sender_acept=std, receiver_acept=coord, level="200").last()
    context = {
      "acceptance_200": acceptance_200,
    }
    return render(request, "student/upload_acceptance_letter_200.html", context=context)


  @login_required
  @staticmethod
  def uploadedAcceptanceLetter300(request):
    """This view show 300 level student acceptance letter"""
    stu_usr = User.objects.get(id=request.user.id) # student user
    std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first() # training student
    coord = std.student_training_coordinator

    # acceptance letter for the student
    acceptance_300 = AcceptanceLetter.objects.filter(sender_acept=std, receiver_acept=coord, level="300").last()
    context = {
      "acceptance_300": acceptance_300,
    }
    return render(request, "student/upload_acceptance_letter_300.html", context=context)


  @login_required
  @staticmethod
  def uploadAcceptanceLetter200(request):
    """upload (the view that will upload) acceptance letter for 200 level student"""
    stu_usr = User.objects.get(id=request.user.id) # student user
    std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
    coord = std.student_training_coordinator

    train = std.student_training_coordinator.dept_hod.department.faculty.training
    faculty = std.student_training_coordinator.dept_hod.department.faculty.name
    department = std.student_training_coordinator.dept_hod.department.name
    level = std.level
    route = f'{datetime.today().year}-acceptances'+'/'+train+'/'+faculty+'/'+department+'/l'+level+'/'
    
    form = UploadAcceptanceLetter(request.POST, request.FILES)
    if form.is_valid():
      instance = form.save(commit=False)
      pic_name = picture_name(instance.image.name)
      instance.image.name = route + pic_name
      instance.sender_acept = std
      instance.receiver_acept = coord
      instance.level = "200"
      instance.save()
      messages.success(request, f'Your 200 level acceptance letter image has been uploaded!')
      return redirect(reverse('student:uploaded_acceptance_letter_200'))


  @login_required
  @staticmethod
  def uploadAcceptanceLetter300(request):
    """upload (the view that will upload) acceptance letter for 300 level student"""
    stu_usr = User.objects.get(id=request.user.id) # student user
    std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
    coord = std.student_training_coordinator

    train = std.student_training_coordinator.dept_hod.department.faculty.training
    faculty = std.student_training_coordinator.dept_hod.department.faculty.name
    department = std.student_training_coordinator.dept_hod.department.name
    level = std.level
    route = f'{datetime.today().year}-acceptances'+'/'+train+'/'+faculty+'/'+department+'/l'+level+'/'
    
    form = UploadAcceptanceLetter(request.POST, request.FILES)
    if form.is_valid():
      instance = form.save(commit=False)
      pic_name = picture_name(instance.image.name)
      instance.image.name = route + pic_name
      instance.sender_acept = std
      instance.receiver_acept = coord
      instance.level = "300"
      instance.save()
      messages.success(request, f'Your 300 level acceptance letter image has been uploaded!')
      return redirect(reverse('student:uploaded_acceptance_letter_300'))


  @login_required
  @staticmethod
  def updateAcceptanceLetter200(request):
    """update acceptance letter for 200 level student"""
    stu_usr = User.objects.get(id=request.user.id) # student user
    std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
    coord = std.student_training_coordinator
    acceptance_200 = AcceptanceLetter.objects.filter(sender_acept=std, receiver_acept=coord, level="200").first()

    train = std.student_training_coordinator.dept_hod.department.faculty.training
    faculty = std.student_training_coordinator.dept_hod.department.faculty.name
    department = std.student_training_coordinator.dept_hod.department.name
    level = std.level
    route = f'{datetime.today().year}-acceptances'+'/'+train+'/'+faculty+'/'+department+'/l'+level+'/'
    
    if not acceptance_200:
      return False
    
    if request.method == 'POST':
      form = UploadAcceptanceLetter(request.POST, request.FILES, instance=acceptance_200)
      if form.is_valid():
        # the remove of previous acceptance is not workin, later will be arrange
        if os.path.exists(acceptance_200.image.path):
          os.remove(acceptance_200.image.path)
        instance = form.save(commit=False)
        pic_name = picture_name(instance.image.name)
        instance.image.name = route + pic_name
        instance.save()
        
        stu_letter = AcceptanceLetter.objects.filter(sender_acept=std, level="200").first()
        if stu_letter:
          stu_letter.is_reviewed = False
          stu_letter.can_change = False
          stu_letter.save()
        messages.success(request, f'Your 200 level acceptance letter image has been updated!')
        return redirect(reverse('student:update_acceptance_letter_200'))
    else:
      form = UploadAcceptanceLetter(instance=acceptance_200)
    context = {
      'form': form,
      "std": std,
      "acceptance_200": acceptance_200,
    }
    return render(request, 'student/update_acceptance_letter_200.html', context)


  @login_required
  @staticmethod
  def updateAcceptanceLetter300(request):
    """update acceptance letter for 300 level student"""
    stu_usr = User.objects.get(id=request.user.id) # student user
    std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
    coord = std.student_training_coordinator
    acceptance_300 = AcceptanceLetter.objects.filter(sender_acept=std, receiver_acept=coord, level="300").first()

    train = std.student_training_coordinator.dept_hod.department.faculty.training
    faculty = std.student_training_coordinator.dept_hod.department.faculty.name
    department = std.student_training_coordinator.dept_hod.department.name
    level = std.level
    route = f'{datetime.today().year}-acceptances'+'/'+train+'/'+faculty+'/'+department+'/l'+level+'/'
    
    if not acceptance_300:
      return False
    
    if request.method == 'POST':
      form = UploadAcceptanceLetter(request.POST, request.FILES, instance=acceptance_300)
      if form.is_valid():
        # the remove of previous acceptance is not workin, later will be arrange
        if os.path.exists(acceptance_300.image.path):
          os.remove(acceptance_300.image.path)
        instance = form.save(commit=False)
        pic_name = picture_name(instance.image.name)
        instance.image.name = route + pic_name
        instance.save()
        
        stu_letter = AcceptanceLetter.objects.filter(sender_acept=std, level="300").first()
        if stu_letter:
          stu_letter.is_reviewed = False
          stu_letter.can_change = False
          stu_letter.save()
        messages.success(request, f'Your 300 level acceptance letter image has been updated!')
        return redirect(reverse('student:update_acceptance_letter_300'))
    else:
      form = UploadAcceptanceLetter(instance=acceptance_300)
    context = {
      'form': form,
      "std": std,
      "acceptance_300": acceptance_300,
    }
    return render(request, 'student/update_acceptance_letter_300.html', context)


  @login_required
  @staticmethod
  def logbookEntry(request):
    """
    This method handle the tricks of student logbook entry per week (upload i.e scanned logbook in hardcopy), which can be view by them and their supervisor.
    """
    stu_usr = User.objects.get(id=request.user.id) # student user
    std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
    coord = std.student_training_coordinator

    train = std.student_training_coordinator.dept_hod.department.faculty.training
    faculty = std.student_training_coordinator.dept_hod.department.faculty.name
    department = std.student_training_coordinator.dept_hod.department.name
    level = std.level
    route = f'{datetime.today().year}-logbooks-entry'+'/'+train+'/'+faculty+'/'+department+'/l'+level+'/'
    WR = WeekReader.objects.filter(student=std).last()
    # increment week by one, but it doesn't save it into the database,
    # just to make it the start of our range below (w)
    a = WR.week_no + 1

    # Increment 12 by one, to make it the end of our range below (w)
    b = 12 + 1
    w = range(a, b)
    weeks = list(w) # convert range (w) to list
    week_no = WR.week_no + 1
    logbook_entries = WeekScannedLogbook.objects.filter(student_lg=std, week=WR).all()

    if request.method == 'POST':
      form = UploadLogbookEntry(request.POST, request.FILES)
      if form.is_valid():
        instance = form.save(commit=False)
        pic_name = picture_name(instance.image.name)
        instance.image.name = route + pic_name
        instance.student_lg = std
        instance.week = WR
        instance.week_no = WR.week_no + 1 # incrementing the week number of (within logbook field)
        instance.save()

        # increment week by one
        WR.week_no += 1
        WR.save()
        messages.success(request, f'You just upload your logbook entry for {WR.week_no} week!')
        return redirect(reverse('student:logbook_entry'))
    else:
      form = UploadLogbookEntry()
    context = {
      'form': form,
      "std": std,
      "weeks": weeks,
      "week_no": week_no,
      "logbook_entries": logbook_entries,
    }
    return render(request, 'student/logbook_entry.html', context)


  @login_required
  @staticmethod
  def logbookComment(request, logbook_id):
    logbook = WeekScannedLogbook.objects.get(id=logbook_id)
    stu_usr = User.objects.get(id=request.user.id) # student user
    std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
    comments = CommentOnLogbook.objects.filter(logbook=logbook).all()

    if request.method == 'POST':
      form = LogbookEntryComment(request.POST)
      if form.is_valid():
        instance = form.save(commit=False)
        instance.commentator = request.user
        instance.logbook = logbook
        instance.save()
        messages.success(request, f'You just comment on logbook entry for {logbook.week_no} week of {std.matrix_no}')
        return redirect(reverse('student:logbook_comment', kwargs={'logbook_id':logbook_id}))
    else:
      form = LogbookEntryComment()
    context = {
      "form": form,
      "comments": comments,
      "logbook": logbook,
    }
    return render(request, 'student/logbook_comment.html', context)
