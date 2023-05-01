from django.urls import path, include
from .views import (trainingDirectorProfile as tdp, trainingManager, registerTrainingCoordinator as rtc,
  activateTrainingCoordinator as atc, filterStaffUser)


app_name = "training"

urlpatterns = [
  path("training/director/profile", tdp, name="training_director_profile"),
  path("training/manager", trainingManager, name="training_manager"),
  path("filter/staff/user", filterStaffUser, name="filter_staff_user"),
  path("register/training/coordinator/", rtc, name="register_training_coordinator"),
  path("activate/training/coordinator/<int:staff_user_id>/", atc, name="activate_training_coordinator"),
]
