<html>
<head>
<!-- instruction for reloading--> 
<meta http-equiv="refresh" content="1" />
</head>
<body>
<p>This page reloads every second.</p>
<p>Current temperature of B&amp;R coffee machine: <% ReadPLC("gHeating.status.actTemp"); %> &deg; C.</p>
</body>
</html>