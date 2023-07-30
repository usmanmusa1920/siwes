from django.urls import path, include
from .views import (CoordinatorCls)
from .supervisor import (supervisor_student, submit_student_logbook)


app_name = 'department'

urlpatterns = [
    # profile
    path(
        'training/coordinator/profile/<int:id_no>', CoordinatorCls.profile, name='training_coordinator_profile'),
    # student of a session
    path(
        'training/coordinator/session/student/', CoordinatorCls.session_student, name='training_coordinator_session_student'),
    # student that upload acceptance letter
    path(
        'coordinator/student/acceptance/letter', CoordinatorCls.coordinator_student_acceptance_letter, name='coordinator_student_acceptance_letter'),
    # view student letter and mark it as viewed
    path(
        'training/coordinator/view/student/letter/<int:letter_id>', CoordinatorCls.view_student_letter, name='training_coordinator_view_student_letter'),
    # assign supervisor
    path(
        'assign/supervisor/<int:id_no>>', CoordinatorCls.assign_supervisor, name='assign_supervisor'),
    # approve student result
    path(
        'approve/student/result/<int:matrix_no>', CoordinatorCls.approve_student_result, name='approve_result'),
    # student result page
    path(
        'student/result/<int:matrix_no>/<int:level>/level', CoordinatorCls.student_result_page, name='student_result_page'),
    # release new letter
    path(
        'new/letter', CoordinatorCls.new_letter, name='new_letter'),
    # student assigned to a supervisor
    path(
        'supervisor/student', supervisor_student, name='supervisor_student'),
    # supervisor submit student logbook
    path(
        'supervisor/submit/student/logbook/<int:matrix_no>', submit_student_logbook, name='submit_student_logbook'),
]
