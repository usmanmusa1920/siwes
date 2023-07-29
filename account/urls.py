from django.urls import path, include
from .views import (
    LoginCustom, LogoutCustom, change_password, Register, Update)
from .profile import generalProfile


app_name = 'auth'

urlpatterns = [
    # general profile
    path(
        'general/profile/<int:id_no>', generalProfile, name='general_profile'),

    # login
    path(
        'login/', LoginCustom.as_view(template_name='auth/login.html'), name='login'),
    # logout
    path(
        'logout/', LogoutCustom.as_view(template_name='auth/logout.html'), name='logout'),
    # change password
    path(
        'change/password/', change_password, name='change_password'),

    # register new session
    path(
        'new/session', Register.session, name='new_session'),

    # register new administrator
    path(
        'register/administrator/', Register.administrator, name='register_administrator'),
    # register new faculty
    path(
        'register/faculty/', Register.faculty, name='register_faculty'),
    # register new department
    path(
        'register/department/', Register.department, name='register_department'),
    # register new vc
    path(
        'register/school/vc/', Register.school_vc, name='register_school_vc'),
    # register new hod
    path(
        'register/department/hod/', Register.department_hod, name='register_department_hod'),
    # register new coordinator
    path(
        'register/department/training/coordinator/', Register.department_training_coordinator, name='register_department_training_coordinator'),
    # register new supervisor
    path(
        'register/student/training/supervisor/', Register.student_training_supervisor, name='register_student_training_coordinatro'),
    # register new student
    path(
        'register/student/', Register.student, name='register_student'),

    # student update profile info...
    path(
        'student/profile/update', Update.student_info, name='student_profile_update'),
    # update profile image
    path(
        'update/profile', Update.profile_image, name='update_profile_img'),
]
