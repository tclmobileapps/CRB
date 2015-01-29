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
Dim jcBookingID, jcSplitTime, jcBookingID2
Dim jcLocation, jcRoom, jcDate, jcFromTime, jcUptoTime, jcUser, jcUserName

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jcBookingID = GetPostParam("cBookingID")
jcSplitTime = UCase(GetPostParam("cSplitTime"))

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("SplitABooking")

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
			jcUser = GetX(jRs, "cUser")
			jcUserName = GetX(jRs, "cUserName")
		end if
	end if
	CloseRs(jRs)
	DisconnectDB(jConn)
end if
if not jbIsError then
	if( (jcSplitTime <= jcFromTime) or (jcSplitTime >= jcUptoTime) ) then
		jbIsError = true
		jcErrorMessage = "Incorrect split time. Must be between the from-time and upto-time."
	end if
end if
if not jbIsError then
	jcBookingID2 = MakeBookingID(j1, jcSysDate, jcSysTime)
	jSQL = "INSERT INTO T_CRB_BOOKING(" & _
		"cBookingID" & _
		", cLocation, cRoom, cDate, cFromTime, cUptoTime" & _
		", cUser, cUserName, cStatus" & _
		", cCreateUser, cCreateDate, cCreateTime" & _
		", cLastUpdateUser, cLastUpdateDate, cLastUpdateTime" & _
		") VALUES (" & _
		MakeInsX(jcBookingID2) & _
		"," & MakeInsX(jcLocation) & "," & MakeInsX(jcRoom) & "," & MakeInsX(jcDate) & "," & MakeInsX(jcSplitTime) & "," & MakeInsX(jcUptoTime) & _
		"," & MakeInsX(jcUser) & "," & MakeInsX(jcUserName) & "," & MakeInsX("A") & _
		"," & MakeInsX(j1) & "," & MakeInsX(jcSysDate) & "," & MakeInsX(jcSysTime) & _
		"," & MakeInsX(j1) & "," & MakeInsX(jcSysDate) & "," & MakeInsX(jcSysTime) & _
		")"
	ExecSQL jSQL

	jSQL = "UPDATE T_CRB_BOOKING SET cUptoTime='" & jcSplitTime & "'" & _
		", cLastUpdateUser='" & j1 & "'" & _
		", cLastUpdateDate='" & jcSysDate & "'" & _
		", cLastUpdateTime='" & jcSysTime & "'" & _
		", cUserName=" & MakeUpdX(jcUserName) & _
		" WHERE cBookingID='" & jcBookingID & "'"
	ExecSQL jSQL
	oJSON.data("cInfo") = "Booking split successfully!"
	oJSON.data("cInfo") = "Booking of '" & jcLocation & " room " & jcRoom & " for " & YyyyMmDd2DateStr(jcDate) & " from " & jcFromTime & " to " & jcUptoTime & "' has been split!"
end if
oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
if jbIsError then
	oJSON.data("cInfo") = "Booking ID " & jcBookingID & " could not be split."
end if
response.write oJSON.JSONoutput()
%>