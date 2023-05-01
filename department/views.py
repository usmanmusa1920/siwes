from django.shortcuts import render, redirect, reverse
from django.contrib import messages
from django.core.paginator import Paginator
from django.contrib.auth.decorators import login_required
from .models import Department, DepartmentHOD, DepartmentTrainingCoordinator
from student.models import TrainingStudent, StudentLetterRequest, AcceptanceLetter
from django.contrib.auth import get_user_model

User = get_user_model()


def trainingCoordinatorProfile(request):
  coord_dept_request_user = request.user
  training_tutor = DepartmentTrainingCoordinator.objects.filter(coordinator=coord_dept_request_user).first()

  # filtering coordinator training student
  coordinator_students = TrainingStudent.objects.filter(student_training_coordinator=training_tutor)

  # filtering coordinator training student that upload acceptance letter
  students_acceptances = AcceptanceLetter.objects.filter(receiver_acept=training_tutor)

   # filtering coordinator training student whose their level is 200
  student_of_200 = TrainingStudent.objects.filter(student_training_coordinator=training_tutor, level="200")

   # filtering coordinator training student whose their level is 300
  student_of_300 = TrainingStudent.objects.filter(student_training_coordinator=training_tutor, level="300")

  context = {
    "training_tutor": training_tutor,
    "coordinator_students": coordinator_students,
    "students_acceptances": students_acceptances,
    "student_of_200": student_of_200,
    "student_of_300": student_of_300,
  }
  return render(request, "department/training_coordinator_profile.html", context=context)


def trainingCoordinatorSessionStudent(request):
  coord_dept_request_user = request.user
  training_tutor = DepartmentTrainingCoordinator.objects.filter(coordinator=coord_dept_request_user).first()

  # filtering coordinator training student
  students_paginator = TrainingStudent.objects.filter(student_training_coordinator=training_tutor)

  paginator = Paginator(students_paginator, 3) # paginating by 3
  page = request.GET.get('page')
  coordinator_students = paginator.get_page(page)

  context = {
    "training_tutor": training_tutor,
    "coordinator_students": coordinator_students,
  }
  return render(request, "department/training_coordinator_session_student.html", context=context)


def trainingCoordinatorViewStudentLetter(request, letter_id):
  """if student departmental training coordinator view his/her acceptance letter,
  it will automatically mark it as reviewed using this view"""
  letter = AcceptanceLetter.objects.get(id=letter_id)
  letter.is_reviewed = True
  letter.can_change = False
  letter.save()
  context = {
    "letter": letter,
  }
  return render(request, "department/student_upload_acceptance_letter.html", context=context)


def coordinatorAcknowledgeStudent(request, student_id):
  # filtering student in user model using id
  student_to_add = User.objects.get(id=student_id)

  # filtering coordinator in user model using id
  coord_in_usr = User.objects.get(id=request.user.id)
  coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_in_usr.identification_num).first()
  coord.training_students.add(student_to_add)
  messages.success(request, f'You acknowledged ({student_to_add.identification_num}) into your this session student')
  return redirect('department:training_coordinator_session_student')
