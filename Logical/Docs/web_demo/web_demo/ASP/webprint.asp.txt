<html>
<body>

	<p>You came here from <% WebPrint("param"); %> <br>
	<a href="<% WebPrint("param"); %>" >Back to previous page</a></p>
	<p>In ASP Sites you can use a link like this: &lt;a href="/ASP/Webprint.asp?<b>param=/&lt;% EnvPrint(PATH_TRANSLATED); %&gt;</b>" &gt;Back&lt;/a&gt; </p>

</body>
</html>