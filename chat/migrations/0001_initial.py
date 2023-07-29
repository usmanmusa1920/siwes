# Generated by Django 4.1.7 on 2023-07-29 17:00

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Message',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('message', models.TextField(blank=True, null=True)),
                ('image', models.ImageField(blank=True, null=True, upload_to='message_pics')),
                ('timestamp', models.DateTimeField(default=django.utils.timezone.now)),
                ('is_msg_added', models.BooleanField(default=False)),
                ('is_new_message', models.BooleanField(default=False)),
                ('is_msg_replied', models.BooleanField(default=False)),
                ('is_view', models.BooleanField(default=False)),
                ('is_request_to_change_img', models.BooleanField(default=False)),
                ('is_approved_request', models.BooleanField(default=False)),
                ('req_level', models.CharField(choices=[('200', '200 level'), ('300', '300 level')], default='200', max_length=100)),
                ('from_sender', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='from_sender', to=settings.AUTH_USER_MODEL)),
                ('to_receiver', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='to_receiver', to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
