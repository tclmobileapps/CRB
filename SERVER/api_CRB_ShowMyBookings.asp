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
Dim jcUser, jcDate
Dim jnCount

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jcUser = GetPostParam("cUser")
jcDate = GetPostParam("cDate")
jnCount = 0

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("ShowMyBookings")

if not jbIsError then
	if not ValidateToken(j1, j2) then
		jbIsError = true
		jcErrorMessage = "Invalid token. Please login once again."
	end if
end if
if not jbIsError then
	set jConn = Connect2DB()
	set jRs = OpenRs(jConn)
	jSQL = "SELECT B.*, R.cName AS cRoomName" & _
		" FROM T_CRB_BOOKING B, T_CRB_ROOM R" & _
		" WHERE B.cDate='" & jcDate & "' AND B.cUser='" & jcUser & "' AND B.cStatus IN('A','R')" & _
		" AND R.cLocation=B.cLocation AND R.cRoom=B.cRoom" & _
		" ORDER BY B.cDate, B.cFromTime, B.cUptoTime"	
	jRs.open jSQL
	oJSON.data.add "aBookings", oJSON.Collection()
	if not IsNullRs(jRs) then
		jRs.movefirst
		while (not jRs.eof) 
			with oJSON.data("aBookings")
				.Add jnCount, oJSON.Collection()
				with .item(jnCount)
					.Add "cBookingID", GetX(jRs, "cBookingId")
					.Add "cLocation", GetX(jRs, "cLocation")
					.Add "cRoom", GetX(jRs, "cRoom")
					.Add "cDate", GetX(jRs, "cDate")
					.Add "cFromTime", GetX(jRs, "cFromTime")
					.Add "cUptoTime", GetX(jRs, "cUptoTime")
					.Add "cRoomName", GetX(jRs, "cRoomName")
				end with
			end with		
			jnCount = jnCount + 1
			
			jRs.movenext
		wend
	end if		
	CloseRs(jRs)
	DisconnectDB(jConn)		
end if
oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
oJSON.data("nBookings") = jnCount
if jbIsError then
	oJSON.data("cInfo") = "Error: " & jcErrorMessage
else
	oJSON.data("cInfo") = "Number of bookings for the date: " & jnCount
end if
response.write oJSON.JSONoutput()
%>