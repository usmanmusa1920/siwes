import os
from django.shortcuts import render, redirect, reverse
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from .models import TrainingStudent, AcceptanceLetter, UpdateAcceptanceLetter
from .forms import UploadAcceptanceLetter, UpdateAcceptanceLetterForm
from django.contrib.auth import get_user_model
from toolkit import picture_name, the_year, whoIsUser, whoIsStudent
from department.models import Letter

User = get_user_model()


def studentProfile(request):
  """student profile"""
  # std_name = whoIsUser(request).first_name
  # std_level = whoIsStudent(request).level
  # std_dept = whoIsStudent(request).student_training_coordinator.dept_hod.department.name
  # std_faculty = whoIsStudent(request).student_training_coordinator.dept_hod.department.faculty.name
  # std_training = whoIsStudent(request).student_training_coordinator.dept_hod.department.faculty.training

  # std_route = f"{std_training}/{std_faculty}/{std_dept}/{std_level}"
  # print(f"The student ({std_name}) acceptance route is: {std_route}")
  
  the_student = request.user
  usr = TrainingStudent.objects.filter(student=the_student).first()
  context = {
    "None": None,
    "usr": usr,
  }
  return render(request, "student/profile.html", context=context)


def placementLetter(request):
  the_student = request.user
  usr = TrainingStudent.objects.filter(student=the_student).first()
  letter = Letter.objects.filter(letter="placement letter", coordinator=usr.student_training_coordinator).first()
  context = {
    "None": None,
    "usr": usr,
    "letter": letter,
  }
  return render(request, "student/placement_letter.html", context=context)
  
  
def acceptanceLetter(request):
  the_student = request.user
  usr = TrainingStudent.objects.filter(student=the_student).first()
  letter = Letter.objects.filter(letter="acceptance letter", coordinator=usr.student_training_coordinator).first()
  context = {
    "None": None,
    "usr": usr,
    "letter": letter,
  }
  return render(request, "student/acceptance_letter.html", context=context)
  
  
def uploadedAcceptanceLetter(request):
  stu_usr = User.objects.get(id=request.user.id) # student user
  student = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
  coord = student.student_training_coordinator

  acceptance_200 = AcceptanceLetter.objects.filter(sender_acept=student, receiver_acept=coord, level="200").last()
  acceptance_300 = AcceptanceLetter.objects.filter(sender_acept=student, receiver_acept=coord, level="300").last()

  if UpdateAcceptanceLetter.objects.filter(sender_acept=student, receiver_acept=coord, is_reviewed=False, level="200"):
    student_req_to_change_letter_200 = UpdateAcceptanceLetter.objects.filter(sender_acept=student, receiver_acept=coord, is_reviewed=False, level="200")
  else:
    student_req_to_change_letter_200 = None # it will show nothing in the template

  if UpdateAcceptanceLetter.objects.filter(sender_acept=student, receiver_acept=coord, is_reviewed=False, level="300"):
    student_req_to_change_letter_300 = UpdateAcceptanceLetter.objects.filter(sender_acept=student, receiver_acept=coord, is_reviewed=False, level="300")
  else:
    student_req_to_change_letter_300 = None # it will show nothing in the template

  context = {
    "student": student,
    "acceptance_200": acceptance_200,
    "acceptance_300": acceptance_300,
    "student_req_to_change_letter_200": student_req_to_change_letter_200,
    "student_req_to_change_letter_300": student_req_to_change_letter_300,
  }
  return render(request, "student/upload_acceptance_letter.html", context=context)


def uploadAcceptanceLetter200(request):
  """upload acceptance letter for 200 level student"""
  stu_usr = User.objects.get(id=request.user.id) # student user
  student = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
  coord = student.student_training_coordinator
  acceptance_200 = AcceptanceLetter.objects.filter(sender_acept=student, receiver_acept=coord, level="200").last()

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
    instance.sender_acept = student
    instance.receiver_acept = coord
    instance.level = "200"
    instance.save()
    messages.success(request, f'Your 200 level acceptance letter image has been uploaded!')
    return redirect(reverse('student:uploaded_acceptance_letter'))


def uploadAcceptanceLetter300(request):
  """upload acceptance letter for 300 level student"""
  stu_usr = User.objects.get(id=request.user.id) # student user
  student = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
  coord = student.student_training_coordinator
  acceptance_300 = AcceptanceLetter.objects.filter(sender_acept=student, receiver_acept=coord, level="300").last()

  # if student.level == "300":
  #   pass
  form = UploadAcceptanceLetter(request.POST, request.FILES)
  if form.is_valid():
    if form.cleaned_data.get("image") == None and form.cleaned_data.get("message") == "":
      messages.success(request, f"You can't send blank space (empty)")
    try:
      if os.path.exists(acceptance_300.image.path):
        os.remove(acceptance_300.image.path)
    except:
      pass
    instance = form.save(commit=False)
    pic_name = picture_name(instance.image.name)
    instance.image.name = pic_name
    instance.sender_acept = student
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
  else:
    return False


def updateAcceptanceLetterRequest(request, letter_id):
  """make request to change acceptance letter"""
  stu_usr = User.objects.get(id=request.user.id) # student user
  student = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
  coord = student.student_training_coordinator
  acept_letter = AcceptanceLetter.objects.get(id=letter_id)
  form = UpdateAcceptanceLetterForm(request.POST)
  if form.is_valid():
    text = form.cleaned_data.get("text")
  instance = form.save(commit=False)
  instance.sender_acept = student
  instance.receiver_acept = coord
  instance.letter = acept_letter
  instance.text = text
  instance.level = student.level
  instance.save()
  messages.success(request, f'Your request for updating your training acceptance letter has been sent!')
  return redirect(reverse('student:uploaded_acceptance_letter'))
