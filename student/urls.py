from django.urls import path, include
from .views import (Student)


app_name = 'student'

urlpatterns = [
    path(
        'student/profile/<int:matrix_id>', Student.profile, name='profile'),
    path(
        'student/placement/letter/<int:level>', Student.placementLetter, name='placement_letter'),
    path(
        'student/acceptance/letter/<int:level>', Student.acceptanceLetter, name='acceptance_letter'),
    path(
        'student/uploaded/acceptance/letter/<int:level>', Student.uploadedAcceptanceLetter, name='uploaded_acceptance_letter'),

    # upload acceptance letter
    path(
        'student/upload/acceptance/letter/<int:level_s>', Student.uploadAcceptanceLetter, name='upload_acceptance_letter'),

    # update acceptance letter
    path('student/update/acceptance/letter/<int:level_s>', Student.updateAcceptanceLetter, name='update_acceptance_letter'),

    # logbook
    path(
        'logbook-entry/<int:matrix_no>/<int:student_level>', Student.logbookEntry, name='logbook_entry'),
    path(
        'additional/log/image/<int:logbook_id>', Student.additionalWeekImage, name='additional_log_image'),
    path(
        'logbook/comment/<int:logbook_id>', Student.logbookComment, name='logbook_comment'),

    # apply training for a specific level
    path(
        'apply/training/<int:level>', Student.applyTraining, name='apply_training'),

    # message
    path(
        'send/message', Student.message, name='send_message'),
]
