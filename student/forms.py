from django import forms
from .models import AcceptanceLetter, UpdateAcceptanceLetter


class UploadAcceptanceLetter(forms.ModelForm):
  class Meta:
    model = AcceptanceLetter
    fields = ['image']

    
class UpdateAcceptanceLetterForm(forms.ModelForm):
  class Meta:
    model = UpdateAcceptanceLetter
    fields = ['text']
