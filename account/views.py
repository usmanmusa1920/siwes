from django.urls import reverse
from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.contrib.auth.views import LoginView, LogoutView
from django.contrib.sites.shortcuts import get_current_site
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth import update_session_auth_hash
from .forms import PasswordChangeForm, SignupForm
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
      "site": current_site,
      "site_name": current_site.name,
      **(self.extra_context or {})
    })
    return context


class LogoutCustom(LoginRequiredMixin ,LogoutView):
  """account logout class"""
  def get_context_data(self, **kwargs):
    context = super().get_context_data(**kwargs)
    current_site = get_current_site(self.request)
    context.update({
      "site": current_site,
      "site_name": current_site.name,
      # "title": _("Logged out"),
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
      messages.success(request, f"That sound great {request.user.first_name}, your password has been changed")
      return redirect(reverse("landing"))
    else:
      context = {
        "form": form
      }
      return render(request, "auth/change_password.html", context)
  return False


  
class Register:
  """These includes views for registering staffs and students' profiles"""

  @login_required
  @staticmethod
  def student(request):
    """register student"""
    if request.user.is_staff == False:
      # block anyone from getting access to the register page of student if he/she is not a staff
      return False
    all_dept = DepartmentTrainingCoordinator.objects.filter(is_active=True)
    """
      we use `DepartmentTrainingCoordinator` table to grab departments name, because at some case, some department they will not register their siwes coordinator on time, if so happen and student of that department trying to register (the one incharge to register him), he will get an error even though his department name will show up in the drop down menu of the register page.
    """
    if request.method == 'POST':
      form = SignupForm(request.POST)
      if form.is_valid():
        form.save()

        all_department = request.POST["all_department"]
        raw_identification_num = form.cleaned_data["identification_num"]
        student_level = form.cleaned_data["student_level"]
        messages.success(request, f'Student with admission number of {raw_identification_num} has been registered for training programme!')
        
        student_department = Department.objects.filter(name=all_department).first()
        student_dept_hod = DepartmentHOD.objects.filter(department=student_department).first()
        student_coord = DepartmentTrainingCoordinator.objects.filter(dept_hod=student_dept_hod).first()
        new_usr = User.objects.filter(identification_num=raw_identification_num).first()
        
        new_student =  TrainingStudent(student=new_usr, student_training_coordinator=student_coord, first_name=form.cleaned_data["first_name"], last_name=form.cleaned_data["last_name"], matrix_no=raw_identification_num, email=form.cleaned_data["email"], phone_number=form.cleaned_data["phone_number"], level=student_level)
        new_student.save()

        # creating student week reader
        WR = WeekReader(student=new_student)
        WR.save()
        
        return redirect('auth:register_student')
    else:
      form = SignupForm()
    context = {
      "all_dept": all_dept,
      "form": form,
    }
    return render(request, 'auth/register_student.html', context)



def error_400(request, exception):
  """this view handle 403 error"""
  return render(request, "error/403.html")


  
def error_403(request, exception):
  """this view handle 403 error"""
  return render(request, "error/403.html")


  
def error_404(request, exception):
  """this view handle 404 error"""
  return render(request, "error/404.html")


  
def error_500(request):
  """this view handle 500 error"""
  return render(request, "error/500.html")
