import os
from datetime import datetime
from django.shortcuts import render, redirect, reverse
from django.contrib import messages
from django.db.models import Q
from django.contrib.auth.decorators import login_required
from .models import TrainingStudent, AcceptanceLetter
from .forms import UploadAcceptanceLetter
from django.contrib.auth import get_user_model
from toolkit import picture_name
from faculty.models import FacultyDean
from department.models import DepartmentHOD, Letter

User = get_user_model()


class Student:
  """Students' related views"""
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
