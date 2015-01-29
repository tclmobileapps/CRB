function ValidText(pValue, pnMinLength, pnMaxLength, pbAllowNull, pcErrorMessage, pbSetFocusOnFailure)
{
	var jText = pValue.value.trim();
	var jLen = jText.length;
	var jLenErrorMessage = pcErrorMessage.trim().length;
	if( (jLen >= pnMinLength) && (jLen <= pnMaxLength) )
	{
		return true;
	}
	if( jLen == 0 )
	{
		if(!pbAllowNull)
		{
			if(jLenErrorMessage > 0)
			{
				alert(pcErrorMessage);
			}
			if(pbSetFocusOnFailure)
			{
				pValue.focus();
			}
		}
		return pbAllowNull;
	}
	if(jLenErrorMessage > 0)
	{
		alert(pcErrorMessage);
	}
	if(pbSetFocusOnFailure)
	{
		pValue.focus();
	}

	return false;
}

function ValidD(pN, pbAllowNull, pnMinDec, pnMaxDec, pcErrorMessage)
{
	var jLenErrorMessage = pcErrorMessage.trim().length;
	//var re = new RegExp("^[0-9]+(\.[0-9]{" + pnMinDec + "," + pnMaxDec + "})?$");
	//alert("^[0-9]+(\.[0-9]{" + pnMinDec + "," + pnMaxDec + "})?$");
	var re = new RegExp("^[0-9]+(\.[0-9]{" + pnMinDec + "," + pnMaxDec + "})?$");
	var jTest = "" + pN;
	if(re.test(jTest))
	{
		return true;
	}	
	var jLen = jTest.length;
	if(jLen < 1)
	{
		if(!pbAllowNull)
		{
			if(jLenErrorMessage > 0)
			{
				alert(pcErrorMessage);
			}
		}
		return pbAllowNull;		
	}
	alert(pcErrorMessage);
	return false;	
}

function ValidN(pN, pbAllowNull, pnMinLen, pnMaxLen, pcErrorMessage)
{
	var jLenErrorMessage = pcErrorMessage.trim().length;
	var re = new RegExp("^[0-9]{" + pnMinLen + "," + pnMaxLen + "}$");
	var jTest = "" + pN;
	if(re.test(jTest))
	{
		return true;
	}	
	var jLen = jTest.length;
	if(jLen < 1)
	{
		if(!pbAllowNull)
		{
			if(jLenErrorMessage > 0)
			{
				alert(pcErrorMessage);
			}
		}
		return pbAllowNull;		
	}
	alert(pcErrorMessage);
	return false;	
}
// Field is passed
function ValidInt(pValue, pbAllowNull, pnMinLen, pnMaxLen, pcErrorMessage, pbSetFocusOnFailure)
{
	var jLenErrorMessage = pcErrorMessage.trim().length;
	var re = new RegExp("^[0-9]{" + pnMinLen + "," + pnMaxLen + "}$");
	if(re.test(pValue.value))
	{
		return true;
	}
	var jLen = pValue.value.length;
	if(jLen < 1)
	{
		if(!pbAllowNull)
		{
			if(jLenErrorMessage > 0)
			{
				alert(pcErrorMessage);
			}
			if(pbSetFocusOnFailure)
			{
				pValue.focus();
			}
		}
		return pbAllowNull;		
	}
	alert(pcErrorMessage);
	if(pbSetFocusOnFailure)
	{
		pValue.focus();
	}
	return false;	
}
function ValidPin(pValue, pbAllowNull, pcErrorMessage)
{
	var jLenErrorMessage = pcErrorMessage.trim().length;
	var re = new RegExp("^[1-9][0-9]{5,5}$");
	if(re.test(pValue))
	{
		return true;
	}
	var jLen = pValue.length;
	if(jLen < 1)
	{
		if(!pbAllowNull)
		{
			if(jLenErrorMessage > 0)
			{
				alert(pcErrorMessage);
			}
		}
		return pbAllowNull;		
	}
	alert(pcErrorMessage);
	return false;
}
function ValidEmail(pcEmail, pbAllowNull, pcErrorMessage, pbSetFocusOnFailure)
{
	var jLenErrorMessage = pcErrorMessage.trim().length;
	var re = new RegExp("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
	if(pcEmail.length == 0)
	{
		if(!pbAllowNull)
		{
			if(jLenErrorMessage > 0)
			{
				alert(pcErrorMessage);
			}
			if(pbSetFocusOnFailure)
			{
				pcEmail.focus();
			}
		}		
		return	pbAllowNull;
	}	
	if(!re.test(pcEmail))
	{
			if(jLenErrorMessage > 0)
			{
				alert(pcErrorMessage);
			}
			if(pbSetFocusOnFailure)
			{
				pcEmail.focus();
			}
			return false;
	}
	return true;
}
function ValidEmail2(pcEmail, pbAllowNull, pcErrorMessage)
{
	var jLenErrorMessage = pcErrorMessage.trim().length;
	//var re = new RegExp("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
	var re = new RegExp("[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?");
	if(pcEmail.length == 0)
	{
		if(!pbAllowNull)
		{
			if(jLenErrorMessage > 0)
			{
				alert(pcErrorMessage);
			}
		}		
		return	pbAllowNull;
	}	
	if(!re.test(pcEmail))
	{
			if(jLenErrorMessage > 0)
			{
				alert(pcErrorMessage);
			}
			return false;
	}
	return true;
}
function ValidPAN(pcPAN, pbAllowNull, pcErrorMessage)
{
	var jLenErrorMessage = pcErrorMessage.trim().length;	
	var re = new RegExp("[a-z0-9A-Z]{10,10}");
	if(re.test(pcPAN))
	{
		return true;
	}
	if(pcPAN.length == 0)
	{
		if(!pbAllowNull)
		{
			if(jLenErrorMessage > 0)
			{
				alert(pcErrorMessage);
			}
		}		
		return pbAllowNull;
	}
	if(jLenErrorMessage > 0)
	{
		alert(pcErrorMessage);
	}
	return false;
}
// Address, City, State, Pin
function ZH2_ValidateAddress(pField1, pField2, pField3, pField4, pbAllowNull)
{
	var jnCount = 0;
	var re = new RegExp("^[1-9][0-9]{5,5}$"); // For Pin Code field pField4
	if(pField1.length > 0)
	{
		jnCount = jnCount + 1;
	}
	if(pField2.length > 0)
	{
		jnCount = jnCount + 1;
	}
	if(pField3.length > 0)
	{
		jnCount = jnCount + 1;
	}
	if(pField4.length > 0)
	{
		if(re.test(pField4))
		{
			jnCount = jnCount + 1;
		}
		else
		{
			jnCount = 1;
		}
	}
	if((jnCount > 0) && (jnCount != 4))
	{
			return false;
	}
	if(jnCount == 0)
	{
		return pbAllowNull;
	}
	return true;
}
function ZH2_ValidateGroupOf2(pField1, pField2, pbAllowNull)
{
	var jnCount = 0;
	if(pField1.length > 0)
	{
		jnCount = jnCount + 1;
	}
	if(pField2.length > 0)
	{
		jnCount = jnCount + 1;
	}
	if((jnCount > 0) && (jnCount != 2))
	{
			return false;
	}
	if(jnCount == 0)
	{
		return pbAllowNull;
	}
	return true;
}
function ZH2_ValidateGroupOf3(pField1, pField2, pField3, pbAllowNull)
{
	var jnCount = 0;
	if(pField1.length > 0)
	{
		jnCount = jnCount + 1;
	}
	if(pField2.length > 0)
	{
		jnCount = jnCount + 1;
	}
	if(pField3.length > 0)
	{
		jnCount = jnCount + 1;
	}
	if((jnCount > 0) && (jnCount != 3))
	{
			return false;
	}
	if(jnCount == 0)
	{
		return pbAllowNull;
	}
	return true;
}
function YyyyDotMmDotDd2YyyyMmDd(pcYyyyDotMmDotDd) {
	var jcIn = pcYyyyDotMmDotDd.trim();
	var jcOut = jcIn.substring(0,4) + jcIn.substring(5,7) + jcIn.substring(8,10);
	return jcOut;
}
function YyyyMmDd2DateStr(pcYyyyMmDd,pcSeparator) {
	return pcYyyyMmDd.substring(6,8) + pcSeparator + pcYyyyMmDd.substring(4,6) + pcSeparator + pcYyyyMmDd.substring(0,4);
}
function YyyyMmDd2YyyyDotMmDotDd(pcYyyyMmDd) {
	return pcYyyyMmDd.substring(0,4) + "-" + pcYyyyMmDd.substring(4,6) + "-" + pcYyyyMmDd.substring(6,8);
}
function GetNextDate(pcYyyyMmDd) {
	var jnDd, jnMm, jnYyyy;
	var jcOutput = '';
	jnDd = parseInt(pcYyyyMmDd.substring(6,8));
	jnMm = parseInt(pcYyyyMmDd.substring(4,6));
	jnYyyy = parseInt(pcYyyyMmDd.substring(0,4));
	jnDd = jnDd + 1;
	if(jnDd > 31) {
		jnDd = 1;
		jnMm++;
		if(jnMm > 12) {
			jnMm = 1;
			jnYyyy++;
		}
	}
	if(jnDd  > 30) {
		if( (jnMm === 4) || (jnMm === 6) || (jnMm === 9) || (jnMm === 11) ) {
			jnDd = 1;
			jnMm++;
		}
	}
	if( (jnMm === 2) && (jnDd > 28) ) {
		if(jnDd > 29) {
			jnDd = 1;
			jnMm++;
		}
		if(jnDd > 28) {
			if( (jnYyyy % 4) > 0 ) {
				jnDd = 1;
				jnMm++;
			}
		}
		if(jnDd > 28) {
			if( (jnYyyy % 400) === 0 ) {
				jnDd = 1;
				jnMm++;
			}
		}
	}
	jcOutput = '' + jnYyyy;
	if(jnMm < 10) {
		jcOutput += '0';
	}
	jcOutput += jnMm;
	if(jnDd < 10) {
		jcOutput += '0';
	}
	jcOutput += jnDd;
	return jcOutput;
}
function GetPrevDate(pcYyyyMmDd) {
	var jnDd, jnMm, jnYyyy;
	var jcOutput = '';
	jnDd = parseInt(pcYyyyMmDd.substring(6,8));
	jnMm = parseInt(pcYyyyMmDd.substring(4,6));
	jnYyyy = parseInt(pcYyyyMmDd.substring(0,4));
	jnDd = jnDd - 1;
	if(jnDd < 1) {
		jnDd = 31;
		jnMm--;
		if(jnMm < 1) {
			jnMm = 12;
			jnYyyy--;
		}
	}
	if(jnDd  > 30) {
		if( (jnMm === 4) || (jnMm === 6) || (jnMm === 9) || (jnMm === 11) ) {
			jnDd = 30;
		}
	}
	if(jnDd > 30) {
		if(jnMm === 2) {
			jnDd = 29;
		}
	}
	if( (jnMm === 2) && (jnDd > 28) ) {
		if(jnDd > 28) {
			if( (jnYyyy % 4) > 0 ) {
				jnDd = 28;
			}
		}
		if(jnDd > 28) {
			if( (jnYyyy % 400) === 0 ) {
				jnDd = 28;
			}
		}
	}
	jcOutput = '' + jnYyyy;
	if(jnMm < 10) {
		jcOutput += '0';
	}
	jcOutput += jnMm;
	if(jnDd < 10) {
		jcOutput += '0';
	}
	jcOutput += jnDd;
	return jcOutput;
}
function HhMi2TimeStr(pcHhMi) {
	return pcHhMi.substring(0,2) + ":" + pcHhMi.substring(2,4);
}
function HhMi2TimeStrAMPM(pcHhMi) {
	var jnHh, jcMode="AM";
	var jcOutput = "";
	jnHh = parseInt(pcHhMi.substring(0,2));
	if(jnHh > 11) {
		jcMode = "PM";
	}
	if(jnHh > 12) {
		jnHh -= 12;
	}
	if(jnHh < 10) {
		jcOutput = "0";
	}
	jcOutput += jnHh + ":" + pcHhMi.substring(2,4) + " " + jcMode;
	return jcOutput;
}