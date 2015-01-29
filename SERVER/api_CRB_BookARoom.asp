<!--#include file="aspJSON1.16.asp"-->
<!--#include file="General.asp"-->
<!--#include file="CRBGeneral.asp"-->
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %>
<% Response.Expires = -1 %>
<%
Dim jConn, jRs, jSQL, oJSON, jbIsError, jcErrorMessage, jcWhere
Dim jcSysDate, jcSysTime
Dim j1, j2
Dim jnCount
Dim jcLocation, jcRoom, jcDate, jcFromTime, jcUptoTime, jcUser
Dim jcWasBooked, jcBookingID
Dim jcUserName

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jcUser = UCase(GetPostParam("cUser"))
jcLocation = UCase(GetPostParam("cLocation"))
jcRoom = UCase(GetPostParam("cRoom"))
jcDate = GetPostParam("cDate")
jcFromTime = GetPostParam("cFromTime")
jcUptoTime = GetPostParam("cUptoTime")
jcWasBooked = "N"
jcBookingID = ""
jcUserName = GetUserName(jcUser)

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("BookARoom")

if not jbIsError then
	if not ValidateToken(j1, j2) then
		jbIsError = true
		jcErrorMessage = "Invalid token. Please login once again."
	end if
end if
if not jbIsError then
	if not IsValidRoom(jcLocation, jcRoom) then
		jbIsError = true
		jcErrorMessage = "Invalid Location/Room specified."
	end if
end if
if not jbIsError then
	if jcUptoTime <= jcFromTime then
		jbIsError = true
		jcErrorMessage = "From time must be before Upto time."
	end if
end if
if not jbIsError then
	if not IsValidBookingTime(jcFromTime) then
		jbIsError = true
		jcErrorMessage = "Invalid From time. Must be at 15 minute boundaries."
	end if
end if
if not jbIsError then
	if not IsValidBookingTime(jcUptoTime) then
		jbIsError = true
		jcErrorMessage = "Invalid Upto time. Must be at 15 minute boundaries."
	end if
end if
if not jbIsError then
	if not CanUserBookARoom(j1, jcLocation, jcRoom) then
		jbIsError = false
		jcErrorMessage = "You are not authorized to book this room. Contact Admin."
	end if
end if
if not jbIsError then
	if IsRoomAvailable(jcLocation, jcRoom, jcDate, jcFromTime, jcUptoTime) then
		jcBookingID = MakeBookingID(j1, jcSysDate, jcSysTime)
		jSQL = "INSERT INTO T_CRB_BOOKING(" & _
			"cBookingID" & _
			", cLocation, cRoom, cDate, cFromTime, cUptoTime" & _
			", cUser, cUserName, cStatus" & _
			", cCreateUser, cCreateDate, cCreateTime" & _
			", cLastUpdateUser, cLastUpdateDate, cLastUpdateTime" & _
			") VALUES (" & _
			MakeInsX(jcBookingID) & _
			"," & MakeInsX(jcLocation) & "," & MakeInsX(jcRoom) & "," & MakeInsX(jcDate) & "," & MakeInsX(jcFromTime) & "," & MakeInsX(jcUptoTime) & _
			"," & MakeInsX(jcUser) & "," & MakeInsX(jcUserName) & "," & MakeInsX("A") & _
			"," & MakeInsX(j1) & "," & MakeInsX(jcSysDate) & "," & MakeInsX(jcSysTime) & _
			"," & MakeInsX(j1) & "," & MakeInsX(jcSysDate) & "," & MakeInsX(jcSysTime) & _
			")"
		ExecSQL jSQL
		jcWasBooked = "Y"
	else
		jbIsError = true
		jcErrorMessage = "The time slot of " & jcFromTime & " to " & jcUptoTime & " is not vacant for the requested room on " & YyyyMmDd2DateStr(jcDate) & "."
	end if
end if
oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
oJSON.data("cWasBooked") = jcWasBooked
if jbIsError then
	oJSON.data("cInfo") = "Booking Unsuccessful"
	oJSON.data("cBookingID") = ""
else
	oJSON.data("cInfo") = "Booking successful with Booking ID: " & jcBookingID
	oJSON.data("cBookingID") = jcBookingID
end if
response.write oJSON.JSONoutput()
%>