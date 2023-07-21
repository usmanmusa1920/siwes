from django.urls import reverse
from django.shortcuts import render, redirect
from django.contrib import messages
from django.core.paginator import Paginator
from django.db.models import Q
from django.contrib.auth.decorators import login_required
from django.contrib.auth import get_user_model
from toolkit import (picture_name, y_session)
from toolkit.decorators import (
    block_student_update_profile, restrict_access_student_profile, val_id_num, check_phone_number, admin_required, dean_required, hod_required, coordinator_required, supervisor_required, schoolstaff_required, student_required, supervisor_or_student_required, coordinator_or_supervisor_or_student_required
)
from .models import Administrator
from .all_models import(
    Session, Faculty, Department, FacultyDean, DepartmentHOD, TrainingStudent, StudentSupervisor, DepartmentTrainingCoordinator, Letter, AcceptanceLetter, WeekReader, WeekScannedLogbook, CommentOnLogbook, StudentResult
)


User = get_user_model()


class Active:
    """This class include active (incumbent) staff related method"""

    @admin_required
    @staticmethod
    def facultyDean(request):
        """active faculty deans"""
        
        active_department_hod = FacultyDean.objects.filter(is_active=True).all()
        paginator = Paginator(active_department_hod, 10)
        page = request.GET.get('page')
        users = paginator.get_page(page)
        context = {
            'users': users,
        }
        return render(request, 'administrator/active_faculty_dean.html', context=context)
    
    @admin_required
    @staticmethod
    def departmentHod(request):
        """active department HOD"""
        
        active_department_hod = DepartmentHOD.objects.filter(is_active=True).all()
        paginator = Paginator(active_department_hod, 10)
        page = request.GET.get('page')
        users = paginator.get_page(page)
        context = {
            'users': users,
        }
        return render(request, 'administrator/active_department_hod.html', context=context)
    
    @admin_required
    @staticmethod
    def departmentTrainingCoordinator(request):
        """active departmenttraining coordinator"""
        
        active_department_coord = DepartmentTrainingCoordinator.objects.filter(is_active=True).all()
        paginator = Paginator(active_department_coord, 10)
        page = request.GET.get('page')
        users = paginator.get_page(page)
        context = {
            'users': users,
        }
        return render(request, 'administrator/active_department_coord.html', context=context)
    

class Activate:
    """Activate (and also deactivate previous) related views"""

    @admin_required
    @staticmethod
    def facultyDean(request, staff_user_id):
        """activate (and also deactivate previous) new faculty dean"""
        
        new_active_dean = FacultyDean.objects.filter(id_no=staff_user_id).first()
        if new_active_dean.is_active:
            messages.success(request, f'This ({new_active_dean.id_no}) is already the dean of faculty of {new_active_dean.faculty.name}')
            return redirect('auth:general_profile', id_no=staff_user_id)
        new_active_dean.is_active = True
        new_active_dean.save()
        for dean in FacultyDean.objects.filter(is_active=True, faculty=new_active_dean.faculty):
            if dean == new_active_dean:
                pass
            else:
                dean.is_active = False
                dean.save()
        messages.success(
            request, f'You just activate {new_active_dean.id_no} as faculty of {new_active_dean.faculty.name} new dean')
        return redirect('administrator:filter_faculty_dean')

    @admin_required
    @staticmethod
    def departmentHOD(request, staff_user_id):
        """activate (and also deactivate previous) new department HOD"""
        
        new_active_hod = DepartmentHOD.objects.filter(id_no=staff_user_id).first()
        if new_active_hod.is_active == True:
            messages.success(request, f'This ({new_active_hod.id_no}) is already the {new_active_hod.department.name} department H.O.D')
            return redirect('auth:general_profile', id_no=staff_user_id)
        new_active_hod.is_active = True
        new_active_hod.save()
        for hod in DepartmentHOD.objects.filter(is_active=True, department=new_active_hod.department):
            if hod == new_active_hod:
                pass
            else:
                hod.is_active = False
                hod.save()
        messages.success(
            request, f'You just activate {new_active_hod.id_no} as {new_active_hod.department.name} department new H.O.D')
        return redirect('administrator:filter_department_hod')

    @admin_required
    @staticmethod
    def departmentTrainingCoordinator(request, staff_user_id):
        """activate (and also deactivate previous) new department training coordinator"""
        
        new_active_coord = DepartmentTrainingCoordinator.objects.filter(id_no=staff_user_id).first()
        if new_active_coord.is_active == True:
            messages.success(request, f'This ({new_active_coord.id_no}) is already the {new_active_coord.dept_hod.department.name} department training coordinator!')
            return redirect('auth:general_profile', id_no=staff_user_id)
        new_active_coord.is_active = True
        new_active_coord.save()
        for coord in DepartmentTrainingCoordinator.objects.filter(is_active=True, dept_hod=new_active_coord.dept_hod):
            if coord == new_active_coord:
                pass
            else:
                coord.is_active = False
                coord.save()
        messages.success(
            request, f'You just activate {new_active_coord.id_no} as {new_active_coord.dept_hod.department.name} department training coordinator!')
        return redirect('administrator:filter_department_training_coordinator')


class Filter:
    """Filters related views"""

    @admin_required
    @staticmethod
    def staff(request):
        """filter staff by ID number"""
        
        search_panel = request.GET.get('search_q')
        # quering all school staff users
        try:
            users_search = User.objects.filter(Q(identification_num__istartswith=search_panel) | Q(identification_num__contains=search_panel), is_schoolstaff=True).order_by('-date_joined')
        except:
            users_search = User.objects.filter(Q(identification_num=search_panel), is_schoolstaff=True).order_by('-date_joined')
        paginator = Paginator(users_search, 10)
        page = request.GET.get('page')
        users = paginator.get_page(page)
        context = {
            'users': users,
            'search_panel': search_panel,
        }
        return render(request, 'administrator/filter_school_staff.html', context=context)
    
    @admin_required
    @staticmethod
    def administrator(request):
        """filter administrator by ID number"""
        
        search_panel = request.GET.get('search_q')
        # quering all administrator users
        try:
            users_search = Administrator.objects.filter(Q(id_no__istartswith=search_panel) | Q(id_no__contains=search_panel)).order_by('-date_joined')
        except:
            users_search = Administrator.objects.filter(Q(id_no=search_panel)).order_by('-date_joined')
        paginator = Paginator(users_search, 10)
        page = request.GET.get('page')
        users = paginator.get_page(page)
        context = {
            'users': users,
            'search_panel': search_panel,
        }
        return render(request, 'administrator/filter_administrator.html', context=context)

    @admin_required
    @staticmethod
    def facultyDean(request):
        """filter faculty dean by ID number"""
        
        search_panel = request.GET.get('search_q')
        # quering all registered faculty dean
        try:
            deans_search = FacultyDean.objects.filter(Q(id_no__istartswith=search_panel) | Q(id_no__contains=search_panel)).order_by('-date_joined')
        except:
            deans_search = FacultyDean.objects.filter(Q(id_no=search_panel)).order_by('-date_joined')
        paginator = Paginator(deans_search, 10)
        page = request.GET.get('page')
        users = paginator.get_page(page)
        context = {
            'users': users,
            'search_panel': search_panel,
        }
        return render(request, 'administrator/filter_faculty_dean.html', context=context)
    
    @admin_required
    @staticmethod
    def departmentHod(request):
        """filter department HOD by ID number"""
        
        search_panel = request.GET.get('search_q')
        # quering all registered department HOD
        try:
            deans_search = DepartmentHOD.objects.filter(Q(id_no__istartswith=search_panel) | Q(id_no__contains=search_panel)).order_by('-date_joined')
        except:
            deans_search = DepartmentHOD.objects.filter(Q(id_no=search_panel)).order_by('-date_joined')
        paginator = Paginator(deans_search, 10)
        page = request.GET.get('page')
        users = paginator.get_page(page)
        context = {
            'users': users,
            'search_panel': search_panel,
        }
        return render(request, 'administrator/filter_department_hod.html', context=context)
    
    @admin_required
    @staticmethod
    def departmentTrainingCoordinator(request):
        """filter department training coordinator by ID number"""
        
        search_panel = request.GET.get('search_q')
        # quering all registered department training coordinator
        try:
            deans_search = DepartmentTrainingCoordinator.objects.filter(Q(id_no__istartswith=search_panel) | Q(id_no__contains=search_panel)).order_by('-date_joined')
        except:
            deans_search = DepartmentTrainingCoordinator.objects.filter(Q(id_no=search_panel)).order_by('-date_joined')
        paginator = Paginator(deans_search, 10)
        page = request.GET.get('page')
        users = paginator.get_page(page)
        context = {
            'users': users,
            'search_panel': search_panel,
        }
        return render(request, 'administrator/filter_department_training_coordinator.html', context=context)
    
    @admin_required
    @staticmethod
    def studentSupervisor(request):
        """filter student supervisor by ID number"""
        
        search_panel = request.GET.get('search_q')
        # quering all student supervisor
        try:
            users_search = StudentSupervisor.objects.filter(Q(id_no__istartswith=search_panel) | Q(id_no__contains=search_panel)).order_by('-date_joined')
        except:
            users_search = StudentSupervisor.objects.filter(Q(id_no=search_panel)).order_by('-date_joined')
        paginator = Paginator(users_search, 10)
        page = request.GET.get('page')
        users = paginator.get_page(page)
        context = {
            'users': users,
            'search_panel': search_panel,
        }
        return render(request, 'administrator/filter_student_supervisor.html', context=context)
    
    @admin_required
    @staticmethod
    def student(request):
        """filter student by ID number"""
        
        search_panel = request.GET.get('search_q')
        # quering all student
        try:
            users_search = TrainingStudent.objects.filter(Q(matrix_no__istartswith=search_panel) | Q(matrix_no__contains=search_panel)).order_by('-date_joined')
        except:
            users_search = TrainingStudent.objects.filter(Q(matrix_no=search_panel)).order_by('-date_joined')
        paginator = Paginator(users_search, 10)
        page = request.GET.get('page')
        users = paginator.get_page(page)
        context = {
            'users': users,
            'search_panel': search_panel,
        }
        return render(request, 'administrator/filter_student.html', context=context)
