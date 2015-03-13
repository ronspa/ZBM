<html>
	<head>
		<TITLE>ASP Goform ReadWrite Demo
		</TITLE>
	</head>
	<body ><h1>ASP Goform ReadWrite Demo</h1>
		<div style="border :1px solid #b3b2b2; margin: 5px; padding: 5px; width : 130px; height : 120px;">
			<form method="POST" action="/goform/ReadWrite">
				<input type=hidden name=redirect size=50 value="<% EnvPrint(PATH_TRANSLATED); %>">
					<input type="hidden" name="variable" value="gMainLogic.cmd.switchOnOff" size="50"> 
				<p>Kaffemaschine   <br>
					<input type="radio" checked="checked" name="value" value="1" size="50"> activate<br>
					<input type="radio" name="value" value="0" size="50"> deactivate 
				</p>
				<p>
					<input type="submit" value="Refresh" name="read">
					<input type="submit" value="Write" name="write">
				</p>
				
			</form>
		</div>
		<p><% ReadPLC("gHeating.status.actTemp","%.1f"); %> &deg;C: Current temperature</p>
		<p><% ReadPLC("gMainLogic.cmd.switchOnOff"); %>: state of the coffee machine (ReadPLC)</p>
		<p><% WebPrint("val"); %>: state of the coffee machine  (WebPrint). This value will be shown after first form submission.</p>
	</body>
</html>