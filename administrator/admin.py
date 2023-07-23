from django.contrib import admin
from toolkit import (picture_name, y_session)
from toolkit.decorators import (
    block_student_update_profile, restrict_access_student_profile, val_id_num, check_phone_number, admin_required, dean_required, hod_required, coordinator_required, supervisor_required, schoolstaff_required, student_required, supervisor_or_student_required, coordinator_or_supervisor_or_student_required
)
from .models import Administrator
from .all_models import(
    Session, Faculty, Department, SchoolVC, FacultyDean, DepartmentHOD, TrainingStudent, StudentSupervisor, DepartmentTrainingCoordinator, Letter, AcceptanceLetter, WeekReader, WeekScannedLogbook, WeekScannedImage, CommentOnLogbook, StudentResult
)


admin.site.register(Administrator)
admin.site.register(SchoolVC)
admin.site.register(StudentResult)
admin.site.register(Session)
admin.site.register(WeekScannedImage)
