
function showMenu(){
  document.querySelector(".left").style.display = 'flex'
  document.querySelector('.left').style.display = 'flex'
  x = window.matchMedia("(max-width: 700px)")
  if (x.matches){
    document.querySelector('.left').style.width = 'fit-content'
    document.querySelector('.left').style.position = 'fixed'
  }
  document.querySelector('.left').style.zIndex = '30'
  document.querySelector('.container').style.display = 'flex'
  document.querySelector('.showmenu').style.display = 'none'
}

function hideMenu(){
  document.querySelector('.left').style.display = 'none'
  document.querySelector('.right').style.width = '100%'
  document.querySelector('.right').style.display = 'flex'
  document.querySelector('.right').style.justifyContent = 'center'
  document.querySelector('.main').style.justifyContent = 'center'
  document.querySelector('.showmenu').style.display = 'block'
}
