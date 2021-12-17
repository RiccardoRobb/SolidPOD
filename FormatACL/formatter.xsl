<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
	<html>
	    <head>
	        <style>
	            table{border: 1pt solid black; width: 40%;border-collapse: collapse;}
	            tr:hover{background-color: #E7E9EB;}
	            tr{border-bottom: 1pt solid black;}
	            td{padding-left: 5px;padding-top: 5px;padding-bottom: 5px;}
	        </style>
	    </head>
		<body>
    			<xsl:for-each select="*">
    			    <xsl:for-each select="*">
    			        <pre><table>
    			        <xsl:for-each select="*">
    			                <tr>
        			            <td><strong><xsl:value-of select="local-name()" /></strong></td>
        			            <xsl:for-each select="@*">
        			                <td><xsl:value-of select="." /></td>
        			            </xsl:for-each>
    			                </tr>
    			        </xsl:for-each>
    			        </table>
    			        </pre>
    			        <br></br>
    			    </xsl:for-each>
    			</xsl:for-each>
		</body>
	</html>
</xsl:template>

</xsl:stylesheet>