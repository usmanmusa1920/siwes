from django.contrib import admin
from .models import (
    Department, DepartmentHOD, StudentSupervisor, DepartmentTrainingCoordinator, Letter)


admin.site.register(Department)
admin.site.register(DepartmentHOD)
admin.site.register(StudentSupervisor)
admin.site.register(DepartmentTrainingCoordinator)
admin.site.register(Letter)
