from django.urls import path, include
from .views import (DepartmentCls, Coordinator)


app_name = 'department'

urlpatterns = [
    path('training/coordinator/profile/<int:id_no>', Coordinator.profile, name='training_coordinator_profile'),
    path('training/coordinator/session/student/', Coordinator.sessionStudent, name='training_coordinator_session_student'),
    path('training/coordinator/view/student/letter/<int:letter_id>', Coordinator.viewStudentLetter, name='training_coordinator_view_student_letter'),
    path('coordinator/acknowledge/student/<int:student_id>', Coordinator.acknowledgeStudent, name='coordinator_acknowledge_student'),
    path('department/<str:dept_name>/students', DepartmentCls.students, name='department_students'),
    path('department/<int:level>/students/level', DepartmentCls.studentsLevel, name='department_students_level'),
]
