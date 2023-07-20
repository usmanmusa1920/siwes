from django.contrib import admin
from .models import (
    TrainingStudent, AcceptanceLetter, WeekReader, WeekScannedLogbook, CommentOnLogbook)


admin.site.register(TrainingStudent)
admin.site.register(AcceptanceLetter)
admin.site.register(WeekReader)
admin.site.register(WeekScannedLogbook)
admin.site.register(CommentOnLogbook)
