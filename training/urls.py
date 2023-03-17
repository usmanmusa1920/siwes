from django.urls import path, include
from .views import trainingDirectorProfile as tdp


app_name = "training"

urlpatterns = [
  path("training/director/profile", tdp, name="training_director_profile"),
]
