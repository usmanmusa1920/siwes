from django.contrib import admin
from administrator.models import Administrator
from administrator.tables import (
    Session, Faculty, Department, Vc, Hod, Coordinator, Supervisor, Student, Letter, Acceptance, WeekReader, WeekEntry, WeekEntryImage, Result
)


admin.site.register(Student)
admin.site.register(Acceptance)
admin.site.register(WeekReader)
admin.site.register(WeekEntry)
