var CurrentCash = 0;
var AddedBlood = false;
var CurrentTransactionsShowing = 0;

OpenCarHud = function() {
    $('.hud-container').animate({"left": "28.65vh"}, 450)
    $(".voice-container").animate({"left": "28.7vh"}, 450, function() {
        $(".vehicle-hud-container").fadeIn(250);
        $('.map-border').show();
    }) 
}

CloseCarHud = function() {
    $('.map-border').hide();
    $(".vehicle-hud-container").fadeOut(250);
    $('.hud-container').animate({"left": ".65vh"}, 450)
    $('.voice-container').animate({"left": ".7vh"}, 450)
}

ShowHud = function() {
  $('.hud-container').css("display", "block");
  $('.voice-container').css("display", "block");
  $('.hud-container').animate({"left": ".65vh"}, 450)
  $('.voice-container').animate({"left": ".7vh"}, 450)
}

HideHud = function() {
  $('.voice-container').animate({"left": "-4vh"}, 450)
  $('.hud-container').animate({"left": "-4vh"}, 450, function() {
      $('.hud-container').css("display", "none");
      $('.voice-container').css("display", "none");
  })
}

UpdateHud = function(data){
    $(".ui-healthbar").find('.hud-barfill').css("height", data.health - 100 + "%");
    $(".ui-armorbar").find('.hud-barfill').css("height", data.armor + "%");
    $(".ui-foodbar").find('.hud-barfill').css("height", data.hunger + "%");
    $(".ui-waterbar").find('.hud-barfill').css("height", data.thirst + "%");
    $(".ui-stressbar").find('.hud-barfill').css("height", data.stress + "%");

    if (data.health - 100 <= 35) {
        $(".ui-healthbar").find('.hud-barfill').addClass("Low");
        if (!AddedBlood) {
            AddedBlood = true
            $.post('http://fw-hud/SetBlood', JSON.stringify({
                Bool: true
            }));
        }
    } else {
        $(".ui-healthbar").find('.hud-barfill').removeClass("Low");
        if (AddedBlood) {
            AddedBlood = false
            $.post('http://fw-hud/SetBlood', JSON.stringify({
                Bool: false
            }));
        }
    }

    if (data.armor <= 35) {
        $(".ui-armorbar").find('.hud-barfill').addClass("Low");
    } else {
        $(".ui-armorbar").find('.hud-barfill').removeClass("Low");
    }

    if (data.hunger <= 35) {
        $(".ui-foodbar").find('.hud-barfill').addClass("Low");
    } else {
        $(".ui-foodbar").find('.hud-barfill').removeClass("Low");

    }

    if (data.thirst <= 35) {
        $(".ui-waterbar").find('.hud-barfill').addClass("Low");
    } else {
        $(".ui-waterbar").find('.hud-barfill').removeClass("Low");

    }

    if (data.talking && data.radio) {
        $(".voice-block").css({"background-color": "#c56127"}); 
    } else if (data.talking) {
        $(".voice-block").css({"background-color": "#bace4e"}); 
    } else {
        $(".voice-block").css({"background-color": "rgb(138, 138, 138)"}); 
    }

    if (data.seatbelt) {
        $(".vehicle-belt img").fadeOut(750);
    } else {
        $(".vehicle-belt img").fadeIn(750);
    }

    $("#Speed-Number").html(data.speed);
    $("#Fuel-Number").html(data.fuel);
    $('.time-text').html(data.hour + ':' + data.minute);
    $('.vehicle-street').html(data.street + ' | ' + data.area);
}

UpdateProximity = function(data) {
    if (data.prox == 1) {
        $("[data-voicetype='1']").fadeIn(150);
        $("[data-voicetype='2']").fadeOut(150);
        $("[data-voicetype='3']").fadeOut(150);
    } else if (data.prox == 2) {
        $("[data-voicetype='1']").fadeIn(150);
        $("[data-voicetype='2']").fadeIn(150);
        $("[data-voicetype='3']").fadeOut(150);
    } else if (data.prox == 3) {
        $("[data-voicetype='1']").fadeIn(150);
        $("[data-voicetype='2']").fadeIn(150);
        $("[data-voicetype='3']").fadeIn(150);
    }
}

ChangeMoney = function(data) {
    var RandomId = Math.floor(Math.random() * 100000)
    $(".current-money").fadeIn(150);
    if (data.type == 'Remove') {
        var MoneyChange = '<div class="money minus" id="id-'+RandomId+'">-€ <span class="reset-color">'+data.amount+'</span></div>'
        $('.money-container').append(MoneyChange);
        CurrentTransactionsShowing = CurrentTransactionsShowing + 1
        setTimeout(function() {
            $("#id-"+RandomId).fadeOut(750, function() {
                $("#id-"+RandomId).remove();
                CurrentTransactionsShowing = CurrentTransactionsShowing - 1
                if (CurrentTransactionsShowing == 0 || CurrentTransactionsShowing < 0) {
                    $(".current-money").fadeOut(300);
                }
            });
        }, 3500)
    } else {
        var MoneyChange = '<div class="money plus" id="id-'+RandomId+'">+€ <span class="reset-color">'+data.amount+'</span></div>'
        $('.money-container').append(MoneyChange);
        CurrentTransactionsShowing = CurrentTransactionsShowing + 1
        setTimeout(function() {
            $("#id-"+RandomId).fadeOut(750, function() {
                $("#id-"+RandomId).remove();
                CurrentTransactionsShowing = CurrentTransactionsShowing - 1
                if (CurrentTransactionsShowing == 0 || CurrentTransactionsShowing < 0) {
                    $(".current-money").fadeOut(300);
                }
            });
        }, 3500)
    }
}

ShowCurrentMoney = function() {
    $(".current-money").fadeIn(150);
    setTimeout(function() {
        $(".current-money").fadeOut(750);
    }, 3500)
}

window.onload = function(e) {
 $(".current-money").fadeOut(1);
 $(".vehicle-hud-container").fadeOut(1);
}

window.addEventListener('message', function(event) {
 switch(event.data.action) {
     case "UpdateProximity":
         UpdateProximity(event.data);
         break;
     case "UpdateHud":
         UpdateHud(event.data);
         break;
     case "ChangeMoney":
         ChangeMoney(event.data);
         break;
     case "SetMoney":
         CurrentCash = event.data.amount
         $(".current-money").html('€ <span class="reset-color">'+CurrentCash+'</span>')
         break;
     case "ShowCash":
         ShowCurrentMoney()
         break;
     case "Show":
         ShowHud();
         break;
     case "Hide":
         HideHud();
         break;
     case "OpenCarHud":
         OpenCarHud();
         break;
     case "CloseCarHud":
         CloseCarHud();
         break;
 }
});