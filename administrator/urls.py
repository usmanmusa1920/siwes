from django.urls import path, include
from .views import (Administrator, Activate, Filter)


app_name = 'administrator'

urlpatterns = [
  # administration
  path('administrator/profile', Administrator.directorProfile, name='administrator_director_profile'),
  path('administrator/manager', Administrator.manager, name='administrator_manager'),

  # filter
  path('filter/staff/user', Filter.staffUser, name='filter_staff_user'),

  # activate
  path('activate/administrator/coordinator/<int:staff_user_id>/', Activate.administratorCoordinator, name='activate_training_coordinator'),
]
