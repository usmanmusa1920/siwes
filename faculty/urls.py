from django.urls import path, include
from .views import FacultyCls


app_name = 'faculty'

urlpatterns = [
    path('faculty/profile/<str:faculty_name>/', FacultyCls.profile, name='profile'),
]
