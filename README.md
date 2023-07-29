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

The first thing in this application is to create an admin user via terminal, where he/she will be in charge of creating other users (vc, hod, coordinator, supervisor, and student) he can also create an admin user just like him. Also he is in charge of creating scool session for each year, new faculty in the site, department. Also he is in charge of deactivating or activating users position.

The VC and HOD they did nothing in the site, they are registered in other to display their name in student placement letter and result, so that to be in history who is the HOD and VC when that student is doing his training program.

The other set of users that do some activities apart from that of admin user are:

- coordinator

- supervisor

- student

The `coordinator` duty is to release student letter for each session, just like the naoraml way they did where they handle placement and acceptance letter to student course rep visually, then he/she will share it to his/her department member, but in this case it is digitally, in which each student of that department ones he login and apply for that session program he will be able to see it. Among coordinator duty is to assign a set of student to a supervisor. Again viewing student uploaded acceptance letter is his duty, which will notify a student if his coordinator view his uploaded acceptance letter or not. The approval of student training programm is his duty after the student supervisor grade, comment and submit the student logbook. Lastly a coordinator can exchange message between him and his student, or him and his student supervisor given to him.

The `supervisor` duty is to review, comment, and grade each student weekly logbook entry base on the student performance. After marking all the 12 weeks of student training program, then he can submit the student logbook to the student coordinator for approval. One more thing is that a supervisor can exchange message with his student and coordinator of his student about some issue.

The `student` in his own side when, is onces login he will be directed to complate (update) his profile information (if not updated), ones that finish then he should apply for for his level training, after that he should print both (placement letter and acceptance letter) of that session, then take it to organisation/company he want to do his tarining, once the organisation/company give him acceptance leter, next thing is to scann it (acceptance) and upload it, once that finish he can be able to upload his weekly logbook entry when he start going for th program (12 weeks). Assuming the student started and finish uploading for the 12 weeks program, his duty finish. The next thing is to wait and see his result. One more thing is that a student can exchange message with his supervisor and his coordinator about some issue.

# Database tables

In this system, we have 20 different database table, which each have it own specific function within the system, below are the list of the tables:

- User

- Profile

- Session

- Administrator

- Faculty

- Department

- VC

- HOD

- Coordinator

- Supervisor

- Student

- Letter

- Acceptance

- WeekReader

- WeeekEntry

- WeekEntryImage

- Result

- Message

First school `Session` must be registered for every year, so that to know in history when a so so year a student did his training.

`Administrator` is the one who is incharge and control of anything within the site, also have grant access to the admin page of the site.

`Faculty` indicate which faculty a `Department`, `Student`, and others `(HOD, Coordinator)` user category belongs to with the exception of `Administrator` and `Supervisor`. These last two (`Administrator` and `Supervisor`) have no any relation to faculty.

`Department` indicate which department a `Student`, and others `(HOD, Coordinator)` user category belongs to with the exception of `Administrator` and `Supervisor`. These last two (`Administrator` and `Supervisor`) have no any relation to department.

`HOD` this register a user as a HOD of a department, it have to be registered first before any department training coordinator, also he/she will be the active HOD ones he is created by administrator.

`Coordinator` this register a user as a training coordinator of a department, it have to be registered first before any student (student of that department) or supervisor that want to supervise student of that department, also he/she will be the active training coordinator ones he is created by administrator. Training coordinator is incharge of assigning a set of students to a supervisor, also he is the one will release student training result.

`Supervisor` is the one who is incharge of supervising student, he can comment on student logbook for each week and also grade him/her.

`Student` the student of the school like me! whether 200 or 300 level student only.

# Logic what`s happening? Oops!

In here I will try to explain what happen when a user do something within the system, by making it in a simple explanatory form. Basically registering a `user` (administrator, vc, dean, hod, coordinator, supervisor, student) or `others` (session, faculty, department, etc) has to be in heirrachy, what I mean is that the registeration order matters, to avoid not null constraint or other kind of error, because some tables have relation to some.

First, lete start with the `Session`. When new session is created it will filter old previous sessions that the `is_current_session = True` even though in most cases it won't find such query, but we include such in other to avoid having any other (previous) sessions with the boolean field of `is_current_session` to true, but only the new we create.

Next, `Administrator` when an adimn user is created he don't affect any other data entry or modify them in the database, if new admin created he will simplify and take a portion of previous admin workers (users).

`Faculty` it also don't affect any other data just like `administrator`.

In the case of `Department` it also don't affect any other data just like faculty above.

For `VC`, in here the system will make sure all other previous VCs are not active (by querying those that are active, and then deactivate them) then later create new active one (VC).

For that of `Dean` is same as `VC`, like wise `HOD` too!

In the case of creating new `Coordinator` in the system is same as of the three above (VC, Dean, HOD) mind you the coordinator have a relation with HOD table (foreignkey relation) and the HOD to be assign must be an active one, within the system it will query the department that the coordinator belongs to and then query the active HOD of that department then assign it to the new coordinator.

This take us to `Supervisor` it is like that of admin, but additionally, the supervisor will be added in the list of the coordinator supervisor field (ManyToMany) that submitted his name for the first time for registering supervisor.

When registering `Student` it follow some like that of coordinator, by the student table have a foreign relation with coordinator table, and the coordinator have to be the active one of the student department.

The above can be called simple logic not complicated, now let explain the other by starting with letter, this letter are in two form (placement and acceptance) letter, all the two are release simultaneously by giving them session value of the current school training session from session table, making it the current active student letter of the department (of the coordinator).

# Life cycle

- Administrator:

  - login

  - release new session

  - register new divisoins:

    - faculty

    - department

  - register new users:

    - administrator

    - VC

    - HOD

    - coordinator

    - supervisor

    - student

  - activate/deactivate:

    - vc

    - hod

    - coordinator

  - logout

- Coordinator:

  - login

  - release student letter

  - assign supervisor to student

  - view student acceptance letter

  - approve student result

  - exchange message with student/student supervisor

  - logout

- supervisor:

  - login

  - comment and grade student weekly loogbook

  - submit student logbook to coordinator for approval

  - exchange message with student/student coordinator

  - logout

- Student:

  - login

  - apply for training

  - print letter (acceptance and placement)

  - upload acceptance letter

  - upload weekly logbook entry

  - exchange message with supervisor/coordinator

  - logout

# Cautions!

Don't try changing any media files such as `profile image` `student acceptance` `student weekly entry` and so on via admin page, because the route won't be thesame.

## Landing page

![snippet_theme](screen/landing.png)

## Login page

![snippet_theme](screen/login.png)
