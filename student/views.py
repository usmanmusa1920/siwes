import os
from datetime import datetime
from django.shortcuts import render, redirect, reverse
from django.contrib import messages
from django.db.models import Q
from django.contrib.auth import get_user_model
from .forms import (UploadAcceptance, WeekEntryForm, WeekEntryImageForm)
from toolkit import (picture_name, y_session)
from toolkit.decorators import (
    block_student_update_profile, restrict_access_student_profile, val_id_num, check_phone_number,staff_required, admin_required, vc_required, hod_required, coordinator_required, supervisor_required, schoolstaff_required, student_required, coordinator_or_student_required, supervisor_or_student_required, coordinator_or_supervisor_or_student_required
)
from administrator.models import Administrator
from administrator.tables import (
    Session, Faculty, Department, Vc, Hod, Coordinator, Supervisor, Student, Letter, Acceptance, WeekReader, WeekEntry, WeekEntryImage, Result
)
from chat.models import Message


User = get_user_model()


class StudentCls:
    """Students' related views"""
    
    def __init__(self):
        self.student = True
        
    def student_acceptance_route(self, train, faculty, department, level: str = '200', logbook=False) -> str:
        """
        This method construct a route for media files (student uploaded acceptance letter, and student weekly logbook image), when you upload a student acceptance letter via admin page this method will not run, so don`t try changing or uploading any media file (student uploaded acceptance letter, and student weekly logbook image)) via admin, to avoid route mis-functioning
        """
        if logbook:
            return f'{datetime.today().year}-logbook' + '/' + train + '/' + faculty + '/' + department + '/l' + level + '/'
        return f'{datetime.today().year}-acceptances' + '/' + train + '/' + faculty + '/' + department + '/l' + level + '/'
    
    @coordinator_or_student_required
    @staticmethod
    def profile(request, matrix_no):
        """student profile"""

        # student
        student = Student.objects.filter(matrix_no=matrix_no).first()

        # restricting any student from getting access to other students` profile
        block_other_stu = restrict_access_student_profile(request, student.matrix_no)
        if block_other_stu:
            return block_other_stu
        
        # student coordinator
        coord_id = student.student_coordinator.identification_num
        coordinator = Coordinator.objects.filter(id_no=coord_id).first()

        # filtering student uploaded acceptance letter
        acceptance_200 = Acceptance.objects.filter(sender=student, level='200').last()
        acceptance_300 = Acceptance.objects.filter(sender=student, level='300').last()

        # acceptance and placement letter for 200 level of which student `session_200` match with the letter session
        letter_200 = Letter.objects.filter(
            coordinator=coordinator, session=student.session_200).first()
        # else:
        letter_300 = Letter.objects.filter(
            coordinator=coordinator, session=student.session_300).first()
        
        context = {
            'student': student,
            'coordinator': coordinator,
            'letter_200': letter_200,
            'letter_300': letter_300,
            'acceptance_200': acceptance_200,
            'acceptance_300': acceptance_300,
        }
        return render(request, 'student/profile.html', context=context)
    
    @student_required
    @staticmethod
    def apply_training(request):
        """Student apply for 200/300 level"""
        student = Student.objects.filter(matrix_no=request.user.identification_num).first()
        
        # the following, check if the student already done his training for 200 or 300 level
        if student.level == 200 or student.level == '200':
            if student.is_apply_training_200 == True:
                messages.success(
                    request, f'Your already apply for {student.level} level training')
                return redirect(reverse('student:profile', kwargs={'matrix_no': student.matrix_no}))
        else:
            if student.is_apply_training_300 == True:
                messages.success(
                    request, f'Your already apply for {student.level} level training')
                return redirect(reverse('student:profile', kwargs={'matrix_no': student.matrix_no}))
        # coordinator from `Coordinator`
        coordinator = Coordinator.objects.filter(
            coordinator=student.student_coordinator).first()
        # current school session
        school_session = Session.objects.filter(is_current_session=True).last()

        # querying last departmental Letter (acceptance/placement), which match school active session
        current_dept_letter = Letter.objects.filter(
            session=school_session.session, coordinator=coordinator).last()
        # if the above filter of `current_dept_letter` found, it will add the student as one of the approvals of that letter
        if current_dept_letter:
            current_dept_letter.approvals.add(student)
            # checking to save a session that student apply training base on his level, and also it will checked a student boolean field for his specific level that he is (200 or 300)
            if student.level == 200 or student.level == '200':
                student.session_200 = school_session.session
                student.is_apply_training_200 = True
            else:
                student.session_300 = school_session.session
                student.is_apply_training_300 = True
            student.save()
            messages.success(
                request, f'You apply for your {student.level} level {student.faculty.training} training')
        else:
            messages.success(
                request, f'Your department have not release student training letter for this session')
        return redirect(reverse('student:profile', kwargs={'matrix_no': student.matrix_no}))
    
    @student_required
    @staticmethod
    def department_student_letter(request, letter_type, level):
        """student placement letter for 200 and 300 level"""
        student = Student.objects.filter(student=request.user).first()
        # coordinator of student
        coordinator = Coordinator.objects.filter(
            id_no=student.student_coordinator.identification_num).first()
        if level == 200 or level == '200':
            if student.is_apply_training_200 == True:
                # querying student department letter, using the letter session, getting it fron the student table, i.i the session that was save when student apply for the training base on his level
                letter = Letter.objects.filter(
                    coordinator=coordinator, session=student.session_200).first()
            else:
                return False
        else:
            if student.is_apply_training_300 == True:
                letter = Letter.objects.filter(
                    coordinator=coordinator, session=student.session_300).first()
            else:
                return False
        context = {
            'student': student,
            'letter': letter,
        }
        if letter_type == 'placement':
            return render(request, 'student/placement_letter.html', context=context)
        elif letter_type == 'acceptance':
            return render(request, 'student/acceptance_letter.html', context=context)
        
    @student_required
    @staticmethod
    def upload_acceptance_letter_page(request, level):
        """
        This view show 200 and 300 level student page, that they will upload their acceptance letter for the first time (not update page) of acceptance letter
        """
        student = Student.objects.filter(matrix_no=request.user.identification_num).first()
        coordinator = Coordinator.objects.filter(
            id_no=student.student_coordinator.identification_num).first()
        # current school session
        school_session = Session.objects.filter(is_current_session=True).last()
        # querying last departmental Letter (acceptance/placement)
        if level == 200 or level == '200':
            current_dept_letter = Letter.objects.filter(
                session=student.session_200, coordinator=coordinator).last()
        else:
            current_dept_letter = Letter.objects.filter(
                session=school_session.session, coordinator=coordinator).last()
        # acceptance letter for the student
        acceptance = Acceptance.objects.filter(
            sender=student, receiver=coordinator, letter=current_dept_letter, level=level).last()
        context = {
            'acceptance': acceptance,
            'student': student,
        }
        return render(request, 'student/upload_acceptance_letter.html', context=context)
    
    @student_required
    @staticmethod
    def upload_acceptance_letter(request, level_s):
        """
        this view will be call when a student upload his/her first acceptance letter (200 and 300) level student
        """
        student = Student.objects.filter(matrix_no=request.user.identification_num).first()
        # coordinator
        coordinator = Coordinator.objects.filter(
            id_no=student.student_coordinator.identification_num).first()
        
        # route param
        train = student.faculty.training
        faculty = student.faculty.name
        department = student.department.name
        level = student.level
        route = StudentCls.student_acceptance_route(
            'do_nothing', train, faculty, department, level)
        
        # current school session
        school_session = Session.objects.filter(is_current_session=True).last()
        # querying last departmental Letter (acceptance/placement)
        current_dept_letter = Letter.objects.filter(
            session=school_session.session, coordinator=coordinator).last()
        form = UploadAcceptance(request.POST, request.FILES)

        if form.is_valid():
            instance = form.save(commit=False)
            pic_name = picture_name(instance.image.name)
            instance.image.name = route + pic_name # new pic route
            instance.sender = student
            instance.session = school_session.session
            instance.receiver = coordinator
            instance.letter = current_dept_letter
            instance.level = level
            instance.save()

            # querying to see if whether student week raeder of his 200 level already created, if not it will create one and also fill in the student `session_200` with the current school session
            # NOTE: week reader will be created as soon as student upload acceptance letter
            WR_prev = WeekReader.objects.filter(
                student=student, acceptance=instance, session=school_session.session, level=level).last()
            if not WR_prev:
                WR = WeekReader(
                    student=student, acceptance=instance, session=school_session.session, level=level)
                WR.save()
            if level == 200 or level == '200':
                student.session_200 = school_session.session
                student.save()
            else:
                student.session_300 = school_session.session
                student.save()
            messages.success(request, f'Your {level_s} level acceptance letter image has been uploaded!')
            return redirect(reverse('student:upload_acceptance_letter_page'))
        
    @student_required
    @staticmethod
    def update_acceptance_letter_page(request, level_s):
        """
        This is a view that will show student update acceptance letter page for 200 and 300 level student
        """
        student = Student.objects.filter(matrix_no=request.user.identification_num).first()
        # coordinator
        coordinator = Coordinator.objects.filter(
            id_no=student.student_coordinator.identification_num).first()
        # current school session
        school_session = Session.objects.filter(is_current_session=True).last()
        # querying last departmental Letter (acceptance/placement)
        current_dept_letter = Letter.objects.filter(
            session=school_session.session, coordinator=coordinator).last()
        acceptance = Acceptance.objects.filter(
            sender=student, receiver=coordinator, letter=current_dept_letter, level=str(student.level)).last()
        context = {
            'form': UploadAcceptance(instance=acceptance),
            'level_s': level_s,
            'student': student,
            'acceptance': acceptance,
        }
        return render(request, 'student/update_acceptance_letter.html', context)
    
    # @student_required
    @staticmethod
    def update_acceptance_letter(request, msg_id=False):
        """
        update acceptance letter for 200 and 300 level student, this is a view that update student acceptance letter, after he/she make a request to his/her coordinator, also it is a view that update student acceptance letter, before student coordinator view his acceptance letter for the first time.
        """

        student = Student.objects.filter(matrix_no=request.user.identification_num).first()
        # coordinator
        coordinator = Coordinator.objects.filter(
            id_no=student.student_coordinator.identification_num).first()
        # current school session
        school_session = Session.objects.filter(is_current_session=True).last()
        # querying last departmental Letter (acceptance/placement)
        current_dept_letter = Letter.objects.filter(
            session=school_session.session, coordinator=coordinator).last()
        acceptance = Acceptance.objects.filter(
            sender=student, receiver=coordinator, letter=current_dept_letter, level=str(student.level)).last()
        # capturing previous acceptance letter route in other to remove it, to avoid leaving unwanted media file in file system
        if os.path.exists(acceptance.image.path):
            prev_acceptance = acceptance.image.path

        # route param
        train = student.faculty.training
        faculty = student.faculty.name
        department = student.department.name
        level = student.level
        route = StudentCls.student_acceptance_route(
            'do_nothing', train, faculty, department, level)
        
        # if acceptance letter not found it will return false
        if not acceptance:
            messages.success(
                request, f'Can\'t find your acceptance letter, contact your coordinator!')
            return redirect(reverse('landing'))
        
        if request.method == 'POST':
            form = UploadAcceptance(request.POST, request.FILES, instance=acceptance)
            if form.is_valid():
                # delete previous acceptance letter if exist
                if os.path.exists(prev_acceptance):
                    os.remove(prev_acceptance)
                instance = form.save(commit=False)
                pic_name = picture_name(instance.image.name)
                instance.image.name = route + pic_name # new pic route
                instance.save()
                
                # making the acceptance letter boolean field to their default state
                student_letter = Acceptance.objects.filter(sender=student, level=level).first()
                if student_letter:
                    student_letter.is_reviewed = False
                    student_letter.can_change = False
                    student_letter.save()
                
                # The below if condition will run only if student is going to update his acceptance letter, after sending request to his coordinator, via message page. And what it do is: looping over student messages where `is_approved_reques=True` in other to make it to `False` so that the notification in the message page will not display.
                if msg_id:
                    messg = Message.objects.get(id=msg_id)
                    sender = messg.from_sender
                    receiver = messg.to_receiver
                    for ms in Message.objects.filter(
                        from_sender=sender, to_receiver=receiver, is_approved_request=True).all():
                        ms.is_approved_request = False
                        ms.save()
                messages.success(request, f'Your {level} level acceptance letter image has been updated!')
                return redirect(reverse('student:update_acceptance_letter_page'))
            
    @coordinator_or_supervisor_or_student_required
    @staticmethod
    def logbook_entry(request, matrix_no, student_level):
        """
        This view will create a student week entry as well as the first scanned image of that week, which can be view by them and their supervisor.
        """

        # student
        student = Student.objects.filter(matrix_no=matrix_no).first()
        # route param
        train = student.faculty.training
        faculty = student.faculty.name
        department = student.department.name
        level = student.level
        route = StudentCls.student_acceptance_route(
            'do_nothing', train, faculty, department, level, logbook=True)
        # current school session
        school_session = Session.objects.filter(is_current_session=True).last()

        # # if student field of `supervisor_id_200` or `supervisor_id_300` base on his level don't have it value, it won't allow him to upload week entry, because we need to add the supervisor in the weekentry that the student want to add
        # if level == 200 or level == '200':
        #     if not student.supervisor_id_200:
        #         messages.warning(
        #             request, f'Your {level} level acceptance letter image has been updated!')
        #         return redirect(
        #             'student:logbook_entry', matrix_no=student.matrix_no, student_level=level)
        # else:
        #     if not student.supervisor_id_300:
        #         messages.warning(
        #             request, f'Your {level} level acceptance letter image has been updated!')
        #         return redirect(
        #             'student:logbook_entry', matrix_no=student.matrix_no, student_level=level)

        """control how to see if student finish his first program"""

        # filtering student week reader base on his level
        if student_level == 200 or student_level == '200':
            WR = WeekReader.objects.filter(
                student=student, session=student.session_200, level=student_level).last()
        else:
            WR = WeekReader.objects.filter(
                student=student, session=student.session_300, level=student_level).last()
            
        # increment week by one, but it doesn't save it into the database, just to make it the start of our range below (w)
        a = WR.week_no + 1

        # training duration of the department letter
        training_duration = WR.acceptance.letter.duration
        
        # sum `training_duration` with 1, to make it the end of our range below (w). Even though it can be definate by putting 12 instaed of grabbing it from foreignkey (WR.acceptance.letter.duration) i.e `training_duration`. In simple terms i mean: b = 12 + 1 instead of the below one.
        b = int(training_duration) + 1
        
        # student week range (from week 1 to week duration `training_duration`) for training programme, this make it to be variable in the template page within the loop.
        w = range(a, b)

        # convert range (w) to list in other to use it it for the loop in the template page
        weeks = list(w)

        # current week number that student is in (for his training), you notice we add one to it, this is because the initial reader is zero, so we add one so as to make the loop start from one.
        week_no = WR.week_no + 1
        
        # loogbook entry for student base on his level weeek reader
        logbook_entries = WeekEntry.objects.filter(
            student=student, week_reader=WR, level=student_level).all()
        # weekly logbook scanned images that student uploaded, they are captured here all in other display them in the log entry page, by testing each if it belong to a specific week entry within the loop in the template.
        log_images = WeekEntryImage.objects.filter(student=student).all()

        # for each week entry this (default_supervisor) is assigned, before the actuall student supervisor mark the student logbook, mean that as soon as sutudent supervisor mark student logbook, the supervisor instance will replace this default one. Reason is to avoid `Not null constraint error`
        default_supervisor = Supervisor.objects.filter(id_no='0000000000').first()

        if request.method == 'POST':
            pic_form = WeekEntryImageForm(request.POST, request.FILES)
            if pic_form.is_valid():
                # new week entry, notice the `week_no` is assign with the value of that student session reader by incrementing with one (for the first week it is 0 i.e 0 + 1, and so on)
                new_week_entry = WeekEntry(
                    student=student, commentator=default_supervisor, week_reader=WR, week_no=WR.week_no + 1, session=school_session.session, level=student_level)
                new_week_entry.save()

                # querying if student week entry exists
                if student.level == 200 or student.level == '200':
                    instance = WeekEntry.objects.filter(
                    student=student, session=student.session_200).first()
                else:
                    instance = WeekEntry.objects.filter(
                    student=student, session=student.session_300).first()
                # if it is not (exist) it will create one, with default supervisor
                if not instance:
                    instance = WeekEntry(
                        student=student, commentator=default_supervisor, week_reader=WR, session=school_session.session, level=student_level)
                    instance.save()

                # pics instance
                pic_instance = pic_form.save(commit=False)
                pic_name = picture_name(pic_instance.image.name)
                pic_instance.week_entry = new_week_entry
                pic_instance.student = student
                pic_instance.image.name = route + pic_name # new pic route
                pic_instance.save()

                # increment student week reader by one
                WR.week_no += 1
                WR.save()
                messages.success(request, f'You just upload your logbook entry for {WR.week_no} week!')
                return redirect(
                    reverse('student:logbook_entry', kwargs={'matrix_no': student.matrix_no, 'student_level': student_level}))
        else:
            form = WeekEntryForm()
            pic_form = WeekEntryImageForm()
        context = {
            'form': form,
            'pic_form': pic_form,
            'student': student,
            'WR': WR,
            'weeks': weeks,
            'week_no': week_no,
            'logbook_entries': logbook_entries,
            'log_images': log_images,
            'training_duration': training_duration,
        }
        return render(request, 'student/logbook_entry.html', context)
    
    @staticmethod
    def additional_logbook_image(request, week_entry_id):
        """
        This is a view that will fire if student want to add new (second) image for a specific week entry (the optional one) mostly said for drawing.
        """
        # student
        student = Student.objects.filter(matrix_no=request.user.identification_num).first()
        # route param
        train = student.faculty.training
        faculty = student.faculty.name
        department = student.department.name
        level = student.level
        route = StudentCls.student_acceptance_route(
            'do_nothing', train, faculty, department, level, logbook=True)
        # the week student want to add new image (second) mostly for drawing
        the_week_entry = WeekEntry.objects.get(id=week_entry_id)
        if request.method == 'POST':
            form = WeekEntryImageForm(request.POST, request.FILES)
            if form.is_valid():
                instance = form.save(commit=False)
                pic_name = picture_name(instance.image.name)
                instance.week_entry = the_week_entry
                instance.student = student
                instance.image.name = route + pic_name # new pic route
                instance.save()
                messages.success(request, f'You just upload your additional logbook entry image for {the_week_entry.week_no} week')
                return redirect(
                    reverse('student:week_entry_comment', kwargs={'week_entry_id': week_entry_id}))
            else:
                messages.success(request, f'Something went wrong when uploading your additional week entry image for {the_week_entry.week_no} week')
                return redirect(
                    reverse('student:week_entry_comment', kwargs={'week_entry_id': week_entry_id}))
            
    @supervisor_or_student_required
    @staticmethod
    def week_entry_comment(request, week_entry_id):
        """
        comment page of student weekl entry, together with supervisor comment functionality within the `form.is_valid()` condition.
        """
        if request.method == 'POST':
            form = WeekEntryForm(request.POST)
            if form.is_valid():
                g_list = [1,2,3,4,5] # grade list
                grade = form.cleaned_data.get('grade')
                comment = form.cleaned_data.get('s_comment')
                
                if grade not in g_list:
                    messages.warning(request, f'Invalid grade ({grade}), you can only grade student with {g_list} grades')
                    return redirect(reverse('student:week_entry_comment', kwargs={'week_entry_id': week_entry_id}))
                instance = WeekEntry.objects.get(id=week_entry_id)
                week_images = WeekEntryImage.objects.filter(week_entry=instance).all()
                commentator = Supervisor.objects.filter(supervisor=request.user).first()

                # replacing the default supervisor to the actual student supervisor
                instance.commentator = commentator
                instance.grade = grade
                instance.comment = comment
                instance.save()
                messages.success(request, f'You just comment on logbook entry for {instance.week_no} week of {instance.student.matrix_no}')
                return redirect(
                    reverse('student:logbook_entry', kwargs={'matrix_no': instance.student.matrix_no, 'student_level': instance.student.level}))
        else:
            form = WeekEntryForm()
        context = {
            'week_images': week_images,
            'instance': instance,
        }
        return render(request, 'student/week_entry_comment.html', context)
