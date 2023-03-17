from django.shortcuts import render
from django.contrib.auth.decorators import login_required


def trainingDirectorProfile(request):
  context = {
    "None": None,
  }
  return render(request, "training/training_director_profile.html", context=context)
