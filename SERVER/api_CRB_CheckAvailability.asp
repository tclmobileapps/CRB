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
Dim jcLocation, jcRoom, jcDate, jcFromTime, jcUptoTime
Dim jcIsAvailable

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jcLocation = UCase(GetPostParam("cLocation"))
jcRoom = UCase(GetPostParam("cRoom"))
jcDate = GetPostParam("cDate")
jcFromTime = GetPostParam("cFromTime")
jcUptoTime = GetPostParam("cUptoTime")
jcIsAvailable = "N"

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("CheckAvailability")

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
jnCount = 0
if not jbIsError then
	if IsRoomAvailable(jcLocation, jcRoom, jcDate, jcFromTime, jcUptoTime) then
		jcIsAvailable = "Y"
	end if
end if
oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
oJSON.data("cIsAvailable") = jcIsAvailable
oJSON.data("cInfo") = "Availability of the room: " & jcIsAvailable
response.write oJSON.JSONoutput()
%>