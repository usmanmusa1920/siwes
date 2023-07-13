# Generated by Django 4.1.7 on 2023-07-13 21:40

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('department', '0001_initial'),
        ('faculty', '0001_initial'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AddField(
            model_name='departmenttrainingcoordinator',
            name='faculty',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='faculty.faculty'),
        ),
        migrations.AddField(
            model_name='departmenttrainingcoordinator',
            name='training_students',
            field=models.ManyToManyField(blank=True, related_name='training_students', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='departmenthod',
            name='department',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='department.department'),
        ),
        migrations.AddField(
            model_name='departmenthod',
            name='faculty',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='faculty.faculty'),
        ),
        migrations.AddField(
            model_name='departmenthod',
            name='hod',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='department',
            name='faculty',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='faculty.faculty'),
        ),
    ]
