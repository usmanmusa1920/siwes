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
    list_filter = ('first_name', 'last_name', 'identification_num', 'email', 'is_active', 'is_superuser', 'is_staff')
    ordering = ('-date_joined',)

    # list to display
    list_display = ('first_name', 'last_name', 'last_login', 'date_joined', 'last_modified', 'identification_num', 'email', 'is_active', 'is_superuser', 'is_staff', 'is_schoolstaff')

    # These are the field that will display when you want to edit user account via admin
    '''
    Don`t put `last_modified` and `date_joined` in the below fieldset because they are not editable.

    But `last_login` is editable, but don`t put it also, why? to avoid mistakely editing it for a user that is why we comment it out below
    '''
    fieldsets = (
        (None, {"fields": ('password', 'identification_num')}),
        ('Personal', {"fields": ('first_name', 'middle_name',
         'last_name', 'email', 'date_of_birth', 'gender', 'phone_number', 'country')}),
        # ('Account activity', {"fields": ('last_login',)}),
        ('Permissions', {"fields": ('is_active',
         'is_staff', 'is_superuser')}),
        ('School permissions', {"fields": ('is_admin',
         'is_dean', 'is_hod', 'is_coordinator', 'is_supervisor', 'is_schoolstaff', 'is_student')}),
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
