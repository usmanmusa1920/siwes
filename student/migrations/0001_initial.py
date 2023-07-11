# Generated by Django 4.1.7 on 2023-07-11 02:50

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('department', '0001_initial'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='TrainingStudent',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('first_name', models.CharField(max_length=100)),
                ('middle_name', models.CharField(blank=True, max_length=100, null=True)),
                ('last_name', models.CharField(max_length=100)),
                ('gender', models.CharField(choices=[('female', 'Female'), ('male', 'Male')], default='male', max_length=100)),
                ('date_of_birth', models.DateField(blank=True, max_length=100, null=True)),
                ('matrix_no', models.CharField(max_length=255, unique=True)),
                ('level', models.CharField(choices=[('200', '200 level'), ('300', '300 level')], default='200', max_length=100)),
                ('email', models.EmailField(max_length=255)),
                ('phone_number', models.CharField(max_length=100)),
                ('date_joined', models.DateTimeField(auto_now_add=True)),
                ('last_modified', models.DateTimeField(auto_now=True)),
                ('is_in_school', models.BooleanField(default=False)),
                ('student', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
                ('student_training_coordinator', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='department.departmenttrainingcoordinator')),
            ],
        ),
        migrations.CreateModel(
            name='WeekReader',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('week_no', models.IntegerField(default=0)),
                ('student', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='student_week_reader', to='student.trainingstudent')),
            ],
        ),
        migrations.CreateModel(
            name='WeekScannedLogbook',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('timestamp', models.DateTimeField(default=django.utils.timezone.now)),
                ('title', models.CharField(blank=True, max_length=255, null=True)),
                ('week_no', models.IntegerField(blank=True, null=True)),
                ('image', models.ImageField(blank=True, null=True, upload_to='weekly-scanned-logbook')),
                ('text', models.TextField(blank=True, null=True)),
                ('level', models.CharField(choices=[('200', '200 level'), ('300', '300 level')], default='200', max_length=100)),
                ('is_reviewed', models.BooleanField(default=False)),
                ('student_lg', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='student_lg', to='student.trainingstudent')),
                ('week', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='week_reader', to='student.weekreader')),
            ],
        ),
        migrations.CreateModel(
            name='StudentLetterRequest',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('timestamp', models.DateTimeField(default=django.utils.timezone.now)),
                ('in_seen', models.BooleanField(default=False)),
                ('receiver_req', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='receiver_req', to='department.departmenttrainingcoordinator')),
                ('sender_req', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='sender_req', to='student.trainingstudent')),
            ],
        ),
        migrations.CreateModel(
            name='CommentOnLogbook',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('timestamp', models.DateTimeField(default=django.utils.timezone.now)),
                ('grade', models.IntegerField(blank=True, null=True)),
                ('comment', models.TextField()),
                ('commentator', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
                ('logbook', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='student.weekscannedlogbook')),
            ],
        ),
        migrations.CreateModel(
            name='AcceptanceLetter',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('timestamp', models.DateTimeField(default=django.utils.timezone.now)),
                ('title', models.CharField(blank=True, max_length=255, null=True)),
                ('level', models.CharField(max_length=255)),
                ('image', models.ImageField(blank=True, null=True, upload_to='acceptance-letters')),
                ('text', models.TextField(blank=True, null=True)),
                ('is_reviewed', models.BooleanField(default=False)),
                ('can_change', models.BooleanField(default=False)),
                ('receiver_acept', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='receiver_acept', to='department.departmenttrainingcoordinator')),
                ('sender_acept', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='sender_acept', to='student.trainingstudent')),
            ],
        ),
    ]
