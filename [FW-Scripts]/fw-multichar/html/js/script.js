var ClickedData = null;
var SelectedChar = null;
var CanChoose = false;

$(document).on('click', '.multichar-card', function(e) {
 e.preventDefault();
  if (CanChoose) {
    $.post('http://fw-multichar/Click', JSON.stringify({}));
    if (SelectedChar !== null) {
      if (ClickedData.CitizenId == "" || ClickedData.CitizenId == undefined) {
       $(".text-input-name").val('');
       $(".text-input-lastname").val('');
       $(".text-input-birthdate").val('');
       $('.new-char-container').animate({bottom: "-60vh"}, 1000)
      } else {
       $('.play-select-container').animate({bottom: "-20vh"}, 1000)
      }
      SelectedChar.removeClass("selected-char");
      SelectedChar = null;
    } else {
      SelectedChar = $(this)
      ClickedData = {CitizenId: SelectedChar.data('citizenid'), Slot: SelectedChar.data('charslot')}
      $.post('http://fw-multichar/ClickedCard', JSON.stringify({Slot: ClickedData.Slot}));
      if (ClickedData.CitizenId == "" || ClickedData.CitizenId == undefined) {
       $('.play-select-container').animate({bottom: "-20vh"}, 1000)
       $('.new-char-container').animate({bottom: "57vh"}, 1000)
      } else {
       $('.play-select-container').animate({bottom: "2vh"}, 1000)
      }
      SelectedChar.addClass("selected-char");
    }
  }
});

$(document).on('click', '.play-button', function(e) {
    e.preventDefault();
    if (CanChoose) {
        if (ClickedData.CitizenId != "" && ClickedData.Slot != null) {
          $.post('http://fw-multichar/Click', JSON.stringify({}));
          $.post('http://fw-multichar/SelectCharacter', JSON.stringify({Citizenid: ClickedData.CitizenId, Slot: ClickedData.Slot}));
          CloseCharScreen()
        }
    }
});

$(document).on('click', '.delete-button', function(e) {
    e.preventDefault();
    if (CanChoose) {
        if (ClickedData.CitizenId != "" && ClickedData.Slot != null) {
          $.post('http://fw-multichar/Click', JSON.stringify({}));
          $.post('http://fw-multichar/DeleteCharacter', JSON.stringify({Citizenid: ClickedData.CitizenId, Slot: ClickedData.Slot}));
          CloseCharScreen()
        }
    }
});

$(document).on('click', '.submit-button', function(e) {
    e.preventDefault();
    if (CanChoose) {
        var CharName = $(".text-input-name").val();
        var CharLastName = $(".text-input-lastname").val();
        var CharBirthdate = $(".text-input-birthdate").val();
        var CharGender = $(".text-input-gender").val();
        var ResultGender = 0
        if (CharGender == 'vrouw') {
          ResultGender = 1
        }
        if (CharName != "" && CharLastName != "" && CharBirthdate != "") {
          $.post('http://fw-multichar/Click', JSON.stringify({}));
          $.post('http://fw-multichar/CreateNewChar', JSON.stringify({FirstName: CharName, LastName: CharLastName, BirthDate: CharBirthdate, Gender: ResultGender, Slot: ClickedData.Slot}));
          CloseCharScreen()
        }
    }
});

$(document).on('click', '.cancel-button', function(e) {
    e.preventDefault();
    if (CanChoose) {
        $(".text-input-name").val('');
        $(".text-input-lastname").val('');
        $(".text-input-birthdate").val('');
        $('.new-char-container').animate({bottom: "-60vh"}, 1000)
        $.post('http://fw-multichar/Click', JSON.stringify({}));
    }
});

SetupChars = function() {
  $('.multichar-container').fadeIn(1500)
  $.post('http://fw-multichar/GetCharacters', JSON.stringify({}), function(Characters){
     for (const [key, value] of Object.entries(Characters)) {
          $("#char-"+value.CharSlot).html('');
          $("#char-"+value.CharSlot).data('citizenid', value.Citizenid)
          $("#char-"+value.CharSlot).html('<p>Tên: '+ value.Name +'</p><p>Nghề nghiệp: '+ value.Job +'</p><p>BSN: '+ value.Citizenid +'</p><span class="tooltiptext">Đang chọn</span>');
      }
  });
}

ShowCard = function(Data) {
  $('#char-'+Data.slot).fadeIn(1500)
}

EnableChoose = function() {
  CanChoose = true;
}

ResetJs = function() {
 $("#char-1").html('<p>Nhân vật mới</p><span class="tooltiptext">Tạo</span>');
 $("#char-2").html('<p>Nhân vật mới</p><span class="tooltiptext">Tạo</span>');
 $("#char-3").html('<p>Nhân vật mới</p><span class="tooltiptext">Tạo</span>');
 $("#char-1").data('citizenid', "")
 $("#char-2").data('citizenid', "")
 $("#char-3").data('citizenid', "")
 $(".text-input-name").val('');
 $(".text-input-lastname").val('');
 $(".text-input-birthdate").val('');
 $('#char-1').fadeOut(1)
 $('#char-2').fadeOut(1)
 $('#char-3').fadeOut(1)
 SelectedChar.removeClass("selected-char");
 $('.new-char-container').animate({bottom: "-60vh"}, 1000)
 $('.play-select-container').animate({bottom: "-20vh"}, 1000)
 SelectedChar = null;
 ClickedData = null;
 CanChoose = false;
}

CloseCharScreen = function() {
  ResetJs()
  $('.multichar-container').fadeOut(750)
  $.post('http://fw-multichar/CloseNui', JSON.stringify({}));
}

window.addEventListener('message', function(event) {
  switch(event.data.action) {
      case "OpenCharSelect":
        SetupChars();
        break;
      case "ShowCard":
        ShowCard(event.data);
        break;
      case "EnableChoose":
        EnableChoose();
        break;
  }
});

window.onload = function(e) {
 $('#char-1').fadeOut(1)
 $('#char-2').fadeOut(1)
 $('#char-3').fadeOut(1)
}