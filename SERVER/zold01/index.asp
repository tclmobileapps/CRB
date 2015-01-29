<!--#include file="General.asp"-->
<!--#include file="CRBGeneral.asp"-->
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Conference R</title>

  <script src="js/jquery.js"></script>
  <script src="js/jquerymobile.js"></script>

  <!-- stylesheets -->
  <link rel="stylesheet" href="css/jquerymobile.css">
  <link rel="stylesheet" href="css/style.css">

</head>
<body>
<!--#include file="login.asp"-->
<!--#include file="home.asp"-->





<script src="js/script.js"></script>
<script src="js/crb.js"></script>
<script language="JavaScript">
$(document).ready(function(){
	localStorage.cUser = "";
	localStorage.cToken = "";
	$.ajaxSetup({ cache: false });
	$('#frmLogin').submit(function(e){
		e.preventDefault();
	});
});
</script>

</body>
</html>