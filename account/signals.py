from django.db.models.signals import post_save
from django.dispatch import receiver
from django.conf import settings
from .models import Profile
from administrator.models import Administrator


User = settings.AUTH_USER_MODEL


@receiver(post_save, sender=User)
def create_profile(sender, instance, created, **kwargs):
    if created:
        Profile.objects.create(user=instance)
        """
        `usr_in_sep_table` this mean user in separate table
        """
        if instance.is_admin:
            usr_in_sep_table = Administrator(
                director=instance, first_name=instance.first_name, last_name=instance.last_name, email=instance.email, phone_number=instance.phone_number, id_no=instance.identification_num, is_active=True)
            usr_in_sep_table.save()
            

@receiver(post_save, sender=User)
def save_profile(sender, instance, **kwargs):
    instance.profile.save()
