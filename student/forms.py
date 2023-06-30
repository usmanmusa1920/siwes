from django import forms
from .models import AcceptanceLetter, WeekScannedLogbook, CommentOnLogbook
from django.contrib.auth import get_user_model


User = get_user_model()


class UploadAcceptanceLetter(forms.ModelForm):
    class Meta:
        model = AcceptanceLetter
        fields = ['image']


class UploadLogbookEntry(forms.ModelForm):
    class Meta:
        model = WeekScannedLogbook
        fields = ['image', 'title', 'text']


class LogbookEntryComment(forms.ModelForm):
    class Meta:
        model = CommentOnLogbook
        fields = ['grade', 'comment']
