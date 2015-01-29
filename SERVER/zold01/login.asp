  <section data-role="page" id="login">
   <header data-theme="b" data-role="header">
     <img src="images/tcl01.png" alt="Tata Capital Logo">
     <h2>Conference Room Booking</h2>
   </header><!-- header -->
   <article role="main" class="ui-content">
      <h3>Login Page</h3>
      <form id="frmLogin" method="post" action="">
        <label for="txt_frmLoginUser">User ID</label>
        <input type="text" name="txt_frmLoginUser" id="txt_frmLoginUser" value="531953" placeholder="Domain Id"></input>

        <label for="txt_frmLoginPassword">Password</label>
        <input type="password" name="txt_frmLoginPassword" id="txt_frmLoginPassword" value="Pheru@1201" placeholder="Password"></input>

        <div data-role="controlgroup">
          <a href="#home" 
             class="ui-btn ui-btn-b ui-icon-check ui-btn-icon-left ui-corner-all"
             onclick="frmLogin_Try2Login()"
          >Continue</a>
        </div>
        <button type="submit" class="ui-hidden-accessible">Submit</button>
      </form>
   </article><!-- content -->
   <footer data-theme="b" data-role="footer" data-position="fixed">
    <h4>&copy; 2014, TCFSL</h4>
   </footer><!-- footer -->
  </section><!-- login -->

<script language="JavaScript">
function frmLogin_Try2Login()
{
    if(!ValidText(document.getElementById("txt_frmLoginUser"),5,10,false,"Please enter a correct user code",true))
    {
      return;
    }

    if(!ValidText(document.getElementById("txt_frmLoginPassword"),1,20,false,"Please enter the password",true))
    {
      return;
    }   

    var jcUser    = $('#txt_frmLoginUser').val(),
      jcPassword  = $('#txt_frmLoginPassword').val();
    $.ajax(
    {
      Type: "POST",
      contentType: "application/json",
      url: "api_CRB_ValidateLogin.asp?callback=?",
      data: { 'txtParamcUser': jcUser, 'txtParamcPassword': jcPassword },
      success: function(rv) {
        var o = jQuery.parseJSON(rv);
        if(o.bIsError)
        {
          alert("Unable to login: " + o.cErrorMesg);
        }
        else
        {
          localStorage.cUser = jcUser;
          localStorage.cToken = o.cToken;
          $("#frmLogin").submit();
        }
      }
    });

}
</script>