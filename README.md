# fugus

The `automate_users_data.sh` script, it ease writing code in python interpreter for registering some users, faculties and departments by the use of `faculty_and_dept.json` file, that contains faculties and departments name and some info of them, for registering them.

```
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
```

```
    If any issue when using the default user model or even custom user model
    (
        from django.contrib.auth.models import User
    ) or
    (
        from django.contrib.auth import get_user_model
        User = get_user_model()
    )
    use the below tricks (export DJANGO_SETTINGS_MODULE=fugus.settings)

    The issue might result due to going into python interpretter with `python` instead of the recommended way that django gave us `python manage.py shell`
```

# Register

Basically registering a `user` (Administrator, Faculty dean, Department HOD, Department training coordinator, Student training supervisor, Student) or `others` (New session, Faculty, Department) must be in heirrachy, what I mean is that the registeration must be in the following order:

`New session`

`Administrator`

`Faculty`

`Department`

`Faculty dean`

`Department HOD`

`Department training coordinator`

`Student training supervisor`

`Student`

First school `session` must be registered for every year, so that to know in history when a so so year a student did his training.

`Administrator` is the one who is incharge and control of anything within the site, also have grant access to the admin page of the site.

`Faculty` indicate which faculty a `department`, `student`, and others `(department HOD, faculty dean, department training coordinator)` user category belongs to with the exception of `administrator` and `supervisor`. These last two (`administrator` and `supervisor`) have no any relation to faculty.

`Department` indicate which department a `student`, and others `(department HOD, faculty dean, department training coordinator)` user category belongs to with the exception of `administrator` and `supervisor`. These last two (`administrator` and `supervisor`) have no any relation to department.

`Faculty dean` this register a user as a dean of a faculty, it have to be registered first before any department HOD, also he/she will be the active dean ones he is created by administrator.

`Department HOD` this register a user as a HOD of a department, it have to be registered first before any department training coordinator, also he/she will be the active HOD ones he is created by administrator.

`Department training coordinator` this register a user as a training coordinator of a department, it have to be registered first before any student (student of that department) or supervisor that want to supervise student of that department, also he/she will be the active training coordinator ones he is created by administrator. Training coordinator is incharge of assigning a set of students to a supervisor, also he is the one will release student training result.

`Student training supervisor` is the one who is incharge of supervising student, he can comment on student logbook for each week and also grade him/her.

`Student` the student of the school like me! whether 200 or 300 level student only.

Landing page

![snippet_theme](screen/landing.png)

Login page

![snippet_theme](screen/login.png)
