Tablet = {}

Tablet.Open = function() {
    $(".tablet-container").css("display", "block").css("user-select", "none");
    $(".tablet-container iframe").css("display", "block");
    $(".tablet-frame").css("display", "block").css("user-select", "none");
    $(".tablet-bg").css("display", "block");
    $(".click").css("display", "block");
}

Tablet.Close = function() {
    $(".tablet-container iframe").css("display", "none");
    $(".tablet-container").css("display", "none");
    $(".tablet-frame").css("display", "none");
    $(".tablet-bg").css("display", "none");
    $(".click").css("display", "none");
    $.post("http://fw-judge/closetablet", JSON.stringify({}));
}

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27:
         Tablet.Close();
         break;
    }
});

$(document).on("click", ".click", function(e){
    e.preventDefault();
    Tablet.Close();
    $.post('http://fw-judge/closetablet');
 });

document.onreadystatechange = () => {
 if (document.readyState === "complete") {
     window.addEventListener('message', function(event) {
        if (event.data.type == "tablet") {
            Tablet.Open();
        }
     });
    };
};

