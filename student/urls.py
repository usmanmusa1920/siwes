from django.urls import path, include
from .views import (Student)


app_name = 'student'

urlpatterns = [
    # profile
    path(
        'student/profile/<int:matrix_id>', Student.profile, name='profile'),
    # apply training for a specific level
    path(
        'apply/training/<int:level>', Student.apply_training, name='apply_training'),
    # letter (placement and acceptance) letter
    path(
        'student/placement/letter/<int:level>', Student.placement_letter, name='placement_letter'),
    path(
        'student/acceptance/letter/<int:level>', Student.acceptance_letter, name='acceptance_letter'),
    # upload acceptance letter (page and view)
    path(
        'student/uploaded/acceptance/letter/page/<int:level>', Student.upload_acceptance_letter_page, name='upload_acceptance_letter_page'),
    path(
        'student/upload/acceptance/letter/<int:level_s>', Student.upload_acceptance_letter, name='upload_acceptance_letter'),
    # update acceptance letter  (page and view)
    path(
        'student/update/acceptance/letter/<int:level_s>', Student.update_acceptance_letter_page, name='update_acceptance_letter_page'),
    # The below two path they actually be like (thesame) pointing at thesame view function, the reason is that in the view function argument, there is an optional key word argument called `msg_id` which will be include in the route if student want to update his acceptance letter after making a request to his coordinator {using the form field of the approved request}. The later path is used when student want to update his acceptance letter before his coordinator view it, and it does not take tha key word argument `msg_id` in the route any more.
    path(
        'student/uploaded/acceptance/letter/<int:level_s>/request/message/<int:msg_id>', Student.update_acceptance_letter, name='update_acceptance_letter'),
    path(
        'student/uploaded/acceptance/letter/<int:level_s>/request/message', Student.update_acceptance_letter, name='update_acceptance_letter'),
    # logbook
    path(
        'logbook-entry/<int:matrix_no>/<int:student_level>', Student.logbook_entry, name='logbook_entry'),
    # additional logbook image (for drawing page)
    path(
        'additional/log/image/<int:logbook_id>', Student.additional_logbook_image, name='additional_logbook_image'),
    # logbook comment
    path(
        'logbook/comment/<int:logbook_id>', Student.logbook_comment, name='logbook_comment'),
]
