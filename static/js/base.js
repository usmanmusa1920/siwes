
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

function current_timing(){
    var time_func = new Date();
    current_hour = time_func.getHours();
    c_minute = time_func.getMinutes();

    // checking minutes
    if(c_minute == 1 | c_minute == 2 | c_minute == 3 | c_minute == 4 | c_minute == 5){
        current_minute = '0' + c_minute
    }
    else if(c_minute == 5 | c_minute == 6 | c_minute == 7 | c_minute == 8 | c_minute == 9){
        current_minute = '0' + c_minute
    }
    else{
        current_minute = c_minute
    }

    // current time mode `am`
    current_mode = "am";

    // checking hours
    if (current_hour == 13){
        current_hour = 1;
        current_mode ="pm";
    }else if (current_hour == 14){
        current_hour = 2;
        current_mode ="pm";
    }
    else if (current_hour == 15){
        current_hour = 3;
        current_mode ="pm";
    }
    else if (current_hour == 16){
        current_hour = 4;
        current_mode ="pm";
    }
    else if (current_hour == 17){
        current_hour = 5;
        current_mode ="pm";
    }
    else if (current_hour == 18){
        current_hour = 6;
        current_mode ="pm";
    }
    else if (current_hour == 19){
        current_hour = 7;
        current_mode ="pm";
    }
    else if (current_hour == 20){
        current_hour = 8;
        current_mode ="pm";
    }
    else if (current_hour == 21){
        current_hour = 9;
        current_mode ="pm";
    }
    else if (current_hour == 22){
        current_hour = 10;
        current_mode ="pm";
    }
    else if (current_hour == 23){
        current_hour = 11;
        current_mode ="pm";
    }
    else if (current_hour == 0){
        current_hour = 12;
    }

    current_time = `${current_hour}:${current_minute} ${current_mode}`;
    document.getElementById("current_timing").innerHTML = current_time;
}

function this_year(){
    var this_year = new Date();
    document.getElementById("this_year").innerHTML = this_year.getFullYear();
}
