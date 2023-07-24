from django.urls import path, include
from .views import (
    request_to_change_acceptance_letter, approve_request, notification, sendMessage)


app_name = 'chat'

urlpatterns = [
    # approve request
    path(
        'approve/request/<int:msg_id>', approve_request, name='approve_request'),
    # request
    path(
        'request/to/change/acceptance/letter', request_to_change_acceptance_letter, name='req_change_acceptance_letter'),
    # notification
    path(
        'notification', notification, name='notification'),
    # message
    path(
        'send/message/<int:user_id>', sendMessage, name='send_message'),
]
