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
from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.conf import settings
from django.conf.urls.static import static

"""
    there are 4 already defined handler
    methods in `django.urls` functions.
"""
handler400 = 'account.views.error_400'
handler403 = 'account.views.error_403'
handler404 = 'account.views.error_404'
handler500 = 'account.views.error_500'


@login_required
def index(request):
    """this is landing page view"""
    from faculty.models import Faculty
    faculties = Faculty.objects.all()
    if request.user.first_name == '' or request.user.first_name == None or request.user.last_name == '' or request.user.last_name == None and request.user.is_student == True:
        # redirecting student to finish his/her profile registeration
        messages.success(request, f'Complate your profile registeration')
        return redirect('auth:student_profile_update')
    context = {
        'faculties': faculties,
    }
    return render(request, 'landing.html', context=context)


urlpatterns = [
    path('admin/', admin.site.urls),
    path('', index, name='landing'),
    path('', include('account.urls')),
    path('', include('administrator.urls')),
    path('', include('faculty.urls')),
    path('', include('department.urls')),
    path('', include('student.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
