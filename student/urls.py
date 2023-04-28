from django.urls import path, include
from .views import (studentProfile, otherViewStudentProfile, placementLetter, acceptanceLetter,
  uploadedAcceptanceLetter, uploadAcceptanceLetter200, uploadAcceptanceLetter300, requestChangeAcceptanceLetter, updateAcceptanceLetterRequest200, updateAcceptanceLetterRequest300)


app_name = "student"

urlpatterns = [
  path("student/profile", studentProfile, name="profile"),
  path("student/profile/<int:student_id>", otherViewStudentProfile, name="other_view_student_profile"),
  path("student/placement/letter", placementLetter, name="placement_letter"),
  path("student/acceptance/letter", acceptanceLetter, name="acceptance_letter"),
  path("student/upload/acceptance/letter", uploadedAcceptanceLetter, name="uploaded_acceptance_letter"),
  path("student/upload/acceptance/letter/200", uploadAcceptanceLetter200, name="upload_acceptance_letter_200"),
  path("student/upload/acceptance/letter/300", uploadAcceptanceLetter300, name="upload_acceptance_letter_300"),
  path("student/request/acceptance/letter/change/<int:letter_id>", requestChangeAcceptanceLetter, name="request_change_acceptance_letter"),
  path("student/update/acceptance/letter/<int:letter_id>/200", updateAcceptanceLetterRequest200, name="update_acceptance_letter_request_200"),
  path("student/update/acceptance/letter/<int:letter_id>/300", updateAcceptanceLetterRequest300, name="update_acceptance_letter_request_300"),
]
