$(document).ready(function(){
  $(document).on('pagecreate', function(evt) {
    $('#viewRoomScheduleResult').off("swiperight");
    $('#viewRoomScheduleResult').off("swipeleft");
    $('#viewRoomScheduleResult').on("swipeleft", function(e) {
      var jcDate = YyyyMmDd2YyyyDotMmDotDd(GetNextDate(YyyyDotMmDotDd2YyyyMmDd($("#frmViewRoomSchedule_txtDate").val())));
      $("#frmViewRoomSchedule_txtDate").val(jcDate);
      viewARoomSchedule();
    });
    $('#viewRoomScheduleResult').on("swiperight", function(e) {
      var jcDate = YyyyMmDd2YyyyDotMmDotDd(GetPrevDate(YyyyDotMmDotDd2YyyyMmDd($("#frmViewRoomSchedule_txtDate").val())));
      $("#frmViewRoomSchedule_txtDate").val(jcDate);
      viewARoomSchedule();
    });
  });

  $(document).on("pageshow", "[data-role='page']", function(){
  	if($($(this)).hasClass("header_default")){
  		$('<header data-theme="b" data-role="header"><h1></h1><a href="#" class="ui-btn-left ui-btn ui-btn-inline ui-btn-icon-notext ui-mini ui-corner-all ui-icon-back" data-rel="back">Back</a><a href="#" onclick="logout()" class="ui-btn-right ui-btn ui-btn-inline ui-btn-icon-notext ui-mini ui-corner-all ui-icon-power">Logout</a></header>')
  			.prependTo( $(this) )
  			.toolbar({position: "fixed"});
  		$("[data-role='header'] h1").text($(this).jqmData("title"));
  	} //header_default

  	$.mobile.resetActivePageHeight();

  	if($($(this)).hasClass("footer_default")){
  		$('<footer data-theme="b" data-role="footer" data-position="fixed"><nav data-role="navbar"><ul><li><a href="#home" class="ui-btn ui-icon-home ui-btn-icon-top">Home</a></li><li><a href="#find" class="ui-btn ui-icon-search ui-btn-icon-top">Find</a></li><li><a href="#book" class="ui-btn ui-icon-plus ui-btn-icon-top">Book</a></li><li><a href="#viewRoomSchedule" class="ui-btn ui-icon-eye ui-btn-icon-top">Room</a></li><li><a href="#myView" class="ui-btn ui-icon-calendar ui-btn-icon-top">MyView</a></li></ul></nav></footer>')
  			.appendTo($(this))
  			.toolbar({position: "fixed"})
	  } //footer_default  

  if($($(this)).hasClass("validate_default")){
    $.ajax(
    {
      Type: "POST",
      contentType: "application/json",
      url: "api_CRB_ValidateToken.asp?callback=?",
      data: { 'txtParam1': Z_GetMe(), 'txtParam2': Z_GetToken() },
      success: function(rv) {
        var o = jQuery.parseJSON(rv);
        if(o.bIsError)
        {
          alert("Unable to validate user credentials: " + o.cErrorMessage);
          logout();
        }
        else
        {
        }
      }
     });  
  }; //validate_default

	var current = $(".ui-page-active").attr('id');
	$("[data-role='footer'] a.ui-btn-active").removeClass("ui-btn-active");
	$("[data-role='footer'] a").each(function(){
		  if($(this).attr('href') === '#' + current) {
			 $(this).addClass('ui-btn-active');
		  }
	  }); // each link in footer
  }); //pageshow

  //Find Page
  $(document).on("pageshow", "#find", function(){
    $("#frmFind_selLoc").html("");
    $("#frmFind_selLoc").selectmenu('refresh',true); 
    //$("#frmFind_selLoc").off("blur");

    $.ajax(
    {
      Type: "POST",
      contentType: "application/json",
      url: "api_CRB_GetLocations.asp?callback=?",
      data: { 'txtParam1': Z_GetMe(), 'txtParam2': Z_GetToken() },
      success: function(rv) {
        var o = jQuery.parseJSON(rv);
        if(o.bIsError)
        {
          alert("Unable to get locations: " + o.cErrorMessage);
        }
        else
        {
          var ji;
          var jOutput = '';
          jOutput += "<option value=''>(Choose One)</option>";
          for(ji=0; ji < o.nLocations; ji++)
          {
            jOutput += "<option value='" + o.aLocations[ji].cLocation + "'>" + o.aLocations[ji].cName + "</option>";
          }
          $("#frmFind_selLoc").html(jOutput);
        }
      }
     });    
  }); //find page

  //FindResult page
  $(document).on("pageshow", "#findResult", function(){

    var jcDateIn = $("#frmFind_txtDate").val();
    var jcDateOut = jcDateIn.substring(0,4) + "" + jcDateIn.substring(5,7) + "" + jcDateIn.substring(8,10);
    var jcVC = "N", jcProjector = "N";
    if($("#frmFind_cbVC").is(":checked")){
      jcVC = "Y";
    }
    if($("frmFind_cbProjector").is(":checked")){
      jcProjector = "Y";
    }
    $.ajax(
    {
      Type: "POST",
      contentType: "application/json",
      url: "api_CRB_SuggestARoom.asp?callback=?",
      data: { 
        'txtParam1': localStorage.cUser, 
        'txtParam2': localStorage.cToken,
        'txtParamcLocation': $('#frmFind_selLoc').val(),
        'txtParamcDate': jcDateOut,
        'txtParamcFromTime': Z_MakeTime($("#frmFind_txtFromHh").val(), $("#frmFind_txtFromMi").val()),
        'txtParamcUptoTime': Z_MakeTime($("#frmFind_txtUptoHh").val(), $("#frmFind_txtUptoMi").val()),
        'txtParamcNeedVC': jcVC,
        'txtParamcProjector': jcProjector,
        'txtParamnSeats': $("#frmFind_txtPerson").val()
      },
      success: function(rv) {
        var o = jQuery.parseJSON(rv);
        if(o.bIsError)
        {
          alert("Unable to Suggest a Room: " + o.cErrorMessage);
        }
        else
        {
          if(o.nRooms < 1) {
            alert("Your search returned no rooms");
            window.location.href = "#find";
            return;
          }

          var jcOutput = '';
          jcOutput = '<ul data-role="listview" data-inset="true" class="ui-listview ui-listview-inset ui-corner-all ui-shadow">';
          for(ji=0; ji < o.nRooms; ji++) {
            jcOutput += '<li data-role="list-divider" role="heading" class="ul-li-divider ui-bar-inherit';
            if(ji === 0){
              jcOutput += ' ui-first-child';
            }
            jcOutput += '">';
            jcOutput += o.aRooms[ji].cRoom;
            jcOutput += '<span class="ui-li-count">' + o.aRooms[ji].nSeats + ' seater</span>';
            jcOutput += '</li>';  

            jcOutput += '<li class="ul-li-static ui-body-inherit';
            if(ji === (o.nRooms - 1)) {
              jcOutput += ' ui-last-child';
            } 
            jcOutput += '">';
            jcOutput += '<a href="#" onclick="try2Book(\'' + Z_GetMe() + '\',\'' + $("#frmFind_selLoc").val() + '\',\'' + o.aRooms[ji].cRoom + '\',\'' + YyyyDotMmDotDd2YyyyMmDd($("#frmFind_txtDate").val()) + '\',' + $("#frmFind_txtFromHh").val() + ',' + $("#frmFind_txtFromMi").val() + ',' + $("#frmFind_txtUptoHh").val() + ',' + $("#frmFind_txtUptoMi").val() + ')">';
            jcOutput += '<p>' + o.aRooms[ji].cLocation + '</p>';
            jcOutput += '<p>';
            jcOutput += o.aRooms[ji].cName + " is a " + o.aRooms[ji].nSeats + ' seater (max ' + o.aRooms[ji].nMaxSeats + ' persons.)' + '</p>';
            jcOutput += '<p class="ul-li-aside">';
            jcOutput += '<strong>';
            if(o.aRooms[ji].cHasVC === "Y") {
              jcOutput += "Has VC";
            } else {
              jcOutput += "No VC";
            }
            jcOutput += '<br/>';
            if(o.aRooms[ji].cHasProjector === "Y") {
              jcOutput += "Has Projector";
            } else {
              jcOutput += "No Projector";
            }            
            jcOutput += '</strong>';
            jcOutput += '</p>';
            jcOutput += '</a>';
            jcOutput += '</li>';

          }

          jcOutput += '</ul>';
          
          $('#findResultContent').html(jcOutput); 
          $("#findResultContent").listview().listview("refresh");
          $("#findResultContent").listview().trigger("create");
          
        }
      }
     });    
  }); // FindResult page

  //Book Page
  $(document).on("pageshow", "#book", function(){
    $("#frmBook_selLoc").html("");
    $("#frmBook_selRoom").html("");
    $("#frmBook_selLoc").selectmenu('refresh',true); 
    $("#frmBook_selRoom").selectmenu('refresh',true); 
    $("#frmBook_selLoc").off("blur");

    // on blur event
    $("#frmBook_selLoc").on("blur", function(){
      $.ajax(
      {
        Type: "POST",
        contentType: "application/json",
        url: "api_CRB_GetRooms.asp?callback=?",
        data: { 
          'txtParam1': Z_GetMe(), 
          'txtParam2': Z_GetToken(),
          'txtParamcLocation': $("#frmBook_selLoc").val(),
          'txtParamcFlagVC': 'X',
          'txtParamcFlagProjector': 'X',
          'txtParamnSeats': 1
        },
        success: function(rv) {
          var o = jQuery.parseJSON(rv);
          if(o.bIsError)
          {
            alert("Unable to get rooms: " + o.cErrorMessage);
          }
          else
          {
            var ji;
            var jOutput = '';
            jOutput += "<option value=''>(Choose One)</option>";
            for(ji=0; ji < o.nRooms; ji++)
            {
              jOutput += "<option value='" + o.aRooms[ji].cRoom + "'>" + o.aRooms[ji].cName + "</option>";
            }
            $("#frmBook_selRoom").html(jOutput);
            $("#frmBook_selRoom").selectmenu('refresh',true); 
          }
        }
      }); //ajax call
    }); // on blur event of frmBook_selLoc 

    $.ajax(
    {
      Type: "POST",
      contentType: "application/json",
      url: "api_CRB_GetLocations.asp?callback=?",
      data: { 'txtParam1': Z_GetMe(), 'txtParam2': Z_GetToken() },
      success: function(rv) {
        var o = jQuery.parseJSON(rv);
        if(o.bIsError)
        {
          alert("Unable to get locations: " + o.cErrorMessage);
        }
        else
        {
          var ji;
          var jOutput = '';
          jOutput += "<option value=''>(Choose One)</option>";
          for(ji=0; ji < o.nLocations; ji++)
          {
            jOutput += "<option value='" + o.aLocations[ji].cLocation + "'>" + o.aLocations[ji].cName + "</option>";
          }
          $("#frmBook_selLoc").html(jOutput);
          $("#frmBook_selLoc").attr('selectedindex',0);
          $("#frmBook_selLoc").selectmenu('refresh',true);
          //$("#frmBook_selRoom").html("");

        }
      }
     });    
  }); //book page

  //ViewRoomSchedule Page
  $(document).on("pageshow", "#viewRoomSchedule", function(){
    $("#frmViewRoomSchedule_selLoc").html("");
    $("#frmViewRoomSchedule_selRoom").html("");
    $("#frmViewRoomSchedule_selLoc").selectmenu('refresh',true); 
    $("#frmViewRoomSchedule_selRoom").selectmenu('refresh',true); 
    $("#frmViewRoomSchedule_selLoc").off("blur");

    // on blur event
    $("#frmViewRoomSchedule_selLoc").on("blur", function(){
      $.ajax(
      {
        Type: "POST",
        contentType: "application/json",
        url: "api_CRB_GetRooms.asp?callback=?",
        data: { 
          'txtParam1': Z_GetMe(), 
          'txtParam2': Z_GetToken(),
          'txtParamcLocation': $("#frmViewRoomSchedule_selLoc").val(),
          'txtParamcFlagVC': 'X',
          'txtParamcFlagProjector': 'X',
          'txtParamnSeats': 1
        },
        success: function(rv) {
          var o = jQuery.parseJSON(rv);
          if(o.bIsError)
          {
            alert("Unable to get rooms: " + o.cErrorMessage);
          }
          else
          {
            var ji;
            var jOutput = '';
            jOutput += "<option value=''>(Choose One)</option>";
            for(ji=0; ji < o.nRooms; ji++)
            {
              jOutput += "<option value='" + o.aRooms[ji].cRoom + "'>" + o.aRooms[ji].cName + "</option>";
            }
            $("#frmViewRoomSchedule_selRoom").html(jOutput);
            $("#frmViewRoomSchedule_selRoom").selectmenu('refresh',true); 
          }
        }
      }); //ajax call
    }); // on blur event of frmViewRoomSchedule_selLoc 

    $.ajax(
    {
      Type: "POST",
      contentType: "application/json",
      url: "api_CRB_GetLocations.asp?callback=?",
      data: { 'txtParam1': Z_GetMe(), 'txtParam2': Z_GetToken() },
      success: function(rv) {
        var o = jQuery.parseJSON(rv);
        if(o.bIsError)
        {
          alert("Unable to get locations: " + o.cErrorMessage);
        }
        else
        {
          var ji;
          var jOutput = '';
          jOutput += "<option value=''>(Choose One)</option>";
          for(ji=0; ji < o.nLocations; ji++)
          {
            jOutput += "<option value='" + o.aLocations[ji].cLocation + "'>" + o.aLocations[ji].cName + "</option>";
          }
          $("#frmViewRoomSchedule_selLoc").html(jOutput);
          $("#frmViewRoomSchedule_selLoc").attr('selectedindex',0);
          $("#frmViewRoomSchedule_selLoc").selectmenu('refresh',true);
        }
      }
     });    
  }); //viewRoomSchedule page

  //myViewResult Page
  $(document).on("pageshow", "#myViewResult", function(){
      myViewAction();
  }); //myViewResult page

  //Cancel Page
  $(document).on("pageshow", "#cancel", function(){
    var jscTemp = "" + $("#frmShowMeeting_Room").val();
    if(jscTemp === "") {
      window.location.href = "#home";
      return;
    }
    $.ajax(
    {
      Type: "POST",
      contentType: "application/json",
      url: "api_CRB_CancelABooking.asp?callback=?",
      data: { 
        'txtParam1': Z_GetMe(), 
        'txtParam2': Z_GetToken(),
        'txtParamcBookingID': $('#frmShowMeeting_BookingID').val()
      },
      success: function(rv) {
        var o = jQuery.parseJSON(rv);
        if(o.bIsError)
        {
          alert("Unable to cancel booking: " + o.cErrorMessage);
        }
        else
        {
          $("#cancelContent").html(o.cInfo);
          alert(o.cInfo);
          window.location.href = "#home";
        }
      }
     });    
  }); //cancel page

  //Reassign Page
  $(document).on("pageshow", "#reassign", function(){
    var jscTemp = "" + $("#frmShowMeeting_Room").val();
    if(jscTemp === "") {
      window.location.href = "#home";
      return;
    }
    $("#reassignContent h3.line1").html($("#frmShowMeeting_Room").val() + ": " + YyyyMmDd2DateStr($("#frmShowMeeting_Date").val(),'.'));
    $("#reassignContent h3.line2").html(HhMi2TimeStrAMPM($("#frmShowMeeting_FromTime").val()) + " to " + HhMi2TimeStrAMPM($("#frmShowMeeting_UptoTime").val()));
  }); //reassign page

  //Split Page
  $(document).on("pageshow", "#split", function(){
    var jscTemp = "" + $("#frmShowMeeting_Room").val();
    if(jscTemp === "") {
      window.location.href = "#home";
      return;
    }
    $("#splitContent h3.line1").html($("#frmShowMeeting_Room").val() + ": " + YyyyMmDd2DateStr($("#frmShowMeeting_Date").val(),'.'));
    $("#splitContent h3.line2").html(HhMi2TimeStrAMPM($("#frmShowMeeting_FromTime").val()) + " to " + HhMi2TimeStrAMPM($("#frmShowMeeting_UptoTime").val()));
  }); //reassign page

  //ShowMeeting Page
  $(document).on("pageshow", "#showMeeting", function(){
    var jscTemp = "" + $("#frmShowMeeting_Room").val();
    if(jscTemp === "") {
      window.location.href = "#home";
      return;
    }
  });

}); // document.ready

function doChange(newPage)
{
	$("body").pagecontainer("change", newPage, {transition: "slide"});
}

function frmLogin_try2Login()
{
	if(!ValidText(document.getElementById("frmLogin_txtUser"),6,10,false,"Please enter the user code",true)) {
		return;
	}
	if(!ValidText(document.getElementById("frmLogin_txtPassword"),1,20,false,"Please enter the password",true)) {
		return;
	}
  var jcUser    	= $('#frmLogin_txtUser').val(),
    	jcPassword  = $('#frmLogin_txtPassword').val();
  $.ajax(
  {
    Type: "POST",
    contentType: "application/json",
    url: "api_CRB_ValidateLogin.asp?callback=?",
    data: { 'txtParamcUser': jcUser, 'txtParamcPassword': jcPassword },
    success: function(rv) {
      var o = jQuery.parseJSON(rv);
      if(o.bIsError)
      {
        alert("Unable to login: " + o.cErrorMessage);
      }
      else
      {
        localStorage.cUser = jcUser;
        localStorage.cToken = o.cToken;
        //alert(localStorage.cUser + " ::: " + localStorage.cToken);
        //console.log(o.cSQL);
        window.location.href = "#home";
        //$("#frmLogin_GotoHome").click();
      }
    }
   });
}

function frmFind_try2Find()
{
  var jField;
  if($("#frmFind_selLoc").val().length < 1) {
    alert("Please choose a location");
    $("#frmFind_selLoc").focus();
    return;
  }
  
  if($('#frmFind_txtDate').val().length !== 10) {
    alert("Please enter a date");
    $("#frmFind_txtDate").focus();
    return;
  }

  if($("#frmFind_txtFromHh").val().length < 1)
  {
    alert("Please enter the from hour (00..23)");
    $("#frmFind_txtFromHh").focus();
    return;
  }

  if($("#frmFind_txtFromMi").val().length < 1)
  {
    alert("Please enter the from minutes (00,15,30,45)");
    $("#frmFind_txtFromMi").focus();
    return;
  }

  if($("#frmFind_txtUptoHh").val().length < 1)
  {
    alert("Please enter the upto hour (00..23)");
    $("#frmFind_txtUptoHh").focus();
    return;
  }

  if($("#frmFind_txtUptoMi").val().length < 1)
  {
    alert("Please enter the upto minutes (00,15,30,45)");
    $("#frmFind_txtUptoMi").focus();
    return;
  }

  if($("#frmFind_txtPerson").val().length < 1)
  {
    alert("Please enter the seating capacity needed (1..50)");
    $("#frmFind_txtPerson").focus();
    return;
  }
  window.location.href = "#findResult";
}

function frmBook_try2Book()
{
  var jField;
  if($("#frmBook_selLoc").val().length < 1) {
    alert("Please choose a location");
    $("#frmBook_selLoc").focus();
    return;
  }

  if($("#frmBook_selRoom").val().length < 1) {
    alert("Please choose a room");
    $("#frmBook_selRoom").focus();
    return;
  }
  
  if($('#frmBook_txtDate').val().length !== 10) {
    alert("Please enter a date");
    $("#frmBook_txtDate").focus();
    return;
  }

  if($("#frmBook_txtFromHh").val().length < 1)
  {
    alert("Please enter the from hour (00..23)");
    $("#frmBook_txtFromHh").focus();
    return;
  }

  if($("#frmBook_txtFromMi").val().length < 1)
  {
    alert("Please enter the from minutes (00,15,30,45)");
    $("#frmBook_txtFromMi").focus();
    return;
  }

  if($("#frmBook_txtUptoHh").val().length < 1)
  {
    alert("Please enter the upto hour (00..23)");
    $("#frmBook_txtUptoHh").focus();
    return;
  }

  if($("#frmBook_txtUptoMi").val().length < 1)
  {
    alert("Please enter the upto minutes (00,15,30,45)");
    $("#frmBook_txtUptoMi").focus();
    return;
  }

  try2Book(Z_GetMe(),$("#frmBook_selLoc").val(),$("#frmBook_selRoom").val(),YyyyDotMmDotDd2YyyyMmDd($("#frmBook_txtDate").val()),$("#frmBook_txtFromHh").val(),$("#frmBook_txtFromMi").val(),$("#frmBook_txtUptoHh").val(),$("#frmBook_txtUptoMi").val());
}


function try2Book(pcForWho,pcLocation, pcRoom, pcDate, pnFromHh, pnFromMi, pnUptoHh, pnUptoMi) {
  //alert("Trying to book a room: " + pcLocation + "/" + pcRoom + " on " + pcDate + " from " + ((pnFromHh*100) + pnFromMi) + " to " + ((pnUptoHh*100)+pnUptoMi));
  //return;
  var jcFromTime, jcUptoTime;
  var jcMessage;
  jcFromTime = Z_MakeTime(pnFromHh, pnFromMi);
  jcUptoTime = Z_MakeTime(pnUptoHh, pnUptoMi);
  jcMessage = 'Booking for Room <strong>' + pcRoom + '</strong> at <strong>' + pcLocation + '</strong> on <strong>' + YyyyMmDd2DateStr(pcDate, '.') + '</strong> from <strong>' + Z_HhMi2Time(jcFromTime) + '</strong> to <strong>' + Z_HhMi2Time(jcUptoTime) + '</strong>';
  $.ajax(
  {
    Type: "POST",
    contentType: "application/json",
    url: "api_CRB_BookARoom.asp?callback=?",
    data: { 
      'txtParam1': Z_GetMe(), 
      'txtParam2': Z_GetToken(),
      'txtParamcUser': pcForWho,
      'txtParamcLocation': pcLocation,
      'txtParamcRoom': pcRoom,
      'txtParamcDate': pcDate,
      'txtParamcFromTime': jcFromTime,
      'txtParamcUptoTime': jcUptoTime
    },
    success: function(rv) {
      var o = jQuery.parseJSON(rv);
      if(o.bIsError)
      {
        alert("Unable to book the room: " + o.cErrorMessage);
        var jcOutput = '<h2>Unable to book the room</h2><p>Reason: ' + o.cReason + '</p>';
        $("#bookResultContent").html(jcOutput);
      }
      else
      {
        var jcOutput = '<h2>Room Booking Successful!</h2><br/><p>Booking Id: ' + o.cBookingID + '</p>';
        jcOutput += '<br/><p>' + jcMessage + ' was successful!</p>';
        jcOutput += '<br/><a href="#home" class="ui-btn ui-btn-mini ui-corner-all">Continue</a>';
        $("#bookResultContent").html(jcOutput);
        window.location.href = "#bookResult";
      }
    }
   });
}

function frmReassign_try2Reassign()
{
  if(!ValidText(document.getElementById("frmReassign_ToUser"),6,10,false,"Please enter the user code",true)) {
    return;
  }
  var jcUser      = $('#frmReassign_ToUser').val();
  $.ajax(
  {
    Type: "POST",
    contentType: "application/json",
    url: "api_CRB_ReassignABooking.asp?callback=?",
    data: { 
      'txtParam1': Z_GetMe(), 
      'txtParam2': Z_GetToken(),
      'txtParamcBookingID': $("#frmShowMeeting_BookingID").val(),
      'txtParamcToUser': $('#frmReassign_ToUser').val()
    },
    success: function(rv) {
      var o = jQuery.parseJSON(rv);
      if(o.bIsError)
      {
        alert("Unable to reassign booking: " + o.cErrorMessage);
      }
      else
      {
        alert("Booking reassigned: " + o.cInfo);
        window.location.href = "#home";
      }
    }
   });
}

function frmSplit_try2Split() {
  if($("#frmSplit_txtSplitHh").val().length < 1)
  {
    alert("Please enter the split hour (00..23)");
    $("#frmSplit_txtSplitHh").focus();
    return;
  }

  if($("#frmSplit_txtSplitMi").val().length < 1)
  {
    alert("Please enter the split minutes (00,15,30,45)");
    $("#frmSplit_txtSplitMi").focus();
    return;
  }  

  var jscFromTime, jscUptoTime, jscSplitTime;
  jscFromTime = $("#frmShowMeeting_FromTime").val();
  jscUptoTime = $("#frmShowMeeting_UptoTime").val();
  jscSplitTime = Z_MakeTime(parseInt($("#frmSplit_txtSplitHh").val()), parseInt($("#frmSplit_txtSplitMi").val()));
  if(jscSplitTime <= jscFromTime) {
    alert("Please enter a split time that is between the start and end times of the meeting");
    return;
  }
  if(jscSplitTime > jscUptoTime) {
    alert("Please enter a split time that is between the start and end times of the meeting");
    return;
  }
  $.ajax(
  {
    Type: "POST",
    contentType: "application/json",
    url: "api_CRB_SplitABooking.asp?callback=?",
    data: { 
      'txtParam1': Z_GetMe(), 
      'txtParam2': Z_GetToken(),
      'txtParamcBookingID': $("#frmShowMeeting_BookingID").val(),
      'txtParamcSplitTime': jscSplitTime
    },
    success: function(rv) {
      var o = jQuery.parseJSON(rv);
      if(o.bIsError)
      {
        alert("Unable to split booking: " + o.cErrorMessage);
      }
      else
      {
        alert("Booking split: " + o.cInfo);
        window.location.href = "#home";
      }
    }
   });  
}
function viewARoomSchedule()
{
  var jField;
  if($("#frmViewRoomSchedule_selLoc").val().length < 1) {
    alert("Please choose a location");
    $("#frmViewRoomSchedule_selLoc").focus();
    return;
  }

  if($("#frmViewRoomSchedule_selRoom").val().length < 1) {
    alert("Please choose a room");
    $("#frmViewRoomSchedule_selRoom").focus();
    return;
  }
  
  if($('#frmViewRoomSchedule_txtDate').val().length !== 10) {
    alert("Please enter a date");
    $("#frmViewRoomSchedule_txtDate").focus();
    return;
  }
  $.ajax(
  {
    Type: "POST",
    contentType: "application/json",
    url: "api_CRB_ShowRoomSchedule.asp?callback=?",
    data: { 
      'txtParam1': Z_GetMe(), 
      'txtParam2': Z_GetToken(),
      'txtParamcLocation': $("#frmViewRoomSchedule_selLoc").val(),
      'txtParamcRoom': $("#frmViewRoomSchedule_selRoom").val(),
      'txtParamcDate': YyyyDotMmDotDd2YyyyMmDd($("#frmViewRoomSchedule_txtDate").val())
    },
    success: function(rv) {
      var o = jQuery.parseJSON(rv);
      if(o.bIsError)
      {
        alert("Unable to view the room schedule: " + o.cErrorMessage);
        var jcOutput = '<h3>Unable to view the room schedule</h3><p>Reason: ' + o.cErrorMessage + '</p>';
        $("#viewRoomScheduleResultContent").html(jcOutput);
        window.location.href = "#viewRoomScheduleResult";
      }
      else
      {
/*          var jcOutput = '<h3>' +$("#frmViewRoomSchedule_selLoc").val() + ':' + $("#frmViewRoomSchedule_selRoom").val() + '</h3>';
          jcOutput += '<h3>' + YyyyMmDd2DateStr(YyyyDotMmDotDd2YyyyMmDd($("#frmViewRoomSchedule_txtDate").val()),'.') + '</h3>';
*/
          var jcOutput = '<h3>';
          jcOutput+= $("#frmViewRoomSchedule_selLoc").val() + ':' + $("#frmViewRoomSchedule_selRoom").val();
          jcOutput += ' ' + YyyyMmDd2DateStr(YyyyDotMmDotDd2YyyyMmDd($("#frmViewRoomSchedule_txtDate").val()),'.');
          jcOutput += '</p>';

          if(o.nSlots < 1) {
            jcOutput += '<p>There are no bookings for the day.</p>';
          } else {
            jcOutput += '<ul data-role="listview" data-inset="true" class="ui-listview ui-listview-inset ui-corner-all ui-shadow">';
            
            for(ji=0; ji < o.nSlots; ji++) {
              jcOutput += '<li data-role="list-divider" role="heading" class="ul-li-divider ui-bar-inherit';
              if(ji === 0){
                jcOutput += ' ui-first-child';
              }
              jcOutput += '">';
              jcOutput += HhMi2TimeStrAMPM(o.aSlots[ji].cFromTime) + ' to ' + HhMi2TimeStrAMPM(o.aSlots[ji].cUptoTime);
              /*jcOutput += '<span class="ul-li-count">' + ji + '</span>';*/
              jcOutput += '</li>';
              jcOutput += '<li class="ul-li-static ui-body-inherit';
              if(ji === (o.nSlots - 1)) {
                jcOutput += ' ui-last-child';
              } 
              jcOutput += '">';
              jcOutput += '<p>Booked for: ' + o.aSlots[ji].cName + '.</p>';
              jcOutput += '</li>';
            }
          }
          jcOutput += '</ul>';
          $('#viewRoomScheduleResultContent').html(jcOutput); 
          $("#viewRoomScheduleResultContent").listview().listview("refresh");
          $("#viewRoomScheduleResultContent").listview().trigger("create");        
          //$("#viewRoomScheduleResultContent").html(jcOutput);
          window.location.href = "#viewRoomScheduleResult";
      }
    }
  });
}
function myViewAction() {
  if($('#frmMyView_txtDate').val().length !== 10) {
    alert("Please enter a date");
    $("#frmMyView_txtDate").focus();
    window.location.href = "#myView";
    return;
  }
  showMyBookings(YyyyDotMmDotDd2YyyyMmDd($("#frmMyView_txtDate").val()));
}
function showMyBookings(pcDate) {
  $.ajax(
  {
    Type: "POST",
    contentType: "application/json",
    url: "api_CRB_ShowMyBookings.asp?callback=?",
    data: { 
      'txtParam1': Z_GetMe(), 
      'txtParam2': Z_GetToken(),
      'txtParamcUser': Z_GetMe(),
      'txtParamcDate': pcDate
    },
    success: function(rv) {
      var o = jQuery.parseJSON(rv);
      if(o.bIsError)
      {
        alert("Unable to retrieve bookings for the date: " + o.cErrorMessage);
        var jcOutput = '<h3>Unable to retrieve bookings for the date.</h3><p>Reason: ' + o.cErrorMessage + '</p>';
        $("myViewResultContent").html(jcOutput);
        window.location.href = "#myViewResult";
      }
      else
      {
/*          var jcOutput = '<h3>' +$("#frmViewRoomSchedule_selLoc").val() + ':' + $("#frmViewRoomSchedule_selRoom").val() + '</h3>';
          jcOutput += '<h3>' + YyyyMmDd2DateStr(YyyyDotMmDotDd2YyyyMmDd($("#frmViewRoomSchedule_txtDate").val()),'.') + '</h3>';
*/
          var jcOutput = '<h3>';
          jcOutput += YyyyMmDd2DateStr(pcDate,".");
          jcOutput +' </h3>';

          if(o.nBookings < 1) {
            jcOutput += '<p>There are no bookings <strong>in your name</strong> for the above date.</p>';
          } else {

            jcOutput += '<ul data-role="listview" data-inset="true" class="ui-listview ui-listview-inset ui-corner-all ui-shadow">';
            
            for(ji=0; ji < o.nBookings; ji++) {
              jcOutput += '<li data-role="list-divider" role="heading" class="ul-li-divider ui-bar-inherit';
              if(ji === 0){
                jcOutput += ' ui-first-child';
              }
              jcOutput += '">';
              jcOutput += HhMi2TimeStrAMPM(o.aBookings[ji].cFromTime) + ' to ' + HhMi2TimeStrAMPM(o.aBookings[ji].cUptoTime);
              /*jcOutput += '<span class="ul-li-count">' + ji + '</span>';*/
              jcOutput += '</li>';
              jcOutput += '<li class="ul-li-static ui-body-inherit';
              if(ji === (o.nBookings - 1)) {
                jcOutput += ' ui-last-child';
              } 
              jcOutput += '">';
              jcOutput += '<a href="#" onclick="showMeeting(\'' + o.aBookings[ji].cBookingID + '\',\'' + o.aBookings[ji].cLocation + '\',\'' + o.aBookings[ji].cRoom + '\',\'' + o.aBookings[ji].cDate + '\',\'' + o.aBookings[ji].cFromTime + '\',\'' + o.aBookings[ji].cUptoTime + '\')">';
              jcOutput += '<p>Location : ' + o.aBookings[ji].cLocation + '.</p>';
              jcOutput += '<p>Room Name: ' + o.aBookings[ji].cRoomName + '.</p>';
              jcOutput += '</a>';
              jcOutput += '</li>';
            }
            jcOutput += '</ul>';
        }
          
        $('#myViewResultContent').html(jcOutput); 
        $("#myViewResultContent").listview().listview("refresh");
        $("#myViewResultContent").listview().trigger("create"); 
        window.location.href = "#myViewResult";
      }
    }
  });  
}
function showMeeting(pcBookingID, pcLocation, pcRoom, pcDate, pcFromTime, pcUptoTime) {
  //alert(pcBookingID);
  $("#frmShowMeeting_BookingID").val(pcBookingID);
  $("#frmShowMeeting_Location").val(pcLocation);
  $("#frmShowMeeting_Room").val(pcRoom);
  $("#frmShowMeeting_Date").val(pcDate);
  $("#frmShowMeeting_FromTime").val(pcFromTime);
  $("#frmShowMeeting_UptoTime").val(pcUptoTime);
  $("#showMeeting h3.line2").html(Z_HhMi2TimeAMPM(pcFromTime) + " to " + Z_HhMi2TimeAMPM(pcUptoTime));
  $("#showMeeting h3.line1").html(pcRoom + ": " + YyyyMmDd2DateStr(pcDate, "."));
  window.location.href="#showMeeting";
}
function logout() {
  var jscUser = Z_GetMe(), jscToken = Z_GetToken();
  localStorage.cUser = "";
  localStorage.cToken = "";
  $.ajax(
  {
    Type: "POST",
    contentType: "application/json",
    url: "api_CRB_Logout.asp?callback=?",
    data: { 'txtParam1': jscUser, 'txtParam2': jscToken },
    success: function(rv) {
      var o = jQuery.parseJSON(rv);
      if(o.bIsError)
      {
        alert("Unable to logout: " + o.cErrorMessage);
        window.location.href = "#login";
      }
      else
      {
        window.location.href = "#login";
      }
    }
  });      
}
function Z_GetMe()
{
  return localStorage.cUser;
}
function Z_GetToken()
{
  return localStorage.cToken;
}
function Z_MakeTime(pnHh, pnMi){
  var jcTime = "";
  pnHh = parseInt(pnHh);
  pnMi = parseInt(pnMi);
  if(pnHh < 10)
  {
    jcTime += "0";
  }
  jcTime += "" + pnHh;
  if(pnMi < 10) {
    jcTime += "0";
  }
  jcTime += "" + pnMi;
  return jcTime;
}
function Z_HhMi2Time(pcHhMi) {
  return pcHhMi.substring(0,2) + ':' + pcHhMi.substring(2,4);
}
function Z_HhMi2TimeAMPM(pcHhMi) {
  var jcTime, jnHh, jcPrefix = " A.M.", jcHh;
  jcTime = Z_HhMi2Time(pcHhMi);
  jnHh = parseInt(jcTime.substring(0,2));
  if(jnHh >= 12) {
    jcPrefix = " P.M.";
    jnHh -= 12;
  }
  if(jnHh < 1) {
    jnHh = 12;
  }
  jcHh = "";
  if(jnHh < 9) {
    jcHh = "0";
  }
  jcHh = jcHh + jnHh;
  return jcHh + ":" + jcTime.substring(3,5) + jcPrefix;
}
