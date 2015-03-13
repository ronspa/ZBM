<html>
<body>
<p>Enviroment variables</p>
	<table>
		<tr><td><% EnvPrint(LOAD_USERS); %>		</td><td> LOAD_USERS </td></tr>               	
		<tr><td><% EnvPrint(LOGIN_USERNAME); %>	</td><td> LOGIN_USERNAME  </td></tr>  
		<tr><td><% EnvPrint(LOGIN_USERS); %>	</td><td> LOGIN_USERS           </td></tr>  
		<tr><td><% EnvPrint(PATH_INFO); %>		</td><td> PATH_INFO            </td></tr>  
		<tr><td><% EnvPrint(QUERY_STRING); %>	</td><td> QUERY_STRING      </td></tr>  
		<tr><td><% EnvPrint(REMOTE_ADDR); %>	</td><td> REMOTE_ADDR      </td></tr>  
		<tr><td><% EnvPrint(SERVER_PORT); %>	</td><td> SERVER_PORT       </td></tr>  
		<tr><td><% EnvPrint(SERVER_URL); %>		</td><td> SERVER_URL     </td></tr>  
		<tr><td><% EnvPrint(PATH_TRANSLATED); %></td><td> PATH_TRANSLATED  </td></tr>  
	</table>
</body>
</html>
