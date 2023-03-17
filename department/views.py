from django.shortcuts import render
from django.contrib.auth.decorators import login_required


def trainingCoordinatorProfile(request):
  context = {
    "None": None,
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
