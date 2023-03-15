
"""
  If any issue when using the default user model
  (from django.contrib.auth.models import User)
  use the below tricks

pmigrate && python manage.py createsuperuser --email usmanmusa1920@gmail.com --first_name usman --last_name musa --identification_num 2010310013 && pm

export DJANGO_SETTINGS_MODULE=fugus.settings

import django
django.setup()

import json
import random
from training.models import TrainingDirector
from faculty.models import Faculty, FacultyDean
from department.models import Department, DepartmentHOD, DepartmentTrainingCoordinator, Letter
from student.models import TrainingStudent, StudentLetterRequest, AcceptanceLetter
from django.contrib.auth import get_user_model


User = get_user_model()


u1 = User.objects.get(id=1)
u2 = User(first_name="Shehu", last_name="Musa", identification_num="201031002", email="usmanmusa2019@gmail.com", phone_number="+2348144807260")
u3 = User(first_name="Benjamin", last_name="Omoniyi", identification_num="201031003", email="benjamin@gmail.com", phone_number="+2348144807211")
u4 = User(first_name="Abdulhakeem", last_name="Odoi", identification_num="201031004", email="odoi@gmail.com", phone_number="+2348144807222")
u5 = User(first_name="Muhammad", last_name="Amin", identification_num="201031005", email="moh'd@mail.com", phone_number="+2348144807233")

u2.save()
u3.save()
u4.save()
u5.save()


td1 = TrainingDirector(first_name="Olagoke", last_name="Abdul", email="olagokeabdul@yahoo.com", phone_number="+23497772601", id_no="20151888")
td2 = TrainingDirector(first_name="Ahmad", last_name="Aminu", email="ahmadaminu@yahoo.com", phone_number="+23497772602", id_no="20151889")
td3 = TrainingDirector(first_name="Ashiru", last_name="Lamido", email="ashirulamido@yahoo.com", phone_number="+23497772603", id_no="20151890")

td1.save()
td2.save()
td3.save()


with open("raw.json") as f:
  r = json.load(f)


for i in r:
  rr = random.randrange(100, 1000)
  ff = Faculty(name=i["faculty"], email=i["faculty"]+"@mail.com", phone_number="+234"+str(rr))
  ff.save()


my_fty1 = Faculty.objects.filter(name="Science").first()
my_fty2 = Faculty.objects.filter(name="Humanities").first()
my_fty3 = Faculty.objects.filter(name="Education").first()
my_fty4 = Faculty.objects.filter(name="Management & Social science").first()

fd1 = FacultyDean(faculty=my_fty1, first_name="Muhammad", last_name="Ahmad", email="muhammadahmad@yahoo.com", phone_number="+2349098732603", id_no="20161666")
fd2 = FacultyDean(faculty=my_fty2, first_name="Sani", last_name="Aliyu", email="sanialiyu@yahoo.com", phone_number="+2349098732604", id_no="20161667")
fd3 = FacultyDean(faculty=my_fty3, first_name="Alameen", last_name="Sambo", email="alameensambo@yahoo.com", phone_number="+2349098732605", id_no="20161668")
fd4 = FacultyDean(faculty=my_fty4, first_name="Suraj", last_name="Haqil", email="surajhaqil@yahoo.com", phone_number="+2349098732606", id_no="20161669")

fd1.save()
fd2.save()
fd3.save()
fd4.save()


for idx, i in enumerate(r):
  gf = Faculty.objects.filter(name=r[idx]["faculty"]).first()
  for g in r[idx]["dept"]:
    rr = random.randrange(300, 3000)
    dd = Department(name=g, email=g+"@mail.com", phone_number="+234"+str(rr)+g, faculty=gf)
    dd.save()


my_dept1 = Department.objects.filter(name="Physics").first()
my_dept2 = Department.objects.filter(name="Computer Science").first()
my_dept3 = Department.objects.filter(name="Mathematics").first()

dh1 = DepartmentHOD(department=my_dept1, first_name="Lawal", last_name="Saad", email="lawalsaad@yahoo.com", phone_number="+2349036632603", id_no="20191999")
dh2 = DepartmentHOD(department=my_dept2, first_name="Ahmad", last_name="Jabaka", email="ahmadjabaka@yahoo.com", phone_number="+2349036632604", id_no="20191920")
dh3 = DepartmentHOD(department=my_dept3, first_name="Tanim", last_name="Mubarak", email="tanimmubarak@yahoo.com", phone_number="+2349036632615", id_no="20191921")

dh1.save()
dh2.save()
dh3.save()


my_hod1 = DepartmentHOD.objects.filter(department=my_dept2).first()
my_hod2 = DepartmentHOD.objects.filter(department=my_dept3).first()
my_hod3 = DepartmentHOD.objects.filter(department=my_dept1).first()

dtc1 = DepartmentTrainingCoordinator(dept_hod=my_hod1, first_name="Nasir", last_name="Sanusi", email="nasirsanusai@yahoo.com", phone_number="+2348135632605", id_no="20232021")
dtc2 = DepartmentTrainingCoordinator(dept_hod=my_hod2, first_name="Ema", last_name="Okonjo", email="emaokonjo@yahoo.com", phone_number="+2348135632633", id_no="20232033")
dtc3 = DepartmentTrainingCoordinator(dept_hod=my_hod3, first_name="Okoye", last_name="Ikechukwu", email="okoyeikechukwu@yahoo.com", phone_number="+2348135632603", id_no="20232000")

dtc1.save()
dtc2.save()
dtc3.save()


lett = Letter(coordinator=dtc3, session="2022/2023", text="This is our students letter")
lett.save()


me_stdent1 = TrainingStudent(student=u1, student_training_coordinator=dtc3, first_name=u1.first_name, last_name=u1.last_name, matrix_no=u1.identification_num, email=u1.email, phone_number=u1.phone_number)
me_stdent2 = TrainingStudent(student=u2, student_training_coordinator=dtc3, first_name=u2.first_name, last_name=u2.last_name, matrix_no=u2.identification_num, email=u2.email, phone_number=u2.phone_number)
me_stdent3 = TrainingStudent(student=u3, student_training_coordinator=dtc3, first_name=u3.first_name, last_name=u3.last_name, matrix_no=u3.identification_num, email=u3.email, phone_number=u3.phone_number)
me_stdent4 = TrainingStudent(student=u4, student_training_coordinator=dtc3, first_name=u4.first_name, last_name=u4.last_name, matrix_no=u4.identification_num, email=u4.email, phone_number=u4.phone_number)
me_stdent5 = TrainingStudent(student=u5, student_training_coordinator=dtc3, first_name=u5.first_name, last_name=u5.last_name, matrix_no=u5.identification_num, email=u5.email, phone_number=u5.phone_number)

me_stdent1.save()
me_stdent2.save()
me_stdent3.save()
me_stdent4.save()
me_stdent5.save()


req_let1 = StudentLetterRequest(sender_req=me_stdent1, receiver_req=dtc3)
req_let2 = StudentLetterRequest(sender_req=me_stdent2, receiver_req=dtc3)

req_let1.save()
req_let2.save()


my_accept1 = AcceptanceLetter(sender_acept=me_stdent1, receiver_acept=dtc3, image="/home/usman/Desktop/media/1-quantum.jpg")
my_accept2 = AcceptanceLetter(sender_acept=me_stdent2, receiver_acept=dtc3, image="/home/usman/Desktop/media/Usman.jpg")

my_accept1.save()
my_accept2.save()


"""
