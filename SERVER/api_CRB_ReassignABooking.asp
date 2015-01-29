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
Dim jcBookingID, jcToUser, jcToUserName
Dim jcLocation, jcRoom, jcDate, jcFromTime, jcUptoTime

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jcBookingID = GetPostParam("cBookingID")
jcToUser = UCase(GetPostParam("cToUser"))
jcToUserName = GetUserName(jcToUser)

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("ReassignABooking")

if not jbIsError then
	if not ValidateToken(j1, j2) then
		jbIsError = true
		jcErrorMessage = "Invalid token. Please login once again."
	end if
end if
if not jbIsError then
	if not IsValidBooking(jcBookingID) then
		jbIsError = true
		jcErrorMessage = "Invalid Booking ID"
	end if
end if
if not jbIsError then
	if not IsMyBooking(jcBookingID, j1) then
		jbIsError = true
		jcErrorMessage = "You are not the owner of this booking ID"
	end if
end if
if not jbIsError then
	set jConn = Connect2DB()
	set jRs = OpenRs(jConn)
	jSQL = "SELECT * FROM T_CRB_BOOKING WHERE cBookingID='" & jcBookingID & "'"
	jRs.open jSQL
	if not IsNullRs(jRs) then
		jRs.movefirst
		if not jRs.eof then
			jcLocation = GetX(jRs, "cLocation")
			jcRoom = GetX(jRs, "cRoom")
			jcDate = GetX(jRs, "cDate")
			jcFromTime = GetX(jRs, "cFromTime")
			jcUptoTime = GetX(jRs, "cUptoTime")
		end if
	end if
	CloseRs(jRs)
	DisconnectDB(jConn)
end if
if not jbIsError then
	jSQL = "UPDATE T_CRB_BOOKING SET cUser='" & jcToUser & "'" & _
		", cLastUpdateUser='" & j1 & "'" & _
		", cLastUpdateDate='" & jcSysDate & "'" & _
		", cLastUpdateTime='" & jcSysTime & "'" & _
		", cStatus='R'" & _
		", cUserName=" & MakeUpdX(jcToUserName) & _
		" WHERE cBookingID='" & jcBookingID & "'"
	ExecSQL jSQL
	oJSON.data("cInfo") = "Booking reassigned successfully!"
	oJSON.data("cInfo") = "Booking of '" & jcLocation & " room " & jcRoom & " for " & YyyyMmDd2DateStr(jcDate) & " from " & jcFromTime & " to " & jcUptoTime & "' has been reassigned to '" & jcToUserName & "'"
end if
oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
if jbIsError then
	oJSON.data("cInfo") = "Booking ID " & jcBookingID & " could not be reassigned."
end if
response.write oJSON.JSONoutput()
%>