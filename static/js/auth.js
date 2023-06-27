
function automate_passwd(){
  /** 
   * this is a function that will automatically field in the value
   * of new (administrator, staff, or student) password
  */

  field = document.querySelector('#id_no').value
  f_name = document.querySelector('#first_name').value
  l_name = document.querySelector('#last_name').value

  // here, we lower case the first name (f_name) and last name (l_name) of new register user
  // then, captured (slice) first letter of his/her first name (f_name) and last name (l_name)
  /**
   * e.g
   * f_name = Usman
   * l_name = Musa
   * admission_number = 234578
   * pwd = u234578m
  */
  pwd = f_name.toLowerCase().slice(0,1) + field + l_name.toLowerCase().slice(0,1) // user password
  document.querySelector('#pwd1').value = pwd
  document.querySelector('#pwd2').value = pwd
}
