from django.urls import path, include
from .views import studentProfile, placementLetter, acceptanceLetter


app_name = "student"

urlpatterns = [
  path("student/profile", studentProfile, name="profile"),
  path("student/placement/letter", placementLetter, name="placement_letter"),
  path("student/acceptance/letter", acceptanceLetter, name="acceptance_letter"),
]
