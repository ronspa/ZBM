Visible for all
ASP users of group 1 automatically will switch on the coffee machine
ASP users of group 2 automatically will switch off the coffee machine

State of coffee machine: <% ReadPLC("gMainLogic.cmd.switchOnOff"); %>

<% UserGroup(1); %>
Group 1 - coffee machine get switched on
<% WritePLC("gMainLogic.cmd.switchOnOff","1"); %>
<% UserGroup(2); %>
Group 2  - coffee machine get switched off
<% WritePLC("gMainLogic.cmd.switchOnOff","0"); %>
<% UserGroup(3); %>
Group 1 + 2
<% UserGroup(4); %>
Group 4

<% UserGroup(8); %>
Group 8
<% UserGroup(0); %>
Visible for all


Now same with ErrorMsg
<% UserGroup(1); %>
Group 1
<% ErrorMsg(); %>
All but group1 
<% UserGroup(2); %>
Group 2
<% ErrorMsg(); %>
All but group2 
<% UserGroup(3); %>
Group 1 + 2
<% ErrorMsg(); %>
All but group1 +2 
<% UserGroup(4); %>
Group 4
<% ErrorMsg(); %>
All but group4
<% UserGroup(8); %>
Group 8
<% ErrorMsg(); %>
All but group8
<% UserGroup(0); %>
Visible for all
------
State of coffee machine: <% ReadPLC("gMainLogic.cmd.switchOnOff"); %>

<% ErrorMsg(); %>
Visible for nobody