from django.urls import path, include
from .views import (Student)


app_name = 'student'

urlpatterns = [
  path('student/profile', Student.profile, name='profile'),
  path('student/profile/update', Student.updateProfile, name='profile_update'),
  path('student/profile/<int:student_id>', Student.otherViewProfile, name='other_view_student_profile'),
  path('student/placement/letter', Student.placementLetter, name='placement_letter'),
  path('student/acceptance/letter', Student.acceptanceLetter, name='acceptance_letter'),
  path('student/uploaded/acceptance/letter/200', Student.uploadedAcceptanceLetter200, name='uploaded_acceptance_letter_200'),
  path('student/uploaded/acceptance/letter/300', Student.uploadedAcceptanceLetter300, name='uploaded_acceptance_letter_300'),

  path('student/upload/acceptance/letter/200', Student.uploadAcceptanceLetter200, name='upload_acceptance_letter_200'),
  path('student/upload/acceptance/letter/300', Student.uploadAcceptanceLetter300, name='upload_acceptance_letter_300'),

  path('student/update/acceptance/letter/200', Student.updateAcceptanceLetter200, name='update_acceptance_letter_200'),
  path('student/update/acceptance/letter/300', Student.updateAcceptanceLetter300, name='update_acceptance_letter_300'),

  path('logbook-entry', Student.logbookEntry, name='logbook_entry'),
  path('logbook/comment/<int:logbook_id>', Student.logbookComment, name='logbook_comment'),
]
