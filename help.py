
"""
  If any issue when using the default user model
  (from django.contrib.auth.models import User)
  use the below tricks

pmake && pmigrate && python manage.py createsuperuser --email usmanmusa1920@gmail.com --first_name Usman --last_name Musa --identification_num 2010310013 && python manage.py createsuperuser --email okoyeikechukwu@yahoo.com --first_name Okoye --last_name Francis --identification_num 20232024 && pm

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


# __________________
# TRAINING DIRECTORS

du1 = User(first_name="Olagoke", last_name="Abdul", identification_num="20151888", email="olagokeabdul@yahoo.com", phone_number="+23497772601")
du2 = User(first_name="Ahmad", last_name="Aminu", identification_num="20151889", email="ahmadaminu@yahoo.com", phone_number="+23497772602")
du3 = User(first_name="Ashiru", last_name="Lamido", identification_num="20151890", email="ashirulamido@yahoo.com", phone_number="+23497772603")

du1.save()
du2.save()
du3.save()

td1 = TrainingDirector(director=du1, first_name=du1.first_name, last_name=du1.last_name, email=du1.email, phone_number=du1.phone_number, id_no=du1.identification_num)
td2 = TrainingDirector(director=du2, first_name=du2.first_name, last_name=du2.last_name, email=du2.email, phone_number=du2.phone_number, id_no=du2.identification_num)
td3 = TrainingDirector(director=du3, first_name=du3.first_name, last_name=du3.last_name, email=du3.email, phone_number=du3.phone_number, id_no=du3.identification_num)

td1.save()
td2.save()
td3.save()


with open("raw.json") as f:
  r = json.load(f)

# _______
# FACULTY

for i in r:
  rr = random.randrange(100, 1000)
  ff = Faculty(name=i["faculty"], email=i["faculty"]+"@mail.com", phone_number="+234"+str(rr))
  ff.save()


my_fty1 = Faculty.objects.filter(name="Science").first()
my_fty2 = Faculty.objects.filter(name="Humanities").first()
my_fty3 = Faculty.objects.filter(name="Education").first()
my_fty4 = Faculty.objects.filter(name="Management & Social science").first()

# ____________
# FACULTY DEAN

fcd1 = User(first_name="Muhammad", last_name="Ahmad", identification_num="20161666", email="muhammadahmad@yahoo.com", phone_number="+2349098732603")
fcd2 = User(first_name="Sani", last_name="Aliyu", identification_num="20161667", email="sanialiyu@yahoo.com", phone_number="+2349098732604")
fcd3 = User(first_name="Alameen", last_name="Sambo", identification_num="20161668", email="alameensambo@yahoo.com", phone_number="+2349098732605")
fcd4 = User(first_name="Suraj", last_name="Haqil", identification_num="20161669", email="surajhaqil@yahoo.com", phone_number="+2349098732606")

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

ud6 = User.objects.filter(identification_num="20232024").first()
ud6.middle_name = "Ikechukwu"
ud6.phone_number = "+2348135632603"
ud6.save()

ud1.save()
ud2.save()
ud3.save()
ud4.save()
ud5.save()

dh1 = DepartmentHOD(hod=ud1, department=my_dept1, first_name=ud1.first_name, last_name=ud1.last_name, email=ud1.email, phone_number=ud1.phone_number, id_no=ud1.identification_num)
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


lett = Letter(coordinator=dtc3, session="2022/2023", text="This is our students letter")
lett.save()

# _________________
# TRAINING STUDENTS

u1 = User.objects.get(id=1)

u2 = User(first_name="Shehu", last_name="Musa", identification_num="201031002", email="usmanmusa2019@gmail.com", phone_number="+2348144807260")
u3 = User(first_name="Benjamin", last_name="Omoniyi", identification_num="201031003", email="benjamin@gmail.com", phone_number="+2348144807211")
u4 = User(first_name="Abdulhakeem", last_name="Odoi", identification_num="201031004", email="odoi@gmail.com", phone_number="+2348144807222")
u5 = User(first_name="Muhammad", last_name="Amin", identification_num="201031005", email="moh'd@mail.com", phone_number="+2348144807233")

u2.save()
u3.save()
u4.save()
u5.save()

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

# ______________
# STUDENT LETTER

req_let1 = StudentLetterRequest(sender_req=me_stdent1, receiver_req=dtc3)
req_let2 = StudentLetterRequest(sender_req=me_stdent2, receiver_req=dtc3)

req_let1.save()
req_let2.save()

# _________________
# ACCEPTANCE LETTER

my_accept1 = AcceptanceLetter(sender_acept=me_stdent1, receiver_acept=dtc3, image="/home/usman/Desktop/media/1-quantum.jpg")
my_accept2 = AcceptanceLetter(sender_acept=me_stdent2, receiver_acept=dtc3, image="/home/usman/Desktop/media/Usman.jpg")

my_accept1.save()
my_accept2.save()


"""
