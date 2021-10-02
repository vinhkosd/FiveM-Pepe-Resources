var PreviusActive = false;

document.onkeyup = function (data) {
    if (data.which == 27) { // Escape
        $.post('http://fw-alerts/CloseNui', JSON.stringify({}))
        RemovePreviousAlerts()
        PreviusActive = false
    }
};

$(document).ready(function(){
    window.addEventListener('message', function(event){
        var action = event.data.action;
        switch(action) {
         case "add":
            AddPreviousAlerts(event.data.data)
            AddPoliceAlert(event.data.data);
            break;
         case "History":
            ShowPreviousAlerts();
            break;
         case "Close":
            RemovePreviousAlerts();
            break;
        }
    });
});

function AddPoliceAlert(data) {
        data.alertTitle != null ? data.alertTitle : "Geen title";
        if (data.callSign === "NO CALLSIGN") {
            data.callSign = "xx-xx";
        } else if (data.callSign === "UITDIENST") {
            data.callSign = "xx-xx";
        } else {
            var temp = data.callSign.split("|");
            data.callSign = temp[0];
        } 
        var $alert = $(".template-container").clone();
        $alert.hide().addClass('transReset');

        if (data.priority == 3) {
            $alert.css({
                "border-color": "#cc2c2c",
                "border-right-color": "#cc2c2c" 
            });
        } else if (data.priority == 2) {
            $alert.css({
                "border-color": "#cc2c2c",
                "border-right-color": "#cc2c2c",
                "background-color": "#be1818a6"
            }); 
        }

        $alert.removeClass('template-container');
        $alert.addClass('alert-' + data.alertId);
        $alert.find('.alert-prefix').html(data.callSign);
        $alert.find('.alert-title').html(data.alertTitle);

        if (data.coords !== undefined && data.coords !== null) {
            $alert.append('<div class="alert-location"><i class="fas fa-map-marker-alt"></i></div>')
            $alert.data('coords', data.coords);
        }

        $.each(data.details, function(i, detail){
            $alert.find('.alert-details').append('<div class="alert-detail">' + detail.icon + ' <span> ' + detail.detail + ' </span></div>');
        });
        $(".alerts-container").prepend($alert);
        $alert.show(300, function() { 
            $(this).removeClass('transReset')
        });
        
        animateCSS('.alert-' + data.alertId, 'bounceInRight', function(){
            $alert.removeClass('animated bounceInRight');
            if (data.priority == 3) {
                $alert.addClass('emergency');
            } else if (data.priority == 1) {
                $alert.addClass('almost');
            }
        });

        setTimeout(function(){
            if (data.priority == 3) {
                $('.alert-' + data.alertId).removeClass('emergency');
             } else if (data.priority == 1) {
                $('.alert-' + data.alertId).removeClass('almost');
            }
              // $('.alert-' + data.alertId).fadeOut(650, function() {
              //     $('.alert-' + data.alertId).remove();
              // }); 
              animateCSS('.alert-' + data.alertId, 'bounceOutRight', function(){
                  $('.alert-' + data.alertId).remove();
              });
        }, data.timeOut != null ? data.timeOut : 3500);
}

AddPreviousAlerts = function(data) {
    var RandomId = Math.floor(Math.random() * 100000)
    data.alertTitle != null ? data.alertTitle : "Geen title";
    if (data.callSign === "NO CALLSIGN") {
        data.callSign = "xx-xx";
    } else if (data.callSign === "UITDIENST") {
        data.callSign = "xx-xx";
    } else {
        var temp = data.callSign.split("|");
        data.callSign = temp[0];
    } 
    var $alert = $(".template-container").clone();
    $alert.hide().addClass('transReset');

    if (data.priority == 3) {
        $alert.css({
            "border-color": "#cc2c2c",
            "border-right-color": "#cc2c2c" 
        });
    } else if (data.priority == 2) {
        $alert.css({
            "border-color": "#cc2c2c",
            "border-right-color": "#cc2c2c",
            "background-color": "#be1818a6"
        }); 
    }

    $alert.removeClass('template-container');
    $alert.addClass('alert-' + RandomId);
    $alert.find('.alert-prefix').html(data.callSign);
    $alert.find('.alert-title').html(data.alertTitle);

    if (data.coords !== undefined && data.coords !== null) {
        $alert.append('<div class="alert-location"><i class="fas fa-map-marker-alt"></i></div>')
        $alert.data('coords', data.coords);
    }

    $.each(data.details, function(i, detail){
        $alert.find('.alert-details').append('<div class="alert-detail">' + detail.icon + ' <span> ' + detail.detail + ' </span></div>');
    });
    $(".log-alerts-container").prepend($alert);
    $alert.show(300, function() {
        $(this).removeClass('transReset')
    });
    
    if (data.priority == 3) {
        $alert.addClass('emergency');
    } else if (data.priority == 1) {
        $alert.addClass('almost');
    }
}

ShowPreviousAlerts = function() {
    $('.log-alerts-container').show();
    $('.alerts-container').hide();
    $(".log-alerts-container").animate({"right": "0"}, 450)
}

RemovePreviousAlerts = function() {
    $(".log-alerts-container").animate({"right": "-40vh"}, 450, function() {
        $('.log-alerts-container').hide();
        $('.alerts-container').show();
    })  
}

function animateCSS(element, animationName, callback) {
    const node = document.querySelector(element)
    node.classList.add('animated', animationName)
    function handleAnimationEnd() {
        node.classList.remove('animated', animationName)
        node.removeEventListener('animationend', handleAnimationEnd)
        if (typeof callback === 'function') callback()
    }
    node.addEventListener('animationend', handleAnimationEnd)
}

$(document).on('click', '.alert-location', function(e){
    e.preventDefault();
    var LocationData = $(this).parent().data('coords');
    $.post('http://fw-alerts/SetWaypoint', JSON.stringify({
        coords: LocationData,
    }))
});