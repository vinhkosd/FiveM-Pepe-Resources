$(document).on('click', '.garage-vehicle', function(e){
    e.preventDefault();

    $(".garage-homescreen").animate({
        left: 30+"vh"
    }, 200);
    $(".garage-detailscreen").animate({
        left: 0+"vh"
    }, 200);

    var Id = $(this).attr('id');
    var VehData = $("#"+Id).data('VehicleData');
    SetupDetails(VehData);  
});

$(document).on('click', '.garage-cardetails-footer', function(e){
    e.preventDefault();

    $(".garage-homescreen").animate({
        left: 00+"vh"
    }, 200);
    $(".garage-detailscreen").animate({
        left: -30+"vh"
    }, 200);
});

$(document).on('click', '#garage-back', function(e){
    e.preventDefault();

    $(".garage-homescreen").animate({
        left: 00+"vh"
    }, 200);
    $(".garage-detailscreen").animate({
        left: -30+"vh"
    }, 200);
});


SetupGarageVehicles = function(Vehicles) {
    $(".garage-vehicles").html("");
    if (Vehicles != null) {
        $.each(Vehicles, function(i, vehicle){
            var Element = '<div class="garage-vehicle" id="vehicle-'+i+'"> <span class="garage-vehicle-firstletter">'+vehicle.model.charAt(0)+'</span> <span class="garage-vehicle-name">'+vehicle.fullname+'</span> </div>';
            
            $(".garage-vehicles").append(Element);
            $("#vehicle-"+i).data('VehicleData', vehicle);
        });
    }
}

$(document).on('click', '#garage-sellveh', function(e){
    e.preventDefault();

    $(".garage-cardetails-footer").hide();
    $(".garage-cardetails-footer2").hide();
    $(".garage-pricescreen").show();

});

$(document).on('click', '#garage-pricescreen-sellveh', function(e){
    e.preventDefault();
    vehicle = $("#garage-sellveh").data("value")
    price = $("#veh-price").val();
    if (vehicle !== "") {
        $(".garage-cardetails-footer").show();
        $(".garage-cardetails-footer2").show();
        $(".garage-pricescreen").hide();

        $.post('http://fw-phone/SellVehicle', JSON.stringify({
            plate: vehicle,
            price: price,
        }));
        QB.Phone.Notifications.Add("fas fa-car", "Autoscout24", "Voertuig werd op Autoscout24 geplaatst!", "#f39c12", 2000);
    } else {
        QB.Phone.Notifications.Add("fas fa-times-circle", "Oeps...", "Er liep iets fout, probeer het later opnieuw...", "#e74c3c", 2000);
    }

});

$(document).on('click', '#garage-pricescreen-back', function(e){
    e.preventDefault();

    $(".garage-cardetails-footer").show();
    $(".garage-cardetails-footer2").show();
    $(".garage-pricescreen").hide();

});

SetupDetails = function(data) {
    $(".vehicle-model").find(".vehicle-answer").html(data.model);
    $(".vehicle-plate").find(".vehicle-answer").html(data.plate);
    $(".vehicle-garage").find(".vehicle-answer").html(data.garage);
    $(".vehicle-status").find(".vehicle-answer").html(data.state);
    $(".vehicle-fuel").find(".vehicle-answer").html(Math.ceil(data.fuel)+"%");
    $(".vehicle-engine").find(".vehicle-answer").html(Math.ceil(data.engine / 10)+"%");
    $(".vehicle-body").find(".vehicle-answer").html(Math.ceil(data.body / 10)+"%");
    $("#garage-sellveh").data("value", data.plate);
}