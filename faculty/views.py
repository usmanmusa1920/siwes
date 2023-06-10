from django.shortcuts import render
from django.contrib.auth.decorators import login_required


@login_required
def facultyProfile(request):
  """faculty profile page"""
  context = {
    'None': None,
  }
  return render(request, 'faculty/profile.html', context=context)
