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

j1 = GetPostParam("1")
j2 = GetPostParam("2")

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("Logout")

if not jbIsError then
	if len(trim("" & j1)) > 0 then
		jSQL = "UPDATE T_CRB_LOGIN_ATTEMPT SET cStatus='C' WHERE cUser='" & j1 & "' AND cStatus='A'"
		ExecSQL jSQL
	end if
end if
oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage

'oJSON.data("cSQL") = jSQL
if jbIsError then
	oJSON.data("cInfo") = "Error: " & jcErrorMessage
else
	oJSON.data("cInfo") = "User " & jcUser & " has been logged out successfully."
end if
response.write oJSON.JSONoutput()
%>