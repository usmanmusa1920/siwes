from django.urls import path, include
from .views import (Student)


app_name = 'student'

urlpatterns = [
    path('student/profile/<int:matrix_id>', Student.profile, name='profile'),
    path(
        'student/placement/letter/200', Student.placementLetter200, name='placement_letter_200'),
    path(
        'student/acceptance/letter/200', Student.acceptanceLetter200, name='acceptance_letter_200'),
    path(
        'student/placement/letter/300', Student.placementLetter300, name='placement_letter_300'),
    path(
        'student/acceptance/letter/300', Student.acceptanceLetter300, name='acceptance_letter_300'),
    path('student/uploaded/acceptance/letter/200', Student.uploadedAcceptanceLetter200, name='uploaded_acceptance_letter_200'),
    path('student/uploaded/acceptance/letter/300', Student.uploadedAcceptanceLetter300, name='uploaded_acceptance_letter_300'),

    # upload acceptance letter
    path('student/upload/acceptance/letter/200', Student.uploadAcceptanceLetter200, name='upload_acceptance_letter_200'),
    path('student/upload/acceptance/letter/300', Student.uploadAcceptanceLetter300, name='upload_acceptance_letter_300'),

    # update acceptance letter
    path('student/update/acceptance/letter/200', Student.updateAcceptanceLetter200, name='update_acceptance_letter_200'),
    path('student/update/acceptance/letter/300', Student.updateAcceptanceLetter300, name='update_acceptance_letter_300'),

    # logbook
    path('logbook-entry/<int:matrix_no>/<int:student_level>', Student.logbookEntry, name='logbook_entry'),
    path('logbook/comment/<int:logbook_id>', Student.logbookComment, name='logbook_comment'),

    # apply training for a specific level
    path('apply/training/<int:level>', Student.applyTraining, name='apply_training'),
]
