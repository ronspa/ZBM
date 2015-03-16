pvAccess =  {}
pvAccess.Func = function() 
{
	function AccessPV(name, rValue, wValue)
	{
		var url = '/goform/ReadWrite';
		var data = 'redirect=/response.asp&variable=' + escape(name);
		if(rValue != null && rValue != "")
		{
		data += '&value=' + escape(rValue);
		data += "&write=1";
		}
		else
		{
		data += '&value=none';
		data += "&read=1";
		}
		var xmlHttp = null;
		try {
		    // Mozilla, Opera, Safari sowie Internet Explorer (ab v7)
		    xmlHttp = new XMLHttpRequest();
		} catch(e) {
		    try {
		        // MS Internet Explorer (ab v6)
		        xmlHttp  = new ActiveXObject("Microsoft.XMLHTTP");
		    } catch(e) {
		        try {
		            // MS Internet Explorer (ab v5)
		            xmlHttp  = new ActiveXObject("Msxml2.XMLHTTP");
		        } catch(e) {
		            xmlHttp  = null;
		        }
		    }
		}
		if (xmlHttp) 
		{
			xmlHttp.open('POST', url , 1);
			xmlHttp.onreadystatechange = function () {
			    if (xmlHttp.readyState == 4) {
			    
						if(wValue != null)
						{
							wValue[3] = xmlHttp.responseText;
							wValue[3] = wValue[3].replace("<!-- B&R ASP Webserver -->",""); 
							// value attribut of node
							wValue.value = wValue[3];
							return wValue;
						}
						               
				    
			    }
			};
			xmlHttp.send(data);
		}
	}
// public	
 	{
		this.WritePV = function(name, value) 
		{
			AccessPV(name,value);
		}
		
 		this.ReadPV = function(name,wValue)
		{
		return	AccessPV(name, null, wValue);
		}		
 	}
}
pvAccess = new pvAccess.Func();

