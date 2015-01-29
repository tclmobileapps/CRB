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
Dim jcBookingID, jcWasBookingCancelled

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jcBookingID = GetPostParam("cBookingID")
jcWasBookingCancelled = "N"

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("CancelABooking")

if not jbIsError then
	if not ValidateToken(j1, j2) then
		jbIsError = true
		jcErrorMessage = "Invalid token. Please login once again."
	end if
end if
if not jbIsError then
	if not IsValidBooking(jcBookingID) then
		jbIsError = true
		jcErrorMessage = "Incorrect Booking ID " & jcBookingID & "."
	end if
end if
if not jbIsError then
	if not IsActiveBooking(jcBookingID) then
		jbIsError = true
		jcErrorMessage = "Bookind ID " & jcBookingID & " is not Active."
	end if
end if
if not jbIsError then
	if not IsBookingHost(j1, jcBookingID) then
		jbIsError = true
		jcErrorMessage = "Not authorized to cancel Booking ID " & jcBookingID & "."
	end if
end if
if not jbIsError then
	if not CancelARoomBooking(j1, jcBookingID) then
		jbIsError = true
		jcErrorMessage = "Unable to cancel the room booking."
	end if
end if
if not jbIsError then
	jcWasBookingCancelled = "Y"
end if
oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
oJSON.data("cWasBookingCancelled") = jcWasBookingCancelled
if jbIsError then
	oJSON.data("cInfo") = "Booking ID " & jcBookingID & " could not be cancelled."
else
	oJSON.data("cInfo") = "Booking ID " & jcBookingID & " successfully cancelled."
	oJSON.data("cWasBookingCancelled") = "Y"
end if
response.write oJSON.JSONoutput()
%>