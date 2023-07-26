from django import forms
from django.contrib.auth import get_user_model
from administrator.all_models import (
    AcceptanceLetter, WeekScannedLogbook, WeekScannedImage, CommentOnLogbook
)


User = get_user_model()


class UploadAcceptanceLetter(forms.ModelForm):
    """upload acceptance letter form"""
    class Meta:
        model = AcceptanceLetter
        fields = ['image']
        

class UploadLogbookEntry(forms.ModelForm):
    """upload weekly logbook entry"""
    class Meta:
        model = WeekScannedLogbook
        fields = ['title', 'text']
        

class UploadLogbookImage(forms.ModelForm):
    """
    upload weekly logbook entry (first scanned image and the second optional i.e for drawing page)
    """
    class Meta:
        model = WeekScannedImage
        fields = ['image']
        

class LogbookEntryComment(forms.ModelForm):
    """comment form for student supervisor"""
    class Meta:
        model = CommentOnLogbook
        fields = ['grade', 'comment']
