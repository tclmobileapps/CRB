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
Dim jcDate, jcLocation, jcRoom
Dim jnCount

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jcLocation = GetPostParam("cLocation")
jcRoom = GetPostParam("cRoom")
jcDate = GetPostParam("cDate")
jnCount = 0

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("ShowRoomSchedule")

if not jbIsError then
	if not ValidateToken(j1, j2) then
		jbIsError = true
		jcErrorMessage = "Invalid token. Please login once again."
	end if
end if
if not jbIsError then
	set jConn = Connect2DB()
	set jRs = OpenRs(jConn)
	jSQL = "SELECT * FROM T_CRB_BOOKING WHERE cLocation='" & jcLocation & "' AND cRoom='" & jcRoom & "' AND cDate='" & jcDate & "' AND cStatus IN('A','R')" & _
		" ORDER BY cFromTime, cUptoTime"
	jRs.open jSQL
	oJSON.data.add "aSlots", oJSON.Collection()
	if not IsNullRs(jRs) then
		jRs.movefirst
		while (not jRs.eof) 
			with oJSON.data("aSlots")
				.Add jnCount, oJSON.Collection()
				with .item(jnCount)
					.Add "cLocation", GetX(jRs, "cLocation")
					.Add "cRoom", GetX(jRs, "cRoom")
					.Add "cFromTime", GetX(jRs, "cFromTime")
					.Add "cUptoTime", GetX(jRs, "cUptoTime")
					.Add "cUser", GetX(jRs, "cUser")
					.Add "cName", GetX(jRs, "cUserName")
					.Add "cBookedByUser", GetX(jRs, "cLastUpdateUser")
					.Add "cBookedByUserName", GetX(jRs, "cLastUpdateUser")
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
oJSON.data("nSlots") = jnCount
if jbIsError then
	oJSON.data("cInfo") = "Error: " & jcErrorMessage
else
	oJSON.data("cInfo") = "Number of bookings for the date: " & jnCount
end if
response.write oJSON.JSONoutput()
%>