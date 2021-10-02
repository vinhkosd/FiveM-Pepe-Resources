// CAR DETAILS
$(document).on('click', '.occasion-vehicle', function(e){
    e.preventDefault();

    $(".occasion-homescreen").animate({
        left: 30+"vh"
    }, 200);
    $(".occasion-detailscreen").animate({
        left: 0+"vh"
    }, 200);

    var Id = $(this).attr('id');
    var CarData = $("#"+Id).data('CarData');
    SetupCarDet(CarData);  
});

$(document).on('click', '.occasion-cardetails-footer', function(e){
    e.preventDefault();

    $(".occasion-homescreen").animate({
        left: 00+"vh"
    }, 200);
    $(".occasion-detailscreen").animate({
        left: -30+"vh"
    }, 200);
});

QB.Phone.Functions.RefreshAutoscout = function(Cars) {
    var CarsObject = $(".occasion-vehicles");
    $(CarsObject).html("");

    if (Cars !== null) {
        $.each(Cars, function(i, car){
            CarsElement = '<div class="occasion-vehicle" id="car-'+car.plate+'"><div class="occasion-vehicle-name">'+car.vehicle+'</div><div class="occasion-vehicle-price">€'+car.salePrice+'</div><div class="occasion-vehicle-plate">Nummerplaat: '+car.plate+'</div></div>'

            $(CarsObject).append(CarsElement);
            $("#car-"+car.plate).data('CarData', car);
        });
    }
}

SetupCarDet = function(data) {
    $(".occasion-bsn").find(".vehicle-answer").html(data.citizenid)
    $(".occasion-model").find(".vehicle-answer").html(data.vehicle)
    $(".occasion-plate").find(".vehicle-answer").html(data.plate)
    $(".occasion-cardetails-footer2").data("plate", data.plate);
    $(".occasion-cardetails-footer2").data("price", data.salePrice);
    $(".occasion-cardetails-footer2").data("citizenid", data.citizenid);
}

$(document).on('click', '#buy-veh', function(e){
    e.preventDefault();

    forSaleVehicle = $(".occasion-cardetails-footer2").data("plate")
    forSaleCitizenid = $(".occasion-cardetails-footer2").data("citizenid")
    forSalePrice = $(".occasion-cardetails-footer2").data("price")
    if (forSaleVehicle !== "") {
        $(".occasion-homescreen").animate({
            left: 00+"vh"
        }, 200);
        $(".occasion-detailscreen").animate({
            left: -30+"vh"
        }, 200);

        $.post('http://fw-phone/BuyVehicle', JSON.stringify({
            plate: forSaleVehicle,
            citizenid: forSaleCitizenid,
            price: forSalePrice,
        }));
        $.post('http://fw-phone/LoadAutoscout', JSON.stringify({}), function(Cars){
            QB.Phone.Functions.RefreshAutoscout(Cars);
        });
    } else {
        QB.Phone.Notifications.Add("fas fa-times-circle", "Oeps...", "Er liep iets fout, probeer het later opnieuw...", "#e74c3c", 2000);
    }
});
