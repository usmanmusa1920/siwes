from django.urls import path, include
from .views import (Activate, Filter, Active)
from .department import DepartmentCls


app_name = 'administrator'

urlpatterns = [
    # department
    path(
        'department/<str:dept_name>/students', DepartmentCls.students, name='department_students'),
    path(
        'department/<int:level>/students/level', DepartmentCls.students_level, name='students_level'),

    # active (incumbent) staff base on ranks
    path(
        'active/faculty/dean', Active.vc, name='active_vc'),
    path(
        'active/department/hod', Active.department_hod, name='active_department_hod'),
    path(
        'active/department/training/coordinator', Active.department_training_coordinator, name='active_department_training_coord'),

    # activate (new staff to take position)
    path(
        'activate/faculty/dean/<int:staff_user_id>/', Activate.vc, name='activate_vc'),
    path(
        'activate/department/hod/<int:staff_user_id>/', Activate.department_hod, name='activate_department_hod'),
    path(
        'activate/department/training/coordinator/<int:staff_user_id>/', Activate.department_training_coordinator, name='activate_department_training_coordinator'),

    # filter users
    path(
        'filter/staff', Filter.staff, name='filter_staff'),
    path(
        'filter/administrator', Filter.administrator, name='filter_administrator'),
    path(
        'filter/faculty/dean', Filter.vc, name='filter_vc'),
    path(
        'filter/department/hod', Filter.department_hod, name='filter_department_hod'),
    path(
        'filter/department/training/coordinator', Filter.department_training_coordinator, name='filter_department_training_coordinator'),
    path(
        'filter/student/supervisor', Filter.student_supervisor, name='filter_student_supervisor'),
    path(
        'filter/student', Filter.student, name='filter_student'),
]
