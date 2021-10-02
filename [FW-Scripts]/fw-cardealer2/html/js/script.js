var CurrentMenu = 'Home';
var CurrentData = null;
var SelectedCategory = $('.cardealer-block');

$(document).on('click', '.car-slot', function(e) {
    e.preventDefault();
    var Model = $(this).data('model');
    CurrentData = {Model: $(this).data('model'), Slot: $(this).data('slot')}
    $.post('http://fw-cardealer2/Click', JSON.stringify({}))
    $('.choose-slot-vehicle').css("display", "block");
    $('.choose-slot-vehicle').animate({"bottom": "35vh"}, 450)
});

$(document).on('click', '.subit-button', function(e) {
    e.preventDefault();
    var SelectedModel = $(".input-vehicle").val();
    $.post('http://fw-cardealer2/Click', JSON.stringify({}))
    $.post('http://fw-cardealer2/SetSlotVehicle', JSON.stringify({slot: CurrentData.Slot, model: SelectedModel}))
    $(".choose-slot-vehicle").animate({"bottom": "-6vh"}, 450, function() {
      $('.choose-slot-vehicle').css("display", "none");
      CloseTablet()
   }) 
});

$(document).on('click', '.cancel-button', function(e) {
    e.preventDefault();
    $.post('http://fw-cardealer2/Click', JSON.stringify({}))
    $(".choose-slot-vehicle").animate({"bottom": "-6vh"}, 450, function() {
      $('.choose-slot-vehicle').css("display", "none");
   }) 
});

$(document).on('click', '.menu-item', function(e) {
    e.preventDefault();
    var MenuType = $(this).data('type')
    if (MenuType != CurrentMenu) {
        $.post('http://fw-cardealer2/Click', JSON.stringify({}))
        if (MenuType == 'Home') {
            CurrentMenu = 'Home'
            OpenOtherCategory('.cardealer-block')
        } else if (MenuType == 'Stock') {
            CurrentMenu = 'Stock'
            OpenOtherCategory('.stock-block')
        } else if (MenuType == 'Sold') {
            CurrentMenu = 'Sold'
            OpenOtherCategory('.sold-block')
        }
    } else {
      $.post('http://fw-cardealer2/ErrorSound', JSON.stringify({}))
    }
});

SetupStock = function() {
  $.post('http://fw-cardealer2/GetStockVehicles', JSON.stringify({}), function(CarData){
    for (const [key, value] of Object.entries(CarData)) {
      var AddVehicle = '<div class="stock-cards"> <img src="img/cars/small/'+value['VehicleName']+'.jpg" class="stock-img"><p>Naam: '+value['VehicleDisplayName']+'</p><p>Voorraad: '+value['VehicleStock']+'x</p><p>Kost: €'+value['VehiclePrice']+'</p></div>'
      $('.stock-block').append(AddVehicle);
     }
  });
}

SetupCarSlots = function() {
  $.post('http://fw-cardealer2/GetDisplayVehicles', JSON.stringify({}), function(CarData){
    for (const [key, value] of Object.entries(CarData)) {
      var AddSlotVehicle = '<div class="car-slot" data-slot='+value['Slot']+'><div class="corner-number"><p>'+value['Slot']+'</p></div><i class="fas fa-plus"></i></div>'
      if (value['Model'] != null & value['Model'] != undefined) {
        AddSlotVehicle = '<div class="car-slot" data-model="'+value['Model']+'" data-slot='+value['Slot']+'><div class="corner-number"><p>'+value['Slot']+'</p></div><img src="img/cars/big/'+value['Model']+'.jpg" class="slot-img"></div>'
      }
      $('.cardealer-block').append(AddSlotVehicle);
     }
  });
}

OpenOtherCategory = function(NewMenu) {
  $(SelectedCategory).fadeOut(450, function() {
    SelectedCategory = $(NewMenu)
    $(SelectedCategory).fadeIn(450)
  })
}

CloseTablet = function() {
  $('.main-container').animate({"left": "-180vh"}, 250, function() {
    OpenOtherCategory('.cardealer-block')
    CurrentMenu = 'Home'
    $('.cardealer-block').html('')
    $('.stock-block').html('')
    $('.main-container').css("display", "none");
    $.post('http://fw-cardealer2/CloseNui', JSON.stringify({}))
  })
}

OpenTablet = function() {
  $('.main-container').css("display", "block");
  $('.main-container').animate({"left": "0vh"}, 750)
  SetupStock()
}

window.onload = function(e) {
  $('.stock-block').fadeOut(1)
  $('.sold-block').fadeOut(1)
}

window.addEventListener('message', function(event) {
  switch(event.data.action) {
     case "OpenTablet":
        SetupCarSlots()
        OpenTablet();
        break;
     case "CloseTablet":
        CloseTablet()
        break;
  }
});
 
document.onkeyup = function (data) {
 if (data.which == 27) { // Escape
   CloseTablet()
 }
};