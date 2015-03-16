<html>
<head>
	<title>Start Coffee Machine</title>
</head>
<body>
	<h1>Welcome</h1>
	<p>State of the coffee machine: <% ReadPLC("gMainLogic.cmd.switchOnOff"); %></p>
	<p>Start coffee machine...      <% WritePLC("gMainLogic.cmd.switchOnOff","1"); %></p>
	<p>State of the coffee machine: <% ReadPLC("gMainLogic.cmd.switchOnOff"); %></p>
	<hr />
	
	<p>Current temperature: <% ReadPLC("gHeating.status.actTemp","%.1f"); %> </p>
	<p>Current Recipe</p>
	<p>Cream: <% ReadPLC("gMainLogic.par.receipe.milk"); %></p>
	<p>Sugar: <% ReadPLC("gMainLogic.par.receipe.sugar"); %></p>
	<p>Coffee Powder: <% ReadPLC("gMainLogic.par.receipe.coffee"); %></p>
	<p>Water: <% ReadPLC("gMainLogic.par.receipe.water"); %></p>

</body>
</html> 

