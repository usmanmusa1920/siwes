rm db.sqlite3 && pmake && pmigrate

export DJANGO_SETTINGS_MODULE=fugus.settings
python

import django
django.setup()

import os
import json
import random
from datetime import datetime
from administrator.models import Administrator
from faculty.models import Faculty, FacultyDean
from department.models import Department, DepartmentHOD, DepartmentTrainingCoordinator, StudentSupervisor, Letter
from student.models import TrainingStudent, StudentLetterRequest, AcceptanceLetter, WeekReader, WeekScannedLogbook, CommentOnLogbook
from django.contrib.auth import get_user_model


dob = datetime.utcnow()
User = get_user_model()

# coping some dummy images as student acceptance letter
os.system('mkdir -p media/acceptance-letters/2023-acceptances/siwes/Science/Physics/l300')
os.system('cp dummy_img/banner.jpg media/acceptance-letters/2023-acceptances/siwes/Science/Physics/l300/banner.jpg')
os.system('cp dummy_img/education.jpg media/acceptance-letters/2023-acceptances/siwes/Science/Physics/l300/education.jpg')


### _______________________
### ADMINISTRATOR (6 admin)
admin_user_1 = User.objects.create_superuser(first_name='Olagoke', last_name='Abdul', identification_num='19992000', email='olagokeabdul@yahoo.com', phone_number='+2348144807200', is_admin=True, date_of_birth=dob, country='Nigeria', password='19991125u')
admin_user_2 = User.objects.create_superuser(first_name='Ahmad', middle_name='Aliyu', last_name='Aminu', identification_num='20151889', email='ahmadaminu@yahoo.com', phone_number='+2348144807201', is_admin=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
admin_user_3 = User.objects.create_superuser(first_name='Ashiru', last_name='Lamido', identification_num='20151890', email='ashirulamido@yahoo.com', phone_number='+2348144807202', is_admin=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
admin_user_4 = User.objects.create_superuser(first_name='Ashiru', last_name='Lamido', identification_num='20151891', email='ashirulamido@yahoo.com', phone_number='+2348144807202', is_admin=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
admin_user_5 = User.objects.create_superuser(first_name='Ashiru', last_name='Lamido', identification_num='20151892', email='ashirulamido@yahoo.com', phone_number='+2348144807202', is_admin=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
admin_user_6 = User.objects.create_superuser(first_name='Ashiru', last_name='Lamido', identification_num='20151893', email='ashirulamido@yahoo.com', phone_number='+2348144807202', is_admin=True, date_of_birth=dob, country='Nigeria') # user_password_not_set

admin_user_1.save()
admin_user_2.save()
admin_user_3.save()
admin_user_4.save()
admin_user_5.save()
admin_user_6.save()

#<!-- administrator models -->
admin_1 = Administrator(director=admin_user_1, first_name=admin_user_1.first_name, last_name=admin_user_1.last_name, email=admin_user_1.email, phone_number=admin_user_1.phone_number, id_no=admin_user_1.identification_num)
admin_2 = Administrator(director=admin_user_2, first_name=admin_user_2.first_name, last_name=admin_user_2.last_name, email=admin_user_2.email, phone_number=admin_user_2.phone_number, id_no=admin_user_2.identification_num)
admin_3 = Administrator(director=admin_user_3, first_name=admin_user_3.first_name, last_name=admin_user_3.last_name, email=admin_user_3.email, phone_number=admin_user_3.phone_number, id_no=admin_user_3.identification_num)
admin_4 = Administrator(director=admin_user_4, first_name=admin_user_4.first_name, last_name=admin_user_4.last_name, email=admin_user_4.email, phone_number=admin_user_4.phone_number, id_no=admin_user_4.identification_num)
admin_5 = Administrator(director=admin_user_5, first_name=admin_user_5.first_name, last_name=admin_user_5.last_name, email=admin_user_5.email, phone_number=admin_user_5.phone_number, id_no=admin_user_5.identification_num)
admin_6 = Administrator(director=admin_user_6, first_name=admin_user_6.first_name, last_name=admin_user_6.last_name, email=admin_user_6.email, phone_number=admin_user_6.phone_number, id_no=admin_user_6.identification_num)

admin_1.save()
admin_2.save()
admin_3.save()
admin_4.save()
admin_5.save()
admin_6.save()


### _____________________
### FACULTY (4 faculties)

with open('faculty_and_dept.json') as f:
  r = json.load(f)

for i in r:
  ff = Faculty(name=i['faculty'], email=i['faculty']+'@mail.com', phone_number=i['phone'])
  ff.save()

faculty_1 = Faculty.objects.filter(name='Science').first()
faculty_2 = Faculty.objects.filter(name='Humanities').first()
faculty_3 = Faculty.objects.filter(name='Education').first()
faculty_4 = Faculty.objects.filter(name='Management & Social science').first()


### _____________________
### FACULTY DEAN (4 dean)
dean_user_1 = User.objects.create_user(first_name='Muhammad', last_name='Ahmad', identification_num='20161666', email='muhammadahmad@yahoo.com', phone_number='+2348144807203', is_dean=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
dean_user_2 = User.objects.create_user(first_name='Sani', last_name='Aliyu', identification_num='20161667', email='sanialiyu@yahoo.com', phone_number='+2348144807204', is_dean=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
dean_user_3 = User.objects.create_user(first_name='Alameen', last_name='Sambo', identification_num='20161668', email='alameensambo@yahoo.com', phone_number='+2348144807205', is_dean=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
dean_user_4 = User.objects.create_user(first_name='Suraj', last_name='Haqil', identification_num='20161669', email='surajhaqil@yahoo.com', phone_number='+2348144807206', is_dean=True, date_of_birth=dob, country='Nigeria') # user_password_not_set

dean_user_1.save()
dean_user_2.save()
dean_user_3.save()
dean_user_4.save()

#<!-- faculty dean -->
dean_1 = FacultyDean(dean=dean_user_1, faculty=faculty_1, first_name=dean_user_1.first_name, last_name=dean_user_1.last_name, email=dean_user_1.email, phone_number=dean_user_1.phone_number, id_no=dean_user_1.identification_num)
dean_2 = FacultyDean(dean=dean_user_1, faculty=faculty_2, first_name=dean_user_2.first_name, last_name=dean_user_2.last_name, email=dean_user_2.email, phone_number=dean_user_2.phone_number, id_no=dean_user_2.identification_num)
dean_3 = FacultyDean(dean=dean_user_1, faculty=faculty_3, first_name=dean_user_3.first_name, last_name=dean_user_3.last_name, email=dean_user_3.email, phone_number=dean_user_3.phone_number, id_no=dean_user_3.identification_num)
dean_4 = FacultyDean(dean=dean_user_1, faculty=faculty_4, first_name=dean_user_4.first_name, last_name=dean_user_4.last_name, email=dean_user_4.email, phone_number=dean_user_4.phone_number, id_no=dean_user_4.identification_num)

dean_1.save()
dean_2.save()
dean_3.save()
dean_4.save()

### ___________________________
### DEPARTMENT (32 departments)

for idx, i in enumerate(r):
  gf = Faculty.objects.filter(name=r[idx]['faculty']).first()
  for g in r[idx]['dept']:
    rr = random.randrange(300, 3000)
    dd = Department(name=g, email=g+'@mail.com', phone_number='+234'+str(rr)+g, faculty=gf)
    dd.save()

# Science
dept_1 = Department.objects.filter(name='Physics').first()
dept_2 = Department.objects.filter(name='Computer Science').first()
dept_3 = Department.objects.filter(name='Mathematics').first()
dept_4 = Department.objects.filter(name='Chemistry').first()
dept_5 = Department.objects.filter(name='Biochemistry').first()
dept_6 = Department.objects.filter(name='Geology').first()
dept_7 = Department.objects.filter(name='Microbiology').first()
dept_8 = Department.objects.filter(name='Plant science & Biotechnology').first()
dept_9 = Department.objects.filter(name='Zoology').first()
dept_10 = Department.objects.filter(name='Biology').first()
# Humanities
dept_11 = Department.objects.filter(name='Arabic Language').first()
dept_12 = Department.objects.filter(name='English Language').first()
dept_13 = Department.objects.filter(name='French').first()
dept_14 = Department.objects.filter(name='Hausa Language').first()
dept_15 = Department.objects.filter(name='History').first()
dept_16 = Department.objects.filter(name='Islamic Studies').first()
# Education
dept_17 = Department.objects.filter(name='Education Arabic').first()
dept_18 = Department.objects.filter(name='Education Biology').first()
dept_19 = Department.objects.filter(name='Education Chemistry').first()
dept_20 = Department.objects.filter(name='Education Economics').first()
dept_21 = Department.objects.filter(name='Education English').first()
dept_22 = Department.objects.filter(name='Education Hausa').first()
dept_23 = Department.objects.filter(name='Education History').first()
dept_24 = Department.objects.filter(name='Education Islamic Studies').first()
dept_25 = Department.objects.filter(name='Education Mathematics').first()
dept_26 = Department.objects.filter(name='Education Physics').first()
# Management & Social science
dept_27 = Department.objects.filter(name='Accounting').first()
dept_28 = Department.objects.filter(name='Business Administration').first()
dept_29 = Department.objects.filter(name='Economics').first()
dept_30 = Department.objects.filter(name='Political science').first()
dept_31 = Department.objects.filter(name='Public Administration').first()
dept_32 = Department.objects.filter(name='Sociology').first()

### _______________________
### DEPARTMENT HOD (32 hod)
hod_user_1 = User.objects.create_user(first_name='Lawal', last_name='Saad', identification_num='20191999', email='lawalsaad@yahoo.com', phone_number='+2349036632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_2 = User.objects.create_user(first_name='Ahmad', last_name='Jabaka', identification_num='20191920', email='ahmadjabaka@yahoo.com', phone_number='+2349036632604', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_3 = User.objects.create_user(first_name='Tanim', last_name='Mubarak', identification_num='20191921', email='tanimmubarak@yahoo.com', phone_number='+2349036632615', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_4 = User.objects.create_user(first_name='Nasir', last_name='Sanusi', identification_num='20232021', email='nasirsanusai@yahoo.com', phone_number='+2348135632605', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_5 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232033', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_6 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232030', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_7 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232031', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_8 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232032', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_9 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232034', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_10 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232035', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_11 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232036', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_12 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232037', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_13 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232038', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_14 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232039', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_15 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232040', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_16 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232041', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_17 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232077', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_18 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232043', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_19 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232044', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_20 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232045', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_21 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232046', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_22 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232047', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_23 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232048', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_24 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232049', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_25 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232050', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_26 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232051', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_27 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232052', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_28 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232053', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_29 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232054', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_30 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232055', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_31 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232056', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
hod_user_32 = User.objects.create_user(first_name='Ema', last_name='Okonjo', identification_num='20232057', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set

hod_user_1.save()
hod_user_2.save()
hod_user_3.save()
hod_user_4.save()
hod_user_5.save()
hod_user_6.save()
hod_user_7.save()
hod_user_8.save()
hod_user_9.save()
hod_user_10.save()
hod_user_11.save()
hod_user_12.save()
hod_user_13.save()
hod_user_14.save()
hod_user_15.save()
hod_user_16.save()
hod_user_17.save()
hod_user_18.save()
hod_user_19.save()
hod_user_20.save()
hod_user_21.save()
hod_user_22.save()
hod_user_23.save()
hod_user_24.save()
hod_user_25.save()
hod_user_26.save()
hod_user_27.save()
hod_user_28.save()
hod_user_29.save()
hod_user_30.save()
hod_user_31.save()
hod_user_32.save()

#<!-- department hod -->
hod_1 = DepartmentHOD(hod=hod_user_1, department=dept_1, first_name=hod_user_1.first_name, last_name=hod_user_1.last_name, email=hod_user_1.email, phone_number=hod_user_1.phone_number, id_no=hod_user_1.identification_num, ranks='B.Sc (Ed), (UDUSOK Nig); PGDIP (BUK, Nig.); Msc, PhD (USIM Malaysia); CFTO')
hod_2 = DepartmentHOD(hod=hod_user_2, department=dept_3, first_name=hod_user_2.first_name, last_name=hod_user_2.last_name, email=hod_user_2.email, phone_number=hod_user_2.phone_number, id_no=hod_user_2.identification_num)
hod_3 = DepartmentHOD(hod=hod_user_3, department=dept_1, first_name=hod_user_3.first_name, last_name=hod_user_3.last_name, email=hod_user_3.email, phone_number=hod_user_3.phone_number, id_no=hod_user_3.identification_num)
hod_4 = DepartmentHOD(hod=hod_user_4, department=dept_1, first_name=hod_user_4.first_name, last_name=hod_user_4.last_name, email=hod_user_4.email, phone_number=hod_user_4.phone_number, id_no=hod_user_4.identification_num)
hod_5 = DepartmentHOD(hod=hod_user_5, department=dept_3, first_name=hod_user_5.first_name, last_name=hod_user_5.last_name, email=hod_user_5.email, phone_number=hod_user_5.phone_number, id_no=hod_user_5.identification_num)
hod_6 = DepartmentHOD(hod=hod_user_6, department=dept_4, first_name=hod_user_6.first_name, last_name=hod_user_6.last_name, email=hod_user_6.email, phone_number=hod_user_6.phone_number, id_no=hod_user_6.identification_num)
hod_7 = DepartmentHOD(hod=hod_user_7, department=dept_3, first_name=hod_user_7.first_name, last_name=hod_user_7.last_name, email=hod_user_7.email, phone_number=hod_user_7.phone_number, id_no=hod_user_7.identification_num)
hod_8 = DepartmentHOD(hod=hod_user_8, department=dept_3, first_name=hod_user_8.first_name, last_name=hod_user_8.last_name, email=hod_user_8.email, phone_number=hod_user_8.phone_number, id_no=hod_user_8.identification_num)
hod_9 = DepartmentHOD(hod=hod_user_9, department=dept_3, first_name=hod_user_9.first_name, last_name=hod_user_9.last_name, email=hod_user_9.email, phone_number=hod_user_9.phone_number, id_no=hod_user_9.identification_num)
hod_10 = DepartmentHOD(hod=hod_user_10, department=dept_2, first_name=hod_user_10.first_name, last_name=hod_user_10.last_name, email=hod_user_10.email, phone_number=hod_user_10.phone_number, id_no=hod_user_10.identification_num)
hod_11 = DepartmentHOD(hod=hod_user_11, department=dept_1, first_name=hod_user_11.first_name, last_name=hod_user_11.last_name, email=hod_user_11.email, phone_number=hod_user_11.phone_number, id_no=hod_user_11.identification_num)
hod_12 = DepartmentHOD(hod=hod_user_12, department=dept_1, first_name=hod_user_12.first_name, last_name=hod_user_12.last_name, email=hod_user_12.email, phone_number=hod_user_12.phone_number, id_no=hod_user_12.identification_num)
hod_13 = DepartmentHOD(hod=hod_user_13, department=dept_2, first_name=hod_user_13.first_name, last_name=hod_user_13.last_name, email=hod_user_13.email, phone_number=hod_user_13.phone_number, id_no=hod_user_13.identification_num)
hod_14 = DepartmentHOD(hod=hod_user_14, department=dept_3, first_name=hod_user_14.first_name, last_name=hod_user_14.last_name, email=hod_user_14.email, phone_number=hod_user_14.phone_number, id_no=hod_user_14.identification_num)
hod_15 = DepartmentHOD(hod=hod_user_15, department=dept_1, first_name=hod_user_15.first_name, last_name=hod_user_15.last_name, email=hod_user_15.email, phone_number=hod_user_15.phone_number, id_no=hod_user_15.identification_num)
hod_16 = DepartmentHOD(hod=hod_user_16, department=dept_2, first_name=hod_user_16.first_name, last_name=hod_user_16.last_name, email=hod_user_16.email, phone_number=hod_user_16.phone_number, id_no=hod_user_16.identification_num)
hod_17 = DepartmentHOD(hod=hod_user_17, department=dept_4, first_name=hod_user_17.first_name, last_name=hod_user_17.last_name, email=hod_user_17.email, phone_number=hod_user_17.phone_number, id_no=hod_user_17.identification_num)
hod_18 = DepartmentHOD(hod=hod_user_18, department=dept_3, first_name=hod_user_18.first_name, last_name=hod_user_18.last_name, email=hod_user_18.email, phone_number=hod_user_18.phone_number, id_no=hod_user_18.identification_num)
hod_19 = DepartmentHOD(hod=hod_user_19, department=dept_2, first_name=hod_user_19.first_name, last_name=hod_user_19.last_name, email=hod_user_19.email, phone_number=hod_user_19.phone_number, id_no=hod_user_19.identification_num)
hod_20 = DepartmentHOD(hod=hod_user_20, department=dept_1, first_name=hod_user_20.first_name, last_name=hod_user_20.last_name, email=hod_user_20.email, phone_number=hod_user_20.phone_number, id_no=hod_user_20.identification_num)
hod_21 = DepartmentHOD(hod=hod_user_21, department=dept_1, first_name=hod_user_21.first_name, last_name=hod_user_21.last_name, email=hod_user_21.email, phone_number=hod_user_21.phone_number, id_no=hod_user_21.identification_num)
hod_22 = DepartmentHOD(hod=hod_user_22, department=dept_4, first_name=hod_user_22.first_name, last_name=hod_user_22.last_name, email=hod_user_22.email, phone_number=hod_user_22.phone_number, id_no=hod_user_22.identification_num)
hod_23 = DepartmentHOD(hod=hod_user_23, department=dept_4, first_name=hod_user_23.first_name, last_name=hod_user_23.last_name, email=hod_user_23.email, phone_number=hod_user_23.phone_number, id_no=hod_user_23.identification_num)
hod_24 = DepartmentHOD(hod=hod_user_24, department=dept_1, first_name=hod_user_24.first_name, last_name=hod_user_24.last_name, email=hod_user_24.email, phone_number=hod_user_24.phone_number, id_no=hod_user_24.identification_num)
hod_25 = DepartmentHOD(hod=hod_user_25, department=dept_2, first_name=hod_user_25.first_name, last_name=hod_user_25.last_name, email=hod_user_25.email, phone_number=hod_user_25.phone_number, id_no=hod_user_25.identification_num)
hod_26 = DepartmentHOD(hod=hod_user_26, department=dept_3, first_name=hod_user_26.first_name, last_name=hod_user_26.last_name, email=hod_user_26.email, phone_number=hod_user_26.phone_number, id_no=hod_user_26.identification_num)
hod_27 = DepartmentHOD(hod=hod_user_27, department=dept_1, first_name=hod_user_27.first_name, last_name=hod_user_27.last_name, email=hod_user_27.email, phone_number=hod_user_27.phone_number, id_no=hod_user_27.identification_num)
hod_28 = DepartmentHOD(hod=hod_user_28, department=dept_2, first_name=hod_user_28.first_name, last_name=hod_user_28.last_name, email=hod_user_28.email, phone_number=hod_user_28.phone_number, id_no=hod_user_28.identification_num)
hod_29 = DepartmentHOD(hod=hod_user_29, department=dept_1, first_name=hod_user_29.first_name, last_name=hod_user_29.last_name, email=hod_user_29.email, phone_number=hod_user_29.phone_number, id_no=hod_user_29.identification_num)
hod_30 = DepartmentHOD(hod=hod_user_30, department=dept_4, first_name=hod_user_30.first_name, last_name=hod_user_30.last_name, email=hod_user_30.email, phone_number=hod_user_30.phone_number, id_no=hod_user_30.identification_num)
hod_31 = DepartmentHOD(hod=hod_user_31, department=dept_1, first_name=hod_user_31.first_name, last_name=hod_user_31.last_name, email=hod_user_31.email, phone_number=hod_user_31.phone_number, id_no=hod_user_31.identification_num)
hod_32 = DepartmentHOD(hod=hod_user_32, department=dept_3, first_name=hod_user_32.first_name, last_name=hod_user_32.last_name, email=hod_user_32.email, phone_number=hod_user_32.phone_number, id_no=hod_user_32.identification_num)

hod_1.save()
hod_2.save()
hod_3.save()
hod_4.save()
hod_5.save()
hod_6.save()
hod_7.save()
hod_8.save()
hod_9.save()
hod_10.save()
hod_11.save()
hod_12.save()
hod_13.save()
hod_14.save()
hod_15.save()
hod_16.save()
hod_17.save()
hod_18.save()
hod_19.save()
hod_20.save()
hod_21.save()
hod_22.save()
hod_23.save()
hod_24.save()
hod_25.save()
hod_26.save()
hod_27.save()
hod_28.save()
hod_29.save()
hod_30.save()
hod_31.save()
hod_32.save()

### _____________________________________
### TRAINING COORDINATOR (32 coordinator)
coord_user_1 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='202320241', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria', password='19991125u')
coord_user_2 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='202320242', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_3 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='202320243', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_4 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='202320244', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_5 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='202320245', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_6 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='202320246', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_7 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='202320247', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_8 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='202320248', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_9 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='202320249', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_10 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202410', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_11 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202411', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_12 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202412', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_13 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202413', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_14 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202414', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_15 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202415', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_16 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202416', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_17 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202417', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_18 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202418', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_19 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202419', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_20 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202420', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_21 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202421', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_22 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202422', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_23 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202423', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_24 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202424', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_25 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202425', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_26 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202426', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_27 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202427', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_28 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202428', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_29 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202429', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_30 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202430', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_31 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202431', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
coord_user_32 = User.objects.create_user(first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='2023202432', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_hod=True, date_of_birth=dob, country='Nigeria') # user_password_not_set

coord_user_1.save()
coord_user_2.save()
coord_user_3.save()
coord_user_4.save()
coord_user_5.save()
coord_user_6.save()
coord_user_7.save()
coord_user_8.save()
coord_user_9.save()
coord_user_10.save()
coord_user_11.save()
coord_user_12.save()
coord_user_13.save()
coord_user_14.save()
coord_user_15.save()
coord_user_16.save()
coord_user_17.save()
coord_user_18.save()
coord_user_19.save()
coord_user_20.save()
coord_user_21.save()
coord_user_22.save()
coord_user_23.save()
coord_user_24.save()
coord_user_25.save()
coord_user_26.save()
coord_user_27.save()
coord_user_28.save()
coord_user_29.save()
coord_user_30.save()
coord_user_31.save()
coord_user_32.save()

#<!-- training coordinator models -->
coord_1 = DepartmentTrainingCoordinator(coordinator=coord_user_1, dept_hod=hod_1, first_name=hod_user_1.first_name, last_name=hod_user_1.last_name, email=hod_user_1.email, phone_number=hod_user_1.phone_number, id_no=hod_user_1.identification_num)
coord_2 = DepartmentTrainingCoordinator(coordinator=coord_user_2, dept_hod=hod_2, first_name=hod_user_2.first_name, last_name=hod_user_2.last_name, email=hod_user_2.email, phone_number=hod_user_2.phone_number, id_no=hod_user_2.identification_num)
coord_3 = DepartmentTrainingCoordinator(coordinator=coord_user_3, dept_hod=hod_3, first_name=hod_user_3.first_name, last_name=hod_user_3.last_name, email=hod_user_3.email, phone_number=hod_user_3.phone_number, id_no=hod_user_3.identification_num)
coord_4 = DepartmentTrainingCoordinator(coordinator=coord_user_4, dept_hod=hod_4, first_name=hod_user_4.first_name, last_name=hod_user_4.last_name, email=hod_user_4.email, phone_number=hod_user_4.phone_number, id_no=hod_user_4.identification_num)
coord_5 = DepartmentTrainingCoordinator(coordinator=coord_user_5, dept_hod=hod_5, first_name=hod_user_5.first_name, last_name=hod_user_5.last_name, email=hod_user_5.email, phone_number=hod_user_5.phone_number, id_no=hod_user_5.identification_num)
coord_6 = DepartmentTrainingCoordinator(coordinator=coord_user_6, dept_hod=hod_6, first_name=hod_user_6.first_name, last_name=hod_user_6.last_name, email=hod_user_6.email, phone_number=hod_user_6.phone_number, id_no=hod_user_6.identification_num)
coord_7 = DepartmentTrainingCoordinator(coordinator=coord_user_7, dept_hod=hod_7, first_name=hod_user_7.first_name, last_name=hod_user_7.last_name, email=hod_user_7.email, phone_number=hod_user_7.phone_number, id_no=hod_user_7.identification_num)
coord_8 = DepartmentTrainingCoordinator(coordinator=coord_user_8, dept_hod=hod_8, first_name=hod_user_8.first_name, last_name=hod_user_8.last_name, email=hod_user_8.email, phone_number=hod_user_8.phone_number, id_no=hod_user_8.identification_num)
coord_9 = DepartmentTrainingCoordinator(coordinator=coord_user_9, dept_hod=hod_9, first_name=hod_user_9.first_name, last_name=hod_user_9.last_name, email=hod_user_9.email, phone_number=hod_user_9.phone_number, id_no=hod_user_9.identification_num)
coord_10 = DepartmentTrainingCoordinator(coordinator=coord_user_10, dept_hod=hod_10, first_name=hod_user_10.first_name, last_name=hod_user_10.last_name, email=hod_user_10.email, phone_number=hod_user_10.phone_number, id_no=hod_user_10.identification_num)
coord_11 = DepartmentTrainingCoordinator(coordinator=coord_user_11, dept_hod=hod_11, first_name=hod_user_11.first_name, last_name=hod_user_11.last_name, email=hod_user_11.email, phone_number=hod_user_11.phone_number, id_no=hod_user_11.identification_num)
coord_12 = DepartmentTrainingCoordinator(coordinator=coord_user_12, dept_hod=hod_12, first_name=hod_user_12.first_name, last_name=hod_user_12.last_name, email=hod_user_12.email, phone_number=hod_user_12.phone_number, id_no=hod_user_12.identification_num)
coord_13 = DepartmentTrainingCoordinator(coordinator=coord_user_13, dept_hod=hod_13, first_name=hod_user_13.first_name, last_name=hod_user_13.last_name, email=hod_user_13.email, phone_number=hod_user_13.phone_number, id_no=hod_user_13.identification_num)
coord_14 = DepartmentTrainingCoordinator(coordinator=coord_user_14, dept_hod=hod_14, first_name=hod_user_14.first_name, last_name=hod_user_14.last_name, email=hod_user_14.email, phone_number=hod_user_14.phone_number, id_no=hod_user_14.identification_num)
coord_15 = DepartmentTrainingCoordinator(coordinator=coord_user_15, dept_hod=hod_15, first_name=hod_user_15.first_name, last_name=hod_user_15.last_name, email=hod_user_15.email, phone_number=hod_user_15.phone_number, id_no=hod_user_15.identification_num)
coord_16 = DepartmentTrainingCoordinator(coordinator=coord_user_16, dept_hod=hod_16, first_name=hod_user_16.first_name, last_name=hod_user_16.last_name, email=hod_user_16.email, phone_number=hod_user_16.phone_number, id_no=hod_user_16.identification_num)
coord_17 = DepartmentTrainingCoordinator(coordinator=coord_user_17, dept_hod=hod_17, first_name=hod_user_17.first_name, last_name=hod_user_17.last_name, email=hod_user_17.email, phone_number=hod_user_17.phone_number, id_no=hod_user_17.identification_num)
coord_18 = DepartmentTrainingCoordinator(coordinator=coord_user_18, dept_hod=hod_18, first_name=hod_user_18.first_name, last_name=hod_user_18.last_name, email=hod_user_18.email, phone_number=hod_user_18.phone_number, id_no=hod_user_18.identification_num)
coord_19 = DepartmentTrainingCoordinator(coordinator=coord_user_19, dept_hod=hod_19, first_name=hod_user_19.first_name, last_name=hod_user_19.last_name, email=hod_user_19.email, phone_number=hod_user_19.phone_number, id_no=hod_user_19.identification_num)
coord_20 = DepartmentTrainingCoordinator(coordinator=coord_user_20, dept_hod=hod_20, first_name=hod_user_20.first_name, last_name=hod_user_20.last_name, email=hod_user_20.email, phone_number=hod_user_20.phone_number, id_no=hod_user_20.identification_num)
coord_21 = DepartmentTrainingCoordinator(coordinator=coord_user_21, dept_hod=hod_21, first_name=hod_user_21.first_name, last_name=hod_user_21.last_name, email=hod_user_21.email, phone_number=hod_user_21.phone_number, id_no=hod_user_21.identification_num)
coord_22 = DepartmentTrainingCoordinator(coordinator=coord_user_22, dept_hod=hod_22, first_name=hod_user_22.first_name, last_name=hod_user_22.last_name, email=hod_user_22.email, phone_number=hod_user_22.phone_number, id_no=hod_user_22.identification_num)
coord_23 = DepartmentTrainingCoordinator(coordinator=coord_user_23, dept_hod=hod_23, first_name=hod_user_23.first_name, last_name=hod_user_23.last_name, email=hod_user_23.email, phone_number=hod_user_23.phone_number, id_no=hod_user_23.identification_num)
coord_24 = DepartmentTrainingCoordinator(coordinator=coord_user_24, dept_hod=hod_24, first_name=hod_user_24.first_name, last_name=hod_user_24.last_name, email=hod_user_24.email, phone_number=hod_user_24.phone_number, id_no=hod_user_24.identification_num)
coord_25 = DepartmentTrainingCoordinator(coordinator=coord_user_25, dept_hod=hod_25, first_name=hod_user_25.first_name, last_name=hod_user_25.last_name, email=hod_user_25.email, phone_number=hod_user_25.phone_number, id_no=hod_user_25.identification_num)
coord_26 = DepartmentTrainingCoordinator(coordinator=coord_user_26, dept_hod=hod_26, first_name=hod_user_26.first_name, last_name=hod_user_26.last_name, email=hod_user_26.email, phone_number=hod_user_26.phone_number, id_no=hod_user_26.identification_num)
coord_27 = DepartmentTrainingCoordinator(coordinator=coord_user_27, dept_hod=hod_27, first_name=hod_user_27.first_name, last_name=hod_user_27.last_name, email=hod_user_27.email, phone_number=hod_user_27.phone_number, id_no=hod_user_27.identification_num)
coord_28 = DepartmentTrainingCoordinator(coordinator=coord_user_28, dept_hod=hod_28, first_name=hod_user_28.first_name, last_name=hod_user_28.last_name, email=hod_user_28.email, phone_number=hod_user_28.phone_number, id_no=hod_user_28.identification_num)
coord_29 = DepartmentTrainingCoordinator(coordinator=coord_user_29, dept_hod=hod_29, first_name=hod_user_29.first_name, last_name=hod_user_29.last_name, email=hod_user_29.email, phone_number=hod_user_29.phone_number, id_no=hod_user_29.identification_num)
coord_30 = DepartmentTrainingCoordinator(coordinator=coord_user_30, dept_hod=hod_30, first_name=hod_user_30.first_name, last_name=hod_user_30.last_name, email=hod_user_30.email, phone_number=hod_user_30.phone_number, id_no=hod_user_30.identification_num)
coord_31 = DepartmentTrainingCoordinator(coordinator=coord_user_31, dept_hod=hod_31, first_name=hod_user_31.first_name, last_name=hod_user_31.last_name, email=hod_user_31.email, phone_number=hod_user_31.phone_number, id_no=hod_user_31.identification_num)
coord_32 = DepartmentTrainingCoordinator(coordinator=coord_user_32, dept_hod=hod_32, first_name=hod_user_32.first_name, last_name=hod_user_32.last_name, email=hod_user_32.email, phone_number=hod_user_32.phone_number, id_no=hod_user_32.identification_num)

coord_1.save()
coord_2.save()
coord_3.save()
coord_4.save()
coord_5.save()
coord_6.save()
coord_7.save()
coord_8.save()
coord_9.save()
coord_10.save()
coord_11.save()
coord_12.save()
coord_13.save()
coord_14.save()
coord_15.save()
coord_16.save()
coord_17.save()
coord_18.save()
coord_19.save()
coord_20.save()
coord_21.save()
coord_22.save()
coord_23.save()
coord_24.save()
coord_25.save()
coord_26.save()
coord_27.save()
coord_28.save()
coord_29.save()
coord_30.save()
coord_31.save()
coord_32.save()

### __________________________________________________________
### STUDENT SUPERVISOR (96 supervisor, 3 for each department)
sup_user_1 = User.objects.create_user(first_name='Fawaz', last_name='Saad', identification_num='20052006', email='lawalsaad@yahoo.com', phone_number='+2349036632603', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_2 = User.objects.create_user(first_name='Jibril', last_name='Jabaka', identification_num='20062007', email='ahmadjabaka@yahoo.com', phone_number='+2349036632604', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_3 = User.objects.create_user(first_name='Yahuza', last_name='Mubarak', identification_num='20072008', email='tanimmubarak@yahoo.com', phone_number='+2349036632615', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_4 = User.objects.create_user(first_name='Kallah', last_name='Sanusi', identification_num='20082009', email='nasirsanusai@yahoo.com', phone_number='+2348135632605', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_5 = User.objects.create_user(first_name='Ayuba', last_name='Okonjo', identification_num='20092010', email='emaokonjo@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_6 = User.objects.create_user(first_name='Ayuba6', last_name='Okonjo6', identification_num='200920106', email='emaokonjo6@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_7 = User.objects.create_user(first_name='Ayuba7', last_name='Okonjo7', identification_num='200920107', email='emaokonjo7@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_8 = User.objects.create_user(first_name='Ayuba8', last_name='Okonjo8', identification_num='200920108', email='emaokonjo8@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_9 = User.objects.create_user(first_name='Ayuba9', last_name='Okonjo9', identification_num='200920109', email='emaokonjo9@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_10 = User.objects.create_user(first_name='Ayuba10', last_name='Okonjo10', identification_num='2009201010', email='emaokonjo10@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_11 = User.objects.create_user(first_name='Ayuba11', last_name='Okonjo11', identification_num='2009201011', email='emaokonjo11@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_12 = User.objects.create_user(first_name='Ayuba12', last_name='Okonjo12', identification_num='2009201012', email='emaokonjo12@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_13 = User.objects.create_user(first_name='Ayuba13', last_name='Okonjo13', identification_num='2009201013', email='emaokonjo13@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_14 = User.objects.create_user(first_name='Ayuba14', last_name='Okonjo14', identification_num='2009201014', email='emaokonjo14@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_15 = User.objects.create_user(first_name='Ayuba15', last_name='Okonjo15', identification_num='2009201015', email='emaokonjo15@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_16 = User.objects.create_user(first_name='Ayuba16', last_name='Okonjo16', identification_num='2009201016', email='emaokonjo16@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_17 = User.objects.create_user(first_name='Ayuba17', last_name='Okonjo17', identification_num='2009201017', email='emaokonjo17@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_18 = User.objects.create_user(first_name='Ayuba18', last_name='Okonjo18', identification_num='2009201018', email='emaokonjo18@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_19 = User.objects.create_user(first_name='Ayuba19', last_name='Okonjo19', identification_num='2009201019', email='emaokonjo19@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_20 = User.objects.create_user(first_name='Ayuba20', last_name='Okonjo20', identification_num='2009201020', email='emaokonjo20@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_21 = User.objects.create_user(first_name='Ayuba21', last_name='Okonjo21', identification_num='2009201021', email='emaokonjo21@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_22 = User.objects.create_user(first_name='Ayuba22', last_name='Okonjo22', identification_num='2009201022', email='emaokonjo22@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_23 = User.objects.create_user(first_name='Ayuba23', last_name='Okonjo23', identification_num='2009201023', email='emaokonjo23@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_24 = User.objects.create_user(first_name='Ayuba24', last_name='Okonjo24', identification_num='2009201024', email='emaokonjo24@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_25 = User.objects.create_user(first_name='Ayuba25', last_name='Okonjo25', identification_num='2009201025', email='emaokonjo25@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_26 = User.objects.create_user(first_name='Ayuba26', last_name='Okonjo26', identification_num='2009201026', email='emaokonjo26@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_27 = User.objects.create_user(first_name='Ayuba27', last_name='Okonjo27', identification_num='2009201027', email='emaokonjo27@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_28 = User.objects.create_user(first_name='Ayuba28', last_name='Okonjo28', identification_num='2009201028', email='emaokonjo28@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_29 = User.objects.create_user(first_name='Ayuba29', last_name='Okonjo29', identification_num='2009201029', email='emaokonjo29@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_30 = User.objects.create_user(first_name='Ayuba30', last_name='Okonjo30', identification_num='2009201030', email='emaokonjo30@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_31 = User.objects.create_user(first_name='Ayuba31', last_name='Okonjo31', identification_num='2009201031', email='emaokonjo31@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_32 = User.objects.create_user(first_name='Ayuba32', last_name='Okonjo32', identification_num='2009201032', email='emaokonjo32@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_33 = User.objects.create_user(first_name='Ayuba33', last_name='Okonjo33', identification_num='2009201033', email='emaokonjo33@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_34 = User.objects.create_user(first_name='Ayuba34', last_name='Okonjo34', identification_num='2009201034', email='emaokonjo34@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_35 = User.objects.create_user(first_name='Ayuba35', last_name='Okonjo35', identification_num='2009201035', email='emaokonjo35@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_36 = User.objects.create_user(first_name='Ayuba36', last_name='Okonjo36', identification_num='2009201036', email='emaokonjo36@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_37 = User.objects.create_user(first_name='Ayuba37', last_name='Okonjo37', identification_num='2009201037', email='emaokonjo37@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_38 = User.objects.create_user(first_name='Ayuba38', last_name='Okonjo38', identification_num='2009201038', email='emaokonjo38@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_39 = User.objects.create_user(first_name='Ayuba39', last_name='Okonjo39', identification_num='2009201039', email='emaokonjo39@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_40 = User.objects.create_user(first_name='Ayuba40', last_name='Okonjo40', identification_num='2009201040', email='emaokonjo40@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_41 = User.objects.create_user(first_name='Ayuba41', last_name='Okonjo41', identification_num='2009201041', email='emaokonjo41@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_42 = User.objects.create_user(first_name='Ayuba42', last_name='Okonjo42', identification_num='2009201042', email='emaokonjo42@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_43 = User.objects.create_user(first_name='Ayuba43', last_name='Okonjo43', identification_num='2009201043', email='emaokonjo43@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_44 = User.objects.create_user(first_name='Ayuba44', last_name='Okonjo44', identification_num='2009201044', email='emaokonjo44@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_45 = User.objects.create_user(first_name='Ayuba45', last_name='Okonjo45', identification_num='2009201045', email='emaokonjo45@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_46 = User.objects.create_user(first_name='Ayuba46', last_name='Okonjo46', identification_num='2009201046', email='emaokonjo46@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_47 = User.objects.create_user(first_name='Ayuba47', last_name='Okonjo47', identification_num='2009201047', email='emaokonjo47@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_48 = User.objects.create_user(first_name='Ayuba48', last_name='Okonjo48', identification_num='2009201048', email='emaokonjo48@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_49 = User.objects.create_user(first_name='Ayuba49', last_name='Okonjo49', identification_num='2009201049', email='emaokonjo49@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_50 = User.objects.create_user(first_name='Ayuba50', last_name='Okonjo50', identification_num='2009201050', email='emaokonjo50@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_51 = User.objects.create_user(first_name='Ayuba51', last_name='Okonjo51', identification_num='2009201051', email='emaokonjo51@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_52 = User.objects.create_user(first_name='Ayuba52', last_name='Okonjo52', identification_num='2009201052', email='emaokonjo52@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_53 = User.objects.create_user(first_name='Ayuba53', last_name='Okonjo53', identification_num='2009201053', email='emaokonjo53@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_54 = User.objects.create_user(first_name='Ayuba54', last_name='Okonjo54', identification_num='2009201054', email='emaokonjo54@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_55 = User.objects.create_user(first_name='Ayuba55', last_name='Okonjo55', identification_num='2009201055', email='emaokonjo55@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_56 = User.objects.create_user(first_name='Ayuba56', last_name='Okonjo56', identification_num='2009201056', email='emaokonjo56@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_57 = User.objects.create_user(first_name='Ayuba57', last_name='Okonjo57', identification_num='2009201057', email='emaokonjo57@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_58 = User.objects.create_user(first_name='Ayuba58', last_name='Okonjo58', identification_num='2009201058', email='emaokonjo58@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_59 = User.objects.create_user(first_name='Ayuba59', last_name='Okonjo59', identification_num='2009201059', email='emaokonjo59@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_60 = User.objects.create_user(first_name='Ayuba60', last_name='Okonjo60', identification_num='2009201060', email='emaokonjo60@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_61 = User.objects.create_user(first_name='Ayuba61', last_name='Okonjo61', identification_num='2009201061', email='emaokonjo61@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_62 = User.objects.create_user(first_name='Ayuba62', last_name='Okonjo62', identification_num='2009201062', email='emaokonjo62@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_63 = User.objects.create_user(first_name='Ayuba63', last_name='Okonjo63', identification_num='2009201063', email='emaokonjo63@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_64 = User.objects.create_user(first_name='Ayuba64', last_name='Okonjo64', identification_num='2009201064', email='emaokonjo64@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_65 = User.objects.create_user(first_name='Ayuba65', last_name='Okonjo65', identification_num='2009201065', email='emaokonjo65@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_66 = User.objects.create_user(first_name='Ayuba66', last_name='Okonjo66', identification_num='2009201066', email='emaokonjo66@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_67 = User.objects.create_user(first_name='Ayuba67', last_name='Okonjo67', identification_num='2009201067', email='emaokonjo67@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_68 = User.objects.create_user(first_name='Ayuba68', last_name='Okonjo68', identification_num='2009201068', email='emaokonjo68@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_69 = User.objects.create_user(first_name='Ayuba69', last_name='Okonjo69', identification_num='2009201069', email='emaokonjo69@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_70 = User.objects.create_user(first_name='Ayuba70', last_name='Okonjo70', identification_num='2009201070', email='emaokonjo70@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_71 = User.objects.create_user(first_name='Ayuba71', last_name='Okonjo71', identification_num='2009201071', email='emaokonjo71@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_72 = User.objects.create_user(first_name='Ayuba72', last_name='Okonjo72', identification_num='2009201072', email='emaokonjo72@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_73 = User.objects.create_user(first_name='Ayuba73', last_name='Okonjo73', identification_num='2009201073', email='emaokonjo73@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_74 = User.objects.create_user(first_name='Ayuba74', last_name='Okonjo74', identification_num='2009201074', email='emaokonjo74@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_75 = User.objects.create_user(first_name='Ayuba75', last_name='Okonjo75', identification_num='2009201075', email='emaokonjo75@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_76 = User.objects.create_user(first_name='Ayuba76', last_name='Okonjo76', identification_num='2009201076', email='emaokonjo76@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_77 = User.objects.create_user(first_name='Ayuba77', last_name='Okonjo77', identification_num='2009201077', email='emaokonjo77@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_78 = User.objects.create_user(first_name='Ayuba78', last_name='Okonjo78', identification_num='2009201078', email='emaokonjo78@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_79 = User.objects.create_user(first_name='Ayuba79', last_name='Okonjo79', identification_num='2009201079', email='emaokonjo79@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_80 = User.objects.create_user(first_name='Ayuba80', last_name='Okonjo80', identification_num='2009201080', email='emaokonjo80@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_81 = User.objects.create_user(first_name='Ayuba81', last_name='Okonjo81', identification_num='2009201081', email='emaokonjo81@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_82 = User.objects.create_user(first_name='Ayuba82', last_name='Okonjo82', identification_num='2009201082', email='emaokonjo82@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_83 = User.objects.create_user(first_name='Ayuba83', last_name='Okonjo83', identification_num='2009201083', email='emaokonjo83@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_84 = User.objects.create_user(first_name='Ayuba84', last_name='Okonjo84', identification_num='2009201084', email='emaokonjo84@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_85 = User.objects.create_user(first_name='Ayuba85', last_name='Okonjo85', identification_num='2009201085', email='emaokonjo85@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_86 = User.objects.create_user(first_name='Ayuba86', last_name='Okonjo86', identification_num='2009201086', email='emaokonjo86@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_87 = User.objects.create_user(first_name='Ayuba87', last_name='Okonjo87', identification_num='2009201087', email='emaokonjo87@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_88 = User.objects.create_user(first_name='Ayuba88', last_name='Okonjo88', identification_num='2009201088', email='emaokonjo88@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_89 = User.objects.create_user(first_name='Ayuba89', last_name='Okonjo89', identification_num='2009201089', email='emaokonjo89@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_90 = User.objects.create_user(first_name='Ayuba90', last_name='Okonjo90', identification_num='2009201090', email='emaokonjo90@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_91 = User.objects.create_user(first_name='Ayuba91', last_name='Okonjo91', identification_num='2009201091', email='emaokonjo91@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_92 = User.objects.create_user(first_name='Ayuba92', last_name='Okonjo92', identification_num='2009201092', email='emaokonjo92@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_93 = User.objects.create_user(first_name='Ayuba93', last_name='Okonjo93', identification_num='2009201093', email='emaokonjo93@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_94 = User.objects.create_user(first_name='Ayuba94', last_name='Okonjo94', identification_num='2009201094', email='emaokonjo94@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_95 = User.objects.create_user(first_name='Ayuba95', last_name='Okonjo95', identification_num='2009201095', email='emaokonjo95@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
sup_user_96 = User.objects.create_user(first_name='Ayuba96', last_name='Okonjo96', identification_num='2009201096', email='emaokonjo96@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, country='Nigeria') # user_password_not_set

sup_user_1.save()
sup_user_2.save()
sup_user_3.save()
sup_user_4.save()
sup_user_5.save()
sup_user_6.save()
sup_user_7.save()
sup_user_8.save()
sup_user_9.save()
sup_user_10.save()
sup_user_11.save()
sup_user_12.save()
sup_user_13.save()
sup_user_14.save()
sup_user_15.save()
sup_user_16.save()
sup_user_17.save()
sup_user_18.save()
sup_user_19.save()
sup_user_20.save()
sup_user_21.save()
sup_user_22.save()
sup_user_23.save()
sup_user_24.save()
sup_user_25.save()
sup_user_26.save()
sup_user_27.save()
sup_user_28.save()
sup_user_29.save()
sup_user_30.save()
sup_user_31.save()
sup_user_32.save()
sup_user_33.save()
sup_user_34.save()
sup_user_35.save()
sup_user_36.save()
sup_user_37.save()
sup_user_38.save()
sup_user_39.save()
sup_user_40.save()
sup_user_41.save()
sup_user_42.save()
sup_user_43.save()
sup_user_44.save()
sup_user_45.save()
sup_user_46.save()
sup_user_47.save()
sup_user_48.save()
sup_user_49.save()
sup_user_50.save()
sup_user_51.save()
sup_user_52.save()
sup_user_53.save()
sup_user_54.save()
sup_user_55.save()
sup_user_56.save()
sup_user_57.save()
sup_user_58.save()
sup_user_59.save()
sup_user_60.save()
sup_user_61.save()
sup_user_62.save()
sup_user_63.save()
sup_user_64.save()
sup_user_65.save()
sup_user_66.save()
sup_user_67.save()
sup_user_68.save()
sup_user_69.save()
sup_user_70.save()
sup_user_71.save()
sup_user_72.save()
sup_user_73.save()
sup_user_74.save()
sup_user_75.save()
sup_user_76.save()
sup_user_77.save()
sup_user_78.save()
sup_user_79.save()
sup_user_80.save()
sup_user_81.save()
sup_user_82.save()
sup_user_83.save()
sup_user_84.save()
sup_user_85.save()
sup_user_86.save()
sup_user_87.save()
sup_user_88.save()
sup_user_89.save()
sup_user_90.save()
sup_user_91.save()
sup_user_92.save()
sup_user_93.save()
sup_user_94.save()
sup_user_95.save()
sup_user_96.save()

#<!-- supervisor hod -->
super_1 = StudentSupervisor(supervisor=sup_user_1, dept_training_coordinator=coord_1, first_name=sup_user_1.first_name, last_name=sup_user_1.last_name, email=sup_user_1.email, phone_number=sup_user_1.phone_number, id_no=sup_user_1.identification_num, location='No. 118 anguwan shanu, gusau GRA Zamfara state Nigeria')
super_2 = StudentSupervisor(supervisor=sup_user_2, dept_training_coordinator=coord_1, first_name=sup_user_2.first_name, last_name=sup_user_2.last_name, email=sup_user_2.email, phone_number=sup_user_2.phone_number, id_no=sup_user_2.identification_num)
super_3 = StudentSupervisor(supervisor=sup_user_3, dept_training_coordinator=coord_1, first_name=sup_user_3.first_name, last_name=sup_user_3.last_name, email=sup_user_3.email, phone_number=sup_user_3.phone_number, id_no=sup_user_3.identification_num)
super_4 = StudentSupervisor(supervisor=sup_user_4, dept_training_coordinator=coord_12, first_name=sup_user_4.first_name, last_name=sup_user_4.last_name, email=sup_user_4.email, phone_number=sup_user_4.phone_number, id_no=sup_user_4.identification_num)
super_5 = StudentSupervisor(supervisor=sup_user_5, dept_training_coordinator=coord_19, first_name=sup_user_5.first_name, last_name=sup_user_5.last_name, email=sup_user_5.email, phone_number=sup_user_5.phone_number, id_no=sup_user_5.identification_num)
super_6 = StudentSupervisor(supervisor=sup_user_6, dept_training_coordinator=coord_6, first_name=sup_user_6.first_name, last_name=sup_user_6.last_name, email=sup_user_6.email, phone_number=sup_user_6.phone_number, id_no=sup_user_6.identification_num)
super_7 = StudentSupervisor(supervisor=sup_user_7, dept_training_coordinator=coord_20, first_name=sup_user_7.first_name, last_name=sup_user_7.last_name, email=sup_user_7.email, phone_number=sup_user_7.phone_number, id_no=sup_user_7.identification_num)
super_8 = StudentSupervisor(supervisor=sup_user_8, dept_training_coordinator=coord_20, first_name=sup_user_8.first_name, last_name=sup_user_8.last_name, email=sup_user_8.email, phone_number=sup_user_8.phone_number, id_no=sup_user_8.identification_num)
super_9 = StudentSupervisor(supervisor=sup_user_9, dept_training_coordinator=coord_26, first_name=sup_user_9.first_name, last_name=sup_user_9.last_name, email=sup_user_9.email, phone_number=sup_user_9.phone_number, id_no=sup_user_9.identification_num)
super_10 = StudentSupervisor(supervisor=sup_user_10, dept_training_coordinator=coord_1, first_name=sup_user_10.first_name, last_name=sup_user_10.last_name, email=sup_user_10.email, phone_number=sup_user_10.phone_number, id_no=sup_user_10.identification_num)
super_11 = StudentSupervisor(supervisor=sup_user_11, dept_training_coordinator=coord_9, first_name=sup_user_11.first_name, last_name=sup_user_11.last_name, email=sup_user_11.email, phone_number=sup_user_11.phone_number, id_no=sup_user_11.identification_num)
super_12 = StudentSupervisor(supervisor=sup_user_12, dept_training_coordinator=coord_31, first_name=sup_user_12.first_name, last_name=sup_user_12.last_name, email=sup_user_12.email, phone_number=sup_user_12.phone_number, id_no=sup_user_12.identification_num)
super_13 = StudentSupervisor(supervisor=sup_user_13, dept_training_coordinator=coord_5, first_name=sup_user_13.first_name, last_name=sup_user_13.last_name, email=sup_user_13.email, phone_number=sup_user_13.phone_number, id_no=sup_user_13.identification_num)
super_14 = StudentSupervisor(supervisor=sup_user_14, dept_training_coordinator=coord_26, first_name=sup_user_14.first_name, last_name=sup_user_14.last_name, email=sup_user_14.email, phone_number=sup_user_14.phone_number, id_no=sup_user_14.identification_num)
super_15 = StudentSupervisor(supervisor=sup_user_15, dept_training_coordinator=coord_32, first_name=sup_user_15.first_name, last_name=sup_user_15.last_name, email=sup_user_15.email, phone_number=sup_user_15.phone_number, id_no=sup_user_15.identification_num)
super_16 = StudentSupervisor(supervisor=sup_user_16, dept_training_coordinator=coord_32, first_name=sup_user_16.first_name, last_name=sup_user_16.last_name, email=sup_user_16.email, phone_number=sup_user_16.phone_number, id_no=sup_user_16.identification_num)
super_17 = StudentSupervisor(supervisor=sup_user_17, dept_training_coordinator=coord_11, first_name=sup_user_17.first_name, last_name=sup_user_17.last_name, email=sup_user_17.email, phone_number=sup_user_17.phone_number, id_no=sup_user_17.identification_num)
super_18 = StudentSupervisor(supervisor=sup_user_18, dept_training_coordinator=coord_3, first_name=sup_user_18.first_name, last_name=sup_user_18.last_name, email=sup_user_18.email, phone_number=sup_user_18.phone_number, id_no=sup_user_18.identification_num)
super_19 = StudentSupervisor(supervisor=sup_user_19, dept_training_coordinator=coord_24, first_name=sup_user_19.first_name, last_name=sup_user_19.last_name, email=sup_user_19.email, phone_number=sup_user_19.phone_number, id_no=sup_user_19.identification_num)
super_20 = StudentSupervisor(supervisor=sup_user_20, dept_training_coordinator=coord_18, first_name=sup_user_20.first_name, last_name=sup_user_20.last_name, email=sup_user_20.email, phone_number=sup_user_20.phone_number, id_no=sup_user_20.identification_num)
super_21 = StudentSupervisor(supervisor=sup_user_21, dept_training_coordinator=coord_8, first_name=sup_user_21.first_name, last_name=sup_user_21.last_name, email=sup_user_21.email, phone_number=sup_user_21.phone_number, id_no=sup_user_21.identification_num)
super_22 = StudentSupervisor(supervisor=sup_user_22, dept_training_coordinator=coord_26, first_name=sup_user_22.first_name, last_name=sup_user_22.last_name, email=sup_user_22.email, phone_number=sup_user_22.phone_number, id_no=sup_user_22.identification_num)
super_23 = StudentSupervisor(supervisor=sup_user_23, dept_training_coordinator=coord_10, first_name=sup_user_23.first_name, last_name=sup_user_23.last_name, email=sup_user_23.email, phone_number=sup_user_23.phone_number, id_no=sup_user_23.identification_num)
super_24 = StudentSupervisor(supervisor=sup_user_24, dept_training_coordinator=coord_32, first_name=sup_user_24.first_name, last_name=sup_user_24.last_name, email=sup_user_24.email, phone_number=sup_user_24.phone_number, id_no=sup_user_24.identification_num)
super_25 = StudentSupervisor(supervisor=sup_user_25, dept_training_coordinator=coord_20, first_name=sup_user_25.first_name, last_name=sup_user_25.last_name, email=sup_user_25.email, phone_number=sup_user_25.phone_number, id_no=sup_user_25.identification_num)
super_26 = StudentSupervisor(supervisor=sup_user_26, dept_training_coordinator=coord_21, first_name=sup_user_26.first_name, last_name=sup_user_26.last_name, email=sup_user_26.email, phone_number=sup_user_26.phone_number, id_no=sup_user_26.identification_num)
super_27 = StudentSupervisor(supervisor=sup_user_27, dept_training_coordinator=coord_17, first_name=sup_user_27.first_name, last_name=sup_user_27.last_name, email=sup_user_27.email, phone_number=sup_user_27.phone_number, id_no=sup_user_27.identification_num)
super_28 = StudentSupervisor(supervisor=sup_user_28, dept_training_coordinator=coord_19, first_name=sup_user_28.first_name, last_name=sup_user_28.last_name, email=sup_user_28.email, phone_number=sup_user_28.phone_number, id_no=sup_user_28.identification_num)
super_29 = StudentSupervisor(supervisor=sup_user_29, dept_training_coordinator=coord_15, first_name=sup_user_29.first_name, last_name=sup_user_29.last_name, email=sup_user_29.email, phone_number=sup_user_29.phone_number, id_no=sup_user_29.identification_num)
super_30 = StudentSupervisor(supervisor=sup_user_30, dept_training_coordinator=coord_15, first_name=sup_user_30.first_name, last_name=sup_user_30.last_name, email=sup_user_30.email, phone_number=sup_user_30.phone_number, id_no=sup_user_30.identification_num)
super_31 = StudentSupervisor(supervisor=sup_user_31, dept_training_coordinator=coord_27, first_name=sup_user_31.first_name, last_name=sup_user_31.last_name, email=sup_user_31.email, phone_number=sup_user_31.phone_number, id_no=sup_user_31.identification_num)
super_32 = StudentSupervisor(supervisor=sup_user_32, dept_training_coordinator=coord_17, first_name=sup_user_32.first_name, last_name=sup_user_32.last_name, email=sup_user_32.email, phone_number=sup_user_32.phone_number, id_no=sup_user_32.identification_num)
super_33 = StudentSupervisor(supervisor=sup_user_33, dept_training_coordinator=coord_32, first_name=sup_user_33.first_name, last_name=sup_user_33.last_name, email=sup_user_33.email, phone_number=sup_user_33.phone_number, id_no=sup_user_33.identification_num)
super_34 = StudentSupervisor(supervisor=sup_user_34, dept_training_coordinator=coord_27, first_name=sup_user_34.first_name, last_name=sup_user_34.last_name, email=sup_user_34.email, phone_number=sup_user_34.phone_number, id_no=sup_user_34.identification_num)
super_35 = StudentSupervisor(supervisor=sup_user_35, dept_training_coordinator=coord_2, first_name=sup_user_35.first_name, last_name=sup_user_35.last_name, email=sup_user_35.email, phone_number=sup_user_35.phone_number, id_no=sup_user_35.identification_num)
super_36 = StudentSupervisor(supervisor=sup_user_36, dept_training_coordinator=coord_19, first_name=sup_user_36.first_name, last_name=sup_user_36.last_name, email=sup_user_36.email, phone_number=sup_user_36.phone_number, id_no=sup_user_36.identification_num)
super_37 = StudentSupervisor(supervisor=sup_user_37, dept_training_coordinator=coord_11, first_name=sup_user_37.first_name, last_name=sup_user_37.last_name, email=sup_user_37.email, phone_number=sup_user_37.phone_number, id_no=sup_user_37.identification_num)
super_38 = StudentSupervisor(supervisor=sup_user_38, dept_training_coordinator=coord_19, first_name=sup_user_38.first_name, last_name=sup_user_38.last_name, email=sup_user_38.email, phone_number=sup_user_38.phone_number, id_no=sup_user_38.identification_num)
super_39 = StudentSupervisor(supervisor=sup_user_39, dept_training_coordinator=coord_11, first_name=sup_user_39.first_name, last_name=sup_user_39.last_name, email=sup_user_39.email, phone_number=sup_user_39.phone_number, id_no=sup_user_39.identification_num)
super_40 = StudentSupervisor(supervisor=sup_user_40, dept_training_coordinator=coord_19, first_name=sup_user_40.first_name, last_name=sup_user_40.last_name, email=sup_user_40.email, phone_number=sup_user_40.phone_number, id_no=sup_user_40.identification_num)
super_41 = StudentSupervisor(supervisor=sup_user_41, dept_training_coordinator=coord_21, first_name=sup_user_41.first_name, last_name=sup_user_41.last_name, email=sup_user_41.email, phone_number=sup_user_41.phone_number, id_no=sup_user_41.identification_num)
super_42 = StudentSupervisor(supervisor=sup_user_42, dept_training_coordinator=coord_30, first_name=sup_user_42.first_name, last_name=sup_user_42.last_name, email=sup_user_42.email, phone_number=sup_user_42.phone_number, id_no=sup_user_42.identification_num)
super_43 = StudentSupervisor(supervisor=sup_user_43, dept_training_coordinator=coord_3, first_name=sup_user_43.first_name, last_name=sup_user_43.last_name, email=sup_user_43.email, phone_number=sup_user_43.phone_number, id_no=sup_user_43.identification_num)
super_44 = StudentSupervisor(supervisor=sup_user_44, dept_training_coordinator=coord_23, first_name=sup_user_44.first_name, last_name=sup_user_44.last_name, email=sup_user_44.email, phone_number=sup_user_44.phone_number, id_no=sup_user_44.identification_num)
super_45 = StudentSupervisor(supervisor=sup_user_45, dept_training_coordinator=coord_27, first_name=sup_user_45.first_name, last_name=sup_user_45.last_name, email=sup_user_45.email, phone_number=sup_user_45.phone_number, id_no=sup_user_45.identification_num)
super_46 = StudentSupervisor(supervisor=sup_user_46, dept_training_coordinator=coord_13, first_name=sup_user_46.first_name, last_name=sup_user_46.last_name, email=sup_user_46.email, phone_number=sup_user_46.phone_number, id_no=sup_user_46.identification_num)
super_47 = StudentSupervisor(supervisor=sup_user_47, dept_training_coordinator=coord_7, first_name=sup_user_47.first_name, last_name=sup_user_47.last_name, email=sup_user_47.email, phone_number=sup_user_47.phone_number, id_no=sup_user_47.identification_num)
super_48 = StudentSupervisor(supervisor=sup_user_48, dept_training_coordinator=coord_30, first_name=sup_user_48.first_name, last_name=sup_user_48.last_name, email=sup_user_48.email, phone_number=sup_user_48.phone_number, id_no=sup_user_48.identification_num)
super_49 = StudentSupervisor(supervisor=sup_user_49, dept_training_coordinator=coord_32, first_name=sup_user_49.first_name, last_name=sup_user_49.last_name, email=sup_user_49.email, phone_number=sup_user_49.phone_number, id_no=sup_user_49.identification_num)
super_50 = StudentSupervisor(supervisor=sup_user_50, dept_training_coordinator=coord_9, first_name=sup_user_50.first_name, last_name=sup_user_50.last_name, email=sup_user_50.email, phone_number=sup_user_50.phone_number, id_no=sup_user_50.identification_num)
super_51 = StudentSupervisor(supervisor=sup_user_51, dept_training_coordinator=coord_28, first_name=sup_user_51.first_name, last_name=sup_user_51.last_name, email=sup_user_51.email, phone_number=sup_user_51.phone_number, id_no=sup_user_51.identification_num)
super_52 = StudentSupervisor(supervisor=sup_user_52, dept_training_coordinator=coord_31, first_name=sup_user_52.first_name, last_name=sup_user_52.last_name, email=sup_user_52.email, phone_number=sup_user_52.phone_number, id_no=sup_user_52.identification_num)
super_53 = StudentSupervisor(supervisor=sup_user_53, dept_training_coordinator=coord_19, first_name=sup_user_53.first_name, last_name=sup_user_53.last_name, email=sup_user_53.email, phone_number=sup_user_53.phone_number, id_no=sup_user_53.identification_num)
super_54 = StudentSupervisor(supervisor=sup_user_54, dept_training_coordinator=coord_8, first_name=sup_user_54.first_name, last_name=sup_user_54.last_name, email=sup_user_54.email, phone_number=sup_user_54.phone_number, id_no=sup_user_54.identification_num)
super_55 = StudentSupervisor(supervisor=sup_user_55, dept_training_coordinator=coord_24, first_name=sup_user_55.first_name, last_name=sup_user_55.last_name, email=sup_user_55.email, phone_number=sup_user_55.phone_number, id_no=sup_user_55.identification_num)
super_56 = StudentSupervisor(supervisor=sup_user_56, dept_training_coordinator=coord_31, first_name=sup_user_56.first_name, last_name=sup_user_56.last_name, email=sup_user_56.email, phone_number=sup_user_56.phone_number, id_no=sup_user_56.identification_num)
super_57 = StudentSupervisor(supervisor=sup_user_57, dept_training_coordinator=coord_7, first_name=sup_user_57.first_name, last_name=sup_user_57.last_name, email=sup_user_57.email, phone_number=sup_user_57.phone_number, id_no=sup_user_57.identification_num)
super_58 = StudentSupervisor(supervisor=sup_user_58, dept_training_coordinator=coord_23, first_name=sup_user_58.first_name, last_name=sup_user_58.last_name, email=sup_user_58.email, phone_number=sup_user_58.phone_number, id_no=sup_user_58.identification_num)
super_59 = StudentSupervisor(supervisor=sup_user_59, dept_training_coordinator=coord_18, first_name=sup_user_59.first_name, last_name=sup_user_59.last_name, email=sup_user_59.email, phone_number=sup_user_59.phone_number, id_no=sup_user_59.identification_num)
super_60 = StudentSupervisor(supervisor=sup_user_60, dept_training_coordinator=coord_30, first_name=sup_user_60.first_name, last_name=sup_user_60.last_name, email=sup_user_60.email, phone_number=sup_user_60.phone_number, id_no=sup_user_60.identification_num)
super_61 = StudentSupervisor(supervisor=sup_user_61, dept_training_coordinator=coord_3, first_name=sup_user_61.first_name, last_name=sup_user_61.last_name, email=sup_user_61.email, phone_number=sup_user_61.phone_number, id_no=sup_user_61.identification_num)
super_62 = StudentSupervisor(supervisor=sup_user_62, dept_training_coordinator=coord_31, first_name=sup_user_62.first_name, last_name=sup_user_62.last_name, email=sup_user_62.email, phone_number=sup_user_62.phone_number, id_no=sup_user_62.identification_num)
super_63 = StudentSupervisor(supervisor=sup_user_63, dept_training_coordinator=coord_24, first_name=sup_user_63.first_name, last_name=sup_user_63.last_name, email=sup_user_63.email, phone_number=sup_user_63.phone_number, id_no=sup_user_63.identification_num)
super_64 = StudentSupervisor(supervisor=sup_user_64, dept_training_coordinator=coord_16, first_name=sup_user_64.first_name, last_name=sup_user_64.last_name, email=sup_user_64.email, phone_number=sup_user_64.phone_number, id_no=sup_user_64.identification_num)
super_65 = StudentSupervisor(supervisor=sup_user_65, dept_training_coordinator=coord_10, first_name=sup_user_65.first_name, last_name=sup_user_65.last_name, email=sup_user_65.email, phone_number=sup_user_65.phone_number, id_no=sup_user_65.identification_num)
super_66 = StudentSupervisor(supervisor=sup_user_66, dept_training_coordinator=coord_6, first_name=sup_user_66.first_name, last_name=sup_user_66.last_name, email=sup_user_66.email, phone_number=sup_user_66.phone_number, id_no=sup_user_66.identification_num)
super_67 = StudentSupervisor(supervisor=sup_user_67, dept_training_coordinator=coord_5, first_name=sup_user_67.first_name, last_name=sup_user_67.last_name, email=sup_user_67.email, phone_number=sup_user_67.phone_number, id_no=sup_user_67.identification_num)
super_68 = StudentSupervisor(supervisor=sup_user_68, dept_training_coordinator=coord_29, first_name=sup_user_68.first_name, last_name=sup_user_68.last_name, email=sup_user_68.email, phone_number=sup_user_68.phone_number, id_no=sup_user_68.identification_num)
super_69 = StudentSupervisor(supervisor=sup_user_69, dept_training_coordinator=coord_27, first_name=sup_user_69.first_name, last_name=sup_user_69.last_name, email=sup_user_69.email, phone_number=sup_user_69.phone_number, id_no=sup_user_69.identification_num)
super_70 = StudentSupervisor(supervisor=sup_user_70, dept_training_coordinator=coord_18, first_name=sup_user_70.first_name, last_name=sup_user_70.last_name, email=sup_user_70.email, phone_number=sup_user_70.phone_number, id_no=sup_user_70.identification_num)
super_71 = StudentSupervisor(supervisor=sup_user_71, dept_training_coordinator=coord_16, first_name=sup_user_71.first_name, last_name=sup_user_71.last_name, email=sup_user_71.email, phone_number=sup_user_71.phone_number, id_no=sup_user_71.identification_num)
super_72 = StudentSupervisor(supervisor=sup_user_72, dept_training_coordinator=coord_7, first_name=sup_user_72.first_name, last_name=sup_user_72.last_name, email=sup_user_72.email, phone_number=sup_user_72.phone_number, id_no=sup_user_72.identification_num)
super_73 = StudentSupervisor(supervisor=sup_user_73, dept_training_coordinator=coord_31, first_name=sup_user_73.first_name, last_name=sup_user_73.last_name, email=sup_user_73.email, phone_number=sup_user_73.phone_number, id_no=sup_user_73.identification_num)
super_74 = StudentSupervisor(supervisor=sup_user_74, dept_training_coordinator=coord_17, first_name=sup_user_74.first_name, last_name=sup_user_74.last_name, email=sup_user_74.email, phone_number=sup_user_74.phone_number, id_no=sup_user_74.identification_num)
super_75 = StudentSupervisor(supervisor=sup_user_75, dept_training_coordinator=coord_17, first_name=sup_user_75.first_name, last_name=sup_user_75.last_name, email=sup_user_75.email, phone_number=sup_user_75.phone_number, id_no=sup_user_75.identification_num)
super_76 = StudentSupervisor(supervisor=sup_user_76, dept_training_coordinator=coord_31, first_name=sup_user_76.first_name, last_name=sup_user_76.last_name, email=sup_user_76.email, phone_number=sup_user_76.phone_number, id_no=sup_user_76.identification_num)
super_77 = StudentSupervisor(supervisor=sup_user_77, dept_training_coordinator=coord_22, first_name=sup_user_77.first_name, last_name=sup_user_77.last_name, email=sup_user_77.email, phone_number=sup_user_77.phone_number, id_no=sup_user_77.identification_num)
super_78 = StudentSupervisor(supervisor=sup_user_78, dept_training_coordinator=coord_25, first_name=sup_user_78.first_name, last_name=sup_user_78.last_name, email=sup_user_78.email, phone_number=sup_user_78.phone_number, id_no=sup_user_78.identification_num)
super_79 = StudentSupervisor(supervisor=sup_user_79, dept_training_coordinator=coord_24, first_name=sup_user_79.first_name, last_name=sup_user_79.last_name, email=sup_user_79.email, phone_number=sup_user_79.phone_number, id_no=sup_user_79.identification_num)
super_80 = StudentSupervisor(supervisor=sup_user_80, dept_training_coordinator=coord_21, first_name=sup_user_80.first_name, last_name=sup_user_80.last_name, email=sup_user_80.email, phone_number=sup_user_80.phone_number, id_no=sup_user_80.identification_num)
super_81 = StudentSupervisor(supervisor=sup_user_81, dept_training_coordinator=coord_13, first_name=sup_user_81.first_name, last_name=sup_user_81.last_name, email=sup_user_81.email, phone_number=sup_user_81.phone_number, id_no=sup_user_81.identification_num)
super_82 = StudentSupervisor(supervisor=sup_user_82, dept_training_coordinator=coord_27, first_name=sup_user_82.first_name, last_name=sup_user_82.last_name, email=sup_user_82.email, phone_number=sup_user_82.phone_number, id_no=sup_user_82.identification_num)
super_83 = StudentSupervisor(supervisor=sup_user_83, dept_training_coordinator=coord_5, first_name=sup_user_83.first_name, last_name=sup_user_83.last_name, email=sup_user_83.email, phone_number=sup_user_83.phone_number, id_no=sup_user_83.identification_num)
super_84 = StudentSupervisor(supervisor=sup_user_84, dept_training_coordinator=coord_10, first_name=sup_user_84.first_name, last_name=sup_user_84.last_name, email=sup_user_84.email, phone_number=sup_user_84.phone_number, id_no=sup_user_84.identification_num)
super_85 = StudentSupervisor(supervisor=sup_user_85, dept_training_coordinator=coord_18, first_name=sup_user_85.first_name, last_name=sup_user_85.last_name, email=sup_user_85.email, phone_number=sup_user_85.phone_number, id_no=sup_user_85.identification_num)
super_86 = StudentSupervisor(supervisor=sup_user_86, dept_training_coordinator=coord_30, first_name=sup_user_86.first_name, last_name=sup_user_86.last_name, email=sup_user_86.email, phone_number=sup_user_86.phone_number, id_no=sup_user_86.identification_num)
super_87 = StudentSupervisor(supervisor=sup_user_87, dept_training_coordinator=coord_30, first_name=sup_user_87.first_name, last_name=sup_user_87.last_name, email=sup_user_87.email, phone_number=sup_user_87.phone_number, id_no=sup_user_87.identification_num)
super_88 = StudentSupervisor(supervisor=sup_user_88, dept_training_coordinator=coord_30, first_name=sup_user_88.first_name, last_name=sup_user_88.last_name, email=sup_user_88.email, phone_number=sup_user_88.phone_number, id_no=sup_user_88.identification_num)
super_89 = StudentSupervisor(supervisor=sup_user_89, dept_training_coordinator=coord_16, first_name=sup_user_89.first_name, last_name=sup_user_89.last_name, email=sup_user_89.email, phone_number=sup_user_89.phone_number, id_no=sup_user_89.identification_num)
super_90 = StudentSupervisor(supervisor=sup_user_90, dept_training_coordinator=coord_9, first_name=sup_user_90.first_name, last_name=sup_user_90.last_name, email=sup_user_90.email, phone_number=sup_user_90.phone_number, id_no=sup_user_90.identification_num)
super_91 = StudentSupervisor(supervisor=sup_user_91, dept_training_coordinator=coord_28, first_name=sup_user_91.first_name, last_name=sup_user_91.last_name, email=sup_user_91.email, phone_number=sup_user_91.phone_number, id_no=sup_user_91.identification_num)
super_92 = StudentSupervisor(supervisor=sup_user_92, dept_training_coordinator=coord_14, first_name=sup_user_92.first_name, last_name=sup_user_92.last_name, email=sup_user_92.email, phone_number=sup_user_92.phone_number, id_no=sup_user_92.identification_num)
super_93 = StudentSupervisor(supervisor=sup_user_93, dept_training_coordinator=coord_3, first_name=sup_user_93.first_name, last_name=sup_user_93.last_name, email=sup_user_93.email, phone_number=sup_user_93.phone_number, id_no=sup_user_93.identification_num)
super_94 = StudentSupervisor(supervisor=sup_user_94, dept_training_coordinator=coord_11, first_name=sup_user_94.first_name, last_name=sup_user_94.last_name, email=sup_user_94.email, phone_number=sup_user_94.phone_number, id_no=sup_user_94.identification_num)
super_95 = StudentSupervisor(supervisor=sup_user_95, dept_training_coordinator=coord_31, first_name=sup_user_95.first_name, last_name=sup_user_95.last_name, email=sup_user_95.email, phone_number=sup_user_95.phone_number, id_no=sup_user_95.identification_num)
super_96 = StudentSupervisor(supervisor=sup_user_96, dept_training_coordinator=coord_29, first_name=sup_user_96.first_name, last_name=sup_user_96.last_name, email=sup_user_96.email, phone_number=sup_user_96.phone_number, id_no=sup_user_96.identification_num)

super_1.save()
super_2.save()
super_3.save()
super_4.save()
super_5.save()
super_6.save()
super_7.save()
super_8.save()
super_9.save()
super_10.save()
super_11.save()
super_12.save()
super_13.save()
super_14.save()
super_15.save()
super_16.save()
super_17.save()
super_18.save()
super_19.save()
super_20.save()
super_21.save()
super_22.save()
super_23.save()
super_24.save()
super_25.save()
super_26.save()
super_27.save()
super_28.save()
super_29.save()
super_30.save()
super_31.save()
super_32.save()
super_33.save()
super_34.save()
super_35.save()
super_36.save()
super_37.save()
super_38.save()
super_39.save()
super_40.save()
super_41.save()
super_42.save()
super_43.save()
super_44.save()
super_45.save()
super_46.save()
super_47.save()
super_48.save()
super_49.save()
super_50.save()
super_51.save()
super_52.save()
super_53.save()
super_54.save()
super_55.save()
super_56.save()
super_57.save()
super_58.save()
super_59.save()
super_60.save()
super_61.save()
super_62.save()
super_63.save()
super_64.save()
super_65.save()
super_66.save()
super_67.save()
super_68.save()
super_69.save()
super_70.save()
super_71.save()
super_72.save()
super_73.save()
super_74.save()
super_75.save()
super_76.save()
super_77.save()
super_78.save()
super_79.save()
super_80.save()
super_81.save()
super_82.save()
super_83.save()
super_84.save()
super_85.save()
super_86.save()
super_87.save()
super_88.save()
super_89.save()
super_90.save()
super_91.save()
super_92.save()
super_93.save()
super_94.save()
super_95.save()
super_96.save()

### ____________________________________________
### LETTER (1 placement and 1 acceptance letter)

placement_lett = Letter(coordinator=coord_3, session='2023', text='This is our students placement letter')
acceptance_lett = Letter(coordinator=coord_3, session='2023', text='This is our students acceptance letter', letter='acceptance letter')
placement_lett.save()
acceptance_lett.save()

### _________________________________________________________________________________________________________
### TRAINING STUDENTS (320 student, 10 student for each department where 5 are 200L and the other 5 are 300L)
student_user_1 = User.objects.create_user(first_name='Usman', last_name='Musa', identification_num='2010310013', email='usmanmusa1920@gmail.com', phone_number='+2348144807260', is_student=True, date_of_birth=dob, country='Nigeria', password='19991125u')
student_user_2 = User.objects.create_user(first_name='Shehu', last_name='Musa', identification_num='201031002', email='usmanmusa2019@gmail.com', phone_number='+2348144807260', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_3 = User.objects.create_user(first_name='Benjamin', last_name='Omoniyi', identification_num='201031003', email='benjamin@gmail.com', phone_number='+2348144807211', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_4 = User.objects.create_user(first_name='Abdulhakeem', last_name='Odoi', identification_num='201031004', email='odoi@gmail.com', phone_number='+2348144807222', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_5 = User.objects.create_user(first_name='Muhammad', last_name='Amin', identification_num='201031005', email='moh\'d@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_6 = User.objects.create_user(first_name='Muhammad6', last_name='Amin6', identification_num='2010310056', email='moh\'d6@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_7 = User.objects.create_user(first_name='Muhammad7', last_name='Amin7', identification_num='2010310057', email='moh\'d7@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_8 = User.objects.create_user(first_name='Muhammad8', last_name='Amin8', identification_num='2010310058', email='moh\'d8@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_9 = User.objects.create_user(first_name='Muhammad9', last_name='Amin9', identification_num='2010310059', email='moh\'d9@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_10 = User.objects.create_user(first_name='Muhammad10', last_name='Amin10', identification_num='20103100510', email='moh\'d10@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_11 = User.objects.create_user(first_name='Muhammad11', last_name='Amin11', identification_num='20103100511', email='moh\'d11@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_12 = User.objects.create_user(first_name='Muhammad12', last_name='Amin12', identification_num='20103100512', email='moh\'d12@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_13 = User.objects.create_user(first_name='Muhammad13', last_name='Amin13', identification_num='20103100513', email='moh\'d13@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_14 = User.objects.create_user(first_name='Muhammad14', last_name='Amin14', identification_num='20103100514', email='moh\'d14@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_15 = User.objects.create_user(first_name='Muhammad15', last_name='Amin15', identification_num='20103100515', email='moh\'d15@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_16 = User.objects.create_user(first_name='Muhammad16', last_name='Amin16', identification_num='20103100516', email='moh\'d16@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_17 = User.objects.create_user(first_name='Muhammad17', last_name='Amin17', identification_num='20103100517', email='moh\'d17@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_18 = User.objects.create_user(first_name='Muhammad18', last_name='Amin18', identification_num='20103100518', email='moh\'d18@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_19 = User.objects.create_user(first_name='Muhammad19', last_name='Amin19', identification_num='20103100519', email='moh\'d19@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_20 = User.objects.create_user(first_name='Muhammad20', last_name='Amin20', identification_num='20103100520', email='moh\'d20@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_21 = User.objects.create_user(first_name='Muhammad21', last_name='Amin21', identification_num='20103100521', email='moh\'d21@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_22 = User.objects.create_user(first_name='Muhammad22', last_name='Amin22', identification_num='20103100522', email='moh\'d22@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_23 = User.objects.create_user(first_name='Muhammad23', last_name='Amin23', identification_num='20103100523', email='moh\'d23@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_24 = User.objects.create_user(first_name='Muhammad24', last_name='Amin24', identification_num='20103100524', email='moh\'d24@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_25 = User.objects.create_user(first_name='Muhammad25', last_name='Amin25', identification_num='20103100525', email='moh\'d25@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_26 = User.objects.create_user(first_name='Muhammad26', last_name='Amin26', identification_num='20103100526', email='moh\'d26@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_27 = User.objects.create_user(first_name='Muhammad27', last_name='Amin27', identification_num='20103100527', email='moh\'d27@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_28 = User.objects.create_user(first_name='Muhammad28', last_name='Amin28', identification_num='20103100528', email='moh\'d28@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_29 = User.objects.create_user(first_name='Muhammad29', last_name='Amin29', identification_num='20103100529', email='moh\'d29@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_30 = User.objects.create_user(first_name='Muhammad30', last_name='Amin30', identification_num='20103100530', email='moh\'d30@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_31 = User.objects.create_user(first_name='Muhammad31', last_name='Amin31', identification_num='20103100531', email='moh\'d31@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_32 = User.objects.create_user(first_name='Muhammad32', last_name='Amin32', identification_num='20103100532', email='moh\'d32@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_33 = User.objects.create_user(first_name='Muhammad33', last_name='Amin33', identification_num='20103100533', email='moh\'d33@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_34 = User.objects.create_user(first_name='Muhammad34', last_name='Amin34', identification_num='20103100534', email='moh\'d34@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_35 = User.objects.create_user(first_name='Muhammad35', last_name='Amin35', identification_num='20103100535', email='moh\'d35@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_36 = User.objects.create_user(first_name='Muhammad36', last_name='Amin36', identification_num='20103100536', email='moh\'d36@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_37 = User.objects.create_user(first_name='Muhammad37', last_name='Amin37', identification_num='20103100537', email='moh\'d37@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_38 = User.objects.create_user(first_name='Muhammad38', last_name='Amin38', identification_num='20103100538', email='moh\'d38@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_39 = User.objects.create_user(first_name='Muhammad39', last_name='Amin39', identification_num='20103100539', email='moh\'d39@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_40 = User.objects.create_user(first_name='Muhammad40', last_name='Amin40', identification_num='20103100540', email='moh\'d40@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_41 = User.objects.create_user(first_name='Muhammad41', last_name='Amin41', identification_num='20103100541', email='moh\'d41@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_42 = User.objects.create_user(first_name='Muhammad42', last_name='Amin42', identification_num='20103100542', email='moh\'d42@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_43 = User.objects.create_user(first_name='Muhammad43', last_name='Amin43', identification_num='20103100543', email='moh\'d43@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_44 = User.objects.create_user(first_name='Muhammad44', last_name='Amin44', identification_num='20103100544', email='moh\'d44@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_45 = User.objects.create_user(first_name='Muhammad45', last_name='Amin45', identification_num='20103100545', email='moh\'d45@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_46 = User.objects.create_user(first_name='Muhammad46', last_name='Amin46', identification_num='20103100546', email='moh\'d46@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_47 = User.objects.create_user(first_name='Muhammad47', last_name='Amin47', identification_num='20103100547', email='moh\'d47@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_48 = User.objects.create_user(first_name='Muhammad48', last_name='Amin48', identification_num='20103100548', email='moh\'d48@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_49 = User.objects.create_user(first_name='Muhammad49', last_name='Amin49', identification_num='20103100549', email='moh\'d49@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_50 = User.objects.create_user(first_name='Muhammad50', last_name='Amin50', identification_num='20103100550', email='moh\'d50@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_51 = User.objects.create_user(first_name='Muhammad51', last_name='Amin51', identification_num='20103100551', email='moh\'d51@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_52 = User.objects.create_user(first_name='Muhammad52', last_name='Amin52', identification_num='20103100552', email='moh\'d52@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_53 = User.objects.create_user(first_name='Muhammad53', last_name='Amin53', identification_num='20103100553', email='moh\'d53@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_54 = User.objects.create_user(first_name='Muhammad54', last_name='Amin54', identification_num='20103100554', email='moh\'d54@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_55 = User.objects.create_user(first_name='Muhammad55', last_name='Amin55', identification_num='20103100555', email='moh\'d55@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_56 = User.objects.create_user(first_name='Muhammad56', last_name='Amin56', identification_num='20103100556', email='moh\'d56@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_57 = User.objects.create_user(first_name='Muhammad57', last_name='Amin57', identification_num='20103100557', email='moh\'d57@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_58 = User.objects.create_user(first_name='Muhammad58', last_name='Amin58', identification_num='20103100558', email='moh\'d58@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_59 = User.objects.create_user(first_name='Muhammad59', last_name='Amin59', identification_num='20103100559', email='moh\'d59@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_60 = User.objects.create_user(first_name='Muhammad60', last_name='Amin60', identification_num='20103100560', email='moh\'d60@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_61 = User.objects.create_user(first_name='Muhammad61', last_name='Amin61', identification_num='20103100561', email='moh\'d61@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_62 = User.objects.create_user(first_name='Muhammad62', last_name='Amin62', identification_num='20103100562', email='moh\'d62@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_63 = User.objects.create_user(first_name='Muhammad63', last_name='Amin63', identification_num='20103100563', email='moh\'d63@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_64 = User.objects.create_user(first_name='Muhammad64', last_name='Amin64', identification_num='20103100564', email='moh\'d64@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_65 = User.objects.create_user(first_name='Muhammad65', last_name='Amin65', identification_num='20103100565', email='moh\'d65@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_66 = User.objects.create_user(first_name='Muhammad66', last_name='Amin66', identification_num='20103100566', email='moh\'d66@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_67 = User.objects.create_user(first_name='Muhammad67', last_name='Amin67', identification_num='20103100567', email='moh\'d67@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_68 = User.objects.create_user(first_name='Muhammad68', last_name='Amin68', identification_num='20103100568', email='moh\'d68@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_69 = User.objects.create_user(first_name='Muhammad69', last_name='Amin69', identification_num='20103100569', email='moh\'d69@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_70 = User.objects.create_user(first_name='Muhammad70', last_name='Amin70', identification_num='20103100570', email='moh\'d70@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_71 = User.objects.create_user(first_name='Muhammad71', last_name='Amin71', identification_num='20103100571', email='moh\'d71@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_72 = User.objects.create_user(first_name='Muhammad72', last_name='Amin72', identification_num='20103100572', email='moh\'d72@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_73 = User.objects.create_user(first_name='Muhammad73', last_name='Amin73', identification_num='20103100573', email='moh\'d73@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_74 = User.objects.create_user(first_name='Muhammad74', last_name='Amin74', identification_num='20103100574', email='moh\'d74@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_75 = User.objects.create_user(first_name='Muhammad75', last_name='Amin75', identification_num='20103100575', email='moh\'d75@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_76 = User.objects.create_user(first_name='Muhammad76', last_name='Amin76', identification_num='20103100576', email='moh\'d76@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_77 = User.objects.create_user(first_name='Muhammad77', last_name='Amin77', identification_num='20103100577', email='moh\'d77@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_78 = User.objects.create_user(first_name='Muhammad78', last_name='Amin78', identification_num='20103100578', email='moh\'d78@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_79 = User.objects.create_user(first_name='Muhammad79', last_name='Amin79', identification_num='20103100579', email='moh\'d79@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_80 = User.objects.create_user(first_name='Muhammad80', last_name='Amin80', identification_num='20103100580', email='moh\'d80@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_81 = User.objects.create_user(first_name='Muhammad81', last_name='Amin81', identification_num='20103100581', email='moh\'d81@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_82 = User.objects.create_user(first_name='Muhammad82', last_name='Amin82', identification_num='20103100582', email='moh\'d82@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_83 = User.objects.create_user(first_name='Muhammad83', last_name='Amin83', identification_num='20103100583', email='moh\'d83@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_84 = User.objects.create_user(first_name='Muhammad84', last_name='Amin84', identification_num='20103100584', email='moh\'d84@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_85 = User.objects.create_user(first_name='Muhammad85', last_name='Amin85', identification_num='20103100585', email='moh\'d85@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_86 = User.objects.create_user(first_name='Muhammad86', last_name='Amin86', identification_num='20103100586', email='moh\'d86@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_87 = User.objects.create_user(first_name='Muhammad87', last_name='Amin87', identification_num='20103100587', email='moh\'d87@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_88 = User.objects.create_user(first_name='Muhammad88', last_name='Amin88', identification_num='20103100588', email='moh\'d88@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_89 = User.objects.create_user(first_name='Muhammad89', last_name='Amin89', identification_num='20103100589', email='moh\'d89@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_90 = User.objects.create_user(first_name='Muhammad90', last_name='Amin90', identification_num='20103100590', email='moh\'d90@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_91 = User.objects.create_user(first_name='Muhammad91', last_name='Amin91', identification_num='20103100591', email='moh\'d91@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_92 = User.objects.create_user(first_name='Muhammad92', last_name='Amin92', identification_num='20103100592', email='moh\'d92@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_93 = User.objects.create_user(first_name='Muhammad93', last_name='Amin93', identification_num='20103100593', email='moh\'d93@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_94 = User.objects.create_user(first_name='Muhammad94', last_name='Amin94', identification_num='20103100594', email='moh\'d94@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_95 = User.objects.create_user(first_name='Muhammad95', last_name='Amin95', identification_num='20103100595', email='moh\'d95@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_96 = User.objects.create_user(first_name='Muhammad96', last_name='Amin96', identification_num='20103100596', email='moh\'d96@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_97 = User.objects.create_user(first_name='Muhammad97', last_name='Amin97', identification_num='20103100597', email='moh\'d97@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_98 = User.objects.create_user(first_name='Muhammad98', last_name='Amin98', identification_num='20103100598', email='moh\'d98@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_99 = User.objects.create_user(first_name='Muhammad99', last_name='Amin99', identification_num='20103100599', email='moh\'d99@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_100 = User.objects.create_user(first_name='Muhammad100', last_name='Amin100', identification_num='201031005100', email='moh\'d100@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_101 = User.objects.create_user(first_name='Muhammad101', last_name='Amin101', identification_num='201031005101', email='moh\'d101@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_102 = User.objects.create_user(first_name='Muhammad102', last_name='Amin102', identification_num='201031005102', email='moh\'d102@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_103 = User.objects.create_user(first_name='Muhammad103', last_name='Amin103', identification_num='201031005103', email='moh\'d103@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_104 = User.objects.create_user(first_name='Muhammad104', last_name='Amin104', identification_num='201031005104', email='moh\'d104@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_105 = User.objects.create_user(first_name='Muhammad105', last_name='Amin105', identification_num='201031005105', email='moh\'d105@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_106 = User.objects.create_user(first_name='Muhammad106', last_name='Amin106', identification_num='201031005106', email='moh\'d106@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_107 = User.objects.create_user(first_name='Muhammad107', last_name='Amin107', identification_num='201031005107', email='moh\'d107@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_108 = User.objects.create_user(first_name='Muhammad108', last_name='Amin108', identification_num='201031005108', email='moh\'d108@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_109 = User.objects.create_user(first_name='Muhammad109', last_name='Amin109', identification_num='201031005109', email='moh\'d109@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_110 = User.objects.create_user(first_name='Muhammad110', last_name='Amin110', identification_num='201031005110', email='moh\'d110@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_111 = User.objects.create_user(first_name='Muhammad111', last_name='Amin111', identification_num='201031005111', email='moh\'d111@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_112 = User.objects.create_user(first_name='Muhammad112', last_name='Amin112', identification_num='201031005112', email='moh\'d112@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_113 = User.objects.create_user(first_name='Muhammad113', last_name='Amin113', identification_num='201031005113', email='moh\'d113@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_114 = User.objects.create_user(first_name='Muhammad114', last_name='Amin114', identification_num='201031005114', email='moh\'d114@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_115 = User.objects.create_user(first_name='Muhammad115', last_name='Amin115', identification_num='201031005115', email='moh\'d115@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_116 = User.objects.create_user(first_name='Muhammad116', last_name='Amin116', identification_num='201031005116', email='moh\'d116@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_117 = User.objects.create_user(first_name='Muhammad117', last_name='Amin117', identification_num='201031005117', email='moh\'d117@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_118 = User.objects.create_user(first_name='Muhammad118', last_name='Amin118', identification_num='201031005118', email='moh\'d118@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_119 = User.objects.create_user(first_name='Muhammad119', last_name='Amin119', identification_num='201031005119', email='moh\'d119@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_120 = User.objects.create_user(first_name='Muhammad120', last_name='Amin120', identification_num='201031005120', email='moh\'d120@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_121 = User.objects.create_user(first_name='Muhammad121', last_name='Amin121', identification_num='201031005121', email='moh\'d121@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_122 = User.objects.create_user(first_name='Muhammad122', last_name='Amin122', identification_num='201031005122', email='moh\'d122@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_123 = User.objects.create_user(first_name='Muhammad123', last_name='Amin123', identification_num='201031005123', email='moh\'d123@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_124 = User.objects.create_user(first_name='Muhammad124', last_name='Amin124', identification_num='201031005124', email='moh\'d124@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_125 = User.objects.create_user(first_name='Muhammad125', last_name='Amin125', identification_num='201031005125', email='moh\'d125@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_126 = User.objects.create_user(first_name='Muhammad126', last_name='Amin126', identification_num='201031005126', email='moh\'d126@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_127 = User.objects.create_user(first_name='Muhammad127', last_name='Amin127', identification_num='201031005127', email='moh\'d127@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_128 = User.objects.create_user(first_name='Muhammad128', last_name='Amin128', identification_num='201031005128', email='moh\'d128@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_129 = User.objects.create_user(first_name='Muhammad129', last_name='Amin129', identification_num='201031005129', email='moh\'d129@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_130 = User.objects.create_user(first_name='Muhammad130', last_name='Amin130', identification_num='201031005130', email='moh\'d130@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_131 = User.objects.create_user(first_name='Muhammad131', last_name='Amin131', identification_num='201031005131', email='moh\'d131@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_132 = User.objects.create_user(first_name='Muhammad132', last_name='Amin132', identification_num='201031005132', email='moh\'d132@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_133 = User.objects.create_user(first_name='Muhammad133', last_name='Amin133', identification_num='201031005133', email='moh\'d133@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_134 = User.objects.create_user(first_name='Muhammad134', last_name='Amin134', identification_num='201031005134', email='moh\'d134@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_135 = User.objects.create_user(first_name='Muhammad135', last_name='Amin135', identification_num='201031005135', email='moh\'d135@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_136 = User.objects.create_user(first_name='Muhammad136', last_name='Amin136', identification_num='201031005136', email='moh\'d136@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_137 = User.objects.create_user(first_name='Muhammad137', last_name='Amin137', identification_num='201031005137', email='moh\'d137@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_138 = User.objects.create_user(first_name='Muhammad138', last_name='Amin138', identification_num='201031005138', email='moh\'d138@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_139 = User.objects.create_user(first_name='Muhammad139', last_name='Amin139', identification_num='201031005139', email='moh\'d139@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_140 = User.objects.create_user(first_name='Muhammad140', last_name='Amin140', identification_num='201031005140', email='moh\'d140@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_141 = User.objects.create_user(first_name='Muhammad141', last_name='Amin141', identification_num='201031005141', email='moh\'d141@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_142 = User.objects.create_user(first_name='Muhammad142', last_name='Amin142', identification_num='201031005142', email='moh\'d142@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_143 = User.objects.create_user(first_name='Muhammad143', last_name='Amin143', identification_num='201031005143', email='moh\'d143@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_144 = User.objects.create_user(first_name='Muhammad144', last_name='Amin144', identification_num='201031005144', email='moh\'d144@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_145 = User.objects.create_user(first_name='Muhammad145', last_name='Amin145', identification_num='201031005145', email='moh\'d145@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_146 = User.objects.create_user(first_name='Muhammad146', last_name='Amin146', identification_num='201031005146', email='moh\'d146@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_147 = User.objects.create_user(first_name='Muhammad147', last_name='Amin147', identification_num='201031005147', email='moh\'d147@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_148 = User.objects.create_user(first_name='Muhammad148', last_name='Amin148', identification_num='201031005148', email='moh\'d148@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_149 = User.objects.create_user(first_name='Muhammad149', last_name='Amin149', identification_num='201031005149', email='moh\'d149@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_150 = User.objects.create_user(first_name='Muhammad150', last_name='Amin150', identification_num='201031005150', email='moh\'d150@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_151 = User.objects.create_user(first_name='Muhammad151', last_name='Amin151', identification_num='201031005151', email='moh\'d151@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_152 = User.objects.create_user(first_name='Muhammad152', last_name='Amin152', identification_num='201031005152', email='moh\'d152@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_153 = User.objects.create_user(first_name='Muhammad153', last_name='Amin153', identification_num='201031005153', email='moh\'d153@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_154 = User.objects.create_user(first_name='Muhammad154', last_name='Amin154', identification_num='201031005154', email='moh\'d154@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_155 = User.objects.create_user(first_name='Muhammad155', last_name='Amin155', identification_num='201031005155', email='moh\'d155@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_156 = User.objects.create_user(first_name='Muhammad156', last_name='Amin156', identification_num='201031005156', email='moh\'d156@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_157 = User.objects.create_user(first_name='Muhammad157', last_name='Amin157', identification_num='201031005157', email='moh\'d157@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_158 = User.objects.create_user(first_name='Muhammad158', last_name='Amin158', identification_num='201031005158', email='moh\'d158@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_159 = User.objects.create_user(first_name='Muhammad159', last_name='Amin159', identification_num='201031005159', email='moh\'d159@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_160 = User.objects.create_user(first_name='Muhammad160', last_name='Amin160', identification_num='201031005160', email='moh\'d160@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_161 = User.objects.create_user(first_name='Muhammad161', last_name='Amin161', identification_num='201031005161', email='moh\'d161@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_162 = User.objects.create_user(first_name='Muhammad162', last_name='Amin162', identification_num='201031005162', email='moh\'d162@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_163 = User.objects.create_user(first_name='Muhammad163', last_name='Amin163', identification_num='201031005163', email='moh\'d163@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_164 = User.objects.create_user(first_name='Muhammad164', last_name='Amin164', identification_num='201031005164', email='moh\'d164@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_165 = User.objects.create_user(first_name='Muhammad165', last_name='Amin165', identification_num='201031005165', email='moh\'d165@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_166 = User.objects.create_user(first_name='Muhammad166', last_name='Amin166', identification_num='201031005166', email='moh\'d166@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_167 = User.objects.create_user(first_name='Muhammad167', last_name='Amin167', identification_num='201031005167', email='moh\'d167@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_168 = User.objects.create_user(first_name='Muhammad168', last_name='Amin168', identification_num='201031005168', email='moh\'d168@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_169 = User.objects.create_user(first_name='Muhammad169', last_name='Amin169', identification_num='201031005169', email='moh\'d169@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_170 = User.objects.create_user(first_name='Muhammad170', last_name='Amin170', identification_num='201031005170', email='moh\'d170@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_171 = User.objects.create_user(first_name='Muhammad171', last_name='Amin171', identification_num='201031005171', email='moh\'d171@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_172 = User.objects.create_user(first_name='Muhammad172', last_name='Amin172', identification_num='201031005172', email='moh\'d172@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_173 = User.objects.create_user(first_name='Muhammad173', last_name='Amin173', identification_num='201031005173', email='moh\'d173@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_174 = User.objects.create_user(first_name='Muhammad174', last_name='Amin174', identification_num='201031005174', email='moh\'d174@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_175 = User.objects.create_user(first_name='Muhammad175', last_name='Amin175', identification_num='201031005175', email='moh\'d175@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_176 = User.objects.create_user(first_name='Muhammad176', last_name='Amin176', identification_num='201031005176', email='moh\'d176@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_177 = User.objects.create_user(first_name='Muhammad177', last_name='Amin177', identification_num='201031005177', email='moh\'d177@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_178 = User.objects.create_user(first_name='Muhammad178', last_name='Amin178', identification_num='201031005178', email='moh\'d178@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_179 = User.objects.create_user(first_name='Muhammad179', last_name='Amin179', identification_num='201031005179', email='moh\'d179@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_180 = User.objects.create_user(first_name='Muhammad180', last_name='Amin180', identification_num='201031005180', email='moh\'d180@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_181 = User.objects.create_user(first_name='Muhammad181', last_name='Amin181', identification_num='201031005181', email='moh\'d181@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_182 = User.objects.create_user(first_name='Muhammad182', last_name='Amin182', identification_num='201031005182', email='moh\'d182@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_183 = User.objects.create_user(first_name='Muhammad183', last_name='Amin183', identification_num='201031005183', email='moh\'d183@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_184 = User.objects.create_user(first_name='Muhammad184', last_name='Amin184', identification_num='201031005184', email='moh\'d184@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_185 = User.objects.create_user(first_name='Muhammad185', last_name='Amin185', identification_num='201031005185', email='moh\'d185@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_186 = User.objects.create_user(first_name='Muhammad186', last_name='Amin186', identification_num='201031005186', email='moh\'d186@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_187 = User.objects.create_user(first_name='Muhammad187', last_name='Amin187', identification_num='201031005187', email='moh\'d187@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_188 = User.objects.create_user(first_name='Muhammad188', last_name='Amin188', identification_num='201031005188', email='moh\'d188@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_189 = User.objects.create_user(first_name='Muhammad189', last_name='Amin189', identification_num='201031005189', email='moh\'d189@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_190 = User.objects.create_user(first_name='Muhammad190', last_name='Amin190', identification_num='201031005190', email='moh\'d190@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_191 = User.objects.create_user(first_name='Muhammad191', last_name='Amin191', identification_num='201031005191', email='moh\'d191@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_192 = User.objects.create_user(first_name='Muhammad192', last_name='Amin192', identification_num='201031005192', email='moh\'d192@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_193 = User.objects.create_user(first_name='Muhammad193', last_name='Amin193', identification_num='201031005193', email='moh\'d193@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_194 = User.objects.create_user(first_name='Muhammad194', last_name='Amin194', identification_num='201031005194', email='moh\'d194@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_195 = User.objects.create_user(first_name='Muhammad195', last_name='Amin195', identification_num='201031005195', email='moh\'d195@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_196 = User.objects.create_user(first_name='Muhammad196', last_name='Amin196', identification_num='201031005196', email='moh\'d196@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_197 = User.objects.create_user(first_name='Muhammad197', last_name='Amin197', identification_num='201031005197', email='moh\'d197@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_198 = User.objects.create_user(first_name='Muhammad198', last_name='Amin198', identification_num='201031005198', email='moh\'d198@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_199 = User.objects.create_user(first_name='Muhammad199', last_name='Amin199', identification_num='201031005199', email='moh\'d199@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_200 = User.objects.create_user(first_name='Muhammad200', last_name='Amin200', identification_num='201031005200', email='moh\'d200@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_201 = User.objects.create_user(first_name='Muhammad201', last_name='Amin201', identification_num='201031005201', email='moh\'d201@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_202 = User.objects.create_user(first_name='Muhammad202', last_name='Amin202', identification_num='201031005202', email='moh\'d202@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_203 = User.objects.create_user(first_name='Muhammad203', last_name='Amin203', identification_num='201031005203', email='moh\'d203@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_204 = User.objects.create_user(first_name='Muhammad204', last_name='Amin204', identification_num='201031005204', email='moh\'d204@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_205 = User.objects.create_user(first_name='Muhammad205', last_name='Amin205', identification_num='201031005205', email='moh\'d205@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_206 = User.objects.create_user(first_name='Muhammad206', last_name='Amin206', identification_num='201031005206', email='moh\'d206@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_207 = User.objects.create_user(first_name='Muhammad207', last_name='Amin207', identification_num='201031005207', email='moh\'d207@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_208 = User.objects.create_user(first_name='Muhammad208', last_name='Amin208', identification_num='201031005208', email='moh\'d208@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_209 = User.objects.create_user(first_name='Muhammad209', last_name='Amin209', identification_num='201031005209', email='moh\'d209@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_210 = User.objects.create_user(first_name='Muhammad210', last_name='Amin210', identification_num='201031005210', email='moh\'d210@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_211 = User.objects.create_user(first_name='Muhammad211', last_name='Amin211', identification_num='201031005211', email='moh\'d211@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_212 = User.objects.create_user(first_name='Muhammad212', last_name='Amin212', identification_num='201031005212', email='moh\'d212@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_213 = User.objects.create_user(first_name='Muhammad213', last_name='Amin213', identification_num='201031005213', email='moh\'d213@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_214 = User.objects.create_user(first_name='Muhammad214', last_name='Amin214', identification_num='201031005214', email='moh\'d214@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_215 = User.objects.create_user(first_name='Muhammad215', last_name='Amin215', identification_num='201031005215', email='moh\'d215@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_216 = User.objects.create_user(first_name='Muhammad216', last_name='Amin216', identification_num='201031005216', email='moh\'d216@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_217 = User.objects.create_user(first_name='Muhammad217', last_name='Amin217', identification_num='201031005217', email='moh\'d217@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_218 = User.objects.create_user(first_name='Muhammad218', last_name='Amin218', identification_num='201031005218', email='moh\'d218@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_219 = User.objects.create_user(first_name='Muhammad219', last_name='Amin219', identification_num='201031005219', email='moh\'d219@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_220 = User.objects.create_user(first_name='Muhammad220', last_name='Amin220', identification_num='201031005220', email='moh\'d220@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_221 = User.objects.create_user(first_name='Muhammad221', last_name='Amin221', identification_num='201031005221', email='moh\'d221@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_222 = User.objects.create_user(first_name='Muhammad222', last_name='Amin222', identification_num='201031005222', email='moh\'d222@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_223 = User.objects.create_user(first_name='Muhammad223', last_name='Amin223', identification_num='201031005223', email='moh\'d223@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_224 = User.objects.create_user(first_name='Muhammad224', last_name='Amin224', identification_num='201031005224', email='moh\'d224@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_225 = User.objects.create_user(first_name='Muhammad225', last_name='Amin225', identification_num='201031005225', email='moh\'d225@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_226 = User.objects.create_user(first_name='Muhammad226', last_name='Amin226', identification_num='201031005226', email='moh\'d226@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_227 = User.objects.create_user(first_name='Muhammad227', last_name='Amin227', identification_num='201031005227', email='moh\'d227@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_228 = User.objects.create_user(first_name='Muhammad228', last_name='Amin228', identification_num='201031005228', email='moh\'d228@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_229 = User.objects.create_user(first_name='Muhammad229', last_name='Amin229', identification_num='201031005229', email='moh\'d229@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_230 = User.objects.create_user(first_name='Muhammad230', last_name='Amin230', identification_num='201031005230', email='moh\'d230@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_231 = User.objects.create_user(first_name='Muhammad231', last_name='Amin231', identification_num='201031005231', email='moh\'d231@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_232 = User.objects.create_user(first_name='Muhammad232', last_name='Amin232', identification_num='201031005232', email='moh\'d232@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_233 = User.objects.create_user(first_name='Muhammad233', last_name='Amin233', identification_num='201031005233', email='moh\'d233@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_234 = User.objects.create_user(first_name='Muhammad234', last_name='Amin234', identification_num='201031005234', email='moh\'d234@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_235 = User.objects.create_user(first_name='Muhammad235', last_name='Amin235', identification_num='201031005235', email='moh\'d235@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_236 = User.objects.create_user(first_name='Muhammad236', last_name='Amin236', identification_num='201031005236', email='moh\'d236@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_237 = User.objects.create_user(first_name='Muhammad237', last_name='Amin237', identification_num='201031005237', email='moh\'d237@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_238 = User.objects.create_user(first_name='Muhammad238', last_name='Amin238', identification_num='201031005238', email='moh\'d238@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_239 = User.objects.create_user(first_name='Muhammad239', last_name='Amin239', identification_num='201031005239', email='moh\'d239@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_240 = User.objects.create_user(first_name='Muhammad240', last_name='Amin240', identification_num='201031005240', email='moh\'d240@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_241 = User.objects.create_user(first_name='Muhammad241', last_name='Amin241', identification_num='201031005241', email='moh\'d241@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_242 = User.objects.create_user(first_name='Muhammad242', last_name='Amin242', identification_num='201031005242', email='moh\'d242@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_243 = User.objects.create_user(first_name='Muhammad243', last_name='Amin243', identification_num='201031005243', email='moh\'d243@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_244 = User.objects.create_user(first_name='Muhammad244', last_name='Amin244', identification_num='201031005244', email='moh\'d244@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_245 = User.objects.create_user(first_name='Muhammad245', last_name='Amin245', identification_num='201031005245', email='moh\'d245@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_246 = User.objects.create_user(first_name='Muhammad246', last_name='Amin246', identification_num='201031005246', email='moh\'d246@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_247 = User.objects.create_user(first_name='Muhammad247', last_name='Amin247', identification_num='201031005247', email='moh\'d247@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_248 = User.objects.create_user(first_name='Muhammad248', last_name='Amin248', identification_num='201031005248', email='moh\'d248@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_249 = User.objects.create_user(first_name='Muhammad249', last_name='Amin249', identification_num='201031005249', email='moh\'d249@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_250 = User.objects.create_user(first_name='Muhammad250', last_name='Amin250', identification_num='201031005250', email='moh\'d250@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_251 = User.objects.create_user(first_name='Muhammad251', last_name='Amin251', identification_num='201031005251', email='moh\'d251@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_252 = User.objects.create_user(first_name='Muhammad252', last_name='Amin252', identification_num='201031005252', email='moh\'d252@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_253 = User.objects.create_user(first_name='Muhammad253', last_name='Amin253', identification_num='201031005253', email='moh\'d253@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_254 = User.objects.create_user(first_name='Muhammad254', last_name='Amin254', identification_num='201031005254', email='moh\'d254@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_255 = User.objects.create_user(first_name='Muhammad255', last_name='Amin255', identification_num='201031005255', email='moh\'d255@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_256 = User.objects.create_user(first_name='Muhammad256', last_name='Amin256', identification_num='201031005256', email='moh\'d256@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_257 = User.objects.create_user(first_name='Muhammad257', last_name='Amin257', identification_num='201031005257', email='moh\'d257@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_258 = User.objects.create_user(first_name='Muhammad258', last_name='Amin258', identification_num='201031005258', email='moh\'d258@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_259 = User.objects.create_user(first_name='Muhammad259', last_name='Amin259', identification_num='201031005259', email='moh\'d259@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_260 = User.objects.create_user(first_name='Muhammad260', last_name='Amin260', identification_num='201031005260', email='moh\'d260@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_261 = User.objects.create_user(first_name='Muhammad261', last_name='Amin261', identification_num='201031005261', email='moh\'d261@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_262 = User.objects.create_user(first_name='Muhammad262', last_name='Amin262', identification_num='201031005262', email='moh\'d262@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_263 = User.objects.create_user(first_name='Muhammad263', last_name='Amin263', identification_num='201031005263', email='moh\'d263@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_264 = User.objects.create_user(first_name='Muhammad264', last_name='Amin264', identification_num='201031005264', email='moh\'d264@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_265 = User.objects.create_user(first_name='Muhammad265', last_name='Amin265', identification_num='201031005265', email='moh\'d265@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_266 = User.objects.create_user(first_name='Muhammad266', last_name='Amin266', identification_num='201031005266', email='moh\'d266@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_267 = User.objects.create_user(first_name='Muhammad267', last_name='Amin267', identification_num='201031005267', email='moh\'d267@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_268 = User.objects.create_user(first_name='Muhammad268', last_name='Amin268', identification_num='201031005268', email='moh\'d268@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_269 = User.objects.create_user(first_name='Muhammad269', last_name='Amin269', identification_num='201031005269', email='moh\'d269@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_270 = User.objects.create_user(first_name='Muhammad270', last_name='Amin270', identification_num='201031005270', email='moh\'d270@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_271 = User.objects.create_user(first_name='Muhammad271', last_name='Amin271', identification_num='201031005271', email='moh\'d271@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_272 = User.objects.create_user(first_name='Muhammad272', last_name='Amin272', identification_num='201031005272', email='moh\'d272@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_273 = User.objects.create_user(first_name='Muhammad273', last_name='Amin273', identification_num='201031005273', email='moh\'d273@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_274 = User.objects.create_user(first_name='Muhammad274', last_name='Amin274', identification_num='201031005274', email='moh\'d274@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_275 = User.objects.create_user(first_name='Muhammad275', last_name='Amin275', identification_num='201031005275', email='moh\'d275@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_276 = User.objects.create_user(first_name='Muhammad276', last_name='Amin276', identification_num='201031005276', email='moh\'d276@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_277 = User.objects.create_user(first_name='Muhammad277', last_name='Amin277', identification_num='201031005277', email='moh\'d277@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_278 = User.objects.create_user(first_name='Muhammad278', last_name='Amin278', identification_num='201031005278', email='moh\'d278@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_279 = User.objects.create_user(first_name='Muhammad279', last_name='Amin279', identification_num='201031005279', email='moh\'d279@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_280 = User.objects.create_user(first_name='Muhammad280', last_name='Amin280', identification_num='201031005280', email='moh\'d280@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_281 = User.objects.create_user(first_name='Muhammad281', last_name='Amin281', identification_num='201031005281', email='moh\'d281@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_282 = User.objects.create_user(first_name='Muhammad282', last_name='Amin282', identification_num='201031005282', email='moh\'d282@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_283 = User.objects.create_user(first_name='Muhammad283', last_name='Amin283', identification_num='201031005283', email='moh\'d283@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_284 = User.objects.create_user(first_name='Muhammad284', last_name='Amin284', identification_num='201031005284', email='moh\'d284@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_285 = User.objects.create_user(first_name='Muhammad285', last_name='Amin285', identification_num='201031005285', email='moh\'d285@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_286 = User.objects.create_user(first_name='Muhammad286', last_name='Amin286', identification_num='201031005286', email='moh\'d286@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_287 = User.objects.create_user(first_name='Muhammad287', last_name='Amin287', identification_num='201031005287', email='moh\'d287@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_288 = User.objects.create_user(first_name='Muhammad288', last_name='Amin288', identification_num='201031005288', email='moh\'d288@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_289 = User.objects.create_user(first_name='Muhammad289', last_name='Amin289', identification_num='201031005289', email='moh\'d289@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_290 = User.objects.create_user(first_name='Muhammad290', last_name='Amin290', identification_num='201031005290', email='moh\'d290@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_291 = User.objects.create_user(first_name='Muhammad291', last_name='Amin291', identification_num='201031005291', email='moh\'d291@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_292 = User.objects.create_user(first_name='Muhammad292', last_name='Amin292', identification_num='201031005292', email='moh\'d292@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_293 = User.objects.create_user(first_name='Muhammad293', last_name='Amin293', identification_num='201031005293', email='moh\'d293@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_294 = User.objects.create_user(first_name='Muhammad294', last_name='Amin294', identification_num='201031005294', email='moh\'d294@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_295 = User.objects.create_user(first_name='Muhammad295', last_name='Amin295', identification_num='201031005295', email='moh\'d295@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_296 = User.objects.create_user(first_name='Muhammad296', last_name='Amin296', identification_num='201031005296', email='moh\'d296@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_297 = User.objects.create_user(first_name='Muhammad297', last_name='Amin297', identification_num='201031005297', email='moh\'d297@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_298 = User.objects.create_user(first_name='Muhammad298', last_name='Amin298', identification_num='201031005298', email='moh\'d298@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_299 = User.objects.create_user(first_name='Muhammad299', last_name='Amin299', identification_num='201031005299', email='moh\'d299@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_300 = User.objects.create_user(first_name='Muhammad300', last_name='Amin300', identification_num='201031005300', email='moh\'d300@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_301 = User.objects.create_user(first_name='Muhammad301', last_name='Amin301', identification_num='201031005301', email='moh\'d301@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_302 = User.objects.create_user(first_name='Muhammad302', last_name='Amin302', identification_num='201031005302', email='moh\'d302@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_303 = User.objects.create_user(first_name='Muhammad303', last_name='Amin303', identification_num='201031005303', email='moh\'d303@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_304 = User.objects.create_user(first_name='Muhammad304', last_name='Amin304', identification_num='201031005304', email='moh\'d304@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_305 = User.objects.create_user(first_name='Muhammad305', last_name='Amin305', identification_num='201031005305', email='moh\'d305@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_306 = User.objects.create_user(first_name='Muhammad306', last_name='Amin306', identification_num='201031005306', email='moh\'d306@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_307 = User.objects.create_user(first_name='Muhammad307', last_name='Amin307', identification_num='201031005307', email='moh\'d307@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_308 = User.objects.create_user(first_name='Muhammad308', last_name='Amin308', identification_num='201031005308', email='moh\'d308@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_309 = User.objects.create_user(first_name='Muhammad309', last_name='Amin309', identification_num='201031005309', email='moh\'d309@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_310 = User.objects.create_user(first_name='Muhammad310', last_name='Amin310', identification_num='201031005310', email='moh\'d310@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_311 = User.objects.create_user(first_name='Muhammad311', last_name='Amin311', identification_num='201031005311', email='moh\'d311@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_312 = User.objects.create_user(first_name='Muhammad312', last_name='Amin312', identification_num='201031005312', email='moh\'d312@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_313 = User.objects.create_user(first_name='Muhammad313', last_name='Amin313', identification_num='201031005313', email='moh\'d313@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_314 = User.objects.create_user(first_name='Muhammad314', last_name='Amin314', identification_num='201031005314', email='moh\'d314@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_315 = User.objects.create_user(first_name='Muhammad315', last_name='Amin315', identification_num='201031005315', email='moh\'d315@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_316 = User.objects.create_user(first_name='Muhammad316', last_name='Amin316', identification_num='201031005316', email='moh\'d316@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_317 = User.objects.create_user(first_name='Muhammad317', last_name='Amin317', identification_num='201031005317', email='moh\'d317@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_318 = User.objects.create_user(first_name='Muhammad318', last_name='Amin318', identification_num='201031005318', email='moh\'d318@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_319 = User.objects.create_user(first_name='Muhammad319', last_name='Amin319', identification_num='201031005319', email='moh\'d319@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set
student_user_320 = User.objects.create_user(first_name='Muhammad320', last_name='Amin320', identification_num='201031005320', email='moh\'d320@mail.com', phone_number='+2348144807233', is_student=True, date_of_birth=dob, country='Nigeria') # user_password_not_set

student_user_1.save()
student_user_2.save()
student_user_3.save()
student_user_4.save()
student_user_5.save()
student_user_6.save()
student_user_7.save()
student_user_8.save()
student_user_9.save()
student_user_10.save()
student_user_11.save()
student_user_12.save()
student_user_13.save()
student_user_14.save()
student_user_15.save()
student_user_16.save()
student_user_17.save()
student_user_18.save()
student_user_19.save()
student_user_20.save()
student_user_21.save()
student_user_22.save()
student_user_23.save()
student_user_24.save()
student_user_25.save()
student_user_26.save()
student_user_27.save()
student_user_28.save()
student_user_29.save()
student_user_30.save()
student_user_31.save()
student_user_32.save()
student_user_33.save()
student_user_34.save()
student_user_35.save()
student_user_36.save()
student_user_37.save()
student_user_38.save()
student_user_39.save()
student_user_40.save()
student_user_41.save()
student_user_42.save()
student_user_43.save()
student_user_44.save()
student_user_45.save()
student_user_46.save()
student_user_47.save()
student_user_48.save()
student_user_49.save()
student_user_50.save()
student_user_51.save()
student_user_52.save()
student_user_53.save()
student_user_54.save()
student_user_55.save()
student_user_56.save()
student_user_57.save()
student_user_58.save()
student_user_59.save()
student_user_60.save()
student_user_61.save()
student_user_62.save()
student_user_63.save()
student_user_64.save()
student_user_65.save()
student_user_66.save()
student_user_67.save()
student_user_68.save()
student_user_69.save()
student_user_70.save()
student_user_71.save()
student_user_72.save()
student_user_73.save()
student_user_74.save()
student_user_75.save()
student_user_76.save()
student_user_77.save()
student_user_78.save()
student_user_79.save()
student_user_80.save()
student_user_81.save()
student_user_82.save()
student_user_83.save()
student_user_84.save()
student_user_85.save()
student_user_86.save()
student_user_87.save()
student_user_88.save()
student_user_89.save()
student_user_90.save()
student_user_91.save()
student_user_92.save()
student_user_93.save()
student_user_94.save()
student_user_95.save()
student_user_96.save()
student_user_97.save()
student_user_98.save()
student_user_99.save()
student_user_100.save()
student_user_101.save()
student_user_102.save()
student_user_103.save()
student_user_104.save()
student_user_105.save()
student_user_106.save()
student_user_107.save()
student_user_108.save()
student_user_109.save()
student_user_110.save()
student_user_111.save()
student_user_112.save()
student_user_113.save()
student_user_114.save()
student_user_115.save()
student_user_116.save()
student_user_117.save()
student_user_118.save()
student_user_119.save()
student_user_120.save()
student_user_121.save()
student_user_122.save()
student_user_123.save()
student_user_124.save()
student_user_125.save()
student_user_126.save()
student_user_127.save()
student_user_128.save()
student_user_129.save()
student_user_130.save()
student_user_131.save()
student_user_132.save()
student_user_133.save()
student_user_134.save()
student_user_135.save()
student_user_136.save()
student_user_137.save()
student_user_138.save()
student_user_139.save()
student_user_140.save()
student_user_141.save()
student_user_142.save()
student_user_143.save()
student_user_144.save()
student_user_145.save()
student_user_146.save()
student_user_147.save()
student_user_148.save()
student_user_149.save()
student_user_150.save()
student_user_151.save()
student_user_152.save()
student_user_153.save()
student_user_154.save()
student_user_155.save()
student_user_156.save()
student_user_157.save()
student_user_158.save()
student_user_159.save()
student_user_160.save()
student_user_161.save()
student_user_162.save()
student_user_163.save()
student_user_164.save()
student_user_165.save()
student_user_166.save()
student_user_167.save()
student_user_168.save()
student_user_169.save()
student_user_170.save()
student_user_171.save()
student_user_172.save()
student_user_173.save()
student_user_174.save()
student_user_175.save()
student_user_176.save()
student_user_177.save()
student_user_178.save()
student_user_179.save()
student_user_180.save()
student_user_181.save()
student_user_182.save()
student_user_183.save()
student_user_184.save()
student_user_185.save()
student_user_186.save()
student_user_187.save()
student_user_188.save()
student_user_189.save()
student_user_190.save()
student_user_191.save()
student_user_192.save()
student_user_193.save()
student_user_194.save()
student_user_195.save()
student_user_196.save()
student_user_197.save()
student_user_198.save()
student_user_199.save()
student_user_200.save()
student_user_201.save()
student_user_202.save()
student_user_203.save()
student_user_204.save()
student_user_205.save()
student_user_206.save()
student_user_207.save()
student_user_208.save()
student_user_209.save()
student_user_210.save()
student_user_211.save()
student_user_212.save()
student_user_213.save()
student_user_214.save()
student_user_215.save()
student_user_216.save()
student_user_217.save()
student_user_218.save()
student_user_219.save()
student_user_220.save()
student_user_221.save()
student_user_222.save()
student_user_223.save()
student_user_224.save()
student_user_225.save()
student_user_226.save()
student_user_227.save()
student_user_228.save()
student_user_229.save()
student_user_230.save()
student_user_231.save()
student_user_232.save()
student_user_233.save()
student_user_234.save()
student_user_235.save()
student_user_236.save()
student_user_237.save()
student_user_238.save()
student_user_239.save()
student_user_240.save()
student_user_241.save()
student_user_242.save()
student_user_243.save()
student_user_244.save()
student_user_245.save()
student_user_246.save()
student_user_247.save()
student_user_248.save()
student_user_249.save()
student_user_250.save()
student_user_251.save()
student_user_252.save()
student_user_253.save()
student_user_254.save()
student_user_255.save()
student_user_256.save()
student_user_257.save()
student_user_258.save()
student_user_259.save()
student_user_260.save()
student_user_261.save()
student_user_262.save()
student_user_263.save()
student_user_264.save()
student_user_265.save()
student_user_266.save()
student_user_267.save()
student_user_268.save()
student_user_269.save()
student_user_270.save()
student_user_271.save()
student_user_272.save()
student_user_273.save()
student_user_274.save()
student_user_275.save()
student_user_276.save()
student_user_277.save()
student_user_278.save()
student_user_279.save()
student_user_280.save()
student_user_281.save()
student_user_282.save()
student_user_283.save()
student_user_284.save()
student_user_285.save()
student_user_286.save()
student_user_287.save()
student_user_288.save()
student_user_289.save()
student_user_290.save()
student_user_291.save()
student_user_292.save()
student_user_293.save()
student_user_294.save()
student_user_295.save()
student_user_296.save()
student_user_297.save()
student_user_298.save()
student_user_299.save()
student_user_300.save()
student_user_301.save()
student_user_302.save()
student_user_303.save()
student_user_304.save()
student_user_305.save()
student_user_306.save()
student_user_307.save()
student_user_308.save()
student_user_309.save()
student_user_310.save()
student_user_311.save()
student_user_312.save()
student_user_313.save()
student_user_314.save()
student_user_315.save()
student_user_316.save()
student_user_317.save()
student_user_318.save()
student_user_319.save()
student_user_320.save()

#<!-- student models -->
student_1 = TrainingStudent(student=student_user_1, student_training_coordinator=coord_3, first_name=student_user_1.first_name, last_name=student_user_1.last_name, matrix_no=student_user_1.identification_num, email=student_user_1.email, phone_number=student_user_1.phone_number, level='300', is_in_school=True)
student_2 = TrainingStudent(student=student_user_2, student_training_coordinator=coord_3, first_name=student_user_2.first_name, last_name=student_user_2.last_name, matrix_no=student_user_2.identification_num, email=student_user_2.email, phone_number=student_user_2.phone_number, is_in_school=True)
student_3 = TrainingStudent(student=student_user_3, student_training_coordinator=coord_3, first_name=student_user_3.first_name, last_name=student_user_3.last_name, matrix_no=student_user_3.identification_num, email=student_user_3.email, phone_number=student_user_3.phone_number, is_in_school=True)
student_4 = TrainingStudent(student=student_user_4, student_training_coordinator=coord_3, first_name=student_user_4.first_name, last_name=student_user_4.last_name, matrix_no=student_user_4.identification_num, email=student_user_4.email, phone_number=student_user_4.phone_number, is_in_school=True)
student_5 = TrainingStudent(student=student_user_5, student_training_coordinator=coord_3, first_name=student_user_5.first_name, last_name=student_user_5.last_name, matrix_no=student_user_5.identification_num, email=student_user_5.email, phone_number=student_user_5.phone_number, is_in_school=True)
student_6 = TrainingStudent(student=student_user_6, student_training_coordinator=coord_17, first_name=student_user_6.first_name, last_name=student_user_6.last_name, matrix_no=student_user_6.identification_num, email=student_user_6.email, phone_number=student_user_6.phone_number, is_in_school=True, level=300)
student_7 = TrainingStudent(student=student_user_7, student_training_coordinator=coord_24, first_name=student_user_7.first_name, last_name=student_user_7.last_name, matrix_no=student_user_7.identification_num, email=student_user_7.email, phone_number=student_user_7.phone_number, is_in_school=True, level=300)
student_8 = TrainingStudent(student=student_user_8, student_training_coordinator=coord_20, first_name=student_user_8.first_name, last_name=student_user_8.last_name, matrix_no=student_user_8.identification_num, email=student_user_8.email, phone_number=student_user_8.phone_number, is_in_school=True, level=200)
student_9 = TrainingStudent(student=student_user_9, student_training_coordinator=coord_3, first_name=student_user_9.first_name, last_name=student_user_9.last_name, matrix_no=student_user_9.identification_num, email=student_user_9.email, phone_number=student_user_9.phone_number, is_in_school=True, level=300)
student_10 = TrainingStudent(student=student_user_10, student_training_coordinator=coord_21, first_name=student_user_10.first_name, last_name=student_user_10.last_name, matrix_no=student_user_10.identification_num, email=student_user_10.email, phone_number=student_user_10.phone_number, is_in_school=True, level=200)
student_11 = TrainingStudent(student=student_user_11, student_training_coordinator=coord_9, first_name=student_user_11.first_name, last_name=student_user_11.last_name, matrix_no=student_user_11.identification_num, email=student_user_11.email, phone_number=student_user_11.phone_number, is_in_school=True, level=300)
student_12 = TrainingStudent(student=student_user_12, student_training_coordinator=coord_31, first_name=student_user_12.first_name, last_name=student_user_12.last_name, matrix_no=student_user_12.identification_num, email=student_user_12.email, phone_number=student_user_12.phone_number, is_in_school=True, level=200)
student_13 = TrainingStudent(student=student_user_13, student_training_coordinator=coord_29, first_name=student_user_13.first_name, last_name=student_user_13.last_name, matrix_no=student_user_13.identification_num, email=student_user_13.email, phone_number=student_user_13.phone_number, is_in_school=True, level=200)
student_14 = TrainingStudent(student=student_user_14, student_training_coordinator=coord_11, first_name=student_user_14.first_name, last_name=student_user_14.last_name, matrix_no=student_user_14.identification_num, email=student_user_14.email, phone_number=student_user_14.phone_number, is_in_school=True, level=300)
student_15 = TrainingStudent(student=student_user_15, student_training_coordinator=coord_9, first_name=student_user_15.first_name, last_name=student_user_15.last_name, matrix_no=student_user_15.identification_num, email=student_user_15.email, phone_number=student_user_15.phone_number, is_in_school=True, level=300)
student_16 = TrainingStudent(student=student_user_16, student_training_coordinator=coord_7, first_name=student_user_16.first_name, last_name=student_user_16.last_name, matrix_no=student_user_16.identification_num, email=student_user_16.email, phone_number=student_user_16.phone_number, is_in_school=True, level=300)
student_17 = TrainingStudent(student=student_user_17, student_training_coordinator=coord_14, first_name=student_user_17.first_name, last_name=student_user_17.last_name, matrix_no=student_user_17.identification_num, email=student_user_17.email, phone_number=student_user_17.phone_number, is_in_school=True, level=300)
student_18 = TrainingStudent(student=student_user_18, student_training_coordinator=coord_30, first_name=student_user_18.first_name, last_name=student_user_18.last_name, matrix_no=student_user_18.identification_num, email=student_user_18.email, phone_number=student_user_18.phone_number, is_in_school=True, level=300)
student_19 = TrainingStudent(student=student_user_19, student_training_coordinator=coord_31, first_name=student_user_19.first_name, last_name=student_user_19.last_name, matrix_no=student_user_19.identification_num, email=student_user_19.email, phone_number=student_user_19.phone_number, is_in_school=True, level=300)
student_20 = TrainingStudent(student=student_user_20, student_training_coordinator=coord_31, first_name=student_user_20.first_name, last_name=student_user_20.last_name, matrix_no=student_user_20.identification_num, email=student_user_20.email, phone_number=student_user_20.phone_number, is_in_school=True, level=300)
student_21 = TrainingStudent(student=student_user_21, student_training_coordinator=coord_29, first_name=student_user_21.first_name, last_name=student_user_21.last_name, matrix_no=student_user_21.identification_num, email=student_user_21.email, phone_number=student_user_21.phone_number, is_in_school=True, level=200)
student_22 = TrainingStudent(student=student_user_22, student_training_coordinator=coord_31, first_name=student_user_22.first_name, last_name=student_user_22.last_name, matrix_no=student_user_22.identification_num, email=student_user_22.email, phone_number=student_user_22.phone_number, is_in_school=True, level=200)
student_23 = TrainingStudent(student=student_user_23, student_training_coordinator=coord_24, first_name=student_user_23.first_name, last_name=student_user_23.last_name, matrix_no=student_user_23.identification_num, email=student_user_23.email, phone_number=student_user_23.phone_number, is_in_school=True, level=200)
student_24 = TrainingStudent(student=student_user_24, student_training_coordinator=coord_14, first_name=student_user_24.first_name, last_name=student_user_24.last_name, matrix_no=student_user_24.identification_num, email=student_user_24.email, phone_number=student_user_24.phone_number, is_in_school=True, level=200)
student_25 = TrainingStudent(student=student_user_25, student_training_coordinator=coord_16, first_name=student_user_25.first_name, last_name=student_user_25.last_name, matrix_no=student_user_25.identification_num, email=student_user_25.email, phone_number=student_user_25.phone_number, is_in_school=True, level=200)
student_26 = TrainingStudent(student=student_user_26, student_training_coordinator=coord_31, first_name=student_user_26.first_name, last_name=student_user_26.last_name, matrix_no=student_user_26.identification_num, email=student_user_26.email, phone_number=student_user_26.phone_number, is_in_school=True, level=300)
student_27 = TrainingStudent(student=student_user_27, student_training_coordinator=coord_21, first_name=student_user_27.first_name, last_name=student_user_27.last_name, matrix_no=student_user_27.identification_num, email=student_user_27.email, phone_number=student_user_27.phone_number, is_in_school=True, level=300)
student_28 = TrainingStudent(student=student_user_28, student_training_coordinator=coord_28, first_name=student_user_28.first_name, last_name=student_user_28.last_name, matrix_no=student_user_28.identification_num, email=student_user_28.email, phone_number=student_user_28.phone_number, is_in_school=True, level=200)
student_29 = TrainingStudent(student=student_user_29, student_training_coordinator=coord_17, first_name=student_user_29.first_name, last_name=student_user_29.last_name, matrix_no=student_user_29.identification_num, email=student_user_29.email, phone_number=student_user_29.phone_number, is_in_school=True, level=300)
student_30 = TrainingStudent(student=student_user_30, student_training_coordinator=coord_32, first_name=student_user_30.first_name, last_name=student_user_30.last_name, matrix_no=student_user_30.identification_num, email=student_user_30.email, phone_number=student_user_30.phone_number, is_in_school=True, level=200)
student_31 = TrainingStudent(student=student_user_31, student_training_coordinator=coord_32, first_name=student_user_31.first_name, last_name=student_user_31.last_name, matrix_no=student_user_31.identification_num, email=student_user_31.email, phone_number=student_user_31.phone_number, is_in_school=True, level=200)
student_32 = TrainingStudent(student=student_user_32, student_training_coordinator=coord_25, first_name=student_user_32.first_name, last_name=student_user_32.last_name, matrix_no=student_user_32.identification_num, email=student_user_32.email, phone_number=student_user_32.phone_number, is_in_school=True, level=300)
student_33 = TrainingStudent(student=student_user_33, student_training_coordinator=coord_31, first_name=student_user_33.first_name, last_name=student_user_33.last_name, matrix_no=student_user_33.identification_num, email=student_user_33.email, phone_number=student_user_33.phone_number, is_in_school=True, level=200)
student_34 = TrainingStudent(student=student_user_34, student_training_coordinator=coord_32, first_name=student_user_34.first_name, last_name=student_user_34.last_name, matrix_no=student_user_34.identification_num, email=student_user_34.email, phone_number=student_user_34.phone_number, is_in_school=True, level=200)
student_35 = TrainingStudent(student=student_user_35, student_training_coordinator=coord_11, first_name=student_user_35.first_name, last_name=student_user_35.last_name, matrix_no=student_user_35.identification_num, email=student_user_35.email, phone_number=student_user_35.phone_number, is_in_school=True, level=200)
student_36 = TrainingStudent(student=student_user_36, student_training_coordinator=coord_30, first_name=student_user_36.first_name, last_name=student_user_36.last_name, matrix_no=student_user_36.identification_num, email=student_user_36.email, phone_number=student_user_36.phone_number, is_in_school=True, level=200)
student_37 = TrainingStudent(student=student_user_37, student_training_coordinator=coord_18, first_name=student_user_37.first_name, last_name=student_user_37.last_name, matrix_no=student_user_37.identification_num, email=student_user_37.email, phone_number=student_user_37.phone_number, is_in_school=True, level=200)
student_38 = TrainingStudent(student=student_user_38, student_training_coordinator=coord_16, first_name=student_user_38.first_name, last_name=student_user_38.last_name, matrix_no=student_user_38.identification_num, email=student_user_38.email, phone_number=student_user_38.phone_number, is_in_school=True, level=300)
student_39 = TrainingStudent(student=student_user_39, student_training_coordinator=coord_7, first_name=student_user_39.first_name, last_name=student_user_39.last_name, matrix_no=student_user_39.identification_num, email=student_user_39.email, phone_number=student_user_39.phone_number, is_in_school=True, level=300)
student_40 = TrainingStudent(student=student_user_40, student_training_coordinator=coord_2, first_name=student_user_40.first_name, last_name=student_user_40.last_name, matrix_no=student_user_40.identification_num, email=student_user_40.email, phone_number=student_user_40.phone_number, is_in_school=True, level=300)
student_41 = TrainingStudent(student=student_user_41, student_training_coordinator=coord_31, first_name=student_user_41.first_name, last_name=student_user_41.last_name, matrix_no=student_user_41.identification_num, email=student_user_41.email, phone_number=student_user_41.phone_number, is_in_school=True, level=300)
student_42 = TrainingStudent(student=student_user_42, student_training_coordinator=coord_27, first_name=student_user_42.first_name, last_name=student_user_42.last_name, matrix_no=student_user_42.identification_num, email=student_user_42.email, phone_number=student_user_42.phone_number, is_in_school=True, level=200)
student_43 = TrainingStudent(student=student_user_43, student_training_coordinator=coord_30, first_name=student_user_43.first_name, last_name=student_user_43.last_name, matrix_no=student_user_43.identification_num, email=student_user_43.email, phone_number=student_user_43.phone_number, is_in_school=True, level=200)
student_44 = TrainingStudent(student=student_user_44, student_training_coordinator=coord_17, first_name=student_user_44.first_name, last_name=student_user_44.last_name, matrix_no=student_user_44.identification_num, email=student_user_44.email, phone_number=student_user_44.phone_number, is_in_school=True, level=200)
student_45 = TrainingStudent(student=student_user_45, student_training_coordinator=coord_12, first_name=student_user_45.first_name, last_name=student_user_45.last_name, matrix_no=student_user_45.identification_num, email=student_user_45.email, phone_number=student_user_45.phone_number, is_in_school=True, level=300)
student_46 = TrainingStudent(student=student_user_46, student_training_coordinator=coord_29, first_name=student_user_46.first_name, last_name=student_user_46.last_name, matrix_no=student_user_46.identification_num, email=student_user_46.email, phone_number=student_user_46.phone_number, is_in_school=True, level=300)
student_47 = TrainingStudent(student=student_user_47, student_training_coordinator=coord_28, first_name=student_user_47.first_name, last_name=student_user_47.last_name, matrix_no=student_user_47.identification_num, email=student_user_47.email, phone_number=student_user_47.phone_number, is_in_school=True, level=200)
student_48 = TrainingStudent(student=student_user_48, student_training_coordinator=coord_14, first_name=student_user_48.first_name, last_name=student_user_48.last_name, matrix_no=student_user_48.identification_num, email=student_user_48.email, phone_number=student_user_48.phone_number, is_in_school=True, level=300)
student_49 = TrainingStudent(student=student_user_49, student_training_coordinator=coord_10, first_name=student_user_49.first_name, last_name=student_user_49.last_name, matrix_no=student_user_49.identification_num, email=student_user_49.email, phone_number=student_user_49.phone_number, is_in_school=True, level=300)
student_50 = TrainingStudent(student=student_user_50, student_training_coordinator=coord_4, first_name=student_user_50.first_name, last_name=student_user_50.last_name, matrix_no=student_user_50.identification_num, email=student_user_50.email, phone_number=student_user_50.phone_number, is_in_school=True, level=200)
student_51 = TrainingStudent(student=student_user_51, student_training_coordinator=coord_32, first_name=student_user_51.first_name, last_name=student_user_51.last_name, matrix_no=student_user_51.identification_num, email=student_user_51.email, phone_number=student_user_51.phone_number, is_in_school=True, level=300)
student_52 = TrainingStudent(student=student_user_52, student_training_coordinator=coord_31, first_name=student_user_52.first_name, last_name=student_user_52.last_name, matrix_no=student_user_52.identification_num, email=student_user_52.email, phone_number=student_user_52.phone_number, is_in_school=True, level=300)
student_53 = TrainingStudent(student=student_user_53, student_training_coordinator=coord_28, first_name=student_user_53.first_name, last_name=student_user_53.last_name, matrix_no=student_user_53.identification_num, email=student_user_53.email, phone_number=student_user_53.phone_number, is_in_school=True, level=200)
student_54 = TrainingStudent(student=student_user_54, student_training_coordinator=coord_15, first_name=student_user_54.first_name, last_name=student_user_54.last_name, matrix_no=student_user_54.identification_num, email=student_user_54.email, phone_number=student_user_54.phone_number, is_in_school=True, level=300)
student_55 = TrainingStudent(student=student_user_55, student_training_coordinator=coord_3, first_name=student_user_55.first_name, last_name=student_user_55.last_name, matrix_no=student_user_55.identification_num, email=student_user_55.email, phone_number=student_user_55.phone_number, is_in_school=True, level=200)
student_56 = TrainingStudent(student=student_user_56, student_training_coordinator=coord_16, first_name=student_user_56.first_name, last_name=student_user_56.last_name, matrix_no=student_user_56.identification_num, email=student_user_56.email, phone_number=student_user_56.phone_number, is_in_school=True, level=200)
student_57 = TrainingStudent(student=student_user_57, student_training_coordinator=coord_8, first_name=student_user_57.first_name, last_name=student_user_57.last_name, matrix_no=student_user_57.identification_num, email=student_user_57.email, phone_number=student_user_57.phone_number, is_in_school=True, level=200)
student_58 = TrainingStudent(student=student_user_58, student_training_coordinator=coord_32, first_name=student_user_58.first_name, last_name=student_user_58.last_name, matrix_no=student_user_58.identification_num, email=student_user_58.email, phone_number=student_user_58.phone_number, is_in_school=True, level=200)
student_59 = TrainingStudent(student=student_user_59, student_training_coordinator=coord_30, first_name=student_user_59.first_name, last_name=student_user_59.last_name, matrix_no=student_user_59.identification_num, email=student_user_59.email, phone_number=student_user_59.phone_number, is_in_school=True, level=300)
student_60 = TrainingStudent(student=student_user_60, student_training_coordinator=coord_8, first_name=student_user_60.first_name, last_name=student_user_60.last_name, matrix_no=student_user_60.identification_num, email=student_user_60.email, phone_number=student_user_60.phone_number, is_in_school=True, level=300)
student_61 = TrainingStudent(student=student_user_61, student_training_coordinator=coord_29, first_name=student_user_61.first_name, last_name=student_user_61.last_name, matrix_no=student_user_61.identification_num, email=student_user_61.email, phone_number=student_user_61.phone_number, is_in_school=True, level=300)
student_62 = TrainingStudent(student=student_user_62, student_training_coordinator=coord_11, first_name=student_user_62.first_name, last_name=student_user_62.last_name, matrix_no=student_user_62.identification_num, email=student_user_62.email, phone_number=student_user_62.phone_number, is_in_school=True, level=200)
student_63 = TrainingStudent(student=student_user_63, student_training_coordinator=coord_8, first_name=student_user_63.first_name, last_name=student_user_63.last_name, matrix_no=student_user_63.identification_num, email=student_user_63.email, phone_number=student_user_63.phone_number, is_in_school=True, level=300)
student_64 = TrainingStudent(student=student_user_64, student_training_coordinator=coord_4, first_name=student_user_64.first_name, last_name=student_user_64.last_name, matrix_no=student_user_64.identification_num, email=student_user_64.email, phone_number=student_user_64.phone_number, is_in_school=True, level=300)
student_65 = TrainingStudent(student=student_user_65, student_training_coordinator=coord_27, first_name=student_user_65.first_name, last_name=student_user_65.last_name, matrix_no=student_user_65.identification_num, email=student_user_65.email, phone_number=student_user_65.phone_number, is_in_school=True, level=300)
student_66 = TrainingStudent(student=student_user_66, student_training_coordinator=coord_5, first_name=student_user_66.first_name, last_name=student_user_66.last_name, matrix_no=student_user_66.identification_num, email=student_user_66.email, phone_number=student_user_66.phone_number, is_in_school=True, level=200)
student_67 = TrainingStudent(student=student_user_67, student_training_coordinator=coord_15, first_name=student_user_67.first_name, last_name=student_user_67.last_name, matrix_no=student_user_67.identification_num, email=student_user_67.email, phone_number=student_user_67.phone_number, is_in_school=True, level=200)
student_68 = TrainingStudent(student=student_user_68, student_training_coordinator=coord_16, first_name=student_user_68.first_name, last_name=student_user_68.last_name, matrix_no=student_user_68.identification_num, email=student_user_68.email, phone_number=student_user_68.phone_number, is_in_school=True, level=200)
student_69 = TrainingStudent(student=student_user_69, student_training_coordinator=coord_29, first_name=student_user_69.first_name, last_name=student_user_69.last_name, matrix_no=student_user_69.identification_num, email=student_user_69.email, phone_number=student_user_69.phone_number, is_in_school=True, level=300)
student_70 = TrainingStudent(student=student_user_70, student_training_coordinator=coord_14, first_name=student_user_70.first_name, last_name=student_user_70.last_name, matrix_no=student_user_70.identification_num, email=student_user_70.email, phone_number=student_user_70.phone_number, is_in_school=True, level=200)
student_71 = TrainingStudent(student=student_user_71, student_training_coordinator=coord_23, first_name=student_user_71.first_name, last_name=student_user_71.last_name, matrix_no=student_user_71.identification_num, email=student_user_71.email, phone_number=student_user_71.phone_number, is_in_school=True, level=300)
student_72 = TrainingStudent(student=student_user_72, student_training_coordinator=coord_30, first_name=student_user_72.first_name, last_name=student_user_72.last_name, matrix_no=student_user_72.identification_num, email=student_user_72.email, phone_number=student_user_72.phone_number, is_in_school=True, level=300)
student_73 = TrainingStudent(student=student_user_73, student_training_coordinator=coord_13, first_name=student_user_73.first_name, last_name=student_user_73.last_name, matrix_no=student_user_73.identification_num, email=student_user_73.email, phone_number=student_user_73.phone_number, is_in_school=True, level=300)
student_74 = TrainingStudent(student=student_user_74, student_training_coordinator=coord_1, first_name=student_user_74.first_name, last_name=student_user_74.last_name, matrix_no=student_user_74.identification_num, email=student_user_74.email, phone_number=student_user_74.phone_number, is_in_school=True, level=200)
student_75 = TrainingStudent(student=student_user_75, student_training_coordinator=coord_32, first_name=student_user_75.first_name, last_name=student_user_75.last_name, matrix_no=student_user_75.identification_num, email=student_user_75.email, phone_number=student_user_75.phone_number, is_in_school=True, level=200)
student_76 = TrainingStudent(student=student_user_76, student_training_coordinator=coord_32, first_name=student_user_76.first_name, last_name=student_user_76.last_name, matrix_no=student_user_76.identification_num, email=student_user_76.email, phone_number=student_user_76.phone_number, is_in_school=True, level=300)
student_77 = TrainingStudent(student=student_user_77, student_training_coordinator=coord_23, first_name=student_user_77.first_name, last_name=student_user_77.last_name, matrix_no=student_user_77.identification_num, email=student_user_77.email, phone_number=student_user_77.phone_number, is_in_school=True, level=200)
student_78 = TrainingStudent(student=student_user_78, student_training_coordinator=coord_32, first_name=student_user_78.first_name, last_name=student_user_78.last_name, matrix_no=student_user_78.identification_num, email=student_user_78.email, phone_number=student_user_78.phone_number, is_in_school=True, level=300)
student_79 = TrainingStudent(student=student_user_79, student_training_coordinator=coord_31, first_name=student_user_79.first_name, last_name=student_user_79.last_name, matrix_no=student_user_79.identification_num, email=student_user_79.email, phone_number=student_user_79.phone_number, is_in_school=True, level=200)
student_80 = TrainingStudent(student=student_user_80, student_training_coordinator=coord_27, first_name=student_user_80.first_name, last_name=student_user_80.last_name, matrix_no=student_user_80.identification_num, email=student_user_80.email, phone_number=student_user_80.phone_number, is_in_school=True, level=200)
student_81 = TrainingStudent(student=student_user_81, student_training_coordinator=coord_5, first_name=student_user_81.first_name, last_name=student_user_81.last_name, matrix_no=student_user_81.identification_num, email=student_user_81.email, phone_number=student_user_81.phone_number, is_in_school=True, level=300)
student_82 = TrainingStudent(student=student_user_82, student_training_coordinator=coord_9, first_name=student_user_82.first_name, last_name=student_user_82.last_name, matrix_no=student_user_82.identification_num, email=student_user_82.email, phone_number=student_user_82.phone_number, is_in_school=True, level=300)
student_83 = TrainingStudent(student=student_user_83, student_training_coordinator=coord_31, first_name=student_user_83.first_name, last_name=student_user_83.last_name, matrix_no=student_user_83.identification_num, email=student_user_83.email, phone_number=student_user_83.phone_number, is_in_school=True, level=300)
student_84 = TrainingStudent(student=student_user_84, student_training_coordinator=coord_10, first_name=student_user_84.first_name, last_name=student_user_84.last_name, matrix_no=student_user_84.identification_num, email=student_user_84.email, phone_number=student_user_84.phone_number, is_in_school=True, level=200)
student_85 = TrainingStudent(student=student_user_85, student_training_coordinator=coord_15, first_name=student_user_85.first_name, last_name=student_user_85.last_name, matrix_no=student_user_85.identification_num, email=student_user_85.email, phone_number=student_user_85.phone_number, is_in_school=True, level=300)
student_86 = TrainingStudent(student=student_user_86, student_training_coordinator=coord_18, first_name=student_user_86.first_name, last_name=student_user_86.last_name, matrix_no=student_user_86.identification_num, email=student_user_86.email, phone_number=student_user_86.phone_number, is_in_school=True, level=300)
student_87 = TrainingStudent(student=student_user_87, student_training_coordinator=coord_31, first_name=student_user_87.first_name, last_name=student_user_87.last_name, matrix_no=student_user_87.identification_num, email=student_user_87.email, phone_number=student_user_87.phone_number, is_in_school=True, level=300)
student_88 = TrainingStudent(student=student_user_88, student_training_coordinator=coord_26, first_name=student_user_88.first_name, last_name=student_user_88.last_name, matrix_no=student_user_88.identification_num, email=student_user_88.email, phone_number=student_user_88.phone_number, is_in_school=True, level=300)
student_89 = TrainingStudent(student=student_user_89, student_training_coordinator=coord_23, first_name=student_user_89.first_name, last_name=student_user_89.last_name, matrix_no=student_user_89.identification_num, email=student_user_89.email, phone_number=student_user_89.phone_number, is_in_school=True, level=200)
student_90 = TrainingStudent(student=student_user_90, student_training_coordinator=coord_32, first_name=student_user_90.first_name, last_name=student_user_90.last_name, matrix_no=student_user_90.identification_num, email=student_user_90.email, phone_number=student_user_90.phone_number, is_in_school=True, level=300)
student_91 = TrainingStudent(student=student_user_91, student_training_coordinator=coord_2, first_name=student_user_91.first_name, last_name=student_user_91.last_name, matrix_no=student_user_91.identification_num, email=student_user_91.email, phone_number=student_user_91.phone_number, is_in_school=True, level=200)
student_92 = TrainingStudent(student=student_user_92, student_training_coordinator=coord_30, first_name=student_user_92.first_name, last_name=student_user_92.last_name, matrix_no=student_user_92.identification_num, email=student_user_92.email, phone_number=student_user_92.phone_number, is_in_school=True, level=300)
student_93 = TrainingStudent(student=student_user_93, student_training_coordinator=coord_12, first_name=student_user_93.first_name, last_name=student_user_93.last_name, matrix_no=student_user_93.identification_num, email=student_user_93.email, phone_number=student_user_93.phone_number, is_in_school=True, level=200)
student_94 = TrainingStudent(student=student_user_94, student_training_coordinator=coord_32, first_name=student_user_94.first_name, last_name=student_user_94.last_name, matrix_no=student_user_94.identification_num, email=student_user_94.email, phone_number=student_user_94.phone_number, is_in_school=True, level=200)
student_95 = TrainingStudent(student=student_user_95, student_training_coordinator=coord_7, first_name=student_user_95.first_name, last_name=student_user_95.last_name, matrix_no=student_user_95.identification_num, email=student_user_95.email, phone_number=student_user_95.phone_number, is_in_school=True, level=300)
student_96 = TrainingStudent(student=student_user_96, student_training_coordinator=coord_32, first_name=student_user_96.first_name, last_name=student_user_96.last_name, matrix_no=student_user_96.identification_num, email=student_user_96.email, phone_number=student_user_96.phone_number, is_in_school=True, level=200)
student_97 = TrainingStudent(student=student_user_97, student_training_coordinator=coord_2, first_name=student_user_97.first_name, last_name=student_user_97.last_name, matrix_no=student_user_97.identification_num, email=student_user_97.email, phone_number=student_user_97.phone_number, is_in_school=True, level=300)
student_98 = TrainingStudent(student=student_user_98, student_training_coordinator=coord_29, first_name=student_user_98.first_name, last_name=student_user_98.last_name, matrix_no=student_user_98.identification_num, email=student_user_98.email, phone_number=student_user_98.phone_number, is_in_school=True, level=200)
student_99 = TrainingStudent(student=student_user_99, student_training_coordinator=coord_3, first_name=student_user_99.first_name, last_name=student_user_99.last_name, matrix_no=student_user_99.identification_num, email=student_user_99.email, phone_number=student_user_99.phone_number, is_in_school=True, level=300)
student_100 = TrainingStudent(student=student_user_100, student_training_coordinator=coord_3, first_name=student_user_100.first_name, last_name=student_user_100.last_name, matrix_no=student_user_100.identification_num, email=student_user_100.email, phone_number=student_user_100.phone_number, is_in_school=True, level=300)
student_101 = TrainingStudent(student=student_user_101, student_training_coordinator=coord_29, first_name=student_user_101.first_name, last_name=student_user_101.last_name, matrix_no=student_user_101.identification_num, email=student_user_101.email, phone_number=student_user_101.phone_number, is_in_school=True, level=200)
student_102 = TrainingStudent(student=student_user_102, student_training_coordinator=coord_16, first_name=student_user_102.first_name, last_name=student_user_102.last_name, matrix_no=student_user_102.identification_num, email=student_user_102.email, phone_number=student_user_102.phone_number, is_in_school=True, level=200)
student_103 = TrainingStudent(student=student_user_103, student_training_coordinator=coord_32, first_name=student_user_103.first_name, last_name=student_user_103.last_name, matrix_no=student_user_103.identification_num, email=student_user_103.email, phone_number=student_user_103.phone_number, is_in_school=True, level=200)
student_104 = TrainingStudent(student=student_user_104, student_training_coordinator=coord_9, first_name=student_user_104.first_name, last_name=student_user_104.last_name, matrix_no=student_user_104.identification_num, email=student_user_104.email, phone_number=student_user_104.phone_number, is_in_school=True, level=200)
student_105 = TrainingStudent(student=student_user_105, student_training_coordinator=coord_3, first_name=student_user_105.first_name, last_name=student_user_105.last_name, matrix_no=student_user_105.identification_num, email=student_user_105.email, phone_number=student_user_105.phone_number, is_in_school=True, level=300)
student_106 = TrainingStudent(student=student_user_106, student_training_coordinator=coord_28, first_name=student_user_106.first_name, last_name=student_user_106.last_name, matrix_no=student_user_106.identification_num, email=student_user_106.email, phone_number=student_user_106.phone_number, is_in_school=True, level=200)
student_107 = TrainingStudent(student=student_user_107, student_training_coordinator=coord_1, first_name=student_user_107.first_name, last_name=student_user_107.last_name, matrix_no=student_user_107.identification_num, email=student_user_107.email, phone_number=student_user_107.phone_number, is_in_school=True, level=200)
student_108 = TrainingStudent(student=student_user_108, student_training_coordinator=coord_3, first_name=student_user_108.first_name, last_name=student_user_108.last_name, matrix_no=student_user_108.identification_num, email=student_user_108.email, phone_number=student_user_108.phone_number, is_in_school=True, level=200)
student_109 = TrainingStudent(student=student_user_109, student_training_coordinator=coord_25, first_name=student_user_109.first_name, last_name=student_user_109.last_name, matrix_no=student_user_109.identification_num, email=student_user_109.email, phone_number=student_user_109.phone_number, is_in_school=True, level=200)
student_110 = TrainingStudent(student=student_user_110, student_training_coordinator=coord_31, first_name=student_user_110.first_name, last_name=student_user_110.last_name, matrix_no=student_user_110.identification_num, email=student_user_110.email, phone_number=student_user_110.phone_number, is_in_school=True, level=300)
student_111 = TrainingStudent(student=student_user_111, student_training_coordinator=coord_6, first_name=student_user_111.first_name, last_name=student_user_111.last_name, matrix_no=student_user_111.identification_num, email=student_user_111.email, phone_number=student_user_111.phone_number, is_in_school=True, level=300)
student_112 = TrainingStudent(student=student_user_112, student_training_coordinator=coord_13, first_name=student_user_112.first_name, last_name=student_user_112.last_name, matrix_no=student_user_112.identification_num, email=student_user_112.email, phone_number=student_user_112.phone_number, is_in_school=True, level=200)
student_113 = TrainingStudent(student=student_user_113, student_training_coordinator=coord_6, first_name=student_user_113.first_name, last_name=student_user_113.last_name, matrix_no=student_user_113.identification_num, email=student_user_113.email, phone_number=student_user_113.phone_number, is_in_school=True, level=200)
student_114 = TrainingStudent(student=student_user_114, student_training_coordinator=coord_17, first_name=student_user_114.first_name, last_name=student_user_114.last_name, matrix_no=student_user_114.identification_num, email=student_user_114.email, phone_number=student_user_114.phone_number, is_in_school=True, level=200)
student_115 = TrainingStudent(student=student_user_115, student_training_coordinator=coord_28, first_name=student_user_115.first_name, last_name=student_user_115.last_name, matrix_no=student_user_115.identification_num, email=student_user_115.email, phone_number=student_user_115.phone_number, is_in_school=True, level=300)
student_116 = TrainingStudent(student=student_user_116, student_training_coordinator=coord_5, first_name=student_user_116.first_name, last_name=student_user_116.last_name, matrix_no=student_user_116.identification_num, email=student_user_116.email, phone_number=student_user_116.phone_number, is_in_school=True, level=200)
student_117 = TrainingStudent(student=student_user_117, student_training_coordinator=coord_14, first_name=student_user_117.first_name, last_name=student_user_117.last_name, matrix_no=student_user_117.identification_num, email=student_user_117.email, phone_number=student_user_117.phone_number, is_in_school=True, level=200)
student_118 = TrainingStudent(student=student_user_118, student_training_coordinator=coord_20, first_name=student_user_118.first_name, last_name=student_user_118.last_name, matrix_no=student_user_118.identification_num, email=student_user_118.email, phone_number=student_user_118.phone_number, is_in_school=True, level=200)
student_119 = TrainingStudent(student=student_user_119, student_training_coordinator=coord_14, first_name=student_user_119.first_name, last_name=student_user_119.last_name, matrix_no=student_user_119.identification_num, email=student_user_119.email, phone_number=student_user_119.phone_number, is_in_school=True, level=300)
student_120 = TrainingStudent(student=student_user_120, student_training_coordinator=coord_30, first_name=student_user_120.first_name, last_name=student_user_120.last_name, matrix_no=student_user_120.identification_num, email=student_user_120.email, phone_number=student_user_120.phone_number, is_in_school=True, level=300)
student_121 = TrainingStudent(student=student_user_121, student_training_coordinator=coord_31, first_name=student_user_121.first_name, last_name=student_user_121.last_name, matrix_no=student_user_121.identification_num, email=student_user_121.email, phone_number=student_user_121.phone_number, is_in_school=True, level=200)
student_122 = TrainingStudent(student=student_user_122, student_training_coordinator=coord_17, first_name=student_user_122.first_name, last_name=student_user_122.last_name, matrix_no=student_user_122.identification_num, email=student_user_122.email, phone_number=student_user_122.phone_number, is_in_school=True, level=200)
student_123 = TrainingStudent(student=student_user_123, student_training_coordinator=coord_16, first_name=student_user_123.first_name, last_name=student_user_123.last_name, matrix_no=student_user_123.identification_num, email=student_user_123.email, phone_number=student_user_123.phone_number, is_in_school=True, level=200)
student_124 = TrainingStudent(student=student_user_124, student_training_coordinator=coord_7, first_name=student_user_124.first_name, last_name=student_user_124.last_name, matrix_no=student_user_124.identification_num, email=student_user_124.email, phone_number=student_user_124.phone_number, is_in_school=True, level=200)
student_125 = TrainingStudent(student=student_user_125, student_training_coordinator=coord_5, first_name=student_user_125.first_name, last_name=student_user_125.last_name, matrix_no=student_user_125.identification_num, email=student_user_125.email, phone_number=student_user_125.phone_number, is_in_school=True, level=300)
student_126 = TrainingStudent(student=student_user_126, student_training_coordinator=coord_15, first_name=student_user_126.first_name, last_name=student_user_126.last_name, matrix_no=student_user_126.identification_num, email=student_user_126.email, phone_number=student_user_126.phone_number, is_in_school=True, level=300)
student_127 = TrainingStudent(student=student_user_127, student_training_coordinator=coord_30, first_name=student_user_127.first_name, last_name=student_user_127.last_name, matrix_no=student_user_127.identification_num, email=student_user_127.email, phone_number=student_user_127.phone_number, is_in_school=True, level=200)
student_128 = TrainingStudent(student=student_user_128, student_training_coordinator=coord_7, first_name=student_user_128.first_name, last_name=student_user_128.last_name, matrix_no=student_user_128.identification_num, email=student_user_128.email, phone_number=student_user_128.phone_number, is_in_school=True, level=300)
student_129 = TrainingStudent(student=student_user_129, student_training_coordinator=coord_31, first_name=student_user_129.first_name, last_name=student_user_129.last_name, matrix_no=student_user_129.identification_num, email=student_user_129.email, phone_number=student_user_129.phone_number, is_in_school=True, level=300)
student_130 = TrainingStudent(student=student_user_130, student_training_coordinator=coord_16, first_name=student_user_130.first_name, last_name=student_user_130.last_name, matrix_no=student_user_130.identification_num, email=student_user_130.email, phone_number=student_user_130.phone_number, is_in_school=True, level=300)
student_131 = TrainingStudent(student=student_user_131, student_training_coordinator=coord_1, first_name=student_user_131.first_name, last_name=student_user_131.last_name, matrix_no=student_user_131.identification_num, email=student_user_131.email, phone_number=student_user_131.phone_number, is_in_school=True, level=300)
student_132 = TrainingStudent(student=student_user_132, student_training_coordinator=coord_24, first_name=student_user_132.first_name, last_name=student_user_132.last_name, matrix_no=student_user_132.identification_num, email=student_user_132.email, phone_number=student_user_132.phone_number, is_in_school=True, level=200)
student_133 = TrainingStudent(student=student_user_133, student_training_coordinator=coord_16, first_name=student_user_133.first_name, last_name=student_user_133.last_name, matrix_no=student_user_133.identification_num, email=student_user_133.email, phone_number=student_user_133.phone_number, is_in_school=True, level=300)
student_134 = TrainingStudent(student=student_user_134, student_training_coordinator=coord_20, first_name=student_user_134.first_name, last_name=student_user_134.last_name, matrix_no=student_user_134.identification_num, email=student_user_134.email, phone_number=student_user_134.phone_number, is_in_school=True, level=200)
student_135 = TrainingStudent(student=student_user_135, student_training_coordinator=coord_32, first_name=student_user_135.first_name, last_name=student_user_135.last_name, matrix_no=student_user_135.identification_num, email=student_user_135.email, phone_number=student_user_135.phone_number, is_in_school=True, level=300)
student_136 = TrainingStudent(student=student_user_136, student_training_coordinator=coord_27, first_name=student_user_136.first_name, last_name=student_user_136.last_name, matrix_no=student_user_136.identification_num, email=student_user_136.email, phone_number=student_user_136.phone_number, is_in_school=True, level=300)
student_137 = TrainingStudent(student=student_user_137, student_training_coordinator=coord_6, first_name=student_user_137.first_name, last_name=student_user_137.last_name, matrix_no=student_user_137.identification_num, email=student_user_137.email, phone_number=student_user_137.phone_number, is_in_school=True, level=300)
student_138 = TrainingStudent(student=student_user_138, student_training_coordinator=coord_30, first_name=student_user_138.first_name, last_name=student_user_138.last_name, matrix_no=student_user_138.identification_num, email=student_user_138.email, phone_number=student_user_138.phone_number, is_in_school=True, level=200)
student_139 = TrainingStudent(student=student_user_139, student_training_coordinator=coord_22, first_name=student_user_139.first_name, last_name=student_user_139.last_name, matrix_no=student_user_139.identification_num, email=student_user_139.email, phone_number=student_user_139.phone_number, is_in_school=True, level=200)
student_140 = TrainingStudent(student=student_user_140, student_training_coordinator=coord_15, first_name=student_user_140.first_name, last_name=student_user_140.last_name, matrix_no=student_user_140.identification_num, email=student_user_140.email, phone_number=student_user_140.phone_number, is_in_school=True, level=200)
student_141 = TrainingStudent(student=student_user_141, student_training_coordinator=coord_24, first_name=student_user_141.first_name, last_name=student_user_141.last_name, matrix_no=student_user_141.identification_num, email=student_user_141.email, phone_number=student_user_141.phone_number, is_in_school=True, level=300)
student_142 = TrainingStudent(student=student_user_142, student_training_coordinator=coord_15, first_name=student_user_142.first_name, last_name=student_user_142.last_name, matrix_no=student_user_142.identification_num, email=student_user_142.email, phone_number=student_user_142.phone_number, is_in_school=True, level=200)
student_143 = TrainingStudent(student=student_user_143, student_training_coordinator=coord_23, first_name=student_user_143.first_name, last_name=student_user_143.last_name, matrix_no=student_user_143.identification_num, email=student_user_143.email, phone_number=student_user_143.phone_number, is_in_school=True, level=300)
student_144 = TrainingStudent(student=student_user_144, student_training_coordinator=coord_12, first_name=student_user_144.first_name, last_name=student_user_144.last_name, matrix_no=student_user_144.identification_num, email=student_user_144.email, phone_number=student_user_144.phone_number, is_in_school=True, level=200)
student_145 = TrainingStudent(student=student_user_145, student_training_coordinator=coord_3, first_name=student_user_145.first_name, last_name=student_user_145.last_name, matrix_no=student_user_145.identification_num, email=student_user_145.email, phone_number=student_user_145.phone_number, is_in_school=True, level=300)
student_146 = TrainingStudent(student=student_user_146, student_training_coordinator=coord_30, first_name=student_user_146.first_name, last_name=student_user_146.last_name, matrix_no=student_user_146.identification_num, email=student_user_146.email, phone_number=student_user_146.phone_number, is_in_school=True, level=300)
student_147 = TrainingStudent(student=student_user_147, student_training_coordinator=coord_32, first_name=student_user_147.first_name, last_name=student_user_147.last_name, matrix_no=student_user_147.identification_num, email=student_user_147.email, phone_number=student_user_147.phone_number, is_in_school=True, level=300)
student_148 = TrainingStudent(student=student_user_148, student_training_coordinator=coord_2, first_name=student_user_148.first_name, last_name=student_user_148.last_name, matrix_no=student_user_148.identification_num, email=student_user_148.email, phone_number=student_user_148.phone_number, is_in_school=True, level=200)
student_149 = TrainingStudent(student=student_user_149, student_training_coordinator=coord_18, first_name=student_user_149.first_name, last_name=student_user_149.last_name, matrix_no=student_user_149.identification_num, email=student_user_149.email, phone_number=student_user_149.phone_number, is_in_school=True, level=300)
student_150 = TrainingStudent(student=student_user_150, student_training_coordinator=coord_2, first_name=student_user_150.first_name, last_name=student_user_150.last_name, matrix_no=student_user_150.identification_num, email=student_user_150.email, phone_number=student_user_150.phone_number, is_in_school=True, level=200)
student_151 = TrainingStudent(student=student_user_151, student_training_coordinator=coord_14, first_name=student_user_151.first_name, last_name=student_user_151.last_name, matrix_no=student_user_151.identification_num, email=student_user_151.email, phone_number=student_user_151.phone_number, is_in_school=True, level=200)
student_152 = TrainingStudent(student=student_user_152, student_training_coordinator=coord_32, first_name=student_user_152.first_name, last_name=student_user_152.last_name, matrix_no=student_user_152.identification_num, email=student_user_152.email, phone_number=student_user_152.phone_number, is_in_school=True, level=300)
student_153 = TrainingStudent(student=student_user_153, student_training_coordinator=coord_4, first_name=student_user_153.first_name, last_name=student_user_153.last_name, matrix_no=student_user_153.identification_num, email=student_user_153.email, phone_number=student_user_153.phone_number, is_in_school=True, level=300)
student_154 = TrainingStudent(student=student_user_154, student_training_coordinator=coord_6, first_name=student_user_154.first_name, last_name=student_user_154.last_name, matrix_no=student_user_154.identification_num, email=student_user_154.email, phone_number=student_user_154.phone_number, is_in_school=True, level=200)
student_155 = TrainingStudent(student=student_user_155, student_training_coordinator=coord_2, first_name=student_user_155.first_name, last_name=student_user_155.last_name, matrix_no=student_user_155.identification_num, email=student_user_155.email, phone_number=student_user_155.phone_number, is_in_school=True, level=300)
student_156 = TrainingStudent(student=student_user_156, student_training_coordinator=coord_31, first_name=student_user_156.first_name, last_name=student_user_156.last_name, matrix_no=student_user_156.identification_num, email=student_user_156.email, phone_number=student_user_156.phone_number, is_in_school=True, level=300)
student_157 = TrainingStudent(student=student_user_157, student_training_coordinator=coord_12, first_name=student_user_157.first_name, last_name=student_user_157.last_name, matrix_no=student_user_157.identification_num, email=student_user_157.email, phone_number=student_user_157.phone_number, is_in_school=True, level=300)
student_158 = TrainingStudent(student=student_user_158, student_training_coordinator=coord_31, first_name=student_user_158.first_name, last_name=student_user_158.last_name, matrix_no=student_user_158.identification_num, email=student_user_158.email, phone_number=student_user_158.phone_number, is_in_school=True, level=200)
student_159 = TrainingStudent(student=student_user_159, student_training_coordinator=coord_27, first_name=student_user_159.first_name, last_name=student_user_159.last_name, matrix_no=student_user_159.identification_num, email=student_user_159.email, phone_number=student_user_159.phone_number, is_in_school=True, level=300)
student_160 = TrainingStudent(student=student_user_160, student_training_coordinator=coord_10, first_name=student_user_160.first_name, last_name=student_user_160.last_name, matrix_no=student_user_160.identification_num, email=student_user_160.email, phone_number=student_user_160.phone_number, is_in_school=True, level=200)
student_161 = TrainingStudent(student=student_user_161, student_training_coordinator=coord_2, first_name=student_user_161.first_name, last_name=student_user_161.last_name, matrix_no=student_user_161.identification_num, email=student_user_161.email, phone_number=student_user_161.phone_number, is_in_school=True, level=200)
student_162 = TrainingStudent(student=student_user_162, student_training_coordinator=coord_27, first_name=student_user_162.first_name, last_name=student_user_162.last_name, matrix_no=student_user_162.identification_num, email=student_user_162.email, phone_number=student_user_162.phone_number, is_in_school=True, level=300)
student_163 = TrainingStudent(student=student_user_163, student_training_coordinator=coord_14, first_name=student_user_163.first_name, last_name=student_user_163.last_name, matrix_no=student_user_163.identification_num, email=student_user_163.email, phone_number=student_user_163.phone_number, is_in_school=True, level=200)
student_164 = TrainingStudent(student=student_user_164, student_training_coordinator=coord_13, first_name=student_user_164.first_name, last_name=student_user_164.last_name, matrix_no=student_user_164.identification_num, email=student_user_164.email, phone_number=student_user_164.phone_number, is_in_school=True, level=200)
student_165 = TrainingStudent(student=student_user_165, student_training_coordinator=coord_30, first_name=student_user_165.first_name, last_name=student_user_165.last_name, matrix_no=student_user_165.identification_num, email=student_user_165.email, phone_number=student_user_165.phone_number, is_in_school=True, level=300)
student_166 = TrainingStudent(student=student_user_166, student_training_coordinator=coord_7, first_name=student_user_166.first_name, last_name=student_user_166.last_name, matrix_no=student_user_166.identification_num, email=student_user_166.email, phone_number=student_user_166.phone_number, is_in_school=True, level=300)
student_167 = TrainingStudent(student=student_user_167, student_training_coordinator=coord_3, first_name=student_user_167.first_name, last_name=student_user_167.last_name, matrix_no=student_user_167.identification_num, email=student_user_167.email, phone_number=student_user_167.phone_number, is_in_school=True, level=300)
student_168 = TrainingStudent(student=student_user_168, student_training_coordinator=coord_2, first_name=student_user_168.first_name, last_name=student_user_168.last_name, matrix_no=student_user_168.identification_num, email=student_user_168.email, phone_number=student_user_168.phone_number, is_in_school=True, level=200)
student_169 = TrainingStudent(student=student_user_169, student_training_coordinator=coord_19, first_name=student_user_169.first_name, last_name=student_user_169.last_name, matrix_no=student_user_169.identification_num, email=student_user_169.email, phone_number=student_user_169.phone_number, is_in_school=True, level=200)
student_170 = TrainingStudent(student=student_user_170, student_training_coordinator=coord_32, first_name=student_user_170.first_name, last_name=student_user_170.last_name, matrix_no=student_user_170.identification_num, email=student_user_170.email, phone_number=student_user_170.phone_number, is_in_school=True, level=200)
student_171 = TrainingStudent(student=student_user_171, student_training_coordinator=coord_22, first_name=student_user_171.first_name, last_name=student_user_171.last_name, matrix_no=student_user_171.identification_num, email=student_user_171.email, phone_number=student_user_171.phone_number, is_in_school=True, level=200)
student_172 = TrainingStudent(student=student_user_172, student_training_coordinator=coord_20, first_name=student_user_172.first_name, last_name=student_user_172.last_name, matrix_no=student_user_172.identification_num, email=student_user_172.email, phone_number=student_user_172.phone_number, is_in_school=True, level=200)
student_173 = TrainingStudent(student=student_user_173, student_training_coordinator=coord_2, first_name=student_user_173.first_name, last_name=student_user_173.last_name, matrix_no=student_user_173.identification_num, email=student_user_173.email, phone_number=student_user_173.phone_number, is_in_school=True, level=300)
student_174 = TrainingStudent(student=student_user_174, student_training_coordinator=coord_25, first_name=student_user_174.first_name, last_name=student_user_174.last_name, matrix_no=student_user_174.identification_num, email=student_user_174.email, phone_number=student_user_174.phone_number, is_in_school=True, level=200)
student_175 = TrainingStudent(student=student_user_175, student_training_coordinator=coord_9, first_name=student_user_175.first_name, last_name=student_user_175.last_name, matrix_no=student_user_175.identification_num, email=student_user_175.email, phone_number=student_user_175.phone_number, is_in_school=True, level=300)
student_176 = TrainingStudent(student=student_user_176, student_training_coordinator=coord_8, first_name=student_user_176.first_name, last_name=student_user_176.last_name, matrix_no=student_user_176.identification_num, email=student_user_176.email, phone_number=student_user_176.phone_number, is_in_school=True, level=300)
student_177 = TrainingStudent(student=student_user_177, student_training_coordinator=coord_30, first_name=student_user_177.first_name, last_name=student_user_177.last_name, matrix_no=student_user_177.identification_num, email=student_user_177.email, phone_number=student_user_177.phone_number, is_in_school=True, level=200)
student_178 = TrainingStudent(student=student_user_178, student_training_coordinator=coord_17, first_name=student_user_178.first_name, last_name=student_user_178.last_name, matrix_no=student_user_178.identification_num, email=student_user_178.email, phone_number=student_user_178.phone_number, is_in_school=True, level=200)
student_179 = TrainingStudent(student=student_user_179, student_training_coordinator=coord_10, first_name=student_user_179.first_name, last_name=student_user_179.last_name, matrix_no=student_user_179.identification_num, email=student_user_179.email, phone_number=student_user_179.phone_number, is_in_school=True, level=300)
student_180 = TrainingStudent(student=student_user_180, student_training_coordinator=coord_23, first_name=student_user_180.first_name, last_name=student_user_180.last_name, matrix_no=student_user_180.identification_num, email=student_user_180.email, phone_number=student_user_180.phone_number, is_in_school=True, level=300)
student_181 = TrainingStudent(student=student_user_181, student_training_coordinator=coord_32, first_name=student_user_181.first_name, last_name=student_user_181.last_name, matrix_no=student_user_181.identification_num, email=student_user_181.email, phone_number=student_user_181.phone_number, is_in_school=True, level=300)
student_182 = TrainingStudent(student=student_user_182, student_training_coordinator=coord_15, first_name=student_user_182.first_name, last_name=student_user_182.last_name, matrix_no=student_user_182.identification_num, email=student_user_182.email, phone_number=student_user_182.phone_number, is_in_school=True, level=200)
student_183 = TrainingStudent(student=student_user_183, student_training_coordinator=coord_32, first_name=student_user_183.first_name, last_name=student_user_183.last_name, matrix_no=student_user_183.identification_num, email=student_user_183.email, phone_number=student_user_183.phone_number, is_in_school=True, level=300)
student_184 = TrainingStudent(student=student_user_184, student_training_coordinator=coord_7, first_name=student_user_184.first_name, last_name=student_user_184.last_name, matrix_no=student_user_184.identification_num, email=student_user_184.email, phone_number=student_user_184.phone_number, is_in_school=True, level=300)
student_185 = TrainingStudent(student=student_user_185, student_training_coordinator=coord_32, first_name=student_user_185.first_name, last_name=student_user_185.last_name, matrix_no=student_user_185.identification_num, email=student_user_185.email, phone_number=student_user_185.phone_number, is_in_school=True, level=200)
student_186 = TrainingStudent(student=student_user_186, student_training_coordinator=coord_16, first_name=student_user_186.first_name, last_name=student_user_186.last_name, matrix_no=student_user_186.identification_num, email=student_user_186.email, phone_number=student_user_186.phone_number, is_in_school=True, level=200)
student_187 = TrainingStudent(student=student_user_187, student_training_coordinator=coord_8, first_name=student_user_187.first_name, last_name=student_user_187.last_name, matrix_no=student_user_187.identification_num, email=student_user_187.email, phone_number=student_user_187.phone_number, is_in_school=True, level=200)
student_188 = TrainingStudent(student=student_user_188, student_training_coordinator=coord_27, first_name=student_user_188.first_name, last_name=student_user_188.last_name, matrix_no=student_user_188.identification_num, email=student_user_188.email, phone_number=student_user_188.phone_number, is_in_school=True, level=300)
student_189 = TrainingStudent(student=student_user_189, student_training_coordinator=coord_21, first_name=student_user_189.first_name, last_name=student_user_189.last_name, matrix_no=student_user_189.identification_num, email=student_user_189.email, phone_number=student_user_189.phone_number, is_in_school=True, level=300)
student_190 = TrainingStudent(student=student_user_190, student_training_coordinator=coord_15, first_name=student_user_190.first_name, last_name=student_user_190.last_name, matrix_no=student_user_190.identification_num, email=student_user_190.email, phone_number=student_user_190.phone_number, is_in_school=True, level=200)
student_191 = TrainingStudent(student=student_user_191, student_training_coordinator=coord_16, first_name=student_user_191.first_name, last_name=student_user_191.last_name, matrix_no=student_user_191.identification_num, email=student_user_191.email, phone_number=student_user_191.phone_number, is_in_school=True, level=200)
student_192 = TrainingStudent(student=student_user_192, student_training_coordinator=coord_26, first_name=student_user_192.first_name, last_name=student_user_192.last_name, matrix_no=student_user_192.identification_num, email=student_user_192.email, phone_number=student_user_192.phone_number, is_in_school=True, level=300)
student_193 = TrainingStudent(student=student_user_193, student_training_coordinator=coord_18, first_name=student_user_193.first_name, last_name=student_user_193.last_name, matrix_no=student_user_193.identification_num, email=student_user_193.email, phone_number=student_user_193.phone_number, is_in_school=True, level=300)
student_194 = TrainingStudent(student=student_user_194, student_training_coordinator=coord_31, first_name=student_user_194.first_name, last_name=student_user_194.last_name, matrix_no=student_user_194.identification_num, email=student_user_194.email, phone_number=student_user_194.phone_number, is_in_school=True, level=200)
student_195 = TrainingStudent(student=student_user_195, student_training_coordinator=coord_26, first_name=student_user_195.first_name, last_name=student_user_195.last_name, matrix_no=student_user_195.identification_num, email=student_user_195.email, phone_number=student_user_195.phone_number, is_in_school=True, level=300)
student_196 = TrainingStudent(student=student_user_196, student_training_coordinator=coord_18, first_name=student_user_196.first_name, last_name=student_user_196.last_name, matrix_no=student_user_196.identification_num, email=student_user_196.email, phone_number=student_user_196.phone_number, is_in_school=True, level=200)
student_197 = TrainingStudent(student=student_user_197, student_training_coordinator=coord_21, first_name=student_user_197.first_name, last_name=student_user_197.last_name, matrix_no=student_user_197.identification_num, email=student_user_197.email, phone_number=student_user_197.phone_number, is_in_school=True, level=200)
student_198 = TrainingStudent(student=student_user_198, student_training_coordinator=coord_19, first_name=student_user_198.first_name, last_name=student_user_198.last_name, matrix_no=student_user_198.identification_num, email=student_user_198.email, phone_number=student_user_198.phone_number, is_in_school=True, level=200)
student_199 = TrainingStudent(student=student_user_199, student_training_coordinator=coord_20, first_name=student_user_199.first_name, last_name=student_user_199.last_name, matrix_no=student_user_199.identification_num, email=student_user_199.email, phone_number=student_user_199.phone_number, is_in_school=True, level=300)
student_200 = TrainingStudent(student=student_user_200, student_training_coordinator=coord_26, first_name=student_user_200.first_name, last_name=student_user_200.last_name, matrix_no=student_user_200.identification_num, email=student_user_200.email, phone_number=student_user_200.phone_number, is_in_school=True, level=300)
student_201 = TrainingStudent(student=student_user_201, student_training_coordinator=coord_11, first_name=student_user_201.first_name, last_name=student_user_201.last_name, matrix_no=student_user_201.identification_num, email=student_user_201.email, phone_number=student_user_201.phone_number, is_in_school=True, level=300)
student_202 = TrainingStudent(student=student_user_202, student_training_coordinator=coord_31, first_name=student_user_202.first_name, last_name=student_user_202.last_name, matrix_no=student_user_202.identification_num, email=student_user_202.email, phone_number=student_user_202.phone_number, is_in_school=True, level=200)
student_203 = TrainingStudent(student=student_user_203, student_training_coordinator=coord_14, first_name=student_user_203.first_name, last_name=student_user_203.last_name, matrix_no=student_user_203.identification_num, email=student_user_203.email, phone_number=student_user_203.phone_number, is_in_school=True, level=200)
student_204 = TrainingStudent(student=student_user_204, student_training_coordinator=coord_11, first_name=student_user_204.first_name, last_name=student_user_204.last_name, matrix_no=student_user_204.identification_num, email=student_user_204.email, phone_number=student_user_204.phone_number, is_in_school=True, level=200)
student_205 = TrainingStudent(student=student_user_205, student_training_coordinator=coord_13, first_name=student_user_205.first_name, last_name=student_user_205.last_name, matrix_no=student_user_205.identification_num, email=student_user_205.email, phone_number=student_user_205.phone_number, is_in_school=True, level=200)
student_206 = TrainingStudent(student=student_user_206, student_training_coordinator=coord_29, first_name=student_user_206.first_name, last_name=student_user_206.last_name, matrix_no=student_user_206.identification_num, email=student_user_206.email, phone_number=student_user_206.phone_number, is_in_school=True, level=200)
student_207 = TrainingStudent(student=student_user_207, student_training_coordinator=coord_25, first_name=student_user_207.first_name, last_name=student_user_207.last_name, matrix_no=student_user_207.identification_num, email=student_user_207.email, phone_number=student_user_207.phone_number, is_in_school=True, level=200)
student_208 = TrainingStudent(student=student_user_208, student_training_coordinator=coord_12, first_name=student_user_208.first_name, last_name=student_user_208.last_name, matrix_no=student_user_208.identification_num, email=student_user_208.email, phone_number=student_user_208.phone_number, is_in_school=True, level=200)
student_209 = TrainingStudent(student=student_user_209, student_training_coordinator=coord_5, first_name=student_user_209.first_name, last_name=student_user_209.last_name, matrix_no=student_user_209.identification_num, email=student_user_209.email, phone_number=student_user_209.phone_number, is_in_school=True, level=300)
student_210 = TrainingStudent(student=student_user_210, student_training_coordinator=coord_32, first_name=student_user_210.first_name, last_name=student_user_210.last_name, matrix_no=student_user_210.identification_num, email=student_user_210.email, phone_number=student_user_210.phone_number, is_in_school=True, level=300)
student_211 = TrainingStudent(student=student_user_211, student_training_coordinator=coord_28, first_name=student_user_211.first_name, last_name=student_user_211.last_name, matrix_no=student_user_211.identification_num, email=student_user_211.email, phone_number=student_user_211.phone_number, is_in_school=True, level=300)
student_212 = TrainingStudent(student=student_user_212, student_training_coordinator=coord_12, first_name=student_user_212.first_name, last_name=student_user_212.last_name, matrix_no=student_user_212.identification_num, email=student_user_212.email, phone_number=student_user_212.phone_number, is_in_school=True, level=300)
student_213 = TrainingStudent(student=student_user_213, student_training_coordinator=coord_19, first_name=student_user_213.first_name, last_name=student_user_213.last_name, matrix_no=student_user_213.identification_num, email=student_user_213.email, phone_number=student_user_213.phone_number, is_in_school=True, level=300)
student_214 = TrainingStudent(student=student_user_214, student_training_coordinator=coord_24, first_name=student_user_214.first_name, last_name=student_user_214.last_name, matrix_no=student_user_214.identification_num, email=student_user_214.email, phone_number=student_user_214.phone_number, is_in_school=True, level=200)
student_215 = TrainingStudent(student=student_user_215, student_training_coordinator=coord_17, first_name=student_user_215.first_name, last_name=student_user_215.last_name, matrix_no=student_user_215.identification_num, email=student_user_215.email, phone_number=student_user_215.phone_number, is_in_school=True, level=300)
student_216 = TrainingStudent(student=student_user_216, student_training_coordinator=coord_21, first_name=student_user_216.first_name, last_name=student_user_216.last_name, matrix_no=student_user_216.identification_num, email=student_user_216.email, phone_number=student_user_216.phone_number, is_in_school=True, level=200)
student_217 = TrainingStudent(student=student_user_217, student_training_coordinator=coord_3, first_name=student_user_217.first_name, last_name=student_user_217.last_name, matrix_no=student_user_217.identification_num, email=student_user_217.email, phone_number=student_user_217.phone_number, is_in_school=True, level=300)
student_218 = TrainingStudent(student=student_user_218, student_training_coordinator=coord_7, first_name=student_user_218.first_name, last_name=student_user_218.last_name, matrix_no=student_user_218.identification_num, email=student_user_218.email, phone_number=student_user_218.phone_number, is_in_school=True, level=300)
student_219 = TrainingStudent(student=student_user_219, student_training_coordinator=coord_2, first_name=student_user_219.first_name, last_name=student_user_219.last_name, matrix_no=student_user_219.identification_num, email=student_user_219.email, phone_number=student_user_219.phone_number, is_in_school=True, level=300)
student_220 = TrainingStudent(student=student_user_220, student_training_coordinator=coord_4, first_name=student_user_220.first_name, last_name=student_user_220.last_name, matrix_no=student_user_220.identification_num, email=student_user_220.email, phone_number=student_user_220.phone_number, is_in_school=True, level=300)
student_221 = TrainingStudent(student=student_user_221, student_training_coordinator=coord_9, first_name=student_user_221.first_name, last_name=student_user_221.last_name, matrix_no=student_user_221.identification_num, email=student_user_221.email, phone_number=student_user_221.phone_number, is_in_school=True, level=200)
student_222 = TrainingStudent(student=student_user_222, student_training_coordinator=coord_4, first_name=student_user_222.first_name, last_name=student_user_222.last_name, matrix_no=student_user_222.identification_num, email=student_user_222.email, phone_number=student_user_222.phone_number, is_in_school=True, level=300)
student_223 = TrainingStudent(student=student_user_223, student_training_coordinator=coord_24, first_name=student_user_223.first_name, last_name=student_user_223.last_name, matrix_no=student_user_223.identification_num, email=student_user_223.email, phone_number=student_user_223.phone_number, is_in_school=True, level=300)
student_224 = TrainingStudent(student=student_user_224, student_training_coordinator=coord_27, first_name=student_user_224.first_name, last_name=student_user_224.last_name, matrix_no=student_user_224.identification_num, email=student_user_224.email, phone_number=student_user_224.phone_number, is_in_school=True, level=300)
student_225 = TrainingStudent(student=student_user_225, student_training_coordinator=coord_8, first_name=student_user_225.first_name, last_name=student_user_225.last_name, matrix_no=student_user_225.identification_num, email=student_user_225.email, phone_number=student_user_225.phone_number, is_in_school=True, level=300)
student_226 = TrainingStudent(student=student_user_226, student_training_coordinator=coord_16, first_name=student_user_226.first_name, last_name=student_user_226.last_name, matrix_no=student_user_226.identification_num, email=student_user_226.email, phone_number=student_user_226.phone_number, is_in_school=True, level=200)
student_227 = TrainingStudent(student=student_user_227, student_training_coordinator=coord_1, first_name=student_user_227.first_name, last_name=student_user_227.last_name, matrix_no=student_user_227.identification_num, email=student_user_227.email, phone_number=student_user_227.phone_number, is_in_school=True, level=300)
student_228 = TrainingStudent(student=student_user_228, student_training_coordinator=coord_32, first_name=student_user_228.first_name, last_name=student_user_228.last_name, matrix_no=student_user_228.identification_num, email=student_user_228.email, phone_number=student_user_228.phone_number, is_in_school=True, level=300)
student_229 = TrainingStudent(student=student_user_229, student_training_coordinator=coord_3, first_name=student_user_229.first_name, last_name=student_user_229.last_name, matrix_no=student_user_229.identification_num, email=student_user_229.email, phone_number=student_user_229.phone_number, is_in_school=True, level=200)
student_230 = TrainingStudent(student=student_user_230, student_training_coordinator=coord_15, first_name=student_user_230.first_name, last_name=student_user_230.last_name, matrix_no=student_user_230.identification_num, email=student_user_230.email, phone_number=student_user_230.phone_number, is_in_school=True, level=200)
student_231 = TrainingStudent(student=student_user_231, student_training_coordinator=coord_11, first_name=student_user_231.first_name, last_name=student_user_231.last_name, matrix_no=student_user_231.identification_num, email=student_user_231.email, phone_number=student_user_231.phone_number, is_in_school=True, level=300)
student_232 = TrainingStudent(student=student_user_232, student_training_coordinator=coord_7, first_name=student_user_232.first_name, last_name=student_user_232.last_name, matrix_no=student_user_232.identification_num, email=student_user_232.email, phone_number=student_user_232.phone_number, is_in_school=True, level=200)
student_233 = TrainingStudent(student=student_user_233, student_training_coordinator=coord_18, first_name=student_user_233.first_name, last_name=student_user_233.last_name, matrix_no=student_user_233.identification_num, email=student_user_233.email, phone_number=student_user_233.phone_number, is_in_school=True, level=300)
student_234 = TrainingStudent(student=student_user_234, student_training_coordinator=coord_3, first_name=student_user_234.first_name, last_name=student_user_234.last_name, matrix_no=student_user_234.identification_num, email=student_user_234.email, phone_number=student_user_234.phone_number, is_in_school=True, level=200)
student_235 = TrainingStudent(student=student_user_235, student_training_coordinator=coord_26, first_name=student_user_235.first_name, last_name=student_user_235.last_name, matrix_no=student_user_235.identification_num, email=student_user_235.email, phone_number=student_user_235.phone_number, is_in_school=True, level=200)
student_236 = TrainingStudent(student=student_user_236, student_training_coordinator=coord_25, first_name=student_user_236.first_name, last_name=student_user_236.last_name, matrix_no=student_user_236.identification_num, email=student_user_236.email, phone_number=student_user_236.phone_number, is_in_school=True, level=300)
student_237 = TrainingStudent(student=student_user_237, student_training_coordinator=coord_31, first_name=student_user_237.first_name, last_name=student_user_237.last_name, matrix_no=student_user_237.identification_num, email=student_user_237.email, phone_number=student_user_237.phone_number, is_in_school=True, level=200)
student_238 = TrainingStudent(student=student_user_238, student_training_coordinator=coord_4, first_name=student_user_238.first_name, last_name=student_user_238.last_name, matrix_no=student_user_238.identification_num, email=student_user_238.email, phone_number=student_user_238.phone_number, is_in_school=True, level=200)
student_239 = TrainingStudent(student=student_user_239, student_training_coordinator=coord_23, first_name=student_user_239.first_name, last_name=student_user_239.last_name, matrix_no=student_user_239.identification_num, email=student_user_239.email, phone_number=student_user_239.phone_number, is_in_school=True, level=300)
student_240 = TrainingStudent(student=student_user_240, student_training_coordinator=coord_15, first_name=student_user_240.first_name, last_name=student_user_240.last_name, matrix_no=student_user_240.identification_num, email=student_user_240.email, phone_number=student_user_240.phone_number, is_in_school=True, level=300)
student_241 = TrainingStudent(student=student_user_241, student_training_coordinator=coord_7, first_name=student_user_241.first_name, last_name=student_user_241.last_name, matrix_no=student_user_241.identification_num, email=student_user_241.email, phone_number=student_user_241.phone_number, is_in_school=True, level=300)
student_242 = TrainingStudent(student=student_user_242, student_training_coordinator=coord_32, first_name=student_user_242.first_name, last_name=student_user_242.last_name, matrix_no=student_user_242.identification_num, email=student_user_242.email, phone_number=student_user_242.phone_number, is_in_school=True, level=200)
student_243 = TrainingStudent(student=student_user_243, student_training_coordinator=coord_29, first_name=student_user_243.first_name, last_name=student_user_243.last_name, matrix_no=student_user_243.identification_num, email=student_user_243.email, phone_number=student_user_243.phone_number, is_in_school=True, level=200)
student_244 = TrainingStudent(student=student_user_244, student_training_coordinator=coord_21, first_name=student_user_244.first_name, last_name=student_user_244.last_name, matrix_no=student_user_244.identification_num, email=student_user_244.email, phone_number=student_user_244.phone_number, is_in_school=True, level=200)
student_245 = TrainingStudent(student=student_user_245, student_training_coordinator=coord_30, first_name=student_user_245.first_name, last_name=student_user_245.last_name, matrix_no=student_user_245.identification_num, email=student_user_245.email, phone_number=student_user_245.phone_number, is_in_school=True, level=200)
student_246 = TrainingStudent(student=student_user_246, student_training_coordinator=coord_13, first_name=student_user_246.first_name, last_name=student_user_246.last_name, matrix_no=student_user_246.identification_num, email=student_user_246.email, phone_number=student_user_246.phone_number, is_in_school=True, level=200)
student_247 = TrainingStudent(student=student_user_247, student_training_coordinator=coord_31, first_name=student_user_247.first_name, last_name=student_user_247.last_name, matrix_no=student_user_247.identification_num, email=student_user_247.email, phone_number=student_user_247.phone_number, is_in_school=True, level=300)
student_248 = TrainingStudent(student=student_user_248, student_training_coordinator=coord_22, first_name=student_user_248.first_name, last_name=student_user_248.last_name, matrix_no=student_user_248.identification_num, email=student_user_248.email, phone_number=student_user_248.phone_number, is_in_school=True, level=300)
student_249 = TrainingStudent(student=student_user_249, student_training_coordinator=coord_28, first_name=student_user_249.first_name, last_name=student_user_249.last_name, matrix_no=student_user_249.identification_num, email=student_user_249.email, phone_number=student_user_249.phone_number, is_in_school=True, level=300)
student_250 = TrainingStudent(student=student_user_250, student_training_coordinator=coord_21, first_name=student_user_250.first_name, last_name=student_user_250.last_name, matrix_no=student_user_250.identification_num, email=student_user_250.email, phone_number=student_user_250.phone_number, is_in_school=True, level=200)
student_251 = TrainingStudent(student=student_user_251, student_training_coordinator=coord_9, first_name=student_user_251.first_name, last_name=student_user_251.last_name, matrix_no=student_user_251.identification_num, email=student_user_251.email, phone_number=student_user_251.phone_number, is_in_school=True, level=200)
student_252 = TrainingStudent(student=student_user_252, student_training_coordinator=coord_22, first_name=student_user_252.first_name, last_name=student_user_252.last_name, matrix_no=student_user_252.identification_num, email=student_user_252.email, phone_number=student_user_252.phone_number, is_in_school=True, level=200)
student_253 = TrainingStudent(student=student_user_253, student_training_coordinator=coord_11, first_name=student_user_253.first_name, last_name=student_user_253.last_name, matrix_no=student_user_253.identification_num, email=student_user_253.email, phone_number=student_user_253.phone_number, is_in_school=True, level=200)
student_254 = TrainingStudent(student=student_user_254, student_training_coordinator=coord_4, first_name=student_user_254.first_name, last_name=student_user_254.last_name, matrix_no=student_user_254.identification_num, email=student_user_254.email, phone_number=student_user_254.phone_number, is_in_school=True, level=200)
student_255 = TrainingStudent(student=student_user_255, student_training_coordinator=coord_23, first_name=student_user_255.first_name, last_name=student_user_255.last_name, matrix_no=student_user_255.identification_num, email=student_user_255.email, phone_number=student_user_255.phone_number, is_in_school=True, level=200)
student_256 = TrainingStudent(student=student_user_256, student_training_coordinator=coord_32, first_name=student_user_256.first_name, last_name=student_user_256.last_name, matrix_no=student_user_256.identification_num, email=student_user_256.email, phone_number=student_user_256.phone_number, is_in_school=True, level=300)
student_257 = TrainingStudent(student=student_user_257, student_training_coordinator=coord_20, first_name=student_user_257.first_name, last_name=student_user_257.last_name, matrix_no=student_user_257.identification_num, email=student_user_257.email, phone_number=student_user_257.phone_number, is_in_school=True, level=300)
student_258 = TrainingStudent(student=student_user_258, student_training_coordinator=coord_11, first_name=student_user_258.first_name, last_name=student_user_258.last_name, matrix_no=student_user_258.identification_num, email=student_user_258.email, phone_number=student_user_258.phone_number, is_in_school=True, level=300)
student_259 = TrainingStudent(student=student_user_259, student_training_coordinator=coord_19, first_name=student_user_259.first_name, last_name=student_user_259.last_name, matrix_no=student_user_259.identification_num, email=student_user_259.email, phone_number=student_user_259.phone_number, is_in_school=True, level=200)
student_260 = TrainingStudent(student=student_user_260, student_training_coordinator=coord_28, first_name=student_user_260.first_name, last_name=student_user_260.last_name, matrix_no=student_user_260.identification_num, email=student_user_260.email, phone_number=student_user_260.phone_number, is_in_school=True, level=300)
student_261 = TrainingStudent(student=student_user_261, student_training_coordinator=coord_12, first_name=student_user_261.first_name, last_name=student_user_261.last_name, matrix_no=student_user_261.identification_num, email=student_user_261.email, phone_number=student_user_261.phone_number, is_in_school=True, level=300)
student_262 = TrainingStudent(student=student_user_262, student_training_coordinator=coord_21, first_name=student_user_262.first_name, last_name=student_user_262.last_name, matrix_no=student_user_262.identification_num, email=student_user_262.email, phone_number=student_user_262.phone_number, is_in_school=True, level=300)
student_263 = TrainingStudent(student=student_user_263, student_training_coordinator=coord_2, first_name=student_user_263.first_name, last_name=student_user_263.last_name, matrix_no=student_user_263.identification_num, email=student_user_263.email, phone_number=student_user_263.phone_number, is_in_school=True, level=300)
student_264 = TrainingStudent(student=student_user_264, student_training_coordinator=coord_2, first_name=student_user_264.first_name, last_name=student_user_264.last_name, matrix_no=student_user_264.identification_num, email=student_user_264.email, phone_number=student_user_264.phone_number, is_in_school=True, level=300)
student_265 = TrainingStudent(student=student_user_265, student_training_coordinator=coord_30, first_name=student_user_265.first_name, last_name=student_user_265.last_name, matrix_no=student_user_265.identification_num, email=student_user_265.email, phone_number=student_user_265.phone_number, is_in_school=True, level=300)
student_266 = TrainingStudent(student=student_user_266, student_training_coordinator=coord_28, first_name=student_user_266.first_name, last_name=student_user_266.last_name, matrix_no=student_user_266.identification_num, email=student_user_266.email, phone_number=student_user_266.phone_number, is_in_school=True, level=300)
student_267 = TrainingStudent(student=student_user_267, student_training_coordinator=coord_25, first_name=student_user_267.first_name, last_name=student_user_267.last_name, matrix_no=student_user_267.identification_num, email=student_user_267.email, phone_number=student_user_267.phone_number, is_in_school=True, level=300)
student_268 = TrainingStudent(student=student_user_268, student_training_coordinator=coord_21, first_name=student_user_268.first_name, last_name=student_user_268.last_name, matrix_no=student_user_268.identification_num, email=student_user_268.email, phone_number=student_user_268.phone_number, is_in_school=True, level=300)
student_269 = TrainingStudent(student=student_user_269, student_training_coordinator=coord_28, first_name=student_user_269.first_name, last_name=student_user_269.last_name, matrix_no=student_user_269.identification_num, email=student_user_269.email, phone_number=student_user_269.phone_number, is_in_school=True, level=200)
student_270 = TrainingStudent(student=student_user_270, student_training_coordinator=coord_14, first_name=student_user_270.first_name, last_name=student_user_270.last_name, matrix_no=student_user_270.identification_num, email=student_user_270.email, phone_number=student_user_270.phone_number, is_in_school=True, level=200)
student_271 = TrainingStudent(student=student_user_271, student_training_coordinator=coord_31, first_name=student_user_271.first_name, last_name=student_user_271.last_name, matrix_no=student_user_271.identification_num, email=student_user_271.email, phone_number=student_user_271.phone_number, is_in_school=True, level=200)
student_272 = TrainingStudent(student=student_user_272, student_training_coordinator=coord_29, first_name=student_user_272.first_name, last_name=student_user_272.last_name, matrix_no=student_user_272.identification_num, email=student_user_272.email, phone_number=student_user_272.phone_number, is_in_school=True, level=200)
student_273 = TrainingStudent(student=student_user_273, student_training_coordinator=coord_32, first_name=student_user_273.first_name, last_name=student_user_273.last_name, matrix_no=student_user_273.identification_num, email=student_user_273.email, phone_number=student_user_273.phone_number, is_in_school=True, level=200)
student_274 = TrainingStudent(student=student_user_274, student_training_coordinator=coord_27, first_name=student_user_274.first_name, last_name=student_user_274.last_name, matrix_no=student_user_274.identification_num, email=student_user_274.email, phone_number=student_user_274.phone_number, is_in_school=True, level=300)
student_275 = TrainingStudent(student=student_user_275, student_training_coordinator=coord_7, first_name=student_user_275.first_name, last_name=student_user_275.last_name, matrix_no=student_user_275.identification_num, email=student_user_275.email, phone_number=student_user_275.phone_number, is_in_school=True, level=200)
student_276 = TrainingStudent(student=student_user_276, student_training_coordinator=coord_26, first_name=student_user_276.first_name, last_name=student_user_276.last_name, matrix_no=student_user_276.identification_num, email=student_user_276.email, phone_number=student_user_276.phone_number, is_in_school=True, level=200)
student_277 = TrainingStudent(student=student_user_277, student_training_coordinator=coord_22, first_name=student_user_277.first_name, last_name=student_user_277.last_name, matrix_no=student_user_277.identification_num, email=student_user_277.email, phone_number=student_user_277.phone_number, is_in_school=True, level=200)
student_278 = TrainingStudent(student=student_user_278, student_training_coordinator=coord_8, first_name=student_user_278.first_name, last_name=student_user_278.last_name, matrix_no=student_user_278.identification_num, email=student_user_278.email, phone_number=student_user_278.phone_number, is_in_school=True, level=200)
student_279 = TrainingStudent(student=student_user_279, student_training_coordinator=coord_30, first_name=student_user_279.first_name, last_name=student_user_279.last_name, matrix_no=student_user_279.identification_num, email=student_user_279.email, phone_number=student_user_279.phone_number, is_in_school=True, level=300)
student_280 = TrainingStudent(student=student_user_280, student_training_coordinator=coord_32, first_name=student_user_280.first_name, last_name=student_user_280.last_name, matrix_no=student_user_280.identification_num, email=student_user_280.email, phone_number=student_user_280.phone_number, is_in_school=True, level=300)
student_281 = TrainingStudent(student=student_user_281, student_training_coordinator=coord_31, first_name=student_user_281.first_name, last_name=student_user_281.last_name, matrix_no=student_user_281.identification_num, email=student_user_281.email, phone_number=student_user_281.phone_number, is_in_school=True, level=200)
student_282 = TrainingStudent(student=student_user_282, student_training_coordinator=coord_26, first_name=student_user_282.first_name, last_name=student_user_282.last_name, matrix_no=student_user_282.identification_num, email=student_user_282.email, phone_number=student_user_282.phone_number, is_in_school=True, level=200)
student_283 = TrainingStudent(student=student_user_283, student_training_coordinator=coord_2, first_name=student_user_283.first_name, last_name=student_user_283.last_name, matrix_no=student_user_283.identification_num, email=student_user_283.email, phone_number=student_user_283.phone_number, is_in_school=True, level=200)
student_284 = TrainingStudent(student=student_user_284, student_training_coordinator=coord_2, first_name=student_user_284.first_name, last_name=student_user_284.last_name, matrix_no=student_user_284.identification_num, email=student_user_284.email, phone_number=student_user_284.phone_number, is_in_school=True, level=200)
student_285 = TrainingStudent(student=student_user_285, student_training_coordinator=coord_3, first_name=student_user_285.first_name, last_name=student_user_285.last_name, matrix_no=student_user_285.identification_num, email=student_user_285.email, phone_number=student_user_285.phone_number, is_in_school=True, level=200)
student_286 = TrainingStudent(student=student_user_286, student_training_coordinator=coord_28, first_name=student_user_286.first_name, last_name=student_user_286.last_name, matrix_no=student_user_286.identification_num, email=student_user_286.email, phone_number=student_user_286.phone_number, is_in_school=True, level=300)
student_287 = TrainingStudent(student=student_user_287, student_training_coordinator=coord_23, first_name=student_user_287.first_name, last_name=student_user_287.last_name, matrix_no=student_user_287.identification_num, email=student_user_287.email, phone_number=student_user_287.phone_number, is_in_school=True, level=300)
student_288 = TrainingStudent(student=student_user_288, student_training_coordinator=coord_29, first_name=student_user_288.first_name, last_name=student_user_288.last_name, matrix_no=student_user_288.identification_num, email=student_user_288.email, phone_number=student_user_288.phone_number, is_in_school=True, level=300)
student_289 = TrainingStudent(student=student_user_289, student_training_coordinator=coord_32, first_name=student_user_289.first_name, last_name=student_user_289.last_name, matrix_no=student_user_289.identification_num, email=student_user_289.email, phone_number=student_user_289.phone_number, is_in_school=True, level=300)
student_290 = TrainingStudent(student=student_user_290, student_training_coordinator=coord_21, first_name=student_user_290.first_name, last_name=student_user_290.last_name, matrix_no=student_user_290.identification_num, email=student_user_290.email, phone_number=student_user_290.phone_number, is_in_school=True, level=200)
student_291 = TrainingStudent(student=student_user_291, student_training_coordinator=coord_16, first_name=student_user_291.first_name, last_name=student_user_291.last_name, matrix_no=student_user_291.identification_num, email=student_user_291.email, phone_number=student_user_291.phone_number, is_in_school=True, level=200)
student_292 = TrainingStudent(student=student_user_292, student_training_coordinator=coord_30, first_name=student_user_292.first_name, last_name=student_user_292.last_name, matrix_no=student_user_292.identification_num, email=student_user_292.email, phone_number=student_user_292.phone_number, is_in_school=True, level=200)
student_293 = TrainingStudent(student=student_user_293, student_training_coordinator=coord_28, first_name=student_user_293.first_name, last_name=student_user_293.last_name, matrix_no=student_user_293.identification_num, email=student_user_293.email, phone_number=student_user_293.phone_number, is_in_school=True, level=300)
student_294 = TrainingStudent(student=student_user_294, student_training_coordinator=coord_5, first_name=student_user_294.first_name, last_name=student_user_294.last_name, matrix_no=student_user_294.identification_num, email=student_user_294.email, phone_number=student_user_294.phone_number, is_in_school=True, level=300)
student_295 = TrainingStudent(student=student_user_295, student_training_coordinator=coord_32, first_name=student_user_295.first_name, last_name=student_user_295.last_name, matrix_no=student_user_295.identification_num, email=student_user_295.email, phone_number=student_user_295.phone_number, is_in_school=True, level=200)
student_296 = TrainingStudent(student=student_user_296, student_training_coordinator=coord_28, first_name=student_user_296.first_name, last_name=student_user_296.last_name, matrix_no=student_user_296.identification_num, email=student_user_296.email, phone_number=student_user_296.phone_number, is_in_school=True, level=300)
student_297 = TrainingStudent(student=student_user_297, student_training_coordinator=coord_25, first_name=student_user_297.first_name, last_name=student_user_297.last_name, matrix_no=student_user_297.identification_num, email=student_user_297.email, phone_number=student_user_297.phone_number, is_in_school=True, level=300)
student_298 = TrainingStudent(student=student_user_298, student_training_coordinator=coord_20, first_name=student_user_298.first_name, last_name=student_user_298.last_name, matrix_no=student_user_298.identification_num, email=student_user_298.email, phone_number=student_user_298.phone_number, is_in_school=True, level=300)
student_299 = TrainingStudent(student=student_user_299, student_training_coordinator=coord_8, first_name=student_user_299.first_name, last_name=student_user_299.last_name, matrix_no=student_user_299.identification_num, email=student_user_299.email, phone_number=student_user_299.phone_number, is_in_school=True, level=300)
student_300 = TrainingStudent(student=student_user_300, student_training_coordinator=coord_7, first_name=student_user_300.first_name, last_name=student_user_300.last_name, matrix_no=student_user_300.identification_num, email=student_user_300.email, phone_number=student_user_300.phone_number, is_in_school=True, level=300)
student_301 = TrainingStudent(student=student_user_301, student_training_coordinator=coord_32, first_name=student_user_301.first_name, last_name=student_user_301.last_name, matrix_no=student_user_301.identification_num, email=student_user_301.email, phone_number=student_user_301.phone_number, is_in_school=True, level=200)
student_302 = TrainingStudent(student=student_user_302, student_training_coordinator=coord_1, first_name=student_user_302.first_name, last_name=student_user_302.last_name, matrix_no=student_user_302.identification_num, email=student_user_302.email, phone_number=student_user_302.phone_number, is_in_school=True, level=300)
student_303 = TrainingStudent(student=student_user_303, student_training_coordinator=coord_25, first_name=student_user_303.first_name, last_name=student_user_303.last_name, matrix_no=student_user_303.identification_num, email=student_user_303.email, phone_number=student_user_303.phone_number, is_in_school=True, level=300)
student_304 = TrainingStudent(student=student_user_304, student_training_coordinator=coord_7, first_name=student_user_304.first_name, last_name=student_user_304.last_name, matrix_no=student_user_304.identification_num, email=student_user_304.email, phone_number=student_user_304.phone_number, is_in_school=True, level=200)
student_305 = TrainingStudent(student=student_user_305, student_training_coordinator=coord_6, first_name=student_user_305.first_name, last_name=student_user_305.last_name, matrix_no=student_user_305.identification_num, email=student_user_305.email, phone_number=student_user_305.phone_number, is_in_school=True, level=200)
student_306 = TrainingStudent(student=student_user_306, student_training_coordinator=coord_22, first_name=student_user_306.first_name, last_name=student_user_306.last_name, matrix_no=student_user_306.identification_num, email=student_user_306.email, phone_number=student_user_306.phone_number, is_in_school=True, level=200)
student_307 = TrainingStudent(student=student_user_307, student_training_coordinator=coord_3, first_name=student_user_307.first_name, last_name=student_user_307.last_name, matrix_no=student_user_307.identification_num, email=student_user_307.email, phone_number=student_user_307.phone_number, is_in_school=True, level=200)
student_308 = TrainingStudent(student=student_user_308, student_training_coordinator=coord_31, first_name=student_user_308.first_name, last_name=student_user_308.last_name, matrix_no=student_user_308.identification_num, email=student_user_308.email, phone_number=student_user_308.phone_number, is_in_school=True, level=300)
student_309 = TrainingStudent(student=student_user_309, student_training_coordinator=coord_26, first_name=student_user_309.first_name, last_name=student_user_309.last_name, matrix_no=student_user_309.identification_num, email=student_user_309.email, phone_number=student_user_309.phone_number, is_in_school=True, level=300)
student_310 = TrainingStudent(student=student_user_310, student_training_coordinator=coord_6, first_name=student_user_310.first_name, last_name=student_user_310.last_name, matrix_no=student_user_310.identification_num, email=student_user_310.email, phone_number=student_user_310.phone_number, is_in_school=True, level=300)
student_311 = TrainingStudent(student=student_user_311, student_training_coordinator=coord_19, first_name=student_user_311.first_name, last_name=student_user_311.last_name, matrix_no=student_user_311.identification_num, email=student_user_311.email, phone_number=student_user_311.phone_number, is_in_school=True, level=200)
student_312 = TrainingStudent(student=student_user_312, student_training_coordinator=coord_19, first_name=student_user_312.first_name, last_name=student_user_312.last_name, matrix_no=student_user_312.identification_num, email=student_user_312.email, phone_number=student_user_312.phone_number, is_in_school=True, level=300)
student_313 = TrainingStudent(student=student_user_313, student_training_coordinator=coord_20, first_name=student_user_313.first_name, last_name=student_user_313.last_name, matrix_no=student_user_313.identification_num, email=student_user_313.email, phone_number=student_user_313.phone_number, is_in_school=True, level=300)
student_314 = TrainingStudent(student=student_user_314, student_training_coordinator=coord_5, first_name=student_user_314.first_name, last_name=student_user_314.last_name, matrix_no=student_user_314.identification_num, email=student_user_314.email, phone_number=student_user_314.phone_number, is_in_school=True, level=300)
student_315 = TrainingStudent(student=student_user_315, student_training_coordinator=coord_2, first_name=student_user_315.first_name, last_name=student_user_315.last_name, matrix_no=student_user_315.identification_num, email=student_user_315.email, phone_number=student_user_315.phone_number, is_in_school=True, level=200)
student_316 = TrainingStudent(student=student_user_316, student_training_coordinator=coord_27, first_name=student_user_316.first_name, last_name=student_user_316.last_name, matrix_no=student_user_316.identification_num, email=student_user_316.email, phone_number=student_user_316.phone_number, is_in_school=True, level=300)
student_317 = TrainingStudent(student=student_user_317, student_training_coordinator=coord_5, first_name=student_user_317.first_name, last_name=student_user_317.last_name, matrix_no=student_user_317.identification_num, email=student_user_317.email, phone_number=student_user_317.phone_number, is_in_school=True, level=200)
student_318 = TrainingStudent(student=student_user_318, student_training_coordinator=coord_24, first_name=student_user_318.first_name, last_name=student_user_318.last_name, matrix_no=student_user_318.identification_num, email=student_user_318.email, phone_number=student_user_318.phone_number, is_in_school=True, level=200)
student_319 = TrainingStudent(student=student_user_319, student_training_coordinator=coord_31, first_name=student_user_319.first_name, last_name=student_user_319.last_name, matrix_no=student_user_319.identification_num, email=student_user_319.email, phone_number=student_user_319.phone_number, is_in_school=True, level=200)
student_320 = TrainingStudent(student=student_user_320, student_training_coordinator=coord_22, first_name=student_user_320.first_name, last_name=student_user_320.last_name, matrix_no=student_user_320.identification_num, email=student_user_320.email, phone_number=student_user_320.phone_number, is_in_school=True, level=200)

student_1.save()
student_2.save()
student_3.save()
student_4.save()
student_5.save()
student_6.save()
student_7.save()
student_8.save()
student_9.save()
student_10.save()
student_11.save()
student_12.save()
student_13.save()
student_14.save()
student_15.save()
student_16.save()
student_17.save()
student_18.save()
student_19.save()
student_20.save()
student_21.save()
student_22.save()
student_23.save()
student_24.save()
student_25.save()
student_26.save()
student_27.save()
student_28.save()
student_29.save()
student_30.save()
student_31.save()
student_32.save()
student_33.save()
student_34.save()
student_35.save()
student_36.save()
student_37.save()
student_38.save()
student_39.save()
student_40.save()
student_41.save()
student_42.save()
student_43.save()
student_44.save()
student_45.save()
student_46.save()
student_47.save()
student_48.save()
student_49.save()
student_50.save()
student_51.save()
student_52.save()
student_53.save()
student_54.save()
student_55.save()
student_56.save()
student_57.save()
student_58.save()
student_59.save()
student_60.save()
student_61.save()
student_62.save()
student_63.save()
student_64.save()
student_65.save()
student_66.save()
student_67.save()
student_68.save()
student_69.save()
student_70.save()
student_71.save()
student_72.save()
student_73.save()
student_74.save()
student_75.save()
student_76.save()
student_77.save()
student_78.save()
student_79.save()
student_80.save()
student_81.save()
student_82.save()
student_83.save()
student_84.save()
student_85.save()
student_86.save()
student_87.save()
student_88.save()
student_89.save()
student_90.save()
student_91.save()
student_92.save()
student_93.save()
student_94.save()
student_95.save()
student_96.save()
student_97.save()
student_98.save()
student_99.save()
student_100.save()
student_101.save()
student_102.save()
student_103.save()
student_104.save()
student_105.save()
student_106.save()
student_107.save()
student_108.save()
student_109.save()
student_110.save()
student_111.save()
student_112.save()
student_113.save()
student_114.save()
student_115.save()
student_116.save()
student_117.save()
student_118.save()
student_119.save()
student_120.save()
student_121.save()
student_122.save()
student_123.save()
student_124.save()
student_125.save()
student_126.save()
student_127.save()
student_128.save()
student_129.save()
student_130.save()
student_131.save()
student_132.save()
student_133.save()
student_134.save()
student_135.save()
student_136.save()
student_137.save()
student_138.save()
student_139.save()
student_140.save()
student_141.save()
student_142.save()
student_143.save()
student_144.save()
student_145.save()
student_146.save()
student_147.save()
student_148.save()
student_149.save()
student_150.save()
student_151.save()
student_152.save()
student_153.save()
student_154.save()
student_155.save()
student_156.save()
student_157.save()
student_158.save()
student_159.save()
student_160.save()
student_161.save()
student_162.save()
student_163.save()
student_164.save()
student_165.save()
student_166.save()
student_167.save()
student_168.save()
student_169.save()
student_170.save()
student_171.save()
student_172.save()
student_173.save()
student_174.save()
student_175.save()
student_176.save()
student_177.save()
student_178.save()
student_179.save()
student_180.save()
student_181.save()
student_182.save()
student_183.save()
student_184.save()
student_185.save()
student_186.save()
student_187.save()
student_188.save()
student_189.save()
student_190.save()
student_191.save()
student_192.save()
student_193.save()
student_194.save()
student_195.save()
student_196.save()
student_197.save()
student_198.save()
student_199.save()
student_200.save()
student_201.save()
student_202.save()
student_203.save()
student_204.save()
student_205.save()
student_206.save()
student_207.save()
student_208.save()
student_209.save()
student_210.save()
student_211.save()
student_212.save()
student_213.save()
student_214.save()
student_215.save()
student_216.save()
student_217.save()
student_218.save()
student_219.save()
student_220.save()
student_221.save()
student_222.save()
student_223.save()
student_224.save()
student_225.save()
student_226.save()
student_227.save()
student_228.save()
student_229.save()
student_230.save()
student_231.save()
student_232.save()
student_233.save()
student_234.save()
student_235.save()
student_236.save()
student_237.save()
student_238.save()
student_239.save()
student_240.save()
student_241.save()
student_242.save()
student_243.save()
student_244.save()
student_245.save()
student_246.save()
student_247.save()
student_248.save()
student_249.save()
student_250.save()
student_251.save()
student_252.save()
student_253.save()
student_254.save()
student_255.save()
student_256.save()
student_257.save()
student_258.save()
student_259.save()
student_260.save()
student_261.save()
student_262.save()
student_263.save()
student_264.save()
student_265.save()
student_266.save()
student_267.save()
student_268.save()
student_269.save()
student_270.save()
student_271.save()
student_272.save()
student_273.save()
student_274.save()
student_275.save()
student_276.save()
student_277.save()
student_278.save()
student_279.save()
student_280.save()
student_281.save()
student_282.save()
student_283.save()
student_284.save()
student_285.save()
student_286.save()
student_287.save()
student_288.save()
student_289.save()
student_290.save()
student_291.save()
student_292.save()
student_293.save()
student_294.save()
student_295.save()
student_296.save()
student_297.save()
student_298.save()
student_299.save()
student_300.save()
student_301.save()
student_302.save()
student_303.save()
student_304.save()
student_305.save()
student_306.save()
student_307.save()
student_308.save()
student_309.save()
student_310.save()
student_311.save()
student_312.save()
student_313.save()
student_314.save()
student_315.save()
student_316.save()
student_317.save()
student_318.save()
student_319.save()
student_320.save()

### adding `2010310013` as approved training student. But I will
### make it `TrainingStudent` instance instead of `User` instance
coord_3.training_students.add(student_user_1)

### assigning supervisor to `2010310013`. But I will
### make it `TrainingStudent` instance instead of `User` instance also
super_1.training_students.add(student_user_1)

### _______________________________________
### WEEK READER (1 week reader for student)
WR_1 = WeekReader(student=student_1)
WR_2 = WeekReader(student=student_2)
WR_3 = WeekReader(student=student_3)
WR_4 = WeekReader(student=student_4)
WR_5 = WeekReader(student=student_5)
WR_6 = WeekReader(student=student_6)
WR_7 = WeekReader(student=student_7)
WR_8 = WeekReader(student=student_8)
WR_9 = WeekReader(student=student_9)
WR_10 = WeekReader(student=student_10)
WR_11 = WeekReader(student=student_11)
WR_12 = WeekReader(student=student_12)
WR_13 = WeekReader(student=student_13)
WR_14 = WeekReader(student=student_14)
WR_15 = WeekReader(student=student_15)
WR_16 = WeekReader(student=student_16)
WR_17 = WeekReader(student=student_17)
WR_18 = WeekReader(student=student_18)
WR_19 = WeekReader(student=student_19)
WR_20 = WeekReader(student=student_20)
WR_21 = WeekReader(student=student_21)
WR_22 = WeekReader(student=student_22)
WR_23 = WeekReader(student=student_23)
WR_24 = WeekReader(student=student_24)
WR_25 = WeekReader(student=student_25)
WR_26 = WeekReader(student=student_26)
WR_27 = WeekReader(student=student_27)
WR_28 = WeekReader(student=student_28)
WR_29 = WeekReader(student=student_29)
WR_30 = WeekReader(student=student_30)
WR_31 = WeekReader(student=student_31)
WR_32 = WeekReader(student=student_32)
WR_33 = WeekReader(student=student_33)
WR_34 = WeekReader(student=student_34)
WR_35 = WeekReader(student=student_35)
WR_36 = WeekReader(student=student_36)
WR_37 = WeekReader(student=student_37)
WR_38 = WeekReader(student=student_38)
WR_39 = WeekReader(student=student_39)
WR_40 = WeekReader(student=student_40)
WR_41 = WeekReader(student=student_41)
WR_42 = WeekReader(student=student_42)
WR_43 = WeekReader(student=student_43)
WR_44 = WeekReader(student=student_44)
WR_45 = WeekReader(student=student_45)
WR_46 = WeekReader(student=student_46)
WR_47 = WeekReader(student=student_47)
WR_48 = WeekReader(student=student_48)
WR_49 = WeekReader(student=student_49)
WR_50 = WeekReader(student=student_50)
WR_51 = WeekReader(student=student_51)
WR_52 = WeekReader(student=student_52)
WR_53 = WeekReader(student=student_53)
WR_54 = WeekReader(student=student_54)
WR_55 = WeekReader(student=student_55)
WR_56 = WeekReader(student=student_56)
WR_57 = WeekReader(student=student_57)
WR_58 = WeekReader(student=student_58)
WR_59 = WeekReader(student=student_59)
WR_60 = WeekReader(student=student_60)
WR_61 = WeekReader(student=student_61)
WR_62 = WeekReader(student=student_62)
WR_63 = WeekReader(student=student_63)
WR_64 = WeekReader(student=student_64)
WR_65 = WeekReader(student=student_65)
WR_66 = WeekReader(student=student_66)
WR_67 = WeekReader(student=student_67)
WR_68 = WeekReader(student=student_68)
WR_69 = WeekReader(student=student_69)
WR_70 = WeekReader(student=student_70)
WR_71 = WeekReader(student=student_71)
WR_72 = WeekReader(student=student_72)
WR_73 = WeekReader(student=student_73)
WR_74 = WeekReader(student=student_74)
WR_75 = WeekReader(student=student_75)
WR_76 = WeekReader(student=student_76)
WR_77 = WeekReader(student=student_77)
WR_78 = WeekReader(student=student_78)
WR_79 = WeekReader(student=student_79)
WR_80 = WeekReader(student=student_80)
WR_81 = WeekReader(student=student_81)
WR_82 = WeekReader(student=student_82)
WR_83 = WeekReader(student=student_83)
WR_84 = WeekReader(student=student_84)
WR_85 = WeekReader(student=student_85)
WR_86 = WeekReader(student=student_86)
WR_87 = WeekReader(student=student_87)
WR_88 = WeekReader(student=student_88)
WR_89 = WeekReader(student=student_89)
WR_90 = WeekReader(student=student_90)
WR_91 = WeekReader(student=student_91)
WR_92 = WeekReader(student=student_92)
WR_93 = WeekReader(student=student_93)
WR_94 = WeekReader(student=student_94)
WR_95 = WeekReader(student=student_95)
WR_96 = WeekReader(student=student_96)
WR_97 = WeekReader(student=student_97)
WR_98 = WeekReader(student=student_98)
WR_99 = WeekReader(student=student_99)
WR_100 = WeekReader(student=student_100)
WR_101 = WeekReader(student=student_101)
WR_102 = WeekReader(student=student_102)
WR_103 = WeekReader(student=student_103)
WR_104 = WeekReader(student=student_104)
WR_105 = WeekReader(student=student_105)
WR_106 = WeekReader(student=student_106)
WR_107 = WeekReader(student=student_107)
WR_108 = WeekReader(student=student_108)
WR_109 = WeekReader(student=student_109)
WR_110 = WeekReader(student=student_110)
WR_111 = WeekReader(student=student_111)
WR_112 = WeekReader(student=student_112)
WR_113 = WeekReader(student=student_113)
WR_114 = WeekReader(student=student_114)
WR_115 = WeekReader(student=student_115)
WR_116 = WeekReader(student=student_116)
WR_117 = WeekReader(student=student_117)
WR_118 = WeekReader(student=student_118)
WR_119 = WeekReader(student=student_119)
WR_120 = WeekReader(student=student_120)
WR_121 = WeekReader(student=student_121)
WR_122 = WeekReader(student=student_122)
WR_123 = WeekReader(student=student_123)
WR_124 = WeekReader(student=student_124)
WR_125 = WeekReader(student=student_125)
WR_126 = WeekReader(student=student_126)
WR_127 = WeekReader(student=student_127)
WR_128 = WeekReader(student=student_128)
WR_129 = WeekReader(student=student_129)
WR_130 = WeekReader(student=student_130)
WR_131 = WeekReader(student=student_131)
WR_132 = WeekReader(student=student_132)
WR_133 = WeekReader(student=student_133)
WR_134 = WeekReader(student=student_134)
WR_135 = WeekReader(student=student_135)
WR_136 = WeekReader(student=student_136)
WR_137 = WeekReader(student=student_137)
WR_138 = WeekReader(student=student_138)
WR_139 = WeekReader(student=student_139)
WR_140 = WeekReader(student=student_140)
WR_141 = WeekReader(student=student_141)
WR_142 = WeekReader(student=student_142)
WR_143 = WeekReader(student=student_143)
WR_144 = WeekReader(student=student_144)
WR_145 = WeekReader(student=student_145)
WR_146 = WeekReader(student=student_146)
WR_147 = WeekReader(student=student_147)
WR_148 = WeekReader(student=student_148)
WR_149 = WeekReader(student=student_149)
WR_150 = WeekReader(student=student_150)
WR_151 = WeekReader(student=student_151)
WR_152 = WeekReader(student=student_152)
WR_153 = WeekReader(student=student_153)
WR_154 = WeekReader(student=student_154)
WR_155 = WeekReader(student=student_155)
WR_156 = WeekReader(student=student_156)
WR_157 = WeekReader(student=student_157)
WR_158 = WeekReader(student=student_158)
WR_159 = WeekReader(student=student_159)
WR_160 = WeekReader(student=student_160)
WR_161 = WeekReader(student=student_161)
WR_162 = WeekReader(student=student_162)
WR_163 = WeekReader(student=student_163)
WR_164 = WeekReader(student=student_164)
WR_165 = WeekReader(student=student_165)
WR_166 = WeekReader(student=student_166)
WR_167 = WeekReader(student=student_167)
WR_168 = WeekReader(student=student_168)
WR_169 = WeekReader(student=student_169)
WR_170 = WeekReader(student=student_170)
WR_171 = WeekReader(student=student_171)
WR_172 = WeekReader(student=student_172)
WR_173 = WeekReader(student=student_173)
WR_174 = WeekReader(student=student_174)
WR_175 = WeekReader(student=student_175)
WR_176 = WeekReader(student=student_176)
WR_177 = WeekReader(student=student_177)
WR_178 = WeekReader(student=student_178)
WR_179 = WeekReader(student=student_179)
WR_180 = WeekReader(student=student_180)
WR_181 = WeekReader(student=student_181)
WR_182 = WeekReader(student=student_182)
WR_183 = WeekReader(student=student_183)
WR_184 = WeekReader(student=student_184)
WR_185 = WeekReader(student=student_185)
WR_186 = WeekReader(student=student_186)
WR_187 = WeekReader(student=student_187)
WR_188 = WeekReader(student=student_188)
WR_189 = WeekReader(student=student_189)
WR_190 = WeekReader(student=student_190)
WR_191 = WeekReader(student=student_191)
WR_192 = WeekReader(student=student_192)
WR_193 = WeekReader(student=student_193)
WR_194 = WeekReader(student=student_194)
WR_195 = WeekReader(student=student_195)
WR_196 = WeekReader(student=student_196)
WR_197 = WeekReader(student=student_197)
WR_198 = WeekReader(student=student_198)
WR_199 = WeekReader(student=student_199)
WR_200 = WeekReader(student=student_200)
WR_201 = WeekReader(student=student_201)
WR_202 = WeekReader(student=student_202)
WR_203 = WeekReader(student=student_203)
WR_204 = WeekReader(student=student_204)
WR_205 = WeekReader(student=student_205)
WR_206 = WeekReader(student=student_206)
WR_207 = WeekReader(student=student_207)
WR_208 = WeekReader(student=student_208)
WR_209 = WeekReader(student=student_209)
WR_210 = WeekReader(student=student_210)
WR_211 = WeekReader(student=student_211)
WR_212 = WeekReader(student=student_212)
WR_213 = WeekReader(student=student_213)
WR_214 = WeekReader(student=student_214)
WR_215 = WeekReader(student=student_215)
WR_216 = WeekReader(student=student_216)
WR_217 = WeekReader(student=student_217)
WR_218 = WeekReader(student=student_218)
WR_219 = WeekReader(student=student_219)
WR_220 = WeekReader(student=student_220)
WR_221 = WeekReader(student=student_221)
WR_222 = WeekReader(student=student_222)
WR_223 = WeekReader(student=student_223)
WR_224 = WeekReader(student=student_224)
WR_225 = WeekReader(student=student_225)
WR_226 = WeekReader(student=student_226)
WR_227 = WeekReader(student=student_227)
WR_228 = WeekReader(student=student_228)
WR_229 = WeekReader(student=student_229)
WR_230 = WeekReader(student=student_230)
WR_231 = WeekReader(student=student_231)
WR_232 = WeekReader(student=student_232)
WR_233 = WeekReader(student=student_233)
WR_234 = WeekReader(student=student_234)
WR_235 = WeekReader(student=student_235)
WR_236 = WeekReader(student=student_236)
WR_237 = WeekReader(student=student_237)
WR_238 = WeekReader(student=student_238)
WR_239 = WeekReader(student=student_239)
WR_240 = WeekReader(student=student_240)
WR_241 = WeekReader(student=student_241)
WR_242 = WeekReader(student=student_242)
WR_243 = WeekReader(student=student_243)
WR_244 = WeekReader(student=student_244)
WR_245 = WeekReader(student=student_245)
WR_246 = WeekReader(student=student_246)
WR_247 = WeekReader(student=student_247)
WR_248 = WeekReader(student=student_248)
WR_249 = WeekReader(student=student_249)
WR_250 = WeekReader(student=student_250)
WR_251 = WeekReader(student=student_251)
WR_252 = WeekReader(student=student_252)
WR_253 = WeekReader(student=student_253)
WR_254 = WeekReader(student=student_254)
WR_255 = WeekReader(student=student_255)
WR_256 = WeekReader(student=student_256)
WR_257 = WeekReader(student=student_257)
WR_258 = WeekReader(student=student_258)
WR_259 = WeekReader(student=student_259)
WR_260 = WeekReader(student=student_260)
WR_261 = WeekReader(student=student_261)
WR_262 = WeekReader(student=student_262)
WR_263 = WeekReader(student=student_263)
WR_264 = WeekReader(student=student_264)
WR_265 = WeekReader(student=student_265)
WR_266 = WeekReader(student=student_266)
WR_267 = WeekReader(student=student_267)
WR_268 = WeekReader(student=student_268)
WR_269 = WeekReader(student=student_269)
WR_270 = WeekReader(student=student_270)
WR_271 = WeekReader(student=student_271)
WR_272 = WeekReader(student=student_272)
WR_273 = WeekReader(student=student_273)
WR_274 = WeekReader(student=student_274)
WR_275 = WeekReader(student=student_275)
WR_276 = WeekReader(student=student_276)
WR_277 = WeekReader(student=student_277)
WR_278 = WeekReader(student=student_278)
WR_279 = WeekReader(student=student_279)
WR_280 = WeekReader(student=student_280)
WR_281 = WeekReader(student=student_281)
WR_282 = WeekReader(student=student_282)
WR_283 = WeekReader(student=student_283)
WR_284 = WeekReader(student=student_284)
WR_285 = WeekReader(student=student_285)
WR_286 = WeekReader(student=student_286)
WR_287 = WeekReader(student=student_287)
WR_288 = WeekReader(student=student_288)
WR_289 = WeekReader(student=student_289)
WR_290 = WeekReader(student=student_290)
WR_291 = WeekReader(student=student_291)
WR_292 = WeekReader(student=student_292)
WR_293 = WeekReader(student=student_293)
WR_294 = WeekReader(student=student_294)
WR_295 = WeekReader(student=student_295)
WR_296 = WeekReader(student=student_296)
WR_297 = WeekReader(student=student_297)
WR_298 = WeekReader(student=student_298)
WR_299 = WeekReader(student=student_299)
WR_300 = WeekReader(student=student_300)
WR_301 = WeekReader(student=student_301)
WR_302 = WeekReader(student=student_302)
WR_303 = WeekReader(student=student_303)
WR_304 = WeekReader(student=student_304)
WR_305 = WeekReader(student=student_305)
WR_306 = WeekReader(student=student_306)
WR_307 = WeekReader(student=student_307)
WR_308 = WeekReader(student=student_308)
WR_309 = WeekReader(student=student_309)
WR_310 = WeekReader(student=student_310)
WR_311 = WeekReader(student=student_311)
WR_312 = WeekReader(student=student_312)
WR_313 = WeekReader(student=student_313)
WR_314 = WeekReader(student=student_314)
WR_315 = WeekReader(student=student_315)
WR_316 = WeekReader(student=student_316)
WR_317 = WeekReader(student=student_317)
WR_318 = WeekReader(student=student_318)
WR_319 = WeekReader(student=student_319)
WR_320 = WeekReader(student=student_320)

WR_1.save()
WR_2.save()
WR_3.save()
WR_4.save()
WR_5.save()
WR_6.save()
WR_7.save()
WR_8.save()
WR_9.save()
WR_10.save()
WR_11.save()
WR_12.save()
WR_13.save()
WR_14.save()
WR_15.save()
WR_16.save()
WR_17.save()
WR_18.save()
WR_19.save()
WR_20.save()
WR_21.save()
WR_22.save()
WR_23.save()
WR_24.save()
WR_25.save()
WR_26.save()
WR_27.save()
WR_28.save()
WR_29.save()
WR_30.save()
WR_31.save()
WR_32.save()
WR_33.save()
WR_34.save()
WR_35.save()
WR_36.save()
WR_37.save()
WR_38.save()
WR_39.save()
WR_40.save()
WR_41.save()
WR_42.save()
WR_43.save()
WR_44.save()
WR_45.save()
WR_46.save()
WR_47.save()
WR_48.save()
WR_49.save()
WR_50.save()
WR_51.save()
WR_52.save()
WR_53.save()
WR_54.save()
WR_55.save()
WR_56.save()
WR_57.save()
WR_58.save()
WR_59.save()
WR_60.save()
WR_61.save()
WR_62.save()
WR_63.save()
WR_64.save()
WR_65.save()
WR_66.save()
WR_67.save()
WR_68.save()
WR_69.save()
WR_70.save()
WR_71.save()
WR_72.save()
WR_73.save()
WR_74.save()
WR_75.save()
WR_76.save()
WR_77.save()
WR_78.save()
WR_79.save()
WR_80.save()
WR_81.save()
WR_82.save()
WR_83.save()
WR_84.save()
WR_85.save()
WR_86.save()
WR_87.save()
WR_88.save()
WR_89.save()
WR_90.save()
WR_91.save()
WR_92.save()
WR_93.save()
WR_94.save()
WR_95.save()
WR_96.save()
WR_97.save()
WR_98.save()
WR_99.save()
WR_100.save()
WR_101.save()
WR_102.save()
WR_103.save()
WR_104.save()
WR_105.save()
WR_106.save()
WR_107.save()
WR_108.save()
WR_109.save()
WR_110.save()
WR_111.save()
WR_112.save()
WR_113.save()
WR_114.save()
WR_115.save()
WR_116.save()
WR_117.save()
WR_118.save()
WR_119.save()
WR_120.save()
WR_121.save()
WR_122.save()
WR_123.save()
WR_124.save()
WR_125.save()
WR_126.save()
WR_127.save()
WR_128.save()
WR_129.save()
WR_130.save()
WR_131.save()
WR_132.save()
WR_133.save()
WR_134.save()
WR_135.save()
WR_136.save()
WR_137.save()
WR_138.save()
WR_139.save()
WR_140.save()
WR_141.save()
WR_142.save()
WR_143.save()
WR_144.save()
WR_145.save()
WR_146.save()
WR_147.save()
WR_148.save()
WR_149.save()
WR_150.save()
WR_151.save()
WR_152.save()
WR_153.save()
WR_154.save()
WR_155.save()
WR_156.save()
WR_157.save()
WR_158.save()
WR_159.save()
WR_160.save()
WR_161.save()
WR_162.save()
WR_163.save()
WR_164.save()
WR_165.save()
WR_166.save()
WR_167.save()
WR_168.save()
WR_169.save()
WR_170.save()
WR_171.save()
WR_172.save()
WR_173.save()
WR_174.save()
WR_175.save()
WR_176.save()
WR_177.save()
WR_178.save()
WR_179.save()
WR_180.save()
WR_181.save()
WR_182.save()
WR_183.save()
WR_184.save()
WR_185.save()
WR_186.save()
WR_187.save()
WR_188.save()
WR_189.save()
WR_190.save()
WR_191.save()
WR_192.save()
WR_193.save()
WR_194.save()
WR_195.save()
WR_196.save()
WR_197.save()
WR_198.save()
WR_199.save()
WR_200.save()
WR_201.save()
WR_202.save()
WR_203.save()
WR_204.save()
WR_205.save()
WR_206.save()
WR_207.save()
WR_208.save()
WR_209.save()
WR_210.save()
WR_211.save()
WR_212.save()
WR_213.save()
WR_214.save()
WR_215.save()
WR_216.save()
WR_217.save()
WR_218.save()
WR_219.save()
WR_220.save()
WR_221.save()
WR_222.save()
WR_223.save()
WR_224.save()
WR_225.save()
WR_226.save()
WR_227.save()
WR_228.save()
WR_229.save()
WR_230.save()
WR_231.save()
WR_232.save()
WR_233.save()
WR_234.save()
WR_235.save()
WR_236.save()
WR_237.save()
WR_238.save()
WR_239.save()
WR_240.save()
WR_241.save()
WR_242.save()
WR_243.save()
WR_244.save()
WR_245.save()
WR_246.save()
WR_247.save()
WR_248.save()
WR_249.save()
WR_250.save()
WR_251.save()
WR_252.save()
WR_253.save()
WR_254.save()
WR_255.save()
WR_256.save()
WR_257.save()
WR_258.save()
WR_259.save()
WR_260.save()
WR_261.save()
WR_262.save()
WR_263.save()
WR_264.save()
WR_265.save()
WR_266.save()
WR_267.save()
WR_268.save()
WR_269.save()
WR_270.save()
WR_271.save()
WR_272.save()
WR_273.save()
WR_274.save()
WR_275.save()
WR_276.save()
WR_277.save()
WR_278.save()
WR_279.save()
WR_280.save()
WR_281.save()
WR_282.save()
WR_283.save()
WR_284.save()
WR_285.save()
WR_286.save()
WR_287.save()
WR_288.save()
WR_289.save()
WR_290.save()
WR_291.save()
WR_292.save()
WR_293.save()
WR_294.save()
WR_295.save()
WR_296.save()
WR_297.save()
WR_298.save()
WR_299.save()
WR_300.save()
WR_301.save()
WR_302.save()
WR_303.save()
WR_304.save()
WR_305.save()
WR_306.save()
WR_307.save()
WR_308.save()
WR_309.save()
WR_310.save()
WR_311.save()
WR_312.save()
WR_313.save()
WR_314.save()
WR_315.save()
WR_316.save()
WR_317.save()
WR_318.save()
WR_319.save()
WR_320.save()

### ______________________
### STUDENT LETTER REQUEST

req_let1 = StudentLetterRequest(sender_req=student_1, receiver_req=coord_3)
req_let2 = StudentLetterRequest(sender_req=student_2, receiver_req=coord_3)

req_let1.save()
req_let2.save()

### _________________
### ACCEPTANCE LETTER

student_accept_1 = AcceptanceLetter(sender_acept=student_1, receiver_acept=coord_3, level='300', image='acceptance-letters/2023-acceptances/siwes/Science/Physics/l300/banner.jpg')
student_accept_2 = AcceptanceLetter(sender_acept=student_2, receiver_acept=coord_3, level='200', image='acceptance-letters/2023-acceptances/siwes/Science/Physics/l300/education.jpg')

student_accept_1.save()
student_accept_2.save()
