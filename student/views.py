import os
from datetime import datetime
from django.shortcuts import render, redirect, reverse
from django.contrib import messages
from django.db.models import Q
from django.contrib.auth.decorators import login_required
from django.contrib.auth import get_user_model
from .forms import (UploadAcceptanceLetter, UploadLogbookEntry, UploadLogbookImage, LogbookEntryComment)
from toolkit import (picture_name, y_session)
from toolkit.decorators import (
    block_student_update_profile, restrict_access_student_profile, val_id_num, check_phone_number, admin_required, dean_required, hod_required, coordinator_required, supervisor_required, schoolstaff_required, student_required, supervisor_or_student_required, coordinator_or_supervisor_or_student_required
)
from administrator.models import Administrator
from administrator.all_models import(
    Session, Faculty, Department, FacultyDean, DepartmentHOD, TrainingStudent, StudentSupervisor, DepartmentTrainingCoordinator, Letter, AcceptanceLetter, WeekReader, WeekScannedLogbook, WeekScannedImage, CommentOnLogbook, StudentResult
)
from chat.models import Message


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

        # student
        student = TrainingStudent.objects.filter(matrix_no=matrix_id).first()

        # restricting any student from getting access to other students` profile
        block_other_stu = restrict_access_student_profile(request, student.matrix_no)
        if block_other_stu:
            return block_other_stu
        
        # student coordinator
        coord_id = student.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_id).first()

        # filtering student uploaded acceptance letter
        acceptance_200 = AcceptanceLetter.objects.filter(
            sender_acept=student, level='200').last()
        acceptance_300 = AcceptanceLetter.objects.filter(
            sender_acept=student, level='300').last()

        # acceptance and placement letter for 200 level of which
        # student `session_200` match with the letter session
        letter_a_200 = Letter.objects.filter(
            letter='acceptance letter', coordinator=coord, session=student.session_200).first()
        letter_p_200 = Letter.objects.filter(
            letter='placement letter', coordinator=coord, session=student.session_200).first()

        # acceptance and placement letter for 300 level of which
        # student `session_300` match with the letter session
        letter_a_300 = Letter.objects.filter(
            letter='acceptance letter', coordinator=coord, session=student.session_300).first()
        letter_p_300 = Letter.objects.filter(
            letter='placement letter', coordinator=coord, session=student.session_300).first()
        
        context = {
            'student': student,
            'coord': coord,
            'letter_a_200': letter_a_200,
            'letter_p_200': letter_p_200,
            'letter_a_300': letter_a_300,
            'letter_p_300': letter_p_300,
            'acceptance_200': acceptance_200,
            'acceptance_300': acceptance_300,
        }
        return render(request, 'student/profile.html', context=context)
    
    @student_required
    @staticmethod
    def applyTraining(request, level):
        """Student apply for 200/300 level"""

        # current login student
        student = TrainingStudent.objects.filter(
            matrix_no=request.user.identification_num).first()
        
        # the following, check if the student already
        # done his training for 200 and 300 level
        if level == 200 or level == '200':
            if student.is_apply_training_200 == True:
                messages.success(
                    request, f'Your already apply for {level} level training')
                return redirect(reverse('student:profile', kwargs={'matrix_id': student.matrix_no}))
        else:
            if student.is_apply_training_300 == True:
                messages.success(
                    request, f'Your already apply for {level} level training')
                return redirect(reverse('student:profile', kwargs={'matrix_id': student.matrix_no}))
        
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

        # if the above filter of `current_dept_letter` found, add
        # the student in the viewers of that letter
        if current_dept_letter:
            current_dept_letter.viewers.add(student)

            # checking to save a session that student apply training base on his level
            if level == 200 or level == '200':
                student.session_200 = current_sch_sess.session
            else:
                student.session_300 = current_sch_sess.session
            student.save()
        else:
            messages.success(
                request, f'Your department have not release student training letter for this session')
            return redirect(reverse('student:profile', kwargs={'matrix_id': student.matrix_no}))
        
        # he it will check a student boolean field for his specific level that he is (200 or 300)
        if level == 200 or level == '200':
            student.is_apply_training_200=True
            student.save()
        else:
            student.is_apply_training_300=True
            student.save()
        messages.success(
            request, f'You apply for your {level} level {student.faculty.training} training')
        return redirect(reverse('student:profile', kwargs={'matrix_id': student.matrix_no}))

    @student_required
    @staticmethod
    def placementLetter(request, level):
        """student placement letter for 200 and 300 level"""

        # student
        the_student_request_user = request.user
        student = TrainingStudent.objects.filter(student=the_student_request_user).first()

        # coordinator of student
        coord_id = student.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_id).first()
        
        # letter
        if level == 200 or level == '200':
            letter = Letter.objects.filter(
                letter='placement letter', coordinator=coord, session=student.session_200).first()
        else:
            letter = Letter.objects.filter(
                letter='placement letter', coordinator=coord, session=student.session_300).first()
        # hod
        hod = DepartmentHOD.objects.filter(
            department=student.department, is_active=True).last()
        context = {
            'student': student,
            'letter': letter,
            'hod': hod,
        }
        return render(request, 'student/placement_letter.html', context=context)

    @student_required
    @staticmethod
    def acceptanceLetter(request, level):
        """student placement letter for 200 and 300 level"""

        # student
        the_student_request_user = request.user
        student = TrainingStudent.objects.filter(student=the_student_request_user).first()

        # coordinator of student
        coord_id = student.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_id).first()

        # letter
        if level == 200 or level == '200':
            letter = Letter.objects.filter(letter='acceptance letter', coordinator=coord, session=student.session_200).first()
        else:
            letter = Letter.objects.filter(letter='acceptance letter', coordinator=coord, session=student.session_300).first()
        context = {
            'student': student,
            'letter': letter,
        }
        return render(request, 'student/acceptance_letter.html', context=context)

    @student_required
    @staticmethod
    def uploadAcceptanceLetterPage(request, level):
        """This view show 200 and 300 level student page, that they will upload their acceptance letter for the first time (not update page) acceptance letter"""

        # student user
        stu_usr = User.objects.get(id=request.user.id)
        student = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()

        # coordinator
        coord_tab = student.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_tab).first()

        # acceptance letter for the student
        if level == 200 or level == '200':
            acceptance = AcceptanceLetter.objects.filter(sender_acept=student, receiver_acept=coord, level=str(level)).last()
        else:
            acceptance = AcceptanceLetter.objects.filter(sender_acept=student, receiver_acept=coord, level=str(level)).last()
        context = {
            'acceptance': acceptance,
            'level': level,
        }
        return render(request, 'student/upload_acceptance_letter.html', context=context)

    @student_required
    @staticmethod
    def uploadAcceptanceLetter(request, level_s):
        """this view will be call when a student upload his/her first acceptance letter (200 and 300) level student"""

        # student
        stu_usr = User.objects.get(id=request.user.id)  # student user
        std = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()

        # coordinator
        coord_tab = std.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_tab).first()

        train = std.faculty.training
        faculty = std.faculty.name
        department = std.department.name
        level = std.level
        route = Student.student_acceptance_route('do_nothing', train, faculty, department, level)

        # current school session
        current_sch_sess = Session.objects.filter(is_current_session=True).last()

        form = UploadAcceptanceLetter(request.POST, request.FILES)
        if form.is_valid():
            instance = form.save(commit=False)
            pic_name = picture_name(instance.image.name)
            instance.image.name = route + pic_name
            instance.sender_acept = std
            instance.session = current_sch_sess.session
            instance.receiver_acept = coord
            if level_s == '200' or level_s == 200:
                instance.level = '200'
            else:
                instance.level = '300'
            instance.save()

            # creating student weekly reader (for logbook entry for 200 level)
            if level == '200' or level == 200:
                WR_prev = WeekReader.objects.filter(
                    student=std, session=current_sch_sess.session, is_200=True).last()
                if not WR_prev:
                    WR = WeekReader(student=std, session=current_sch_sess.session, is_200=True)
                    WR.save()
                std.session_200 = current_sch_sess.session
                std.save()
            else:
                WR_prev = WeekReader.objects.filter(
                    student=std, session=current_sch_sess.session, is_300=True).last()
                if not WR_prev:
                    WR = WeekReader(student=std, session=current_sch_sess.session, is_300=True)
                    WR.save()
                std.session_300 = current_sch_sess.session
                std.save()
            messages.success(request, f'Your {level_s} level acceptance letter image has been uploaded!')
            return redirect(reverse('student:upload_acceptance_letter_page', kwargs={'level': level_s}))
    
        
    @student_required
    @staticmethod
    def updateAcceptanceLetterPage(request, level_s):
        """this is a view that will show student update acceptance letter page for 200 and 300 level student"""
        
        # student user
        stu_usr = User.objects.get(id=request.user.id)
        student = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()

        # coordinator
        coord_tab = student.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_tab).first()

        if level_s == '200' or level_s == 200:
            acceptance = AcceptanceLetter.objects.filter(sender_acept=student, receiver_acept=coord, level='200').first()
        else:
            acceptance = AcceptanceLetter.objects.filter(sender_acept=student, receiver_acept=coord, level='300').first()
        context = {
            'form': UploadAcceptanceLetter(instance=acceptance),
            'level_s': level_s,
            'student': student,
            'acceptance': acceptance,
        }
        return render(request, 'student/update_acceptance_letter.html', context)
        
    # @student_required
    @staticmethod
    def updateAcceptanceLetter(request, level_s, msg_id=False):
        """
        update acceptance letter for 200 and 300 level student
        this is a view that update student acceptance letter, after he/she make a request to his/her coordinator, also it is a view that update student acceptance letter, before student coordinator view his acceptance letter for the first time.
        """
        
        # student user
        stu_usr = User.objects.get(id=request.user.id)
        student = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()

        # coordinator
        coord_tab = student.student_training_coordinator.identification_num
        coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_tab).first()

        if level_s == '200' or level_s == 200:
            acceptance = AcceptanceLetter.objects.filter(sender_acept=student, receiver_acept=coord, level='200').first()
        else:
            acceptance = AcceptanceLetter.objects.filter(sender_acept=student, receiver_acept=coord, level='300').first()

        train = student.faculty.training
        faculty = student.faculty.name
        department = student.department.name
        level = student.level
        route = Student.student_acceptance_route('do_nothing', train, faculty, department, level)

        # current school session
        current_sch_sess = Session.objects.filter(is_current_session=True).last()

        if not acceptance:
            return False

        if request.method == 'POST':
            form = UploadAcceptanceLetter(request.POST, request.FILES, instance=acceptance)
            if form.is_valid():
                # the remove of previous acceptance is not workin, later will be arrange
                if os.path.exists(acceptance.image.path):
                    os.remove(acceptance.image.path)
                instance = form.save(commit=False)
                pic_name = picture_name(instance.image.name)
                instance.session = current_sch_sess.session
                instance.image.name = route + pic_name
                instance.save()

                if level_s == '200' or level_s == 200:
                    stu_letter = AcceptanceLetter.objects.filter(sender_acept=student, level='200').first()
                else:
                    stu_letter = AcceptanceLetter.objects.filter(sender_acept=student, level='300').first()
                if stu_letter:
                    stu_letter.is_reviewed = False
                    stu_letter.can_change = False
                    stu_letter.save()
                if msg_id:
                    # messg = Message.objects.get(id=msg_id)
                    # messg.is_expired = True
                    # messg.save()
                    for ms in Message.objects.filter(from_sender=request.user):
                        ms.is_expired = True
                        ms.save()
                messages.success(request, f'Your 200 level acceptance letter image has been updated!')
                return redirect(reverse('student:update_acceptance_letter_page', kwargs={'level_s': level_s}))
    
    @coordinator_or_supervisor_or_student_required
    @staticmethod
    def logbookEntry(request, matrix_no, student_level):
        """
        This method handle the tricks of student logbook entry per week (upload i.e scanned logbook in hardcopy), which can be view by them and their supervisor.
        """

        # student
        stu_usr = User.objects.filter(identification_num=matrix_no).first() # student user
        student = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()

        train = student.faculty.training
        faculty = student.faculty.name
        department = student.department.name
        level = student.level
        route = Student.student_acceptance_route('do_nothing', train, faculty, department, level, logbook=True)

        # filtering student week reader
        WR = WeekReader.objects.filter(student=student).last()

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
            student_lg=student, week=WR, level=student_level).all()
        log_images = WeekScannedImage.objects.filter(student=student).all()

        if request.method == 'POST':
            form = UploadLogbookEntry(request.POST)
            pic_form = UploadLogbookImage(request.POST, request.FILES)
            if form.is_valid() and pic_form.is_valid():
                instance = form.save(commit=False)
                pic_instance = pic_form.save(commit=False)
                # pic_name = picture_name(instance.image.name)
                pic_name = picture_name(pic_instance.image.name)
                # instance.image.name = route + pic_name
                pic_instance.logbook = instance
                pic_instance.student = student
                pic_instance.image.name = route + pic_name
                instance.student_lg = student
                instance.week = WR

                # incrementing the week number of (within logbook field)
                instance.week_no = WR.week_no + 1
                instance.save()
                pic_instance.save()

                # increment student week reader by one
                WR.week_no += 1
                WR.save()
                messages.success(request, f'You just upload your logbook entry for {WR.week_no} week!')
                return redirect(
                    reverse('student:logbook_entry', kwargs={'matrix_no': student.matrix_no, 'student_level': student_level}))
        else:
            form = UploadLogbookEntry()
            pic_form = UploadLogbookImage()
        context = {
            'form': form,
            'pic_form': pic_form,
            'student': student,
            'WR': WR,
            'weeks': weeks,
            'week_no': week_no,
            'logbook_entries': logbook_entries,
            'log_images': log_images,
        }
        return render(request, 'student/logbook_entry.html', context)
    
    @staticmethod
    def additionalWeekImage(request, logbook_id):
        # student
        stu_usr = request.user # student user
        student = TrainingStudent.objects.filter(matrix_no=stu_usr.identification_num).first()

        train = student.faculty.training
        faculty = student.faculty.name
        department = student.department.name
        level = student.level
        route = Student.student_acceptance_route(
            'do_nothing', train, faculty, department, level, logbook=True)
        log_parent = WeekScannedLogbook.objects.get(id=logbook_id)
        if request.method == 'POST':
            form = UploadLogbookImage(request.POST, request.FILES)
            if form.is_valid():
                instance = form.save(commit=False)
                pic_name = picture_name(instance.image.name)
                instance.logbook = log_parent
                instance.student = student
                instance.image.name = route + pic_name
                instance.save()
                messages.success(request, f'You just upload your additional logbook entry image')
                return redirect(
                    reverse('student:logbook_comment', kwargs={'logbook_id': logbook_id}))
            else:
                messages.success(request, f'Something went wrong when uploading your additional logbook entry image')
                return redirect(
                    reverse('student:logbook_comment', kwargs={'logbook_id': logbook_id}))

    @supervisor_or_student_required
    @staticmethod
    def logbookComment(request, logbook_id):
        """supervisor comment on student logbook"""
        
        logbook = WeekScannedLogbook.objects.get(id=logbook_id)
        log_images = WeekScannedImage.objects.filter(logbook=logbook).all()
        commentator = StudentSupervisor.objects.filter(supervisor=request.user).first()

        if request.method == 'POST':
            form = LogbookEntryComment(request.POST)
            if form.is_valid():
                g_list = [1,2,3,4,5] # grade list
                grade = form.cleaned_data.get('grade')
                print(grade, type(grade))
                if grade not in g_list:
                    messages.warning(request, f'Invalid grade ({grade}), you can only grade student with {g_list} grades')
                    return redirect(reverse('student:logbook_comment', kwargs={'logbook_id': logbook_id}))
                instance = form.save(commit=False)
                instance.commentator = commentator
                instance.logbook = logbook
                instance.save()
                messages.success(request, f'You just comment on logbook entry for {logbook.week_no} week of {logbook.student_lg.matrix_no}')
                return redirect(reverse('student:logbook_comment', kwargs={'logbook_id': logbook_id}))
        else:
            form = LogbookEntryComment()
        context = {
            # 'form': form,
            'log_images': log_images,
            'logbook': logbook,
        }
        return render(request, 'student/logbook_comment.html', context)
