from django import forms
from .models import Message


class MessageForm(forms.ModelForm):
    """send message form"""
    class Meta:
        model = Message
        fields = ['message', 'image']
