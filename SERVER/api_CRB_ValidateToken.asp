<!--#include file="aspJSON1.16.asp"-->
<!--#include file="General.asp"-->
<!--#include file="CRBGeneral.asp"-->
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %>
<% Response.Expires = -1 %>
<%
Dim jConn, jRs, jSQL, oJSON, jbIsError, jcErrorMessage, jcWhere
Dim jcSysDate, jcSysTime
Dim jcLastActionDate, jcLastActionTime
Dim j1, j2
Dim jnCount
Dim jnTimeDiffInSeconds
j1 = GetPostParam("1")
j2 = GetPostParam("2")
jnCount = 0

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("ValidateToken")

'if not jbIsError then
''	if not ValidateToken(j1, j2) then
''		jbIsError = true
''		jcErrorMessage = "Invalid token. Please login once again."
''	end if
'end if
if not jbIsError then
	if not ValidateToken(j1,j2) then
		jbIsError = true
		jcErrorMessage	= "Token authentication failure. Login once again."
	end if
end if
if not jbIsError then
	set jConn = Connect2DB()
	set jRs = OpenRs(jConn)
	jRs.open "SELECT * FROM T_CRB_LOGIN_ATTEMPT WHERE cUser='" & j1 & "' AND cToken='" & j2 & "' AND cStatus='A'"
	if not IsNullRs(jRs) then
		jRs.movefirst
		if not jRs.eof then
			jcLastActionDate = GetX(jRs, "cLastActionDate")
			jcLastActionTime = GetX(jRs, "cLastActionTime")
		end if
	end if
	CloseRs(jRs)
	DisconnectDB(jConn)
	jnTimeDiffInSeconds = GetTimeDiffInSeconds(jcLastActionDate, jcLastActionTime, jcSysDate, jcSysTime)
	if jnTimeDiffInSeconds > (15*60) then
		jbIsError = true
		jcErrorMessage = "Your session has timed out. Please try again."
	else
		jSQL = "UPDATE T_CRB_LOGIN_ATTEMPT SET cLastActionDate='" & jcSysDate & "', cLastActionTime='" & jcSysTime & "'" & _
			" WHERE cUser='" & j1 & "' AND cToken='" & j2 & "' AND cStatus='A'"
		ExecSQL jSQL
	end if
end if
oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
if jbIsError then
	oJSON.data("cInfo") = "Error: " & jcErrorMessage
else
	oJSON.data("cInfo") = "Token authenticated."
end if
response.write oJSON.JSONoutput()
%>