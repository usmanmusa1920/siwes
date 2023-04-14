from django import forms
from .models import AcceptanceLetter


class UploadAcceptanceLetter(forms.ModelForm):
  class Meta:
    model = AcceptanceLetter
    fields = ['image']
