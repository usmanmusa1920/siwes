from django.urls import path, include
from .views import facultyProfile


app_name = "faculty"

urlpatterns = [
    path("faculty/profile/", facultyProfile, name="profile"),
]
