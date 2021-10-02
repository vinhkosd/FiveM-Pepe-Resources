var CurrentVehicleData = {}
var CurrentMenu = null;
var ChoseActive = false;

$(document).on('click', '.close-menu > i', function(e) {
  e.preventDefault();
  $.post(`http://fw-garages/Click`, JSON.stringify({}));
  CloseGarage()
});

$(document).on('click', '.back', function(e) {
  e.preventDefault();
  $.post(`http://fw-garages/Click`, JSON.stringify({}));
  CurrentMenu.removeClass("selected");
  $(".vehicle-click-container").animate({"right": "-50vh"}, 550, function() {
    $(".vehicle-click-container").css("display", "none");
    CurrentVehicleData = {}
    ChoseActive = false
    CurrentMenu = null
  })
});

$(document).on('click', '.takeout', function(e) {
  e.preventDefault();
  $.post(`http://fw-garages/Click`, JSON.stringify({}));
  if (CurrentMenu != null && CurrentMenu != undefined) {
    if (CurrentVehicleData != null && CurrentVehicleData != undefined) {
      CloseGarage()
      $.post(`http://fw-garages/TakeOutVehicle`, JSON.stringify({Plate: CurrentVehicleData.Plate, Model: CurrentVehicleData.Model, State: CurrentVehicleData.State, Engine: CurrentVehicleData.Engine, Body: CurrentVehicleData.Body, Fuel: CurrentVehicleData.Fuel, Price: CurrentVehicleData.Price}));
    }
  }
});

$(document).on("click", '.vecicle-container', function(e) {
   e.preventDefault();
   $.post(`http://fw-garages/Click`, JSON.stringify({}));
   if (CurrentMenu != null && CurrentMenu != undefined) {
     CurrentMenu.removeClass("selected");
     $(".vehicle-click-container").animate({"right": "-50vh"}, 550, function() {
       $(".vehicle-click-container").css("display", "none");
       CurrentVehicleData = {}
       ChoseActive = false
       CurrentMenu = null
     })
   } else {
     CurrentVehicleData = {Plate: $(this).data('plate'), Model: $(this).data('model'), State: $(this).data('state'), Fuel: $(this).data('fuel'), Body: $(this).data('body'), Engine: $(this).data('motor'), Price: $(this).data('price')}
     CurrentMenu = $(this)
     ChoseActive = true
     $(this).addClass("selected");
     $(".ui-vehiclestatusbarfuel").find('.hud-barfill').css("height", $(this).data('fuel') + "%");
     $(".ui-vehiclestatusbarmotor").find('.hud-barfill').css("height", $(this).data('motor') / 1000 * 100 + "%");
     $(".ui-vehiclestatusbarbody").find('.hud-barfill').css("height", $(this).data('body') / 1000 * 100 + "%");

     if ($(this).data('fuel') <= 25) {
       $(".ui-vehiclestatusbarfuel").find('.hud-barfill').css({"background-color": "rgb(126, 28, 28)"}); 
     } else {
       $(".ui-vehiclestatusbarfuel").find('.hud-barfill').css({"background-color": "#1f851c"}); 
     }

     if (($(this).data('motor') / 1000 * 100) <= 25) {
       $(".ui-vehiclestatusbarmotor").find('.hud-barfill').css({"background-color": "rgb(126, 28, 28)"}); 
     } else {
       $(".ui-vehiclestatusbarmotor").find('.hud-barfill').css({"background-color": "#1f851c"}); 
     }

     if (($(this).data('body') / 1000 * 100) <= 25) {
       $(".ui-vehiclestatusbarbody").find('.hud-barfill').css({"background-color": "rgb(126, 28, 28)"}); 
     } else {
       $(".ui-vehiclestatusbarbody").find('.hud-barfill').css({"background-color": "#1f851c"}); 
     }
     $(".vehicle-click-container").css("display", "block");
     $(".vehicle-click-container").animate({"right": "0vh"}, 250)
   }
});

SetupGarageVehicles = function(data) {
  $(".menu-container").html('')
  for (const [key, value] of Object.entries(data.garagevehicles)) {
    if (value['State'] === 'out') {
      var AddVehicle = '<div class="vecicle-container" data-plate='+value['Plate']+' data-model='+value['Model']+' data-state='+value['State']+' data-fuel='+value['Fuel']+' data-motor='+value['Motor']+' data-body='+value['Body']+'><span class="vehicle-status status-out">Uit</span><p><i class="fas fa-car"></i> '+ value['Name'] +'</p></div>'
      $('.menu-container').append(AddVehicle);
    } else {
      var AddVehicle = '<div class="vecicle-container" data-plate='+value['Plate']+' data-model='+value['Model']+' data-state='+value['State']+' data-fuel='+value['Fuel']+' data-motor='+value['Motor']+' data-body='+value['Body']+'><span class="vehicle-status status-in">In</span><p><i class="fas fa-car"></i> '+ value['Name'] +'</p></div>'
      $('.menu-container').append(AddVehicle);
    }
  }
  $(".main-container").css("display", "block");
  $(".main-container").animate({"right": "2vh"}, 550)
}

SetupDepotVehicles = function(data) {
  $(".menu-container").html('')
  for (const [key, value] of Object.entries(data.depotvehicles)) {
      var AddVehicle = '<div class="vecicle-container" data-plate='+value['Plate']+' data-model='+value['Model']+' data-state='+value['State']+' data-price='+value['Price']+' data-fuel='+value['Fuel']+' data-motor='+value['Motor']+' data-body='+value['Body']+'><span class="vehicle-status status-out"> €'+value['Price']+'</span><p><i class="fas fa-car"></i> '+ value['Name'] +'</p></div>'
      $('.menu-container').append(AddVehicle);
  }
  $(".main-container").css("display", "block");
  $(".main-container").animate({"right": "2vh"}, 550)
}

CloseGarage = function() {
  var VehicleTab = document.getElementById('vehicle-tab');
  if (ChoseActive) {
    CurrentMenu.removeClass("selected");
    $(".vehicle-click-container").animate({"right": "-50vh"}, 1450, function() {
      $(".vehicle-click-container").css("display", "none");
      CurrentVehicleData = {}
      ChoseActive = false
      CurrentMenu = null
    })
  }
  VehicleTab.scrollTop = 0;
  $(".main-container").animate({"right": "-50vh"}, 550, function() {
    $(".main-container").css("display", "none");
    $(".menu-container").html('')
  })
  $.post(`http://fw-garages/CloseNui`, JSON.stringify({}));
}

window.addEventListener('message', function(event) {
  switch(event.data.action) {
      case "OpenGarage":
          SetupGarageVehicles(event.data);
          break;
      case "OpenDepot":
          SetupDepotVehicles(event.data);
          break;
  }
});



document.onkeyup = function (data) {
  if (data.which == 27) { // Escape
    CloseGarage()
  }
};