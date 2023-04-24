# Generated by Django 4.1.7 on 2023-04-24 12:49

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone
import phonenumber_field.modelfields


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Faculty',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date_joined', models.DateTimeField(default=django.utils.timezone.now)),
                ('last_modified', models.DateTimeField(auto_now=True)),
                ('training', models.CharField(choices=[('siwes', 'Student industrial work experience (SIWES)'), ('tp', 'Teaching practice (TP)')], default='siwes', max_length=100)),
                ('name', models.CharField(blank=True, max_length=300, null=True)),
                ('email', models.EmailField(max_length=255, unique=True)),
                ('website', models.CharField(blank=True, max_length=300, null=True)),
                ('phone_number', phonenumber_field.modelfields.PhoneNumberField(max_length=100, region=None, unique=True)),
                ('description', models.TextField(blank=True, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='FacultyDean',
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
                ('dean', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
                ('faculty', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='faculty.faculty')),
            ],
        ),
    ]
