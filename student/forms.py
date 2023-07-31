from django import forms
from django.contrib.auth import get_user_model
from administrator.tables import (
    Session, Faculty, Department, Vc, Hod, Coordinator, Supervisor, Student, Letter, Acceptance, WeekReader, WeekEntry, WeekEntryImage, Result
)


User = get_user_model()


class UploadAcceptance(forms.ModelForm):
    """upload acceptance letter form"""
    class Meta:
        model = Acceptance
        fields = ['image']
        

class WeekEntryForm(forms.ModelForm):
    """upload weekly logbook entry"""
    class Meta:
        model = WeekEntry
        fields = ['grade', 'comment']
        

class WeekEntryImageForm(forms.ModelForm):
    """
    upload weekly logbook entry (first scanned image and the second optional i.e for drawing page)
    """
    class Meta:
        model = WeekEntryImage
        fields = ['image']
