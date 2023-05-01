from django.urls import path, include
from .views import (trainingCoordinatorProfile as tcp, trainingCoordinatorViewStudentLetter as tcvsl, trainingCoordinatorSessionStudent as tcss,
  coordinatorAcknowledgeStudent as cas)


app_name = "department"

urlpatterns = [
  path("training/coordinator/profile/", tcp, name="training_coordinator_profile"),
  path("training/coordinator/session/student/", tcss, name="training_coordinator_session_student"),
  path("training/coordinator/view/student/letter/<int:letter_id>", tcvsl, name="training_coordinator_view_student_letter"),
  path("coordinator/acknowledge/student/<int:student_id>", cas, name="coordinator_acknowledge_student"),
]
