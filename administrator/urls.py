from django.urls import path, include
from .views import (Activate, Filter, Active)


app_name = 'administrator'

urlpatterns = [
    # active (incumbent) staff base on ranks
    path('active/faculty/dean', Active.facultyDean, name='active_faculty_dean'),
    path('active/department/hod', Active.departmentHod, name='active_department_hod'),
    path('active/department/training/coordinator', Active.departmentTrainingCoordinator, name='active_department_training_coord'),

    # activate (new staff to take position)
    path('activate/faculty/dean/<int:staff_user_id>/', Activate.facultyDean, name='activate_faculty_dean'),
    path('activate/department/hod/<int:staff_user_id>/', Activate.departmentHOD, name='activate_department_hod'),
    path('activate/department/training/coordinator/<int:staff_user_id>/', Activate.departmentTrainingCoordinator, name='activate_department_training_coordinator'),

    # filter users
    path('filter/staff', Filter.staff, name='filter_staff'),
    path('filter/administrator', Filter.administrator, name='filter_administrator'),
    path('filter/faculty/dean', Filter.facultyDean, name='filter_faculty_dean'),
    path('filter/department/hod', Filter.departmentHod, name='filter_department_hod'),
    path('filter/department/training/coordinator', Filter.departmentTrainingCoordinator, name='filter_department_training_coordinator'),
    path('filter/student/supervisor', Filter.studentSupervisor, name='filter_student_supervisor'),
    path('filter/student', Filter.student, name='filter_student'),
]
