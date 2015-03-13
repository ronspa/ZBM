<html>
	<head>
		<TITLE>ASP Goform ReadWrite Demo
		</TITLE>
	</head>
	<body ><h1>ASP Goform ReadWrite Demo</h1>
		<form method="POST" action="/goform/ReadWrite">
			<input type=hidden name=redirect size=50 value="<% EnvPrint(PATH_TRANSLATED); %>">
			<p>PV-Name: 
				<input type="text" name="variable" value="<% WebPrint("var"); %>" size="50"> 
			</p>
			<p>Value:&nbsp; &nbsp; &nbsp; &nbsp; 
				<input type="text" name="value" value="<% WebPrint("val"); %>" size="50"> 
			</p>
			<p>
				<input type="submit" value="Read" name="read">
				<input type="submit" value="Write" name="write">
			</p>
		</form>
			<p>Current temperature:
				<% ReadPLC("gHeating.status.actTemp"); %> 
			</p><h2>You may use this PVs</h2>
			<ul>
				<li>gHeating.status.actTemp : REAL : temperature (OUT)
				</li>
				<li>gMainLogic.cmd.switchOnOff : BOOL : On-off switch of the coffee machine
				</li>
			</ul>
	</body>
</html>