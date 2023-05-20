# Generated by Django 4.1.7 on 2023-05-20 03:22

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone
import phonenumber_field.modelfields


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('faculty', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Department',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date_joined', models.DateTimeField(default=django.utils.timezone.now)),
                ('last_modified', models.DateTimeField(auto_now=True)),
                ('name', models.CharField(blank=True, max_length=300, null=True)),
                ('email', models.EmailField(max_length=255, unique=True)),
                ('website', models.CharField(blank=True, max_length=300, null=True)),
                ('phone_number', phonenumber_field.modelfields.PhoneNumberField(max_length=100, region=None, unique=True)),
                ('description', models.TextField(blank=True, null=True)),
                ('faculty', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='faculty.faculty')),
            ],
        ),
        migrations.CreateModel(
            name='DepartmentHOD',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ranks', models.CharField(blank=True, max_length=100, null=True)),
                ('universities', models.CharField(blank=True, max_length=100, null=True)),
                ('first_name', models.CharField(max_length=100)),
                ('middle_name', models.CharField(blank=True, max_length=100, null=True)),
                ('last_name', models.CharField(max_length=100)),
                ('gender', models.CharField(choices=[('female', 'Female'), ('male', 'Male')], default='male', max_length=100)),
                ('date_of_birth', models.DateField(blank=True, max_length=100, null=True)),
                ('id_no', models.CharField(max_length=255, unique=True)),
                ('email', models.EmailField(max_length=255)),
                ('phone_number', phonenumber_field.modelfields.PhoneNumberField(max_length=100, region=None)),
                ('date_joined', models.DateTimeField(default=django.utils.timezone.now)),
                ('date_leave', models.DateTimeField(auto_now=True)),
                ('is_active', models.BooleanField(default=False)),
                ('department', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='department.department')),
                ('hod', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='DepartmentTrainingCoordinator',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('first_name', models.CharField(max_length=100)),
                ('middle_name', models.CharField(blank=True, max_length=100, null=True)),
                ('last_name', models.CharField(max_length=100)),
                ('gender', models.CharField(choices=[('female', 'Female'), ('male', 'Male')], default='male', max_length=100)),
                ('date_of_birth', models.DateField(blank=True, max_length=100, null=True)),
                ('id_no', models.CharField(max_length=255, unique=True)),
                ('email', models.EmailField(max_length=255)),
                ('phone_number', phonenumber_field.modelfields.PhoneNumberField(max_length=100, region=None)),
                ('date_joined', models.DateTimeField(default=django.utils.timezone.now)),
                ('date_leave', models.DateTimeField(auto_now=True)),
                ('is_active', models.BooleanField(default=False)),
                ('coordinator', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
                ('dept_hod', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='department.departmenthod')),
                ('training_students', models.ManyToManyField(blank=True, related_name='training_students', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Letter',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('release_date', models.DateTimeField(default=django.utils.timezone.now)),
                ('last_modified', models.DateTimeField(auto_now=True)),
                ('letter', models.CharField(choices=[('placement letter', 'Placement letter'), ('acceptance letter', 'Acceptance letter')], default='placement letter', max_length=100)),
                ('duration', models.CharField(default='3', max_length=100)),
                ('start_of_training', models.DateTimeField(default=django.utils.timezone.now)),
                ('end_of_training', models.DateTimeField(default=django.utils.timezone.now)),
                ('text', models.TextField(blank=True, null=True)),
                ('session', models.CharField(max_length=255)),
                ('coordinator', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='department.departmenttrainingcoordinator')),
                ('viewers', models.ManyToManyField(blank=True, related_name='viewers', to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
