<!--#include file="General.asp"-->
<!--#include file="CRBGeneral.asp"-->
<%
response.write "Pre  Test: " & now() & "<br/>"
response.write "Count    : " & GetCount("T_CRB_00", "nID > 0") & "<BR/>"
response.write "Post Test: " & now() & "<br/>"
%>