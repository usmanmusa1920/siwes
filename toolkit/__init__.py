# -*- coding: utf-8 -*-
import os
import secrets
from datetime import datetime
from student.models import TrainingStudent
from django.contrib.auth import get_user_model

the_year = datetime.utcnow().year
# User = get_user_model()


def picture_name(pic_name):
  random_hex = secrets.token_hex(8)
  _, f_ext = os.path.splitext(pic_name)
  picture_fn = random_hex + f_ext
  new_name = _ + "_" + picture_fn
  return new_name


def whoIsUser(request):
  """
  This return current user (instance), it is mainly for given the current
  level of user, so that iit create their media folder foracceptance letter
  """
  return request.user

  
def whoIsStudent(request):
  """
  This return current student (instance), it is mainly to create a sub-folder for student acceptance letter that they will upload
  """
  student = TrainingStudent.objects.filter(matrix_no=request.user.identification_num).first()
  return student
