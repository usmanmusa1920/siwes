import os
from django.shortcuts import render, redirect, reverse
from django.contrib import messages
from django.db.models import Q
from django.contrib.auth.decorators import login_required
from .models import TrainingStudent, AcceptanceLetter, UpdateAcceptanceLetter
from .forms import UploadAcceptanceLetter, UpdateAcceptanceLetterForm
from django.contrib.auth import get_user_model
from toolkit import picture_name
from faculty.models import FacultyDean
from department.models import DepartmentHOD, Letter

User = get_user_model()


def studentProfile(request):
  """student profile"""
  the_student_request_user = request.user
  std = TrainingStudent.objects.filter(student=the_student_request_user).first()
  dean = FacultyDean.objects.filter(faculty=std.student_training_coordinator.dept_hod.department.faculty).last()
  hod = DepartmentHOD.objects.filter(department=std.student_training_coordinator.dept_hod.department).last()

  context = {
    "std": std,
    "dean": dean,
    "hod": hod,
  }
  return render(request, "student/profile.html", context=context)


def otherViewStudentProfile(request, student_id):
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
  

def placementLetter(request):
  the_student_request_user = request.user
  std = TrainingStudent.objects.filter(student=the_student_request_user).first()
  letter = Letter.objects.filter(letter="placement letter", coordinator=std.student_training_coordinator).first()
  dean = FacultyDean.objects.filter(faculty=std.student_training_coordinator.dept_hod.department.faculty).last()
  hod = DepartmentHOD.objects.filter(department=std.student_training_coordinator.dept_hod.department).last()

  context = {
    "None": None,
    "std": std,
    "letter": letter,
    "dean": dean,
    "hod": hod,
  }
  return render(request, "student/placement_letter.html", context=context)
  

def acceptanceLetter(request):
  the_student_request_user = request.user
  std = TrainingStudent.objects.filter(student=the_student_request_user).first()
  letter = Letter.objects.filter(letter="acceptance letter", coordinator=std.student_training_coordinator).first()
  dean = FacultyDean.objects.filter(faculty=std.student_training_coordinator.dept_hod.department.faculty).last()
  hod = DepartmentHOD.objects.filter(department=std.student_training_coordinator.dept_hod.department).last()

  context = {
    "None": None,
    "std": std,
    "letter": letter,
    "dean": dean,
    "hod": hod,
  }
  return render(request, "student/acceptance_letter.html", context=context)
  

def uploadedAcceptanceLetter(request):
  stu_usr = User.objects.get(id=request.user.id) # student user
  std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first() # training student
  coord = std.student_training_coordinator

  # acceptance letter for student for 200 and 300 level
  acceptance_200 = AcceptanceLetter.objects.filter(sender_acept=std, receiver_acept=coord, level="200").last()
  acceptance_300 = AcceptanceLetter.objects.filter(sender_acept=std, receiver_acept=coord, level="300").last()

  # acceptance letter (if coordinator approved to change) for student for 200 and 300 level
  can_change_letter_200 = AcceptanceLetter.objects.filter(sender_acept=std, receiver_acept=coord, level="200", can_change=True).last()
  can_change_letter_300 = AcceptanceLetter.objects.filter(sender_acept=std, receiver_acept=coord, level="300", can_change=True).last()

  # filtering student declined request (is_declined=True) for 200 and 300 level
  student_decline_req_200 = UpdateAcceptanceLetter.objects.filter(sender_acept=std, receiver_acept=coord, is_declined=True, level="200").last()
  student_declined_req_300 = UpdateAcceptanceLetter.objects.filter(sender_acept=std, receiver_acept=coord, is_declined=True, level="300").last()

  # request for changing letter
  student_requests_300 = UpdateAcceptanceLetter.objects.filter(Q(sender_acept=std, receiver_acept=coord, is_declined=False, level="300"))

  context = {
    "std": std,
    "acceptance_200": acceptance_200,
    "acceptance_300": acceptance_300,
    "student_decline_req_200": student_decline_req_200,
    "student_declined_req_300": student_declined_req_300,
    "can_change_letter_200": can_change_letter_200,
    "can_change_letter_300": can_change_letter_300,
    "student_requests_300": student_requests_300,
  }
  return render(request, "student/upload_acceptance_letter.html", context=context)
  

def uploadAcceptanceLetter200(request):
  """upload acceptance letter for 200 level student"""
  stu_usr = User.objects.get(id=request.user.id) # student user
  std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
  coord = std.student_training_coordinator
  acceptance_200 = AcceptanceLetter.objects.filter(sender_acept=std, receiver_acept=coord, level="200").last()

  # if student.level == "200":
  #   pass
  form = UploadAcceptanceLetter(request.POST, request.FILES)
  if form.is_valid():
    if form.cleaned_data.get("image") == None and form.cleaned_data.get("message") == "":
      messages.success(request, f"You can't send blank space (empty)")
    try:
      if os.path.exists(acceptance_200.image.path):
        os.remove(acceptance_200.image.path)
    except:
      pass
    instance = form.save(commit=False)
    pic_name = picture_name(instance.image.name)
    instance.image.name = pic_name
    instance.sender_acept = std
    instance.receiver_acept = coord
    instance.level = "200"
    instance.save()
    messages.success(request, f'Your 200 level acceptance letter image has been uploaded!')
    return redirect(reverse('student:uploaded_acceptance_letter'))
    

def uploadAcceptanceLetter300(request):
  """upload acceptance letter for 300 level student"""
  stu_usr = User.objects.get(id=request.user.id) # student user
  std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
  coord = std.student_training_coordinator
  acceptance_300 = AcceptanceLetter.objects.filter(sender_acept=std, receiver_acept=coord, level="300").last()

  # if student.level == "300":
  #   pass
  form = UploadAcceptanceLetter(request.POST, request.FILES)
  # , instance=request.user
  if form.is_valid():
    if form.cleaned_data.get("image") == None and form.cleaned_data.get("message") == "":
      messages.success(request, f"You can't send blank space (empty)")
    try:
      if acceptance_300:
        acceptance_300.delete()
      if os.path.exists(acceptance_300.image.path):
        os.remove(acceptance_300.image.path)
    except:
      pass
    instance = form.save(commit=False)
    pic_name = picture_name(instance.image.name)
    instance.image.name = pic_name
    instance.sender_acept = std
    instance.receiver_acept = coord
    instance.level = "300"
    instance.save()
    messages.success(request, f'Your 300 level acceptance letter image has been uploaded!')
    return redirect(reverse('student:uploaded_acceptance_letter'))
    

def requestChangeAcceptanceLetter(request, letter_id):
  letter = AcceptanceLetter.objects.get(id=letter_id)
  if letter.sender_acept.student == request.user:
    context = {
      "letter": letter,
    }
    return render(request, "student/request_change_acceptance_letter.html", context=context)
  return False
  
  
def updateAcceptanceLetterRequest200(request, letter_id):
  """Make request to change acceptance lette for 200 level"""
  stu_usr = User.objects.get(id=request.user.id) # student user
  std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
  coord = std.student_training_coordinator
  acept_letter = AcceptanceLetter.objects.get(id=letter_id)

  student_requests = UpdateAcceptanceLetter.objects.filter(Q(sender_acept=std, receiver_acept=coord, is_approved=False, level="200"))
  if student_requests:
    messages.success(request, f'You already requested!')
    return redirect(reverse('student:uploaded_acceptance_letter'))

  form = UpdateAcceptanceLetterForm(request.POST)
  if form.is_valid():
    text = form.cleaned_data.get("text")
  instance = form.save(commit=False)
  instance.sender_acept = std
  instance.receiver_acept = coord
  instance.letter = acept_letter
  instance.text = text
  instance.level = "200"
  instance.save()
  messages.success(request, f'Your request for updating your training acceptance letter has been sent!')
  return redirect(reverse('student:uploaded_acceptance_letter'))


def updateAcceptanceLetterRequest300(request, letter_id):
  """Make request to change acceptance lette for 300 level"""
  stu_usr = User.objects.get(id=request.user.id) # student user
  std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
  coord = std.student_training_coordinator
  acept_letter = AcceptanceLetter.objects.get(id=letter_id)

  student_requests = UpdateAcceptanceLetter.objects.filter(Q(sender_acept=std, receiver_acept=coord, is_declined=False, level="300"))
  if student_requests:
    messages.success(request, f'You already requested!')
    return redirect(reverse('student:uploaded_acceptance_letter'))

  form = UpdateAcceptanceLetterForm(request.POST)
  if form.is_valid():
    text = form.cleaned_data.get("text")
  instance = form.save(commit=False)
  instance.sender_acept = std
  instance.receiver_acept = coord
  instance.letter = acept_letter
  instance.text = text
  instance.level = "300"
  instance.save()
  messages.success(request, f'Your request for updating your training acceptance letter has been sent!')
  return redirect(reverse('student:uploaded_acceptance_letter'))
