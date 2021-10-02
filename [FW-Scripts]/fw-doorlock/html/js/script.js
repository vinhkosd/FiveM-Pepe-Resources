Doorlock = {}

const $notification = $('.notification.template').clone();
var CurrentClass = {}

Doorlock.Show = function(data) {
  $notification.html('');
  $notification.removeClass('template');
  if (data.text == 'closed') {
      CurrentClass = 'error'
      $notification.append('<div class="alert-detail"><span> Gesloten</span></div>');
  } else if (data.text == 'closed-auth') {
      CurrentClass = 'error'
      $notification.append('<div class="alert-detail"><span> [E] Gesloten</span></div>');
  } else if (data.text == 'open') {
      CurrentClass = 'success'
      $notification.append('<div class="alert-detail"><span> Open</span></div>');
  } else if (data.text == 'open-auth') {
      CurrentClass = 'success'
      $notification.append('<div class="alert-detail"><span> [E] Open</span></div>');
  }
  $notification.addClass(CurrentClass);
  $notification.fadeIn();
  $('.notif-container').append($notification);
}

Doorlock.Remove = function(data) {
  $.when($notification.fadeOut()).done(function() {
      $notification.removeClass(CurrentClass);
      $notification.remove()
  });
}

window.addEventListener('message', function(event) {
 switch(event.data.action) {
    case "show":
        Doorlock.Show(event.data);
        break;
    case "remove":
        Doorlock.Remove(event.data);
        break;
    }
});