<html>
	<head>
		<TITLE>ASP Goform (Multiform)
		</TITLE>
	</head>
	<body ><h1>ASP Goform (Multiform)</h1>
	<div style="border :2px solid #b3b2b2; margin: 5px; padding: 5px; width : 140px; height : 370px;">
		<form method="POST" action="/goform/ReadWrite">
			<input type=hidden name=redirect size=50 value="<% EnvPrint(PATH_TRANSLATED); %>">
			<div style="border :1px solid #b3b2b2; margin: 5px; padding: 5px; width : 118px; height : 90px;">
				1. PV Name: <br>
					<input type="text" name="variable" value="gMainLogic.par.coffeeType" size="15" readonly="readonly"> 
				<br>
				1. Value:<br>
					<input type="text" name="value" value="0" size="1">Coffee type
			</div>
			<div style="border :1px solid #b3b2b2; margin: 5px; padding: 5px; width : 118px; height : 90px;">
				2. PV Name: <br>
					<input type="text" name="variable1" value="gMainLogic.par.givenMoney"  size="15" readonly="readonly"> 
				<br>
				2. Value:<br>
					<input type="text" name="value1" value="<% WebPrint("val1"); %>" size="10"> €
			</div>
			<div style="border :1px solid #b3b2b2; margin: 5px; padding: 5px; width : 118px; height : 90px;">
				3. PV Name: <br>
					<input type="hidden" name="variable2" value="visCtrl:cmdStartCoffee" size="15"> <i>(Field is hidden)</i>
				<br>
				3. Value:<br>
					<input type="text" name="value2" value="<% WebPrint("val2"); %>" size="1">"Start" 
			</div>
			<p>
				<input type="submit" value="Read" name="read">
				<input type="submit" value="Write" name="write">
			</p>
			
		</form>
	</div>	
<br>Change: <% ReadPLC(gMainLogic.status.money.changedMoney); %> €

	</body>
</html>