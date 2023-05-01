from django.shortcuts import render, redirect, reverse
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from .models import Department, DepartmentHOD, DepartmentTrainingCoordinator
from student.models import TrainingStudent, StudentLetterRequest, AcceptanceLetter
from django.contrib.auth import get_user_model

User = get_user_model()


def trainingCoordinatorProfile(request):
  coord_dept_request_user = request.user
  training_tutor = DepartmentTrainingCoordinator.objects.filter(coordinator=coord_dept_request_user).first()
  coordinator_students = TrainingStudent.objects.filter(student_training_coordinator=training_tutor)

  students_acceptances = AcceptanceLetter.objects.filter(receiver_acept=training_tutor)
  student_of_200 = TrainingStudent.objects.filter(student_training_coordinator=training_tutor, level="200")
  student_of_300 = TrainingStudent.objects.filter(student_training_coordinator=training_tutor, level="300")

  context = {
    "training_tutor": training_tutor,
    "coordinator_students": coordinator_students,
    "students_acceptances": students_acceptances,
    "student_of_200": student_of_200,
    "student_of_300": student_of_300,
  }
  return render(request, "department/training_coordinator_profile.html", context=context)


def trainingCoordinatorViewStudentLetter(request, letter_id):
  letter = AcceptanceLetter.objects.get(id=letter_id)
  letter.is_reviewed = True
  letter.can_change = False
  letter.save()
  context = {
    "letter": letter,
  }
  return render(request, "department/student_upload_acceptance_letter.html", context=context)


def acceptStudentRequestApproved(request, letter_id):
  """Accept student request (function)"""
  letter = AcceptanceLetter.objects.get(id=letter_id)
  if letter.receiver_acept.coordinator == request.user:
    letter.can_change = True
    letter.save()
    messages.success(request, f'You accept ({letter.sender_acept.matrix_no}) request to update acceptance letter')
    return redirect(reverse('department:training_coordinator_profile'))
  return False
  

def registerTrainingCoordinator(request):
  context = {
    "None": None,
  }
  return render(request, "department/register_training_coordinator.html", context=context)
  

  
def confirmRegisterTrainingCoordinator(request):
  context = {
    "None": None,
  }
  return render(request, "department/confirm_register_training_coordinator.html", context=context)
