from django.urls import path, include
from .views import (trainingCoordinatorProfile as tcp, registerTrainingCoordinator as rtc, confirmRegisterTrainingCoordinator as crtc)


app_name = "department"

urlpatterns = [
  path("training/coordinator/profile/", tcp, name="training_coordinator_profile"),
  path("register/training/coordinator/", rtc, name="register_training_coordinator"),
  path("confirm/register/training/coordinator/", crtc, name="confirm_register_training_coordinator"),
]
