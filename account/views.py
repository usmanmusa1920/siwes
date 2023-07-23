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
    PasswordChangeForm, AdministratorSignupForm, FacultySignupForm, FacultyDeanSignupForm, DepartmentSignupForm, SchoolVCSignupForm, DepartmentHODSignupForm, DepartmentCoordinatorSignupForm, StudentSupervisorSignupForm, StudentSignupForm, UpdateStudentProfile
)
from toolkit import (picture_name, y_session)
from toolkit.decorators import (
    block_student_update_profile, restrict_access_student_profile, val_id_num, check_phone_number, admin_required, dean_required, hod_required, coordinator_required, supervisor_required, schoolstaff_required, student_required, supervisor_or_student_required, coordinator_or_supervisor_or_student_required
)
from administrator.models import Administrator
from administrator.all_models import(
    Session, Faculty, Department, SchoolVC, FacultyDean, DepartmentHOD, TrainingStudent, StudentSupervisor, DepartmentTrainingCoordinator, Letter, AcceptanceLetter, WeekReader, WeekScannedLogbook, CommentOnLogbook, StudentResult, Message
)


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
def changePassword(request):
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
    These class includes class methods (views) for registering new
    (administrator, faculty, faculty dean, department, department HOD, department training coordinator, and student) profiles
    """

    @admin_required
    @staticmethod
    def session(request):
        """register new session"""

        last_prev_sess = Session.objects.filter(is_current_session=True).last()
        if last_prev_sess:
            # grabing data from `last_prev_sess`
            a_sess = last_prev_sess.session
            b_sess = a_sess.split('/') # making it a list
            c_sess = int(b_sess[0])+1 # taking index 0 of the list and plus it with one
            d_sess = int(b_sess[1])+1 # taking index 1 of the list and plus it with one
            e_sess = '/'.join([str(c_sess), str(d_sess)]) # new session
            date_sess = e_sess
        else:
            date_sess = y_session()
        if request.method == 'POST':
            # deactivating any `is_current_session` which is True to False
            prev_sess = Session.objects.filter(is_current_session=True)
            for sess in prev_sess:
                sess.is_current_session = False
                sess.save()

            # if we find the query `last_prev_sess`, we will use it for the following tricks
            # else if we don`t find the query we, will create new one using `y_session` function
            if last_prev_sess:
                new_sess = Session(session=date_sess, is_current_session=True)
            else:
                new_sess = Session(is_current_session=True)
            new_sess.save()

            messages.success(
                request, f'New session ({date_sess}) for the school training programm created')
            return redirect('landing')
        context = {
            'date_sess': date_sess,
        }
        return render(request, 'auth/new_session.html', context)

    @check_phone_number(redirect_where='auth:register_administrator')
    @admin_required
    @staticmethod
    def administrator(request):
        """
        register administrator
        
        when creating new administrator a signal will fire, which will automatically create administrator also in the seperate table of administrator. But in this view it only query the administrator in other to assign his/her description
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

                # filtering created admin in other to assign his/her description
                new_administrator = Administrator.objects.filter(
                    id_no=instance.identification_num
                ).first()
                new_administrator.description = raw_description
                new_administrator.save()
                messages.success(request, f'Administrator with ID number of {raw_identification_num} has been registered as an administrator!')
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
                messages.success(request, f'New faculty with name of {raw_name} has been registered!')
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

                messages.success(request, f'New department with name of {raw_name} has been registered!')
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
    def schoolVC(request):
        """register schoolVC"""

        # quering faculties and departments names, which we will be rendering in templates
        faculties = Faculty.objects.all()
        departments = Department.objects.all()
        print(request.method)

        if request.method == 'POST':
            form = SchoolVCSignupForm(request.POST)
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
                old_active_vc = SchoolVC.objects.filter(is_active=True)
                if old_active_vc:
                    for old in old_active_vc:
                        old.is_active = False
                        old.save()

                # creating user (in the school vc table)
                new_dept_hod = SchoolVC(
                    vc=instance, faculty=db_faculty, department=db_dept, ranks=raw_ranks, first_name=instance.first_name, middle_name=instance.middle_name, last_name=instance.last_name, gender=instance.gender, date_of_birth=instance.date_of_birth, id_no=instance.identification_num, email=instance.email, phone_number=instance.phone_number, level_rank_title_1=raw_level_rank_title_1, level_rank_title_2=raw_level_rank_title_2, email_other=raw_other_email, phone_number_other=raw_other_phone, professorship=raw_professorship, is_active=True
                )
                new_dept_hod.save()
                messages.success(request, f'Staff with ID number of {raw_identification_num} has been registered as new VC of the school!')
                return redirect('auth:general_profile', id_no=raw_identification_num)
        else:
            form = SchoolVCSignupForm()
        context = {
            'form': form,
            'faculties': faculties,
            'departments': departments,
            'who_to_reg': 'school vc',
        }
        return render(request, 'auth/register.html', context)
    
    @check_phone_number(redirect_where='auth:register_faculty_dean')
    @admin_required
    @staticmethod
    def facultyDean(request):
        """register faculty dean"""

        # quering departments names, which we will be rendering in templates
        departments = Department.objects.all()

        if request.method == 'POST':
            form = FacultyDeanSignupForm(request.POST)
            if form.is_valid():
                instance = form.save(commit=False)
                instance.is_dean = True
                instance.is_schoolstaff = True
                instance.save()

                # grabbing user raw datas (from html form)
                raw_identification_num = form.cleaned_data['identification_num']
                raw_ranks = form.cleaned_data['ranks']
                raw_level_rank_title_1 = form.cleaned_data['level_rank_title_1']
                raw_level_rank_title_2 = form.cleaned_data['level_rank_title_2']
                raw_dept = request.POST['raw_dept']

                db_dept = Department.objects.filter(name=raw_dept).first()
                raw_faculty = db_dept.faculty.name

                db_faculty = Faculty.objects.filter(name=raw_faculty).first()

                # deactivating old dean
                old_active_deans = FacultyDean.objects.filter(faculty=db_faculty, is_active=True)
                if old_active_deans:
                    for old in old_active_deans:
                        old.is_active = False
                        old.save()

                # creating user (in the faculty dean table)
                new_faculty_dean = FacultyDean(
                    dean=instance, faculty=db_faculty, department=db_dept, ranks=raw_ranks, first_name=instance.first_name, middle_name=instance.middle_name, last_name=instance.last_name, gender=instance.gender, date_of_birth=instance.date_of_birth, id_no=instance.identification_num, email=instance.email, phone_number=instance.phone_number, level_rank_title_1=raw_level_rank_title_1, level_rank_title_2=raw_level_rank_title_2, is_active=True
                )
                new_faculty_dean.save()
                messages.success(request, f'Staff with ID number of {raw_identification_num} has been registered as new faculty of {raw_faculty} dean!')
                return redirect('auth:general_profile', id_no=raw_identification_num)
        else:
            form = FacultyDeanSignupForm()
        context = {
            'form': form,
            'departments': departments,
            'who_to_reg': 'faculty dean',
        }
        return render(request, 'auth/register.html', context)

    @check_phone_number(redirect_where='auth:register_department_hod')
    @admin_required
    @staticmethod
    def departmentHOD(request):
        """register department hod"""

        # quering faculties and departments names, which we will be rendering in templates
        faculties = Faculty.objects.all()
        departments = Department.objects.all()

        if request.method == 'POST':
            form = DepartmentHODSignupForm(request.POST)
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
                old_active_hod = DepartmentHOD.objects.filter(department=db_dept, is_active=True)
                if old_active_hod:
                    for old in old_active_hod:
                        old.is_active = False
                        old.save()

                # creating user (in the department hod table)
                new_dept_hod = DepartmentHOD(
                    hod=instance, faculty=db_faculty, department=db_dept, ranks=raw_ranks, first_name=instance.first_name, middle_name=instance.middle_name, last_name=instance.last_name, gender=instance.gender, date_of_birth=instance.date_of_birth, id_no=instance.identification_num, email=instance.email, phone_number=instance.phone_number, level_rank_title_1=raw_level_rank_title_1, level_rank_title_2=raw_level_rank_title_2, email_other=raw_other_email, phone_number_other=raw_other_phone, is_active=True
                )
                new_dept_hod.save()
                messages.success(request, f'Staff with ID number of {raw_identification_num} has been registered as new department of {raw_dept} dean!')
                return redirect('auth:general_profile', id_no=raw_identification_num)
        else:
            form = DepartmentHODSignupForm()
        context = {
            'form': form,
            'faculties': faculties,
            'departments': departments,
            'who_to_reg': 'department hod',
        }
        return render(request, 'auth/register.html', context)

    @check_phone_number(redirect_where='auth:register_department_training_coordinator')
    @admin_required
    @staticmethod
    def departmentTrainingCoordinator(request):
        """register department training coordinator"""

        # quering faculties and departments names, which we will be rendering in templates
        faculties = Faculty.objects.all()
        all_dept_hod = DepartmentHOD.objects.filter(is_active=True)

        if request.method == 'POST':
            form = DepartmentCoordinatorSignupForm(request.POST)
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
                dept_hod = DepartmentHOD.objects.filter(department=dept, is_active=True).first()
                
                faculty_name = dept.faculty.name
                db_faculty = Faculty.objects.filter(name=faculty_name).first()

                # deactivating old coordinator
                old_active_hod = DepartmentTrainingCoordinator.objects.filter(department=dept, is_active=True)
                if old_active_hod:
                    for old in old_active_hod:
                        old.is_active = False
                        old.save()

                # registering user to department training coordinator table
                new_training_coordinator = DepartmentTrainingCoordinator(
                    coordinator=instance, faculty=db_faculty, department=dept, dept_hod=dept_hod, first_name=instance.first_name, last_name=instance.last_name, email=instance.email, phone_number=instance.phone_number, id_no=raw_identification_num, is_active=True
                )
                new_training_coordinator.save()
                messages.success(request, f'Staff with ID number of {raw_identification_num} has been registered as new department of {all_department} training coordinator!')
                return redirect('auth:general_profile', id_no=raw_identification_num)
        else:
            form = DepartmentCoordinatorSignupForm()
        context = {
            'form': form,
            'faculties': faculties,
            'all_dept_hod': all_dept_hod,
            'who_to_reg': 'training coordinator',
        }
        return render(request, 'auth/register.html', context)

    @check_phone_number(redirect_where='auth:register_student_training_coordinatro')
    @admin_required
    @staticmethod
    def studentTrainingSupervisor(request):
        """register department student training supervisor"""
        
        # quering faculties and departments names, which we will be rendering in templates
        all_coord = DepartmentTrainingCoordinator.objects.filter(is_active=True)

        if request.method == 'POST':
            form = StudentSupervisorSignupForm(request.POST)
            if form.is_valid():
                instance = form.save(commit=False)
                instance.is_staff = True
                instance.is_supervisor = True
                instance.is_schoolstaff = True
                instance.save()

                # grabbing user raw datas (from html form)
                coord_id = request.POST['all_coord']
                raw_small_desc = form.cleaned_data['small_desc']

                # quering department, using the `all_department` variable above
                coord = DepartmentTrainingCoordinator.objects.filter(id_no=coord_id, is_active=True).first()

                # registering user to department training coordinator table
                new_student_supervisor = StudentSupervisor(
                    supervisor=instance, first_name=instance.first_name, last_name=instance.last_name, email=instance.email, phone_number=instance.phone_number, id_no=instance.identification_num, small_desc=raw_small_desc, is_active=True
                )
                new_student_supervisor.save()

                # appending new supervisor into selected departmental active
                # coordinator list of supervisors
                coord.training_supervisors.add(new_student_supervisor)
                coord.save()

                messages.success(request, f'New supervisor with ID number of {instance.identification_num} has been registered as student supervisor of {coord.department.name} department!')
                return redirect('auth:general_profile', id_no=instance.identification_num)
        else:
            form = StudentSupervisorSignupForm()
        context = {
            'form': form,
            'all_coord': all_coord,
            'who_to_reg': 'student supervisor',
        }
        return render(request, 'auth/register.html', context)

    @admin_required
    @staticmethod
    def student(request):
        """register student"""
        
        # querying all active departmental training coordinator
        all_dept = DepartmentTrainingCoordinator.objects.filter(is_active=True)
        
        """
        We use `DepartmentTrainingCoordinator` table to grab departments name instead of using the `Department` table direct, because we want to display only departments that have an active training coordinator. Reason, at some cases, some department they will not register their siwes coordinator on time (or they won`t have an active training coordinator), if so happen and if an administrator is about to register (students`) from a specific department (had it been we use the `Department` table direct), he will get an error even though his department name will show up in the drop down menu of the register page. One more thing is that for each student in the `TrainingStudent` table has a foreignkey of `DepartmentTrainingCoordinator`
        """

        if request.method == 'POST':
            form = StudentSignupForm(request.POST)
            if form.is_valid():

                # grabbing user raw datas (from html form)
                all_department = request.POST['all_department']
                raw_identification_num = form.cleaned_data['identification_num']

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
                
                # quering an active department HOD, using the `dept` variable above
                dept_hod = DepartmentHOD.objects.filter(department=dept, is_active=True).first()

                # quering an active department training coordinator, using the `dept_hod` variable above. So that we can assign the new register student to the active training coordinator of his department
                dept_training_coord_usr = DepartmentTrainingCoordinator.objects.filter(
                    dept_hod=dept_hod, is_active=True).first()
                dept_training_coord = User.objects.filter(
                    identification_num=dept_training_coord_usr.id_no).first()

                # registering user to training student table
                new_student = TrainingStudent(
                    student=instance, faculty=faculty, department=dept, student_training_coordinator=dept_training_coord, matrix_no=raw_identification_num)
                new_student.save()

                # adding new student into the cordinator `training_students` list
                dept_training_coord_usr.training_students.add(new_student)
                
                messages.success(request, f'Student with admission number of {raw_identification_num} has been registered for training programme!')
                return redirect('auth:general_profile', id_no=raw_identification_num)
        else:
            form = StudentSignupForm()
        context = {
            'all_dept': all_dept,
            'form': form,
        }
        return render(request, 'auth/register_student.html', context)


class UpdateProfile:
    """class that contains users update functionalities"""

    @check_phone_number(redirect_where='auth:student_profile_update')
    @student_required
    @staticmethod
    def student(request):
        """student update profile"""

        r_user = request.user
        # querying student from student models
        std = TrainingStudent.objects.filter(student=r_user).first()

        # blocking student from updating his/her profile
        block_stu = block_student_update_profile(request, r_user)
        if block_stu:
            return block_stu
        
        if request.method == 'POST':
            form = UpdateStudentProfile(request.POST, request.FILES, instance=request.user)
            if form.is_valid():
                form = form.save(commit=False)
                form.save()

                # grabbing raw datas (from html form)
                level = request.POST['student_level']
                
                # assigning data to student model
                std.first_name = form.first_name
                std.middle_name = form.middle_name
                std.last_name = form.last_name
                std.gender = form.gender
                std.date_of_birth = form.date_of_birth
                std.matrix_no = form.identification_num
                std.level = level
                std.email = form.email
                std.phone_number = form.phone_number
                std.is_in_school = True
                std.save()
                
                messages.success(request, f'Your profile has been updated!')
                return redirect(reverse('student:profile', kwargs={'matrix_id': form.identification_num}))
        else:
            form = UpdateStudentProfile(instance=request.user)

        context = {
            'form': form,
        }
        return render(request, 'auth/student_update_profile.html', context=context)
