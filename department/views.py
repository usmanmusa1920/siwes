from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from .models import Department, DepartmentHOD, DepartmentTrainingCoordinator
from student.models import TrainingStudent
from django.contrib.auth import get_user_model

User = get_user_model()


def trainingCoordinatorProfile(request):
  coord_dept = request.user
  training_tutor = DepartmentTrainingCoordinator.objects.filter(coordinator=coord_dept).first()
  coord_student = TrainingStudent.objects.filter(student_training_coordinator=training_tutor)
  context = {
    "None": None,
    "training_tutor": training_tutor,
    "coord_student": coord_student,
  }
  return render(request, "department/training_coordinator_profile.html", context=context)
  


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
