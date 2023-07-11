from django.urls import reverse
from django.shortcuts import render, redirect, HttpResponseRedirect
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.contrib.auth.views import LoginView, LogoutView
from django.contrib.sites.shortcuts import get_current_site
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth import update_session_auth_hash
from .forms import (
    PasswordChangeForm, AdministratorSignupForm, FacultySignupForm, FacultyDeanSignupForm, DepartmentSignupForm, DepartmentHODSignupForm, DepartmentCoordinatorSignupForm, StudentSupervisorSignupForm, StudentSignupForm, UpdateStudentProfile)
from administrator.models import Administrator
from faculty.models import Faculty, FacultyDean
from department.models import (
    Department, DepartmentHOD, DepartmentTrainingCoordinator, StudentSupervisor)
from student.models import TrainingStudent, WeekReader
from django.contrib.auth import get_user_model
from toolkit.decorators import (
    val_id_num, validate_staff_user, check_phone_number, block_student_update_profile)


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


@login_required
def generalProfile(request, id_no):
    """general profile"""

    # querying user using identification number
    user = User.objects.filter(identification_num=id_no).first()

    if request.user.is_admin:
        pass
    if request.user.is_dean:
        pass
    if request.user.is_hod:
        pass
    if request.user.is_coordinator:
        pass
    if request.user.is_supervisor:
        pass
    if request.user.is_student:
        pass

    context = {
        'user': user,
    }
    return render(request, 'auth/general_profile.html', context=context)


class Register:
    """
    These class includes class methods (views) for registering new
    (administrator, faculty, faculty dean, department, department HOD, department training coordinator, and student) profiles
    """

    @check_phone_number(redirect_where='auth:register_administrator')
    @validate_staff_user
    @login_required
    @staticmethod
    def administrator(request):
        """register administrator"""
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

                # creating user (in the administrator table)
                new_administrator = Administrator(
                    director=instance, first_name=instance.first_name, middle_name=instance.middle_name, last_name=instance.last_name, gender=instance.gender, date_of_birth=instance.date_of_birth, id_no=instance.identification_num, email=instance.email, phone_number=instance.phone_number, description=raw_description
                )
                new_administrator.save()

                messages.success(request, f'Administrator with ID number of {raw_identification_num} has been registered as an administrator!')
                # return redirect('auth:register_administrator')
                return redirect('auth:general_profile', id_no=raw_identification_num)
        else:
            form = AdministratorSignupForm()
        context = {
            'form': form,
            'who_to': 'administrator',
        }
        return render(request, 'auth/register.html', context)

    @check_phone_number(redirect_where='auth:register_faculty')
    @validate_staff_user
    @login_required
    @staticmethod
    def faculty(request):
        """register faculty"""
        if request.user.is_staff == False:
            # block anyone from getting access to the register page of
            # administrator if he/she is not a staff
            return False
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
            'who_to': 'faculty',
        }
        return render(request, 'auth/register.html', context)

    @check_phone_number(redirect_where='auth:register_faculty_dean')
    @validate_staff_user
    @login_required
    @staticmethod
    def facultyDean(request):
        """register faculty dean"""
        # quering faculties names, which we will be rendering in templates
        faculties = Faculty.objects.all()

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
                raw_faculty = request.POST['raw_faculty']
                db_faculty = Faculty.objects.filter(name=raw_faculty).first()

                # creating user (in the faculty dean table)
                new_faculty_dean = FacultyDean(
                    dean=instance, faculty=db_faculty, ranks=raw_ranks, first_name=instance.first_name, middle_name=instance.middle_name, last_name=instance.last_name, gender=instance.gender, date_of_birth=instance.date_of_birth, id_no=instance.identification_num, email=instance.email, phone_number=instance.phone_number, level_rank_title_1=raw_level_rank_title_1, level_rank_title_2=raw_level_rank_title_2
                )
                new_faculty_dean.save()

                # grabbing faculty name
                faculty = new_faculty_dean.faculty.name
                messages.success(request, f'Staff with ID number of {raw_identification_num} has been registered as new faculty of {faculty} dean!')
                # return redirect('auth:register_faculty_dean')
                return redirect('auth:general_profile', id_no=raw_identification_num)
        else:
            form = FacultyDeanSignupForm()
        context = {
            'form': form,
            'faculties': faculties,
            'who_to': 'faculty dean',
        }
        return render(request, 'auth/register.html', context)

    @check_phone_number(redirect_where='auth:register_department')
    @validate_staff_user
    @login_required
    @staticmethod
    def department(request):
        """register department"""
        if request.method == 'POST':
            form = DepartmentSignupForm(request.POST)
            if form.is_valid():
                form.save()

                # grabbing user raw datas (from html form)
                raw_name = form.cleaned_data['name']
                messages.success(request, f'New department with name of {raw_name} has been registered!')
                return redirect('auth:register_department')
        else:
            form = DepartmentSignupForm()
        context = {
            'form': form,
            'who_to': 'department',
        }
        return render(request, 'auth/register.html', context)

    @check_phone_number(redirect_where='auth:register_department_hod')
    @validate_staff_user
    @login_required
    @staticmethod
    def departmentHOD(request):
        """register department hod"""
        # quering departments names, which we will be rendering in templates
        departments = Department.objects.all()

        if request.method == 'POST':
            form = DepartmentHODSignupForm(request.POST)
            if form.is_valid():
                instance = form.save(commit=False)
                instance.is_staff = True
                instance.is_hod = True
                instance.is_schoolstaff = True
                instance.save()

                # grabbing user raw datas (from html form)
                raw_identification_num = form.cleaned_data['identification_num']
                raw_ranks = form.cleaned_data['ranks']
                raw_level_rank_title_1 = form.cleaned_data['level_rank_title_1']
                raw_level_rank_title_2 = form.cleaned_data['level_rank_title_2']
                raw_dept = request.POST['raw_dept']
                db_dept = Department.objects.filter(name=raw_dept).first()

                # creating user (in the department hod table)
                new_dept_hod = DepartmentHOD(
                    hod=instance, department=db_dept, ranks=raw_ranks, first_name=instance.first_name, middle_name=instance.middle_name, last_name=instance.last_name, gender=instance.gender, date_of_birth=instance.date_of_birth, id_no=instance.identification_num, email=instance.email, phone_number=instance.phone_number, level_rank_title_1=raw_level_rank_title_1, level_rank_title_2=raw_level_rank_title_2
                )
                new_dept_hod.save()

                # grabbing department name
                department = new_dept_hod.department.name
                messages.success(request, f'Staff with ID number of {raw_identification_num} has been registered as new department of {department} dean!')
                # return redirect('auth:register_department_hod')
                return redirect('auth:general_profile', id_no=raw_identification_num)
        else:
            form = DepartmentHODSignupForm()
        context = {
            'form': form,
            'departments': departments,
            'who_to': 'department hod',
        }
        return render(request, 'auth/register.html', context)

    @check_phone_number(redirect_where='auth:register_department_training_coordinator')
    @validate_staff_user
    @login_required
    @staticmethod
    def departmentTrainingCoordinator(request):
        """register department training coordinator"""

        # quering all department
        all_dept = Department.objects.all()
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
                dept_hod = DepartmentHOD.objects.filter(
                    department=dept, is_active=True).first()

                # registering user to department training coordinator table
                new_training_coordinator = DepartmentTrainingCoordinator(
                    coordinator=instance, dept_hod=dept_hod, first_name=instance.first_name, last_name=instance.last_name, email=instance.email, phone_number=instance.phone_number, id_no=raw_identification_num
                )
                new_training_coordinator.save()  # saving

                messages.success(request, f'Staff with ID number of {raw_identification_num} has been registered as new department of {all_department} training coordinator!')
                # return redirect('auth:register_department_training_coordinator')
                return redirect('auth:general_profile', id_no=raw_identification_num)
        else:
            form = DepartmentCoordinatorSignupForm()
        context = {
            'form': form,
            'all_dept': all_dept,
            'who_to': 'training coordinator',
        }
        return render(request, 'auth/register.html', context)

    @check_phone_number(redirect_where='auth:register_student_training_coordinatro')
    @validate_staff_user
    @login_required
    @staticmethod
    def studentTrainingSupervisor(request):
        """register department student training supervisor"""

        # quering all department
        all_dept = Department.objects.all()
        if request.method == 'POST':
            form = StudentSupervisorSignupForm(request.POST)
            if form.is_valid():
                instance = form.save(commit=False)
                instance.is_staff = True
                instance.is_supervisor = True
                instance.is_schoolstaff = True
                instance.save()

                # grabbing user raw datas (from html form)
                all_department = request.POST['all_department']
                raw_location = form.cleaned_data['location']

                # quering department, using the `all_department` variable above
                dept = Department.objects.filter(name=all_department).first()
                # quering department HOD, using the `dept` variable above
                dept_hod = DepartmentHOD.objects.filter(
                    department=dept, is_active=True).first()
                # quering department training coordinator, using the `dept_hod` variable above
                dept_training_coordinator = DepartmentTrainingCoordinator.objects.filter(
                    dept_hod=dept_hod, is_active=True).first()

                # registering user to department training coordinator table
                new_student_supervisor = StudentSupervisor(
                    supervisor=instance, dept_training_coordinator=dept_training_coordinator, first_name=instance.first_name, last_name=instance.last_name, email=instance.email, phone_number=instance.phone_number, id_no=instance.identification_num, location=raw_location
                )
                new_student_supervisor.save()  # saving

                messages.success(request, f'Staff with ID number of {instance.identification_num} has been registered as student supervisor of {all_department} department!')
                # return redirect('auth:register_department_training_coordinator')
                return redirect('auth:general_profile', id_no=instance.identification_num)
        else:
            form = StudentSupervisorSignupForm()
        context = {
            'form': form,
            'all_dept': all_dept,
            'who_to': 'student supervisor',
        }
        return render(request, 'auth/register.html', context)

    @validate_staff_user
    @login_required
    @staticmethod
    def student(request):
        """register student"""
        
        # querying all active departmental training coordinator
        all_dept = DepartmentTrainingCoordinator.objects.filter(is_active=True)
        """
        We use `DepartmentTrainingCoordinator` table to grab departments name instead of using the `Department` table direct, because we want to display only departments that have an active training coordinator. Reason at some case, some department they will not register their siwes coordinator on time (or they won`t have an active training coordinator), if so happen and if an administrator is about to register (students`) from a specific department (had it been we use the `Department` table direct), he will get an error even though his department name will show up in the drop down menu of the register page. One more thin is that for each student in the `TrainingStudent` table has a foreignkey of `DepartmentTrainingCoordinator`
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
                
                # quering an active department HOD, using the `dept` variable above
                dept_hod = DepartmentHOD.objects.filter(department=dept, is_active=True).first()

                # quering an active department training coordinator, using the `dept_hod` variable above. So that we can assign the new register student to the active training coordinator of his department
                dept_training_coord = DepartmentTrainingCoordinator.objects.filter(dept_hod=dept_hod, is_active=True).first()

                # registering user to training student table
                new_student = TrainingStudent(student=instance, student_training_coordinator=dept_training_coord, matrix_no=raw_identification_num)
                new_student.save()

                # creating student weekly reader (for logbook entry for 200 level)
                WR = WeekReader(student=new_student)
                WR.save()

                messages.success(request, f'Student with admission number of {raw_identification_num} has been registered for training programme!')
                # return redirect('auth:register_student')
                return redirect('auth:general_profile', id_no=raw_identification_num)
        else:
            form = StudentSignupForm()
        context = {
            'all_dept': all_dept,
            'form': form,
        }
        return render(request, 'auth/register_student.html', context)


class UpdateProfile:

    @check_phone_number(redirect_where='auth:student_profile_update')
    @login_required
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

                # querying student week reader for updating his level. May be he is not in @00 level which is the default one
                WR = WeekReader.objects.filter(student=std).first()
                WR.level = level
                WR.save()
                
                messages.success(request, f'Your profile has been updated!')
                return redirect(reverse('student:profile', kwargs={'matrix_id': form.identification_num}))
        else:
            form = UpdateStudentProfile(instance=request.user)

        context = {
            'form': form,
        }
        return render(request, 'auth/student_update_profile.html', context=context)
