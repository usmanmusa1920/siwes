from django.urls import path, include
from .views import (
    request_to_change_acceptance_letter, approve_request, decline_request, notification, send_message
)


app_name = 'chat'

urlpatterns = [
    # student request to change acceptance letter
    path(
        'request/to/change/acceptance/letter', request_to_change_acceptance_letter, name='request_to_change_acceptance_letter'),
    # approve request
    path(
        'approve/request/<int:msg_id>', approve_request, name='approve_request'),
    # decline request
    path(
        'decline/request/<int:msg_id>', decline_request, name='decline_request'),
    # notification
    path(
        'notification', notification, name='notification'),
    # send message
    path(
        'send/message/<int:user_id>', send_message, name='send_message'),
]
