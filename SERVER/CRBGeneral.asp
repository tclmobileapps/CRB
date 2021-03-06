<%
function CancelARoomBooking(pcUser, pcBookingID)
	CancelARoomBooking = false
	Dim jcSysDate, jcSysTime, jSQL
	if GetCount("T_CRB_BOOKING", "cBookingID='" & pcBookingID & "'") <> 1 then
		exit function
	end if
	if GetCount("T_CRB_BOOKING", "cBookingID='" & pcBookingID & "' AND cStatus='A'") <> 1 then
		exit function
	end if
	if GetCount("T_CRB_BOOKING", "cBookingID='" & pcBookingID & "' AND ((cUser='" & pcUser & "') OR (cCreateUser='" & pcUser & "') OR (cLastUpdateUser='" & pcUser & "'))") <> 1 then
		exit function
	end if	
	GetSysDateTime jcSysDate, jcSysTime
	jSQL = "UPDATE T_CRB_BOOKING SET cStatus='C'" & _
		", cLastUpdateUser='" & pcUser & "'" & _
		", cLastUpdateDate='" & jcSysDate & "'" & _
		", cLastUpdateTime='" & jcSysTime & "'" & _
		" WHERE cBookingID='" & pcBookingID & "' AND cStatus='A'"
	ExecSQL jSQL
	CancelARoomBooking = true
end function

function CanUserBookARoom(pcUser, pcLocation, pcRoom)
	 CanUserBookARoom = false
	 if GetCount("T_CRB_ROOM", "cLocation='" & pcLocation & "' AND cRoom='" & pcRoom & "' AND cIsSpecial='N'") = 1 then
	 	CanUserBookARoom = true
	 	exit function
	 end if
	 'Special Room
	 if GetCount("T_CRB_SPECIAL", "cUser='" & pcUser & "' AND cLocation IS NULL AND cRoom IS NULL") = 1 then
	 	CanUserBookARoom = true
	 	exit function	 	
	 end if
	 if GetCount("T_CRB_SPECIAL", "cUser='" & pcUser & "' AND cLocation='" & pcLocation & "' AND cRoom IS NULL") = 1 then
	 	CanUserBookARoom = true
	 	exit function	 	
	 end if
	 if GetCount("T_CRB_SPECIAL", "cUser='" & pcUser & "' AND cLocation='" & pcLocation & "' AND cRoom='" & pcRoom & "'") = 1 then
	 	CanUserBookARoom = true
	 	exit function	 	
	 end if
end function

sub ClearDebugTables
	ExecSQL "DELETE FROM T_CRB_00"
end sub

function GetUserName(pcUser)
	GetUserName = "Name of " & pcUser
	if pcUser = "531953" then
		GetUserName = "Ajay Pherwani"
	end if
	if pcUser = "530104" then
		GetUserName = "Amar Sinhji"
	end if
end function

function GetMaxParams()
	GetMaxParams = 200
end function

function GetParamDelim()
	GetParamDelim = "~~~~"
end function

function GetPostParam(byval pcParamName)
	Dim jcParamName
	Dim x
	jcParamName = "txtParam" & pcParamName
	x = trim("" & request.form(jcParamName))
	if x = "" then
		x = trim("" & request(jcParamName))
	end if
	GetPostParam = x
end function

function InitJSON(pcApiName)
	Dim o
	set o = new aspJSON
	o.data("bIsError") = true
	o.data("cErrorMessage") = "Error in API: " & pcApiName
	o.data("cInfo") = ""
	set InitJSON = o
end function

function IsActiveBooking(pcBookingID)
	IsActiveBooking = false
	if GetCount("T_CRB_BOOKING", "cBookingID='" & pcBookingID & "' AND cStatus='A'") = 1 then
		IsActiveBooking = true
	end if
end function

function IsBookingHost(pcUser, pcBookingID)
	IsBookingHost = false
	if GetCount("T_CRB_BOOKING", "cBookingID='" & pcBookingID & "' AND ((cUser='" & pcUser & "') OR (cCreateUser='" & pcUser & "') OR (cLastUpdateUser='" & pcUser & "'))") = 1 then
		IsBookingHost = true
	end if
end function

function IsRoomAvailable(pcLocation, pcRoom, pcDate, pcFromTime, pcUptoTime)
	IsRoomAvailable = false
	if GetCount("T_CRB_BOOKING", "cLocation='" & pcLocation & "' AND cRoom='" & pcRoom & "' AND cDate='" & pcDate & "' AND cFromTime < '" & pcUptoTime & "' AND cUptoTime > '" & pcFromTime & "' AND cStatus='A'") = 0 then
		IsRoomAvailable = true
	end if
end function

function IsMyBooking(pcBookingID, pcMe)
	IsMyBooking = false
	if GetCount("T_CRB_BOOKING", "cBookingID='" & pcBookingID & "' AND cUser='" & pcMe & "'") = 1 then
		IsMyBooking = true
	end if
end function

function IsValidBooking(pcBookingID)
	IsValidBooking = false
	if GetCount("T_CRB_BOOKING", "cBookingID='" & pcBookingID & "'") = 1 then
		IsValidBooking = true
	end if
end function

function IsValidBookingTime(pcTime)
	IsValidBookingTime = false
	if len(pcTime) <> 4 then
		exit function
	end if
	Dim jcHh, jcMm 
	jcHh = mid(pcTime, 1, 2)
	jcMm = mid(pcTime, 3, 4)
	if not ((jcMm = "00") or (jcMm = "15") or (jcMm = "30") or (jcMm = "45")) then
		exit function
	end if
	if jcHh > 24 then
		exit function
	end if
	if not ((mid(jcHh, 1, 1) >= "0") and (mid(jcHh, 1, 1) <= "2")) then
		exit function
	end if
	if not ((mid(jcHh, 2, 1) >= "0") and (mid(jcHh, 2, 1) <= "9")) then
		exit function
	end if
	IsValidBookingTime = true
end function

function IsValidRoom(pcLocation, pcRoom)
	IsValidRoom = false
	if GetCount("T_CRB_ROOM", "cLocation='" & pcLocation & "' AND cRoom='" & pcRoom & "'") = 1 then
		IsValidRoom = true
	end if
end function

function MakeBookingID(pcUser, pcDate, pcTime)
	MakeBookingID = pcUser & pcDate & pcTime
end function

function ValidateToken(pcUser, pcToken)
	ValidateToken = false
	if GetCount("T_CRB_LOGIN_ATTEMPT", "cUser='" & pcUser & "' AND cToken='" & pcToken & "' AND cStatus='A'") <> 1 then
		exit function
	end if
	ValidateToken = true
end function
%>