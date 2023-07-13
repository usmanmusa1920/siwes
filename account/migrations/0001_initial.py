# Generated by Django 4.1.7 on 2023-07-13 21:40

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import django_countries.fields


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='UserAccount',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(blank=True, null=True, verbose_name='last login')),
                ('first_name', models.CharField(max_length=100)),
                ('middle_name', models.CharField(blank=True, max_length=100, null=True)),
                ('last_name', models.CharField(max_length=100)),
                ('gender', models.CharField(choices=[('female', 'Female'), ('male', 'Male')], default='male', max_length=100)),
                ('date_of_birth', models.DateField(blank=True, max_length=100, null=True)),
                ('identification_num', models.CharField(max_length=255, unique=True)),
                ('email', models.EmailField(max_length=255)),
                ('phone_number', models.CharField(max_length=100)),
                ('country', django_countries.fields.CountryField(max_length=100)),
                ('date_joined', models.DateTimeField(auto_now_add=True)),
                ('last_modified', models.DateTimeField(auto_now=True)),
                ('is_active', models.BooleanField(default=True)),
                ('is_staff', models.BooleanField(default=False)),
                ('is_superuser', models.BooleanField(default=False)),
                ('is_admin', models.BooleanField(default=False)),
                ('is_dean', models.BooleanField(default=False)),
                ('is_hod', models.BooleanField(default=False)),
                ('is_coordinator', models.BooleanField(default=False)),
                ('is_supervisor', models.BooleanField(default=False)),
                ('is_schoolstaff', models.BooleanField(default=False)),
                ('is_student', models.BooleanField(default=False)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.CreateModel(
            name='Profile',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('session', models.CharField(default=2023, max_length=255)),
                ('image', models.ImageField(default='default_pic.png', upload_to='users_profile_pics')),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
