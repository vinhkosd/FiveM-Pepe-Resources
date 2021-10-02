window.addEventListener('message', function (event) {
    switch(event.data.action) {
        case 'show':
            ShowNotif(event.data);
            break;
        default:
            ShowNotif(event.data);
            break;
    }
});

function ShowNotif(data) {
    var $notification = $('.notification.template').clone();
    var Text = '  ' + data.text
    var Icon = ''
    if (data.type === 'success') {
        Icon =  '<span style="font-size:1.2vh; color: #176236;"><i class="fas fa-check-circle"></i></span>'
    } else if (data.type === 'primary') {
        Icon =  '<span style="font-size:1.2vh; color: #194a6b;"><i class="fas fa-info-circle"></i></span>'
    } else if (data.type == 'info') {
        Icon =  '<span style="font-size:1.2vh; color: #ac783d;"><i class="fas fa-exclamation-circle"></i></span>'
    } else {
        Icon =  '<span style="font-size:1.2vh; color: #72140a;"><i class="fas fa-times-circle"></i></span>'
    }
    $notification.removeClass('template');
    $notification.addClass(data.type);
    $notification.append('<div class="alert-detail">' +  Icon  + ' <span> ' + Text + ' </span></div>');
    $notification.fadeIn();
    $('.notif-container').append($notification);
    setTimeout(function() {
        $.when($notification.fadeOut()).done(function() {
            $notification.remove()
        });
    }, data.length != null ? data.length : 2500);
}