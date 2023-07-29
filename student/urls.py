from django.urls import path, include
from .views import (StudentCls)


app_name = 'student'

urlpatterns = [
    # profile
    path(
        'student/profile/<int:matrix_no>', StudentCls.profile, name='profile'),
    # apply training for a specific level
    path(
        'apply/training', StudentCls.apply_training, name='apply_training'),
    # letter (placement and acceptance) letter
    path(
        'student/<str:letter_type>/letter/<int:level>', StudentCls.department_student_letter, name='department_student_letter'),
    # upload acceptance letter (page and view)
    path(
        'uploaded/acceptance/letter/page/<int:level>', StudentCls.upload_acceptance_letter_page, name='upload_acceptance_letter_page'),
    path(
        'upload/acceptance/letter/<int:level_s>', StudentCls.upload_acceptance_letter, name='upload_acceptance_letter'),
    # update acceptance letter  (page and view)
    path(
        'student/update/acceptance/letter/<int:level_s>', StudentCls.update_acceptance_letter_page, name='update_acceptance_letter_page'),
    # The below two path they actually be like (thesame) pointing at thesame view function, the reason is that in the view function argument, there is an optional key word argument called `msg_id` which will be include in the route if student want to update his acceptance letter after making a request to his coordinator {using the form field of the approved request}. The later path is used when student want to update his acceptance letter before his coordinator view it, and it does not take tha key word argument `msg_id` in the route any more.
    path(
        'student/uploaded/acceptance/letter/<int:level_s>/request/message/<int:msg_id>', StudentCls.update_acceptance_letter, name='update_acceptance_letter'),
    path(
        'student/uploaded/acceptance/letter/<int:level_s>/request/message', StudentCls.update_acceptance_letter, name='update_acceptance_letter'),
    # logbook
    path(
        'logbook-entry/<int:matrix_no>/<int:student_level>', StudentCls.logbook_entry, name='logbook_entry'),
    # additional logbook image (for drawing page)
    path(
        'additional/log/image/<int:logbook_id>', StudentCls.additional_logbook_image, name='additional_logbook_image'),
    # logbook comment
    path(
        'logbook/comment/<int:logbook_id>', StudentCls.logbook_comment, name='logbook_comment'),
]
