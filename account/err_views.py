from django.urls import reverse
from django.shortcuts import render, redirect, HttpResponseRedirect


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
