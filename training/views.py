from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from faculty.models import Faculty
from department.models import Department, DepartmentTrainingCoordinator
from student.models import TrainingStudent


def trainingDirectorProfile(request):
  context = {
    "None": None,
  }
  return render(request, "training/training_director_profile.html", context=context)


def trainingManager(request):
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
    "faculties": faculties,
    "departments": departments,
    "all_dept_coord": all_dept_coord,
    "fclty": fclty,
    "dept": dept,
  }
  return render(request, "training/training_manager.html", context=context)
