from django.shortcuts import render
from django.contrib.auth.decorators import login_required


def studentProfile(request):
  context = {
    "None": None,
  }
  return render(request, "student/profile.html", context=context)
  


def placementLetter(request):
  context = {
    "None": None,
  }
  return render(request, "student/placement_letter.html", context=context)
  

  
def acceptanceLetter(request):
  context = {
    "None": None,
  }
  return render(request, "student/acceptance_letter.html", context=context)
