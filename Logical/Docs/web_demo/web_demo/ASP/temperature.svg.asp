<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
	<svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 400"  preserveAspectRatio="XMidYMid meet" >
		<text x="10" y="15">Current temperature of the coffee machine</text>
		<g transform="rotate(180)">
			<rect x="-30" y="-140" width="20" height="120" fill="grey" opacity=".5"/>
			<rect x="-30" y="-140" width="20" height="<% ReadPLC(gHeating.status.actTemp); %>" fill="green" />
		</g>
		<text x="10" y="155" ><% ReadPLC(gHeating.status.actTemp); %> ° C </text>
		
		<script>
			function refresh()
			{
			 clearTimeout(timeout);
			 document.location.href = document.location.href;
			}
			var timeout = setTimeout("refresh()", 1000);
		</script>
</svg>