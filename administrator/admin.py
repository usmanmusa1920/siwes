from django.contrib import admin
from toolkit import (picture_name, y_session)
from toolkit.decorators import (
    block_student_update_profile, restrict_access_student_profile, val_id_num, check_phone_number,staff_required, admin_required, vc_required, hod_required, coordinator_required, supervisor_required, schoolstaff_required, student_required, coordinator_or_student_required, supervisor_or_student_required, coordinator_or_supervisor_or_student_required
)
from .models import Administrator
from administrator.tables import (
    Session, Faculty, Department, Vc, Hod, Coordinator, Supervisor, Student, Letter, Acceptance, WeekReader, WeekEntry, WeekEntryImage, Result
)


admin.site.register(Administrator)
admin.site.register(Vc)
admin.site.register(Result)
admin.site.register(Session)
admin.site.register(WeekEntryImage)
