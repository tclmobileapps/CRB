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
set oJSON = InitJSON("GetLocations")

if not jbIsError then
	if not ValidateToken(j1, j2) then
		jbIsError = true
		jcErrorMessage = "Invalid token. Please login once again."
	end if
end if
jnCount = 0
if not jbIsError then
	set jConn = Connect2DB()
	set jRs = OpenRs(jConn)
	jSQL = "SELECT * FROM T_CRB_LOCATION ORDER BY cName"
	jRs.open jSQL
	oJSON.data.add "aLocations", oJSON.Collection()
	if not IsNullRs(jRs) then
		jRs.movefirst
		while (not jRs.eof) 
			with oJSON.data("aLocations")
				.Add jnCount, oJSON.Collection()
				with .item(jnCount)
					.Add "cLocation", GetX(jRs, "cLocation")
					.Add "cName", GetX(jRs, "cName")
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
if not jbIsError then
	oJSON.data("cInfo") = "Number of Locations downloaded: " & jnCount & "."
	oJSON.data("nLocations") = jnCount
end if
response.write oJSON.JSONoutput()
%>