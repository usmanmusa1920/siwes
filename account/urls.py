from django.urls import path, include
from .views import LoginCustom, LogoutCustom, changePassword, Register


app_name = 'auth'

urlpatterns = [
  path('login/', LoginCustom.as_view(template_name='auth/login.html'), name='login'),
  path('logout/', LogoutCustom.as_view(template_name='auth/logout.html'), name='logout'),
  path('change/password/', changePassword, name='change_password'),
  # register route
  path('register/administrator/', Register.administrator, name='register_administrator'),
  path('register/faculty/', Register.faculty, name='register_faculty'),
  path('register/faculty/dean/', Register.facultyDean, name='register_faculty_dean'),
  path('register/department/', Register.department, name='register_department'),
  path('register/department/hod/', Register.departmentHOD, name='register_department_hod'),
  path('register/department/training/coordinator/', Register.departmentTrainingCoordinator, name='register_department_training_coordinator'),
  path('register/student/', Register.student, name='register_student'),
]
