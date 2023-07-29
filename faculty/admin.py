from django.contrib import admin
# from administrator.all_models import(
#     Session, Faculty, Department, FacultyDean, DepartmentHOD, TrainingStudent, StudentSupervisor, DepartmentTrainingCoordinator, Letter, AcceptanceLetter, WeekReader, WeekScannedLogbook, CommentOnLogbook, StudentResult
# )
from administrator.tables import (
    Session, Faculty, Department, Vc, Hod, Coordinator, Supervisor, Student, Letter, Acceptance, WeekReader, WeekEntry, WeekEntryImage, Result
)


admin.site.register(Faculty)
# admin.site.register(FacultyDean)
