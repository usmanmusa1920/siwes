from django.urls import reverse
from django.shortcuts import render, redirect
from django.contrib import messages
from django.core.paginator import Paginator
from django.db.models import Q
from django.contrib.auth.decorators import login_required
from faculty.models import Faculty
from department.models import Department, DepartmentHOD, DepartmentTrainingCoordinator, Letter
from student.models import TrainingStudent
from django.contrib.auth import get_user_model


User = get_user_model()


class Administrator:
  """Administrator related views"""

  @login_required
  @staticmethod
  def directorProfile(request):
    """director profile"""
    context = {
      'None': None,
    }
    return render(request, 'administrator/director_profile.html', context=context)


  @login_required
  @staticmethod
  def manager(request):
    """manager"""
    faculties = Faculty.objects.all()
    departments = Department.objects.all()
    all_dept_coord = DepartmentTrainingCoordinator.objects.all()

    if request.user.is_staff:
      fclty = Faculty.objects
      dept = DepartmentTrainingCoordinator.objects
    else:
      TS = TrainingStudent.objects.filter(matrix_no=request.user.identification_num).first() # Training student with matrix number of 2010310013
      fclty = TS.student_training_coordinator.dept_hod.department.faculty # Faculty of Science
      dept = TS.student_training_coordinator.dept_hod.department # Department of Physics
      
    context = {
      'faculties': faculties,
      'departments': departments,
      'all_dept_coord': all_dept_coord,
      'fclty': fclty,
      'dept': dept,
    }
    return render(request, 'administrator/manager.html', context=context)
  


class Activate:
  """Activate (and also deactivate previous) related views"""

  @login_required
  @staticmethod
  def administratorCoordinator(request, staff_user_id):
    """activate department coordinator"""
    new_active_coord = DepartmentTrainingCoordinator.objects.filter(id_no=staff_user_id).first()
    if new_active_coord.is_active:
      messages.success(request, f'This ({new_active_coord.id_no}) is  already the {new_active_coord.dept_hod.department.name} department training coordinator!')
      return redirect('administrator:filter_staff_user')
    new_active_coord.is_active = True
    new_active_coord.save()
    for coord in DepartmentTrainingCoordinator.objects.filter(is_active=True, dept_hod=new_active_coord.dept_hod):
      coord.is_active = False
      coord.save()
    messages.success(request, f'You just activate {new_active_coord.id_no} as {new_active_coord.dept_hod.department.name} department training coordinator!')
    return redirect('landing')
  

class Filter:
  """Filters related views"""

  @login_required
  @staticmethod
  def staffUser(request):
    """filter staff by ID number"""
    search_panel = request.GET.get('search_q')
    try:
      users_search = User.objects.filter(Q(identification_num__istartswith=search_panel) | Q(identification_num__contains=search_panel), is_staff=True).order_by('-date_joined')
    except:
      users_search = User.objects.filter(Q(identification_num=search_panel), is_staff=True).order_by('-date_joined')
    paginator = Paginator(users_search, 3)
    page = request.GET.get('page')
    users = paginator.get_page(page)
    context = {
      'users': users,
      'search_panel': search_panel,
    }
    return render(request, 'administrator/filter_staff_user.html', context=context)
