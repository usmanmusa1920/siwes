from django.urls import path, include
from .views import (Administrator)


app_name = 'administrator'

urlpatterns = [
  path('administrator/profile', Administrator.directorProfile, name='administrator_director_profile'),
  path('administrator/manager', Administrator.manager, name='administrator_manager'),
  path('filter/staff/user', Administrator.filterStaffUser, name='filter_staff_user'),
  path('register/administrator/coordinator/', Administrator.registerAdministratorCoordinator, name='register_training_coordinator'),
  path('activate/administrator/coordinator/<int:staff_user_id>/', Administrator.activateAdministratorCoordinator, name='activate_training_coordinator'),
]
