from django import forms
from .models import AcceptanceLetter, WeekScannedLogbook,CommentOnLogbook


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
