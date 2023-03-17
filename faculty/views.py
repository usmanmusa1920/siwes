from django.shortcuts import render


def facultyProfile(request):
  context = {
    "None": None,
  }
  return render(request, "faculty/profile.html", context=context)
