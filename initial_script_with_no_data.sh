#!/bin/bash
x
sv

rm -rf account/__pycache__
rm -rf account/migrations/*
touch account/migrations/__init__.py

rm -rf administrator/__pycache__
rm -rf administrator/migrations/*
touch administrator/migrations/__init__.py

rm -rf chat/__pycache__
rm -rf chat/migrations/*
touch chat/migrations/__init__.py

rm db.sqlite3

pmake && pmigrate
python manage.py shell

from datetime import datetime
from django.contrib.auth import get_user_model
# from administrator.all_models import Session
from administrator.tables import (
    Session, Faculty, Department, Vc, Hod, Coordinator, Supervisor, Student, Letter, Acceptance, WeekReader, WeekEntry, WeekEntryImage, Result
)

dob = datetime.utcnow()
User = get_user_model()

# Session
curr_sess = Session(is_current_session=True)
curr_sess.save()

# registering only one user
admin_user = User.objects.create_superuser(
    first_name='Olagoke', last_name='Abdul', identification_num='19992000', email='olagokeabdul@yahoo.com', phone_number='+2348144807200', date_of_birth=dob, is_superuser=True, is_staff=True, is_admin=True, is_schoolstaff=True, password='19991125u')
admin_user.save()
exit()
pm
