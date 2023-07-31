import os
from django.urls import reverse
from django.shortcuts import render, redirect, HttpResponseRedirect
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.contrib.auth.views import LoginView, LogoutView
from django.contrib.sites.shortcuts import get_current_site
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth import update_session_auth_hash
from django.contrib.auth import get_user_model
from .forms import (
    PasswordChangeForm, AdministratorSignupForm, FacultySignupForm, VcDeanHodSignupForm, DepartmentSignupForm, CoordinatorSignupForm, SupervisorSignupForm, StudentSignupForm, UpdateStudentProfile, UpdateProfileImage
)
from toolkit import (picture_name, y_session)
from toolkit.decorators import (
    block_student_update_profile, restrict_access_student_profile, val_id_num, check_phone_number,staff_required, admin_required, vc_required, hod_required, coordinator_required, supervisor_required, schoolstaff_required, student_required, coordinator_or_student_required, supervisor_or_student_required, coordinator_or_supervisor_or_student_required
)
from chat.models import Message
from administrator.models import Administrator
from toolkit import (picture_name, y_session)
from administrator.tables import (
    Session, Faculty, Department, Vc, Hod, Coordinator, Supervisor, Student, Letter, Acceptance, WeekReader, WeekEntry, WeekEntryImage, Result
)
# from student.views import StudentCls


User = get_user_model()


class LoginCustom(LoginView):
    """account login class"""

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        current_site = get_current_site(self.request)
        context.update({
            self.redirect_field_name: self.get_redirect_url(),
            'site': current_site,
            'site_name': current_site.name,
            **(self.extra_context or {})
        })
        return context


class LogoutCustom(LoginRequiredMixin, LogoutView):
    """account logout class"""

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        current_site = get_current_site(self.request)
        context.update({
            'site': current_site,
            'site_name': current_site.name,
            # 'title': _('Logged out'),
            **(self.extra_context or {})
        })
        return context


@login_required
def change_password(request):
    """change account password view"""

    if request.user.is_authenticated:
        form = PasswordChangeForm(user=request.user, data=request.POST or None)
        if form.is_valid():
            form.save()
            update_session_auth_hash(request, form.user)
            messages.success(request, f'That sound great {request.user.first_name}, your password has been changed')
            return redirect(reverse('landing'))
        else:
            context = {
                'form': form
            }
            return render(request, 'auth/change_password.html', context)
    return False


class Register:
    """
    These class includes class methods (views) for registering new (asession, administrator, faculty, department, VC, dean, HOD, coordinator, supervisor, and student) profiles
    """

    @admin_required
    @staticmethod
    def session(request):
        """register new session"""
        
        # Querying a session that the `is_current_session=True` is marked as current sesson, also the last one, which with the previous session data it will be able to create new session data.
        last_prev_sess = Session.objects.filter(is_current_session=True).last()
        if last_prev_sess:
            # grabing session data from `last_prev_sess`
            a_sess = last_prev_sess.session
            b_sess = a_sess.split('/') # making it a list
            c_sess = int(b_sess[0])+1 # taking index 0 of the list and plus it with one
            d_sess = int(b_sess[1])+1 # taking index 1 of the list and plus it with one

            # new session, by joining `c_sess` and `d_sess` in between them with forward slash `/`
            new_session = '/'.join([str(c_sess), str(d_sess)])
        else:
            # if there is no any marked `is_current_session=True` of session it will create one using the current year we are and the next year we will enter using `y_session` function.
            new_session = y_session()
        if request.method == 'POST':
            # deactivating any `is_current_session` which is True to False
            prev_sess = Session.objects.filter(is_current_session=True)
            for sess in prev_sess:
                sess.is_current_session = False
                sess.save()

            # if we find the query `last_prev_sess`, we will use it for the following tricks, else if we don`t find the query, it will create new one using `y_session` function which was been given as default in the Session table.
            if last_prev_sess:
                new_sess = Session(session=new_session, is_current_session=True)
            else:
                new_sess = Session(is_current_session=True)
            new_sess.save()

            messages.success(
                request, f'New session ({new_session}) for the school training (siwes/TP) programm created')
            return redirect('landing')
        context = {
            'new_session': new_session,
        }
        return render(request, 'auth/new_session.html', context)

    @check_phone_number(redirect_where='auth:register_administrator')
    @admin_required
    @staticmethod
    def administrator(request):
        """
        register administrator
        
        when creating new administrator a signal will fire, which will automatically create administrator in the seperate table of administrator. But in this view it only query the administrator in other to assign his/her description if provided when registering the user
        """

        if request.method == 'POST':
            form = AdministratorSignupForm(request.POST)
            if form.is_valid():
                instance = form.save(commit=False)
                instance.is_superuser = True
                instance.is_staff = True
                instance.is_admin = True
                instance.is_schoolstaff = True
                instance.save()

                # grabbing user raw datas (from html form)
                raw_identification_num = form.cleaned_data['identification_num']
                raw_description = form.cleaned_data['description']

                # filtering created admin in other to assign his/her description (if provided) because the description field is optional
                new_administrator = Administrator.objects.filter(
                    id_no=instance.identification_num).first()
                new_administrator.description = raw_description
                new_administrator.save()

                messages.success(
                    request, f'New user with ID number of {raw_identification_num} has been registered as an administrator!')
                return redirect('auth:general_profile', id_no=raw_identification_num)
        else:
            form = AdministratorSignupForm()
        context = {
            'form': form,
            'who_to_reg': 'administrator',
        }
        return render(request, 'auth/register.html', context)

    @check_phone_number(redirect_where='auth:register_faculty')
    @admin_required
    @staticmethod
    def faculty(request):
        """register faculty"""
        
        if request.method == 'POST':
            form = FacultySignupForm(request.POST)
            if form.is_valid():
                form.save()
                # grabbing user raw datas (from html form)
                raw_name = form.cleaned_data['name']
                messages.success(
                    request, f'New faculty with name of {raw_name} has been registered!')
                return redirect('auth:register_faculty')
        else:
            form = FacultySignupForm()
        context = {
            'form': form,
            'who_to_reg': 'faculty',
        }
        return render(request, 'auth/register.html', context)

    @check_phone_number(redirect_where='auth:register_department')
    @admin_required
    @staticmethod
    def department(request):
        """register department"""

        faculties = Faculty.objects.all()
        if request.method == 'POST':
            form = DepartmentSignupForm(request.POST)
            if form.is_valid():
                instance = form.save(commit=False)

                # grabbing user raw datas (from html form)
                raw_name = form.cleaned_data['name']
                raw_faculty = request.POST['raw_faculty']

                db_faculty = Faculty.objects.filter(name=raw_faculty).first()
                instance.faculty = db_faculty
                instance.save()

                messages.success(
                    request, f'New department with name of {raw_name} has been registered!')
                return redirect('auth:register_department')
        else:
            form = DepartmentSignupForm()
        context = {
            'form': form,
            'faculties': faculties,
            'who_to_reg': 'department',
        }
        return render(request, 'auth/register.html', context)

    @check_phone_number(redirect_where='auth:register_department_hod')
    @admin_required
    @staticmethod
    def school_vc(request):
        """register VC"""

        # quering departments, which we will be rendering in templates
        departments = Department.objects.all()
        
        if request.method == 'POST':
            form = VcDeanHodSignupForm(request.POST)
            print(form.errors)
            if form.is_valid():
                instance = form.save(commit=False)
                instance.is_vc = True
                instance.is_schoolstaff = True
                instance.save()

                # grabbing user raw datas (from html form)
                raw_identification_num = form.cleaned_data['identification_num']
                raw_ranks = form.cleaned_data['ranks']
                raw_level_rank_title_1 = form.cleaned_data['level_rank_title_1']
                raw_level_rank_title_2 = form.cleaned_data['level_rank_title_2']
                raw_dept = request.POST['raw_dept']
                raw_other_email = request.POST['other_email']
                raw_other_phone = request.POST['other_phone']
                raw_professorship = request.POST['professorship']
                
                db_dept = Department.objects.filter(name=raw_dept).first()
                faculty_name = db_dept.faculty.name
                db_faculty = Faculty.objects.filter(name=faculty_name).first()

                # deactivating old vc
                old_active_vc = Vc.objects.filter(is_active=True)
                if old_active_vc:
                    for old in old_active_vc:
                        old.is_active = False
                        old.save()

                # creating user (in the school vc table)
                new_dept_hod = Vc(
                    vc=instance, faculty=db_faculty, department=db_dept, ranks=raw_ranks, first_name=instance.first_name, middle_name=instance.middle_name, last_name=instance.last_name, gender=instance.gender, date_of_birth=instance.date_of_birth, id_no=instance.identification_num, email=instance.email, phone_number=instance.phone_number, level_rank_title_1=raw_level_rank_title_1, level_rank_title_2=raw_level_rank_title_2, email_other=raw_other_email, phone_number_other=raw_other_phone, professorship=raw_professorship, is_active=True
                )
                new_dept_hod.save()
                messages.success(
                    request, f'Staff with ID number of {raw_identification_num} has been registered as new VC of the school!')
                return redirect('auth:general_profile', id_no=raw_identification_num)
        else:
            form = VcDeanHodSignupForm()
        context = {
            'form': form,
            'departments': departments,
            'who_to_reg': 'vc',
        }
        return render(request, 'auth/register.html', context)

    @check_phone_number(redirect_where='auth:register_department_hod')
    @admin_required
    @staticmethod
    def department_hod(request):
        """register department hod"""

        # quering departments, which we will be rendering in templates
        departments = Department.objects.all()

        if request.method == 'POST':
            form = VcDeanHodSignupForm(request.POST)
            if form.is_valid():
                instance = form.save(commit=False)
                instance.is_hod = True
                instance.is_schoolstaff = True
                instance.save()

                # grabbing user raw datas (from html form)
                raw_identification_num = form.cleaned_data['identification_num']
                raw_ranks = form.cleaned_data['ranks']
                raw_level_rank_title_1 = form.cleaned_data['level_rank_title_1']
                raw_level_rank_title_2 = form.cleaned_data['level_rank_title_2']
                raw_dept = request.POST['raw_dept']
                raw_other_email = request.POST['other_email']
                raw_other_phone = request.POST['other_phone']
                
                db_dept = Department.objects.filter(name=raw_dept).first()
                faculty_name = db_dept.faculty.name
                db_faculty = Faculty.objects.filter(name=faculty_name).first()

                # deactivating old hod
                old_active_hod = Hod.objects.filter(department=db_dept, is_active=True)
                if old_active_hod:
                    for old in old_active_hod:
                        old.is_active = False
                        old.save()

                # creating user (in the department hod table)
                new_dept_hod = Hod(
                    hod=instance, faculty=db_faculty, department=db_dept, ranks=raw_ranks, first_name=instance.first_name, middle_name=instance.middle_name, last_name=instance.last_name, gender=instance.gender, date_of_birth=instance.date_of_birth, id_no=instance.identification_num, email=instance.email, phone_number=instance.phone_number, level_rank_title_1=raw_level_rank_title_1, level_rank_title_2=raw_level_rank_title_2, email_other=raw_other_email, phone_number_other=raw_other_phone, is_active=True
                )
                new_dept_hod.save()
                messages.success(
                    request, f'Staff with ID number of {raw_identification_num} has been registered as new department of {raw_dept} HOD!')
                return redirect('auth:general_profile', id_no=raw_identification_num)
        else:
            form = VcDeanHodSignupForm()
        context = {
            'form': form,
            'departments': departments,
            'who_to_reg': 'hod',
        }
        return render(request, 'auth/register.html', context)

    @check_phone_number(redirect_where='auth:register_department_training_coordinator')
    @admin_required
    @staticmethod
    def department_training_coordinator(request):
        """register department training coordinator"""

        # quering departments active hod, which we will be rendering in templates
        # all_dept_hod = Hod.objects.filter(is_active=True)
        # quering departments, which we will be rendering in templates
        departments = Department.objects.all()

        if request.method == 'POST':
            form = CoordinatorSignupForm(request.POST)
            if form.is_valid():
                instance = form.save(commit=False)
                instance.is_coordinator = True
                instance.is_schoolstaff = True
                instance.save()

                # grabbing user raw datas (from html form)
                all_department = request.POST['all_department']
                raw_identification_num = form.cleaned_data['identification_num']

                # quering department, using the `all_department` variable above
                dept = Department.objects.filter(name=all_department).first()

                # quering department HOD, using the `dept` variable above
                dept_hod = Hod.objects.filter(department=dept, is_active=True).first()
                
                faculty_name = dept.faculty.name
                db_faculty = Faculty.objects.filter(name=faculty_name).first()

                # deactivating old coordinator
                old_active_hod = Coordinator.objects.filter(department=dept, is_active=True)
                if old_active_hod:
                    for old in old_active_hod:
                        old.is_active = False
                        old.save()

                # registering user to department training coordinator table
                new_training_coordinator = Coordinator(
                    coordinator=instance, faculty=db_faculty, department=dept, first_name=instance.first_name, last_name=instance.last_name, email=instance.email, phone_number=instance.phone_number, id_no=raw_identification_num, is_active=True
                )
                new_training_coordinator.save()
                messages.success(
                    request, f'Staff with ID number of {raw_identification_num} has been registered as new department of {all_department} training coordinator!')
                return redirect('auth:general_profile', id_no=raw_identification_num)
        else:
            form = CoordinatorSignupForm()
        context = {
            'form': form,
            'departments': departments,
            'who_to_reg': 'coordinator',
        }
        return render(request, 'auth/register.html', context)

    @check_phone_number(redirect_where='auth:register_student_training_coordinatro')
    @admin_required
    @staticmethod
    def student_training_supervisor(request):
        """register department student training supervisor"""
        
        # quering all departments active coordinator, which we will be rendering in templates
        all_coord = Coordinator.objects.filter(is_active=True)

        if request.method == 'POST':
            form = SupervisorSignupForm(request.POST)
            if form.is_valid():
                instance = form.save(commit=False)
                instance.is_supervisor = True
                instance.is_schoolstaff = True
                instance.save()

                # grabbing user raw datas (from html form)
                coord_id = request.POST['all_coord']
                raw_small_desc = form.cleaned_data['small_desc']

                # filtering department coordinator, using the `coord_id` variable above. In other to append the new register supervisor, in the active coordinator of the department. This will let it to display when coordinator is about to assign supervisor to student.
                coord = Coordinator.objects.filter(id_no=coord_id, is_active=True).first()

                # registering user to department training coordinator table
                new_student_supervisor = Supervisor(
                    supervisor=instance, first_name=instance.first_name, last_name=instance.last_name, email=instance.email, phone_number=instance.phone_number, id_no=instance.identification_num, small_desc=raw_small_desc, is_active=True
                )
                new_student_supervisor.save()

                # appending new supervisor into selected departmental active coordinator `list of supervisors`
                coord.training_supervisors.add(new_student_supervisor)
                coord.save()

                messages.success(
                    request, f'New supervisor with ID number of {instance.identification_num} has been registered as student supervisor of {coord.department.name} department!')
                return redirect('auth:general_profile', id_no=instance.identification_num)
        else:
            form = SupervisorSignupForm()
        context = {
            'form': form,
            'all_coord': all_coord,
            'who_to_reg': 'supervisor',
        }
        return render(request, 'auth/register.html', context)

    @admin_required
    @staticmethod
    def student(request):
        """register student"""
        
        # quering departments, which we will be rendering in templates
        departments = Department.objects.all()
        if request.method == 'POST':
            form = StudentSignupForm(request.POST)
            if form.is_valid():

                # grabbing user raw datas (from html form)
                all_department = request.POST['all_department']
                raw_identification_num = form.cleaned_data['identification_num']
                # raw_student_level = form.cleaned_data['student_level']

                # validate id number
                val_usr_id = val_id_num(request, raw_identification_num)
                if val_usr_id:
                    return val_usr_id
                
                # user instance
                instance = form.save(commit=False)
                instance.is_student = True
                instance.save()

                # quering department, using the `all_department` variable above
                dept = Department.objects.filter(name=all_department).first()
                faculty_name = dept.faculty.name
                faculty = Faculty.objects.filter(name=faculty_name).first()
                
                # quering an active department training coordinator, using the `dept` variable above. So that we can assign the new register student to the active training coordinator of his department
                dept_training_coord_usr = Coordinator.objects.filter(
                    department=dept, is_active=True).first()
                dept_training_coord = User.objects.filter(
                    identification_num=dept_training_coord_usr.id_no).first()

                # registering user to training student table
                new_student = Student(
                    student=instance, faculty=faculty, department=dept, student_coordinator=dept_training_coord, matrix_no=raw_identification_num)
                new_student.save()

                # adding new student into the cordinator `students` list
                dept_training_coord_usr.students.add(new_student)
                
                messages.success(
                    request, f'Student with admission number of {raw_identification_num} has been registered for training programme in {dept.name} department!')
                return redirect('auth:general_profile', id_no=raw_identification_num)
        else:
            form = StudentSignupForm()
        context = {
            'departments': departments,
            'form': form,
        }
        return render(request, 'auth/register_student.html', context)


class Update:
    """class that contains users update functionalities"""

    @staticmethod
    def profile_image(request):
        form = UpdateProfileImage(request.POST, request.FILES, instance=request.user.profile)

        # user previous profile image
        user_previous_img = request.user.profile.image.path

        if request.method == 'POST':
            # current school session
            current_school_sess = Session.objects.filter(is_current_session=True).last()

            # user profile image instance
            instance = form.save(commit=False)

            # removing user previous profile image if it is not the default one `default.png`
            if user_previous_img != '/home/usman/Desktop/acode/fugus/media/default.png':
                if os.path.exists(user_previous_img):
                    os.remove(user_previous_img)
            pic_name = picture_name(instance.image.name)

            # this is the current logged in user, filtered using his id
            user_from_base_table = User.objects.get(id=request.user.id)

            # making a user profile image route base on their ranks, instead of putting all of them in one directory.
            if request.user.is_admin:
                route = f'{current_school_sess.session}/admin/'
            elif request.user.is_vc:
                vc = Vc.objects.filter(
                    id_no=user_from_base_table.identification_num).first()
                route = f'{current_school_sess.session}/vc/{vc.faculty.name}/{vc.department.name}/'
            elif request.user.is_hod:
                hod = Hod.objects.filter(
                    id_no=user_from_base_table.identification_num).first()
                route = f'{current_school_sess.session}/hod/{hod.faculty.name}/{hod.department.name}/'
            elif request.user.is_coordinator:
                coordinator = Coordinator.objects.filter(
                    id_no=user_from_base_table.identification_num).first()
                route = f'{current_school_sess.session}/coordinator/{coordinator.faculty.name}/{coordinator.department.name}/'
            elif request.user.is_supervisor:
                route = f'{current_school_sess.session}/supervisor/'
            elif request.user.is_student:
                student = Student.objects.filter(
                    matrix_no=user_from_base_table.identification_num).first()
                route = f'{current_school_sess.session}/student/{student.faculty.name}/{student.department.name}/'
            else:
                route = f'{current_school_sess.session}/other/'
            instance.image.name = route + pic_name # final route
            instance.save()

            messages.success(
                request, f'Your profile image has been updated!')
            return redirect('auth:general_profile', id_no=request.user.identification_num)

    @check_phone_number(redirect_where='auth:student_profile_update')
    @student_required
    @staticmethod
    def student_info(request):
        """student update profile information"""

        r_user = request.user
        # querying student from student models
        student = Student.objects.filter(student=r_user).first()

        # blocking student from updating his/her profile, if it is up to date
        block_stu = block_student_update_profile(request, r_user)
        if block_stu:
            return block_stu
        
        if request.method == 'POST':
            form = UpdateStudentProfile(request.POST, request.FILES, instance=request.user)
            if form.is_valid():
                form = form.save(commit=False)
                form.save()

                # grabbing raw datas (from html form)
                # level = request.POST['student_level']
                bank_name = request.POST['bank_name']
                account_name = request.POST['account_name']
                account_number = request.POST['account_number']
                bank_sort_code = request.POST['bank_sort_code']
                
                # assigning data to student model
                student.first_name = form.first_name
                student.middle_name = form.middle_name
                student.last_name = form.last_name
                student.gender = form.gender
                student.date_of_birth = form.date_of_birth
                student.matrix_no = form.identification_num
                # student.level = level
                student.email = form.email
                student.phone_number = form.phone_number
                student.is_in_school = True
                # for bank details
                student.bank_name = bank_name
                student.account_name = account_name
                student.account_number = account_number
                student.bank_sort_code = bank_sort_code
                student.save()
                
                messages.success(
                    request, f'Your profile has been updated!')
                return redirect(reverse('student:profile', kwargs={'matrix_no': form.identification_num}))
        else:
            form = UpdateStudentProfile(instance=request.user)

        context = {
            'form': form,
        }
        return render(request, 'auth/student_update_profile.html', context=context)
