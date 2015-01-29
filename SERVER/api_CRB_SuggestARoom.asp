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
Dim jcLocation, jcDate, jcFromTime, jcUptoTime, jcNeedVC, jcNeedProjector, jnSeats
Dim jnCount
Dim jbIsAllowed

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jcLocation = trim(UCase(GetPostParam("cLocation")))
jcDate = GetPostParam("cDate")
jcFromTime = GetPostParam("cFromTime")
jcUptoTime = GetPostParam("cUptoTime")
jcNeedVC = trim(UCase(GetPostParam("cNeedVC")))
jcNeedProjector = trim(UCase(GetPostParam("cNeedProjector")))
jnSeats = cLng(GetPostParam("nSeats"))
jnCount = 0

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("SuggestARoom")

if not jbIsError then
	if not ValidateToken(j1, j2) then
		jbIsError = true
		jcErrorMessage = "Invalid token. Please login once again."
	end if
end if
if not jbIsError then
	set jConn = Connect2DB()
	set jRs = OpenRs(jConn)
	jSQL = "SELECT * FROM T_CRB_ROOM WHERE cLocation='" & jcLocation & "'"
	'if ((jcNeedVC = "Y") or (jcNeedVC = "N")) then
	if (jcNeedVC = "Y") then
		jSQL = jSQL & " AND cHasVC='" & jcNeedVC & "'"
	end if
	'if ((jcNeedProjector = "Y") or (jcNeedProjector = "N")) then
	if (jcNeedProjector = "Y") then
		jSQL = jSQL & " AND cHasProjector='" & jcNeedProjector & "'"
	end if
	if jnSeats > 0 then
		jSQL = jSQL & " AND nMaxSeats >= " & jnSeats
	end if
	jSQL = jSQL & " ORDER BY nSeats, cHasVC, cHasProjector, nMaxSeats"
	'oJSON.data("cSQL") = jSQL
	jRs.open jSQL
	oJSON.data.add "aRooms", oJSON.Collection()
	if not IsNullRs(jRs) then
		jRs.movefirst
		while (not jRs.eof) 
			if IsRoomAvailable(jcLocation, GetX(jRs,"cRoom"), jcDate, jcFromTime, jcUptoTime) then
			    jbIsAllowed = (Getx(jRs, "cIsSpecial") = "N")
			    if not jbIsAllowed then
			    	jbIsAllowed = CanUserBookARoom(j1, jcLocation, GetX(jRs, "cRoom"))
			    end if
				if jbIsAllowed then
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
				end if
			end if
			jRs.movenext
		wend
	end if	
	CloseRs(jRs)
	DisconnectDB(jConn)	
end if

oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
if jbIsError then
	oJSON.data("cInfo") = "Error: " & jcErrorMessage
else
	oJSON.data("cInfo") = "Number of rooms available: " & jnCount
end if
oJSON.data("nRooms") = jnCount
response.write oJSON.JSONoutput()
%>