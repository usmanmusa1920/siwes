from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from .models import TrainingStudent
from django.contrib.auth import get_user_model

User = get_user_model()


def studentProfile(request):
  the_student = request.user
  usr = TrainingStudent.objects.filter(student=the_student).first()
  context = {
    "None": None,
    "usr": usr,
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
