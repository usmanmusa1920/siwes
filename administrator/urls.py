from django.urls import path, include
from .views import (Administrator, Activate, Filter)


app_name = 'administrator'

urlpatterns = [
  # administration
  path('administrator/profile', Administrator.directorProfile, name='administrator_director_profile'),
  path('administrator/manager', Administrator.manager, name='administrator_manager'),

  # filter
  path('filter/staff/user', Filter.staffUser, name='filter_staff_user'),
  path('filter/faculty/dean', Filter.facultyDean, name='filter_faculty_dean'),
  path('filter/department/hod', Filter.departmentHod, name='filter_department_hod'),
  path('filter/department/training/coordinator', Filter.departmentTrainingCoordinator, name='filter_department_training_coordinator'),

  # activate
  path('activate/faculty/dean/<int:staff_user_id>/', Activate.facultyDean, name='activate_faculty_dean'),
  path('activate/department/hod/<int:staff_user_id>/', Activate.departmentHOD, name='activate_department_hod'),
  path('activate/department/training/coordinator/<int:staff_user_id>/', Activate.departmentTrainingCoordinator, name='activate_department_training_coordinator'),
]
