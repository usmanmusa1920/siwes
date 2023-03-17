from django.shortcuts import render


def trainingDirectorProfile(request):
  context = {
    "None": None,
  }
  return render(request, "training/training_director_profile.html", context=context)
