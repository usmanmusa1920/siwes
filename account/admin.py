from django.contrib import admin
from django.contrib.auth.models import Group
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth import get_user_model
from .models import Profile


User = get_user_model()


class ProfileInline(admin.TabularInline):
    model = Profile
    extra = 0


class UserAdminForm(UserAdmin):
    search_fields = ('identification_num', 'email',)
    list_filter = ('first_name', 'last_name', 'identification_num',
                   'email', 'is_active', 'is_superuser', 'is_staff')
    ordering = ('-date_joined',)
    list_display = ('first_name', 'last_name', 'last_login',
                    'identification_num', 'email', 'is_active', 'is_superuser', 'is_staff')
    # These are the field that will display when you want to edit user account via admin
    fieldsets = (
        (None, {"fields": ('password', 'email',)}),
        ('Personal', {"fields": ('first_name', 'middle_name',
         'last_name', 'date_of_birth', 'phone_number')}),
        ('Account activity', {"fields": ('last_login', 'date_joined',)}),
        ('Permissions', {"fields": ('is_active',
         'is_superuser', 'is_staff', 'is_admin')}),
    )
    # These are the field that will display when you want to create new user account via admin
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('first_name', 'last_name', 'identification_num', 'email', 'is_active', 'is_superuser', 'is_staff', 'password1', 'password2')
        }),
    )
    inlines = [ProfileInline]
    filter_horizontal = ()


class ProfileAdmin(admin.ModelAdmin):
    search_fields = ('user', 'session', 'image')
    ordering = ('-user',)
    list_filter = ('user', 'session', 'image')
    list_display = ('user', 'session', 'image')
    fieldsets = (
        (None, {"fields": ('user',), }),
        ('Date Information', {'fields': ('session', 'image')}),
    )


admin.site.site_header = 'FUGUS'
admin.site.site_title = 'FUGUS'
admin.site.index_title = 'FUGUS admin'

admin.site.register(User, UserAdminForm)
admin.site.register(Profile, ProfileAdmin)
admin.site.unregister(Group)
