from django.shortcuts import render, redirect, reverse
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from .models import Department, DepartmentHOD, DepartmentTrainingCoordinator
from student.models import TrainingStudent, StudentLetterRequest, AcceptanceLetter, UpdateAcceptanceLetter
from django.contrib.auth import get_user_model

User = get_user_model()


def trainingCoordinatorProfile(request):
  coord_dept_request_user = request.user
  training_tutor = DepartmentTrainingCoordinator.objects.filter(coordinator=coord_dept_request_user).first()
  coordinator_students = TrainingStudent.objects.filter(student_training_coordinator=training_tutor)

  students_acceptances = AcceptanceLetter.objects.filter(receiver_acept=training_tutor)
  student_of_200 = TrainingStudent.objects.filter(student_training_coordinator=training_tutor, level="200")
  student_of_300 = TrainingStudent.objects.filter(student_training_coordinator=training_tutor, level="300")

  # student that make request to change acceptance letter, after their coordinator viewed it (previous letter)
  # student_make_request = UpdateAcceptanceLetter.objects.filter(receiver_acept=training_tutor, is_approved=False)

  context = {
    "training_tutor": training_tutor,
    "coordinator_students": coordinator_students,
    "students_acceptances": students_acceptances,
    "student_of_200": student_of_200,
    "student_of_300": student_of_300,
    # "student_make_request": student_make_request,
  }
  return render(request, "department/training_coordinator_profile.html", context=context)


def trainingCoordinatorViewStudentLetter(request, letter_id):
  letter = AcceptanceLetter.objects.get(id=letter_id)
  letter.is_reviewed = True
  letter.save()

  letter_sender = letter.sender_acept
  coord = letter.receiver_acept
  student_request = UpdateAcceptanceLetter.objects.filter(sender_acept=letter_sender, receiver_acept=coord, letter=letter)
  context = {
    "letter": letter,
    "student_request": student_request,
  }
  return render(request, "department/student_upload_acceptance_letter.html", context=context)
  

def acceptStudentRequest(request, letter_id):
  """Accept student request (page)"""
  letter = UpdateAcceptanceLetter.objects.get(id=letter_id)
  if letter.receiver_acept.coordinator == request.user:
    context = {
      "letter": letter,
    }
    return render(request, "department/accept_student_request_change_acceptance_letter.html", context=context)
  return False


def acceptStudentRequestApproved(request, letter_id):
  """Accept student request (function)"""
  letter = AcceptanceLetter.objects.get(id=letter_id)
  if letter.receiver_acept.coordinator == request.user:
    letter.can_change = True
    letter.save()
    messages.success(request, f'You accept ({letter.sender_acept.matrix_no}) request to update acceptance letter')
    return redirect(reverse('department:training_coordinator_profile'))
  return False


def declineStudentRequest(request, letter_id):
  """Decline student request (page)"""
  letter = UpdateAcceptanceLetter.objects.get(id=letter_id)
  if letter.receiver_acept.coordinator == request.user:
    context = {
      "letter": letter,
    }
    return render(request, "department/decline_student_request_change_acceptance_letter.html", context=context)
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
