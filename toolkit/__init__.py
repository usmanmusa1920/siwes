# -*- coding: utf-8 -*-
import os
import secrets
from datetime import datetime


date = datetime.utcnow()

the_year = date.year         # 2023
the_month = date.month       # 4
the_day = date.day           # 24
the_date = date.date()       # 2023-04-24
the_now = date.now()         # 2023-04-24 14:36:22.387168
the_utcnow = date.utcnow()   # 2023-04-24 13:36:22.387203


def picture_name(pic_name):
  """this function generate random name for an image name"""
  random_hex = secrets.token_hex(8)
  _, f_ext = os.path.splitext(pic_name)
  picture_fn = random_hex + f_ext
  new_name = _ + '_' + picture_fn
  return new_name
