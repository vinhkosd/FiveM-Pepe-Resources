$(document).on('click', '.spawn-dots', function(e){
    e.preventDefault();
    OnClick()
    var SpawnDot = $(this).data('dotnum');
    CloseContainer()
    $.post('http://fw-spawn/SpawnPlayer', JSON.stringify({
        SpawnId: SpawnDot
    }))
});

$(document).on('click', '.appartment-dots', function(e){
    e.preventDefault();
    OnClick()
    var AppartmentDot = $(this).data('dotnum');
    CloseContainer()
    $.post('http://fw-spawn/ChooseAppartment', JSON.stringify({
        AppId: AppartmentDot
    }))
});

$(document).on('click', '.last-location-button', function(e){
    e.preventDefault();
    OnClick()
    CloseContainer()
    $.post('http://fw-spawn/SpawnPlayer', JSON.stringify({
        SpawnId: 'lastlocation'
    }))
});

$(document).on('click', '.jail-dots', function(e){
    e.preventDefault();
    OnClick()
    CloseContainer()
    var JailDot = $(this).data('dotnum');
    $.post('http://fw-spawn/SpawnJail', JSON.stringify({
        JailId: JailDot
    }))
});

CloseContainer = function() {
 $.post('http://fw-spawn/Close', JSON.stringify({})) 
 $(".main-map-container").animate({"left": "-150vh"}, 1000, function() {
    $(".main-map-container").css("display", "none");
    $(".map-text").css("left", "81vh");
    $('.map-text').html('<p>Chọn nơi xuất phát</p>');
    $(".spawn-dots-container").fadeOut(1);
    $(".appartment-dots-container").fadeOut(1);
    $(".spawn-jail-dots-container").fadeOut(1);
    $(".last-location-button").fadeOut(1);
 }) 
}

OpenSpawn = function(data) {
  $('.map-text').html('<p>Chọn nơi xuất phát</p>');
  $(".map-text").css("left", "81vh");
  $(".main-map-container").css("display", "block");
  $(".main-map-container").animate({"left": "0vh"}, 1000)
  if (!data.injail) {
    $(".last-location-button").fadeIn(450);
    $(".spawn-dots-container").fadeIn(450);
  } else {
    $(".spawn-jail-dots-container").fadeIn(450);
  }
}

OpenNew = function() {
 $(".main-map-container").css("display", "block");
 $(".main-map-container").animate({"left": "0vh"}, 1000)
 $(".map-text").css("left", "79vh");
 $('.map-text').html('<p>Chọn căn hộ</p>');
 $(".appartment-dots-container").fadeIn(450);
}

OnClick = function() {
  $.post('http://fw-spawn/Click', JSON.stringify({}))  
}

window.onload = function(e) {
 $(".spawn-dots-container").fadeOut(1);
 $(".appartment-dots-container").fadeOut(1);
 $(".spawn-jail-dots-container").fadeOut(1);
 $(".last-location-button").fadeOut(1);
}

window.addEventListener('message', function(event) {
  switch(event.data.action) {
      case "spawn":
          OpenSpawn(event.data);
          break;
      case "new":
          OpenNew(event.data);
          break;
  }
});