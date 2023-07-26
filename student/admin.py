from django.contrib import admin
from administrator.models import Administrator
from administrator.all_models import(
    TrainingStudent, AcceptanceLetter, WeekReader, WeekScannedLogbook, CommentOnLogbook
)


admin.site.register(TrainingStudent)
admin.site.register(AcceptanceLetter)
admin.site.register(WeekReader)
admin.site.register(WeekScannedLogbook)
admin.site.register(CommentOnLogbook)
