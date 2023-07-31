# -*- coding: utf-8 -*-
from django.urls import reverse
from django.shortcuts import render, redirect, HttpResponseRedirect
from django.contrib import messages
from django.contrib.auth.decorators import login_required


def block_student_update_profile(request, r_user):
    """
    blocking student from updating his/her profile, if it is up to date
    """
    if r_user.first_name != '' and r_user.first_name != None and r_user.last_name != '' and r_user.last_name != None and r_user.is_student == True:
        messages.success(request, f'Your profile is already updated {r_user.first_name}!')
        return redirect(reverse('student:profile', kwargs={'matrix_no': r_user.identification_num}))
    

def restrict_access_student_profile(request, id_no):
    """
    restricting any student from getting access to other students` profile
    but allowing himself and staff user to get access to it
    """
    if request.user.is_schoolstaff == False and request.user.identification_num != id_no:
        messages.warning(request, f'Can\'t get access to ({id_no}) profile')
        return redirect('student:profile', matrix_no=request.user.identification_num)
    

def val_id_num(request, raw_identification_num):
    """
    restricting accepting identification number which type is any, apart from integer
    for students
    """
    try:
        if type(eval(raw_identification_num)) == int:
            # trying to see if the identification number type is `int` it will pass
            pass
    except:
        # if the identification number type is not `int` then it will handle the error here by redirecting back to the student register page with a flash message
        messages.warning(request, f'Invalid identification number ({raw_identification_num}) it should be all number')
        return redirect('auth:register_student')
    

def check_phone_number(*args_1, **kwargs_1):
    """
    `check_phone_number` is the decorator factory, equivalent to the
    convention name usually given as `decorator_factory`
    
    This decorator (validate phone number decorator) for checking user
    phone number if it is in international format (start with +)
    """
    def decorator(view):
        def wrapper(request, *args_2, **kwargs_2):
            if request.POST != {}:
                if request.POST['phone_number'].startswith('+') == False:
                    messages.warning(request, f'Invalid phone number, it shoulde be in international format `e.g +12125552368`')
                    # redirect_where: is the redirected url we want to redirect user to
                    return redirect(kwargs_1['redirect_where'])
            return view(request, *args_2, **kwargs_2)
        return wrapper
    return decorator


def staff_required(view):
    """
    decorator that block anyone from getting access to some routes (pages) which is
    only administrator who is staff will grant access to
    """
    @login_required
    def wrapper(request, *args, **kwargs):
        if request.user.is_staff == False:
            return False
        return view(request, *args, **kwargs)
    return wrapper


def admin_required(view):
    """
    decorator that block anyone from getting access to some routes (pages) which is
    only administrator will grant access to
    """
    @login_required
    def wrapper(request, *args, **kwargs):
        if request.user.is_admin == False:
            return False
        return view(request, *args, **kwargs)
    return wrapper


def vc_required(view):
    """
    decorator that block anyone from getting access to some routes (pages) which is
    only school vc will grant access to
    """
    @login_required
    def wrapper(request, *args, **kwargs):
        if request.user.is_vc == False:
            return False
        return view(request, *args, **kwargs)
    return wrapper


def hod_required(view):
    """
    decorator that block anyone from getting access to some routes (pages) which is
    only HOD will grant access to
    """
    @login_required
    def wrapper(request, *args, **kwargs):
        if request.user.is_hod == False:
            return False
        return view(request, *args, **kwargs)
    return wrapper


def coordinator_required(view):
    """
    decorator that block anyone from getting access to some routes (pages) which is
    only training coordinator will grant access to
    """

    @login_required
    def wrapper(request, *args, **kwargs):
        if request.user.is_coordinator == False:
            return False
        return view(request, *args, **kwargs)
    return wrapper


def supervisor_required(view):
    """
    decorator that block anyone from getting access to some routes (pages) which is
    only student supervisor will grant access to
    """
    @login_required
    def wrapper(request, *args, **kwargs):
        if request.user.is_supervisor == False:
            return False
        return view(request, *args, **kwargs)
    return wrapper


def schoolstaff_required(view):
    """
    decorator that block anyone from getting access to some routes (pages) which is
    only school staff will grant access to
    """
    @login_required
    def wrapper(request, *args, **kwargs):
        if request.user.is_schoolstaff == False:
            return False
        return view(request, *args, **kwargs)
    return wrapper


def student_required(view):
    """
    decorator that block anyone from getting access to some routes (pages) which is
    only student will grant access to
    """
    @login_required
    def wrapper(request, *args, **kwargs):
        if request.user.is_student == False:
            return False
        return view(request, *args, **kwargs)
    return wrapper


def coordinator_or_student_required(view):
    """
    decorator that block anyone from getting access to some routes (pages) which is
    only student coordinator, and the student will grant access to
    """
    @login_required
    def wrapper(request, *args, **kwargs):
        if request.user.is_admin or request.user.is_vc or request.user.is_hod or request.user.is_supervisor:
            return False
        return view(request, *args, **kwargs)
    return wrapper


def supervisor_or_student_required(view):
    """
    decorator that block anyone from getting access to some routes (pages) which is
    only student supervisor, and the student will grant access to
    """
    @login_required
    def wrapper(request, *args, **kwargs):
        if request.user.is_admin or request.user.is_vc or request.user.is_hod or request.user.is_coordinator:
            return False
        return view(request, *args, **kwargs)
    return wrapper


def coordinator_or_supervisor_or_student_required(view):
    """
    decorator that block anyone from getting access to some routes (pages) which is
    only coordinator, supervisor, and the student will grant access to
    """
    @login_required
    def wrapper(request, *args, **kwargs):
        if request.user.is_admin or request.user.is_vc or request.user.is_hod:
            return False
        return view(request, *args, **kwargs)
    return wrapper
