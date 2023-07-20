from django.contrib import admin
from .models import Administrator
from .all_models import Session
from administrator.all_models import (
    Faculty, FacultyDean, Department, DepartmentHOD, DepartmentTrainingCoordinator, TrainingStudent, StudentSupervisor, Letter, AcceptanceLetter, WeekReader, WeekScannedLogbook, CommentOnLogbook, StudentResult
    )


admin.site.register(Administrator)
admin.site.register(StudentResult)
admin.site.register(Session)
