
function automate_passwd(is_student=false){
  /** 
   * this is a function that will automatically field in the value
   * of new (staff, or student) password
  */

  field = document.querySelector('#id_no').value // identification number (staff) or matrix number (student)

  if (is_student==true){
    // here, we concatenate `FUG` and student admission number as the password of new register user (student)
    /**
     * e.g
     * admission_number = 234578
     * pwd = fug234578
    */
    pwd = 'FUG' + field // user (student) password
  }else{
    f_name = document.querySelector('#first_name').value // staff first name
    l_name = document.querySelector('#last_name').value // staff last name
    // here, we lower case the first name (f_name) and last name (l_name) of new register user (staff)
    // then, captured (slice) first letter of his/her first name (f_name) and last name (l_name)
    /**
     * e.g
     * f_name = Lawal
     * l_name = Saad
     * identification_number = 234578
     * pwd = l234578s
    */
    pwd = f_name.toLowerCase().slice(0,1) + field + l_name.toLowerCase().slice(0,1) // user (staff) password
  }
  document.querySelector('#pwd1').value = pwd
  document.querySelector('#pwd2').value = pwd
}
