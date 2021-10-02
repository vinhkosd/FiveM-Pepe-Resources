var SelectedBankData = {balance: null, bankid: null, owner: null}
var SelectedSlot = null;
var SelectedBank = null;

OpenBank = function(data) {
    var Count = 0;
    var SubCount = 0;
    $(".loader").fadeIn(450);
    $(".select-container").fadeIn(750);
    $(".bank-container").fadeIn(750);
    $('.personal-accounts').html('')
    $('.shared-accounts').html('')
    $('.firstname').html('<p>Welkom terug, <b>'+ data.chardata.charinfo.firstname + ' ' + data.chardata.charinfo.lastname +'</b>.</p>')
    $('#private').data('saldo', data.chardata.money['bank'])
    $('#private').data('bankid', data.chardata.charinfo.account)
    $('#private').html('<div class="account-card-container"><div style="padding-top: 10px;float:left;"><i class="fas fa-money-check"></i></div><div style="padding-left:60px;"><p id="account-name" class="account-name">'+ data.chardata.charinfo.firstname + ' ' + data.chardata.charinfo.lastname +'</p><p id="account-number" class="account-number">' + data.chardata.charinfo.account + '</p><p id="account-amount" class="account-amount">Saldo: €' + data.chardata.money['bank'] + '</p></div></div>');
    setTimeout(function() {
    $.post('http://fw-banking/GetPrivateAcounts', JSON.stringify({}), function(Accounts){
        for (const [key, value] of Object.entries(Accounts)) {
         Count = parseInt(Count) + parseInt(key)
         var OpenAccounts = '<div class="delete-shared-account" data-bankid='+value.BankId+' style="float:left;margin-top:25px; position: absolute; left: 2px;"><i class="fas fa-times" style="font-size: 15px; color: red;"></i></div><div class="account-card" id="slot-'+key+'" data-saldo="'+value.Balance+'" data-bankid ="'+value.BankId+'" data-owner="'+value.Owner+'" data-slot="'+key+'"><div class="account-card-container" ><div style="padding-top: 10px;float:left;"><i class="fas fa-money-check"></i></div><div style="padding-left:60px;"><p id="account-name" class="account-name">'+ value.Name +'</p><p id="account-number" class="account-number">'+ value.BankId +'</p><p id="account-amount" class="account-amount">Saldo: €'+ value.Balance +'</p></div></div>';
         $('.personal-accounts').append(OpenAccounts);
        }
        if (Count < 1) {
            var AddAccount = '<div class="account-card" id="slot-1" data-saldo="" data-bankid ="" data-owner="" data-slot=1><div class="account-card-container" ><div style="padding-top: 10px;float:left;"><i class="fas fa-money-check"></i></div><div style="padding-left:60px;"><p id="account-name" class="account-name">-</p><p id="account-number" class="account-number">-</p><p id="account-amount" class="account-amount">-</p></div></div></div>';
            $('.personal-accounts').append(AddAccount);
         }
    });
    $.post('http://fw-banking/GetSharedAccounts', JSON.stringify({}), function(Accounts){
        for (const [key, value] of Object.entries(Accounts)) {
            SubCount = parseInt(SubCount) + parseInt(key)
            if (data.chardata.citizenid == value.Owner) {
                var OpenAccounts = '<div class="delete-shared-account" data-bankid='+value.BankId+' style="float:left;margin-top:25px; position: absolute; left: 2px;"><i class="fas fa-times" style="font-size: 15px; color: red;"></i></div><div class="account-card" id="openaccount'+key+'" data-saldo='+value.Balance+' data-bankid ='+value.BankId+' data-owner='+value.Owner+' data-slot=2><div class="account-card-container" ><div style="padding-top: 10px;float:left;"><i class="fas fa-users"></i></div><div style="padding-left:60px;"><p id="account-name" class="account-name">'+value.Name+'</p><p id="account-number" class="account-number">' + value.BankId + '</p><p id="account-amount" class="account-amount">€' + value.Balance + '</p></div></div>';
                $(".shared-accounts").append(OpenAccounts); 
            } else {
                var OpenAccounts = '<div class="account-card" id="openaccount'+key+'" data-saldo='+value.Balance+' data-bankid ='+value.BankId+' data-owner='+value.Owner+' data-slot=2><div class="account-card-container" ><div style="padding-top: 10px;float:left;"><i class="fas fa-users"></i></div><div style="padding-left:60px;"><p id="account-name" class="account-name">'+value.Name+'</p><p id="account-number" class="account-number">' + value.BankId + '</p><p id="account-amount" class="account-amount">€' + value.Balance + '</p></div></div>';
                $(".shared-accounts").append(OpenAccounts); 
            }
        }
        if (SubCount < 1) {
            var AddAccount = '<div class="account-card" id="slot-10" data-saldo="" data-bankid ="" data-owner="" data-slot=10><div class="account-card-container" ><div style="padding-top: 10px;float:left;"><i class="fas fa-users"></i></i></div><div style="padding-left:60px;"><p id="account-name" class="account-name">-</p><p id="account-number" class="account-number">-</p><p id="account-amount" class="account-amount">-</p></div></div></div>';
            $('.shared-accounts').append(AddAccount);
        }
    });
    if (!data.candeposit) {
        $("#deposit").fadeOut(750);   
    }
    $(".loader").fadeOut(750, function() {
        $(".select-container-hide").fadeIn(750); 
        $(".bank-container-hide").fadeIn(750); 
      });
    }, 3500)  
}

RefreshBank = function() {
    var Count = 0;
    var SubCount = 0;
    $('.personal-accounts').html('')
    $('.shared-accounts').html('')
    $.post('http://fw-banking/GetPersonalBalance', JSON.stringify({}), function(Data){
        $('#private').data('saldo', Data.Balance)
        $('#private').data('bankid', Data.BankId)
        $('#private').html('<div class="account-card-container"><div style="padding-top: 10px;float:left;"><i class="fas fa-money-check"></i></div><div style="padding-left:60px;"><p id="account-name" class="account-name">'+ Data.Name +'</p><p id="account-number" class="account-number">' + Data.BankId + '</p><p id="account-amount" class="account-amount">Saldo: €' + Data.Balance + '</p></div></div>');
    $.post('http://fw-banking/GetPrivateAcounts', JSON.stringify({}), function(Accounts){
        for (const [key, value] of Object.entries(Accounts)) {
         Count = parseInt(Count) + parseInt(key)
         var OpenAccounts = '<div class="delete-shared-account" data-bankid='+value.BankId+' style="float:left;margin-top:25px; position: absolute; left: 2px;"><i class="fas fa-times" style="font-size: 15px; color: red;"></i></div><div class="account-card" id="slot-'+key+'" data-saldo="'+value.Balance+'" data-bankid ="'+value.BankId+'" data-owner="'+value.Owner+'" data-slot="'+key+'"><div class="account-card-container" ><div style="padding-top: 10px;float:left;"><i class="fas fa-money-check"></i></div><div style="padding-left:60px;"><p id="account-name" class="account-name">'+ value.Name +'</p><p id="account-number" class="account-number">'+ value.BankId +'</p><p id="account-amount" class="account-amount">Saldo: €'+ value.Balance +'</p></div></div>';
         $('.personal-accounts').append(OpenAccounts);
        }
        if (Count < 1) {
            var AddAccount = '<div class="account-card" id="slot-1" data-saldo="" data-bankid ="" data-owner="" data-slot=1><div class="account-card-container" ><div style="padding-top: 10px;float:left;"><i class="fas fa-money-check"></i></div><div style="padding-left:60px;"><p id="account-name" class="account-name">-</p><p id="account-number" class="account-number">-</p><p id="account-amount" class="account-amount">-</p></div></div></div>';
            $('.personal-accounts').append(AddAccount);
         }
    });
    $.post('http://fw-banking/GetSharedAccounts', JSON.stringify({}), function(Accounts){
        for (const [key, value] of Object.entries(Accounts)) {
            SubCount = parseInt(SubCount) + parseInt(key)
            if (Data.CitizenId == value.Owner) {
                var OpenAccounts = '<div class="delete-shared-account" data-bankid='+value.BankId+' style="float:left;margin-top:25px; position: absolute; left: 2px;"><i class="fas fa-times" style="font-size: 15px; color: red;"></i></div><div class="account-card" id="openaccount'+key+'" data-saldo='+value.Balance+' data-bankid ='+value.BankId+' data-owner='+value.Owner+' data-slot=2><div class="account-card-container" ><div style="padding-top: 10px;float:left;"><i class="fas fa-users"></i></div><div style="padding-left:60px;"><p id="account-name" class="account-name">'+value.Name+'</p><p id="account-number" class="account-number">' + value.BankId + '</p><p id="account-amount" class="account-amount">€' + value.Balance + '</p></div></div>';
                $(".shared-accounts").append(OpenAccounts);
            } else {
                var OpenAccounts = '<div class="account-card" id="openaccount'+key+'" data-saldo='+value.Balance+' data-bankid ='+value.BankId+' data-owner='+value.Owner+' data-slot=2><div class="account-card-container" ><div style="padding-top: 10px;float:left;"><i class="fas fa-users"></i></div><div style="padding-left:60px;"><p id="account-name" class="account-name">'+value.Name+'</p><p id="account-number" class="account-number">' + value.BankId + '</p><p id="account-amount" class="account-amount">€' + value.Balance + '</p></div></div>';
                $(".shared-accounts").append(OpenAccounts);
            }
        }
        if (SubCount < 1) {
            var AddAccount = '<div class="account-card" id="slot-10" data-saldo="" data-bankid ="" data-owner="" data-slot=10><div class="account-card-container" ><div style="padding-top: 10px;float:left;"><i class="fas fa-users"></i></div><div style="padding-left:60px;"><p id="account-name" class="account-name">-</p><p id="account-number" class="account-number">-</p><p id="account-amount" class="account-amount">-</p></div></div></div>';
            $('.shared-accounts').append(AddAccount);
        }
    });
    });
}

SetupSharedAccount = function(data) {
 var i;
 for (i = 0; i < 6; i++) {
   $('#char-slot-'+i).html('')
 }
 for (const [key, value] of Object.entries(data.accounts)) {
      var FirstLetter = (value.Firstname).charAt(0);
      var LastLetter = (value.Lastname).charAt(0);
      if (data.citizenid === SelectedBankData.owner) {
        $(".bank-add-user").fadeIn(750);
        $('#char-slot-'+key).html('<span class="bank-user-delete" data-citizenid='+value.CitizenId+'><i class="fas fa-times-circle"></i></span><li class="bank-user-rounded"><p>'+ FirstLetter + LastLetter +'</p></li>');
    } else {
        $(".bank-add-user").fadeOut(350);
        $('#char-slot-'+key).html('<br><li class="bank-user-rounded"><p>'+ FirstLetter + LastLetter +'</p></li>');
      }
 }
 $(".account-data-multi").fadeIn(750); 
}

OnClick = function(type) {
  $.post('http://fw-banking/ClickSound', JSON.stringify({
      success: type
  }))
}

CloseBankApp = function() {
    $(".loader").fadeIn(750);
    $("#deposit").fadeIn(750); 
    $(".bank-add-user").fadeOut(750);
    $(".account-data-multi").fadeOut(750); 
    $(".select-container-hide").fadeOut(750); 
    $(".bank-container-hide").fadeOut(750); 
    $(".select-container").fadeOut(750);
    $(".bank-container").fadeOut(750); 
    $(".bank-card-create-holder").fadeOut(750);
    $(".card-create-input").val('');
    $(".bank-form").val('');
    if (SelectedBank !== null) {
     $(SelectedBank).removeClass("selected-bank");
    }
    SelectedSlot = null;
    SelectedBank = null;
    SelectedBankData = null;
    var i;
    for (i = 0; i < 6; i++) {
     $('#slot-'+i).data('saldo', '')
     $('#slot-'+i).data('bankid', '')
     $('#slot-'+i).data('owner', '')
     $('#char-slot-'+i).html('')
     $('#slot-'+i).html('<div class="account-card-container"><div style="padding-left:8px;padding-top: 10px;float:left;"><i class="fas fa-money-check"></i></div><div style="padding-left:60px;"><p id="account-name" class="account-name">-</p><p id="account-number" class="account-number">-</p><p id="account-amount" class="account-amount">-</p></div></div></div>');
     $('.shared-accounts').html('<div class="account-card" data-saldo="" data-bankid="" data-owner="" data-slot=2><div class="account-card-container" ><div style="padding-top: 10px;float:left;"><i class="fas fa-users"></i></div><div style="padding-left:60px;"><p id="account-name" class="account-name">-</p><p id="account-number" class="account-number">-</p><p id="account-amount" class="account-amount">-</p></div></div>');
    }
    $.post('http://fw-banking/CloseApp', JSON.stringify({}))
}

SetupTransactionForAccount = function(BankNumber) {
  $.post('http://fw-banking/GetTransactions', JSON.stringify({
      BankId: BankNumber,
  }));
}

SetupTransaction = function(data) {
    $("#transactions").fadeOut(450); 
    $("#transactions").html("");
    setTimeout(function() {
        for (const [key, value] of Object.entries(data.transaction)) {
            if (value.Type === 'Add') {
                var TransactionElement = '<div style="border-left: 3px solid #4CAF50;" class="bank-transaction" id="transaction'+key+'"><div style="padding-top: 7px;padding-left: 1px;float: left;"><i style="color:#4CAF50;" class="fas fa-circle-notch"></i></div><div style="padding-left: 30px;"><p class="transaction-title">Gestort ('+value.Name+') <br><strong>+ €'+value.Amount+'</strong></b></p><p class="transaction-time"><i class="fas fa-clock"></i>'+value.Date+' om '+value.Time+'</p></div></div>';
            } else {
                var TransactionElement = '<div style="border-left: 3px solid #E53935;" class="bank-transaction" id="transaction'+key+'"><div style="padding-top: 7px;padding-left: 1px;float: left;"><i style="color:#E53935;" class="fas fa-circle-notch"></i></div><div style="padding-left: 30px;"><p class="transaction-title">Opname ('+value.Name+') <br><strong>- €'+value.Amount+'</strong></b></p><p class="transaction-time"><i class="fas fa-clock"></i>'+value.Date+' om '+value.Time+'</p></div></div>';
            }
            $("#transactions").append(TransactionElement);
        }
    $("#transactions").fadeIn(450); 
    }, 500)
}

ResetJS = function() {
  $("#transactions").html("");
  if (SelectedBank !== null) {
    $(SelectedBank).removeClass("selected-bank");
  }
  SelectedSlot = null;
  SelectedBank = null;
  SelectedBankData = null;  
}

AddNumber = function(e){
    var v = $(".bank-form").val();
    $(".bank-form").val(v + e);
}

$(document).on('click', '.bank-number-button', function(e) {
    e.preventDefault();
    var KeyNumber = $(this).data('value')
    if (KeyNumber !== null) {
        OnClick('click')
        if (KeyNumber != 'clear') {
            AddNumber(KeyNumber)
        } else {
          $(".bank-form").val('');
        }
    }
});
  
$(document).on('click', '.account-card', function(e) {
    e.preventDefault();
    if ($(this).data('bankid') != '') {
        OnClick('success-click')
        var ClickedData = {balance: $(this).data('saldo'), bankid: $(this).data('bankid'), owner: $(this).data('owner')}
        if (SelectedBank !== null) {
         $(SelectedBank).removeClass("selected-bank");
        }
        $(this).addClass("selected-bank");
        $('.bankid').html('<p>Geselecteerde rekening: '+ ClickedData.bankid +'</p>')
        $('.bank-main-amount').html('<p>Beschikbaar saldo</p>€'+ ClickedData.balance +'')
        if ($(this).data('slot') !== 'private') {
            SetupTransactionForAccount(ClickedData.bankid)
        } else {
            $("#transactions").html("");
        }
        SelectedBank = $(this)
        SelectedSlot = $(this).data('slot')
        SelectedBankData = ClickedData
        if ($(this).data('slot') >= 2) {
          $.post('http://fw-banking/GetAccountUsers', JSON.stringify({
              BankId: SelectedBankData.bankid,
          }));
        } else {
            $(".account-data-multi").fadeOut(750); 
            $(".account-data-multi").fadeOut(750); 
        }
    } else {
        OnClick('success-click')
        SelectedSlot = $(this).data('slot')
        $(".bank-card-create-holder").fadeIn(750);
    }
});

$(document).on('click', '#create-account', function(e) {
    e.preventDefault();
    var BankName = $(".card-create-input").val();
    if (BankName !== undefined && BankName !== '') {
        OnClick('success-click2')
        if (SelectedSlot >= 2) {
            $(".card-create-input").val('');
            $(".bank-card-create-holder").fadeOut(750);
            $.post('http://fw-banking/CreateAccount', JSON.stringify({
              Name: BankName,
              Slot: 2,
              Type: 'shared',
            }))
            setTimeout(function() {
                RefreshBank()
            }, 500) 
        } else {
            $(".card-create-input").val('');
            $(".bank-card-create-holder").fadeOut(750);
            $.post('http://fw-banking/CreateAccount', JSON.stringify({
              Name: BankName,
              Slot: SelectedSlot,
              Type: 'private',
            })) 
            setTimeout(function() {
                RefreshBank()
            }, 500)  
        }
    }
});

$(document).on('click', '#cancel-account', function(e) {
    e.preventDefault();
    OnClick('click')
    $(".card-create-input").val('');
    $(".bank-card-create-holder").fadeOut(750);
});

$(document).on('click', '#withdraw', function(e) {
    e.preventDefault();
    var MoneyAmount = parseInt($(".bank-form").val());
    if (MoneyAmount > 0 && SelectedBank !== null) {
     $.post('http://fw-banking/Withdraw', JSON.stringify({
         BankId: SelectedBankData.bankid,
         RemoveAmount: MoneyAmount
     }))
     ResetJS()
     OnClick('success-click2')
     setTimeout(function() {
        RefreshBank()
    }, 500) 
    } else {
     OnClick('bank-error') 
    }  
});

$(document).on('click', '#deposit', function(e) {
    e.preventDefault();
    var MoneyAmount = parseInt($(".bank-form").val());
    if (MoneyAmount > 0 && SelectedBank !== null) {
     $.post('http://fw-banking/Deposit', JSON.stringify({
         BankId: SelectedBankData.bankid,
         AddAmount: MoneyAmount
     }))
     ResetJS()
     OnClick('success-click2')
     setTimeout(function() {
        RefreshBank()
    }, 500) 
    } else {
     OnClick('bank-error') 
    }  
});

$(document).on('click', '.bank-add-user', function(e) {
    $(".bank-add-user-modal").fadeIn(750); 
});

$(document).on('click', '#cancel-add', function(e) {
    $(".bank-add-user-modal").fadeOut(750); 
});

$(document).on('click', '.delete-shared-account', function(e) {
    var BankId = $(this).data('bankid')
    if (BankId != null && BankId != undefined) {
        $.post('http://fw-banking/DeleteAccount', JSON.stringify({
            BankId: BankId,
        }))
        setTimeout(function() {
            RefreshBank()
        }, 500) 
    }
});

$(document).on('click', '#logout', function(e) {
    e.preventDefault();
    OnClick('click')
    CloseBankApp()
});

$(document).on('click', '#submit-add', function(e) {
    e.preventDefault();
    var BsnNumber = $(".add-account-bsn").val();
    if (BsnNumber.length == 8) {
        OnClick('success-click2')
        $.post('http://fw-banking/AddUserToAccount', JSON.stringify({
            BankId: SelectedBankData.bankid,
            TargetBsn: BsnNumber
        }))
        $(".add-account-bsn").val('');
        $(".bank-add-user-modal").fadeOut(750); 
        setTimeout(function() {
            $.post('http://fw-banking/GetAccountUsers', JSON.stringify({
                BankId: SelectedBankData.bankid,
            }));
          }, 500) 
    } else {
        OnClick('bank-error')
    } 
});

$(document).on('click', '.bank-user-delete', function(e) {
    e.preventDefault();
    var ClickedCitizenId = $(this).data('citizenid')
    if (ClickedCitizenId !== undefined && ClickedCitizenId !== '') {
        if (ClickedCitizenId !== SelectedBankData.owner) {
         $.post('http://fw-banking/DeleteFromAccount', JSON.stringify({
             TargetBsn: ClickedCitizenId,
             BankId: SelectedBankData.bankid,
         }));
         setTimeout(function() {
           $.post('http://fw-banking/GetAccountUsers', JSON.stringify({
               BankId: SelectedBankData.bankid,
           }));
         }, 500) 
        }
    }
});

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case "openbank":
            OpenBank(event.data);
            break;
        case "SetupUsers":
            SetupSharedAccount(event.data)
            break;
        case "SetupTransaction":
            SetupTransaction(event.data)
            break;
        case "update":
            Update(event.data);
            break;
    }
});

window.onload = function(e) {
 $(".loader").fadeOut(1);
 $(".select-container").fadeOut(1);
 $(".bank-container").fadeOut(1);
 $(".select-container-hide").fadeOut(1); 
 $(".bank-container-hide").fadeOut(1); 
 $(".account-data-multi").fadeOut(1); 
 $(".bank-add-user-modal").fadeOut(1); 
 $(".account-data-multi").fadeOut(1); 
 $(".bank-card-create-holder").fadeOut(1); 
 $(".bank-add-user").fadeOut(1);
}