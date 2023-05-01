from django.urls import path, include
from .views import (trainingCoordinatorProfile as tcp, registerTrainingCoordinator as rtc,
  confirmRegisterTrainingCoordinator as crtc, acceptStudentRequestApproved as asra, trainingCoordinatorViewStudentLetter as tcvsl)


app_name = "department"

urlpatterns = [
  path("training/coordinator/profile/", tcp, name="training_coordinator_profile"),
  path("register/training/coordinator/", rtc, name="register_training_coordinator"),
  path("confirm/register/training/coordinator/", crtc, name="confirm_register_training_coordinator"),
  path("accept/student/request/<int:letter_id>/approved", asra, name="accept_student_request_approved"),
  path("training/coordinator/view/student/letter/<int:letter_id>", tcvsl, name="training_coordinator_view_student_letter"),
]
