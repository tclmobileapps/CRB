<!--#include file="aspJSON1.16.asp"-->
<!--#include file="General.asp"-->
<!--#include file="CRBGeneral.asp"-->
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %>
<% Response.Expires = -1 %>
<%
Dim jConn, jRs, jSQL, oJSON, jbIsError, jcErrorMessage, jcWhere
Dim jcSysDate, jcSysTime
'Dim j1, j2
Dim jcUser, jcPassword, jcGUID, jcWasSUccessful, jcStatus
Dim jnCount

'j1 = GetPostParam("1")
'j2 = GetPostParam("2")
jcUser = trim(UCase(GetPostParam("cUser")))
jcPassword = GetPostParam("cPassword")
jnCount = 0
jcGUID = ""
jcWasSUccessful = "N"
jcStatus = "X"

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("ValidateLogin")

'if not jbIsError then
''	if not ValidateToken(j1, j2) then
''		jbIsError = true
''		jcErrorMessage = "Invalid token. Please login once again."
''	end if
'end if
if not jbIsError then
	if (len(jcUser) < 6) or (len(jcUser) > 10) then
		jbIsError = true
		jcErrorMessage	= "User ID must be between 6 and 10 characters only."
	end if
end if
if not jbIsError then
	jcGUID = GetGUID()
	jcWasSUccessful = "Y"
	jcStatus = "A"
end if
jSQL = "UPDATE T_CRB_LOGIN_ATTEMPT SET cStatus='F' WHERE cUser='" & jcUser & "' AND cStatus='A'"
ExecSQL jSQL
jSQL = "INSERT INTO T_CRB_LOGIN_ATTEMPT(cUser, cDate, cTime" & _
	", cWasSuccessful, cToken, cStatus" & _
	") VALUES (" & _
	MakeInsX(jcUser) & "," & MakeInsX(jcSysDate) & "," & MakeInsX(jcSysTime) & _
	"," & MakeInsX(jcWasSuccessful) & "," & MakeInsX(jcGUID) & "," & MakeInsX(jcStatus) & _
	")"
ExecSQL jSQL
if jcWasSuccessful = "Y" then
	jSQL = "UPDATE T_CRB_LOGIN_ATTEMPT SET cLastActionDate='" & jcSysDate & "', cLastActionTime='" & jcSysTime & "' WHERE cUser='" & jcUser & "' AND cStatus='A'"
	ExecSQL jSQL
end if
oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
oJSON.data("cToken") = jcGUID 
'oJSON.data("cSQL") = jSQL
if jbIsError then
	oJSON.data("cInfo") = "Error: " & jcErrorMessage
else
	oJSON.data("cInfo") = "User " & jcUser & " has been logged in successfully. Token: " & jcGUID 
end if
response.write oJSON.JSONoutput()
%>