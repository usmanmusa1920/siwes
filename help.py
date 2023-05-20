# This script, it ease writing code in python interpreter

"""
The following are the functional requirements for the
SIWES portal:

i.)The administrator creates the profiles of students that are eligible to go for the SIWES program.

ii.)The system generates a list of the students that are eligible to go for the SIWES program.

iii.)Students log in to the portal and are identified with unique matriculation number and password (registration number) as assigned by the school and as stored in the database.

iv.)Students can fill their logbooks, edit them and view their logbook entry per week. They can also send and receive mails through the portal mailbox.

v.)Lecturers supervise activities of students on SIWES and comment and grade them on weekly basis.

vi.)Industry-based supervisors can monitor activities of students on SIWES in their company and comment and grade their logbooks weekly.

vii.)SIWES coordinator assigns a set of students to a supervisor from the institution.

viii.)Administrator creates user accounts for all user groups

NB: Scanned students` logbook in hardcopy is (as picture)
"""

"""
Datetime format:
  d = '01' to '31'
  j = '1' to '31'
  m = '01' to '12'
  n = '1' to '12'
  M = 'Jan'
  b = 'jan'
  F = 'May'
  y = '99'
  Y = '1999'
--------------------

pmake && pmigrate && python manage.py createsuperuser --email usmanmusa1920@gmail.com --first_name Usman --last_name Musa --identification_num 2010310013 && python manage.py createsuperuser --email okoyeikechukwu@yahoo.com --first_name Okoye --last_name Francis --identification_num 20232024 && pm

  If any issue when using the default user model
  (from django.contrib.auth.models import User)
  use the below tricks (export DJANGO_SETTINGS_MODULE=fugus.settings)

export DJANGO_SETTINGS_MODULE=fugus.settings
python

import django
django.setup()

import os
import json
import random
from administrator.models import Administrator
from faculty.models import Faculty, FacultyDean
from department.models import Department, DepartmentHOD, DepartmentTrainingCoordinator, Letter
from student.models import TrainingStudent, StudentLetterRequest, AcceptanceLetter
from django.contrib.auth import get_user_model


User = get_user_model()

# coping some dummy images as student acceptance letter
os.system('mkdir -p media/acceptance-letters/2023-acceptances/siwes/Science/Physics/l300')
os.system('cp dummy_img/banner.jpg media/acceptance-letters/2023-acceptances/siwes/Science/Physics/l300/banner.jpg')
os.system('cp dummy_img/education.jpg media/acceptance-letters/2023-acceptances/siwes/Science/Physics/l300/education.jpg')


# __________________
# TRAINING DIRECTORS

du1 = User(first_name="Olagoke", last_name="Abdul", identification_num="20151888", email="olagokeabdul@yahoo.com", phone_number="+2348144807200")
du2 = User(first_name="Ahmad", last_name="Aminu", identification_num="20151889", email="ahmadaminu@yahoo.com", phone_number="+2348144807201")
du3 = User(first_name="Ashiru", last_name="Lamido", identification_num="20151890", email="ashirulamido@yahoo.com", phone_number="+2348144807202")

du1.save()
du2.save()
du3.save()


td1 = Administrator(director=du1, first_name=du1.first_name, last_name=du1.last_name, email=du1.email, phone_number=du1.phone_number, id_no=du1.identification_num)
td2 = Administrator(director=du2, first_name=du2.first_name, last_name=du2.last_name, email=du2.email, phone_number=du2.phone_number, id_no=du2.identification_num)
td3 = Administrator(director=du3, first_name=du3.first_name, last_name=du3.last_name, email=du3.email, phone_number=du3.phone_number, id_no=du3.identification_num)

td1.save()
td2.save()
td3.save()


with open("raw.json") as f:
  r = json.load(f)

# _______
# FACULTY

for i in r:
  ff = Faculty(name=i["faculty"], email=i["faculty"]+"@mail.com", phone_number=i["phone"])
  ff.save()

my_fty1 = Faculty.objects.filter(name="Science").first()
my_fty2 = Faculty.objects.filter(name="Humanities").first()
my_fty3 = Faculty.objects.filter(name="Education").first()
my_fty4 = Faculty.objects.filter(name="Management & Social science").first()


# ____________
# FACULTY DEAN

fcd1 = User(first_name="Muhammad", last_name="Ahmad", identification_num="20161666", email="muhammadahmad@yahoo.com", phone_number="+2348144807203")
fcd2 = User(first_name="Sani", last_name="Aliyu", identification_num="20161667", email="sanialiyu@yahoo.com", phone_number="+2348144807204")
fcd3 = User(first_name="Alameen", last_name="Sambo", identification_num="20161668", email="alameensambo@yahoo.com", phone_number="+2348144807205")
fcd4 = User(first_name="Suraj", last_name="Haqil", identification_num="20161669", email="surajhaqil@yahoo.com", phone_number="+2348144807206")

fcd1.save()
fcd2.save()
fcd3.save()
fcd4.save()


fd1 = FacultyDean(dean=fcd1, faculty=my_fty1, first_name=fcd1.first_name, last_name=fcd1.last_name, email=fcd1.email, phone_number=fcd1.phone_number, id_no=fcd1.identification_num)
fd2 = FacultyDean(dean=fcd1, faculty=my_fty2, first_name=fcd2.first_name, last_name=fcd2.last_name, email=fcd2.email, phone_number=fcd2.phone_number, id_no=fcd2.identification_num)
fd3 = FacultyDean(dean=fcd1, faculty=my_fty3, first_name=fcd3.first_name, last_name=fcd3.last_name, email=fcd3.email, phone_number=fcd3.phone_number, id_no=fcd3.identification_num)
fd4 = FacultyDean(dean=fcd1, faculty=my_fty4, first_name=fcd4.first_name, last_name=fcd4.last_name, email=fcd4.email, phone_number=fcd4.phone_number, id_no=fcd4.identification_num)

fd1.save()
fd2.save()
fd3.save()
fd4.save()

# __________
# DEPARTMENT

for idx, i in enumerate(r):
  gf = Faculty.objects.filter(name=r[idx]["faculty"]).first()
  for g in r[idx]["dept"]:
    rr = random.randrange(300, 3000)
    dd = Department(name=g, email=g+"@mail.com", phone_number="+234"+str(rr)+g, faculty=gf)
    dd.save()

my_dept1 = Department.objects.filter(name="Physics").first()
my_dept2 = Department.objects.filter(name="Computer Science").first()
my_dept3 = Department.objects.filter(name="Mathematics").first()

# ______________
# DEPARTMENT HOD

ud1 = User(first_name="Lawal", last_name="Saad", identification_num="20191999", email="lawalsaad@yahoo.com", phone_number="+2349036632603")
ud2 = User(first_name="Ahmad", last_name="Jabaka", identification_num="20191920", email="ahmadjabaka@yahoo.com", phone_number="+2349036632604")
ud3 = User(first_name="Tanim", last_name="Mubarak", identification_num="20191921", email="tanimmubarak@yahoo.com", phone_number="+2349036632615")
ud4 = User(first_name="Nasir", last_name="Sanusi", identification_num="20232021", email="nasirsanusai@yahoo.com", phone_number="+2348135632605")
ud5 = User(first_name="Ema", last_name="Okonjo", identification_num="20232033", email="emaokonjo@yahoo.com", phone_number="+2348135632633")

ud1.save()
ud2.save()
ud3.save()
ud4.save()
ud5.save()

ud6 = User.objects.filter(identification_num="20232024").first()
ud6.middle_name = "Ikechukwu"
ud6.phone_number = "+2348135632603"
ud6.save()


dh1 = DepartmentHOD(hod=ud1, department=my_dept1, first_name=ud1.first_name, last_name=ud1.last_name, email=ud1.email, phone_number=ud1.phone_number, id_no=ud1.identification_num, universities="B.Sc (Ed), (UDUSOK Nig); PGDIP (BUK, Nig.); Msc, PhD (USIM Malaysia); CFTO", ranks="Ph.D")
dh2 = DepartmentHOD(hod=ud2, department=my_dept2, first_name=ud2.first_name, last_name=ud2.last_name, email=ud2.email, phone_number=ud2.phone_number, id_no=ud2.identification_num)
dh3 = DepartmentHOD(hod=ud3, department=my_dept3, first_name=ud3.first_name, last_name=ud3.last_name, email=ud3.email, phone_number=ud3.phone_number, id_no=ud3.identification_num)

dh1.save()
dh2.save()
dh3.save()

# ____________________
# TRAINING COORDINATOR

dtc1 = DepartmentTrainingCoordinator(coordinator=ud4, dept_hod=dh2, first_name=ud4.first_name, last_name=ud4.last_name, email=ud4.email, phone_number=ud4.phone_number, id_no=ud4.identification_num)
dtc2 = DepartmentTrainingCoordinator(coordinator=ud5, dept_hod=dh3, first_name=ud5.first_name, last_name=ud5.last_name, email=ud5.email, phone_number=ud5.phone_number, id_no=ud5.identification_num)
dtc3 = DepartmentTrainingCoordinator(coordinator=ud6, dept_hod=dh1, first_name=ud6.first_name, middle_name=ud6.middle_name, last_name=ud6.last_name, email=ud6.email, phone_number=ud6.phone_number, id_no=ud6.identification_num)

dtc1.save()
dtc2.save()
dtc3.save()

# ______
# LETTER

placement_lett = Letter(coordinator=dtc3, session="2023", text="This is our students placement letter")
acceptance_lett = Letter(coordinator=dtc3, session="2023", text="This is our students acceptance letter", letter="acceptance letter")
placement_lett.save()
acceptance_lett.save()

# _________________
# TRAINING STUDENTS

u1 = User.objects.get(id=1)
u1.is_staff = False
u1.save()

u2 = User(first_name="Shehu", last_name="Musa", identification_num="201031002", email="usmanmusa2019@gmail.com", phone_number="+2348144807260")
u3 = User(first_name="Benjamin", last_name="Omoniyi", identification_num="201031003", email="benjamin@gmail.com", phone_number="+2348144807211")
u4 = User(first_name="Abdulhakeem", last_name="Odoi", identification_num="201031004", email="odoi@gmail.com", phone_number="+2348144807222")
u5 = User(first_name="Muhammad", last_name="Amin", identification_num="201031005", email="moh'd@mail.com", phone_number="+2348144807233")

u2.save()
u3.save()
u4.save()
u5.save()

# ________________
# TRAINING STUDENT

me_stdent1 = TrainingStudent(student=u1, student_training_coordinator=dtc3, first_name=u1.first_name, last_name=u1.last_name, matrix_no=u1.identification_num, email=u1.email, phone_number=u1.phone_number, level='300')
me_stdent2 = TrainingStudent(student=u2, student_training_coordinator=dtc3, first_name=u2.first_name, last_name=u2.last_name, matrix_no=u2.identification_num, email=u2.email, phone_number=u2.phone_number)
me_stdent3 = TrainingStudent(student=u3, student_training_coordinator=dtc3, first_name=u3.first_name, last_name=u3.last_name, matrix_no=u3.identification_num, email=u3.email, phone_number=u3.phone_number)
me_stdent4 = TrainingStudent(student=u4, student_training_coordinator=dtc3, first_name=u4.first_name, last_name=u4.last_name, matrix_no=u4.identification_num, email=u4.email, phone_number=u4.phone_number)
me_stdent5 = TrainingStudent(student=u5, student_training_coordinator=dtc3, first_name=u5.first_name, last_name=u5.last_name, matrix_no=u5.identification_num, email=u5.email, phone_number=u5.phone_number)

me_stdent1.save()
me_stdent2.save()
me_stdent3.save()
me_stdent4.save()
me_stdent5.save()

# adding `2010310013` as approved training student. But I will
# make it `TrainingStudent` instance instead of `User` instance
dtc3.training_students.add(u1)

# ______________________
# STUDENT LETTER REQUEST

req_let1 = StudentLetterRequest(sender_req=me_stdent1, receiver_req=dtc3)
req_let2 = StudentLetterRequest(sender_req=me_stdent2, receiver_req=dtc3)

req_let1.save()
req_let2.save()

# _________________
# ACCEPTANCE LETTER

my_accept1 = AcceptanceLetter(sender_acept=me_stdent1, receiver_acept=dtc3, level="300", image="acceptance-letters/2023-acceptances/siwes/Science/Physics/l300/banner.jpg")
my_accept2 = AcceptanceLetter(sender_acept=me_stdent2, receiver_acept=dtc3, level="200", image="acceptance-letters/2023-acceptances/siwes/Science/Physics/l300/education.jpg")

my_accept1.save()
my_accept2.save()


"""
