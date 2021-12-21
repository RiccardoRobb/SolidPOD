<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    version="2.0">

<xsl:variable name="agent">0x115f3286214d212940ea8a9729d7fa9bffbf34b417182c367f19683c86460f4d</xsl:variable>

<xsl:variable name="agentClass">0xcd19ac0aa7c8fc00a6fe656d8cbb736dfffcb150f17c2ab772e275580c24c6b7</xsl:variable>

<xsl:variable name="app">0x7205dc88e6ee2b598403174d48e9b148aff045f2cd055367166c21524f0b8e87</xsl:variable>

<xsl:variable name="agentS">0x115f...</xsl:variable>

<xsl:variable name="agentClassS">0xcd19...</xsl:variable>

<xsl:variable name="appS">0x7205...</xsl:variable>

<xsl:template match="/">
	<html>
	    <head>
	        <style>
	            table{border: 1pt solid black; width: 94%; border-collapse: collapse; margin-left: 3%; margin-right: 3%}
	            tr:hover{background-color: #E7E9EB;}
	            tr{border-bottom: 1pt solid black;}
	            tr.new{background-color: #000000;}
	            td{padding-left: 5px;padding-top: 5px;padding-bottom: 5px;}
	            td.last{text-align: right;}
	            font.separator{color:#0066ff; margin-left: 15px;}
	            font.reduced{font-size: 10px;}
	        </style>
	    </head>
		<body>
		    <pre>
		        <div style="padding: 1% 1% 1% 1%; border-left-style: solid; background-color: #E0EBEB; margin-bottom: 3%; width: 98%;">
		            <h3>podName = https://riccardo.solidcommunity.net/private/Files -> <font style="color: #639C9C;"><em>0xa2562b602b63e582e070509e535db9cad726b3d2f4007c681e741142b7f7b135</em></font></h3>
		        </div>
		        <div style="display: flex; flex-direction: row; flex-wrap: nowrap; align-items: flex-start;">
		        <div style="border-left-style: solid; height:fit-content; background-color: #E0EBEB; margin:0px; flex-grow: 1;">
    			<xsl:for-each select="*">
    			    <xsl:for-each select="*">
    			    <table>
    			        <xsl:for-each select="*">
                            
                                <xsl:choose>
                                    <xsl:when test = "local-name() = 'mode'">
                                    
                                        <xsl:for-each select="@*">
                                            <font class="separator"><xsl:value-of select="substring-after(.,'#')"/></font>
                                        </xsl:for-each>
                                        
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <tr>
                                        
                                        <xsl:choose>
                                            <xsl:when test = "local-name() = 'default'">
                                                <td><strong><strike><xsl:value-of select="local-name()"/></strike></strong></td>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <td><strong><xsl:value-of select="local-name()"/></strong></td>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        
                                        <xsl:for-each select="@*">
                                            <td><xsl:value-of select="."/></td>
                                            <xsl:choose>
                                            <xsl:when test = ". = './'">
                                                <td class="last"><strong><font class="reduced">0xa2562b602b63e582e070509e535db9cad726b3d2f4007c681e741142b7f7b135</font></strong></td>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:choose>
                                                <xsl:when test = "local-name(..) = 'agent'">
                                                    <td class="last"><strong><font class="reduced"><xsl:value-of select="$agent"/></font></strong></td>
                                                </xsl:when>
                                                <xsl:when test = "local-name(..) = 'agentClass'">
                                                    <td class="last"><strong><font class="reduced"><xsl:value-of select="$agentClass"/></font></strong></td>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <td class="last"><strong><font class="reduced"><xsl:value-of select="$app"/></font></strong></td>
                                                </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        </xsl:for-each>
                                        
                                        </tr>
                                    </xsl:otherwise>
                                </xsl:choose>
                            
    			        </xsl:for-each>
    			        </table>
    			        <br></br>
    			    </xsl:for-each>
    			</xsl:for-each>
    			</div>
    			<div style="flex-grow: 1; ">
    			    <strong><h2><font style="margin-left: 15px;">Calls</font></h2></strong>
    			    <ul>
    			        <li>Deploy(<strong><font class="reduced">0xa256...</font></strong>)</li>
    			        
    			        <xsl:for-each select="*">
    			            <xsl:for-each select="*">
    			                <li>addRule(<strong><font class="reduced"><xsl:for-each select="*"><xsl:choose><xsl:when test = "local-name() = 'mode'"><xsl:for-each select="@*"><xsl:value-of select="substring-after(.,'#')"/></xsl:for-each></xsl:when></xsl:choose></xsl:for-each>,<xsl:for-each select="*"><xsl:choose><xsl:when test="local-name()='agent'"><xsl:value-of select="$agentS"/></xsl:when><xsl:when test="local-name()='agentClass'"><xsl:value-of select="$agentClassS"/></xsl:when><xsl:when test="local-name()='origin'"><xsl:value-of select="$appS"/></xsl:when></xsl:choose></xsl:for-each>)</font></strong></li>
    			            </xsl:for-each>
			            </xsl:for-each>
    			    </ul>
    			    <strong><h2><font style="margin-left: 15px;">+</font></h2></strong>
    			    <ul>
    			        <li>changeRule(<strong><font class="reduced">Read,<xsl:value-of select="$agentS"/>,Write</font></strong>)</li>
			            <li>removeRule(<strong><font class="reduced"><xsl:value-of select="$agentS"/>,Write</font></strong>)</li>
    			    </ul>
    			</div>
    			</div>
    		</pre>
		</body>
	</html>
</xsl:template>

</xsl:stylesheet>