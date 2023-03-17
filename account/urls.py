from django.urls import path, include
from .views import LoginCustom, LogoutCustom, changePassword, signup


app_name = "auth"

urlpatterns = [
  path("login/", LoginCustom.as_view(template_name="auth/login.html"), name="login"),
  path("logout/", LogoutCustom.as_view(template_name="auth/logout.html"), name="logout"),
  path("change/password/", changePassword, name="change_password"),
  path("signup/", signup, name="signup"),
]
