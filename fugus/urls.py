"""fugus URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include

"""
    there are 4 already defined handler
    methods in `django.urls` functions.
"""
# handler403 = 'account.views.error_403'
# handler404 = 'account.views.error_404'
# handler500 = 'account.views.error_500'

from django.shortcuts import render
def index(request):
    return render(request, "landing.html")
def profile_student(request):
    return render(request, "profile_student.html")
def profile_staff(request):
    return render(request, "profile_staff.html")
def register_student(request):
    return render(request, "register_student.html")
def acceptance_letter(request):
    return render(request, "acceptance_letter.html")
def placement_letter(request):
    return render(request, "placement_letter.html")
def login(request):
    return render(request, "auth/login.html")
def signup(request):
    return render(request, "auth/signup.html")
def change_password(request):
    return render(request, "auth/change_password.html")

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", index),
    path("profile_student/", profile_student),
    path("profile_staff/", profile_staff),
    path("register_student/", register_student),
    path("login/", login),
    path("signup/", signup),
    path("placement_letter/", placement_letter),
    path("acceptance_letter/", acceptance_letter),
    path("change_password/", change_password),
    path("", include('training.urls')),
    path("", include('faculty.urls')),
    path("", include('department.urls')),
    path("", include('student.urls')),
]
