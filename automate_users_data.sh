#!/bin/bash
sv
rm account/migrations/*_initial.py
rm administrator/migrations/*_initial.py
rm chat/migrations/*_initial.py
rm db.sqlite3 && pmake && pmigrate

python manage.py shell

import os
import json
import random
from datetime import datetime
from toolkit import (picture_name, y_session)
from toolkit.decorators import (
    block_student_update_profile, restrict_access_student_profile, val_id_num, check_phone_number, admin_required, dean_required, hod_required, coordinator_required, supervisor_required, schoolstaff_required, student_required, supervisor_or_student_required, coordinator_or_supervisor_or_student_required
)
from chat.models import Message
from administrator.models import Administrator
from administrator.all_models import(
    Session, Faculty, Department, SchoolVC, FacultyDean, DepartmentHOD, TrainingStudent, StudentSupervisor, DepartmentTrainingCoordinator, Letter, AcceptanceLetter, WeekReader, WeekScannedLogbook, CommentOnLogbook, StudentResult
)
from django.contrib.auth import get_user_model


dob = datetime.utcnow()
User = get_user_model()


# Session
curr_sess = Session(is_current_session=True)
curr_sess.save()


### _______________________
### ADMINISTRATOR (2 admin)
admin_user_1 = User.objects.create_superuser(
    first_name='Olagoke', last_name='Abdul', identification_num='19992000', email='olagokeabdul@yahoo.com', phone_number='+2348144807200', date_of_birth=dob, is_superuser=True, is_staff=True, is_admin=True, is_schoolstaff=True, password='19991125u')
admin_user_2 = User.objects.create_superuser(
    first_name='Ahmad', middle_name='Aliyu', last_name='Aminu', identification_num='20151889', email='ahmadaliyu@yahoo.com', phone_number='+2348144807201', date_of_birth=dob, is_superuser=True, is_staff=True, is_admin=True, is_schoolstaff=True) # user_password_not_set

admin_user_1.save()
admin_user_2.save()


### _____________________
### FACULTY (4 faculties)

with open('faculty_and_department.json') as f:
    json_data = json.load(f)

for i in json_data:
    if i['faculty'] == 'Education':
        faculty_training = Faculty(name=i['faculty'], email=i['faculty']+'@mail.com', phone_number=i['phone'], training='tp')
    else:
        faculty_training = Faculty(name=i['faculty'], email=i['faculty']+'@mail.com', phone_number=i['phone'])
    faculty_training.save()

faculty_1 = Faculty.objects.filter(name='Science').first()
faculty_2 = Faculty.objects.filter(name='Humanities').first()
faculty_3 = Faculty.objects.filter(name='Education').first()
faculty_4 = Faculty.objects.filter(name='Management & social science').first()

### ___________________________
### DEPARTMENT (32 departments)

for idx, i in enumerate(json_data):
    filt_faculty = Faculty.objects.filter(name=json_data[idx]['faculty']).first()
    for j in json_data[idx]['department']:
        rand_num = random.randrange(300, 3000)
        new_dept = Department(name=j, email=j+'@mail.com', phone_number='+234'+str(rand_num)+j, faculty=filt_faculty)
        new_dept.save()

# Science
dept_1 = Department.objects.filter(name='Physics').first()
dept_2 = Department.objects.filter(name='Computer Science').first()
dept_3 = Department.objects.filter(name='Mathematics').first()
dept_4 = Department.objects.filter(name='Chemistry').first()
dept_5 = Department.objects.filter(name='Biochemistry').first()
dept_6 = Department.objects.filter(name='Geology').first()
dept_7 = Department.objects.filter(name='Microbiology').first()
dept_8 = Department.objects.filter(name='Plant science & biotechnology').first()
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
# Management & social science
dept_27 = Department.objects.filter(name='Accounting').first()
dept_28 = Department.objects.filter(name='Business Administration').first()
dept_29 = Department.objects.filter(name='Economics').first()
dept_30 = Department.objects.filter(name='Political science').first()
dept_31 = Department.objects.filter(name='Public Administration').first()
dept_32 = Department.objects.filter(name='Sociology').first()


### _____________________
### FACULTY DEAN (4 dean)
sch_vc_user = User.objects.create_user(
    first_name='Mu`azu', middle_name='Abubakar', last_name='Gusau', identification_num='20161777', email='amagusau@udusok.edu.ng', phone_number='+2348035052912', is_vc=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set

sch_vc_user.save()

#<!-- faculty dean -->
sch_vc = SchoolVC(
    vc=sch_vc_user, faculty=faculty_1, department=dept_1 , first_name=sch_vc_user.first_name, last_name=sch_vc_user.last_name, email=sch_vc_user.email, email_other='magusau@hotmail.com', phone_number=sch_vc_user.phone_number, phone_number_other='+2348181959199', id_no=sch_vc_user.identification_num, ranks='B.Sc (UDUS) M.Sc (Surrey UK), Ph.D (Surrey UK)', level_rank_title_1='Prof', level_rank_title_2='Ph.D', professorship='Professor of Toxicology', is_active=True)

sch_vc.save()


### _____________________
### FACULTY DEAN (4 dean)
dean_user_1 = User.objects.create_user(
    first_name='Ahmad', last_name='Galadima', identification_num='20161666', email='ahmadgaladima@yahoo.com', phone_number='+2348144807203', is_dean=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
dean_user_2 = User.objects.create_user(
    first_name='Sani', last_name='Aliyu', identification_num='20161667', email='sanialiyu@yahoo.com', phone_number='+2348144807204', is_dean=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
dean_user_3 = User.objects.create_user(
    first_name='Alameen', last_name='Sambo', identification_num='20161668', email='alameensambo@yahoo.com', phone_number='+2348144807205', is_dean=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
dean_user_4 = User.objects.create_user(
    first_name='Suraj', last_name='Haqil', identification_num='20161669', email='surajhaqil@yahoo.com', phone_number='+2348144807206', is_dean=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set

dean_user_1.save()
dean_user_2.save()
dean_user_3.save()
dean_user_4.save()

#<!-- faculty dean -->
dean_1 = FacultyDean(
    dean=dean_user_1, faculty=faculty_1, department=dept_1 , first_name=dean_user_1.first_name, last_name=dean_user_1.last_name, email=dean_user_1.email, phone_number=dean_user_1.phone_number, id_no=dean_user_1.identification_num, is_active=True)
dean_2 = FacultyDean(
    dean=dean_user_1, faculty=faculty_2, department=dept_12 , first_name=dean_user_2.first_name, last_name=dean_user_2.last_name, email=dean_user_2.email, phone_number=dean_user_2.phone_number, id_no=dean_user_2.identification_num, is_active=True)
dean_3 = FacultyDean(
    dean=dean_user_1, faculty=faculty_3, department=dept_25, first_name=dean_user_3.first_name, last_name=dean_user_3.last_name, email=dean_user_3.email, phone_number=dean_user_3.phone_number, id_no=dean_user_3.identification_num, is_active=True)
dean_4 = FacultyDean(
    dean=dean_user_1, faculty=faculty_4, department=dept_32, first_name=dean_user_4.first_name, last_name=dean_user_4.last_name, email=dean_user_4.email, phone_number=dean_user_4.phone_number, id_no=dean_user_4.identification_num, is_active=True)

dean_1.save()
dean_2.save()
dean_3.save()
dean_4.save()

### _______________________
### DEPARTMENT HOD (32 hod)
hod_user_1 = User.objects.create_user(
    first_name='Lawal', last_name='Saad', identification_num='20191999', email='lawalsaad@yahoo.com', phone_number='+2349036632603', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_2 = User.objects.create_user(
    first_name='Ahmad', last_name='Jabaka', identification_num='20191920', email='ahmadjabaka@yahoo.com', phone_number='+2349036632604', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_3 = User.objects.create_user(
    first_name='Emanuel', last_name='Omokuala', identification_num='20191921', email='emanuelomokuala@yahoo.com', phone_number='+2349036632615', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_4 = User.objects.create_user(
    first_name='Nasir', last_name='Sanusi', identification_num='20232021', email='nasirsanusi@yahoo.com', phone_number='+2348135632605', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_5 = User.objects.create_user(
    first_name='Ridwan', last_name='Saleh', identification_num='20232033', email='ridwansaleh@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_6 = User.objects.create_user(
    first_name='Lawal', last_name='Murana', identification_num='20232030', email='lawalmurana@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_7 = User.objects.create_user(
    first_name='Eddy', last_name='Brochu', identification_num='20232031', email='eddybrochu@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_8 = User.objects.create_user(
    first_name='Salman', last_name='Saif', identification_num='20232032', email='salmansaif@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_9 = User.objects.create_user(
    first_name='Mubarak', last_name='Wanka', identification_num='20232034', email='mubarakwanka@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_10 = User.objects.create_user(
    first_name='Suleman', last_name='Hotoro', identification_num='20232035', email='sulemanhotoro@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_11 = User.objects.create_user(
    first_name='Abdullahi', last_name='Salis', identification_num='20232036', email='abdullahisalis@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_12 = User.objects.create_user(
    first_name='Ahmad', last_name='Gusau', identification_num='20232037', email='ahmadgusau@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_13 = User.objects.create_user(
    first_name='Emanuel', last_name='Andy', identification_num='20232038', email='emanuelandy@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_14 = User.objects.create_user(
    first_name='Tsalha', last_name='Kurmi', identification_num='20232039', email='tsalhakurmi@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_15 = User.objects.create_user(
    first_name='Abdulaziz', last_name='Shuaib', identification_num='20232040', email='abdulazizshuaib@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_16 = User.objects.create_user(
    first_name='Isa', last_name='Nura', identification_num='20232041', email='isanura@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_17 = User.objects.create_user(
    first_name='Abdul', last_name='Ali', identification_num='20232077', email='abdulali@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_18 = User.objects.create_user(
    first_name='Saadu', last_name='Idris', identification_num='20232043', email='saaduidris@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_19 = User.objects.create_user(
    first_name='Muhsin', last_name='Salihu', identification_num='20232044', email='muhsinsalihu@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_20 = User.objects.create_user(
    first_name='Nasir', last_name='Garba', identification_num='20232045', email='nasirgarba@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_21 = User.objects.create_user(
    first_name='Mukhtar', last_name='Kamal', identification_num='20232046', email='mukhtarkamal@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_22 = User.objects.create_user(
    first_name='Lamido', last_name='Yahaya', identification_num='20232047', email='lamidoyahaya@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_23 = User.objects.create_user(
    first_name='Tukur', last_name='Ayuba', identification_num='20232048', email='tukurayuba@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_24 = User.objects.create_user(
    first_name='Hamza', last_name='Yahaya', identification_num='20232049', email='hamzayahaya@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_25 = User.objects.create_user(
    first_name='Ashafa', last_name='Halliru', identification_num='20232050', email='ashafahalliru@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_26 = User.objects.create_user(
    first_name='Labaran', last_name='Saleh', identification_num='20232051', email='labaransaleh@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_27 = User.objects.create_user(
    first_name='Nabil', last_name='Haruna', identification_num='20232052', email='nabilharuna@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_28 = User.objects.create_user(
    first_name='Buhari', last_name='Aminu', identification_num='20232053', email='buhariaminu@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_29 = User.objects.create_user(
    first_name='Adamu', last_name='Hasan', identification_num='20232054', email='adamuhasan@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_30 = User.objects.create_user(
    first_name='Ismail', last_name='Sani', identification_num='20232055', email='ismailsani@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_31 = User.objects.create_user(
    first_name='Shehu', last_name='Makeri', identification_num='20232056', email='shehumakeri@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
hod_user_32 = User.objects.create_user(first_name='Usman', last_name='Alamin', identification_num='20232057', email='usmanalamin@yahoo.com', phone_number='+2348135632633', is_hod=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set

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
hod_1 = DepartmentHOD(
    hod=hod_user_1, faculty=faculty_1, department=dept_1, first_name=hod_user_1.first_name, last_name=hod_user_1.last_name, email=hod_user_1.email, email_other='lawalsaad@fugusau.edu.ng', phone_number=hod_user_1.phone_number, phone_number_other='+2348097750488', id_no=hod_user_1.identification_num, ranks='B.Sc (Ed), (UDUSOK Nig); PGDIP (BUK, Nig.); Msc, PhD (USIM Malaysia); CFTO', level_rank_title_1='Dr', level_rank_title_2='Ph.D', is_active=True)
hod_2 = DepartmentHOD(
    hod=hod_user_2, faculty=faculty_1, department=dept_2, first_name=hod_user_2.first_name, last_name=hod_user_2.last_name, email=hod_user_2.email, phone_number=hod_user_2.phone_number, id_no=hod_user_2.identification_num, is_active=True)
hod_3 = DepartmentHOD(
    hod=hod_user_3, faculty=faculty_1, department=dept_3, first_name=hod_user_3.first_name, last_name=hod_user_3.last_name, email=hod_user_3.email, phone_number=hod_user_3.phone_number, id_no=hod_user_3.identification_num, is_active=True)
hod_4 = DepartmentHOD(
    hod=hod_user_4, faculty=faculty_1, department=dept_4, first_name=hod_user_4.first_name, last_name=hod_user_4.last_name, email=hod_user_4.email, phone_number=hod_user_4.phone_number, id_no=hod_user_4.identification_num, is_active=True)
hod_5 = DepartmentHOD(
    hod=hod_user_5, faculty=faculty_1, department=dept_5, first_name=hod_user_5.first_name, last_name=hod_user_5.last_name, email=hod_user_5.email, phone_number=hod_user_5.phone_number, id_no=hod_user_5.identification_num, is_active=True)
hod_6 = DepartmentHOD(
    hod=hod_user_6, faculty=faculty_1, department=dept_6, first_name=hod_user_6.first_name, last_name=hod_user_6.last_name, email=hod_user_6.email, phone_number=hod_user_6.phone_number, id_no=hod_user_6.identification_num, is_active=True)
hod_7 = DepartmentHOD(
    hod=hod_user_7, faculty=faculty_1, department=dept_7, first_name=hod_user_7.first_name, last_name=hod_user_7.last_name, email=hod_user_7.email, phone_number=hod_user_7.phone_number, id_no=hod_user_7.identification_num, is_active=True)
hod_8 = DepartmentHOD(
    hod=hod_user_8, faculty=faculty_1, department=dept_8, first_name=hod_user_8.first_name, last_name=hod_user_8.last_name, email=hod_user_8.email, phone_number=hod_user_8.phone_number, id_no=hod_user_8.identification_num, is_active=True)
hod_9 = DepartmentHOD(
    hod=hod_user_9, faculty=faculty_1, department=dept_9, first_name=hod_user_9.first_name, last_name=hod_user_9.last_name, email=hod_user_9.email, phone_number=hod_user_9.phone_number, id_no=hod_user_9.identification_num, is_active=True)
hod_10 = DepartmentHOD(
    hod=hod_user_10, faculty=faculty_1, department=dept_10, first_name=hod_user_10.first_name, last_name=hod_user_10.last_name, email=hod_user_10.email, phone_number=hod_user_10.phone_number, id_no=hod_user_10.identification_num, is_active=True)
hod_11 = DepartmentHOD(
    hod=hod_user_11, faculty=faculty_2, department=dept_11, first_name=hod_user_11.first_name, last_name=hod_user_11.last_name, email=hod_user_11.email, phone_number=hod_user_11.phone_number, id_no=hod_user_11.identification_num, is_active=True)
hod_12 = DepartmentHOD(
    hod=hod_user_12, faculty=faculty_2, department=dept_12, first_name=hod_user_12.first_name, last_name=hod_user_12.last_name, email=hod_user_12.email, phone_number=hod_user_12.phone_number, id_no=hod_user_12.identification_num, is_active=True)
hod_13 = DepartmentHOD(
    hod=hod_user_13, faculty=faculty_2, department=dept_13, first_name=hod_user_13.first_name, last_name=hod_user_13.last_name, email=hod_user_13.email, phone_number=hod_user_13.phone_number, id_no=hod_user_13.identification_num, is_active=True)
hod_14 = DepartmentHOD(
    hod=hod_user_14, faculty=faculty_2, department=dept_14, first_name=hod_user_14.first_name, last_name=hod_user_14.last_name, email=hod_user_14.email, phone_number=hod_user_14.phone_number, id_no=hod_user_14.identification_num, is_active=True)
hod_15 = DepartmentHOD(
    hod=hod_user_15, faculty=faculty_2, department=dept_15, first_name=hod_user_15.first_name, last_name=hod_user_15.last_name, email=hod_user_15.email, phone_number=hod_user_15.phone_number, id_no=hod_user_15.identification_num, is_active=True)
hod_16 = DepartmentHOD(
    hod=hod_user_16, faculty=faculty_2, department=dept_16, first_name=hod_user_16.first_name, last_name=hod_user_16.last_name, email=hod_user_16.email, phone_number=hod_user_16.phone_number, id_no=hod_user_16.identification_num, is_active=True)
hod_17 = DepartmentHOD(
    hod=hod_user_17, faculty=faculty_3, department=dept_17, first_name=hod_user_17.first_name, last_name=hod_user_17.last_name, email=hod_user_17.email, phone_number=hod_user_17.phone_number, id_no=hod_user_17.identification_num, is_active=True)
hod_18 = DepartmentHOD(
    hod=hod_user_18, faculty=faculty_3, department=dept_18, first_name=hod_user_18.first_name, last_name=hod_user_18.last_name, email=hod_user_18.email, phone_number=hod_user_18.phone_number, id_no=hod_user_18.identification_num, is_active=True)
hod_19 = DepartmentHOD(
    hod=hod_user_19, faculty=faculty_3, department=dept_19, first_name=hod_user_19.first_name, last_name=hod_user_19.last_name, email=hod_user_19.email, phone_number=hod_user_19.phone_number, id_no=hod_user_19.identification_num, is_active=True)
hod_20 = DepartmentHOD(
    hod=hod_user_20, faculty=faculty_3, department=dept_20, first_name=hod_user_20.first_name, last_name=hod_user_20.last_name, email=hod_user_20.email, phone_number=hod_user_20.phone_number, id_no=hod_user_20.identification_num, is_active=True)
hod_21 = DepartmentHOD(
    hod=hod_user_21, faculty=faculty_3, department=dept_21, first_name=hod_user_21.first_name, last_name=hod_user_21.last_name, email=hod_user_21.email, phone_number=hod_user_21.phone_number, id_no=hod_user_21.identification_num, is_active=True)
hod_22 = DepartmentHOD(
    hod=hod_user_22, faculty=faculty_3, department=dept_22, first_name=hod_user_22.first_name, last_name=hod_user_22.last_name, email=hod_user_22.email, phone_number=hod_user_22.phone_number, id_no=hod_user_22.identification_num, is_active=True)
hod_23 = DepartmentHOD(
    hod=hod_user_23, faculty=faculty_3, department=dept_23, first_name=hod_user_23.first_name, last_name=hod_user_23.last_name, email=hod_user_23.email, phone_number=hod_user_23.phone_number, id_no=hod_user_23.identification_num, is_active=True)
hod_24 = DepartmentHOD(
    hod=hod_user_24, faculty=faculty_3, department=dept_24, first_name=hod_user_24.first_name, last_name=hod_user_24.last_name, email=hod_user_24.email, phone_number=hod_user_24.phone_number, id_no=hod_user_24.identification_num, is_active=True)
hod_25 = DepartmentHOD(
    hod=hod_user_25, faculty=faculty_3, department=dept_25, first_name=hod_user_25.first_name, last_name=hod_user_25.last_name, email=hod_user_25.email, phone_number=hod_user_25.phone_number, id_no=hod_user_25.identification_num, is_active=True)
hod_26 = DepartmentHOD(
    hod=hod_user_26, faculty=faculty_3, department=dept_26, first_name=hod_user_26.first_name, last_name=hod_user_26.last_name, email=hod_user_26.email, phone_number=hod_user_26.phone_number, id_no=hod_user_26.identification_num, is_active=True)
hod_27 = DepartmentHOD(
    hod=hod_user_27, faculty=faculty_4, department=dept_27, first_name=hod_user_27.first_name, last_name=hod_user_27.last_name, email=hod_user_27.email, phone_number=hod_user_27.phone_number, id_no=hod_user_27.identification_num, is_active=True)
hod_28 = DepartmentHOD(
    hod=hod_user_28, faculty=faculty_4, department=dept_28, first_name=hod_user_28.first_name, last_name=hod_user_28.last_name, email=hod_user_28.email, phone_number=hod_user_28.phone_number, id_no=hod_user_28.identification_num, is_active=True)
hod_29 = DepartmentHOD(
    hod=hod_user_29, faculty=faculty_4, department=dept_29, first_name=hod_user_29.first_name, last_name=hod_user_29.last_name, email=hod_user_29.email, phone_number=hod_user_29.phone_number, id_no=hod_user_29.identification_num, is_active=True)
hod_30 = DepartmentHOD(
    hod=hod_user_30, faculty=faculty_4, department=dept_30, first_name=hod_user_30.first_name, last_name=hod_user_30.last_name, email=hod_user_30.email, phone_number=hod_user_30.phone_number, id_no=hod_user_30.identification_num, is_active=True)
hod_31 = DepartmentHOD(
    hod=hod_user_31, faculty=faculty_4, department=dept_31, first_name=hod_user_31.first_name, last_name=hod_user_31.last_name, email=hod_user_31.email, phone_number=hod_user_31.phone_number, id_no=hod_user_31.identification_num, is_active=True)
hod_32 = DepartmentHOD(
    hod=hod_user_32, faculty=faculty_4, department=dept_32, first_name=hod_user_32.first_name, last_name=hod_user_32.last_name, email=hod_user_32.email, phone_number=hod_user_32.phone_number, id_no=hod_user_32.identification_num, is_active=True)

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
coord_user_1 = User.objects.create_user(
    first_name='Okoye', last_name='Francis', middle_name='Ikechukwu', identification_num='202320241', email='okoyeikechukwu@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, password='19991125u', is_schoolstaff=True)
coord_user_2 = User.objects.create_user(
    first_name='Adamu', last_name='Samaila', identification_num='202320242', email='adamusamaila@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_3 = User.objects.create_user(
    first_name='Auta', last_name='Baita', identification_num='202320243', email='autabaita@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_4 = User.objects.create_user(
    first_name='Sagir', last_name='Bello', identification_num='202320244', email='sagirbello@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_5 = User.objects.create_user(
    first_name='Nura', last_name='Hamisu', identification_num='202320245', email='nurahamisu@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_6 = User.objects.create_user(
    first_name='Saad', last_name='Abdul', identification_num='202320246', email='saadabdul@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_7 = User.objects.create_user(
    first_name='Nawabu', last_name='Hakeem', identification_num='202320247', email='nawabuhakeem@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_8 = User.objects.create_user(
    first_name='Iyal', last_name='Usman', identification_num='202320248', email='iyalusman@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_9 = User.objects.create_user(
    first_name='Gambo', last_name='Ganji', identification_num='202320249', email='gambogamji@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_10 = User.objects.create_user(
    first_name='Lawwali', last_name='Nura', identification_num='2023202410', email='lawwalinura@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_11 = User.objects.create_user(
    first_name='Emmanuel', last_name='Seth', identification_num='2023202411', email='emmanuelseth@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_12 = User.objects.create_user(
    first_name='Saeed', last_name='Hashim', identification_num='2023202412', email='saeedhashim@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_13 = User.objects.create_user(
    first_name='Saminu', last_name='Yau', identification_num='2023202413', email='saminuyau@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_14 = User.objects.create_user(
    first_name='Tahir', last_name='Idris', identification_num='2023202414', email='tahiridris@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_15 = User.objects.create_user(
    first_name='Sunday', last_name='Abdul', identification_num='2023202415', email='sundayabdul@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_16 = User.objects.create_user(
    first_name='Idris', last_name='Bala', identification_num='2023202416', email='idrisbala@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_17 = User.objects.create_user(
    first_name='Yusuf', last_name='Dare', identification_num='2023202417', email='yusufdare@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_18 = User.objects.create_user(
    first_name='Yakubu', last_name='Dauda', identification_num='2023202418', email='yakubudauda@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_19 = User.objects.create_user(
    first_name='Salisu', last_name='Nura', identification_num='2023202419', email='salisunura@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_20 = User.objects.create_user(
    first_name='Nura', last_name='Sadik', identification_num='2023202420', email='nurasadik@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_21 = User.objects.create_user(
    first_name='Idris', last_name='Lawal', identification_num='2023202421', email='idrislawal@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_22 = User.objects.create_user(
    first_name='Saminu', last_name='Saeed', identification_num='2023202422', email='saminusaeed@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_23 = User.objects.create_user(
    first_name='Isya', last_name='Ali', identification_num='2023202423', email='isyaali@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_24 = User.objects.create_user(
    first_name='Tamim', last_name='Sule', identification_num='2023202424', email='tamimsule@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_25 = User.objects.create_user(
    first_name='Idris', last_name='Pakistan', identification_num='2023202425', email='idrispakistan@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_26 = User.objects.create_user(
    first_name='Auwal', last_name='Nasiru', identification_num='2023202426', email='auwalnasiru@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_27 = User.objects.create_user(
    first_name='Mubarak', last_name='Shehu', identification_num='2023202427', email='mubarakshehu@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_28 = User.objects.create_user(
    first_name='Yusuf', last_name='Akande', identification_num='2023202428', email='yusufakande@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_29 = User.objects.create_user(
    first_name='Tsalha', last_name='Usman', identification_num='2023202429', email='tsalhausman@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_30 = User.objects.create_user(
    first_name='Ayuba', last_name='Mani', identification_num='2023202430', email='ayubamani@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_31 = User.objects.create_user(
    first_name='Samaila', last_name='Ahmad', identification_num='2023202431', email='samailaahmad@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
coord_user_32 = User.objects.create_user(
    first_name='Abdurrahman', last_name='Zakiru', identification_num='2023202432', email='abdurrahmanzakiru@yahoo.com', phone_number='+2348135632603', is_coordinator=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set

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

# training coordinator models
coord_1 = DepartmentTrainingCoordinator(
    coordinator=coord_user_1, faculty=faculty_1, department=dept_1, dept_hod=hod_1, first_name=coord_user_1.first_name, middle_name=coord_user_1.middle_name, last_name=coord_user_1.last_name, email=coord_user_1.email, phone_number=coord_user_1.phone_number, id_no=coord_user_1.identification_num, is_active=True)
coord_2 = DepartmentTrainingCoordinator(
    coordinator=coord_user_2, faculty=faculty_1, department=dept_2, dept_hod=hod_2, first_name=coord_user_2.first_name, last_name=coord_user_2.last_name, email=coord_user_2.email, phone_number=coord_user_2.phone_number, id_no=coord_user_2.identification_num, is_active=True)
coord_3 = DepartmentTrainingCoordinator(
    coordinator=coord_user_3, faculty=faculty_1, department=dept_3, dept_hod=hod_3, first_name=coord_user_3.first_name, last_name=coord_user_3.last_name, email=coord_user_3.email, phone_number=coord_user_3.phone_number, id_no=coord_user_3.identification_num, is_active=True)
coord_4 = DepartmentTrainingCoordinator(
    coordinator=coord_user_4, faculty=faculty_1, department=dept_4, dept_hod=hod_4, first_name=coord_user_4.first_name, last_name=coord_user_4.last_name, email=coord_user_4.email, phone_number=coord_user_4.phone_number, id_no=coord_user_4.identification_num, is_active=True)
coord_5 = DepartmentTrainingCoordinator(
    coordinator=coord_user_5, faculty=faculty_1, department=dept_5, dept_hod=hod_5, first_name=coord_user_5.first_name, last_name=coord_user_5.last_name, email=coord_user_5.email, phone_number=coord_user_5.phone_number, id_no=coord_user_5.identification_num, is_active=True)
coord_6 = DepartmentTrainingCoordinator(
    coordinator=coord_user_6, faculty=faculty_1, department=dept_6, dept_hod=hod_6, first_name=coord_user_6.first_name, last_name=coord_user_6.last_name, email=coord_user_6.email, phone_number=coord_user_6.phone_number, id_no=coord_user_6.identification_num, is_active=True)
coord_7 = DepartmentTrainingCoordinator(
    coordinator=coord_user_7, faculty=faculty_1, department=dept_7, dept_hod=hod_7, first_name=coord_user_7.first_name, last_name=coord_user_7.last_name, email=coord_user_7.email, phone_number=coord_user_7.phone_number, id_no=coord_user_7.identification_num, is_active=True)
coord_8 = DepartmentTrainingCoordinator(
    coordinator=coord_user_8, faculty=faculty_1, department=dept_8, dept_hod=hod_8, first_name=coord_user_8.first_name, last_name=coord_user_8.last_name, email=coord_user_8.email, phone_number=coord_user_8.phone_number, id_no=coord_user_8.identification_num, is_active=True)
coord_9 = DepartmentTrainingCoordinator(
    coordinator=coord_user_9, faculty=faculty_1, department=dept_9, dept_hod=hod_9, first_name=coord_user_9.first_name, last_name=coord_user_9.last_name, email=coord_user_9.email, phone_number=coord_user_9.phone_number, id_no=coord_user_9.identification_num, is_active=True)
coord_10 = DepartmentTrainingCoordinator(
    coordinator=coord_user_10, faculty=faculty_1, department=dept_10, dept_hod=hod_10, first_name=coord_user_10.first_name, last_name=coord_user_10.last_name, email=coord_user_10.email, phone_number=coord_user_10.phone_number, id_no=coord_user_10.identification_num, is_active=True)
coord_11 = DepartmentTrainingCoordinator(
    coordinator=coord_user_11, faculty=faculty_2, department=dept_11, dept_hod=hod_11, first_name=coord_user_11.first_name, last_name=coord_user_11.last_name, email=coord_user_11.email, phone_number=coord_user_11.phone_number, id_no=coord_user_11.identification_num, is_active=True)
coord_12 = DepartmentTrainingCoordinator(
    coordinator=coord_user_12, faculty=faculty_2, department=dept_12, dept_hod=hod_12, first_name=coord_user_12.first_name, last_name=coord_user_12.last_name, email=coord_user_12.email, phone_number=coord_user_12.phone_number, id_no=coord_user_12.identification_num, is_active=True)
coord_13 = DepartmentTrainingCoordinator(
    coordinator=coord_user_13, faculty=faculty_2, department=dept_13, dept_hod=hod_13, first_name=coord_user_13.first_name, last_name=coord_user_13.last_name, email=coord_user_13.email, phone_number=coord_user_13.phone_number, id_no=coord_user_13.identification_num, is_active=True)
coord_14 = DepartmentTrainingCoordinator(
    coordinator=coord_user_14, faculty=faculty_2, department=dept_14, dept_hod=hod_14, first_name=coord_user_14.first_name, last_name=coord_user_14.last_name, email=coord_user_14.email, phone_number=coord_user_14.phone_number, id_no=coord_user_14.identification_num, is_active=True)
coord_15 = DepartmentTrainingCoordinator(
    coordinator=coord_user_15, faculty=faculty_2, department=dept_15, dept_hod=hod_15, first_name=coord_user_15.first_name, last_name=coord_user_15.last_name, email=coord_user_15.email, phone_number=coord_user_15.phone_number, id_no=coord_user_15.identification_num, is_active=True)
coord_16 = DepartmentTrainingCoordinator(
    coordinator=coord_user_16, faculty=faculty_2, department=dept_16, dept_hod=hod_16, first_name=coord_user_16.first_name, last_name=coord_user_16.last_name, email=coord_user_16.email, phone_number=coord_user_16.phone_number, id_no=coord_user_16.identification_num, is_active=True)
coord_17 = DepartmentTrainingCoordinator(
    coordinator=coord_user_17, faculty=faculty_3, department=dept_17, dept_hod=hod_17, first_name=coord_user_17.first_name, last_name=coord_user_17.last_name, email=coord_user_17.email, phone_number=coord_user_17.phone_number, id_no=coord_user_17.identification_num, is_active=True)
coord_18 = DepartmentTrainingCoordinator(
    coordinator=coord_user_18, faculty=faculty_3, department=dept_18, dept_hod=hod_18, first_name=coord_user_18.first_name, last_name=coord_user_18.last_name, email=coord_user_18.email, phone_number=coord_user_18.phone_number, id_no=coord_user_18.identification_num, is_active=True)
coord_19 = DepartmentTrainingCoordinator(
    coordinator=coord_user_19, faculty=faculty_3, department=dept_19, dept_hod=hod_19, first_name=coord_user_19.first_name, last_name=coord_user_19.last_name, email=coord_user_19.email, phone_number=coord_user_19.phone_number, id_no=coord_user_19.identification_num, is_active=True)
coord_20 = DepartmentTrainingCoordinator(
    coordinator=coord_user_20, faculty=faculty_3, department=dept_20, dept_hod=hod_20, first_name=coord_user_20.first_name, last_name=coord_user_20.last_name, email=coord_user_20.email, phone_number=coord_user_20.phone_number, id_no=coord_user_20.identification_num, is_active=True)
coord_21 = DepartmentTrainingCoordinator(
    coordinator=coord_user_21, faculty=faculty_3, department=dept_21, dept_hod=hod_21, first_name=coord_user_21.first_name, last_name=coord_user_21.last_name, email=coord_user_21.email, phone_number=coord_user_21.phone_number, id_no=coord_user_21.identification_num, is_active=True)
coord_22 = DepartmentTrainingCoordinator(
    coordinator=coord_user_22, faculty=faculty_3, department=dept_22, dept_hod=hod_22, first_name=coord_user_22.first_name, last_name=coord_user_22.last_name, email=coord_user_22.email, phone_number=coord_user_22.phone_number, id_no=coord_user_22.identification_num, is_active=True)
coord_23 = DepartmentTrainingCoordinator(
    coordinator=coord_user_23, faculty=faculty_3, department=dept_23, dept_hod=hod_23, first_name=coord_user_23.first_name, last_name=coord_user_23.last_name, email=coord_user_23.email, phone_number=coord_user_23.phone_number, id_no=coord_user_23.identification_num, is_active=True)
coord_24 = DepartmentTrainingCoordinator(
    coordinator=coord_user_24, faculty=faculty_3, department=dept_24, dept_hod=hod_24, first_name=coord_user_24.first_name, last_name=coord_user_24.last_name, email=coord_user_24.email, phone_number=coord_user_24.phone_number, id_no=coord_user_24.identification_num, is_active=True)
coord_25 = DepartmentTrainingCoordinator(
    coordinator=coord_user_25, faculty=faculty_3, department=dept_25, dept_hod=hod_25, first_name=coord_user_25.first_name, last_name=coord_user_25.last_name, email=coord_user_25.email, phone_number=coord_user_25.phone_number, id_no=coord_user_25.identification_num, is_active=True)
coord_26 = DepartmentTrainingCoordinator(
    coordinator=coord_user_26, faculty=faculty_3, department=dept_26, dept_hod=hod_26, first_name=coord_user_26.first_name, last_name=coord_user_26.last_name, email=coord_user_26.email, phone_number=coord_user_26.phone_number, id_no=coord_user_26.identification_num, is_active=True)
coord_27 = DepartmentTrainingCoordinator(
    coordinator=coord_user_27, faculty=faculty_4, department=dept_27, dept_hod=hod_27, first_name=coord_user_27.first_name, last_name=coord_user_27.last_name, email=coord_user_27.email, phone_number=coord_user_27.phone_number, id_no=coord_user_27.identification_num, is_active=True)
coord_28 = DepartmentTrainingCoordinator(
    coordinator=coord_user_28, faculty=faculty_4, department=dept_28, dept_hod=hod_28, first_name=coord_user_28.first_name, last_name=coord_user_28.last_name, email=coord_user_28.email, phone_number=coord_user_28.phone_number, id_no=coord_user_28.identification_num, is_active=True)
coord_29 = DepartmentTrainingCoordinator(
    coordinator=coord_user_29, faculty=faculty_4, department=dept_29, dept_hod=hod_29, first_name=coord_user_29.first_name, last_name=coord_user_29.last_name, email=coord_user_29.email, phone_number=coord_user_29.phone_number, id_no=coord_user_29.identification_num, is_active=True)
coord_30 = DepartmentTrainingCoordinator(
    coordinator=coord_user_30, faculty=faculty_4, department=dept_30, dept_hod=hod_30, first_name=coord_user_30.first_name, last_name=coord_user_30.last_name, email=coord_user_30.email, phone_number=coord_user_30.phone_number, id_no=coord_user_30.identification_num, is_active=True)
coord_31 = DepartmentTrainingCoordinator(
    coordinator=coord_user_31, faculty=faculty_4, department=dept_31, dept_hod=hod_31, first_name=coord_user_31.first_name, last_name=coord_user_31.last_name, email=coord_user_31.email, phone_number=coord_user_31.phone_number, id_no=coord_user_31.identification_num, is_active=True)
coord_32 = DepartmentTrainingCoordinator(
    coordinator=coord_user_32, faculty=faculty_4, department=dept_32, dept_hod=hod_32, first_name=coord_user_32.first_name, last_name=coord_user_32.last_name, email=coord_user_32.email, phone_number=coord_user_32.phone_number, id_no=coord_user_32.identification_num, is_active=True)

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
sup_user_1 = User.objects.create_user(
    first_name='Fawaz', last_name='Saad', identification_num='20052006', email='fawazsaad@yahoo.com', phone_number='+2349036632603', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True, password='19991125u')
sup_user_2 = User.objects.create_user(
    first_name='Jibril', last_name='Jabaka', identification_num='20062007', email='jibriljabaka@yahoo.com', phone_number='+2349036632604', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_3 = User.objects.create_user(
    first_name='Yahuza', last_name='Mubarak', identification_num='20072008', email='yahuzamubarak@yahoo.com', phone_number='+2349036632615', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_4 = User.objects.create_user(
    first_name='Kallah', last_name='Sanusi', identification_num='20082009', email='kallahsanusi@yahoo.com', phone_number='+2348135632605', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_5 = User.objects.create_user(
    first_name='Ayuba', last_name='Okonjo', identification_num='20092010', email='ayubaokonjo@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_6 = User.objects.create_user(
    first_name='Labaran', last_name='Lawal', identification_num='200920106', email='labaranlawal@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_7 = User.objects.create_user(
    first_name='Samaila', last_name='Yusuf', identification_num='200920107', email='samailayusuf@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_8 = User.objects.create_user(
    first_name='Mustapha', last_name='Salis', identification_num='200920108', email='mustaphasalis@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_9 = User.objects.create_user(
    first_name='Usman', last_name='Ahmad', identification_num='200920109', email='usmanahmad@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_10 = User.objects.create_user(
    first_name='Nazifi', last_name='Ali', identification_num='2009201010', email='nazifiali@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_11 = User.objects.create_user(
    first_name='Obaja', last_name='Tukur', identification_num='2009201011', email='obajatukur@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_12 = User.objects.create_user(
    first_name='Lawal', last_name='Abdul', identification_num='2009201012', email='lawalabdul@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_13 = User.objects.create_user(
    first_name='Nura', last_name='Omar', identification_num='2009201013', email='nuraomar@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_14 = User.objects.create_user(
    first_name='Suleman', last_name='Sani', identification_num='2009201014', email='sulemansani@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_15 = User.objects.create_user(
    first_name='Muhsin', last_name='Baffa', identification_num='2009201015', email='muhsinbaffa@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_16 = User.objects.create_user(
    first_name='Abdul', last_name='Gamji', identification_num='2009201016', email='abdulgamji@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_17 = User.objects.create_user(
    first_name='Idris', last_name='Hanwa', identification_num='2009201017', email='idrishanwa@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_18 = User.objects.create_user(
    first_name='Laminu', last_name='Saeed', identification_num='2009201018', email='laminusaeed@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_19 = User.objects.create_user(
    first_name='Nura', last_name='Labaran', identification_num='2009201019', email='nuralabaran@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_20 = User.objects.create_user(
    first_name='Tukur', last_name='Sani', identification_num='2009201020', email='tukursani@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_21 = User.objects.create_user(
    first_name='Adamu', last_name='Surajo', identification_num='2009201021', email='adamusurajo@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_22 = User.objects.create_user(
    first_name='Hasan', last_name='Sani', identification_num='2009201022', email='hasansani@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_23 = User.objects.create_user(
    first_name='Husain', last_name='Sani', identification_num='2009201023', email='husainsani@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_24 = User.objects.create_user(
    first_name='Gambo', last_name='Sani', identification_num='2009201024', email='gambosani@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_25 = User.objects.create_user(
    first_name='Ilya', last_name='Abbah', identification_num='2009201025', email='ilyaabbah@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_26 = User.objects.create_user(
    first_name='Yahaya', last_name='Sule', identification_num='2009201026', email='yahayasule@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_27 = User.objects.create_user(
    first_name='Abbas', last_name='Lawal', identification_num='2009201027', email='abbaslawal@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_28 = User.objects.create_user(
    first_name='Nura', last_name='Khalid', identification_num='2009201028', email='nurakhalid@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_29 = User.objects.create_user(
    first_name='Ibrahim', last_name='Bala', identification_num='2009201029', email='ibrahimbala@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_30 = User.objects.create_user(
    first_name='Sani', last_name='Momo', identification_num='2009201030', email='sanimomo@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_31 = User.objects.create_user(
    first_name='Lukman', last_name='Surajo', identification_num='2009201031', email='lukmansurajo@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_32 = User.objects.create_user(
    first_name='Aliyu', last_name='Nalado', identification_num='2009201032', email='aliyunalado@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_33 = User.objects.create_user(
    first_name='Usman', last_name='Tukur', identification_num='2009201033', email='usmantukur@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_34 = User.objects.create_user(
    first_name='Labaran', last_name='Sani', identification_num='2009201034', email='labaransani@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_35 = User.objects.create_user(
    first_name='Lamido', last_name='Hayee', identification_num='2009201035', email='lamidohayee@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_36 = User.objects.create_user(
    first_name='Idris', last_name='Walid', identification_num='2009201036', email='idriswalid@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_37 = User.objects.create_user(
    first_name='Mustafa', last_name='Gusau', identification_num='2009201037', email='mustafagusau@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_38 = User.objects.create_user(
    first_name='Tambai', last_name='Salisu', identification_num='2009201038', email='tambaisalisu@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_39 = User.objects.create_user(
    first_name='Nasir', last_name='Nass', identification_num='2009201039', email='nasirnass@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_40 = User.objects.create_user(
    first_name='Muhamad', last_name='Ali', identification_num='2009201040', email='muhammadali@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_41 = User.objects.create_user(
    first_name='Lawal', last_name='Yusuf', identification_num='2009201041', email='lawalyusuf@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_42 = User.objects.create_user(
    first_name='Seth', last_name='Olade', identification_num='2009201042', email='setholade@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_43 = User.objects.create_user(
    first_name='Samran', last_name='Ali', identification_num='2009201043', email='samranali@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_44 = User.objects.create_user(
    first_name='Imran', last_name='Yusuf', identification_num='2009201044', email='imranyusuf@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_45 = User.objects.create_user(
    first_name='Anas', last_name='Yau', identification_num='2009201045', email='anasyau@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_46 = User.objects.create_user(
    first_name='Salihu', last_name='Balaro', identification_num='2009201046', email='salihubalaro@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_47 = User.objects.create_user(
    first_name='Khamis', last_name='Lukman', identification_num='2009201047', email='khamislukman@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_48 = User.objects.create_user(
    first_name='Nura', last_name='Salim', identification_num='2009201048', email='nurasalim@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_49 = User.objects.create_user(
    first_name='Fahad', last_name='Abdul', identification_num='2009201049', email='fahadabdul@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_50 = User.objects.create_user(
    first_name='Fareed', last_name='Sani', identification_num='2009201050', email='fareedsani@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_51 = User.objects.create_user(
    first_name='Alhazai', last_name='Ilya', identification_num='2009201051', email='alhazaiilya@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_52 = User.objects.create_user(
    first_name='Mansir', last_name='Fahad', identification_num='2009201052', email='mansirfahad@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_53 = User.objects.create_user(
    first_name='Hafiz', last_name='Sani', identification_num='2009201053', email='hafizsani@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_54 = User.objects.create_user(
    first_name='Murtala', last_name='Uba', identification_num='2009201054', email='murtalauba@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_55 = User.objects.create_user(
    first_name='Ubale', last_name='Yusuf', identification_num='2009201055', email='ubaleyusuf@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_56 = User.objects.create_user(
    first_name='Samaila', last_name='Nasir', identification_num='2009201056', email='samailanasir@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_57 = User.objects.create_user(
    first_name='Babangida', last_name='Hafiz', identification_num='2009201057', email='babangidahafiz@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_58 = User.objects.create_user(
    first_name='Yusuf', last_name='Faruk', identification_num='2009201058', email='yusuffaruk@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_59 = User.objects.create_user(
    first_name='Muntari', last_name='Dankasuwa', identification_num='2009201059', email='muntaridankasuwa@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_60 = User.objects.create_user(
    first_name='Ahmad', last_name='Usmanu', identification_num='2009201060', email='ahmadusmanu@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_61 = User.objects.create_user(
    first_name='Lawi', last_name='Zailani', identification_num='2009201061', email='lawizailani@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_62 = User.objects.create_user(
    first_name='Faruk', last_name='Usman', identification_num='2009201062', email='farukusman@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_63 = User.objects.create_user(
    first_name='Fareed', last_name='Lawal', identification_num='2009201063', email='fareedlawal@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_64 = User.objects.create_user(
    first_name='Nura', last_name='Yusuf', identification_num='2009201064', email='nurayusuf@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_65 = User.objects.create_user(
    first_name='Babagana', last_name='Salisu', identification_num='2009201065', email='babaganasalisu@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_66 = User.objects.create_user(
    first_name='Muhsin', last_name='Gazali', identification_num='2009201066', email='muhsingazali@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_67 = User.objects.create_user(
    first_name='Tamim', last_name='Saleh', identification_num='2009201067', email='tamimsaleh@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_68 = User.objects.create_user(
    first_name='Ubale', last_name='Yawale', identification_num='2009201068', email='ubaleyawale@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_69 = User.objects.create_user(
    first_name='Lukman', last_name='Usman', identification_num='2009201069', email='lukmanusman@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_70 = User.objects.create_user(
    first_name='Abbas', last_name='Akande', identification_num='2009201070', email='abbasakande@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_71 = User.objects.create_user(
    first_name='Idris', last_name='Sule', identification_num='2009201071', email='idrissule@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_72 = User.objects.create_user(
    first_name='Mufeed', last_name='Sani', identification_num='2009201072', email='mufeedsani@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_73 = User.objects.create_user(
    first_name='Naziru', last_name='Musa', identification_num='2009201073', email='nazirumusa@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_74 = User.objects.create_user(
    first_name='Bello', last_name='Kaku', identification_num='2009201074', email='bellokaku@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_75 = User.objects.create_user(
    first_name='Mukhtar', last_name='Hamza', identification_num='2009201075', email='mukhtarhamza@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_76 = User.objects.create_user(
    first_name='Balaro', last_name='Ahmad', identification_num='2009201076', email='balaroahmad@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_77 = User.objects.create_user(
    first_name='Saeed', last_name='Lukman', identification_num='2009201077', email='saeedlukman@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_78 = User.objects.create_user(
    first_name='Fawaz', last_name='Jawad', identification_num='2009201078', email='fawazjawad@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_79 = User.objects.create_user(
    first_name='Haruna', last_name='Kotarkoshi', identification_num='2009201079', email='harunakotarkoshi@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_80 = User.objects.create_user(
    first_name='Fahad', last_name='Malam', identification_num='2009201080', email='fahadmalam@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_81 = User.objects.create_user(
    first_name='Ilya', last_name='Adam', identification_num='2009201081', email='ilyaadam@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_82 = User.objects.create_user(
    first_name='Lawal', last_name='Usman', identification_num='2009201082', email='lawalsani@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_83 = User.objects.create_user(
    first_name='Habib', last_name='Ibrahim', identification_num='2009201083', email='habibibrahim@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_84 = User.objects.create_user(
    first_name='Idris', last_name='Danjuma', identification_num='2009201084', email='idrisdanjuma@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_85 = User.objects.create_user(
    first_name='Ayuba', last_name='Tukur', identification_num='2009201085', email='ayubatukur@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_86 = User.objects.create_user(
    first_name='Labaran', last_name='Lukman', identification_num='2009201086', email='labaranlukman@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_87 = User.objects.create_user(
    first_name='Sani', last_name='Ashiru', identification_num='2009201087', email='saniashiru@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_88 = User.objects.create_user(
    first_name='Faruk', last_name='Bala', identification_num='2009201088', email='farukbala@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_89 = User.objects.create_user(
    first_name='Adam', last_name='Habib', identification_num='2009201089', email='adamhabib@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_90 = User.objects.create_user(
    first_name='Buhari', last_name='Maidoki', identification_num='2009201090', email='buharimaidoki@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_91 = User.objects.create_user(
    first_name='Sale', last_name='Usman', identification_num='2009201091', email='saleusman@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_92 = User.objects.create_user(
    first_name='Sulaiman', last_name='Ahmad', identification_num='2009201092', email='sulaimanahmad@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_93 = User.objects.create_user(
    first_name='Bashir', last_name='Kotarkoshi', identification_num='2009201093', email='bashirkotarkoshi@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_94 = User.objects.create_user(
    first_name='Bala', last_name='Usman', identification_num='2009201094', email='balausman@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_95 = User.objects.create_user(
    first_name='Buba', last_name='Awwal', identification_num='2009201095', email='bubaawwal@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set
sup_user_96 = User.objects.create_user(
    first_name='Sagir', last_name='Sani', identification_num='2009201096', email='sagirsani@yahoo.com', phone_number='+2348135632633', is_supervisor=True, date_of_birth=dob, is_schoolstaff=True) # user_password_not_set

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
super_1 = StudentSupervisor(
    supervisor=sup_user_1, first_name=sup_user_1.first_name, last_name=sup_user_1.last_name, email=sup_user_1.email, phone_number=sup_user_1.phone_number, id_no=sup_user_1.identification_num, small_desc='No. 118 anguwan shanu, gusau GRA Zamfara state Nigeria', is_active=True)
super_2 = StudentSupervisor(
    supervisor=sup_user_2, first_name=sup_user_2.first_name, last_name=sup_user_2.last_name, email=sup_user_2.email, phone_number=sup_user_2.phone_number, id_no=sup_user_2.identification_num, is_active=True)
super_3 = StudentSupervisor(
    supervisor=sup_user_3, first_name=sup_user_3.first_name, last_name=sup_user_3.last_name, email=sup_user_3.email, phone_number=sup_user_3.phone_number, id_no=sup_user_3.identification_num, is_active=True)
super_4 = StudentSupervisor(
    supervisor=sup_user_4, first_name=sup_user_4.first_name, last_name=sup_user_4.last_name, email=sup_user_4.email, phone_number=sup_user_4.phone_number, id_no=sup_user_4.identification_num, is_active=True)
super_5 = StudentSupervisor(
    supervisor=sup_user_5, first_name=sup_user_5.first_name, last_name=sup_user_5.last_name, email=sup_user_5.email, phone_number=sup_user_5.phone_number, id_no=sup_user_5.identification_num, is_active=True)
super_6 = StudentSupervisor(
    supervisor=sup_user_6, first_name=sup_user_6.first_name, last_name=sup_user_6.last_name, email=sup_user_6.email, phone_number=sup_user_6.phone_number, id_no=sup_user_6.identification_num, is_active=True)
super_7 = StudentSupervisor(
    supervisor=sup_user_7, first_name=sup_user_7.first_name, last_name=sup_user_7.last_name, email=sup_user_7.email, phone_number=sup_user_7.phone_number, id_no=sup_user_7.identification_num, is_active=True)
super_8 = StudentSupervisor(
    supervisor=sup_user_8, first_name=sup_user_8.first_name, last_name=sup_user_8.last_name, email=sup_user_8.email, phone_number=sup_user_8.phone_number, id_no=sup_user_8.identification_num, is_active=True)
super_9 = StudentSupervisor(
    supervisor=sup_user_9, first_name=sup_user_9.first_name, last_name=sup_user_9.last_name, email=sup_user_9.email, phone_number=sup_user_9.phone_number, id_no=sup_user_9.identification_num, is_active=True)
super_10 = StudentSupervisor(
    supervisor=sup_user_10, first_name=sup_user_10.first_name, last_name=sup_user_10.last_name, email=sup_user_10.email, phone_number=sup_user_10.phone_number, id_no=sup_user_10.identification_num, is_active=True)
super_11 = StudentSupervisor(
    supervisor=sup_user_11, first_name=sup_user_11.first_name, last_name=sup_user_11.last_name, email=sup_user_11.email, phone_number=sup_user_11.phone_number, id_no=sup_user_11.identification_num, is_active=True)
super_12 = StudentSupervisor(
    supervisor=sup_user_12, first_name=sup_user_12.first_name, last_name=sup_user_12.last_name, email=sup_user_12.email, phone_number=sup_user_12.phone_number, id_no=sup_user_12.identification_num, is_active=True)
super_13 = StudentSupervisor(
    supervisor=sup_user_13, first_name=sup_user_13.first_name, last_name=sup_user_13.last_name, email=sup_user_13.email, phone_number=sup_user_13.phone_number, id_no=sup_user_13.identification_num, is_active=True)
super_14 = StudentSupervisor(
    supervisor=sup_user_14, first_name=sup_user_14.first_name, last_name=sup_user_14.last_name, email=sup_user_14.email, phone_number=sup_user_14.phone_number, id_no=sup_user_14.identification_num, is_active=True)
super_15 = StudentSupervisor(
    supervisor=sup_user_15, first_name=sup_user_15.first_name, last_name=sup_user_15.last_name, email=sup_user_15.email, phone_number=sup_user_15.phone_number, id_no=sup_user_15.identification_num, is_active=True)
super_16 = StudentSupervisor(
    supervisor=sup_user_16, first_name=sup_user_16.first_name, last_name=sup_user_16.last_name, email=sup_user_16.email, phone_number=sup_user_16.phone_number, id_no=sup_user_16.identification_num, is_active=True)
super_17 = StudentSupervisor(
    supervisor=sup_user_17, first_name=sup_user_17.first_name, last_name=sup_user_17.last_name, email=sup_user_17.email, phone_number=sup_user_17.phone_number, id_no=sup_user_17.identification_num, is_active=True)
super_18 = StudentSupervisor(
    supervisor=sup_user_18, first_name=sup_user_18.first_name, last_name=sup_user_18.last_name, email=sup_user_18.email, phone_number=sup_user_18.phone_number, id_no=sup_user_18.identification_num, is_active=True)
super_19 = StudentSupervisor(
    supervisor=sup_user_19, first_name=sup_user_19.first_name, last_name=sup_user_19.last_name, email=sup_user_19.email, phone_number=sup_user_19.phone_number, id_no=sup_user_19.identification_num, is_active=True)
super_20 = StudentSupervisor(
    supervisor=sup_user_20, first_name=sup_user_20.first_name, last_name=sup_user_20.last_name, email=sup_user_20.email, phone_number=sup_user_20.phone_number, id_no=sup_user_20.identification_num, is_active=True)
super_21 = StudentSupervisor(
    supervisor=sup_user_21, first_name=sup_user_21.first_name, last_name=sup_user_21.last_name, email=sup_user_21.email, phone_number=sup_user_21.phone_number, id_no=sup_user_21.identification_num, is_active=True)
super_22 = StudentSupervisor(
    supervisor=sup_user_22, first_name=sup_user_22.first_name, last_name=sup_user_22.last_name, email=sup_user_22.email, phone_number=sup_user_22.phone_number, id_no=sup_user_22.identification_num, is_active=True)
super_23 = StudentSupervisor(
    supervisor=sup_user_23, first_name=sup_user_23.first_name, last_name=sup_user_23.last_name, email=sup_user_23.email, phone_number=sup_user_23.phone_number, id_no=sup_user_23.identification_num, is_active=True)
super_24 = StudentSupervisor(
    supervisor=sup_user_24, first_name=sup_user_24.first_name, last_name=sup_user_24.last_name, email=sup_user_24.email, phone_number=sup_user_24.phone_number, id_no=sup_user_24.identification_num, is_active=True)
super_25 = StudentSupervisor(
    supervisor=sup_user_25, first_name=sup_user_25.first_name, last_name=sup_user_25.last_name, email=sup_user_25.email, phone_number=sup_user_25.phone_number, id_no=sup_user_25.identification_num, is_active=True)
super_26 = StudentSupervisor(
    supervisor=sup_user_26, first_name=sup_user_26.first_name, last_name=sup_user_26.last_name, email=sup_user_26.email, phone_number=sup_user_26.phone_number, id_no=sup_user_26.identification_num, is_active=True)
super_27 = StudentSupervisor(
    supervisor=sup_user_27, first_name=sup_user_27.first_name, last_name=sup_user_27.last_name, email=sup_user_27.email, phone_number=sup_user_27.phone_number, id_no=sup_user_27.identification_num, is_active=True)
super_28 = StudentSupervisor(
    supervisor=sup_user_28, first_name=sup_user_28.first_name, last_name=sup_user_28.last_name, email=sup_user_28.email, phone_number=sup_user_28.phone_number, id_no=sup_user_28.identification_num, is_active=True)
super_29 = StudentSupervisor(
    supervisor=sup_user_29, first_name=sup_user_29.first_name, last_name=sup_user_29.last_name, email=sup_user_29.email, phone_number=sup_user_29.phone_number, id_no=sup_user_29.identification_num, is_active=True)
super_30 = StudentSupervisor(
    supervisor=sup_user_30, first_name=sup_user_30.first_name, last_name=sup_user_30.last_name, email=sup_user_30.email, phone_number=sup_user_30.phone_number, id_no=sup_user_30.identification_num, is_active=True)
super_31 = StudentSupervisor(
    supervisor=sup_user_31, first_name=sup_user_31.first_name, last_name=sup_user_31.last_name, email=sup_user_31.email, phone_number=sup_user_31.phone_number, id_no=sup_user_31.identification_num, is_active=True)
super_32 = StudentSupervisor(
    supervisor=sup_user_32, first_name=sup_user_32.first_name, last_name=sup_user_32.last_name, email=sup_user_32.email, phone_number=sup_user_32.phone_number, id_no=sup_user_32.identification_num, is_active=True)
super_33 = StudentSupervisor(
    supervisor=sup_user_33, first_name=sup_user_33.first_name, last_name=sup_user_33.last_name, email=sup_user_33.email, phone_number=sup_user_33.phone_number, id_no=sup_user_33.identification_num, is_active=True)
super_34 = StudentSupervisor(
    supervisor=sup_user_34, first_name=sup_user_34.first_name, last_name=sup_user_34.last_name, email=sup_user_34.email, phone_number=sup_user_34.phone_number, id_no=sup_user_34.identification_num, is_active=True)
super_35 = StudentSupervisor(
    supervisor=sup_user_35, first_name=sup_user_35.first_name, last_name=sup_user_35.last_name, email=sup_user_35.email, phone_number=sup_user_35.phone_number, id_no=sup_user_35.identification_num, is_active=True)
super_36 = StudentSupervisor(
    supervisor=sup_user_36, first_name=sup_user_36.first_name, last_name=sup_user_36.last_name, email=sup_user_36.email, phone_number=sup_user_36.phone_number, id_no=sup_user_36.identification_num, is_active=True)
super_37 = StudentSupervisor(
    supervisor=sup_user_37, first_name=sup_user_37.first_name, last_name=sup_user_37.last_name, email=sup_user_37.email, phone_number=sup_user_37.phone_number, id_no=sup_user_37.identification_num, is_active=True)
super_38 = StudentSupervisor(
    supervisor=sup_user_38, first_name=sup_user_38.first_name, last_name=sup_user_38.last_name, email=sup_user_38.email, phone_number=sup_user_38.phone_number, id_no=sup_user_38.identification_num, is_active=True)
super_39 = StudentSupervisor(
    supervisor=sup_user_39, first_name=sup_user_39.first_name, last_name=sup_user_39.last_name, email=sup_user_39.email, phone_number=sup_user_39.phone_number, id_no=sup_user_39.identification_num, is_active=True)
super_40 = StudentSupervisor(
    supervisor=sup_user_40, first_name=sup_user_40.first_name, last_name=sup_user_40.last_name, email=sup_user_40.email, phone_number=sup_user_40.phone_number, id_no=sup_user_40.identification_num, is_active=True)
super_41 = StudentSupervisor(
    supervisor=sup_user_41, first_name=sup_user_41.first_name, last_name=sup_user_41.last_name, email=sup_user_41.email, phone_number=sup_user_41.phone_number, id_no=sup_user_41.identification_num, is_active=True)
super_42 = StudentSupervisor(
    supervisor=sup_user_42, first_name=sup_user_42.first_name, last_name=sup_user_42.last_name, email=sup_user_42.email, phone_number=sup_user_42.phone_number, id_no=sup_user_42.identification_num, is_active=True)
super_43 = StudentSupervisor(
    supervisor=sup_user_43, first_name=sup_user_43.first_name, last_name=sup_user_43.last_name, email=sup_user_43.email, phone_number=sup_user_43.phone_number, id_no=sup_user_43.identification_num, is_active=True)
super_44 = StudentSupervisor(
    supervisor=sup_user_44, first_name=sup_user_44.first_name, last_name=sup_user_44.last_name, email=sup_user_44.email, phone_number=sup_user_44.phone_number, id_no=sup_user_44.identification_num, is_active=True)
super_45 = StudentSupervisor(
    supervisor=sup_user_45, first_name=sup_user_45.first_name, last_name=sup_user_45.last_name, email=sup_user_45.email, phone_number=sup_user_45.phone_number, id_no=sup_user_45.identification_num, is_active=True)
super_46 = StudentSupervisor(
    supervisor=sup_user_46, first_name=sup_user_46.first_name, last_name=sup_user_46.last_name, email=sup_user_46.email, phone_number=sup_user_46.phone_number, id_no=sup_user_46.identification_num, is_active=True)
super_47 = StudentSupervisor(
    supervisor=sup_user_47, first_name=sup_user_47.first_name, last_name=sup_user_47.last_name, email=sup_user_47.email, phone_number=sup_user_47.phone_number, id_no=sup_user_47.identification_num, is_active=True)
super_48 = StudentSupervisor(
    supervisor=sup_user_48, first_name=sup_user_48.first_name, last_name=sup_user_48.last_name, email=sup_user_48.email, phone_number=sup_user_48.phone_number, id_no=sup_user_48.identification_num, is_active=True)
super_49 = StudentSupervisor(
    supervisor=sup_user_49, first_name=sup_user_49.first_name, last_name=sup_user_49.last_name, email=sup_user_49.email, phone_number=sup_user_49.phone_number, id_no=sup_user_49.identification_num, is_active=True)
super_50 = StudentSupervisor(
    supervisor=sup_user_50, first_name=sup_user_50.first_name, last_name=sup_user_50.last_name, email=sup_user_50.email, phone_number=sup_user_50.phone_number, id_no=sup_user_50.identification_num, is_active=True)
super_51 = StudentSupervisor(
    supervisor=sup_user_51, first_name=sup_user_51.first_name, last_name=sup_user_51.last_name, email=sup_user_51.email, phone_number=sup_user_51.phone_number, id_no=sup_user_51.identification_num, is_active=True)
super_52 = StudentSupervisor(
    supervisor=sup_user_52, first_name=sup_user_52.first_name, last_name=sup_user_52.last_name, email=sup_user_52.email, phone_number=sup_user_52.phone_number, id_no=sup_user_52.identification_num, is_active=True)
super_53 = StudentSupervisor(
    supervisor=sup_user_53, first_name=sup_user_53.first_name, last_name=sup_user_53.last_name, email=sup_user_53.email, phone_number=sup_user_53.phone_number, id_no=sup_user_53.identification_num, is_active=True)
super_54 = StudentSupervisor(
    supervisor=sup_user_54, first_name=sup_user_54.first_name, last_name=sup_user_54.last_name, email=sup_user_54.email, phone_number=sup_user_54.phone_number, id_no=sup_user_54.identification_num, is_active=True)
super_55 = StudentSupervisor(
    supervisor=sup_user_55, first_name=sup_user_55.first_name, last_name=sup_user_55.last_name, email=sup_user_55.email, phone_number=sup_user_55.phone_number, id_no=sup_user_55.identification_num, is_active=True)
super_56 = StudentSupervisor(
    supervisor=sup_user_56, first_name=sup_user_56.first_name, last_name=sup_user_56.last_name, email=sup_user_56.email, phone_number=sup_user_56.phone_number, id_no=sup_user_56.identification_num, is_active=True)
super_57 = StudentSupervisor(
    supervisor=sup_user_57, first_name=sup_user_57.first_name, last_name=sup_user_57.last_name, email=sup_user_57.email, phone_number=sup_user_57.phone_number, id_no=sup_user_57.identification_num, is_active=True)
super_58 = StudentSupervisor(
    supervisor=sup_user_58, first_name=sup_user_58.first_name, last_name=sup_user_58.last_name, email=sup_user_58.email, phone_number=sup_user_58.phone_number, id_no=sup_user_58.identification_num, is_active=True)
super_59 = StudentSupervisor(
    supervisor=sup_user_59, first_name=sup_user_59.first_name, last_name=sup_user_59.last_name, email=sup_user_59.email, phone_number=sup_user_59.phone_number, id_no=sup_user_59.identification_num, is_active=True)
super_60 = StudentSupervisor(
    supervisor=sup_user_60, first_name=sup_user_60.first_name, last_name=sup_user_60.last_name, email=sup_user_60.email, phone_number=sup_user_60.phone_number, id_no=sup_user_60.identification_num, is_active=True)
super_61 = StudentSupervisor(
    supervisor=sup_user_61, first_name=sup_user_61.first_name, last_name=sup_user_61.last_name, email=sup_user_61.email, phone_number=sup_user_61.phone_number, id_no=sup_user_61.identification_num, is_active=True)
super_62 = StudentSupervisor(
    supervisor=sup_user_62, first_name=sup_user_62.first_name, last_name=sup_user_62.last_name, email=sup_user_62.email, phone_number=sup_user_62.phone_number, id_no=sup_user_62.identification_num, is_active=True)
super_63 = StudentSupervisor(
    supervisor=sup_user_63, first_name=sup_user_63.first_name, last_name=sup_user_63.last_name, email=sup_user_63.email, phone_number=sup_user_63.phone_number, id_no=sup_user_63.identification_num, is_active=True)
super_64 = StudentSupervisor(
    supervisor=sup_user_64, first_name=sup_user_64.first_name, last_name=sup_user_64.last_name, email=sup_user_64.email, phone_number=sup_user_64.phone_number, id_no=sup_user_64.identification_num, is_active=True)
super_65 = StudentSupervisor(
    supervisor=sup_user_65, first_name=sup_user_65.first_name, last_name=sup_user_65.last_name, email=sup_user_65.email, phone_number=sup_user_65.phone_number, id_no=sup_user_65.identification_num, is_active=True)
super_66 = StudentSupervisor(
    supervisor=sup_user_66, first_name=sup_user_66.first_name, last_name=sup_user_66.last_name, email=sup_user_66.email, phone_number=sup_user_66.phone_number, id_no=sup_user_66.identification_num, is_active=True)
super_67 = StudentSupervisor(
    supervisor=sup_user_67, first_name=sup_user_67.first_name, last_name=sup_user_67.last_name, email=sup_user_67.email, phone_number=sup_user_67.phone_number, id_no=sup_user_67.identification_num, is_active=True)
super_68 = StudentSupervisor(
    supervisor=sup_user_68, first_name=sup_user_68.first_name, last_name=sup_user_68.last_name, email=sup_user_68.email, phone_number=sup_user_68.phone_number, id_no=sup_user_68.identification_num, is_active=True)
super_69 = StudentSupervisor(
    supervisor=sup_user_69, first_name=sup_user_69.first_name, last_name=sup_user_69.last_name, email=sup_user_69.email, phone_number=sup_user_69.phone_number, id_no=sup_user_69.identification_num, is_active=True)
super_70 = StudentSupervisor(
    supervisor=sup_user_70, first_name=sup_user_70.first_name, last_name=sup_user_70.last_name, email=sup_user_70.email, phone_number=sup_user_70.phone_number, id_no=sup_user_70.identification_num, is_active=True)
super_71 = StudentSupervisor(
    supervisor=sup_user_71, first_name=sup_user_71.first_name, last_name=sup_user_71.last_name, email=sup_user_71.email, phone_number=sup_user_71.phone_number, id_no=sup_user_71.identification_num, is_active=True)
super_72 = StudentSupervisor(
    supervisor=sup_user_72, first_name=sup_user_72.first_name, last_name=sup_user_72.last_name, email=sup_user_72.email, phone_number=sup_user_72.phone_number, id_no=sup_user_72.identification_num, is_active=True)
super_73 = StudentSupervisor(
    supervisor=sup_user_73, first_name=sup_user_73.first_name, last_name=sup_user_73.last_name, email=sup_user_73.email, phone_number=sup_user_73.phone_number, id_no=sup_user_73.identification_num, is_active=True)
super_74 = StudentSupervisor(
    supervisor=sup_user_74, first_name=sup_user_74.first_name, last_name=sup_user_74.last_name, email=sup_user_74.email, phone_number=sup_user_74.phone_number, id_no=sup_user_74.identification_num, is_active=True)
super_75 = StudentSupervisor(
    supervisor=sup_user_75, first_name=sup_user_75.first_name, last_name=sup_user_75.last_name, email=sup_user_75.email, phone_number=sup_user_75.phone_number, id_no=sup_user_75.identification_num, is_active=True)
super_76 = StudentSupervisor(
    supervisor=sup_user_76, first_name=sup_user_76.first_name, last_name=sup_user_76.last_name, email=sup_user_76.email, phone_number=sup_user_76.phone_number, id_no=sup_user_76.identification_num, is_active=True)
super_77 = StudentSupervisor(
    supervisor=sup_user_77, first_name=sup_user_77.first_name, last_name=sup_user_77.last_name, email=sup_user_77.email, phone_number=sup_user_77.phone_number, id_no=sup_user_77.identification_num, is_active=True)
super_78 = StudentSupervisor(
    supervisor=sup_user_78, first_name=sup_user_78.first_name, last_name=sup_user_78.last_name, email=sup_user_78.email, phone_number=sup_user_78.phone_number, id_no=sup_user_78.identification_num, is_active=True)
super_79 = StudentSupervisor(
    supervisor=sup_user_79, first_name=sup_user_79.first_name, last_name=sup_user_79.last_name, email=sup_user_79.email, phone_number=sup_user_79.phone_number, id_no=sup_user_79.identification_num, is_active=True)
super_80 = StudentSupervisor(
    supervisor=sup_user_80, first_name=sup_user_80.first_name, last_name=sup_user_80.last_name, email=sup_user_80.email, phone_number=sup_user_80.phone_number, id_no=sup_user_80.identification_num, is_active=True)
super_81 = StudentSupervisor(
    supervisor=sup_user_81, first_name=sup_user_81.first_name, last_name=sup_user_81.last_name, email=sup_user_81.email, phone_number=sup_user_81.phone_number, id_no=sup_user_81.identification_num, is_active=True)
super_82 = StudentSupervisor(
    supervisor=sup_user_82, first_name=sup_user_82.first_name, last_name=sup_user_82.last_name, email=sup_user_82.email, phone_number=sup_user_82.phone_number, id_no=sup_user_82.identification_num, is_active=True)
super_83 = StudentSupervisor(
    supervisor=sup_user_83, first_name=sup_user_83.first_name, last_name=sup_user_83.last_name, email=sup_user_83.email, phone_number=sup_user_83.phone_number, id_no=sup_user_83.identification_num, is_active=True)
super_84 = StudentSupervisor(
    supervisor=sup_user_84, first_name=sup_user_84.first_name, last_name=sup_user_84.last_name, email=sup_user_84.email, phone_number=sup_user_84.phone_number, id_no=sup_user_84.identification_num, is_active=True)
super_85 = StudentSupervisor(
    supervisor=sup_user_85, first_name=sup_user_85.first_name, last_name=sup_user_85.last_name, email=sup_user_85.email, phone_number=sup_user_85.phone_number, id_no=sup_user_85.identification_num, is_active=True)
super_86 = StudentSupervisor(
    supervisor=sup_user_86, first_name=sup_user_86.first_name, last_name=sup_user_86.last_name, email=sup_user_86.email, phone_number=sup_user_86.phone_number, id_no=sup_user_86.identification_num, is_active=True)
super_87 = StudentSupervisor(
    supervisor=sup_user_87, first_name=sup_user_87.first_name, last_name=sup_user_87.last_name, email=sup_user_87.email, phone_number=sup_user_87.phone_number, id_no=sup_user_87.identification_num, is_active=True)
super_88 = StudentSupervisor(
    supervisor=sup_user_88, first_name=sup_user_88.first_name, last_name=sup_user_88.last_name, email=sup_user_88.email, phone_number=sup_user_88.phone_number, id_no=sup_user_88.identification_num, is_active=True)
super_89 = StudentSupervisor(
    supervisor=sup_user_89, first_name=sup_user_89.first_name, last_name=sup_user_89.last_name, email=sup_user_89.email, phone_number=sup_user_89.phone_number, id_no=sup_user_89.identification_num, is_active=True)
super_90 = StudentSupervisor(
    supervisor=sup_user_90, first_name=sup_user_90.first_name, last_name=sup_user_90.last_name, email=sup_user_90.email, phone_number=sup_user_90.phone_number, id_no=sup_user_90.identification_num, is_active=True)
super_91 = StudentSupervisor(
    supervisor=sup_user_91, first_name=sup_user_91.first_name, last_name=sup_user_91.last_name, email=sup_user_91.email, phone_number=sup_user_91.phone_number, id_no=sup_user_91.identification_num, is_active=True)
super_92 = StudentSupervisor(
    supervisor=sup_user_92, first_name=sup_user_92.first_name, last_name=sup_user_92.last_name, email=sup_user_92.email, phone_number=sup_user_92.phone_number, id_no=sup_user_92.identification_num, is_active=True)
super_93 = StudentSupervisor(
    supervisor=sup_user_93, first_name=sup_user_93.first_name, last_name=sup_user_93.last_name, email=sup_user_93.email, phone_number=sup_user_93.phone_number, id_no=sup_user_93.identification_num, is_active=True)
super_94 = StudentSupervisor(
    supervisor=sup_user_94, first_name=sup_user_94.first_name, last_name=sup_user_94.last_name, email=sup_user_94.email, phone_number=sup_user_94.phone_number, id_no=sup_user_94.identification_num, is_active=True)
super_95 = StudentSupervisor(
    supervisor=sup_user_95, first_name=sup_user_95.first_name, last_name=sup_user_95.last_name, email=sup_user_95.email, phone_number=sup_user_95.phone_number, id_no=sup_user_95.identification_num, is_active=True)
super_96 = StudentSupervisor(
    supervisor=sup_user_96, first_name=sup_user_96.first_name, last_name=sup_user_96.last_name, email=sup_user_96.email, phone_number=sup_user_96.phone_number, id_no=sup_user_96.identification_num, is_active=True)

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

### _________________________________
### Adding supervisors to departments

# physics
coord_1.training_supervisors.add(super_1)
coord_1.training_supervisors.add(super_2)
coord_1.training_supervisors.add(super_3)

# Computer Science
coord_2.training_supervisors.add(super_4)
coord_2.training_supervisors.add(super_5)
coord_2.training_supervisors.add(super_6)

# Mathematics
coord_3.training_supervisors.add(super_7)
coord_3.training_supervisors.add(super_8)
coord_3.training_supervisors.add(super_9)

# Chemistry
coord_4.training_supervisors.add(super_10)
coord_4.training_supervisors.add(super_11)
coord_4.training_supervisors.add(super_12)

# Biochemistry
coord_5.training_supervisors.add(super_13)
coord_5.training_supervisors.add(super_14)
coord_5.training_supervisors.add(super_15)

# Geology
coord_6.training_supervisors.add(super_16)
coord_6.training_supervisors.add(super_17)
coord_6.training_supervisors.add(super_18)

# Microbiology
coord_7.training_supervisors.add(super_19)
coord_7.training_supervisors.add(super_20)
coord_7.training_supervisors.add(super_21)

# Plant science & biotechnology
coord_8.training_supervisors.add(super_22)
coord_8.training_supervisors.add(super_23)
coord_8.training_supervisors.add(super_24)

# Zoology
coord_9.training_supervisors.add(super_25)
coord_9.training_supervisors.add(super_26)
coord_9.training_supervisors.add(super_27)

# Biology
coord_10.training_supervisors.add(super_28)
coord_10.training_supervisors.add(super_29)
coord_10.training_supervisors.add(super_30)

# Arabic Language
coord_11.training_supervisors.add(super_31)
coord_11.training_supervisors.add(super_32)
coord_11.training_supervisors.add(super_33)

# English Language
coord_12.training_supervisors.add(super_34)
coord_12.training_supervisors.add(super_35)
coord_12.training_supervisors.add(super_36)

# French
coord_13.training_supervisors.add(super_37)
coord_13.training_supervisors.add(super_38)
coord_13.training_supervisors.add(super_39)

# Hausa Language
coord_14.training_supervisors.add(super_40)
coord_14.training_supervisors.add(super_41)
coord_14.training_supervisors.add(super_42)

# History
coord_15.training_supervisors.add(super_43)
coord_15.training_supervisors.add(super_44)
coord_15.training_supervisors.add(super_45)

# Islamic Studies
coord_16.training_supervisors.add(super_46)
coord_16.training_supervisors.add(super_47)
coord_16.training_supervisors.add(super_48)

# Education Arabic
coord_17.training_supervisors.add(super_49)
coord_17.training_supervisors.add(super_50)
coord_17.training_supervisors.add(super_51)

# Education Biology
coord_18.training_supervisors.add(super_52)
coord_18.training_supervisors.add(super_53)
coord_18.training_supervisors.add(super_54)

# Education Chemistry
coord_19.training_supervisors.add(super_55)
coord_19.training_supervisors.add(super_56)
coord_19.training_supervisors.add(super_57)

# Education Economics
coord_20.training_supervisors.add(super_58)
coord_20.training_supervisors.add(super_59)
coord_20.training_supervisors.add(super_60)

# Education English
coord_21.training_supervisors.add(super_61)
coord_21.training_supervisors.add(super_62)
coord_21.training_supervisors.add(super_63)

# Education Hausa
coord_22.training_supervisors.add(super_64)
coord_22.training_supervisors.add(super_65)
coord_22.training_supervisors.add(super_66)

# Education History
coord_23.training_supervisors.add(super_67)
coord_23.training_supervisors.add(super_68)
coord_23.training_supervisors.add(super_69)

# Education Islamic Studies
coord_24.training_supervisors.add(super_70)
coord_24.training_supervisors.add(super_71)
coord_24.training_supervisors.add(super_72)

# Education Mathematics
coord_25.training_supervisors.add(super_73)
coord_25.training_supervisors.add(super_74)
coord_25.training_supervisors.add(super_75)

# Education Physics
coord_26.training_supervisors.add(super_76)
coord_26.training_supervisors.add(super_77)
coord_26.training_supervisors.add(super_78)

# Accounting
coord_27.training_supervisors.add(super_79)
coord_27.training_supervisors.add(super_80)
coord_27.training_supervisors.add(super_81)

# Business Administration
coord_28.training_supervisors.add(super_82)
coord_28.training_supervisors.add(super_83)
coord_28.training_supervisors.add(super_84)

# Economics
coord_29.training_supervisors.add(super_85)
coord_29.training_supervisors.add(super_86)
coord_29.training_supervisors.add(super_87)

# Political science
coord_30.training_supervisors.add(super_88)
coord_30.training_supervisors.add(super_89)
coord_30.training_supervisors.add(super_90)

# Public Administration
coord_31.training_supervisors.add(super_91)
coord_31.training_supervisors.add(super_92)
coord_31.training_supervisors.add(super_93)

# Sociology
coord_32.training_supervisors.add(super_94)
coord_32.training_supervisors.add(super_95)
coord_32.training_supervisors.add(super_96)

### _________________________________________________________________________________________________________
### TRAINING STUDENTS (320 student, 10 student for each department where 5 are 200L and the other 5 are 300L)
# Physics students
student_user_1 = User.objects.create_user(
    first_name='Usman', last_name='Musa', identification_num='2010310013', email='usmanmusa1920@gmail.com', phone_number='+2348144807260', is_student=True, password='19991125u')
student_user_2 = User.objects.create_user(
    first_name='Benjamin', last_name='Omoniyi', identification_num='2010310025', email='benjaminomoniyi@gmail.com', phone_number='+2348144807260', is_student=True) # user_password_not_set
student_user_3 = User.objects.create_user(
    first_name='Jaafar', last_name='Ridwan', identification_num='201031003', email='jaafarridwan@gmail.com', phone_number='+2348144807211', is_student=True) # user_password_not_set
student_user_4 = User.objects.create_user(
    first_name='Rukayya', last_name='Zakari', identification_num='2010310043', email='rukayyazakari@gmail.com', phone_number='+2348144807222', is_student=True) # user_password_not_set
student_user_5 = User.objects.create_user(
    first_name='Sulaiman', last_name='Tambai', identification_num='2010310018', email='sulaimantambai@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_6 = User.objects.create_user(
    first_name='Umar', last_name='Ahmad', identification_num='1910310001', email='umarahmad6@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_7 = User.objects.create_user(
    first_name='Mustapha', last_name='Taoheed', identification_num='1910310003', email='mustaphataoheed@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_8 = User.objects.create_user(
    first_name='Shuaibu', last_name='Ishaq', identification_num='1910310010', email='shuaibuishaq@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_9 = User.objects.create_user(
    first_name='Lukman', last_name='Bello', identification_num='1910310014', email='lukmanbello@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_10 = User.objects.create_user(
    first_name='Muhammad', last_name='Mahdi', identification_num='2120310004', email='muhammadmahdi@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Computer Science students
student_user_11 = User.objects.create_user(
    first_name='Abba', last_name='Sanusi', identification_num='2010308057', email='abbasanusi@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_12 = User.objects.create_user(
    first_name='Ahmad', last_name='Shehu', identification_num='2010308022', email='ahmadshehu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_13 = User.objects.create_user(
    first_name='Marwanu', last_name='Ibrahim', identification_num='2010308027', email='marwanuibrahim@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_14 = User.objects.create_user(
    first_name='Babangida', last_name='Samaila', identification_num='2010308031', email='babangidasamaila@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_15 = User.objects.create_user(
    first_name='Abdulhakeem', last_name='Odoi', identification_num='20103100515', email='abdulhakeemodoi@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_16 = User.objects.create_user(
    first_name='Salim', last_name='Muhammad', identification_num='20103100516', email='salimmuhammad@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_17 = User.objects.create_user(
    first_name='Abdulfatah', last_name='Gusau', identification_num='20103100517', email='abdulfatahgusau@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_18 = User.objects.create_user(
    first_name='Sanusi', last_name='Salihu', identification_num='20103100518', email='sanusisalihu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_19 = User.objects.create_user(
    first_name='Benjamin', last_name='Isaac', identification_num='20103100519', email='benjaminisaac@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_20 = User.objects.create_user(
    first_name='Mustapha', last_name='Galadeema', identification_num='20103100520', email='mustaphagaladeema@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Mathematics students
student_user_21 = User.objects.create_user(
    first_name='Muhammad', last_name='Bello', identification_num='20103100521', email='muhammadbello@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_22 = User.objects.create_user(
    first_name='Mahmud', last_name='Ali', identification_num='20103100522', email='mahmudali@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_23 = User.objects.create_user(
    first_name='Usman', last_name='Bilya', identification_num='20103100523', email='usmanbilya@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_24 = User.objects.create_user(
    first_name='Amadu', last_name='Lawal', identification_num='20103100524', email='amadulawal@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_25 = User.objects.create_user(
    first_name='Ibrahim', last_name='Yakub', identification_num='20103100525', email='ibrahimyakub@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_26 = User.objects.create_user(
    first_name='Hasan', last_name='Gambo', identification_num='20103100526', email='hasangambo@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_27 = User.objects.create_user(
    first_name='Alamin', last_name='Yawuri', identification_num='20103100527', email='alaminyawuri@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_28 = User.objects.create_user(
    first_name='Sani', last_name='Nasir', identification_num='20103100528', email='saninasir@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_29 = User.objects.create_user(
    first_name='Ayuba', last_name='Anka', identification_num='20103100529', email='ayubaanka@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_30 = User.objects.create_user(
    first_name='Tukur', last_name='Kanoma', identification_num='20103100530', email='tukurkanoma@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Chemistry students
student_user_31 = User.objects.create_user(
    first_name='Musa', last_name='Halilu', identification_num='20103100531', email='musahalilu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_32 = User.objects.create_user(
    first_name='Jawad', last_name='Hashim', identification_num='20103100532', email='jawadhashim@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_33 = User.objects.create_user(
    first_name='Hamisu', last_name='Ali', identification_num='20103100533', email='hamisuali@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_34 = User.objects.create_user(
    first_name='Salim', last_name='Ahmad', identification_num='20103100534', email='salimahmad@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_35 = User.objects.create_user(
    first_name='Tijjani', last_name='Fage', identification_num='20103100535', email='tijjanifage@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_36 = User.objects.create_user(
    first_name='Tamim', last_name='Alkali', identification_num='20103100536', email='taminmalkali@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_37 = User.objects.create_user(
    first_name='Nura', last_name='Bello', identification_num='20103100537', email='nurabello@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_38 = User.objects.create_user(
    first_name='Munnir', last_name='Khalid', identification_num='20103100538', email='munirkhalid@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_39 = User.objects.create_user(
    first_name='Sagir', last_name='Yakub', identification_num='20103100539', email='sagiryakub@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_40 = User.objects.create_user(
    first_name='Habib', last_name='Usman', identification_num='20103100540', email='habibusman@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Biochemistry students
student_user_41 = User.objects.create_user(
    first_name='Muaz', last_name='Ahmad', identification_num='20103100541', email='muazahmad@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_42 = User.objects.create_user(
    first_name='Saleh', last_name='Anka', identification_num='20103100542', email='salehanka@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_43 = User.objects.create_user(
    first_name='Andy', last_name='Kaku', identification_num='20103100543', email='andykaku@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_44 = User.objects.create_user(
    first_name='Kabir', last_name='Sagir', identification_num='20103100544', email='kabirsagir@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_45 = User.objects.create_user(
    first_name='Lawi', last_name='Ayuba', identification_num='20103100545', email='lawiayuba@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_46 = User.objects.create_user(
    first_name='Mustapha', last_name='Abdallah', identification_num='20103100546', email='mustaphaabdallah@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_47 = User.objects.create_user(
    first_name='Yakub', last_name='Yusuf', identification_num='20103100547', email='yakubyusuf@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_48 = User.objects.create_user(
    first_name='Abba', last_name='Sagir', identification_num='20103100548', email='abbasagir@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_49 = User.objects.create_user(
    first_name='Gazali', last_name='Kebbi', identification_num='20103100549', email='gazalikebbi@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_50 = User.objects.create_user(
    first_name='Talle', last_name='Ahmad', identification_num='20103100550', email='talleahmad@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Geology students
student_user_51 = User.objects.create_user(
    first_name='Hamza', last_name='Yahaya', identification_num='20103100551', email='hamzayahaya@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_52 = User.objects.create_user(
    first_name='Abdul', last_name='Ali', identification_num='20103100552', email='abdulali@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_53 = User.objects.create_user(
    first_name='Zahradin', last_name='Jabir', identification_num='20103100553', email='zahradinjabir@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_54 = User.objects.create_user(
    first_name='Masud', last_name='Shehu', identification_num='20103100554', email='masudshehu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_55 = User.objects.create_user(
    first_name='Jaafar', last_name='Shehu', identification_num='20103100555', email='jaafarshehu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_56 = User.objects.create_user(
    first_name='Salmanu', last_name='Border', identification_num='20103100556', email='salmanuborder@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_57 = User.objects.create_user(
    first_name='Aamir', last_name='Kallah', identification_num='20103100557', email='aamirkallah@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_58 = User.objects.create_user(
    first_name='Dahiru', last_name='Abbas', identification_num='20103100558', email='dahiruabbas@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_59 = User.objects.create_user(
    first_name='Yusuf', last_name='Habu', identification_num='20103100559', email='yusufhabu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_60 = User.objects.create_user(
    first_name='Saminu', last_name='GRA', identification_num='20103100560', email='saminugra@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Microbiology students
student_user_61 = User.objects.create_user(
    first_name='Usman', last_name='Sani', identification_num='20103100561', email='usmansani@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_62 = User.objects.create_user(
    first_name='Musa', last_name='Bakwai', identification_num='20103100562', email='musabakwai@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_63 = User.objects.create_user(
    first_name='Bashir', last_name='Yusuf', identification_num='20103100563', email='bashiryusuf@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_64 = User.objects.create_user(
    first_name='Lawal', last_name='Sagir', identification_num='20103100564', email='lawalsagir@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_65 = User.objects.create_user(
    first_name='Nura', last_name='Sadam', identification_num='20103100565', email='nurasadam@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_66 = User.objects.create_user(
    first_name='Sadiku', last_name='Usman', identification_num='20103100566', email='sadikuusman@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_67 = User.objects.create_user(
    first_name='Usama', last_name='Gamji', identification_num='20103100567', email='usamagamji@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_68 = User.objects.create_user(
    first_name='Faruk', last_name='Ali', identification_num='20103100568', email='farukali@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_69 = User.objects.create_user(
    first_name='Namadi', last_name='Ashiru', identification_num='20103100569', email='namadiashiru@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_70 = User.objects.create_user(
    first_name='Samir', last_name='Dannigeria', identification_num='20103100570', email='samirdannigeria@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Plant science & biotechnology students
student_user_71 = User.objects.create_user(
    first_name='Tamimu', last_name='Ibrahim', identification_num='20103100571', email='tamimuibrahim@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_72 = User.objects.create_user(
    first_name='Umar', last_name='Lawal', identification_num='20103100572', email='umarlawal@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_73 = User.objects.create_user(
    first_name='Babangida', last_name='Yunusa', identification_num='20103100573', email='babangidayunusa@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_74 = User.objects.create_user(
    first_name='Saleh', last_name='Yau', identification_num='20103100574', email='salehyau@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_75 = User.objects.create_user(
    first_name='Yakubu', last_name='Hamza', identification_num='20103100575', email='yakubuhamza@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_76 = User.objects.create_user(
    first_name='Fawaz', last_name='Zakari', identification_num='20103100576', email='fawazzakari@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_77 = User.objects.create_user(
    first_name='Alamin', last_name='Namadi', identification_num='20103100577', email='alaminnamadi@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_78 = User.objects.create_user(
    first_name='Saleh', last_name='Usman', identification_num='20103100578', email='salehusman@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_79 = User.objects.create_user(
    first_name='Salihu', last_name='Tafeeda', identification_num='20103100579', email='salihutafeeda@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_80 = User.objects.create_user(
    first_name='Yahaya', last_name='Lowcos', identification_num='20103100580', email='yahayalowcos@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Zoology students
student_user_81 = User.objects.create_user(
    first_name='Mudassir', last_name='Ashiru', identification_num='20103100581', email='mudassirashiru81@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_82 = User.objects.create_user(
    first_name='Ahmad', last_name='Lawal', identification_num='20103100582', email='ahmadlawal@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_83 = User.objects.create_user(
    first_name='Sagir', last_name='Nura', identification_num='20103100583', email='sagirnura@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_84 = User.objects.create_user(
    first_name='Surajo', last_name='Nadama', identification_num='20103100584', email='surajonadama@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_85 = User.objects.create_user(
    first_name='Halilu', last_name='Abbas', identification_num='20103100585', email='haliluabbas@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_86 = User.objects.create_user(
    first_name='Sani', last_name='Sagir', identification_num='20103100586', email='sanisagir@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_87 = User.objects.create_user(
    first_name='Oladeji', last_name='Olatunji', identification_num='20103100587', email='oladejiolatunji@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_88 = User.objects.create_user(
    first_name='Sule', last_name='Lilo', identification_num='20103100588', email='sulelilo@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_89 = User.objects.create_user(
    first_name='Naallah', last_name='Hafiz', identification_num='20103100589', email='naallahhafiz@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_90 = User.objects.create_user(
    first_name='Muhsin', last_name='Bala', identification_num='20103100590', email='muhsinbala@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Biology students
student_user_91 = User.objects.create_user(
    first_name='Kabiru', last_name='Hudu', identification_num='20103100591', email='kabiruhudu91@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_92 = User.objects.create_user(
    first_name='Adam', last_name='Ali', identification_num='20103100592', email='adamali@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_93 = User.objects.create_user(
    first_name='Salisu', last_name='Ahmad', identification_num='20103100593', email='salisuahmad@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_94 = User.objects.create_user(
    first_name='Tsalha', last_name='Tela', identification_num='20103100594', email='tsalhatela@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_95 = User.objects.create_user(
    first_name='Nura', last_name='Yau', identification_num='20103100595', email='nurayau@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_96 = User.objects.create_user(
    first_name='Bashir', last_name='Tsoho', identification_num='20103100596', email='bashirtsoho@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_97 = User.objects.create_user(
    first_name='Annur', last_name='Saminu', identification_num='20103100597', email='annursaminu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_98 = User.objects.create_user(
    first_name='Tukur', last_name='Danmalam', identification_num='20103100598', email='tukurdanmalam@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_99 = User.objects.create_user(
    first_name='Nasiru', last_name='Alhasan', identification_num='20103100599', email='nasirualhasan@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_100 = User.objects.create_user(
    first_name='Abdulwahab', last_name='Khalid', identification_num='201031005100', email='abdulwahabkhalid@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Arabic Language students
student_user_101 = User.objects.create_user(
    first_name='Shuaibu', last_name='Buhari', identification_num='201031005101', email='shuaibubuhari@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_102 = User.objects.create_user(
    first_name='Abbas', last_name='Yahuza', identification_num='201031005102', email='abbasyahuza@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_103 = User.objects.create_user(
    first_name='Nas', last_name='Mansur', identification_num='201031005103', email='nasmansur@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_104 = User.objects.create_user(
    first_name='Omar', last_name='Khan', identification_num='201031005104', email='omarkhan@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_105 = User.objects.create_user(
    first_name='Ali', last_name='Sani', identification_num='201031005105', email='alisani@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_106 = User.objects.create_user(
    first_name='Idris', last_name='Yakub', identification_num='201031005106', email='idrisyakub@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_107 = User.objects.create_user(
    first_name='Zailani', last_name='Zakiru', identification_num='201031005107', email='zailanizakiru@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_108 = User.objects.create_user(
    first_name='Kamal', last_name='Tafeeda', identification_num='201031005108', email='kamaltafeeda@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_109 = User.objects.create_user(
    first_name='Saith', last_name='Adam', identification_num='201031005109', email='saithadam@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_110 = User.objects.create_user(
    first_name='Ola', last_name='Ema', identification_num='201031005110', email='olaema@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# English Language students
student_user_111 = User.objects.create_user(
    first_name='Musbahu', last_name='Rabiu', identification_num='201031005111', email='musbahurabiu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_112 = User.objects.create_user(
    first_name='Sale', last_name='Sani', identification_num='201031005112', email='salesani@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_113 = User.objects.create_user(
    first_name='Muqaddas', last_name='Kabir', identification_num='201031005113', email='muqaddaskabir@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_114 = User.objects.create_user(
    first_name='Hasan', last_name='Nura', identification_num='201031005114', email='hasannura@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_115 = User.objects.create_user(
    first_name='Husain', last_name='Nura', identification_num='201031005115', email='husainnura@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_116 = User.objects.create_user(
    first_name='Ashiru', last_name='Ahmad', identification_num='201031005116', email='ashiruahmad@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_117 = User.objects.create_user(
    first_name='Balah', last_name='Bau', identification_num='201031005117', email='balahbau@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_118 = User.objects.create_user(
    first_name='John', last_name='Chris', identification_num='201031005118', email='johnchris@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_119 = User.objects.create_user(
    first_name='Doe', last_name='Trav', identification_num='201031005119', email='doetrav@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_120 = User.objects.create_user(
    first_name='Mannir', last_name='Yahaya', identification_num='201031005120', email='manniryahaya@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# French students
student_user_121 = User.objects.create_user(
    first_name='Abbah', last_name='Tijjani', identification_num='201031005121', email='abbahtijjani@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_122 = User.objects.create_user(
    first_name='Sani', last_name='Shagari', identification_num='201031005122', email='sanishagari@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_123 = User.objects.create_user(
    first_name='Baba', last_name='Uba', identification_num='201031005123', email='babauba@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_124 = User.objects.create_user(
    first_name='Hafiz', last_name='Kallah', identification_num='201031005124', email='hafizkallah@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_125 = User.objects.create_user(
    first_name='Mahmud', last_name='Aminu', identification_num='201031005125', email='mahmudaminu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_126 = User.objects.create_user(
    first_name='Abdullahi', last_name='Jaafar', identification_num='201031005126', email='abdullahijaafar@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_127 = User.objects.create_user(
    first_name='Nafiu', last_name='Dahiru', identification_num='201031005127', email='nafiudahiru@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_128 = User.objects.create_user(
    first_name='Yusuf', last_name='Sulaiman', identification_num='201031005128', email='Yusufsulaiman@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_129 = User.objects.create_user(
    first_name='Annur', last_name='Nura', identification_num='201031005129', email='annurnura@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_130 = User.objects.create_user(
    first_name='Kawu', last_name='Bala', identification_num='201031005130', email='kawubala@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Hausa students
student_user_131 = User.objects.create_user(
    first_name='Audu', last_name='Mani', identification_num='201031005131', email='audumani@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_132 = User.objects.create_user(
    first_name='Sagir', last_name='Tanko', identification_num='201031005132', email='sagirtanko@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_133 = User.objects.create_user(
    first_name='Yawale', last_name='Lado', identification_num='201031005133', email='yawalelado@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_134 = User.objects.create_user(
    first_name='John', last_name='Gusau', identification_num='201031005134', email='johngusau@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_135 = User.objects.create_user(
    first_name='Benjamin', last_name='Ola', identification_num='201031005135', email='benjaminola@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_136 = User.objects.create_user(
    first_name='Yahuza', last_name='Mahdi', identification_num='201031005136', email='yahuzamahdi@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_137 = User.objects.create_user(
    first_name='Tijjani', last_name='Legas', identification_num='201031005137', email='tijjanilegas@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_138 = User.objects.create_user(
    first_name='Mamman', last_name='Aleru', identification_num='201031005138', email='mammanaleru@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_139 = User.objects.create_user(
    first_name='Arfat', last_name='Asifat', identification_num='201031005139', email='arfatasifat@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_140 = User.objects.create_user(
    first_name='Ammar', last_name='Sharu', identification_num='201031005140', email='ammarsharu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# History students
student_user_141 = User.objects.create_user(
    first_name='Nawabu', last_name='Amin', identification_num='201031005141', email='nawabuamin@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_142 = User.objects.create_user(
    first_name='Husain', last_name='Shagali', identification_num='201031005142', email='husainshagali@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_143 = User.objects.create_user(
    first_name='Nazir', last_name='Abdu', identification_num='201031005143', email='nazirabdu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_144 = User.objects.create_user(
    first_name='Nazifi', last_name='Lawal', identification_num='201031005144', email='nazifilawal@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_145 = User.objects.create_user(
    first_name='Shamsu', last_name='Salman', identification_num='201031005145', email='shamsusalman@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_146 = User.objects.create_user(
    first_name='Balarabe', last_name='Zaria', identification_num='201031005146', email='balarabezaria@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_147 = User.objects.create_user(
    first_name='Yuguda', last_name='Lawal', identification_num='201031005147', email='yugudalawal@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_148 = User.objects.create_user(
    first_name='Yusufu', last_name='Ladan', identification_num='201031005148', email='yusufuladan@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_149 = User.objects.create_user(
    first_name='Mamman', last_name='Liman', identification_num='201031005149', email='mammanliman@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_150 = User.objects.create_user(
    first_name='Aliyu', last_name='Mufaddal', identification_num='201031005150', email='aliyumufaddal@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Islamic Studies students
student_user_151 = User.objects.create_user(
    first_name='Abubakar', last_name='Sani', identification_num='201031005151', email='abubakarsani@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_152 = User.objects.create_user(
    first_name='Salihu', last_name='Labaran', identification_num='201031005152', email='salihulabaran@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_153 = User.objects.create_user(
    first_name='Tamim', last_name='Ali', identification_num='201031005153', email='tamimali@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_154 = User.objects.create_user(
    first_name='Usman', last_name='Lawal', identification_num='201031005154', email='usmanlawal@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_155 = User.objects.create_user(
    first_name='Lawal', last_name='Saleh', identification_num='201031005155', email='lawalsaleh@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_156 = User.objects.create_user(
    first_name='Gaddafi', last_name='Mustapha', identification_num='201031005156', email='gaddafimustapha@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_157 = User.objects.create_user(
    first_name='Lawi', last_name='Lukman', identification_num='201031005157', email='lawilukman@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_158 = User.objects.create_user(
    first_name='Sagir', last_name='Mubarak', identification_num='201031005158', email='sagirmubarak@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_159 = User.objects.create_user(
    first_name='Mubarak', last_name='Yakub', identification_num='201031005159', email='mubarakyakub@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_160 = User.objects.create_user(
    first_name='Annur', last_name='Usman', identification_num='201031005160', email='annurusman@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Education Arabic students
student_user_161 = User.objects.create_user(
    first_name='Sule', last_name='Nura', identification_num='201031005161', email='sulenura@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_162 = User.objects.create_user(
    first_name='Nawab', last_name='Najib', identification_num='201031005162', email='nawabnajib@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_163 = User.objects.create_user(
    first_name='Samir', last_name='Lawal', identification_num='201031005163', email='samirlawal@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_164 = User.objects.create_user(
    first_name='Andi', last_name='Jerry', identification_num='201031005164', email='andijerry@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_165 = User.objects.create_user(
    first_name='Yahaya', last_name='Ibrahim', identification_num='201031005165', email='yahayaibrahim@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_166 = User.objects.create_user(
    first_name='Faruk', last_name='Ali', identification_num='201031005166', email='farukali@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_167 = User.objects.create_user(
    first_name='Marwanu', last_name='Samaila', identification_num='201031005167', email='marwanusamaila@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_168 = User.objects.create_user(
    first_name='Shehu', last_name='Nas', identification_num='201031005168', email='shehunas@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_169 = User.objects.create_user(
    first_name='Sani', last_name='Lawal', identification_num='201031005169', email='sanilawal@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_170 = User.objects.create_user(
    first_name='Ahmad', last_name='Muhammad', identification_num='201031005170', email='ahmadmuhammad@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Education Biology students
student_user_171 = User.objects.create_user(
    first_name='Taoheed', last_name='Abbas', identification_num='201031005171', email='taoheedabbas@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_172 = User.objects.create_user(
    first_name='Sanusi', last_name='Nasir', identification_num='201031005172', email='sanusinasir@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_173 = User.objects.create_user(
    first_name='Nura', last_name='Sani', identification_num='201031005173', email='nurasani@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_174 = User.objects.create_user(
    first_name='Muntari', last_name='Yero', identification_num='201031005174', email='muntariyero@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_175 = User.objects.create_user(
    first_name='Ashiru', last_name='Auwal', identification_num='201031005175', email='ashiruauwal@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_176 = User.objects.create_user(
    first_name='Auwal', last_name='Malam', identification_num='201031005176', email='auwallawal@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_177 = User.objects.create_user(
    first_name='Muhammad', last_name='Tahir', identification_num='201031005177', email='muhammadtahir@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_178 = User.objects.create_user(
    first_name='Sunday', last_name='Tamty', identification_num='201031005178', email='sundaytamty@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_179 = User.objects.create_user(
    first_name='Yusuf', last_name='Talle', identification_num='201031005179', email='yusuftalle@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_180 = User.objects.create_user(
    first_name='Amadu', last_name='Ali', identification_num='201031005180', email='amaduali@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Education Chemistry students
student_user_181 = User.objects.create_user(
    first_name='Surajo', last_name='Nura', identification_num='201031005181', email='surajonura@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_182 = User.objects.create_user(
    first_name='Mannir', last_name='Malam', identification_num='201031005182', email='mannirmalam@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_183 = User.objects.create_user(
    first_name='Lawal', last_name='Sani', identification_num='201031005183', email='lawalsani@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_184 = User.objects.create_user(
    first_name='Usman', last_name='Mamu', identification_num='201031005184', email='usmanmamu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_185 = User.objects.create_user(
    first_name='Adiyu', last_name='Tamim', identification_num='201031005185', email='adiyutamim@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_186 = User.objects.create_user(
    first_name='Khamis', last_name='Akuyam', identification_num='201031005186', email='khamisakuyam@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_187 = User.objects.create_user(
    first_name='Talha', last_name='Sani', identification_num='201031005187', email='talhasani@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_188 = User.objects.create_user(
    first_name='Musa', last_name='Nura', identification_num='201031005188', email='musanura@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_189 = User.objects.create_user(
    first_name='Khamis', last_name='Surajo', identification_num='201031005189', email='khamissurajo@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_190 = User.objects.create_user(
    first_name='Idris', last_name='Ali', identification_num='201031005190', email='idrisali@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Education Economics students
student_user_191 = User.objects.create_user(
    first_name='Sule', last_name='Auta', identification_num='201031005191', email='suleauta@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_192 = User.objects.create_user(
    first_name='Bawa', last_name='Sadik', identification_num='201031005192', email='bawasadik@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_193 = User.objects.create_user(
    first_name='Muhammad', last_name='Usman', identification_num='201031005193', email='muhammadusman@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_194 = User.objects.create_user(
    first_name='Usman', last_name='Bawa', identification_num='201031005194', email='usmanbawa@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_195 = User.objects.create_user(
    first_name='Abdul', last_name='Nawab', identification_num='201031005195', email='abdulnawab@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_196 = User.objects.create_user(
    first_name='Najib', last_name='Fawaz', identification_num='201031005196', email='najibfawaz@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_197 = User.objects.create_user(
    first_name='Tukur', last_name='Sani', identification_num='201031005197', email='tukursani@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_198 = User.objects.create_user(
    first_name='Idris', last_name='Ahmad', identification_num='201031005198', email='idrisahmad@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_199 = User.objects.create_user(
    first_name='Sadik', last_name='Sani', identification_num='201031005199', email='sadiksani@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_200 = User.objects.create_user(
    first_name='Sallau', last_name='Salihu', identification_num='201031005200', email='sallausalihu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Education English students
student_user_201 = User.objects.create_user(
    first_name='Aliyu', last_name='Abubakar', identification_num='201031005201', email='aliyuabubakar@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_202 = User.objects.create_user(
    first_name='Hayatu', last_name='Jamilu', identification_num='201031005202', email='hayatujamilu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_203 = User.objects.create_user(
    first_name='Jibril', last_name='Lawal', identification_num='201031005203', email='jibrillawal@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_204 = User.objects.create_user(
    first_name='Nass', last_name='Jos', identification_num='201031005204', email='nasjos@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_205 = User.objects.create_user(
    first_name='Ahmad', last_name='Abbas', identification_num='201031005205', email='ahmadabbas@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_206 = User.objects.create_user(
    first_name='Tahir', last_name='Salim', identification_num='201031005206', email='tahirsalim@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_207 = User.objects.create_user(
    first_name='Nura', last_name='Usman', identification_num='201031005207', email='nurausman@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_208 = User.objects.create_user(
    first_name='Lawal', last_name='Iya', identification_num='201031005208', email='lawaliya@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_209 = User.objects.create_user(
    first_name='Tajuddeen', last_name='Anka', identification_num='201031005209', email='tajuddeenanka@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_210 = User.objects.create_user(
    first_name='Kabir', last_name='Yunusa', identification_num='201031005210', email='kabiryunusa@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Education Hausa students
student_user_211 = User.objects.create_user(
    first_name='Umar', last_name='Yau', identification_num='201031005211', email='umaryau@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_212 = User.objects.create_user(
    first_name='Ali', last_name='Ali', identification_num='201031005212', email='aliali@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_213 = User.objects.create_user(
    first_name='Lambda', last_name='Isaac', identification_num='201031005213', email='lambdaisaac@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_214 = User.objects.create_user(
    first_name='Iya', last_name='Tambai', identification_num='201031005214', email='iyatambai@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_215 = User.objects.create_user(
    first_name='Gambo', last_name='Soba', identification_num='201031005215', email='gambosoba@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_216 = User.objects.create_user(
    first_name='Haruna', last_name='Oyo', identification_num='201031005216', email='harunaoyo@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_217 = User.objects.create_user(
    first_name='Babatunde', last_name='Arrabi', identification_num='201031005217', email='babatundearrabi@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_218 = User.objects.create_user(
    first_name='Harvard', last_name='Chris', identification_num='201031005218', email='harvardchris@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_219 = User.objects.create_user(
    first_name='Sani', last_name='Yarima', identification_num='201031005219', email='saniyarima@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_220 = User.objects.create_user(
    first_name='Ahmad', last_name='Lawal', identification_num='201031005220', email='ahmadlawal@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Education History students
student_user_221 = User.objects.create_user(
    first_name='Sunny', last_name='Agba', identification_num='201031005221', email='sunnyagba@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_222 = User.objects.create_user(
    first_name='Alaji', last_name='Nura', identification_num='201031005222', email='alajinura@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_223 = User.objects.create_user(
    first_name='Nass', last_name='Kabir', identification_num='201031005223', email='nasskabir@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_224 = User.objects.create_user(
    first_name='Inuwa', last_name='Danladi', identification_num='201031005224', email='inuwadanladi@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_225 = User.objects.create_user(
    first_name='Haruna', last_name='Khidir', identification_num='201031005225', email='harunakhidir@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_226 = User.objects.create_user(
    first_name='Babanjae', last_name='Hanwa', identification_num='201031005226', email='babanjaehanwa@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_227 = User.objects.create_user(
    first_name='Idris', last_name='Bala', identification_num='201031005227', email='idrisbala@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_228 = User.objects.create_user(
    first_name='Davido', last_name='Chales', identification_num='201031005228', email='davidochales@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_229 = User.objects.create_user(
    first_name='Sadiq', last_name='Dudu', identification_num='201031005229', email='sadiqdudu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_230 = User.objects.create_user(
    first_name='Kabido', last_name='Alamin', identification_num='201031005230', email='kabidoalamin@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Education Islamic Studies students
student_user_231 = User.objects.create_user(
    first_name='Barau', last_name='Ismail', identification_num='201031005231', email='barauismail@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_232 = User.objects.create_user(
    first_name='Lawal', last_name='Nura', identification_num='201031005232', email='lawalnura@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_233 = User.objects.create_user(
    first_name='Nafiu', last_name='Yahaya', identification_num='201031005233', email='nafiuyahaya@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_234 = User.objects.create_user(
    first_name='Halilu', last_name='Kofa', identification_num='201031005234', email='halilukofa@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_235 = User.objects.create_user(
    first_name='Yau', last_name='Malam', identification_num='201031005235', email='yaumalam@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_236 = User.objects.create_user(
    first_name='Mohammed', last_name='Shariff', identification_num='201031005236', email='mohammedshariff@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_237 = User.objects.create_user(
    first_name='Tahir', last_name='Waje', identification_num='201031005237', email='tahirwaje@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_238 = User.objects.create_user(
    first_name='Najibu', last_name='Usman', identification_num='201031005238', email='najibuusman@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_239 = User.objects.create_user(
    first_name='Ahmad', last_name='Alamin', identification_num='201031005239', email='ahmadalamin@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_240 = User.objects.create_user(
    first_name='Nura', last_name='Sadik', identification_num='201031005240', email='nurasadik@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Education Mathematics students
student_user_241 = User.objects.create_user(
    first_name='Bello', last_name='Abdu', identification_num='201031005241', email='belloabdu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_242 = User.objects.create_user(
    first_name='Jazuli', last_name='Anas', identification_num='201031005242', email='jazulianas@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_243 = User.objects.create_user(
    first_name='Badamasi', last_name='Anka', identification_num='201031005243', email='badamasianka@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_244 = User.objects.create_user(
    first_name='Usman', last_name='Abuja', identification_num='201031005244', email='usmanabuja@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_245 = User.objects.create_user(
    first_name='Ilyas', last_name='Abdul', identification_num='201031005245', email='ilyasabdul@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_246 = User.objects.create_user(
    first_name='Ashiru', last_name='Ishaq', identification_num='201031005246', email='ashiruishaq@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_247 = User.objects.create_user(
    first_name='Shamaila', last_name='Nura', identification_num='201031005247', email='shamailanura@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_248 = User.objects.create_user(
    first_name='Amadu', last_name='Ali', identification_num='201031005248', email='amaduali@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_249 = User.objects.create_user(
    first_name='Tukur', last_name='Sani', identification_num='201031005249', email='tukursani@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_250 = User.objects.create_user(
    first_name='James', last_name='Bado', identification_num='201031005250', email='jamesbado@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Education Physics students
student_user_251 = User.objects.create_user(
    first_name='Oliver', last_name='Yusuf', identification_num='201031005251', email='oliveryusuf@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_252 = User.objects.create_user(
    first_name='Hayatu', last_name='Buhari', identification_num='201031005252', email='hayatubuhari@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_253 = User.objects.create_user(
    first_name='Sani', last_name='Baba', identification_num='201031005253', email='sanibaba@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_254 = User.objects.create_user(
    first_name='Amadu', last_name='Salis', identification_num='201031005254', email='amadusalis@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_255 = User.objects.create_user(
    first_name='Lawi', last_name='Usman', identification_num='201031005255', email='lawiusman@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_256 = User.objects.create_user(
    first_name='Mamuda', last_name='Ibrahim', identification_num='201031005256', email='mamudaibrahim@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_257 = User.objects.create_user(
    first_name='Ashiru', last_name='Ali', identification_num='201031005257', email='ashiruali@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_258 = User.objects.create_user(
    first_name='Sunday', last_name='Ben', identification_num='201031005258', email='sundayben@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_259 = User.objects.create_user(
    first_name='Iyal', last_name='Nasir', identification_num='201031005259', email='iyalnasir@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_260 = User.objects.create_user(
    first_name='Abbas', last_name='Usama', identification_num='201031005260', email='abbasusama@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Accounting students
student_user_261 = User.objects.create_user(
    first_name='Musa', last_name='Isah', identification_num='201031005261', email='musaisah@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_262 = User.objects.create_user(
    first_name='Isah', last_name='Ayuba', identification_num='201031005262', email='isaayuba@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_263 = User.objects.create_user(
    first_name='Attahiru', last_name='Akuyam', identification_num='201031005263', email='attahiruakuyam@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_264 = User.objects.create_user(
    first_name='Murtala', last_name='Kota', identification_num='201031005264', email='murtalakota@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_265 = User.objects.create_user(
    first_name='Shehu', last_name='Sheikh', identification_num='201031005265', email='shehusheikh@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_266 = User.objects.create_user(
    first_name='Samsin', last_name='John', identification_num='201031005266', email='samsinjohn@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_267 = User.objects.create_user(
    first_name='Nura', last_name='Saulawa', identification_num='201031005267', email='nurasaulawa@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_268 = User.objects.create_user(
    first_name='Tahir', last_name='Inuwa', identification_num='201031005268', email='tahirinuwa@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_269 = User.objects.create_user(
    first_name='Mamman', last_name='Abakar', identification_num='201031005269', email='mammanabakar@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_270 = User.objects.create_user(
    first_name='Yakubu', last_name='Police', identification_num='201031005270', email='yakubupolice@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Business Administration students
student_user_271 = User.objects.create_user(
    first_name='Lawal', last_name='Sani', identification_num='201031005271', email='lawalsani@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_272 = User.objects.create_user(
    first_name='Sani', last_name='Yahuza', identification_num='201031005272', email='saniyahuza@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_273 = User.objects.create_user(
    first_name='Iyal', last_name='Kawu', identification_num='201031005273', email='iyalkawu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_274 = User.objects.create_user(
    first_name='Hafiz', last_name='Jazuli', identification_num='201031005274', email='hafizjazuli@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_275 = User.objects.create_user(
    first_name='Ishaq', last_name='Usman', identification_num='201031005275', email='ishaqusman@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_276 = User.objects.create_user(
    first_name='Muhammad', last_name='Aminu', identification_num='201031005276', email='muhammadaminu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_277 = User.objects.create_user(
    first_name='Jabir', last_name='Nura', identification_num='201031005277', email='jabirnura@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_278 = User.objects.create_user(
    first_name='Ibrahim', last_name='Kambari', identification_num='201031005278', email='ibrahimkambari@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_279 = User.objects.create_user(
    first_name='Salahu', last_name='Soja', identification_num='201031005279', email='salahusoja@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_280 = User.objects.create_user(
    first_name='Usman', last_name='Zahradeen', identification_num='201031005280', email='usmanzahradeen@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Economics students
student_user_281 = User.objects.create_user(
    first_name='Nawab', last_name='Isa', identification_num='201031005281', email='nawabisa@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_282 = User.objects.create_user(
    first_name='Ali', last_name='Gwarzo', identification_num='201031005282', email='aligwarzo@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_283 = User.objects.create_user(
    first_name='Salisu', last_name='Umar', identification_num='201031005283', email='salisuumar@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_284 = User.objects.create_user(
    first_name='Ifean', last_name='Chales', identification_num='201031005284', email='ifeanchales@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_285 = User.objects.create_user(
    first_name='Idris', last_name='Bala', identification_num='201031005285', email='idrisbala@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_286 = User.objects.create_user(
    first_name='Nura', last_name='Salim', identification_num='201031005286', email='nurasalim@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_287 = User.objects.create_user(
    first_name='Hayatu', last_name='Bala', identification_num='201031005287', email='hayatubala@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_288 = User.objects.create_user(
    first_name='Isa', last_name='Zanna', identification_num='201031005288', email='isazanna@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_289 = User.objects.create_user(
    first_name='Nura', last_name='Zaria', identification_num='201031005289', email='nurazaria@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_290 = User.objects.create_user(
    first_name='Talle', last_name='Aminu', identification_num='201031005290', email='talleaminu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Political science students
student_user_291 = User.objects.create_user(
    first_name='Sani', last_name='Yahaya', identification_num='201031005291', email='saniyahaya@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_292 = User.objects.create_user(
    first_name='Samir', last_name='Abdullahi', identification_num='201031005292', email='samirabdullahi@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_293 = User.objects.create_user(
    first_name='Idris', last_name='Shehu', identification_num='201031005293', email='idrisshehu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_294 = User.objects.create_user(
    first_name='Ayuba', last_name='Ubale', identification_num='201031005294', email='ayubaubale@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_295 = User.objects.create_user(
    first_name='Salmanu', last_name='Sule', identification_num='201031005295', email='salmanusule@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_296 = User.objects.create_user(
    first_name='Zakari', last_name='Abbas', identification_num='201031005296', email='zakariabbas@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_297 = User.objects.create_user(
    first_name='Tamimu', last_name='Chiroma', identification_num='201031005297', email='tanimuchiroma@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_298 = User.objects.create_user(
    first_name='Ismail', last_name='Lawal', identification_num='201031005298', email='ismaillawal@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_299 = User.objects.create_user(
    first_name='Nura', last_name='Yau', identification_num='201031005299', email='nurayau@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_300 = User.objects.create_user(
    first_name='Auwal', last_name='Kanoma', identification_num='201031005300', email='auwalkanoma@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Public Administration students
student_user_301 = User.objects.create_user(
    first_name='Najib', last_name='Ibrahim', identification_num='201031005301', email='najibibrahim@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_302 = User.objects.create_user(
    first_name='Surajo', last_name='Fada', identification_num='201031005302', email='surajofada@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_303 = User.objects.create_user(
    first_name='Alamin', last_name='Kano', identification_num='201031005303', email='alaminkano@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_304 = User.objects.create_user(
    first_name='Yusuf', last_name='Fagge', identification_num='201031005304', email='yusuffagge@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_305 = User.objects.create_user(
    first_name='Sulaiman', last_name='Idris', identification_num='201031005305', email='sulaimanidris@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_306 = User.objects.create_user(
    first_name='Haruna', last_name='Bau', identification_num='201031005306', email='harunabau@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_307 = User.objects.create_user(
    first_name='Idris', last_name='Bala', identification_num='201031005307', email='idrisbala@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_308 = User.objects.create_user(
    first_name='Saminu', last_name='Giwa', identification_num='201031005308', email='saminugiwa@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_309 = User.objects.create_user(
    first_name='Jaafar', last_name='Lawal', identification_num='201031005309', email='jaafarlawal@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_310 = User.objects.create_user(
    first_name='Tijjani', last_name='Nura', identification_num='201031005310', email='tijjaninura@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

# Sociology students
student_user_311 = User.objects.create_user(
    first_name='Usman', last_name='Muhammad', identification_num='201031005311', email='usmanmuhammad@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_312 = User.objects.create_user(
    first_name='Yusuf', last_name='Nasir', identification_num='201031005312', email='yusufnasir@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_313 = User.objects.create_user(
    first_name='Idris', last_name='Hayatu', identification_num='201031005313', email='idrishayatu@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_314 = User.objects.create_user(
    first_name='Isah', last_name='Sadiku', identification_num='201031005314', email='isahsadiku@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_315 = User.objects.create_user(
    first_name='Ibrahim', last_name='Anas', identification_num='201031005315', email='ibrahimanas@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_316 = User.objects.create_user(
    first_name='Hamza', last_name='Tukur', identification_num='201031005316', email='hamzatukur@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_317 = User.objects.create_user(
    first_name='Buhari', last_name='Bola', identification_num='201031005317', email='buharibola@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_318 = User.objects.create_user(
    first_name='Babagana', last_name='Khalid', identification_num='201031005318', email='babaganakhalid@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_319 = User.objects.create_user(
    first_name='Ilyasu', last_name='Abdulgaffar', identification_num='201031005319', email='ilyasuabdulgaffar@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set
student_user_320 = User.objects.create_user(
    first_name='Haruna', last_name='Jabaka', identification_num='201031005320', email='harunajabaka@mail.com', phone_number='+2348144807233', is_student=True) # user_password_not_set

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
# Physics students
student_1 = TrainingStudent(
    student=student_user_1, faculty=faculty_1, department=dept_1, student_training_coordinator=coord_user_1, first_name=student_user_1.first_name, last_name=student_user_1.last_name, matrix_no=student_user_1.identification_num, email=student_user_1.email, phone_number=student_user_1.phone_number, level='300', is_in_school=True, session=curr_sess.session)
student_2 = TrainingStudent(
    student=student_user_2, faculty=faculty_1, department=dept_1, student_training_coordinator=coord_user_1, first_name=student_user_2.first_name, last_name=student_user_2.last_name, matrix_no=student_user_2.identification_num, email=student_user_2.email, phone_number=student_user_2.phone_number, is_in_school=True, session=curr_sess.session)
student_3 = TrainingStudent(
    student=student_user_3, faculty=faculty_1, department=dept_1, student_training_coordinator=coord_user_1, first_name=student_user_3.first_name, last_name=student_user_3.last_name, matrix_no=student_user_3.identification_num, email=student_user_3.email, phone_number=student_user_3.phone_number, is_in_school=True, session=curr_sess.session)
student_4 = TrainingStudent(
    student=student_user_4, faculty=faculty_1, department=dept_1, student_training_coordinator=coord_user_1, first_name=student_user_4.first_name, last_name=student_user_4.last_name, matrix_no=student_user_4.identification_num, email=student_user_4.email, phone_number=student_user_4.phone_number, is_in_school=True, session=curr_sess.session)
student_5 = TrainingStudent(
    student=student_user_5, faculty=faculty_1, department=dept_1, student_training_coordinator=coord_user_1, first_name=student_user_5.first_name, last_name=student_user_5.last_name, matrix_no=student_user_5.identification_num, email=student_user_5.email, phone_number=student_user_5.phone_number, is_in_school=True, session=curr_sess.session)
student_6 = TrainingStudent(
    student=student_user_6, faculty=faculty_1, department=dept_1, student_training_coordinator=coord_user_1, first_name=student_user_6.first_name, last_name=student_user_6.last_name, matrix_no=student_user_6.identification_num, email=student_user_6.email, phone_number=student_user_6.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_7 = TrainingStudent(
    student=student_user_7, faculty=faculty_1, department=dept_1, student_training_coordinator=coord_user_1, first_name=student_user_7.first_name, last_name=student_user_7.last_name, matrix_no=student_user_7.identification_num, email=student_user_7.email, phone_number=student_user_7.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_8 = TrainingStudent(
    student=student_user_8, faculty=faculty_1, department=dept_1, student_training_coordinator=coord_user_1, first_name=student_user_8.first_name, last_name=student_user_8.last_name, matrix_no=student_user_8.identification_num, email=student_user_8.email, phone_number=student_user_8.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_9 = TrainingStudent(
    student=student_user_9, faculty=faculty_1, department=dept_1, student_training_coordinator=coord_user_1, first_name=student_user_9.first_name, last_name=student_user_9.last_name, matrix_no=student_user_9.identification_num, email=student_user_9.email, phone_number=student_user_9.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_10 = TrainingStudent(
    student=student_user_10, faculty=faculty_1, department=dept_1, student_training_coordinator=coord_user_1, first_name=student_user_10.first_name, last_name=student_user_10.last_name, matrix_no=student_user_10.identification_num, email=student_user_10.email, phone_number=student_user_10.phone_number, is_in_school=True, session=curr_sess.session, level=200)

# Computer Science students
student_11 = TrainingStudent(
    student=student_user_11, faculty=faculty_1, department=dept_2, student_training_coordinator=coord_user_2, first_name=student_user_11.first_name, last_name=student_user_11.last_name, matrix_no=student_user_11.identification_num, email=student_user_11.email, phone_number=student_user_11.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_12 = TrainingStudent(
    student=student_user_12, faculty=faculty_1, department=dept_2, student_training_coordinator=coord_user_2, first_name=student_user_12.first_name, last_name=student_user_12.last_name, matrix_no=student_user_12.identification_num, email=student_user_12.email, phone_number=student_user_12.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_13 = TrainingStudent(
    student=student_user_13, faculty=faculty_1, department=dept_2, student_training_coordinator=coord_user_2, first_name=student_user_13.first_name, last_name=student_user_13.last_name, matrix_no=student_user_13.identification_num, email=student_user_13.email, phone_number=student_user_13.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_14 = TrainingStudent(
    student=student_user_14, faculty=faculty_1, department=dept_2, student_training_coordinator=coord_user_2, first_name=student_user_14.first_name, last_name=student_user_14.last_name, matrix_no=student_user_14.identification_num, email=student_user_14.email, phone_number=student_user_14.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_15 = TrainingStudent(
    student=student_user_15, faculty=faculty_1, department=dept_2, student_training_coordinator=coord_user_2, first_name=student_user_15.first_name, last_name=student_user_15.last_name, matrix_no=student_user_15.identification_num, email=student_user_15.email, phone_number=student_user_15.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_16 = TrainingStudent(
    student=student_user_16, faculty=faculty_1, department=dept_2, student_training_coordinator=coord_user_2, first_name=student_user_16.first_name, last_name=student_user_16.last_name, matrix_no=student_user_16.identification_num, email=student_user_16.email, phone_number=student_user_16.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_17 = TrainingStudent(
    student=student_user_17, faculty=faculty_1, department=dept_2, student_training_coordinator=coord_user_2, first_name=student_user_17.first_name, last_name=student_user_17.last_name, matrix_no=student_user_17.identification_num, email=student_user_17.email, phone_number=student_user_17.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_18 = TrainingStudent(
    student=student_user_18, faculty=faculty_1, department=dept_2, student_training_coordinator=coord_user_2, first_name=student_user_18.first_name, last_name=student_user_18.last_name, matrix_no=student_user_18.identification_num, email=student_user_18.email, phone_number=student_user_18.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_19 = TrainingStudent(
    student=student_user_19, faculty=faculty_1, department=dept_2, student_training_coordinator=coord_user_2, first_name=student_user_19.first_name, last_name=student_user_19.last_name, matrix_no=student_user_19.identification_num, email=student_user_19.email, phone_number=student_user_19.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_20 = TrainingStudent(
    student=student_user_20, faculty=faculty_1, department=dept_2, student_training_coordinator=coord_user_2, first_name=student_user_20.first_name, last_name=student_user_20.last_name, matrix_no=student_user_20.identification_num, email=student_user_20.email, phone_number=student_user_20.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# Mathematics students
student_21 = TrainingStudent(
    student=student_user_21, faculty=faculty_1, department=dept_3, student_training_coordinator=coord_user_3, first_name=student_user_21.first_name, last_name=student_user_21.last_name, matrix_no=student_user_21.identification_num, email=student_user_21.email, phone_number=student_user_21.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_22 = TrainingStudent(
    student=student_user_22, faculty=faculty_1, department=dept_3, student_training_coordinator=coord_user_3, first_name=student_user_22.first_name, last_name=student_user_22.last_name, matrix_no=student_user_22.identification_num, email=student_user_22.email, phone_number=student_user_22.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_23 = TrainingStudent(
    student=student_user_23, faculty=faculty_1, department=dept_3, student_training_coordinator=coord_user_3, first_name=student_user_23.first_name, last_name=student_user_23.last_name, matrix_no=student_user_23.identification_num, email=student_user_23.email, phone_number=student_user_23.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_24 = TrainingStudent(
    student=student_user_24, faculty=faculty_1, department=dept_3, student_training_coordinator=coord_user_3, first_name=student_user_24.first_name, last_name=student_user_24.last_name, matrix_no=student_user_24.identification_num, email=student_user_24.email, phone_number=student_user_24.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_25 = TrainingStudent(
    student=student_user_25, faculty=faculty_1, department=dept_3, student_training_coordinator=coord_user_3, first_name=student_user_25.first_name, last_name=student_user_25.last_name, matrix_no=student_user_25.identification_num, email=student_user_25.email, phone_number=student_user_25.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_26 = TrainingStudent(
    student=student_user_26, faculty=faculty_1, department=dept_3, student_training_coordinator=coord_user_3, first_name=student_user_26.first_name, last_name=student_user_26.last_name, matrix_no=student_user_26.identification_num, email=student_user_26.email, phone_number=student_user_26.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_27 = TrainingStudent(
    student=student_user_27, faculty=faculty_1, department=dept_3, student_training_coordinator=coord_user_3, first_name=student_user_27.first_name, last_name=student_user_27.last_name, matrix_no=student_user_27.identification_num, email=student_user_27.email, phone_number=student_user_27.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_28 = TrainingStudent(
    student=student_user_28, faculty=faculty_1, department=dept_3, student_training_coordinator=coord_user_3, first_name=student_user_28.first_name, last_name=student_user_28.last_name, matrix_no=student_user_28.identification_num, email=student_user_28.email, phone_number=student_user_28.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_29 = TrainingStudent(
    student=student_user_29, faculty=faculty_1, department=dept_3, student_training_coordinator=coord_user_3, first_name=student_user_29.first_name, last_name=student_user_29.last_name, matrix_no=student_user_29.identification_num, email=student_user_29.email, phone_number=student_user_29.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_30 = TrainingStudent(
    student=student_user_30, faculty=faculty_1, department=dept_3, student_training_coordinator=coord_user_3, first_name=student_user_30.first_name, last_name=student_user_30.last_name, matrix_no=student_user_30.identification_num, email=student_user_30.email, phone_number=student_user_30.phone_number, is_in_school=True, session=curr_sess.session, level=200)

# Chemistry students
student_31 = TrainingStudent(
    student=student_user_31, faculty=faculty_1, department=dept_4, student_training_coordinator=coord_user_4, first_name=student_user_31.first_name, last_name=student_user_31.last_name, matrix_no=student_user_31.identification_num, email=student_user_31.email, phone_number=student_user_31.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_32 = TrainingStudent(
    student=student_user_32, faculty=faculty_1, department=dept_4, student_training_coordinator=coord_user_4, first_name=student_user_32.first_name, last_name=student_user_32.last_name, matrix_no=student_user_32.identification_num, email=student_user_32.email, phone_number=student_user_32.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_33 = TrainingStudent(
    student=student_user_33, faculty=faculty_1, department=dept_4, student_training_coordinator=coord_user_4, first_name=student_user_33.first_name, last_name=student_user_33.last_name, matrix_no=student_user_33.identification_num, email=student_user_33.email, phone_number=student_user_33.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_34 = TrainingStudent(
    student=student_user_34, faculty=faculty_1, department=dept_4, student_training_coordinator=coord_user_4, first_name=student_user_34.first_name, last_name=student_user_34.last_name, matrix_no=student_user_34.identification_num, email=student_user_34.email, phone_number=student_user_34.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_35 = TrainingStudent(
    student=student_user_35, faculty=faculty_1, department=dept_4, student_training_coordinator=coord_user_4, first_name=student_user_35.first_name, last_name=student_user_35.last_name, matrix_no=student_user_35.identification_num, email=student_user_35.email, phone_number=student_user_35.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_36 = TrainingStudent(
    student=student_user_36, faculty=faculty_1, department=dept_4, student_training_coordinator=coord_user_4, first_name=student_user_36.first_name, last_name=student_user_36.last_name, matrix_no=student_user_36.identification_num, email=student_user_36.email, phone_number=student_user_36.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_37 = TrainingStudent(
    student=student_user_37, faculty=faculty_1, department=dept_4, student_training_coordinator=coord_user_4, first_name=student_user_37.first_name, last_name=student_user_37.last_name, matrix_no=student_user_37.identification_num, email=student_user_37.email, phone_number=student_user_37.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_38 = TrainingStudent(
    student=student_user_38, faculty=faculty_1, department=dept_4, student_training_coordinator=coord_user_4, first_name=student_user_38.first_name, last_name=student_user_38.last_name, matrix_no=student_user_38.identification_num, email=student_user_38.email, phone_number=student_user_38.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_39 = TrainingStudent(
    student=student_user_39, faculty=faculty_1, department=dept_4, student_training_coordinator=coord_user_4, first_name=student_user_39.first_name, last_name=student_user_39.last_name, matrix_no=student_user_39.identification_num, email=student_user_39.email, phone_number=student_user_39.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_40 = TrainingStudent(
    student=student_user_40, faculty=faculty_1, department=dept_4, student_training_coordinator=coord_user_4, first_name=student_user_40.first_name, last_name=student_user_40.last_name, matrix_no=student_user_40.identification_num, email=student_user_40.email, phone_number=student_user_40.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# Biochemistry students
student_41 = TrainingStudent(
    student=student_user_41, faculty=faculty_1, department=dept_5, student_training_coordinator=coord_user_5, first_name=student_user_41.first_name, last_name=student_user_41.last_name, matrix_no=student_user_41.identification_num, email=student_user_41.email, phone_number=student_user_41.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_42 = TrainingStudent(
    student=student_user_42, faculty=faculty_1, department=dept_5, student_training_coordinator=coord_user_5, first_name=student_user_42.first_name, last_name=student_user_42.last_name, matrix_no=student_user_42.identification_num, email=student_user_42.email, phone_number=student_user_42.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_43 = TrainingStudent(
    student=student_user_43, faculty=faculty_1, department=dept_5, student_training_coordinator=coord_user_5, first_name=student_user_43.first_name, last_name=student_user_43.last_name, matrix_no=student_user_43.identification_num, email=student_user_43.email, phone_number=student_user_43.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_44 = TrainingStudent(
    student=student_user_44, faculty=faculty_1, department=dept_5, student_training_coordinator=coord_user_5, first_name=student_user_44.first_name, last_name=student_user_44.last_name, matrix_no=student_user_44.identification_num, email=student_user_44.email, phone_number=student_user_44.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_45 = TrainingStudent(
    student=student_user_45, faculty=faculty_1, department=dept_5, student_training_coordinator=coord_user_5, first_name=student_user_45.first_name, last_name=student_user_45.last_name, matrix_no=student_user_45.identification_num, email=student_user_45.email, phone_number=student_user_45.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_46 = TrainingStudent(
    student=student_user_46, faculty=faculty_1, department=dept_5, student_training_coordinator=coord_user_5, first_name=student_user_46.first_name, last_name=student_user_46.last_name, matrix_no=student_user_46.identification_num, email=student_user_46.email, phone_number=student_user_46.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_47 = TrainingStudent(
    student=student_user_47, faculty=faculty_1, department=dept_5, student_training_coordinator=coord_user_5, first_name=student_user_47.first_name, last_name=student_user_47.last_name, matrix_no=student_user_47.identification_num, email=student_user_47.email, phone_number=student_user_47.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_48 = TrainingStudent(
    student=student_user_48, faculty=faculty_1, department=dept_5, student_training_coordinator=coord_user_5, first_name=student_user_48.first_name, last_name=student_user_48.last_name, matrix_no=student_user_48.identification_num, email=student_user_48.email, phone_number=student_user_48.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_49 = TrainingStudent(
    student=student_user_49, faculty=faculty_1, department=dept_5, student_training_coordinator=coord_user_5, first_name=student_user_49.first_name, last_name=student_user_49.last_name, matrix_no=student_user_49.identification_num, email=student_user_49.email, phone_number=student_user_49.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_50 = TrainingStudent(
    student=student_user_50, faculty=faculty_1, department=dept_5, student_training_coordinator=coord_user_5, first_name=student_user_50.first_name, last_name=student_user_50.last_name, matrix_no=student_user_50.identification_num, email=student_user_50.email, phone_number=student_user_50.phone_number, is_in_school=True, session=curr_sess.session, level=200)

# Geology students
student_51 = TrainingStudent(
    student=student_user_51, faculty=faculty_1, department=dept_6, student_training_coordinator=coord_user_6, first_name=student_user_51.first_name, last_name=student_user_51.last_name, matrix_no=student_user_51.identification_num, email=student_user_51.email, phone_number=student_user_51.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_52 = TrainingStudent(
    student=student_user_52, faculty=faculty_1, department=dept_6, student_training_coordinator=coord_user_6, first_name=student_user_52.first_name, last_name=student_user_52.last_name, matrix_no=student_user_52.identification_num, email=student_user_52.email, phone_number=student_user_52.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_53 = TrainingStudent(
    student=student_user_53, faculty=faculty_1, department=dept_6, student_training_coordinator=coord_user_6, first_name=student_user_53.first_name, last_name=student_user_53.last_name, matrix_no=student_user_53.identification_num, email=student_user_53.email, phone_number=student_user_53.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_54 = TrainingStudent(
    student=student_user_54, faculty=faculty_1, department=dept_6, student_training_coordinator=coord_user_6, first_name=student_user_54.first_name, last_name=student_user_54.last_name, matrix_no=student_user_54.identification_num, email=student_user_54.email, phone_number=student_user_54.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_55 = TrainingStudent(
    student=student_user_55, faculty=faculty_1, department=dept_6, student_training_coordinator=coord_user_6, first_name=student_user_55.first_name, last_name=student_user_55.last_name, matrix_no=student_user_55.identification_num, email=student_user_55.email, phone_number=student_user_55.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_56 = TrainingStudent(
    student=student_user_56, faculty=faculty_1, department=dept_6, student_training_coordinator=coord_user_6, first_name=student_user_56.first_name, last_name=student_user_56.last_name, matrix_no=student_user_56.identification_num, email=student_user_56.email, phone_number=student_user_56.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_57 = TrainingStudent(
    student=student_user_57, faculty=faculty_1, department=dept_6, student_training_coordinator=coord_user_6, first_name=student_user_57.first_name, last_name=student_user_57.last_name, matrix_no=student_user_57.identification_num, email=student_user_57.email, phone_number=student_user_57.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_58 = TrainingStudent(
    student=student_user_58, faculty=faculty_1, department=dept_6, student_training_coordinator=coord_user_6, first_name=student_user_58.first_name, last_name=student_user_58.last_name, matrix_no=student_user_58.identification_num, email=student_user_58.email, phone_number=student_user_58.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_59 = TrainingStudent(
    student=student_user_59, faculty=faculty_1, department=dept_6, student_training_coordinator=coord_user_6, first_name=student_user_59.first_name, last_name=student_user_59.last_name, matrix_no=student_user_59.identification_num, email=student_user_59.email, phone_number=student_user_59.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_60 = TrainingStudent(
    student=student_user_60, faculty=faculty_1, department=dept_6, student_training_coordinator=coord_user_6, first_name=student_user_60.first_name, last_name=student_user_60.last_name, matrix_no=student_user_60.identification_num, email=student_user_60.email, phone_number=student_user_60.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# Microbiology students
student_61 = TrainingStudent(
    student=student_user_61, faculty=faculty_1, department=dept_7, student_training_coordinator=coord_user_7, first_name=student_user_61.first_name, last_name=student_user_61.last_name, matrix_no=student_user_61.identification_num, email=student_user_61.email, phone_number=student_user_61.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_62 = TrainingStudent(
    student=student_user_62, faculty=faculty_1, department=dept_7, student_training_coordinator=coord_user_7, first_name=student_user_62.first_name, last_name=student_user_62.last_name, matrix_no=student_user_62.identification_num, email=student_user_62.email, phone_number=student_user_62.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_63 = TrainingStudent(
    student=student_user_63, faculty=faculty_1, department=dept_7, student_training_coordinator=coord_user_7, first_name=student_user_63.first_name, last_name=student_user_63.last_name, matrix_no=student_user_63.identification_num, email=student_user_63.email, phone_number=student_user_63.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_64 = TrainingStudent(
    student=student_user_64, faculty=faculty_1, department=dept_7, student_training_coordinator=coord_user_7, first_name=student_user_64.first_name, last_name=student_user_64.last_name, matrix_no=student_user_64.identification_num, email=student_user_64.email, phone_number=student_user_64.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_65 = TrainingStudent(
    student=student_user_65, faculty=faculty_1, department=dept_7, student_training_coordinator=coord_user_7, first_name=student_user_65.first_name, last_name=student_user_65.last_name, matrix_no=student_user_65.identification_num, email=student_user_65.email, phone_number=student_user_65.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_66 = TrainingStudent(
    student=student_user_66, faculty=faculty_1, department=dept_7, student_training_coordinator=coord_user_7, first_name=student_user_66.first_name, last_name=student_user_66.last_name, matrix_no=student_user_66.identification_num, email=student_user_66.email, phone_number=student_user_66.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_67 = TrainingStudent(
    student=student_user_67, faculty=faculty_1, department=dept_7, student_training_coordinator=coord_user_7, first_name=student_user_67.first_name, last_name=student_user_67.last_name, matrix_no=student_user_67.identification_num, email=student_user_67.email, phone_number=student_user_67.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_68 = TrainingStudent(
    student=student_user_68, faculty=faculty_1, department=dept_7, student_training_coordinator=coord_user_7, first_name=student_user_68.first_name, last_name=student_user_68.last_name, matrix_no=student_user_68.identification_num, email=student_user_68.email, phone_number=student_user_68.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_69 = TrainingStudent(
    student=student_user_69, faculty=faculty_1, department=dept_7, student_training_coordinator=coord_user_29, first_name=student_user_69.first_name, last_name=student_user_69.last_name, matrix_no=student_user_69.identification_num, email=student_user_69.email, phone_number=student_user_69.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_70 = TrainingStudent(
    student=student_user_70, faculty=faculty_1, department=dept_7, student_training_coordinator=coord_user_7, first_name=student_user_70.first_name, last_name=student_user_70.last_name, matrix_no=student_user_70.identification_num, email=student_user_70.email, phone_number=student_user_70.phone_number, is_in_school=True, session=curr_sess.session, level=200)

# Plant science & biotechnology students
student_71 = TrainingStudent(
    student=student_user_71, faculty=faculty_1, department=dept_8, student_training_coordinator=coord_user_8, first_name=student_user_71.first_name, last_name=student_user_71.last_name, matrix_no=student_user_71.identification_num, email=student_user_71.email, phone_number=student_user_71.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_72 = TrainingStudent(
    student=student_user_72, faculty=faculty_1, department=dept_8, student_training_coordinator=coord_user_8, first_name=student_user_72.first_name, last_name=student_user_72.last_name, matrix_no=student_user_72.identification_num, email=student_user_72.email, phone_number=student_user_72.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_73 = TrainingStudent(
    student=student_user_73, faculty=faculty_1, department=dept_8, student_training_coordinator=coord_user_8, first_name=student_user_73.first_name, last_name=student_user_73.last_name, matrix_no=student_user_73.identification_num, email=student_user_73.email, phone_number=student_user_73.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_74 = TrainingStudent(
    student=student_user_74, faculty=faculty_1, department=dept_8, student_training_coordinator=coord_user_8, first_name=student_user_74.first_name, last_name=student_user_74.last_name, matrix_no=student_user_74.identification_num, email=student_user_74.email, phone_number=student_user_74.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_75 = TrainingStudent(
    student=student_user_75, faculty=faculty_1, department=dept_8, student_training_coordinator=coord_user_8, first_name=student_user_75.first_name, last_name=student_user_75.last_name, matrix_no=student_user_75.identification_num, email=student_user_75.email, phone_number=student_user_75.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_76 = TrainingStudent(
    student=student_user_76, faculty=faculty_1, department=dept_8, student_training_coordinator=coord_user_8, first_name=student_user_76.first_name, last_name=student_user_76.last_name, matrix_no=student_user_76.identification_num, email=student_user_76.email, phone_number=student_user_76.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_77 = TrainingStudent(
    student=student_user_77, faculty=faculty_1, department=dept_8, student_training_coordinator=coord_user_8, first_name=student_user_77.first_name, last_name=student_user_77.last_name, matrix_no=student_user_77.identification_num, email=student_user_77.email, phone_number=student_user_77.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_78 = TrainingStudent(
    student=student_user_78, faculty=faculty_1, department=dept_8, student_training_coordinator=coord_user_8, first_name=student_user_78.first_name, last_name=student_user_78.last_name, matrix_no=student_user_78.identification_num, email=student_user_78.email, phone_number=student_user_78.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_79 = TrainingStudent(
    student=student_user_79, faculty=faculty_1, department=dept_8, student_training_coordinator=coord_user_8, first_name=student_user_79.first_name, last_name=student_user_79.last_name, matrix_no=student_user_79.identification_num, email=student_user_79.email, phone_number=student_user_79.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_80 = TrainingStudent(
    student=student_user_80, faculty=faculty_1, department=dept_8, student_training_coordinator=coord_user_8, first_name=student_user_80.first_name, last_name=student_user_80.last_name, matrix_no=student_user_80.identification_num, email=student_user_80.email, phone_number=student_user_80.phone_number, is_in_school=True, session=curr_sess.session, level=200)

# Zoology students
student_81 = TrainingStudent(
    student=student_user_81, faculty=faculty_1, department=dept_9, student_training_coordinator=coord_user_9, first_name=student_user_81.first_name, last_name=student_user_81.last_name, matrix_no=student_user_81.identification_num, email=student_user_81.email, phone_number=student_user_81.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_82 = TrainingStudent(
    student=student_user_82, faculty=faculty_1, department=dept_9, student_training_coordinator=coord_user_9, first_name=student_user_82.first_name, last_name=student_user_82.last_name, matrix_no=student_user_82.identification_num, email=student_user_82.email, phone_number=student_user_82.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_83 = TrainingStudent(
    student=student_user_83, faculty=faculty_1, department=dept_9, student_training_coordinator=coord_user_9, first_name=student_user_83.first_name, last_name=student_user_83.last_name, matrix_no=student_user_83.identification_num, email=student_user_83.email, phone_number=student_user_83.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_84 = TrainingStudent(
    student=student_user_84, faculty=faculty_1, department=dept_9, student_training_coordinator=coord_user_9, first_name=student_user_84.first_name, last_name=student_user_84.last_name, matrix_no=student_user_84.identification_num, email=student_user_84.email, phone_number=student_user_84.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_85 = TrainingStudent(
    student=student_user_85, faculty=faculty_1, department=dept_9, student_training_coordinator=coord_user_9, first_name=student_user_85.first_name, last_name=student_user_85.last_name, matrix_no=student_user_85.identification_num, email=student_user_85.email, phone_number=student_user_85.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_86 = TrainingStudent(
    student=student_user_86, faculty=faculty_1, department=dept_9, student_training_coordinator=coord_user_18, first_name=student_user_86.first_name, last_name=student_user_86.last_name, matrix_no=student_user_86.identification_num, email=student_user_86.email, phone_number=student_user_86.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_87 = TrainingStudent(
    student=student_user_87, faculty=faculty_1, department=dept_9, student_training_coordinator=coord_user_9, first_name=student_user_87.first_name, last_name=student_user_87.last_name, matrix_no=student_user_87.identification_num, email=student_user_87.email, phone_number=student_user_87.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_88 = TrainingStudent(
    student=student_user_88, faculty=faculty_1, department=dept_9, student_training_coordinator=coord_user_9, first_name=student_user_88.first_name, last_name=student_user_88.last_name, matrix_no=student_user_88.identification_num, email=student_user_88.email, phone_number=student_user_88.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_89 = TrainingStudent(
    student=student_user_89, faculty=faculty_1, department=dept_9, student_training_coordinator=coord_user_9, first_name=student_user_89.first_name, last_name=student_user_89.last_name, matrix_no=student_user_89.identification_num, email=student_user_89.email, phone_number=student_user_89.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_90 = TrainingStudent(
    student=student_user_90, faculty=faculty_1, department=dept_9, student_training_coordinator=coord_user_9, first_name=student_user_90.first_name, last_name=student_user_90.last_name, matrix_no=student_user_90.identification_num, email=student_user_90.email, phone_number=student_user_90.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# Biology students
student_91 = TrainingStudent(
    student=student_user_91, faculty=faculty_1, department=dept_10, student_training_coordinator=coord_user_10, first_name=student_user_91.first_name, last_name=student_user_91.last_name, matrix_no=student_user_91.identification_num, email=student_user_91.email, phone_number=student_user_91.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_92 = TrainingStudent(
    student=student_user_92, faculty=faculty_1, department=dept_10, student_training_coordinator=coord_user_10, first_name=student_user_92.first_name, last_name=student_user_92.last_name, matrix_no=student_user_92.identification_num, email=student_user_92.email, phone_number=student_user_92.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_93 = TrainingStudent(
    student=student_user_93, faculty=faculty_1, department=dept_10, student_training_coordinator=coord_user_10, first_name=student_user_93.first_name, last_name=student_user_93.last_name, matrix_no=student_user_93.identification_num, email=student_user_93.email, phone_number=student_user_93.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_94 = TrainingStudent(
    student=student_user_94, faculty=faculty_1, department=dept_10, student_training_coordinator=coord_user_10, first_name=student_user_94.first_name, last_name=student_user_94.last_name, matrix_no=student_user_94.identification_num, email=student_user_94.email, phone_number=student_user_94.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_95 = TrainingStudent(
    student=student_user_95, faculty=faculty_1, department=dept_10, student_training_coordinator=coord_user_10, first_name=student_user_95.first_name, last_name=student_user_95.last_name, matrix_no=student_user_95.identification_num, email=student_user_95.email, phone_number=student_user_95.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_96 = TrainingStudent(
    student=student_user_96, faculty=faculty_1, department=dept_10, student_training_coordinator=coord_user_10, first_name=student_user_96.first_name, last_name=student_user_96.last_name, matrix_no=student_user_96.identification_num, email=student_user_96.email, phone_number=student_user_96.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_97 = TrainingStudent(
    student=student_user_97, faculty=faculty_1, department=dept_10, student_training_coordinator=coord_user_10, first_name=student_user_97.first_name, last_name=student_user_97.last_name, matrix_no=student_user_97.identification_num, email=student_user_97.email, phone_number=student_user_97.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_98 = TrainingStudent(
    student=student_user_98, faculty=faculty_1, department=dept_10, student_training_coordinator=coord_user_10, first_name=student_user_98.first_name, last_name=student_user_98.last_name, matrix_no=student_user_98.identification_num, email=student_user_98.email, phone_number=student_user_98.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_99 = TrainingStudent(
    student=student_user_99, faculty=faculty_1, department=dept_10, student_training_coordinator=coord_user_10, first_name=student_user_99.first_name, last_name=student_user_99.last_name, matrix_no=student_user_99.identification_num, email=student_user_99.email, phone_number=student_user_99.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_100 = TrainingStudent(
    student=student_user_100, faculty=faculty_1, department=dept_10, student_training_coordinator=coord_user_10, first_name=student_user_100.first_name, last_name=student_user_100.last_name, matrix_no=student_user_100.identification_num, email=student_user_100.email, phone_number=student_user_100.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# Arabic Language students
student_101 = TrainingStudent(
    student=student_user_101, faculty=faculty_2, department=dept_11, student_training_coordinator=coord_user_11, first_name=student_user_101.first_name, last_name=student_user_101.last_name, matrix_no=student_user_101.identification_num, email=student_user_101.email, phone_number=student_user_101.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_102 = TrainingStudent(
    student=student_user_102, faculty=faculty_2, department=dept_11, student_training_coordinator=coord_user_11, first_name=student_user_102.first_name, last_name=student_user_102.last_name, matrix_no=student_user_102.identification_num, email=student_user_102.email, phone_number=student_user_102.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_103 = TrainingStudent(
    student=student_user_103, faculty=faculty_2, department=dept_11, student_training_coordinator=coord_user_11, first_name=student_user_103.first_name, last_name=student_user_103.last_name, matrix_no=student_user_103.identification_num, email=student_user_103.email, phone_number=student_user_103.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_104 = TrainingStudent(
    student=student_user_104, faculty=faculty_2, department=dept_11, student_training_coordinator=coord_user_11, first_name=student_user_104.first_name, last_name=student_user_104.last_name, matrix_no=student_user_104.identification_num, email=student_user_104.email, phone_number=student_user_104.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_105 = TrainingStudent(
    student=student_user_105, faculty=faculty_2, department=dept_11, student_training_coordinator=coord_user_11, first_name=student_user_105.first_name, last_name=student_user_105.last_name, matrix_no=student_user_105.identification_num, email=student_user_105.email, phone_number=student_user_105.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_106 = TrainingStudent(
    student=student_user_106, faculty=faculty_2, department=dept_11, student_training_coordinator=coord_user_11, first_name=student_user_106.first_name, last_name=student_user_106.last_name, matrix_no=student_user_106.identification_num, email=student_user_106.email, phone_number=student_user_106.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_107 = TrainingStudent(
    student=student_user_107, faculty=faculty_2, department=dept_11, student_training_coordinator=coord_user_11, first_name=student_user_107.first_name, last_name=student_user_107.last_name, matrix_no=student_user_107.identification_num, email=student_user_107.email, phone_number=student_user_107.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_108 = TrainingStudent(
    student=student_user_108, faculty=faculty_2, department=dept_11, student_training_coordinator=coord_user_11, first_name=student_user_108.first_name, last_name=student_user_108.last_name, matrix_no=student_user_108.identification_num, email=student_user_108.email, phone_number=student_user_108.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_109 = TrainingStudent(
    student=student_user_109, faculty=faculty_2, department=dept_11, student_training_coordinator=coord_user_11, first_name=student_user_109.first_name, last_name=student_user_109.last_name, matrix_no=student_user_109.identification_num, email=student_user_109.email, phone_number=student_user_109.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_110 = TrainingStudent(
    student=student_user_110, faculty=faculty_2, department=dept_11, student_training_coordinator=coord_user_11, first_name=student_user_110.first_name, last_name=student_user_110.last_name, matrix_no=student_user_110.identification_num, email=student_user_110.email, phone_number=student_user_110.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# English Language students
student_111 = TrainingStudent(
    student=student_user_111, faculty=faculty_2, department=dept_12, student_training_coordinator=coord_user_12, first_name=student_user_111.first_name, last_name=student_user_111.last_name, matrix_no=student_user_111.identification_num, email=student_user_111.email, phone_number=student_user_111.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_112 = TrainingStudent(
    student=student_user_112, faculty=faculty_2, department=dept_12, student_training_coordinator=coord_user_12, first_name=student_user_112.first_name, last_name=student_user_112.last_name, matrix_no=student_user_112.identification_num, email=student_user_112.email, phone_number=student_user_112.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_113 = TrainingStudent(
    student=student_user_113, faculty=faculty_2, department=dept_12, student_training_coordinator=coord_user_12, first_name=student_user_113.first_name, last_name=student_user_113.last_name, matrix_no=student_user_113.identification_num, email=student_user_113.email, phone_number=student_user_113.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_114 = TrainingStudent(
    student=student_user_114, faculty=faculty_2, department=dept_12, student_training_coordinator=coord_user_12, first_name=student_user_114.first_name, last_name=student_user_114.last_name, matrix_no=student_user_114.identification_num, email=student_user_114.email, phone_number=student_user_114.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_115 = TrainingStudent(
    student=student_user_115, faculty=faculty_2, department=dept_12, student_training_coordinator=coord_user_12, first_name=student_user_115.first_name, last_name=student_user_115.last_name, matrix_no=student_user_115.identification_num, email=student_user_115.email, phone_number=student_user_115.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_116 = TrainingStudent(
    student=student_user_116, faculty=faculty_2, department=dept_12, student_training_coordinator=coord_user_12, first_name=student_user_116.first_name, last_name=student_user_116.last_name, matrix_no=student_user_116.identification_num, email=student_user_116.email, phone_number=student_user_116.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_117 = TrainingStudent(
    student=student_user_117, faculty=faculty_2, department=dept_12, student_training_coordinator=coord_user_12, first_name=student_user_117.first_name, last_name=student_user_117.last_name, matrix_no=student_user_117.identification_num, email=student_user_117.email, phone_number=student_user_117.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_118 = TrainingStudent(
    student=student_user_118, faculty=faculty_2, department=dept_12, student_training_coordinator=coord_user_12, first_name=student_user_118.first_name, last_name=student_user_118.last_name, matrix_no=student_user_118.identification_num, email=student_user_118.email, phone_number=student_user_118.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_119 = TrainingStudent(
    student=student_user_119, faculty=faculty_2, department=dept_12, student_training_coordinator=coord_user_12, first_name=student_user_119.first_name, last_name=student_user_119.last_name, matrix_no=student_user_119.identification_num, email=student_user_119.email, phone_number=student_user_119.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_120 = TrainingStudent(
    student=student_user_120, faculty=faculty_2, department=dept_12, student_training_coordinator=coord_user_12, first_name=student_user_120.first_name, last_name=student_user_120.last_name, matrix_no=student_user_120.identification_num, email=student_user_120.email, phone_number=student_user_120.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# French students
student_121 = TrainingStudent(
    student=student_user_121, faculty=faculty_2, department=dept_13, student_training_coordinator=coord_user_13, first_name=student_user_121.first_name, last_name=student_user_121.last_name, matrix_no=student_user_121.identification_num, email=student_user_121.email, phone_number=student_user_121.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_122 = TrainingStudent(
    student=student_user_122, faculty=faculty_2, department=dept_13, student_training_coordinator=coord_user_13, first_name=student_user_122.first_name, last_name=student_user_122.last_name, matrix_no=student_user_122.identification_num, email=student_user_122.email, phone_number=student_user_122.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_123 = TrainingStudent(
    student=student_user_123, faculty=faculty_2, department=dept_13, student_training_coordinator=coord_user_13, first_name=student_user_123.first_name, last_name=student_user_123.last_name, matrix_no=student_user_123.identification_num, email=student_user_123.email, phone_number=student_user_123.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_124 = TrainingStudent(
    student=student_user_124, faculty=faculty_2, department=dept_13, student_training_coordinator=coord_user_13, first_name=student_user_124.first_name, last_name=student_user_124.last_name, matrix_no=student_user_124.identification_num, email=student_user_124.email, phone_number=student_user_124.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_125 = TrainingStudent(
    student=student_user_125, faculty=faculty_2, department=dept_13, student_training_coordinator=coord_user_13, first_name=student_user_125.first_name, last_name=student_user_125.last_name, matrix_no=student_user_125.identification_num, email=student_user_125.email, phone_number=student_user_125.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_126 = TrainingStudent(
    student=student_user_126, faculty=faculty_2, department=dept_13, student_training_coordinator=coord_user_13, first_name=student_user_126.first_name, last_name=student_user_126.last_name, matrix_no=student_user_126.identification_num, email=student_user_126.email, phone_number=student_user_126.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_127 = TrainingStudent(
    student=student_user_127, faculty=faculty_2, department=dept_13, student_training_coordinator=coord_user_13, first_name=student_user_127.first_name, last_name=student_user_127.last_name, matrix_no=student_user_127.identification_num, email=student_user_127.email, phone_number=student_user_127.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_128 = TrainingStudent(
    student=student_user_128, faculty=faculty_2, department=dept_13, student_training_coordinator=coord_user_13, first_name=student_user_128.first_name, last_name=student_user_128.last_name, matrix_no=student_user_128.identification_num, email=student_user_128.email, phone_number=student_user_128.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_129 = TrainingStudent(
    student=student_user_129, faculty=faculty_2, department=dept_13, student_training_coordinator=coord_user_13, first_name=student_user_129.first_name, last_name=student_user_129.last_name, matrix_no=student_user_129.identification_num, email=student_user_129.email, phone_number=student_user_129.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_130 = TrainingStudent(
    student=student_user_130, faculty=faculty_2, department=dept_13, student_training_coordinator=coord_user_13, first_name=student_user_130.first_name, last_name=student_user_130.last_name, matrix_no=student_user_130.identification_num, email=student_user_130.email, phone_number=student_user_130.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# Hausa students
student_131 = TrainingStudent(
    student=student_user_131, faculty=faculty_2, department=dept_14, student_training_coordinator=coord_user_14, first_name=student_user_131.first_name, last_name=student_user_131.last_name, matrix_no=student_user_131.identification_num, email=student_user_131.email, phone_number=student_user_131.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_132 = TrainingStudent(
    student=student_user_132, faculty=faculty_2, department=dept_14, student_training_coordinator=coord_user_14, first_name=student_user_132.first_name, last_name=student_user_132.last_name, matrix_no=student_user_132.identification_num, email=student_user_132.email, phone_number=student_user_132.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_133 = TrainingStudent(
    student=student_user_133, faculty=faculty_2, department=dept_14, student_training_coordinator=coord_user_14, first_name=student_user_133.first_name, last_name=student_user_133.last_name, matrix_no=student_user_133.identification_num, email=student_user_133.email, phone_number=student_user_133.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_134 = TrainingStudent(
    student=student_user_134, faculty=faculty_2, department=dept_14, student_training_coordinator=coord_user_14, first_name=student_user_134.first_name, last_name=student_user_134.last_name, matrix_no=student_user_134.identification_num, email=student_user_134.email, phone_number=student_user_134.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_135 = TrainingStudent(
    student=student_user_135, faculty=faculty_2, department=dept_14, student_training_coordinator=coord_user_14, first_name=student_user_135.first_name, last_name=student_user_135.last_name, matrix_no=student_user_135.identification_num, email=student_user_135.email, phone_number=student_user_135.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_136 = TrainingStudent(
    student=student_user_136, faculty=faculty_2, department=dept_14, student_training_coordinator=coord_user_14, first_name=student_user_136.first_name, last_name=student_user_136.last_name, matrix_no=student_user_136.identification_num, email=student_user_136.email, phone_number=student_user_136.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_137 = TrainingStudent(
    student=student_user_137, faculty=faculty_2, department=dept_14, student_training_coordinator=coord_user_14, first_name=student_user_137.first_name, last_name=student_user_137.last_name, matrix_no=student_user_137.identification_num, email=student_user_137.email, phone_number=student_user_137.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_138 = TrainingStudent(
    student=student_user_138, faculty=faculty_2, department=dept_14, student_training_coordinator=coord_user_14, first_name=student_user_138.first_name, last_name=student_user_138.last_name, matrix_no=student_user_138.identification_num, email=student_user_138.email, phone_number=student_user_138.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_139 = TrainingStudent(
    student=student_user_139, faculty=faculty_2, department=dept_14, student_training_coordinator=coord_user_14, first_name=student_user_139.first_name, last_name=student_user_139.last_name, matrix_no=student_user_139.identification_num, email=student_user_139.email, phone_number=student_user_139.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_140 = TrainingStudent(
    student=student_user_140, faculty=faculty_2, department=dept_14, student_training_coordinator=coord_user_14, first_name=student_user_140.first_name, last_name=student_user_140.last_name, matrix_no=student_user_140.identification_num, email=student_user_140.email, phone_number=student_user_140.phone_number, is_in_school=True, session=curr_sess.session, level=200)

# History students
student_141 = TrainingStudent(
    student=student_user_141, faculty=faculty_2, department=dept_15, student_training_coordinator=coord_user_15, first_name=student_user_141.first_name, last_name=student_user_141.last_name, matrix_no=student_user_141.identification_num, email=student_user_141.email, phone_number=student_user_141.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_142 = TrainingStudent(
    student=student_user_142, faculty=faculty_2, department=dept_15, student_training_coordinator=coord_user_15, first_name=student_user_142.first_name, last_name=student_user_142.last_name, matrix_no=student_user_142.identification_num, email=student_user_142.email, phone_number=student_user_142.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_143 = TrainingStudent(
    student=student_user_143, faculty=faculty_2, department=dept_15, student_training_coordinator=coord_user_15, first_name=student_user_143.first_name, last_name=student_user_143.last_name, matrix_no=student_user_143.identification_num, email=student_user_143.email, phone_number=student_user_143.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_144 = TrainingStudent(
    student=student_user_144, faculty=faculty_2, department=dept_15, student_training_coordinator=coord_user_15, first_name=student_user_144.first_name, last_name=student_user_144.last_name, matrix_no=student_user_144.identification_num, email=student_user_144.email, phone_number=student_user_144.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_145 = TrainingStudent(
    student=student_user_145, faculty=faculty_2, department=dept_15, student_training_coordinator=coord_user_15, first_name=student_user_145.first_name, last_name=student_user_145.last_name, matrix_no=student_user_145.identification_num, email=student_user_145.email, phone_number=student_user_145.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_146 = TrainingStudent(
    student=student_user_146, faculty=faculty_2, department=dept_15, student_training_coordinator=coord_user_15, first_name=student_user_146.first_name, last_name=student_user_146.last_name, matrix_no=student_user_146.identification_num, email=student_user_146.email, phone_number=student_user_146.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_147 = TrainingStudent(
    student=student_user_147, faculty=faculty_2, department=dept_15, student_training_coordinator=coord_user_15, first_name=student_user_147.first_name, last_name=student_user_147.last_name, matrix_no=student_user_147.identification_num, email=student_user_147.email, phone_number=student_user_147.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_148 = TrainingStudent(
    student=student_user_148, faculty=faculty_2, department=dept_15, student_training_coordinator=coord_user_15, first_name=student_user_148.first_name, last_name=student_user_148.last_name, matrix_no=student_user_148.identification_num, email=student_user_148.email, phone_number=student_user_148.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_149 = TrainingStudent(
    student=student_user_149, faculty=faculty_2, department=dept_15, student_training_coordinator=coord_user_15, first_name=student_user_149.first_name, last_name=student_user_149.last_name, matrix_no=student_user_149.identification_num, email=student_user_149.email, phone_number=student_user_149.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_150 = TrainingStudent(
    student=student_user_150, faculty=faculty_2, department=dept_15, student_training_coordinator=coord_user_15, first_name=student_user_150.first_name, last_name=student_user_150.last_name, matrix_no=student_user_150.identification_num, email=student_user_150.email, phone_number=student_user_150.phone_number, is_in_school=True, session=curr_sess.session, level=200)

# Islamic Studies students
student_151 = TrainingStudent(
    student=student_user_151, faculty=faculty_2, department=dept_16, student_training_coordinator=coord_user_16, first_name=student_user_151.first_name, last_name=student_user_151.last_name, matrix_no=student_user_151.identification_num, email=student_user_151.email, phone_number=student_user_151.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_152 = TrainingStudent(
    student=student_user_152, faculty=faculty_2, department=dept_16, student_training_coordinator=coord_user_16, first_name=student_user_152.first_name, last_name=student_user_152.last_name, matrix_no=student_user_152.identification_num, email=student_user_152.email, phone_number=student_user_152.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_153 = TrainingStudent(
    student=student_user_153, faculty=faculty_2, department=dept_16, student_training_coordinator=coord_user_16, first_name=student_user_153.first_name, last_name=student_user_153.last_name, matrix_no=student_user_153.identification_num, email=student_user_153.email, phone_number=student_user_153.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_154 = TrainingStudent(
    student=student_user_154, faculty=faculty_2, department=dept_16, student_training_coordinator=coord_user_16, first_name=student_user_154.first_name, last_name=student_user_154.last_name, matrix_no=student_user_154.identification_num, email=student_user_154.email, phone_number=student_user_154.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_155 = TrainingStudent(
    student=student_user_155, faculty=faculty_2, department=dept_16, student_training_coordinator=coord_user_16, first_name=student_user_155.first_name, last_name=student_user_155.last_name, matrix_no=student_user_155.identification_num, email=student_user_155.email, phone_number=student_user_155.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_156 = TrainingStudent(
    student=student_user_156, faculty=faculty_2, department=dept_16, student_training_coordinator=coord_user_16, first_name=student_user_156.first_name, last_name=student_user_156.last_name, matrix_no=student_user_156.identification_num, email=student_user_156.email, phone_number=student_user_156.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_157 = TrainingStudent(
    student=student_user_157, faculty=faculty_2, department=dept_16, student_training_coordinator=coord_user_16, first_name=student_user_157.first_name, last_name=student_user_157.last_name, matrix_no=student_user_157.identification_num, email=student_user_157.email, phone_number=student_user_157.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_158 = TrainingStudent(
    student=student_user_158, faculty=faculty_2, department=dept_16, student_training_coordinator=coord_user_16, first_name=student_user_158.first_name, last_name=student_user_158.last_name, matrix_no=student_user_158.identification_num, email=student_user_158.email, phone_number=student_user_158.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_159 = TrainingStudent(
    student=student_user_159, faculty=faculty_2, department=dept_16, student_training_coordinator=coord_user_16, first_name=student_user_159.first_name, last_name=student_user_159.last_name, matrix_no=student_user_159.identification_num, email=student_user_159.email, phone_number=student_user_159.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_160 = TrainingStudent(
    student=student_user_160, faculty=faculty_2, department=dept_16, student_training_coordinator=coord_user_16, first_name=student_user_160.first_name, last_name=student_user_160.last_name, matrix_no=student_user_160.identification_num, email=student_user_160.email, phone_number=student_user_160.phone_number, is_in_school=True, session=curr_sess.session, level=200)

# Education Arabic students
student_161 = TrainingStudent(
    student=student_user_161, faculty=faculty_3, department=dept_17, student_training_coordinator=coord_user_17, first_name=student_user_161.first_name, last_name=student_user_161.last_name, matrix_no=student_user_161.identification_num, email=student_user_161.email, phone_number=student_user_161.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_162 = TrainingStudent(
    student=student_user_162, faculty=faculty_3, department=dept_17, student_training_coordinator=coord_user_17, first_name=student_user_162.first_name, last_name=student_user_162.last_name, matrix_no=student_user_162.identification_num, email=student_user_162.email, phone_number=student_user_162.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_163 = TrainingStudent(
    student=student_user_163, faculty=faculty_3, department=dept_17, student_training_coordinator=coord_user_17, first_name=student_user_163.first_name, last_name=student_user_163.last_name, matrix_no=student_user_163.identification_num, email=student_user_163.email, phone_number=student_user_163.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_164 = TrainingStudent(
    student=student_user_164, faculty=faculty_3, department=dept_17, student_training_coordinator=coord_user_17, first_name=student_user_164.first_name, last_name=student_user_164.last_name, matrix_no=student_user_164.identification_num, email=student_user_164.email, phone_number=student_user_164.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_165 = TrainingStudent(
    student=student_user_165, faculty=faculty_3, department=dept_17, student_training_coordinator=coord_user_17, first_name=student_user_165.first_name, last_name=student_user_165.last_name, matrix_no=student_user_165.identification_num, email=student_user_165.email, phone_number=student_user_165.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_166 = TrainingStudent(
    student=student_user_166, faculty=faculty_3, department=dept_17, student_training_coordinator=coord_user_17, first_name=student_user_166.first_name, last_name=student_user_166.last_name, matrix_no=student_user_166.identification_num, email=student_user_166.email, phone_number=student_user_166.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_167 = TrainingStudent(
    student=student_user_167, faculty=faculty_3, department=dept_17, student_training_coordinator=coord_user_17, first_name=student_user_167.first_name, last_name=student_user_167.last_name, matrix_no=student_user_167.identification_num, email=student_user_167.email, phone_number=student_user_167.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_168 = TrainingStudent(
    student=student_user_168, faculty=faculty_3, department=dept_17, student_training_coordinator=coord_user_17, first_name=student_user_168.first_name, last_name=student_user_168.last_name, matrix_no=student_user_168.identification_num, email=student_user_168.email, phone_number=student_user_168.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_169 = TrainingStudent(
    student=student_user_169, faculty=faculty_3, department=dept_17, student_training_coordinator=coord_user_17, first_name=student_user_169.first_name, last_name=student_user_169.last_name, matrix_no=student_user_169.identification_num, email=student_user_169.email, phone_number=student_user_169.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_170 = TrainingStudent(
    student=student_user_170, faculty=faculty_3, department=dept_17, student_training_coordinator=coord_user_17, first_name=student_user_170.first_name, last_name=student_user_170.last_name, matrix_no=student_user_170.identification_num, email=student_user_170.email, phone_number=student_user_170.phone_number, is_in_school=True, session=curr_sess.session, level=200)

# Education Biology students
student_171 = TrainingStudent(
    student=student_user_171, faculty=faculty_3, department=dept_18, student_training_coordinator=coord_user_18, first_name=student_user_171.first_name, last_name=student_user_171.last_name, matrix_no=student_user_171.identification_num, email=student_user_171.email, phone_number=student_user_171.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_172 = TrainingStudent(
    student=student_user_172, faculty=faculty_3, department=dept_18, student_training_coordinator=coord_user_18, first_name=student_user_172.first_name, last_name=student_user_172.last_name, matrix_no=student_user_172.identification_num, email=student_user_172.email, phone_number=student_user_172.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_173 = TrainingStudent(
    student=student_user_173, faculty=faculty_3, department=dept_18, student_training_coordinator=coord_user_18, first_name=student_user_173.first_name, last_name=student_user_173.last_name, matrix_no=student_user_173.identification_num, email=student_user_173.email, phone_number=student_user_173.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_174 = TrainingStudent(
    student=student_user_174, faculty=faculty_3, department=dept_18, student_training_coordinator=coord_user_18, first_name=student_user_174.first_name, last_name=student_user_174.last_name, matrix_no=student_user_174.identification_num, email=student_user_174.email, phone_number=student_user_174.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_175 = TrainingStudent(
    student=student_user_175, faculty=faculty_3, department=dept_18, student_training_coordinator=coord_user_18, first_name=student_user_175.first_name, last_name=student_user_175.last_name, matrix_no=student_user_175.identification_num, email=student_user_175.email, phone_number=student_user_175.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_176 = TrainingStudent(
    student=student_user_176, faculty=faculty_3, department=dept_18, student_training_coordinator=coord_user_18, first_name=student_user_176.first_name, last_name=student_user_176.last_name, matrix_no=student_user_176.identification_num, email=student_user_176.email, phone_number=student_user_176.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_177 = TrainingStudent(
    student=student_user_177, faculty=faculty_3, department=dept_18, student_training_coordinator=coord_user_18, first_name=student_user_177.first_name, last_name=student_user_177.last_name, matrix_no=student_user_177.identification_num, email=student_user_177.email, phone_number=student_user_177.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_178 = TrainingStudent(
    student=student_user_178, faculty=faculty_3, department=dept_18, student_training_coordinator=coord_user_18, first_name=student_user_178.first_name, last_name=student_user_178.last_name, matrix_no=student_user_178.identification_num, email=student_user_178.email, phone_number=student_user_178.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_179 = TrainingStudent(
    student=student_user_179, faculty=faculty_3, department=dept_18, student_training_coordinator=coord_user_18, first_name=student_user_179.first_name, last_name=student_user_179.last_name, matrix_no=student_user_179.identification_num, email=student_user_179.email, phone_number=student_user_179.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_180 = TrainingStudent(
    student=student_user_180, faculty=faculty_3, department=dept_18, student_training_coordinator=coord_user_18, first_name=student_user_180.first_name, last_name=student_user_180.last_name, matrix_no=student_user_180.identification_num, email=student_user_180.email, phone_number=student_user_180.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# Education Chemistry students
student_181 = TrainingStudent(
    student=student_user_181, faculty=faculty_3, department=dept_19, student_training_coordinator=coord_user_19, first_name=student_user_181.first_name, last_name=student_user_181.last_name, matrix_no=student_user_181.identification_num, email=student_user_181.email, phone_number=student_user_181.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_182 = TrainingStudent(
    student=student_user_182, faculty=faculty_3, department=dept_19, student_training_coordinator=coord_user_19, first_name=student_user_182.first_name, last_name=student_user_182.last_name, matrix_no=student_user_182.identification_num, email=student_user_182.email, phone_number=student_user_182.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_183 = TrainingStudent(
    student=student_user_183, faculty=faculty_3, department=dept_19, student_training_coordinator=coord_user_19, first_name=student_user_183.first_name, last_name=student_user_183.last_name, matrix_no=student_user_183.identification_num, email=student_user_183.email, phone_number=student_user_183.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_184 = TrainingStudent(
    student=student_user_184, faculty=faculty_3, department=dept_19, student_training_coordinator=coord_user_19, first_name=student_user_184.first_name, last_name=student_user_184.last_name, matrix_no=student_user_184.identification_num, email=student_user_184.email, phone_number=student_user_184.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_185 = TrainingStudent(
    student=student_user_185, faculty=faculty_3, department=dept_19, student_training_coordinator=coord_user_19, first_name=student_user_185.first_name, last_name=student_user_185.last_name, matrix_no=student_user_185.identification_num, email=student_user_185.email, phone_number=student_user_185.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_186 = TrainingStudent(
    student=student_user_186, faculty=faculty_3, department=dept_19, student_training_coordinator=coord_user_19, first_name=student_user_186.first_name, last_name=student_user_186.last_name, matrix_no=student_user_186.identification_num, email=student_user_186.email, phone_number=student_user_186.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_187 = TrainingStudent(
    student=student_user_187, faculty=faculty_3, department=dept_19, student_training_coordinator=coord_user_19, first_name=student_user_187.first_name, last_name=student_user_187.last_name, matrix_no=student_user_187.identification_num, email=student_user_187.email, phone_number=student_user_187.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_188 = TrainingStudent(
    student=student_user_188, faculty=faculty_3, department=dept_19, student_training_coordinator=coord_user_19, first_name=student_user_188.first_name, last_name=student_user_188.last_name, matrix_no=student_user_188.identification_num, email=student_user_188.email, phone_number=student_user_188.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_189 = TrainingStudent(
    student=student_user_189, faculty=faculty_3, department=dept_19, student_training_coordinator=coord_user_19, first_name=student_user_189.first_name, last_name=student_user_189.last_name, matrix_no=student_user_189.identification_num, email=student_user_189.email, phone_number=student_user_189.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_190 = TrainingStudent(
    student=student_user_190, faculty=faculty_3, department=dept_19, student_training_coordinator=coord_user_19, first_name=student_user_190.first_name, last_name=student_user_190.last_name, matrix_no=student_user_190.identification_num, email=student_user_190.email, phone_number=student_user_190.phone_number, is_in_school=True, session=curr_sess.session, level=200)

# Education Economics students
student_191 = TrainingStudent(
    student=student_user_191, faculty=faculty_3, department=dept_20, student_training_coordinator=coord_user_20, first_name=student_user_191.first_name, last_name=student_user_191.last_name, matrix_no=student_user_191.identification_num, email=student_user_191.email, phone_number=student_user_191.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_192 = TrainingStudent(
    student=student_user_192, faculty=faculty_3, department=dept_20, student_training_coordinator=coord_user_20, first_name=student_user_192.first_name, last_name=student_user_192.last_name, matrix_no=student_user_192.identification_num, email=student_user_192.email, phone_number=student_user_192.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_193 = TrainingStudent(
    student=student_user_193, faculty=faculty_3, department=dept_20, student_training_coordinator=coord_user_20, first_name=student_user_193.first_name, last_name=student_user_193.last_name, matrix_no=student_user_193.identification_num, email=student_user_193.email, phone_number=student_user_193.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_194 = TrainingStudent(
    student=student_user_194, faculty=faculty_3, department=dept_20, student_training_coordinator=coord_user_20, first_name=student_user_194.first_name, last_name=student_user_194.last_name, matrix_no=student_user_194.identification_num, email=student_user_194.email, phone_number=student_user_194.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_195 = TrainingStudent(
    student=student_user_195, faculty=faculty_3, department=dept_20, student_training_coordinator=coord_user_20, first_name=student_user_195.first_name, last_name=student_user_195.last_name, matrix_no=student_user_195.identification_num, email=student_user_195.email, phone_number=student_user_195.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_196 = TrainingStudent(
    student=student_user_196, faculty=faculty_3, department=dept_20, student_training_coordinator=coord_user_20, first_name=student_user_196.first_name, last_name=student_user_196.last_name, matrix_no=student_user_196.identification_num, email=student_user_196.email, phone_number=student_user_196.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_197 = TrainingStudent(
    student=student_user_197, faculty=faculty_3, department=dept_20, student_training_coordinator=coord_user_20, first_name=student_user_197.first_name, last_name=student_user_197.last_name, matrix_no=student_user_197.identification_num, email=student_user_197.email, phone_number=student_user_197.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_198 = TrainingStudent(
    student=student_user_198, faculty=faculty_3, department=dept_20, student_training_coordinator=coord_user_20, first_name=student_user_198.first_name, last_name=student_user_198.last_name, matrix_no=student_user_198.identification_num, email=student_user_198.email, phone_number=student_user_198.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_199 = TrainingStudent(
    student=student_user_199, faculty=faculty_3, department=dept_20, student_training_coordinator=coord_user_20, first_name=student_user_199.first_name, last_name=student_user_199.last_name, matrix_no=student_user_199.identification_num, email=student_user_199.email, phone_number=student_user_199.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_200 = TrainingStudent(
    student=student_user_200, faculty=faculty_3, department=dept_20, student_training_coordinator=coord_user_20, first_name=student_user_200.first_name, last_name=student_user_200.last_name, matrix_no=student_user_200.identification_num, email=student_user_200.email, phone_number=student_user_200.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# Education English students
student_201 = TrainingStudent(
    student=student_user_201, faculty=faculty_3, department=dept_21, student_training_coordinator=coord_user_21, first_name=student_user_201.first_name, last_name=student_user_201.last_name, matrix_no=student_user_201.identification_num, email=student_user_201.email, phone_number=student_user_201.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_202 = TrainingStudent(
    student=student_user_202, faculty=faculty_3, department=dept_21, student_training_coordinator=coord_user_31, first_name=student_user_202.first_name, last_name=student_user_202.last_name, matrix_no=student_user_202.identification_num, email=student_user_202.email, phone_number=student_user_202.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_203 = TrainingStudent(
    student=student_user_203, faculty=faculty_3, department=dept_21, student_training_coordinator=coord_user_21, first_name=student_user_203.first_name, last_name=student_user_203.last_name, matrix_no=student_user_203.identification_num, email=student_user_203.email, phone_number=student_user_203.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_204 = TrainingStudent(
    student=student_user_204, faculty=faculty_3, department=dept_21, student_training_coordinator=coord_user_21, first_name=student_user_204.first_name, last_name=student_user_204.last_name, matrix_no=student_user_204.identification_num, email=student_user_204.email, phone_number=student_user_204.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_205 = TrainingStudent(
    student=student_user_205, faculty=faculty_3, department=dept_21, student_training_coordinator=coord_user_21, first_name=student_user_205.first_name, last_name=student_user_205.last_name, matrix_no=student_user_205.identification_num, email=student_user_205.email, phone_number=student_user_205.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_206 = TrainingStudent(
    student=student_user_206, faculty=faculty_3, department=dept_21, student_training_coordinator=coord_user_21, first_name=student_user_206.first_name, last_name=student_user_206.last_name, matrix_no=student_user_206.identification_num, email=student_user_206.email, phone_number=student_user_206.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_207 = TrainingStudent(
    student=student_user_207, faculty=faculty_3, department=dept_21, student_training_coordinator=coord_user_21, first_name=student_user_207.first_name, last_name=student_user_207.last_name, matrix_no=student_user_207.identification_num, email=student_user_207.email, phone_number=student_user_207.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_208 = TrainingStudent(
    student=student_user_208, faculty=faculty_3, department=dept_21, student_training_coordinator=coord_user_21, first_name=student_user_208.first_name, last_name=student_user_208.last_name, matrix_no=student_user_208.identification_num, email=student_user_208.email, phone_number=student_user_208.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_209 = TrainingStudent(
    student=student_user_209, faculty=faculty_3, department=dept_21, student_training_coordinator=coord_user_21, first_name=student_user_209.first_name, last_name=student_user_209.last_name, matrix_no=student_user_209.identification_num, email=student_user_209.email, phone_number=student_user_209.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_210 = TrainingStudent(
    student=student_user_210, faculty=faculty_3, department=dept_21, student_training_coordinator=coord_user_21, first_name=student_user_210.first_name, last_name=student_user_210.last_name, matrix_no=student_user_210.identification_num, email=student_user_210.email, phone_number=student_user_210.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# Education Hausa students
student_211 = TrainingStudent(
    student=student_user_211, faculty=faculty_3, department=dept_22, student_training_coordinator=coord_user_22, first_name=student_user_211.first_name, last_name=student_user_211.last_name, matrix_no=student_user_211.identification_num, email=student_user_211.email, phone_number=student_user_211.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_212 = TrainingStudent(
    student=student_user_212, faculty=faculty_3, department=dept_22, student_training_coordinator=coord_user_22, first_name=student_user_212.first_name, last_name=student_user_212.last_name, matrix_no=student_user_212.identification_num, email=student_user_212.email, phone_number=student_user_212.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_213 = TrainingStudent(
    student=student_user_213, faculty=faculty_3, department=dept_22, student_training_coordinator=coord_user_22, first_name=student_user_213.first_name, last_name=student_user_213.last_name, matrix_no=student_user_213.identification_num, email=student_user_213.email, phone_number=student_user_213.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_214 = TrainingStudent(
    student=student_user_214, faculty=faculty_3, department=dept_22, student_training_coordinator=coord_user_22, first_name=student_user_214.first_name, last_name=student_user_214.last_name, matrix_no=student_user_214.identification_num, email=student_user_214.email, phone_number=student_user_214.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_215 = TrainingStudent(
    student=student_user_215, faculty=faculty_3, department=dept_22, student_training_coordinator=coord_user_22, first_name=student_user_215.first_name, last_name=student_user_215.last_name, matrix_no=student_user_215.identification_num, email=student_user_215.email, phone_number=student_user_215.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_216 = TrainingStudent(
    student=student_user_216, faculty=faculty_3, department=dept_22, student_training_coordinator=coord_user_22, first_name=student_user_216.first_name, last_name=student_user_216.last_name, matrix_no=student_user_216.identification_num, email=student_user_216.email, phone_number=student_user_216.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_217 = TrainingStudent(
    student=student_user_217, faculty=faculty_3, department=dept_22, student_training_coordinator=coord_user_22, first_name=student_user_217.first_name, last_name=student_user_217.last_name, matrix_no=student_user_217.identification_num, email=student_user_217.email, phone_number=student_user_217.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_218 = TrainingStudent(
    student=student_user_218, faculty=faculty_3, department=dept_22, student_training_coordinator=coord_user_22, first_name=student_user_218.first_name, last_name=student_user_218.last_name, matrix_no=student_user_218.identification_num, email=student_user_218.email, phone_number=student_user_218.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_219 = TrainingStudent(
    student=student_user_219, faculty=faculty_3, department=dept_22, student_training_coordinator=coord_user_22, first_name=student_user_219.first_name, last_name=student_user_219.last_name, matrix_no=student_user_219.identification_num, email=student_user_219.email, phone_number=student_user_219.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_220 = TrainingStudent(
    student=student_user_220, faculty=faculty_3, department=dept_22, student_training_coordinator=coord_user_22, first_name=student_user_220.first_name, last_name=student_user_220.last_name, matrix_no=student_user_220.identification_num, email=student_user_220.email, phone_number=student_user_220.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# Education History students
student_221 = TrainingStudent(
    student=student_user_221, faculty=faculty_3, department=dept_23, student_training_coordinator=coord_user_23, first_name=student_user_221.first_name, last_name=student_user_221.last_name, matrix_no=student_user_221.identification_num, email=student_user_221.email, phone_number=student_user_221.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_222 = TrainingStudent(
    student=student_user_222, faculty=faculty_3, department=dept_23, student_training_coordinator=coord_user_23, first_name=student_user_222.first_name, last_name=student_user_222.last_name, matrix_no=student_user_222.identification_num, email=student_user_222.email, phone_number=student_user_222.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_223 = TrainingStudent(
    student=student_user_223, faculty=faculty_3, department=dept_23, student_training_coordinator=coord_user_23, first_name=student_user_223.first_name, last_name=student_user_223.last_name, matrix_no=student_user_223.identification_num, email=student_user_223.email, phone_number=student_user_223.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_224 = TrainingStudent(
    student=student_user_224, faculty=faculty_3, department=dept_23, student_training_coordinator=coord_user_23, first_name=student_user_224.first_name, last_name=student_user_224.last_name, matrix_no=student_user_224.identification_num, email=student_user_224.email, phone_number=student_user_224.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_225 = TrainingStudent(
    student=student_user_225, faculty=faculty_3, department=dept_23, student_training_coordinator=coord_user_23, first_name=student_user_225.first_name, last_name=student_user_225.last_name, matrix_no=student_user_225.identification_num, email=student_user_225.email, phone_number=student_user_225.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_226 = TrainingStudent(
    student=student_user_226, faculty=faculty_3, department=dept_23, student_training_coordinator=coord_user_23, first_name=student_user_226.first_name, last_name=student_user_226.last_name, matrix_no=student_user_226.identification_num, email=student_user_226.email, phone_number=student_user_226.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_227 = TrainingStudent(
    student=student_user_227, faculty=faculty_3, department=dept_23, student_training_coordinator=coord_user_23, first_name=student_user_227.first_name, last_name=student_user_227.last_name, matrix_no=student_user_227.identification_num, email=student_user_227.email, phone_number=student_user_227.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_228 = TrainingStudent(
    student=student_user_228, faculty=faculty_3, department=dept_23, student_training_coordinator=coord_user_23, first_name=student_user_228.first_name, last_name=student_user_228.last_name, matrix_no=student_user_228.identification_num, email=student_user_228.email, phone_number=student_user_228.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_229 = TrainingStudent(
    student=student_user_229, faculty=faculty_3, department=dept_23, student_training_coordinator=coord_user_23, first_name=student_user_229.first_name, last_name=student_user_229.last_name, matrix_no=student_user_229.identification_num, email=student_user_229.email, phone_number=student_user_229.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_230 = TrainingStudent(
    student=student_user_230, faculty=faculty_3, department=dept_23, student_training_coordinator=coord_user_23, first_name=student_user_230.first_name, last_name=student_user_230.last_name, matrix_no=student_user_230.identification_num, email=student_user_230.email, phone_number=student_user_230.phone_number, is_in_school=True, session=curr_sess.session, level=200)

# Education Islamic Studies students
student_231 = TrainingStudent(
    student=student_user_231, faculty=faculty_3, department=dept_24, student_training_coordinator=coord_user_24, first_name=student_user_231.first_name, last_name=student_user_231.last_name, matrix_no=student_user_231.identification_num, email=student_user_231.email, phone_number=student_user_231.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_232 = TrainingStudent(
    student=student_user_232, faculty=faculty_3, department=dept_24, student_training_coordinator=coord_user_24, first_name=student_user_232.first_name, last_name=student_user_232.last_name, matrix_no=student_user_232.identification_num, email=student_user_232.email, phone_number=student_user_232.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_233 = TrainingStudent(
    student=student_user_233, faculty=faculty_3, department=dept_24, student_training_coordinator=coord_user_24, first_name=student_user_233.first_name, last_name=student_user_233.last_name, matrix_no=student_user_233.identification_num, email=student_user_233.email, phone_number=student_user_233.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_234 = TrainingStudent(
    student=student_user_234, faculty=faculty_3, department=dept_24, student_training_coordinator=coord_user_24, first_name=student_user_234.first_name, last_name=student_user_234.last_name, matrix_no=student_user_234.identification_num, email=student_user_234.email, phone_number=student_user_234.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_235 = TrainingStudent(
    student=student_user_235, faculty=faculty_3, department=dept_24, student_training_coordinator=coord_user_24, first_name=student_user_235.first_name, last_name=student_user_235.last_name, matrix_no=student_user_235.identification_num, email=student_user_235.email, phone_number=student_user_235.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_236 = TrainingStudent(
    student=student_user_236, faculty=faculty_3, department=dept_24, student_training_coordinator=coord_user_24, first_name=student_user_236.first_name, last_name=student_user_236.last_name, matrix_no=student_user_236.identification_num, email=student_user_236.email, phone_number=student_user_236.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_237 = TrainingStudent(
    student=student_user_237, faculty=faculty_3, department=dept_24, student_training_coordinator=coord_user_24, first_name=student_user_237.first_name, last_name=student_user_237.last_name, matrix_no=student_user_237.identification_num, email=student_user_237.email, phone_number=student_user_237.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_238 = TrainingStudent(
    student=student_user_238, faculty=faculty_3, department=dept_24, student_training_coordinator=coord_user_24, first_name=student_user_238.first_name, last_name=student_user_238.last_name, matrix_no=student_user_238.identification_num, email=student_user_238.email, phone_number=student_user_238.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_239 = TrainingStudent(
    student=student_user_239, faculty=faculty_3, department=dept_24, student_training_coordinator=coord_user_24, first_name=student_user_239.first_name, last_name=student_user_239.last_name, matrix_no=student_user_239.identification_num, email=student_user_239.email, phone_number=student_user_239.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_240 = TrainingStudent(
    student=student_user_240, faculty=faculty_3, department=dept_24, student_training_coordinator=coord_user_24, first_name=student_user_240.first_name, last_name=student_user_240.last_name, matrix_no=student_user_240.identification_num, email=student_user_240.email, phone_number=student_user_240.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# Education Mathematics students
student_241 = TrainingStudent(
    student=student_user_241, faculty=faculty_3, department=dept_25, student_training_coordinator=coord_user_25, first_name=student_user_241.first_name, last_name=student_user_241.last_name, matrix_no=student_user_241.identification_num, email=student_user_241.email, phone_number=student_user_241.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_242 = TrainingStudent(
    student=student_user_242, faculty=faculty_3, department=dept_25, student_training_coordinator=coord_user_25, first_name=student_user_242.first_name, last_name=student_user_242.last_name, matrix_no=student_user_242.identification_num, email=student_user_242.email, phone_number=student_user_242.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_243 = TrainingStudent(
    student=student_user_243, faculty=faculty_3, department=dept_25, student_training_coordinator=coord_user_25, first_name=student_user_243.first_name, last_name=student_user_243.last_name, matrix_no=student_user_243.identification_num, email=student_user_243.email, phone_number=student_user_243.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_244 = TrainingStudent(
    student=student_user_244, faculty=faculty_3, department=dept_25, student_training_coordinator=coord_user_25, first_name=student_user_244.first_name, last_name=student_user_244.last_name, matrix_no=student_user_244.identification_num, email=student_user_244.email, phone_number=student_user_244.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_245 = TrainingStudent(
    student=student_user_245, faculty=faculty_3, department=dept_25, student_training_coordinator=coord_user_25, first_name=student_user_245.first_name, last_name=student_user_245.last_name, matrix_no=student_user_245.identification_num, email=student_user_245.email, phone_number=student_user_245.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_246 = TrainingStudent(
    student=student_user_246, faculty=faculty_3, department=dept_25, student_training_coordinator=coord_user_25, first_name=student_user_246.first_name, last_name=student_user_246.last_name, matrix_no=student_user_246.identification_num, email=student_user_246.email, phone_number=student_user_246.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_247 = TrainingStudent(
    student=student_user_247, faculty=faculty_3, department=dept_25, student_training_coordinator=coord_user_25, first_name=student_user_247.first_name, last_name=student_user_247.last_name, matrix_no=student_user_247.identification_num, email=student_user_247.email, phone_number=student_user_247.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_248 = TrainingStudent(
    student=student_user_248, faculty=faculty_3, department=dept_25, student_training_coordinator=coord_user_25, first_name=student_user_248.first_name, last_name=student_user_248.last_name, matrix_no=student_user_248.identification_num, email=student_user_248.email, phone_number=student_user_248.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_249 = TrainingStudent(
    student=student_user_249, faculty=faculty_3, department=dept_25, student_training_coordinator=coord_user_25, first_name=student_user_249.first_name, last_name=student_user_249.last_name, matrix_no=student_user_249.identification_num, email=student_user_249.email, phone_number=student_user_249.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_250 = TrainingStudent(
    student=student_user_250, faculty=faculty_3, department=dept_25, student_training_coordinator=coord_user_25, first_name=student_user_250.first_name, last_name=student_user_250.last_name, matrix_no=student_user_250.identification_num, email=student_user_250.email, phone_number=student_user_250.phone_number, is_in_school=True, session=curr_sess.session, level=200)

# Education Physics students
student_251 = TrainingStudent(
    student=student_user_251, faculty=faculty_3, department=dept_26, student_training_coordinator=coord_user_26, first_name=student_user_251.first_name, last_name=student_user_251.last_name, matrix_no=student_user_251.identification_num, email=student_user_251.email, phone_number=student_user_251.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_252 = TrainingStudent(
    student=student_user_252, faculty=faculty_3, department=dept_26, student_training_coordinator=coord_user_26, first_name=student_user_252.first_name, last_name=student_user_252.last_name, matrix_no=student_user_252.identification_num, email=student_user_252.email, phone_number=student_user_252.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_253 = TrainingStudent(
    student=student_user_253, faculty=faculty_3, department=dept_26, student_training_coordinator=coord_user_26, first_name=student_user_253.first_name, last_name=student_user_253.last_name, matrix_no=student_user_253.identification_num, email=student_user_253.email, phone_number=student_user_253.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_254 = TrainingStudent(
    student=student_user_254, faculty=faculty_3, department=dept_26, student_training_coordinator=coord_user_26, first_name=student_user_254.first_name, last_name=student_user_254.last_name, matrix_no=student_user_254.identification_num, email=student_user_254.email, phone_number=student_user_254.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_255 = TrainingStudent(
    student=student_user_255, faculty=faculty_3, department=dept_26, student_training_coordinator=coord_user_26, first_name=student_user_255.first_name, last_name=student_user_255.last_name, matrix_no=student_user_255.identification_num, email=student_user_255.email, phone_number=student_user_255.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_256 = TrainingStudent(
    student=student_user_256, faculty=faculty_3, department=dept_26, student_training_coordinator=coord_user_26, first_name=student_user_256.first_name, last_name=student_user_256.last_name, matrix_no=student_user_256.identification_num, email=student_user_256.email, phone_number=student_user_256.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_257 = TrainingStudent(
    student=student_user_257, faculty=faculty_3, department=dept_26, student_training_coordinator=coord_user_26, first_name=student_user_257.first_name, last_name=student_user_257.last_name, matrix_no=student_user_257.identification_num, email=student_user_257.email, phone_number=student_user_257.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_258 = TrainingStudent(
    student=student_user_258, faculty=faculty_3, department=dept_26, student_training_coordinator=coord_user_26, first_name=student_user_258.first_name, last_name=student_user_258.last_name, matrix_no=student_user_258.identification_num, email=student_user_258.email, phone_number=student_user_258.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_259 = TrainingStudent(
    student=student_user_259, faculty=faculty_3, department=dept_26, student_training_coordinator=coord_user_26, first_name=student_user_259.first_name, last_name=student_user_259.last_name, matrix_no=student_user_259.identification_num, email=student_user_259.email, phone_number=student_user_259.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_260 = TrainingStudent(
    student=student_user_260, faculty=faculty_3, department=dept_26, student_training_coordinator=coord_user_26, first_name=student_user_260.first_name, last_name=student_user_260.last_name, matrix_no=student_user_260.identification_num, email=student_user_260.email, phone_number=student_user_260.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# Accounting students
student_261 = TrainingStudent(
    student=student_user_261, faculty=faculty_4, department=dept_27, student_training_coordinator=coord_user_27, first_name=student_user_261.first_name, last_name=student_user_261.last_name, matrix_no=student_user_261.identification_num, email=student_user_261.email, phone_number=student_user_261.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_262 = TrainingStudent(
    student=student_user_262, faculty=faculty_4, department=dept_27, student_training_coordinator=coord_user_27, first_name=student_user_262.first_name, last_name=student_user_262.last_name, matrix_no=student_user_262.identification_num, email=student_user_262.email, phone_number=student_user_262.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_263 = TrainingStudent(
    student=student_user_263, faculty=faculty_4, department=dept_27, student_training_coordinator=coord_user_27, first_name=student_user_263.first_name, last_name=student_user_263.last_name, matrix_no=student_user_263.identification_num, email=student_user_263.email, phone_number=student_user_263.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_264 = TrainingStudent(
    student=student_user_264, faculty=faculty_4, department=dept_27, student_training_coordinator=coord_user_27, first_name=student_user_264.first_name, last_name=student_user_264.last_name, matrix_no=student_user_264.identification_num, email=student_user_264.email, phone_number=student_user_264.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_265 = TrainingStudent(
    student=student_user_265, faculty=faculty_4, department=dept_27, student_training_coordinator=coord_user_27, first_name=student_user_265.first_name, last_name=student_user_265.last_name, matrix_no=student_user_265.identification_num, email=student_user_265.email, phone_number=student_user_265.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_266 = TrainingStudent(
    student=student_user_266, faculty=faculty_4, department=dept_27, student_training_coordinator=coord_user_27, first_name=student_user_266.first_name, last_name=student_user_266.last_name, matrix_no=student_user_266.identification_num, email=student_user_266.email, phone_number=student_user_266.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_267 = TrainingStudent(
    student=student_user_267, faculty=faculty_4, department=dept_27, student_training_coordinator=coord_user_27, first_name=student_user_267.first_name, last_name=student_user_267.last_name, matrix_no=student_user_267.identification_num, email=student_user_267.email, phone_number=student_user_267.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_268 = TrainingStudent(
    student=student_user_268, faculty=faculty_4, department=dept_27, student_training_coordinator=coord_user_27, first_name=student_user_268.first_name, last_name=student_user_268.last_name, matrix_no=student_user_268.identification_num, email=student_user_268.email, phone_number=student_user_268.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_269 = TrainingStudent(
    student=student_user_269, faculty=faculty_4, department=dept_27, student_training_coordinator=coord_user_27, first_name=student_user_269.first_name, last_name=student_user_269.last_name, matrix_no=student_user_269.identification_num, email=student_user_269.email, phone_number=student_user_269.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_270 = TrainingStudent(
    student=student_user_270, faculty=faculty_4, department=dept_27, student_training_coordinator=coord_user_27, first_name=student_user_270.first_name, last_name=student_user_270.last_name, matrix_no=student_user_270.identification_num, email=student_user_270.email, phone_number=student_user_270.phone_number, is_in_school=True, session=curr_sess.session, level=200)

# Business Administration students
student_271 = TrainingStudent(
    student=student_user_271, faculty=faculty_4, department=dept_28, student_training_coordinator=coord_user_28, first_name=student_user_271.first_name, last_name=student_user_271.last_name, matrix_no=student_user_271.identification_num, email=student_user_271.email, phone_number=student_user_271.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_272 = TrainingStudent(
    student=student_user_272, faculty=faculty_4, department=dept_28, student_training_coordinator=coord_user_28, first_name=student_user_272.first_name, last_name=student_user_272.last_name, matrix_no=student_user_272.identification_num, email=student_user_272.email, phone_number=student_user_272.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_273 = TrainingStudent(
    student=student_user_273, faculty=faculty_4, department=dept_28, student_training_coordinator=coord_user_28, first_name=student_user_273.first_name, last_name=student_user_273.last_name, matrix_no=student_user_273.identification_num, email=student_user_273.email, phone_number=student_user_273.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_274 = TrainingStudent(
    student=student_user_274, faculty=faculty_4, department=dept_28, student_training_coordinator=coord_user_28, first_name=student_user_274.first_name, last_name=student_user_274.last_name, matrix_no=student_user_274.identification_num, email=student_user_274.email, phone_number=student_user_274.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_275 = TrainingStudent(
    student=student_user_275, faculty=faculty_4, department=dept_28, student_training_coordinator=coord_user_28, first_name=student_user_275.first_name, last_name=student_user_275.last_name, matrix_no=student_user_275.identification_num, email=student_user_275.email, phone_number=student_user_275.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_276 = TrainingStudent(
    student=student_user_276, faculty=faculty_4, department=dept_28, student_training_coordinator=coord_user_28, first_name=student_user_276.first_name, last_name=student_user_276.last_name, matrix_no=student_user_276.identification_num, email=student_user_276.email, phone_number=student_user_276.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_277 = TrainingStudent(
    student=student_user_277, faculty=faculty_4, department=dept_28, student_training_coordinator=coord_user_28, first_name=student_user_277.first_name, last_name=student_user_277.last_name, matrix_no=student_user_277.identification_num, email=student_user_277.email, phone_number=student_user_277.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_278 = TrainingStudent(
    student=student_user_278, faculty=faculty_4, department=dept_28, student_training_coordinator=coord_user_28, first_name=student_user_278.first_name, last_name=student_user_278.last_name, matrix_no=student_user_278.identification_num, email=student_user_278.email, phone_number=student_user_278.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_279 = TrainingStudent(
    student=student_user_279, faculty=faculty_4, department=dept_28, student_training_coordinator=coord_user_28, first_name=student_user_279.first_name, last_name=student_user_279.last_name, matrix_no=student_user_279.identification_num, email=student_user_279.email, phone_number=student_user_279.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_280 = TrainingStudent(
    student=student_user_280, faculty=faculty_4, department=dept_28, student_training_coordinator=coord_user_28, first_name=student_user_280.first_name, last_name=student_user_280.last_name, matrix_no=student_user_280.identification_num, email=student_user_280.email, phone_number=student_user_280.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# Economics students
student_281 = TrainingStudent(
    student=student_user_281, faculty=faculty_4, department=dept_29, student_training_coordinator=coord_user_29, first_name=student_user_281.first_name, last_name=student_user_281.last_name, matrix_no=student_user_281.identification_num, email=student_user_281.email, phone_number=student_user_281.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_282 = TrainingStudent(
    student=student_user_282, faculty=faculty_4, department=dept_29, student_training_coordinator=coord_user_29, first_name=student_user_282.first_name, last_name=student_user_282.last_name, matrix_no=student_user_282.identification_num, email=student_user_282.email, phone_number=student_user_282.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_283 = TrainingStudent(
    student=student_user_283, faculty=faculty_4, department=dept_29, student_training_coordinator=coord_user_29, first_name=student_user_283.first_name, last_name=student_user_283.last_name, matrix_no=student_user_283.identification_num, email=student_user_283.email, phone_number=student_user_283.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_284 = TrainingStudent(
    student=student_user_284, faculty=faculty_4, department=dept_29, student_training_coordinator=coord_user_29, first_name=student_user_284.first_name, last_name=student_user_284.last_name, matrix_no=student_user_284.identification_num, email=student_user_284.email, phone_number=student_user_284.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_285 = TrainingStudent(
    student=student_user_285, faculty=faculty_4, department=dept_29, student_training_coordinator=coord_user_29, first_name=student_user_285.first_name, last_name=student_user_285.last_name, matrix_no=student_user_285.identification_num, email=student_user_285.email, phone_number=student_user_285.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_286 = TrainingStudent(
    student=student_user_286, faculty=faculty_4, department=dept_29, student_training_coordinator=coord_user_29, first_name=student_user_286.first_name, last_name=student_user_286.last_name, matrix_no=student_user_286.identification_num, email=student_user_286.email, phone_number=student_user_286.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_287 = TrainingStudent(
    student=student_user_287, faculty=faculty_4, department=dept_29, student_training_coordinator=coord_user_29, first_name=student_user_287.first_name, last_name=student_user_287.last_name, matrix_no=student_user_287.identification_num, email=student_user_287.email, phone_number=student_user_287.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_288 = TrainingStudent(
    student=student_user_288, faculty=faculty_4, department=dept_29, student_training_coordinator=coord_user_29, first_name=student_user_288.first_name, last_name=student_user_288.last_name, matrix_no=student_user_288.identification_num, email=student_user_288.email, phone_number=student_user_288.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_289 = TrainingStudent(
    student=student_user_289, faculty=faculty_4, department=dept_29, student_training_coordinator=coord_user_29, first_name=student_user_289.first_name, last_name=student_user_289.last_name, matrix_no=student_user_289.identification_num, email=student_user_289.email, phone_number=student_user_289.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_290 = TrainingStudent(
    student=student_user_290, faculty=faculty_4, department=dept_29, student_training_coordinator=coord_user_29, first_name=student_user_290.first_name, last_name=student_user_290.last_name, matrix_no=student_user_290.identification_num, email=student_user_290.email, phone_number=student_user_290.phone_number, is_in_school=True, session=curr_sess.session, level=200)

# Political science students
student_291 = TrainingStudent(
    student=student_user_291, faculty=faculty_4, department=dept_30, student_training_coordinator=coord_user_30, first_name=student_user_291.first_name, last_name=student_user_291.last_name, matrix_no=student_user_291.identification_num, email=student_user_291.email, phone_number=student_user_291.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_292 = TrainingStudent(
    student=student_user_292, faculty=faculty_4, department=dept_30, student_training_coordinator=coord_user_30, first_name=student_user_292.first_name, last_name=student_user_292.last_name, matrix_no=student_user_292.identification_num, email=student_user_292.email, phone_number=student_user_292.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_293 = TrainingStudent(
    student=student_user_293, faculty=faculty_4, department=dept_30, student_training_coordinator=coord_user_30, first_name=student_user_293.first_name, last_name=student_user_293.last_name, matrix_no=student_user_293.identification_num, email=student_user_293.email, phone_number=student_user_293.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_294 = TrainingStudent(
    student=student_user_294, faculty=faculty_4, department=dept_30, student_training_coordinator=coord_user_30, first_name=student_user_294.first_name, last_name=student_user_294.last_name, matrix_no=student_user_294.identification_num, email=student_user_294.email, phone_number=student_user_294.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_295 = TrainingStudent(
    student=student_user_295, faculty=faculty_4, department=dept_30, student_training_coordinator=coord_user_30, first_name=student_user_295.first_name, last_name=student_user_295.last_name, matrix_no=student_user_295.identification_num, email=student_user_295.email, phone_number=student_user_295.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_296 = TrainingStudent(
    student=student_user_296, faculty=faculty_4, department=dept_30, student_training_coordinator=coord_user_30, first_name=student_user_296.first_name, last_name=student_user_296.last_name, matrix_no=student_user_296.identification_num, email=student_user_296.email, phone_number=student_user_296.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_297 = TrainingStudent(
    student=student_user_297, faculty=faculty_4, department=dept_30, student_training_coordinator=coord_user_30, first_name=student_user_297.first_name, last_name=student_user_297.last_name, matrix_no=student_user_297.identification_num, email=student_user_297.email, phone_number=student_user_297.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_298 = TrainingStudent(
    student=student_user_298, faculty=faculty_4, department=dept_30, student_training_coordinator=coord_user_30, first_name=student_user_298.first_name, last_name=student_user_298.last_name, matrix_no=student_user_298.identification_num, email=student_user_298.email, phone_number=student_user_298.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_299 = TrainingStudent(
    student=student_user_299, faculty=faculty_4, department=dept_30, student_training_coordinator=coord_user_30, first_name=student_user_299.first_name, last_name=student_user_299.last_name, matrix_no=student_user_299.identification_num, email=student_user_299.email, phone_number=student_user_299.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_300 = TrainingStudent(
    student=student_user_300, faculty=faculty_4, department=dept_30, student_training_coordinator=coord_user_30, first_name=student_user_300.first_name, last_name=student_user_300.last_name, matrix_no=student_user_300.identification_num, email=student_user_300.email, phone_number=student_user_300.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# Public Administration students
student_301 = TrainingStudent(
    student=student_user_301, faculty=faculty_4, department=dept_31, student_training_coordinator=coord_user_31, first_name=student_user_301.first_name, last_name=student_user_301.last_name, matrix_no=student_user_301.identification_num, email=student_user_301.email, phone_number=student_user_301.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_302 = TrainingStudent(
    student=student_user_302, faculty=faculty_4, department=dept_31, student_training_coordinator=coord_user_31, first_name=student_user_302.first_name, last_name=student_user_302.last_name, matrix_no=student_user_302.identification_num, email=student_user_302.email, phone_number=student_user_302.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_303 = TrainingStudent(
    student=student_user_303, faculty=faculty_4, department=dept_31, student_training_coordinator=coord_user_31, first_name=student_user_303.first_name, last_name=student_user_303.last_name, matrix_no=student_user_303.identification_num, email=student_user_303.email, phone_number=student_user_303.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_304 = TrainingStudent(
    student=student_user_304, faculty=faculty_4, department=dept_31, student_training_coordinator=coord_user_31, first_name=student_user_304.first_name, last_name=student_user_304.last_name, matrix_no=student_user_304.identification_num, email=student_user_304.email, phone_number=student_user_304.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_305 = TrainingStudent(
    student=student_user_305, faculty=faculty_4, department=dept_31, student_training_coordinator=coord_user_31, first_name=student_user_305.first_name, last_name=student_user_305.last_name, matrix_no=student_user_305.identification_num, email=student_user_305.email, phone_number=student_user_305.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_306 = TrainingStudent(
    student=student_user_306, faculty=faculty_4, department=dept_31, student_training_coordinator=coord_user_31, first_name=student_user_306.first_name, last_name=student_user_306.last_name, matrix_no=student_user_306.identification_num, email=student_user_306.email, phone_number=student_user_306.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_307 = TrainingStudent(
    student=student_user_307, faculty=faculty_4, department=dept_31, student_training_coordinator=coord_user_31, first_name=student_user_307.first_name, last_name=student_user_307.last_name, matrix_no=student_user_307.identification_num, email=student_user_307.email, phone_number=student_user_307.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_308 = TrainingStudent(
    student=student_user_308, faculty=faculty_4, department=dept_31, student_training_coordinator=coord_user_31, first_name=student_user_308.first_name, last_name=student_user_308.last_name, matrix_no=student_user_308.identification_num, email=student_user_308.email, phone_number=student_user_308.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_309 = TrainingStudent(
    student=student_user_309, faculty=faculty_4, department=dept_31, student_training_coordinator=coord_user_31, first_name=student_user_309.first_name, last_name=student_user_309.last_name, matrix_no=student_user_309.identification_num, email=student_user_309.email, phone_number=student_user_309.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_310 = TrainingStudent(
    student=student_user_310, faculty=faculty_4, department=dept_31, student_training_coordinator=coord_user_31, first_name=student_user_310.first_name, last_name=student_user_310.last_name, matrix_no=student_user_310.identification_num, email=student_user_310.email, phone_number=student_user_310.phone_number, is_in_school=True, session=curr_sess.session, level=300)

# Sociology students
student_311 = TrainingStudent(
    student=student_user_311, faculty=faculty_4, department=dept_32, student_training_coordinator=coord_user_32, first_name=student_user_311.first_name, last_name=student_user_311.last_name, matrix_no=student_user_311.identification_num, email=student_user_311.email, phone_number=student_user_311.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_312 = TrainingStudent(
    student=student_user_312, faculty=faculty_4, department=dept_32, student_training_coordinator=coord_user_32, first_name=student_user_312.first_name, last_name=student_user_312.last_name, matrix_no=student_user_312.identification_num, email=student_user_312.email, phone_number=student_user_312.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_313 = TrainingStudent(
    student=student_user_313, faculty=faculty_4, department=dept_32, student_training_coordinator=coord_user_32, first_name=student_user_313.first_name, last_name=student_user_313.last_name, matrix_no=student_user_313.identification_num, email=student_user_313.email, phone_number=student_user_313.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_314 = TrainingStudent(
    student=student_user_314, faculty=faculty_4, department=dept_32, student_training_coordinator=coord_user_32, first_name=student_user_314.first_name, last_name=student_user_314.last_name, matrix_no=student_user_314.identification_num, email=student_user_314.email, phone_number=student_user_314.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_315 = TrainingStudent(
    student=student_user_315, faculty=faculty_4, department=dept_32, student_training_coordinator=coord_user_32, first_name=student_user_315.first_name, last_name=student_user_315.last_name, matrix_no=student_user_315.identification_num, email=student_user_315.email, phone_number=student_user_315.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_316 = TrainingStudent(
    student=student_user_316, faculty=faculty_4, department=dept_32, student_training_coordinator=coord_user_32, first_name=student_user_316.first_name, last_name=student_user_316.last_name, matrix_no=student_user_316.identification_num, email=student_user_316.email, phone_number=student_user_316.phone_number, is_in_school=True, session=curr_sess.session, level=300)
student_317 = TrainingStudent(
    student=student_user_317, faculty=faculty_4, department=dept_32, student_training_coordinator=coord_user_32, first_name=student_user_317.first_name, last_name=student_user_317.last_name, matrix_no=student_user_317.identification_num, email=student_user_317.email, phone_number=student_user_317.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_318 = TrainingStudent(
    student=student_user_318, faculty=faculty_4, department=dept_32, student_training_coordinator=coord_user_32, first_name=student_user_318.first_name, last_name=student_user_318.last_name, matrix_no=student_user_318.identification_num, email=student_user_318.email, phone_number=student_user_318.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_319 = TrainingStudent(
    student=student_user_319, faculty=faculty_4, department=dept_32, student_training_coordinator=coord_user_32, first_name=student_user_319.first_name, last_name=student_user_319.last_name, matrix_no=student_user_319.identification_num, email=student_user_319.email, phone_number=student_user_319.phone_number, is_in_school=True, session=curr_sess.session, level=200)
student_320 = TrainingStudent(
    student=student_user_320, faculty=faculty_4, department=dept_32, student_training_coordinator=coord_user_32, first_name=student_user_320.first_name, last_name=student_user_320.last_name, matrix_no=student_user_320.identification_num, email=student_user_320.email, phone_number=student_user_320.phone_number, is_in_school=True, session=curr_sess.session, level=200)

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

### adding student to his/her active training coordinator
# def me():
#     # this code produce the following (adding student to his/her coordinato)
#     num = 0
#     for i in range(1, 33):
#         for j in range(1, 11):
#             print(f'coord_{i}.training_students.add(student_{num+1})')
#             print(f'coord_{i}.training_students.add(student_{num+2})')
#             print(f'coord_{i}.training_students.add(student_{num+3})')
#             print(f'coord_{i}.training_students.add(student_{num+4})')
#             print(f'coord_{i}.training_students.add(student_{num+5})')
#             print(f'coord_{i}.training_students.add(student_{num+6})')
#             print(f'coord_{i}.training_students.add(student_{num+7})')
#             print(f'coord_{i}.training_students.add(student_{num+8})')
#             print(f'coord_{i}.training_students.add(student_{num+9})')
#             print(f'coord_{i}.training_students.add(student_{num+10})')
#             print()
#             num+=10
#             break
# me()
coord_1.training_students.add(student_1)
coord_1.training_students.add(student_2)
coord_1.training_students.add(student_3)
coord_1.training_students.add(student_4)
coord_1.training_students.add(student_5)
coord_1.training_students.add(student_6)
coord_1.training_students.add(student_7)
coord_1.training_students.add(student_8)
coord_1.training_students.add(student_9)
coord_1.training_students.add(student_10)

coord_2.training_students.add(student_11)
coord_2.training_students.add(student_12)
coord_2.training_students.add(student_13)
coord_2.training_students.add(student_14)
coord_2.training_students.add(student_15)
coord_2.training_students.add(student_16)
coord_2.training_students.add(student_17)
coord_2.training_students.add(student_18)
coord_2.training_students.add(student_19)
coord_2.training_students.add(student_20)

coord_3.training_students.add(student_21)
coord_3.training_students.add(student_22)
coord_3.training_students.add(student_23)
coord_3.training_students.add(student_24)
coord_3.training_students.add(student_25)
coord_3.training_students.add(student_26)
coord_3.training_students.add(student_27)
coord_3.training_students.add(student_28)
coord_3.training_students.add(student_29)
coord_3.training_students.add(student_30)

coord_4.training_students.add(student_31)
coord_4.training_students.add(student_32)
coord_4.training_students.add(student_33)
coord_4.training_students.add(student_34)
coord_4.training_students.add(student_35)
coord_4.training_students.add(student_36)
coord_4.training_students.add(student_37)
coord_4.training_students.add(student_38)
coord_4.training_students.add(student_39)
coord_4.training_students.add(student_40)

coord_5.training_students.add(student_41)
coord_5.training_students.add(student_42)
coord_5.training_students.add(student_43)
coord_5.training_students.add(student_44)
coord_5.training_students.add(student_45)
coord_5.training_students.add(student_46)
coord_5.training_students.add(student_47)
coord_5.training_students.add(student_48)
coord_5.training_students.add(student_49)
coord_5.training_students.add(student_50)

coord_6.training_students.add(student_51)
coord_6.training_students.add(student_52)
coord_6.training_students.add(student_53)
coord_6.training_students.add(student_54)
coord_6.training_students.add(student_55)
coord_6.training_students.add(student_56)
coord_6.training_students.add(student_57)
coord_6.training_students.add(student_58)
coord_6.training_students.add(student_59)
coord_6.training_students.add(student_60)

coord_7.training_students.add(student_61)
coord_7.training_students.add(student_62)
coord_7.training_students.add(student_63)
coord_7.training_students.add(student_64)
coord_7.training_students.add(student_65)
coord_7.training_students.add(student_66)
coord_7.training_students.add(student_67)
coord_7.training_students.add(student_68)
coord_7.training_students.add(student_69)
coord_7.training_students.add(student_70)

coord_8.training_students.add(student_71)
coord_8.training_students.add(student_72)
coord_8.training_students.add(student_73)
coord_8.training_students.add(student_74)
coord_8.training_students.add(student_75)
coord_8.training_students.add(student_76)
coord_8.training_students.add(student_77)
coord_8.training_students.add(student_78)
coord_8.training_students.add(student_79)
coord_8.training_students.add(student_80)

coord_9.training_students.add(student_81)
coord_9.training_students.add(student_82)
coord_9.training_students.add(student_83)
coord_9.training_students.add(student_84)
coord_9.training_students.add(student_85)
coord_9.training_students.add(student_86)
coord_9.training_students.add(student_87)
coord_9.training_students.add(student_88)
coord_9.training_students.add(student_89)
coord_9.training_students.add(student_90)

coord_10.training_students.add(student_91)
coord_10.training_students.add(student_92)
coord_10.training_students.add(student_93)
coord_10.training_students.add(student_94)
coord_10.training_students.add(student_95)
coord_10.training_students.add(student_96)
coord_10.training_students.add(student_97)
coord_10.training_students.add(student_98)
coord_10.training_students.add(student_99)
coord_10.training_students.add(student_100)

coord_11.training_students.add(student_101)
coord_11.training_students.add(student_102)
coord_11.training_students.add(student_103)
coord_11.training_students.add(student_104)
coord_11.training_students.add(student_105)
coord_11.training_students.add(student_106)
coord_11.training_students.add(student_107)
coord_11.training_students.add(student_108)
coord_11.training_students.add(student_109)
coord_11.training_students.add(student_110)

coord_12.training_students.add(student_111)
coord_12.training_students.add(student_112)
coord_12.training_students.add(student_113)
coord_12.training_students.add(student_114)
coord_12.training_students.add(student_115)
coord_12.training_students.add(student_116)
coord_12.training_students.add(student_117)
coord_12.training_students.add(student_118)
coord_12.training_students.add(student_119)
coord_12.training_students.add(student_120)

coord_13.training_students.add(student_121)
coord_13.training_students.add(student_122)
coord_13.training_students.add(student_123)
coord_13.training_students.add(student_124)
coord_13.training_students.add(student_125)
coord_13.training_students.add(student_126)
coord_13.training_students.add(student_127)
coord_13.training_students.add(student_128)
coord_13.training_students.add(student_129)
coord_13.training_students.add(student_130)

coord_14.training_students.add(student_131)
coord_14.training_students.add(student_132)
coord_14.training_students.add(student_133)
coord_14.training_students.add(student_134)
coord_14.training_students.add(student_135)
coord_14.training_students.add(student_136)
coord_14.training_students.add(student_137)
coord_14.training_students.add(student_138)
coord_14.training_students.add(student_139)
coord_14.training_students.add(student_140)

coord_15.training_students.add(student_141)
coord_15.training_students.add(student_142)
coord_15.training_students.add(student_143)
coord_15.training_students.add(student_144)
coord_15.training_students.add(student_145)
coord_15.training_students.add(student_146)
coord_15.training_students.add(student_147)
coord_15.training_students.add(student_148)
coord_15.training_students.add(student_149)
coord_15.training_students.add(student_150)

coord_16.training_students.add(student_151)
coord_16.training_students.add(student_152)
coord_16.training_students.add(student_153)
coord_16.training_students.add(student_154)
coord_16.training_students.add(student_155)
coord_16.training_students.add(student_156)
coord_16.training_students.add(student_157)
coord_16.training_students.add(student_158)
coord_16.training_students.add(student_159)
coord_16.training_students.add(student_160)

coord_17.training_students.add(student_161)
coord_17.training_students.add(student_162)
coord_17.training_students.add(student_163)
coord_17.training_students.add(student_164)
coord_17.training_students.add(student_165)
coord_17.training_students.add(student_166)
coord_17.training_students.add(student_167)
coord_17.training_students.add(student_168)
coord_17.training_students.add(student_169)
coord_17.training_students.add(student_170)

coord_18.training_students.add(student_171)
coord_18.training_students.add(student_172)
coord_18.training_students.add(student_173)
coord_18.training_students.add(student_174)
coord_18.training_students.add(student_175)
coord_18.training_students.add(student_176)
coord_18.training_students.add(student_177)
coord_18.training_students.add(student_178)
coord_18.training_students.add(student_179)
coord_18.training_students.add(student_180)

coord_19.training_students.add(student_181)
coord_19.training_students.add(student_182)
coord_19.training_students.add(student_183)
coord_19.training_students.add(student_184)
coord_19.training_students.add(student_185)
coord_19.training_students.add(student_186)
coord_19.training_students.add(student_187)
coord_19.training_students.add(student_188)
coord_19.training_students.add(student_189)
coord_19.training_students.add(student_190)

coord_20.training_students.add(student_191)
coord_20.training_students.add(student_192)
coord_20.training_students.add(student_193)
coord_20.training_students.add(student_194)
coord_20.training_students.add(student_195)
coord_20.training_students.add(student_196)
coord_20.training_students.add(student_197)
coord_20.training_students.add(student_198)
coord_20.training_students.add(student_199)
coord_20.training_students.add(student_200)

coord_21.training_students.add(student_201)
coord_21.training_students.add(student_202)
coord_21.training_students.add(student_203)
coord_21.training_students.add(student_204)
coord_21.training_students.add(student_205)
coord_21.training_students.add(student_206)
coord_21.training_students.add(student_207)
coord_21.training_students.add(student_208)
coord_21.training_students.add(student_209)
coord_21.training_students.add(student_210)

coord_22.training_students.add(student_211)
coord_22.training_students.add(student_212)
coord_22.training_students.add(student_213)
coord_22.training_students.add(student_214)
coord_22.training_students.add(student_215)
coord_22.training_students.add(student_216)
coord_22.training_students.add(student_217)
coord_22.training_students.add(student_218)
coord_22.training_students.add(student_219)
coord_22.training_students.add(student_220)

coord_23.training_students.add(student_221)
coord_23.training_students.add(student_222)
coord_23.training_students.add(student_223)
coord_23.training_students.add(student_224)
coord_23.training_students.add(student_225)
coord_23.training_students.add(student_226)
coord_23.training_students.add(student_227)
coord_23.training_students.add(student_228)
coord_23.training_students.add(student_229)
coord_23.training_students.add(student_230)

coord_24.training_students.add(student_231)
coord_24.training_students.add(student_232)
coord_24.training_students.add(student_233)
coord_24.training_students.add(student_234)
coord_24.training_students.add(student_235)
coord_24.training_students.add(student_236)
coord_24.training_students.add(student_237)
coord_24.training_students.add(student_238)
coord_24.training_students.add(student_239)
coord_24.training_students.add(student_240)

coord_25.training_students.add(student_241)
coord_25.training_students.add(student_242)
coord_25.training_students.add(student_243)
coord_25.training_students.add(student_244)
coord_25.training_students.add(student_245)
coord_25.training_students.add(student_246)
coord_25.training_students.add(student_247)
coord_25.training_students.add(student_248)
coord_25.training_students.add(student_249)
coord_25.training_students.add(student_250)

coord_26.training_students.add(student_251)
coord_26.training_students.add(student_252)
coord_26.training_students.add(student_253)
coord_26.training_students.add(student_254)
coord_26.training_students.add(student_255)
coord_26.training_students.add(student_256)
coord_26.training_students.add(student_257)
coord_26.training_students.add(student_258)
coord_26.training_students.add(student_259)
coord_26.training_students.add(student_260)

coord_27.training_students.add(student_261)
coord_27.training_students.add(student_262)
coord_27.training_students.add(student_263)
coord_27.training_students.add(student_264)
coord_27.training_students.add(student_265)
coord_27.training_students.add(student_266)
coord_27.training_students.add(student_267)
coord_27.training_students.add(student_268)
coord_27.training_students.add(student_269)
coord_27.training_students.add(student_270)

coord_28.training_students.add(student_271)
coord_28.training_students.add(student_272)
coord_28.training_students.add(student_273)
coord_28.training_students.add(student_274)
coord_28.training_students.add(student_275)
coord_28.training_students.add(student_276)
coord_28.training_students.add(student_277)
coord_28.training_students.add(student_278)
coord_28.training_students.add(student_279)
coord_28.training_students.add(student_280)

coord_29.training_students.add(student_281)
coord_29.training_students.add(student_282)
coord_29.training_students.add(student_283)
coord_29.training_students.add(student_284)
coord_29.training_students.add(student_285)
coord_29.training_students.add(student_286)
coord_29.training_students.add(student_287)
coord_29.training_students.add(student_288)
coord_29.training_students.add(student_289)
coord_29.training_students.add(student_290)

coord_30.training_students.add(student_291)
coord_30.training_students.add(student_292)
coord_30.training_students.add(student_293)
coord_30.training_students.add(student_294)
coord_30.training_students.add(student_295)
coord_30.training_students.add(student_296)
coord_30.training_students.add(student_297)
coord_30.training_students.add(student_298)
coord_30.training_students.add(student_299)
coord_30.training_students.add(student_300)

coord_31.training_students.add(student_301)
coord_31.training_students.add(student_302)
coord_31.training_students.add(student_303)
coord_31.training_students.add(student_304)
coord_31.training_students.add(student_305)
coord_31.training_students.add(student_306)
coord_31.training_students.add(student_307)
coord_31.training_students.add(student_308)
coord_31.training_students.add(student_309)
coord_31.training_students.add(student_310)

coord_32.training_students.add(student_311)
coord_32.training_students.add(student_312)
coord_32.training_students.add(student_313)
coord_32.training_students.add(student_314)
coord_32.training_students.add(student_315)
coord_32.training_students.add(student_316)
coord_32.training_students.add(student_317)
coord_32.training_students.add(student_318)
coord_32.training_students.add(student_319)
coord_32.training_students.add(student_320)

exit()
pm
