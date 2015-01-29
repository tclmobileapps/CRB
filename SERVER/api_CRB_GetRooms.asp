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
Dim jcLocation, jcFlagVC, jcFlagProjector, jnSeats

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jcLocation = GetPostParam("cLocation")
jcFlagVC = GetPostParam("cFlagVC")
jcFlagProjector = GetPostParam("cFlagProjector")
jnSeats = cLng("0" & GetPostParam("nSeats"))
GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("GetRooms")

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
	jSQL = "SELECT * FROM T_CRB_ROOM WHERE cLocation='" & jcLocation & "'"
	if (jcFlagVC = "Y") then 'or (jcFlagVC = "N") then
		jSQL = jSQL & " AND cHasVC='" & jcFlagVC & "'"
	end if
	if (jcFlagProjector = "Y") then 'or (jcFlagProjector = "N") then
		jSQL = jSQL & " AND cHasProjector='" & jcFlagProjector & "'"
	end if
	if jnSeats > 0 then
		jSQL = jSQL & " AND nMaxSeats >= " & jnSeats
	end if
	jSQL = jSQL & " ORDER BY cRoom"
	jRs.open jSQL
	oJSON.data.add "aRooms", oJSON.Collection()
	if not IsNullRs(jRs) then
		jRs.movefirst
		while (not jRs.eof) 
			with oJSON.data("aRooms")
				.Add jnCount, oJSON.Collection()
				with .item(jnCount)
					.Add "cLocation", GetX(jRs, "cLocation")
					.Add "cRoom", GetX(jRs, "cRoom")
					.Add "cName", GetX(jRs, "cName")
					.Add "cHasVC", GetX(jRs, "cHasVC")
					.Add "cHasProjector", GetX(jRs, "cHasProjector")
					.Add "cIsSpecial", GetX(jRs, "cIsSpecial")
					.Add "nSeats", GetN(jRs, "nSeats")
					.Add "nMaxSeats", GetN(jRs, "nMaxSeats")
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
	oJSON.data("cInfo") = "Number of Rooms: " & jnCount & "."
	oJSON.data("nRooms") = jnCount
end if
response.write oJSON.JSONoutput()
%>