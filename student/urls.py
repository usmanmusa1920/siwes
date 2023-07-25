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

    # upload acceptance letter
    path(
        'student/uploaded/acceptance/letter/page/<int:level>', Student.uploadAcceptanceLetterPage, name='upload_acceptance_letter_page'),
    path(
        'student/upload/acceptance/letter/<int:level_s>', Student.uploadAcceptanceLetter, name='upload_acceptance_letter'),

    # update acceptance letter
    path(
        'student/update/acceptance/letter/<int:level_s>', Student.updateAcceptanceLetterPage, name='update_acceptance_letter_page'),
    # the below two path they actually be like (thesame) pointing at thesame view function, the reason is that in the view function argument, there is an optional key word argument called `msg_id` which will be include in the route if student want to update his acceptance letter after making a request to his coordinator {using the form field of the approved request}. The later path is used when student want to update his acceptance letter before his coordinatorview it, and it does not take tha key word argument `msg_id` inthe route
    path(
        'student/uploaded/acceptance/letter/<int:level_s>/request/message/<int:msg_id>', Student.updateAcceptanceLetter, name='update_acceptance_letter'),
    path(
        'student/uploaded/acceptance/letter/<int:level_s>/request/message', Student.updateAcceptanceLetter, name='update_acceptance_letter'),

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
]
