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
from toolkit import (picture_name, y_session)
from toolkit.decorators import (
    block_student_update_profile, restrict_access_student_profile, val_id_num, check_phone_number, admin_required, dean_required, hod_required, coordinator_required, supervisor_required, schoolstaff_required, student_required, supervisor_or_student_required, coordinator_or_supervisor_or_student_required
)
from administrator.models import Administrator
from administrator.all_models import(
    Session, Faculty, Department, FacultyDean, DepartmentHOD, TrainingStudent, StudentSupervisor, DepartmentTrainingCoordinator, Letter, AcceptanceLetter, WeekReader, WeekScannedLogbook, CommentOnLogbook, StudentResult
)

"""
    there are 4 already defined handler
    methods in `django.urls` functions.
"""
handler400 = 'account.err_views.error_400'
handler403 = 'account.err_views.error_403'
handler404 = 'account.err_views.error_404'
handler500 = 'account.err_views.error_500'


@login_required
def index(request):
    """this is landing page view"""
    faculties = Faculty.objects.all()
    if request.user.first_name == '' or request.user.first_name == None or request.user.last_name == '' or request.user.last_name == None and request.user.is_student == True:
        # redirecting student to finish his/her profile registeration
        messages.success(request, f'Complate your profile registeration')
        return redirect('auth:student_profile_update')
    
    # the below condition will notify if new session is needed
    if request.user.is_admin:
        current_sch_sess = Session.objects.filter(
            is_current_session=True).last() # school session
        fun_sess=y_session() # from `y_session` function

        # spliting function session
        fun_split=fun_sess.split('/')
        fun_1=fun_split[0]
        fun_2=fun_split[1]

        # spliting current school session
        curr_split=current_sch_sess.session.split('/')
        curr_1=curr_split[0]
        curr_2=curr_split[1]

        # checking and comparing if both are equal to one
        if int(fun_1) - int(curr_1) == 1 and int(fun_2) - int(curr_2) == 1:
            messages.success(request, f'It seems new school session have to be created')
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
