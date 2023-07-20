import os
from datetime import datetime
from django.shortcuts import render, redirect, reverse
from django.contrib import messages
from django.db.models import Q
from django.contrib.auth.decorators import login_required
from django.contrib.auth import get_user_model
from .models import (TrainingStudent, AcceptanceLetter, WeekReader,
    WeekScannedLogbook, CommentOnLogbook)
from .forms import (UploadAcceptanceLetter, UploadLogbookEntry, LogbookEntryComment)
from toolkit import picture_name
from faculty.models import FacultyDean
from department.models import DepartmentHOD, DepartmentTrainingCoordinator, Letter
from toolkit.decorators import (
    admin_required, dean_required, hod_required, coordinator_required, supervisor_required, schoolstaff_required, student_required, check_phone_number, block_student_update_profile, restrict_access_student_profile, supervisor_or_student_required, coordinator_or_supervisor_or_student_required, val_id_num)
from administrator.all_models import Session


User = get_user_model()


class Student:
    """Students' related views"""

    def __init__(self):
        self.student = True

    def student_acceptance_route(self, train, faculty, department, level: str = '200', logbook=False) -> str:
        """
        this method costruct a route for media files (student uploaded acceptance letter),
        when you upload a media file via admin page this method will not run,
        so don`t try changing or uploading any media file via admin, to avoid
        route mis-functioning
        """
        if logbook:
            return f'{datetime.today().year}-logbook' + '/' + train + '/' + faculty + '/' + department + '/l' + level + '/'
        return f'{datetime.today().year}-acceptances' + '/' + train + '/' + faculty + '/' + department + '/l' + level + '/'

    @student_required
    @staticmethod
    def profile(request, matrix_id):
        """student profile"""
        std = TrainingStudent.objects.filter(matrix_no=matrix_id).first()

        # restricting any student from getting access to other students` profile
        block_other_stu = restrict_access_student_profile(request, std.matrix_no)
        if block_other_stu:
            return block_other_stu

        # dean = FacultyDean.objects.filter(faculty=std.faculty).last()
        # hod = DepartmentHOD.objects.filter(department=std.department).last()

        coord_id = std.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_id).first()

        acceptance_200 = AcceptanceLetter.objects.filter(sender_acept=std, level='200').last()
        acceptance_300 = AcceptanceLetter.objects.filter(sender_acept=std, level='300').last()

        # letter 200 level
        letter_a_200 = Letter.objects.filter(
            letter='acceptance letter', coordinator=coord, session=std.session_200).first()
        letter_p_200 = Letter.objects.filter(
            letter='placement letter', coordinator=coord, session=std.session_200).first()

        # # letter 300 level
        letter_a_300 = Letter.objects.filter(
            letter='acceptance letter', coordinator=coord, session=std.session_300).first()
        letter_p_300 = Letter.objects.filter(
            letter='placement letter', coordinator=coord, session=std.session_300).first()
        
        # logbook
        logbook_200 = WeekScannedLogbook.objects.filter(
            student_lg=std, level='200').first()
        logbook_300 = WeekScannedLogbook.objects.filter(
            student_lg=std, level='300').first()
        # week reader
        wr_200 = WeekReader.objects.filter(
            student=std, is_200=True).first()
        wr_300 = WeekReader.objects.filter(
            student=std, is_300=True).first()

        context = {
            'std': std,
            'letter_a_200': letter_a_200,
            'letter_p_200': letter_p_200,
            'letter_a_300': letter_a_300,
            'letter_p_300': letter_p_300,
            'acceptance_200': acceptance_200,
            'acceptance_300': acceptance_300,
            'wr_200': wr_200,
            'wr_300': wr_300,
        }
        return render(request, 'student/profile.html', context=context)
    
    @student_required
    @staticmethod
    def applyTraining(request, level):
        """Student apply for 200/300 level"""

        # current login student
        student = TrainingStudent.objects.filter(
            matrix_no=request.user.identification_num).first()
        
        # coordinator from base `User`
        coord_user = User.objects.filter(
            identification_num=student.student_training_coordinator.identification_num).first()
        
        # coordinator from `DepartmentTrainingCoordinator`
        coord = DepartmentTrainingCoordinator.objects.filter(
            coordinator=coord_user).first()
        
        # current school session
        current_sch_sess = Session.objects.filter(is_current_session=True).last()

        # querying last departmental Letter (acceptance/placement)
        current_dept_letter = Letter.objects.filter(
            session=current_sch_sess.session, coordinator=coord, letter='placement letter'
        ).last()
        if current_dept_letter:
            current_dept_letter.viewers.add(student)
        else:
            messages.success(
                request, f'Your department have not release student training letter for this session')
            return redirect(reverse('student:profile', kwargs={'matrix_id': student.matrix_no}))

        # creating student weekly reader (for logbook entry for 200 level)
        if level == '200' or level == 200:
            WR_prev = WeekReader.objects.filter(
                student=student, session=current_sch_sess.session, is_200=True).last()
            if not WR_prev:
                WR = WeekReader(student=student, session=current_sch_sess.session, is_200=True)
                WR.save()
            student.session_200 = current_sch_sess.session
            student.save()
        else:
            WR_prev = WeekReader.objects.filter(
                student=student, session=current_sch_sess.session, is_300=True).last()
            if not WR_prev:
                WR = WeekReader(student=student, session=current_sch_sess.session, is_300=True)
                WR.save()
            student.session_300 = current_sch_sess.session
            student.save()

        messages.success(
            request, f'You apply for your {level} level {student.faculty.training} training')
        return redirect(reverse('student:profile', kwargs={'matrix_id': student.matrix_no}))

    @student_required
    @staticmethod
    def placementLetter200(request):
        """student placement letter 200 level"""
        the_student_request_user = request.user
        std = TrainingStudent.objects.filter(student=the_student_request_user).first()

        coord_id = std.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_id).first()

        # letter
        letter = Letter.objects.filter(letter='placement letter', coordinator=coord, is_200=True).first()

        # dean
        dean = FacultyDean.objects.filter(faculty=std.faculty).last()

        # hod
        hod = DepartmentHOD.objects.filter(department=std.department).last()

        context = {
            'std': std,
            'letter': letter,
            'dean': dean,
            'hod': hod,
        }
        return render(request, 'student/placement_letter.html', context=context)

    @student_required
    @staticmethod
    def acceptanceLetter200(request):
        """student placement letter 200 level"""
        the_student_request_user = request.user
        std = TrainingStudent.objects.filter(student=the_student_request_user).first()

        coord_id = std.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_id).first()

        # letter
        letter = Letter.objects.filter(letter='acceptance letter', coordinator=coord, is_200=True).first()

        # dean
        dean = FacultyDean.objects.filter(faculty=std.faculty).last()

        # hod
        hod = DepartmentHOD.objects.filter(department=std.department).last()

        context = {
            'std': std,
            'letter': letter,
            'dean': dean,
            'hod': hod,
        }
        return render(request, 'student/acceptance_letter.html', context=context)

    @student_required
    @staticmethod
    def placementLetter300(request):
        """student placement letter 300 level"""
        the_student_request_user = request.user
        std = TrainingStudent.objects.filter(student=the_student_request_user).first()

        coord_id = std.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_id).first()

        # letter
        letter = Letter.objects.filter(letter='placement letter', coordinator=coord, is_300=True).first()

        # dean
        dean = FacultyDean.objects.filter(faculty=std.faculty).last()

        # hod
        hod = DepartmentHOD.objects.filter(department=std.department).last()

        context = {
            'std': std,
            'letter': letter,
            'dean': dean,
            'hod': hod,
        }
        return render(request, 'student/placement_letter.html', context=context)

    @student_required
    @staticmethod
    def acceptanceLetter300(request):
        """student placement letter 300 level"""
        the_student_request_user = request.user
        std = TrainingStudent.objects.filter(student=the_student_request_user).first()

        coord_id = std.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_id).first()

        # letter
        letter = Letter.objects.filter(letter='acceptance letter', coordinator=coord, is_300=True).first()

        # dean
        dean = FacultyDean.objects.filter(faculty=std.faculty).last()

        # hod
        hod = DepartmentHOD.objects.filter(department=std.department).last()

        context = {
            'std': std,
            'letter': letter,
            'dean': dean,
            'hod': hod,
        }
        return render(request, 'student/acceptance_letter.html', context=context)

    @student_required
    @staticmethod
    def uploadedAcceptanceLetter200(request):
        """This view show 200 level student acceptance letter"""
        stu_usr = User.objects.get(id=request.user.id)  # student user
        std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()  # training student
        # coord = std.student_training_coordinator
        coord_tab = std.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_tab).first()

        # acceptance letter for the student
        acceptance_200 = AcceptanceLetter.objects.filter(sender_acept=std, receiver_acept=coord, level='200').last()
        context = {
            'acceptance_200': acceptance_200,
        }
        return render(request, 'student/upload_acceptance_letter_200.html', context=context)

    @student_required
    @staticmethod
    def uploadedAcceptanceLetter300(request):
        """This view show 300 level student acceptance letter"""
        stu_usr = User.objects.get(id=request.user.id)  # student user
        std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()  # training student
        coord_tab = std.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_tab).first()

        # acceptance letter for the student
        acceptance_300 = AcceptanceLetter.objects.filter(sender_acept=std, receiver_acept=coord, level='300').last()
        context = {
            'acceptance_300': acceptance_300,
        }
        return render(request, 'student/upload_acceptance_letter_300.html', context=context)

    @student_required
    @staticmethod
    def uploadAcceptanceLetter200(request):
        """upload (the view that will upload) acceptance letter for 200 level student"""
        stu_usr = User.objects.get(id=request.user.id)  # student user
        std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
        # coord = std.student_training_coordinator
        coord_tab = std.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_tab).first()

        train = std.faculty.training
        faculty = std.faculty.name
        department = std.department.name
        level = std.level
        route = Student.student_acceptance_route('do_nothing', train, faculty, department, level)

        form = UploadAcceptanceLetter(request.POST, request.FILES)
        if form.is_valid():
            instance = form.save(commit=False)
            pic_name = picture_name(instance.image.name)
            instance.image.name = route + pic_name
            instance.sender_acept = std
            instance.receiver_acept = coord
            instance.level = '200'
            instance.save()
            messages.success(request, f'Your 200 level acceptance letter image has been uploaded!')
            return redirect(reverse('student:uploaded_acceptance_letter_200'))

    @student_required
    @staticmethod
    def uploadAcceptanceLetter300(request):
        """upload (the view that will upload) acceptance letter for 300 level student"""
        stu_usr = User.objects.get(id=request.user.id)  # student user
        std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
        # coord = std.student_training_coordinator
        coord_tab = std.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_tab).first()

        train = std.faculty.training
        faculty = std.faculty.name
        department = std.department.name
        level = std.level
        route = Student.student_acceptance_route('do_nothing', train, faculty, department, level)

        form = UploadAcceptanceLetter(request.POST, request.FILES)
        if form.is_valid():
            instance = form.save(commit=False)
            pic_name = picture_name(instance.image.name)
            instance.image.name = route + pic_name
            instance.sender_acept = std
            instance.receiver_acept = coord
            instance.level = '300'
            instance.save()
            messages.success(request, f'Your 300 level acceptance letter image has been uploaded!')
            return redirect(reverse('student:uploaded_acceptance_letter_300'))

    @student_required
    @staticmethod
    def updateAcceptanceLetter200(request):
        """update acceptance letter for 200 level student"""
        
        stu_usr = User.objects.get(id=request.user.id)  # student user
        std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
        # coord = std.student_training_coordinator
        coord_tab = std.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_tab).first()
        acceptance_200 = AcceptanceLetter.objects.filter(sender_acept=std, receiver_acept=coord, level='200').first()

        train = std.faculty.training
        faculty = std.faculty.name
        department = std.department.name
        level = std.level
        route = Student.student_acceptance_route('do_nothing', train, faculty, department, level)

        if not acceptance_200:
            return False

        if request.method == 'POST':
            form = UploadAcceptanceLetter(request.POST, request.FILES, instance=acceptance_200)
            if form.is_valid():
                # the remove of previous acceptance is not workin, later will be arrange
                if os.path.exists(acceptance_200.image.path):
                    os.remove(acceptance_200.image.path)
                instance = form.save(commit=False)
                pic_name = picture_name(instance.image.name)
                instance.image.name = route + pic_name
                instance.save()

                stu_letter = AcceptanceLetter.objects.filter(sender_acept=std, level='200').first()
                if stu_letter:
                    stu_letter.is_reviewed = False
                    stu_letter.can_change = False
                    stu_letter.save()
                messages.success(request, f'Your 200 level acceptance letter image has been updated!')
                return redirect(reverse('student:update_acceptance_letter_200'))
        else:
            form = UploadAcceptanceLetter(instance=acceptance_200)
        context = {
            'form': form,
            'std': std,
            'acceptance_200': acceptance_200,
        }
        return render(request, 'student/update_acceptance_letter_200.html', context)

    @student_required
    @staticmethod
    def updateAcceptanceLetter300(request):
        """update acceptance letter for 300 level student"""

        stu_usr = User.objects.get(id=request.user.id)  # student user
        std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
        # coord = std.student_training_coordinator
        coord_tab = std.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_tab).first()
        acceptance_300 = AcceptanceLetter.objects.filter(sender_acept=std, receiver_acept=coord, level='300').first()

        train = std.faculty.training
        faculty = std.faculty.name
        department = std.department.name
        level = std.level
        route = Student.student_acceptance_route('do_nothing', train, faculty, department, level)

        if not acceptance_300:
            return False

        if request.method == 'POST':
            form = UploadAcceptanceLetter(
                request.POST, request.FILES, instance=acceptance_300)
            if form.is_valid():
                # the remove of previous acceptance is not workin, later will be arrange
                if os.path.exists(acceptance_300.image.path):
                    os.remove(acceptance_300.image.path)
                instance = form.save(commit=False)
                pic_name = picture_name(instance.image.name)
                instance.image.name = route + pic_name
                instance.save()

                stu_letter = AcceptanceLetter.objects.filter(sender_acept=std, level='300').first()
                if stu_letter:
                    stu_letter.is_reviewed = False
                    stu_letter.can_change = False
                    stu_letter.save()
                messages.success(request, f'Your 300 level acceptance letter image has been updated!')
                return redirect(reverse('student:update_acceptance_letter_300'))
        else:
            form = UploadAcceptanceLetter(instance=acceptance_300)
        context = {
            'form': form,
            'std': std,
            'acceptance_300': acceptance_300,
        }
        return render(request, 'student/update_acceptance_letter_300.html', context)

    @coordinator_or_supervisor_or_student_required
    @staticmethod
    def logbookEntry(request, matrix_no, student_level):
        """
        This method handle the tricks of student logbook entry per week (upload i.e scanned logbook in hardcopy), which can be view by them and their supervisor.
        """
        stu_usr = User.objects.filter(identification_num=matrix_no).first() # student user
        std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()

        train = std.faculty.training
        faculty = std.faculty.name
        department = std.department.name
        level = std.level
        route = Student.student_acceptance_route('do_nothing', train, faculty, department, level, logbook=True)

        # filtering student week reader
        WR = WeekReader.objects.filter(student=std).last()

        # increment week by one, but it doesn't save it into the database,
        # just to make it the start of our range below (w)
        a = WR.week_no + 1

        # Increment 12 by one, to make it the end of our range below (w)
        b = 12 + 1

        # student week range (from week 1 to week 12) for 3 month training programme
        w = range(a, b)

        # convert range (w) to list in other to use it it for the loop in the template page
        weeks = list(w)

        # current week number taht student is in (for his training)
        week_no = WR.week_no + 1

        # student logbook entry instance
        logbook_entries = WeekScannedLogbook.objects.filter(
            student_lg=std, week=WR, level=student_level).all()

        if request.method == 'POST':
            form = UploadLogbookEntry(request.POST, request.FILES)
            if form.is_valid():
                instance = form.save(commit=False)
                pic_name = picture_name(instance.image.name)
                instance.image.name = route + pic_name
                instance.student_lg = std
                instance.week = WR

                # incrementing the week number of (within logbook field)
                instance.week_no = WR.week_no + 1
                instance.save()

                # increment student week reader by one
                WR.week_no += 1
                WR.save()
                messages.success(request, f'You just upload your logbook entry for {WR.week_no} week!')
                return redirect(
                    reverse('student:logbook_entry', kwargs={'matrix_no': std.matrix_no, 'student_level': student_level}))
        else:
            form = UploadLogbookEntry()
        context = {
            'form': form,
            'std': std,
            'WR': WR,
            'weeks': weeks,
            'week_no': week_no,
            'logbook_entries': logbook_entries,
        }
        return render(request, 'student/logbook_entry.html', context)

    @supervisor_or_student_required
    @staticmethod
    def logbookComment(request, logbook_id):
        """supervisor comment on student logbook"""
        
        logbook = WeekScannedLogbook.objects.get(id=logbook_id)
        stu_usr = User.objects.get(id=request.user.id)  # student user
        std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()
        comments = CommentOnLogbook.objects.filter(logbook=logbook).all()

        if request.method == 'POST':
            form = LogbookEntryComment(request.POST)
            if form.is_valid():
                instance = form.save(commit=False)
                instance.commentator = request.user
                instance.logbook = logbook
                instance.save()
                messages.success(request, f'You just comment on logbook entry for {logbook.week_no} week of {std.matrix_no}')
                return redirect(reverse('student:logbook_comment', kwargs={'logbook_id': logbook_id}))
        else:
            form = LogbookEntryComment()
        context = {
            'form': form,
            'comments': comments,
            'logbook': logbook,
        }
        return render(request, 'student/logbook_comment.html', context)
