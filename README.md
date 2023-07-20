# fugus

The `automate_users_data.sh` script, it ease writing code in python interpreter for testing some users instanciation.

The `faculty_and_dept.json` file, contains faculties and departments name and some info of them, for testing also.

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
    (from django.contrib.auth.models import User) or
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

`Faculty` info coming soon!

`Department` info coming soon!

`Faculty dean` info coming soon!

`Department HOD` info coming soon!

`Department training coordinator` info coming soon!

`Student training supervisor` info coming soon!

`Student` info coming soon!

Landing page

![snippet_theme](screen/landing.png)

Login page

![snippet_theme](screen/login.png)
