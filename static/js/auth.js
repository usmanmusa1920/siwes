
function automate_passwd(){
  /** this is a function that will automatically field in the value of student password */
  field = document.querySelector('#id_no').value
  document.querySelector('#pwd1').value = field
  document.querySelector('#pwd2').value = field
}
