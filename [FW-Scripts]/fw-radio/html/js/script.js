Radio = {}

window.addEventListener('message', function(event) {
    if (event.data.type == "open") {
        Radio.SlideUp()
    }
    if (event.data.type == "close") {
        Radio.SlideDown()
    }
    if (event.data.type == "setchannel") {
        Radio.SetChannelVar(event.data)
    }
});

document.onkeyup = function (data) {
    if (data.which == 27) { // Escape key
        $.post('http://fw-radio/Escape', JSON.stringify({}));
        Radio.SlideDown()
    } else if (data.which == 13) { // Escape key
        $.post('http://fw-radio/JoinRadio', JSON.stringify({
            channel: $("#channel").val()
        }));
    }
};

$(document).on('click', '.button', function(e){
    e.preventDefault();
    var KeyData = $(this).data('button')
    Radio.OnClick()
    if (KeyData === 'submit') {
        $.post('http://fw-radio/JoinRadio', JSON.stringify({
            channel: $("#channel").val()
        }));
    } else if (KeyData === 'disconnect') {
        $.post('http://fw-radio/LeaveRadio');
        $("#channel").val('');
    } else if (KeyData === 'volumeup') {
        $.post('http://fw-radio/SetVolume', JSON.stringify({
            Type: 'Up'
        }));
    } else if (KeyData === 'volumedown') {
        $.post('http://fw-radio/SetVolume', JSON.stringify({
            Type: 'Down'
        }));
    } else if (KeyData === 'onoff') {
        $.post('http://fw-radio/ToggleOnOff', JSON.stringify({}));
    }
});

Radio.SetChannelVar = function(data) {
    $("#channel").val(data.channel);
}

Radio.OnClick = function() {
 $.post('http://fw-radio/OnClick');
}

Radio.SlideUp = function() {
    $(".container").css("display", "block");
    $(".radio-container").animate({bottom: "6vh",}, 250);
}

Radio.SlideDown = function() {
    $(".radio-container").animate({bottom: "-110vh",}, 400, function(){
        $(".container").css("display", "none");
    });
}