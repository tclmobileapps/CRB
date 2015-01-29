<%
function Boolean2YesNo(pbValue)
	Boolean2YesNo = "N"
	if pbValue then
		Boolean2YesNo = "Y"
	end if
end function

function CloseRs(pRs)
	pRs.close
	set pRs = nothing
end function

function Connect2DB()
	Dim jConn
	Dim jCStr
	on error resume next
	set jConn=Server.CreateObject("ADODB.Connection")
	jCStr = "DSN=CRB;"
	jConn.open jCStr
	'response.write "Hello" & Err.Description & "/" & Err.Number
	set Connect2DB = jConn
end function

function Convert2Key(pcIn, pbIncludeDigits)
	Convert2Key = ""
	Dim jcIn, jnLen, ji, jc
	Dim jRv
	jRV = ""
	jcIn = UCase(trim("" & pcIn))
	jnLen = len(jcIn)
	for ji = 1 to jnLen
		jc = mid(jcIn, ji, 1)
		if (jc >= "A") and (jc <= "Z") then
			jRV = jRv & jc
		end if
		if (jc >= "0") and (jc <= "9") and (pbIncludeDigits) then
			jRV = jRv & jc
		end if
	next
	Convert2Key = jRv
end function
function DdDashMmDashYyyy2YyyyMmDd(pcIn)
	DdDashMmDashYyyy2YyyyMmDd = ""
	Dim jcIn	
	if len(pcIn) = 10 then
		jcIn = mid(pcin, 7, 4) & mid(pcin, 4, 2) & mid(pcIn, 1, 2) 
		DdDashMmDashYyyy2YyyyMmDd = jcIn
	end if
end function
sub DisconnectDB(pConn)
	on error resume next
	pConn.close
	set pConn = nothing
end sub

sub Exec(pSQL)
	Dim jRv
	jRv = ExecuteXns(pSQL)
end sub

sub ExecSQL(pSQL)
	Dim jRv
	jRv = ExecuteXns(pSQL)
end sub

function ExecuteXns(pSQL)
	Dim jSQL
	on error resume next
	err.clear
	jSQL = pSQL
	ExecuteXns = false
	Dim jCmd
	Dim jConn
	set jConn = Connect2DB()
	set jCmd = Server.CreateObject("ADODB.Command")
	set jCmd.ActiveConnection = jConn
	jCmd.CommandText = jSQL
	jCmd.Execute jSQL
	if err.number <> 0 then
		response.write "Error: " & err.number & "<br/>Description: " & err.description & "<br/>SQL: " & pSQL
		response.end
	end if
	jCmd.CommandText = ""
	set jCmd = nothing
	DisconnectDB(jConn)
	ExecuteXns = true
end function

function GetCount(pTable, pWhere)
	Dim jConn
	GetCount = 0
	set jConn = Connect2DB()
	Dim jRs
	'set jRs = Server.CreateObject("ADODB.Recordset")
	'jRs.ActiveConnection = jConn
	set jRs = OpenRs(jConn)
	Dim jSQL
	jSQL = "SELECT COUNT(1) as nCount FROM " & pTable & _
		" WHERE " & pWhere
	jRs.open jSQL
	if NullRs(jRs) = "N" then
		GetCount = cLng(jRs("nCount"))
	end if
	'jRs.close
	'set jRs = nothing	
	CloseRs(jRs)
	DisconnectDB(jConn)
end function

function GetD(pRs, pField)
	GetD = cDbl("0" & pRs(pField))
end function

Function GetDaysBetween(pcYyyyMmDd1,pcYyyyMmDd2) 
    GetDaysBetween = 0
    Dim jcDate1, jcDate2
    Dim jcDate 
    if len(pcYyyyMmDd1) <> 8 or len(pcYyyyMmDd2) <> 8 then
    	exit function
    end if
    jcDate1 = YyyyMmDd2Date(pcYyyyMmDd1)
    jcDate2 = YyyyMmDd2Date(pcYyyyMmDd2)

    If jcDate1 < jcDate2 Then
        jcDate = jcDate1
        jcDate1 = jcDate2
        jcDate2 = jcDate
    End If
    Dim jnDays 
    jnDays = jcDate1 - jcDate2
    GetDaysBetween = jnDays
End Function

Function GetGuid() 
    Set TypeLib = CreateObject("Scriptlet.TypeLib") 
    GetGuid = Left(CStr(TypeLib.Guid), 38) 
    Set TypeLib = Nothing 
End Function 

function GetIP()
	GetIP = ""
	Dim jcIP
	jcIP = ""
	jcIP = "" & Request.ServerVariables("HTTP_X_FORWARDED_FOR")
	if jcIP = "" then
		jcIP = Request.ServerVariables("REMOTE_ADDR")
	end if
	jcIP = trim(jcIP)
	if jcIP = "::1" then
		jcIP = Request.ServerVariables("REMOTE_HOST")
	end if
	GetIP = jcIP
end function

function GetLastDdOfMonth(pcYyyyMm)
	GetLastDdOfMonth = 30
	Dim jcYyyyMm, jnMm, jnYyyy
	jcYyyyMm = mid(trim(pcYyyyMm), 1, 6)
	jnYyyy = cInt(mid(jcYyyyMm, 1, 4))
	jnMm = cInt(mid(jcYyyyMm, 5, 2))
	if (jnMm = 1) or (jnMm = 3) or (jnMm = 5) or (jnMm = 7) or (jnMm = 8) or (jnMm = 10) or (jnMm = 12) then
		GetLastDdOfMonth = 31
	end if
	if jnMm = 2 then
		GetLastDdOfMonth = 28
		if IsLeapYear("" & jnYyyy) then
			GetLastDdOfMonth = 29
		end if
	end if
end function

function GetN(pRs, pField)
	GetN = cLng("0" & pRs(pField))
end function

function GetNextYyyyMm(pcYyyyMm)
	GetNextYyyyMm = ""
	Dim jnYyyy, jnMm
	jnYyyy = cInt(mid(pcYyyyMm, 1, 4))
	jnMm = cInt(mid(pcYyyyMm, 5, 2)) + 1
	if jnMm > 12 then
		jnMm = 1
		jnYyyy = jnYyyy + 1
	end if
	GetNextYyyyMm = "" & jnYyyy & "" & LPad(jnMm, 2, "0")
end function

function GetMonthName(pcYyyyMm)
	GetMonthName = ""
	if len(pcYyyyMm) < 6 then
		exit function
	end if
	Dim jcMon
	jcMon = ""
	if mid(pcYyyyMm,5,2) = "01" then
		jcMon = "Jan"
	end if
	if mid(pcYyyyMm,5,2) = "02" then
		jcMon = "Feb"
	end if
	if mid(pcYyyyMm,5,2) = "03" then
		jcMon = "Mar"
	end if
	if mid(pcYyyyMm,5,2) = "04" then
		jcMon = "Apr"
	end if
	if mid(pcYyyyMm,5,2) = "05" then
		jcMon = "May"
	end if
	if mid(pcYyyyMm,5,2) = "06" then
		jcMon = "Jun"
	end if
	if mid(pcYyyyMm,5,2) = "07" then
		jcMon = "Jul"
	end if
	if mid(pcYyyyMm,5,2) = "08" then
		jcMon = "Aug"
	end if
	if mid(pcYyyyMm,5,2) = "09" then
		jcMon = "Sep"
	end if
	if mid(pcYyyyMm,5,2) = "10" then
		jcMon = "Oct"
	end if
	if mid(pcYyyyMm,5,2) = "11" then
		jcMon = "Nov"
	end if
	if mid(pcYyyyMm,5,2) = "12" then
		jcMon = "Dec"
	end if
	GetMonthName = jcMon & "-" & mid(pcYyyyMm, 1, 4)
end function

function GetParamDelim()
	GetParamDelim = "~~~~"
end function

function GetSingleN(pTable, pField, pWhere)
	GetSingleN = 0
	on error resume next
	err.clear
	Dim jConn
	set jConn = Connect2DB()
	Dim jSQL
	jSQL = "SELECT " & pField & " AS nOut FROM " & pTable & " WHERE " & pWhere
	Dim jRs
	set jRs = OpenRs(jConn)
	jRs.open jSQL
	if NullRs(jRs) = "N" then
		GetSingleN = cDbl(jRs("nOut"))
	end if
	CloseRs(jRs)
	DisconnectDB(jConn)
end function

function GetSingleX(pTable, pField, pWhere)
	GetSingleX = ""
	on error resume next
	err.clear
	Dim jConn
	set jConn = Connect2DB()
	Dim jSQL
	jSQL = "SELECT " & pField & " AS pX FROM " & pTable & " WHERE " & pWhere
	Dim jRs
	set jRs = OpenRs(jConn)
	jRs.open jSQL
	if NullRs(jRs) = "N" then
		GetSingleX = jRs("pX")
	end if
	CloseRs(jRs)
	DisconnectDB(jConn)
end function

function GetSingleD(pTable, pField, pWhere)
	GetSingleD = ""
	Dim jDate
	on error resume next
	err.clear
	Dim jConn
	set jConn = Connect2DB()
	Dim jSQL
	'jSQL = "SELECT " & format(pField,"yyyymmdd") & " FROM " & pTable & " WHERE " & pWhere
	jSQL = "SELECT " & pField & " AS dDate FROM " & pTable & " WHERE " & pWhere
	Dim jRs
	set jRs = OpenRs(jConn)
	jRs.open jSQL
	if NullRs(jRs) = "N" then
		jDate = CDate(jRs("dDate"))
	end if
	CloseRs(jRs)
	DisconnectDB(jConn)
	GetSingleD = Year(jDate) & LPad(Month(jDate),2,"0") & LPad(Day(jDate),2,"0")
end function


sub GetSysDateTime(pDate, pTime)
	pDate = "00000000"
	pTime = "000000"
	Dim jDate
	jDate = now()
	pDate = Year(jDate)
	if Month(jDate) < 10 then
		pDate = pDate & "0"
	end if
	pDate = pDate & Month(jDate)
	if Day(jDate) < 10 then
		pDate = pDate & "0"
	end if
	pDate = pDate & Day(jDate)
	pTime = LPad("" & Hour(jDate), 2, "0") & LPad("" & Minute(jDate), 2, "0") & LPad("" & Second(jDate), 2, "0")
	'Dim jConn, jRs, jSQL
	'jSQL = "SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') AS cDate, TO_CHAR(SYSDATE, 'HH24MISS') as cTime FROM DUAL"
	'set jConn = Connect2DB()
	'set jRs   = OpenRs(jConn)
	'jRs.open jSQL
	'if not IsNullRs(jRs) then
	'	jRs.movefirst
	'	pDate = getStr(jRs, "cDate")
	'	pTime = GetStr(jRs, "cTime")
	'end if
	'CloseRs(jRs)
	'DisconnectDB(jConn)
end sub

function GetX(pRs, pField)
  on error resume next
	GetX = replace(trim("" & pRs(pField)), vbcrlf, "<br>")
	if err.number <> 0 then
		response.write "Error: " & err.Description & "<br>"
		response.write "Error: " & err.Number & "<br>"
		response.write "Field: " & pField & "<br>"
		response.end
	end if
end function

function IsLeapYear(pcYyyy)
	IsLeapYear = false
	Dim jnYyyy
	jnYyyy = cInt(trim(pcYyyy))
	if (jnYyyy mod 4) = 0 then
		if (jnYyyy mod 100) <> 0 then
			IsLeapYear = true
		else
			if (jnYyyy mod 400) = 0 then
				IsLeapYear = true	
			end if
		end if
	end if
end function

function IsNullRs(pRs)
	IsNullRs = true
	if NullRs(pRs) = "N" then
		IsNulLRs = false
	end if
end function

function LPad(pStr, pWidth, pPadChar)
	Dim jIn, jOut
	Dim jLen, ji
	jOut = ""
	jIn = trim("" & pStr)
	jLen = len(jIn)
	if jLen >= pWidth then
		LPad = jIn
		exit function
	end if
	jOut = jIn
	while(jLen < pWidth)
		jOut = pPadChar & jOut
		jLen = jLen + 1
	wend
	LPad = jOut
end function

function MakeCodeStr(pcStr)
	MakeCodeStr = ""
	Dim jCStr, jnLen, ji, jChar
	Dim jcRV
	jcRV = ""
	jcStr = ucase(trim("" & pcStr))
	jnLen = len(jcStr)
	for ji = 1 to jnLen
		jChar = mid(jcStr, ji, 1)
		if( ((jChar >= "A") and (jChar <= "Z")) or ((jChar >= "0") and (jChar <= "9")) ) then
			jcRV = jcRV & jChar
		end if
	next
	MakeCodeStr = jcRV
end function

function MakeInsX(pStrVal)
	'Convert string for value to insert
	MakeInsX = MakeStr(pStrVal)
end function

function MakeInsL(pNumVal)
	MakeInsL = cLng("0" & pNumVal)
end function

function MakeInsN(pNumVal)
	MakeInsN = cDbl("0" & pNumVal)
end function

function MakeNum(pNumVal)
	MakeNum = null
	MakeNum = "" & pNumVal
end function

function MakeStr(pStrVal)
	MakeStr = "null"
	Dim jVal 
	Dim ji, jLen
	Dim jOut, jChar
	jVal = trim("" & pStrVal)
	jLen = len(jVal)
	jOut = ""
	if jLen > 0 then
		ji = 1
		while(ji <= jLen)
			jChar = mid(jVal, ji, 1)
			if jChar = "'" then
				jChar = "''"
			end if
			jOut = jOut & jChar
			ji = ji + 1
		wend
		jOut = chr(39) & jOut & chr(39)
		MakeStr = jOut
	end if
end function

function MakeTD(pcData)
	MakeTD = "&nbsp;"
	if len(trim(pcData)) > 0 then
		MakeTD = "" & trim(pcData) & ""
	end if
end function
function MakeUpdX(pStrVal)
	'Convert string for value to update
	MakeUpdX = MakeStr(pStrVal)
end function

function MakeUpdN(pNumVal)
	MakeUpdN = cDbl("0" & pNumVal)
end function

function MakeOptionHtml(pcCode, pcDesc, pcDefault)
	MakeOptionHtml = ""
	Dim jSelected, jRV
	jSelected = ""
	if pcDefault = pcCode then
		jSelected = " selected"
	end if
	jRV = "<option value='" & pcCode & "'" & jSelected & ">" & pcDesc & "</option>"
	MakeOptionHtml = jRV
end function

function MakeYesNoHtml(pcYesDesc, pcNoDesc, pcDefault)
	MakeYesNoHtml = ""
	Dim jRV, jSelected
	jRV = ""
	jSelected = ""
	if pcDefault = "Y" then
		jSelected = " selected"
	end if
	jRV = jRV & "<option value='Y'" & jSelected & ">" & pcYesDesc & "</option>"
	jSelected = ""
	if pcDefault = "N" then
		jSelected = " selected"
	end if
	jRV = jRV & "<option value='N'" & jSelected & ">" & pcNoDesc & "</option>"
	MakeYesNoHtml = jRV
end function

Function Mm2Mon(pnMm) 
    Mm2Mon = ""
    If pnMm = 1 Then
        Mm2Mon = "JAN"
        Exit Function
    End If
    If pnMm = 2 Then
        Mm2Mon = "FEB"
        Exit Function
    End If
    If pnMm = 3 Then
        Mm2Mon = "MAR"
        Exit Function
    End If
    If pnMm = 4 Then
        Mm2Mon = "APR"
        Exit Function
    End If
    If pnMm = 5 Then
        Mm2Mon = "MAY"
        Exit Function
    End If
    If pnMm = 6 Then
        Mm2Mon = "JUN"
        Exit Function
    End If
    If pnMm = 7 Then
        Mm2Mon = "JUL"
        Exit Function
    End If
    If pnMm = 8 Then
        Mm2Mon = "AUG"
        Exit Function
    End If
    If pnMm = 9 Then
        Mm2Mon = "SEP"
        Exit Function
    End If
    If pnMm = 10 Then
        Mm2Mon = "OCT"
        Exit Function
    End If
    If pnMm = 11 Then
        Mm2Mon = "NOV"
        Exit Function
    End If
    If pnMm = 12 Then
        Mm2Mon = "DEC"
        Exit Function
    End If
End Function

function NullRs(pRs)
	NullRs = "Y"
	if pRs.eof and pRs.bof then
		NullRs = "Y"
	else
		NullRs = "N"
	end if
end function

function OpenRs(pConn)
	set OpenRs = nothing
	Dim jRs
	set jRs = Server.CreateObject("ADODB.Recordset")
	jRs.ActiveConnection = pConn
	set OpenRs = jRs
end function

function RPad(pStr, pWidth, pPadChar)
	Dim jIn, jOut
	Dim jLen, ji
	jOut = ""
	jIn = trim("" & pStr)
	jLen = len(jIn)
	if jLen >= pWidth then
		RPad = jIn
		exit function
	end if
	jOut = jIn
	while(jLen < pWidth)
		jOut = jOut & pPadChar
		jLen = jLen + 1
	wend
	RPad = jOut
end function

Function YyyyMmDd2Date(pcYyyyMmDd) 
    Dim jcDd, jcMm, jcYyyy
    Dim jDd, jMm, jYyyy
    Dim jMon 
    Dim jLen 
    pcYyyyMmDd = Trim(pcYyyyMmDd)
    jLen = Len(pcYyyyMmDd)
    If (jLen <> 8) Then
        Exit Function
    End If
    
    jcDd = Mid(pcYyyyMmDd, 7, 2)
    jcMm = Mid(pcYyyyMmDd, 5, 2)
    jcYyyy = Mid(pcYyyyMmDd, 1, 4)
    If IsNumeric(jcDd) Then
        jDd = CInt(jcDd)
        If jDd < 1 Or jDd > 31 Then
            Exit Function
        End If
    End If
    If IsNumeric(jcMm) Then
        jMm = CInt(jcMm)
        If jMm < 1 Or jMm > 12 Then
            Exit Function
        End If
    End If
    If IsNumeric(jcYyyy) Then
        jYyyy = CInt(jcYyyy)
        If jYyyy < 2000 Then
            Exit Function
        End If
    End If
    jMon = Mm2Mon(jMm)
    YyyyMmDd2Date = DateValue(jMon & " " & jDd & ", " & jYyyy)
End Function

function YyyyMmDd2DateStr(pcYyyyMmDd)
	YyyyMmDd2DateStr = ""
	if len(pcYyyyMmDd) = 8 then
		YyyyMmDd2DateStr = mid(pcYyyyMmDd,7,2) & "." & mid(pcYyyyMmDd,5,2) & "." & mid(pcYyyyMmDd,1,4)
	end if
end function

function YyyyMmDd2MonthNoFy(pcYyyyMmDd)
	YyyyMmDd2MonthNoFy = 0
	
	if len(pcYyyyMmDd) <> 8 then
		exit function
	end if
	Dim jcMm, jnMm
	jcMm = mid(pcYyyyMmDd, 5, 2)
	if (jcMm < "01") or (jcMm > "12") then
		exit function
	end if
	jnMm = cint(jcMm)
	if jnMm >= 4 then
		jnMm = jnMm	- 3
	else
		jnMm = jnMm + 9
	end if

	YyyyMmDd2MonthNoFy = jnMm
end function

function GetTimeDiffInSeconds(pcFromDate, pcFromTime, pcUptoDate, pcUptoTime)
  GetTimeDiffInSeconds = 99999
  Dim jnHh1, jnMi1, jnSs1, jnVal1
  Dim jnHh2, jnMi2, jnSs2, jnVal2
  if pcFromDate = pcUptoDate then
  	jnHh1 = mid(pcFromTime, 1, 2)
  	jnMi1 = mid(pcFromTime, 3, 2)
  	jnSs1 = mid(pcFromTime, 5, 2)
  	jnHh2 = mid(pcUptoTime, 1, 2)
  	jnMi2 = mid(pcUptoTime, 3, 2)
  	jnSs2 = mid(pcUptoTime, 5, 2)
  	jnVal1 = (jnHh1 * 3600) + (jnMi1 * 60) + (jnSs1)
  	jnVal2 = (jnHh2 * 3600) + (jnMi2 * 60) + (jnSs2)
  	GetTimeDiffInSeconds = abs(jnVal2 - jnVal1)
  end if
end function
%>