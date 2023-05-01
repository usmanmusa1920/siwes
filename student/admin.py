from django.contrib import admin
from .models import TrainingStudent, StudentLetterRequest, AcceptanceLetter

admin.site.register(TrainingStudent)
admin.site.register(StudentLetterRequest)
admin.site.register(AcceptanceLetter)
