var Cityhall = {}
var mouseOver = false;
var selectedIdentity = null;
var selectedIdentityType = null;
var selectedJob = null;
var selectedJobId = null;

Cityhall.Open = function(data) {
    $(".container").fadeIn(150);
}

Cityhall.Close = function() {
    $(".container").fadeOut(150, function(){
        Cityhall.ResetPages();
    });
    $.post('http://fw-cityhall/Close');

    $(selectedJob).removeClass("job-selected");
    $(selectedIdentity).removeClass("job-selected");
}

Cityhall.ResetPages = function() {
    $(".cityhall-option-blocks").show();
    $(".cityhall-identity-page").hide();
    $(".cityhall-job-page").hide();
}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                Cityhall.Open(event.data);
                break;
            case "close":
                Cityhall.Close();
                break;
        }
    })
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            Cityhall.Close();
            break;
    }
});

$('.cityhall-option-block').click(function(e){
    e.preventDefault();

    var blockPage = $(this).data('page');

    $(".cityhall-option-blocks").fadeOut(100, function(){
        $(".cityhall-"+blockPage+"-page").fadeIn(100);
    });

    if (blockPage == "identity") {
        $(".identity-page-blocks").html("");
        $(".identity-page-blocks").html('<div class="identity-page-block" data-type="id-kaart" onmouseover="'+hoverDescription("id-kaart")+'" onmouseout="'+hoverDescription("id-kaart")+'"><p>ID-kaart</p></div>');
        $.post('http://fw-cityhall/requestLicenses', JSON.stringify({}), function(licenses){
            $.each(licenses, function(i, license){
                var elem = '<div class="identity-page-block" data-type="'+license.idType+'" onmouseover="hoverDescription("'+license.idType+'")" onmouseout="hoverDescription("'+license.idType+'")"><p>'+license.label+'</p></div>';
                $(".identity-page-blocks").append(elem);
            });
        });
    }
    $.post('http://fw-cityhall/Click', JSON.stringify({}))
});

hoverDescription = function(type) {
    if (!mouseOver) {
        if (type == "id-kaart") {
            $(".hover-description").fadeIn(10);
            $(".hover-description").html('<p>Je bent verplicht om een ID-kaart op je te dragen. <br>Dit is om zodat je je kunt indentificeren op ieder moment.</p>');
        } else if (type == "rijbewijs") {
            $(".hover-description").fadeIn(10);
            $(".hover-description").html('<p>Als je in een voertuig rijd ben je verplicht om een rijbewijs<br> te kunnen tonen op het moment dat deze gevraagd word.</p>');
        }
    } else {
        if(selectedIdentity == null) {
            $(".hover-description").fadeOut(10);
            $(".hover-description").html('');
        }
    }

    mouseOver = !mouseOver;
}

$(document).on("click", ".identity-page-block", function(e){
    e.preventDefault();

    var idType = $(this).data('type');

    selectedIdentityType = idType;

    if (selectedIdentity == null) {
        $(this).addClass("identity-selected");
        $(".hover-description").fadeIn(10);
        selectedIdentity = this;
        if (idType== "id-kaart") {
            $(".request-identity-button").fadeIn(100);
            $(".request-identity-button").html("<p>ID-kaart aanvragen (€50,-)</p>")
        } else {
            $(".request-identity-button").fadeIn(100);
            $(".request-identity-button").html("<p>Rijbewijs aanvragen (€50,-)</p>")
        }
    } else if (selectedIdentity == this) {
        $(this).removeClass("identity-selected");
        selectedIdentity = null;
        $(".request-identity-button").fadeOut(100);
    } else {
        $(selectedIdentity).removeClass("identity-selected");
        $(this).addClass("identity-selected");
        selectedIdentity = this;
        if($(this).data('type') == "id-kaart") {
            $(".request-identity-button").html("<p>ID-kaart aanvragen (€50,-)</p>")
        } else {
            $(".request-identity-button").html("<p>Rijbewijs aanvragen (€50,-)</p>")
        }
    }
    $.post('http://fw-cityhall/Click', JSON.stringify({}))
});

$(".request-identity-button").click(function(e){
    e.preventDefault();

    $.post('http://fw-cityhall/requestId', JSON.stringify({
        idType: selectedIdentityType
    }))

    Cityhall.ResetPages();
});

$(document).on("click", ".cityhall-close", function(e){
    Cityhall.Close()
    $.post('http://fw-cityhall/Click', JSON.stringify({}))
});

$(document).on("click", ".job-page-block", function(e){
    e.preventDefault();
    var job = $(this).data('job');
    selectedJobId = job;
    if (selectedJob == null) {
        $(this).addClass("job-selected");
        selectedJob = this;
        $(".apply-job-button").fadeIn(100);
    } else if (selectedJob == this) {
        $(this).removeClass("job-selected");
        selectedJob = null;
        $(".apply-job-button").fadeOut(100);
    } else {
        $(selectedJob).removeClass("job-selected");
        $(this).addClass("job-selected");
        selectedJob = this;
    }
    $.post('http://fw-cityhall/Click', JSON.stringify({}))
});

$(document).on('click', '.apply-job-button', function(e){
    e.preventDefault();
    $.post('http://fw-cityhall/applyJob', JSON.stringify({
        job: selectedJobId
    }))
    Cityhall.ResetPages();
});

$(document).on('click', '.back-to-main', function(e){
    e.preventDefault();
    $.post('http://fw-cityhall/Click', JSON.stringify({}))
    $(selectedJob).removeClass("job-selected");
    $(selectedIdentity).removeClass("job-selected");
    Cityhall.ResetPages();
});