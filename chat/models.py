from django.db import models
from django.utils import timezone
from django.conf import settings


User = settings.AUTH_USER_MODEL


class Message(models.Model):
    from_sender = models.ForeignKey(User, on_delete=models.CASCADE, related_name='from_sender')
    to_receiver = models.ForeignKey(User, on_delete=models.CASCADE, related_name='to_receiver')
    message = models.TextField(blank=True, null=True)
    image = models.ImageField(blank=True, null=True, upload_to='message_pics')
    timestamp = models.DateTimeField(default=timezone.now)
    
    # if the receiver of the message is the current logged in user, while the sender is the user you are in his message page and the message is not replied by the one the message is sent to him (current logged in user), so this will be checked, in other to notify us what to do. This `is_msg_added`, we use it to make our filter well organize in both (notification and send_message) page when querying data. I know it is actually confusing to get it at the first time!
    is_msg_added = models.BooleanField(default=False)
    
    # This `is_new_message`, we use it to see if the sender of a message, send another additional message, before he/she get reply from who he/she sent a message to
    is_new_message = models.BooleanField(default=False)
    
    # At this we filter to see if a user reply a message, before the user that sent him/her a message send another one again
    is_msg_replied = models.BooleanField(default=False)
    
    # This one it let us know if a message is seen or not
    is_view = models.BooleanField(default=False)

    # this field will be true if student make request to change acceptance letter
    is_request_to_change_img = models.BooleanField(default=False)

    # this will be true if student coordinator accept student request to change acceptance letter
    is_approved_request = models.BooleanField(default=False)

    req_level_choices = [('200', '200 level'), ('300', '300 level'),]
    req_level = models.CharField(max_length=100, default='200', choices=req_level_choices)
    
    def __str__(self):
        return f'Message send from {self.from_sender} to {self.to_receiver} on {self.timestamp} ({self.message})'
