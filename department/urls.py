from django.urls import path, include
from .views import (Coordinator)
from .supervisor import (supervisor_student, submit_student_logbook)


app_name = 'department'

urlpatterns = [
    # profile
    path(
        'training/coordinator/profile/<int:id_no>', Coordinator.profile, name='training_coordinator_profile'),
    # student of a session
    path(
        'training/coordinator/session/student/', Coordinator.session_student, name='training_coordinator_session_student'),
    # student that ipload acceptance letter
    path(
        'training/coordinator/student/acceptance/letter', Coordinator.students_acceptance_letter, name='training_coordinator_student_acceptance_letter'),
    # view student letter and mark it as viewed
    path(
        'training/coordinator/view/student/letter/<int:letter_id>', Coordinator.view_student_letter, name='training_coordinator_view_student_letter'),
    # add student in to coordintor training student list
    path(
        'coordinator/acknowledge/student/<int:student_id>', Coordinator.acknowledge_student, name='coordinator_acknowledge_student'),
    # assign supervisor
    path(
        'assign/supervisor/<int:id_no>/<int:level>', Coordinator.assign_supervisor, name='assign_supervisor'),
    # release student result
    path(
        'release/student/result/<int:matrix_no>', Coordinator.release_student_result, name='release_result'),
    # release student result page
    path(
        'student/result/<int:matrix_no>/<int:level>/level', Coordinator.student_result, name='student_result_page'),
    # release new letter
    path(
        'new/letter', Coordinator.new_letter, name='new_letter'),
    # supervisor assign
    path(
        'supervisor/student', supervisor_student, name='supervisor_student'),
    # supervisor student logbook
    path(
        'supervisor/submit/student/logbook/<int:matrix_no>', submit_student_logbook, name='submit_student_logbook'),
]
