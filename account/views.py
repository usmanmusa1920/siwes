from django.urls import reverse
from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.contrib.auth.views import LoginView, LogoutView
from django.contrib.sites.shortcuts import get_current_site
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth import update_session_auth_hash
from .forms import (PasswordChangeForm, AdministratorSignupForm, FacultySignupForm, FacultyDeanSignupForm, DepartmentSignupForm, DepartmentHODSignupForm, DepartmentCoordinatorSignupForm, StudentSignupForm)
from administrator.models import Administrator
from faculty.models import Faculty, FacultyDean
from department.models import Department, DepartmentHOD, DepartmentTrainingCoordinator
from student.models import TrainingStudent, WeekReader
from django.contrib.auth import get_user_model


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
  

class LogoutCustom(LoginRequiredMixin ,LogoutView):
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
  """change password view"""
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

  @login_required
  @staticmethod
  def administrator(request):
    """register administrator"""
    if request.user.is_staff == False:
      # block anyone from getting access to the register page of
      # administrator if he/she is not a staff
      return False
    if request.method == 'POST':
      form = AdministratorSignupForm(request.POST)
      if form.is_valid():
        form.save()
        
        # grabbing user raw datas (from html form)
        raw_identification_num = form.cleaned_data['identification_num']
        raw_description = form.cleaned_data['description']
        
        # filtering user you just create (from the general user table)
        filtering_usr = User.objects.filter(identification_num=raw_identification_num).first()
        filtering_usr.is_staff = True # making him/her as staff
        filtering_usr.save()

        # grabbing user datas (from general user table)
        raw_first_name = filtering_usr.first_name
        raw_middle_name = filtering_usr.middle_name
        raw_last_name = filtering_usr.last_name
        raw_gender = filtering_usr.gender
        raw_date_of_birth = filtering_usr.date_of_birth
        raw_email = filtering_usr.email
        raw_phone_number = filtering_usr.phone_number
        
        # creating user (in the administrator table)
        new_administrator =  Administrator(director=filtering_usr, first_name=raw_first_name, middle_name=raw_middle_name, last_name=raw_last_name, gender=raw_gender, date_of_birth=raw_date_of_birth, id_no=raw_identification_num, email=raw_email, phone_number=raw_phone_number, description=raw_description)
        new_administrator.save()
        
        messages.success(request, f'Administrator with ID number of {raw_identification_num} has been registered as an administrator!')
        return redirect('auth:register_administrator')
    else:
      form = AdministratorSignupForm()
    context = {
      'form': form,
    }
    return render(request, 'auth/register_administrator.html', context)
  

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
    }
    return render(request, 'auth/register_faculty.html', context)
  

  @login_required
  @staticmethod
  def facultyDean(request):
    """register faculty dean"""
    if request.user.is_staff == False:
      # block anyone from getting access to the register page of
      # administrator if he/she is not a staff
      return False
    
    # quering faculties names, which we will be rendering in templates
    faculties = Faculty.objects.all()

    if request.method == 'POST':
      form = FacultyDeanSignupForm(request.POST)
      if form.is_valid():
        form.save()
        
        # grabbing user raw datas (from html form)
        raw_identification_num = form.cleaned_data['identification_num']
        raw_ranks = form.cleaned_data['ranks']
        raw_faculty = request.POST['raw_faculty']
        db_faculty = Faculty.objects.filter(name=raw_faculty).first()
        
        # filtering user you just create (from the general user table)
        filtering_usr = User.objects.filter(identification_num=raw_identification_num).first()
        filtering_usr.is_staff = True # making him/her as staff
        filtering_usr.save()

        # grabbing user datas (from general user table)
        raw_first_name = filtering_usr.first_name
        raw_middle_name = filtering_usr.middle_name
        raw_last_name = filtering_usr.last_name
        raw_gender = filtering_usr.gender
        raw_date_of_birth = filtering_usr.date_of_birth
        raw_email = filtering_usr.email
        raw_phone_number = filtering_usr.phone_number
        
        # creating user (in the faculty dean table)
        new_faculty_dean =  FacultyDean(dean=filtering_usr, faculty=db_faculty, ranks=raw_ranks, first_name=raw_first_name, middle_name=raw_middle_name, last_name=raw_last_name, gender=raw_gender, date_of_birth=raw_date_of_birth, id_no=raw_identification_num, email=raw_email, phone_number=raw_phone_number)
        new_faculty_dean.save()

        # grabbing faculty name
        faculty = new_faculty_dean.faculty.name
        
        messages.success(request, f'Staff with ID number of {raw_identification_num} has been registered as new faculty of {faculty} dean!')
        return redirect('auth:register_faculty_dean')
    else:
      form = FacultyDeanSignupForm()
    context = {
      'form': form,
      'faculties': faculties,
    }
    return render(request, 'auth/register_faculty_dean.html', context)
  

  @login_required
  @staticmethod
  def department(request):
    """register department"""
    if request.user.is_staff == False:
      # block anyone from getting access to the register page of
      # administrator if he/she is not a staff
      return False
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
    }
    return render(request, 'auth/register_department.html', context)
  

  @login_required
  @staticmethod
  def departmentHOD(request):
    """register department hod"""
    if request.user.is_staff == False:
      # block anyone from getting access to the register page of
      # administrator if he/she is not a staff
      return False
    
    # quering departments names, which we will be rendering in templates
    departments = Department.objects.all()

    if request.method == 'POST':
      form = DepartmentHODSignupForm(request.POST)
      if form.is_valid():
        form.save()
        
        # grabbing user raw datas (from html form)
        raw_identification_num = form.cleaned_data['identification_num']
        raw_ranks = form.cleaned_data['ranks']
        raw_dept = request.POST['raw_dept']
        db_dept = Department.objects.filter(name=raw_dept).first()
        
        # filtering user you just create (from the general user table)
        filtering_usr = User.objects.filter(identification_num=raw_identification_num).first()
        filtering_usr.is_staff = True # making him/her as staff
        filtering_usr.save()

        # grabbing user datas (from general user table)
        raw_first_name = filtering_usr.first_name
        raw_middle_name = filtering_usr.middle_name
        raw_last_name = filtering_usr.last_name
        raw_gender = filtering_usr.gender
        raw_date_of_birth = filtering_usr.date_of_birth
        raw_email = filtering_usr.email
        raw_phone_number = filtering_usr.phone_number
        
        # creating user (in the department hod table)
        new_dept_hod =  DepartmentHOD(hod=filtering_usr, department=db_dept, ranks=raw_ranks, first_name=raw_first_name, middle_name=raw_middle_name, last_name=raw_last_name, gender=raw_gender, date_of_birth=raw_date_of_birth, id_no=raw_identification_num, email=raw_email, phone_number=raw_phone_number)
        new_dept_hod.save()

        # grabbing department name
        department = new_dept_hod.department.name
        
        messages.success(request, f'Staff with ID number of {raw_identification_num} has been registered as new department of {department} dean!')
        return redirect('auth:register_department_hod')
    else:
      form = DepartmentHODSignupForm()
    context = {
      'form': form,
      'departments': departments,
    }
    return render(request, 'auth/register_department_hod.html', context)
  

  @login_required
  @staticmethod
  def departmentTrainingCoordinator(request):
    """register department training coordinator"""

    # quering all department
    all_dept = Department.objects.all()
    if request.method == 'POST':
      form = DepartmentCoordinatorSignupForm(request.POST)
      if form.is_valid():
        form.save()

        # grabbing user raw datas (from html form)
        all_department = request.POST['all_department']
        raw_identification_num = form.cleaned_data['identification_num']
        
        # quering department, using the `all_department` variable above
        dept = Department.objects.filter(name=all_department).first()
        # quering department HOD, using the `dept` variable above
        dept_hod = DepartmentHOD.objects.filter(department=dept, is_active=True).first()

        # filtering user you just create (from the general user table)
        filtering_usr = User.objects.filter(identification_num=raw_identification_num).first()
        filtering_usr.is_staff = True # making him/her as staff
        filtering_usr.save()

        # registering user to department training coordinator table
        new_training_coordinator = DepartmentTrainingCoordinator(coordinator=filtering_usr, dept_hod=dept_hod, first_name=filtering_usr.first_name, last_name=filtering_usr.last_name, email=filtering_usr.email, phone_number=filtering_usr.phone_number, id_no=raw_identification_num)
        new_training_coordinator.save() # saving
        
        messages.success(request, f'Staff with ID number of {raw_identification_num} has been registered as new department of {all_department} training coordinator!')
        return redirect('auth:register_department_training_coordinator')
    else:
      form = DepartmentCoordinatorSignupForm()
    context = {
      'form': form,
      'all_dept': all_dept,
    }
    return render(request, 'auth/register_training_coordinator.html', context)
  

  @login_required
  @staticmethod
  def student(request):
    """register student"""
    if request.user.is_staff == False:
      # block anyone from getting access to the register page of student if he/she is not a staff
      return False
    all_dept = DepartmentTrainingCoordinator.objects.filter(is_active=True)
    """
    We use `DepartmentTrainingCoordinator` table to grab departments name, because at some case, some department they will not register their siwes coordinator on time, if so happen and student of that department trying to register (the one incharge to register him), he will get an error even though his department name will show up in the drop down menu of the register page.
    """
    if request.method == 'POST':
      form = StudentSignupForm(request.POST)
      if form.is_valid():
        form.save()

        # grabbing user raw datas (from html form)
        all_department = request.POST['all_department']
        raw_identification_num = form.cleaned_data['identification_num']
        student_level = form.cleaned_data['student_level']
        
        # quering department, using the `all_department` variable above
        dept = Department.objects.filter(name=all_department).first()
        # quering department HOD, using the `dept` variable above
        dept_hod = DepartmentHOD.objects.filter(department=dept).first()
        dept_training_coord = DepartmentTrainingCoordinator.objects.filter(dept_hod=dept_hod).first()

        # filtering user you just create (from the general user table)
        filtering_usr = User.objects.filter(identification_num=raw_identification_num).first()
        
        # registering user to training student table
        new_student =  TrainingStudent(student=filtering_usr, student_training_coordinator=dept_training_coord, first_name=form.cleaned_data['first_name'], last_name=form.cleaned_data['last_name'], matrix_no=raw_identification_num, email=form.cleaned_data['email'], phone_number=form.cleaned_data['phone_number'], level=student_level)
        new_student.save()

        # creating student weekly reader
        WR = WeekReader(student=new_student)
        WR.save()
        
        messages.success(request, f'Student with admission number of {raw_identification_num} has been registered for training programme!')
        return redirect('auth:register_student')
    else:
      form = StudentSignupForm()
    context = {
      'all_dept': all_dept,
      'form': form,
    }
    return render(request, 'auth/register_student.html', context)
  

def error_400(request, exception):
  """this view handle 403 error"""
  return render(request, 'error/403.html')


def error_403(request, exception):
  """this view handle 403 error"""
  return render(request, 'error/403.html')


def error_404(request, exception):
  """this view handle 404 error"""
  return render(request, 'error/404.html')


def error_500(request):
  """this view handle 500 error"""
  return render(request, 'error/500.html')
