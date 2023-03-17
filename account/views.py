from django.urls import reverse
from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth.views import LoginView, LogoutView
from django.contrib.sites.shortcuts import get_current_site
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth import update_session_auth_hash
from .forms import PasswordChangeForm, SignupForm
from department.models import Department, DepartmentHOD, DepartmentTrainingCoordinator
from student.models import TrainingStudent
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


  
def signup(request):
  if request.method == 'POST':
    all_dept = DepartmentTrainingCoordinator.objects.all()
    """
      we use `DepartmentTrainingCoordinator` table to grab departments name, because at some case, some department they will not register their siwes coordinator on time, if so happen and student of that department trying to register, he will get an error even though his department name will show up in the drop down menu of the signup page.
    """
    form = SignupForm(request.POST)
    if form.is_valid():
      form.save()

      all_department = request.POST["all_department"]
      raw_identification_num = form.cleaned_data["identification_num"]
      messages.success(request, f'Welcome {raw_identification_num}, your account has been created, you are ready to login!')
      
      student_department = Department.objects.filter(name=all_department).first()
      student_dept_hod = DepartmentHOD.objects.filter(department=student_department).first()
      student_coord = DepartmentTrainingCoordinator.objects.filter(dept_hod=student_dept_hod).first()
      new_usr = User.objects.filter(identification_num=raw_identification_num).first()
      
      new_student =  TrainingStudent(student=new_usr, student_training_coordinator=student_coord, first_name=form.cleaned_data["first_name"], last_name=form.cleaned_data["last_name"], matrix_no=raw_identification_num, email=form.cleaned_data["email"], phone_number=form.cleaned_data["phone_number"])
      new_student.save()
      
      return redirect('auth:login')
  else:
    all_dept = DepartmentTrainingCoordinator.objects.all()
    form = SignupForm()
  context = {
    "all_dept": all_dept,
    "form": form,
  }
  return render(request, 'auth/signup.html', context)



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
