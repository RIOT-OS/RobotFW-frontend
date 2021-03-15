<?xml version="1.0" encoding="UTF-8"?>

<!--
  Error utilities
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:func="http://exslt.org/functions"
  xmlns:riot-error="http://ci.riot-os.org/functions"
  extension-element-prefixes="func">

  <!--
    Display a error message with or without termination of the XSL transformation.
  -->
  <func:function name="riot-error:raise-error">
    <xsl:param name="message" />
    <xsl:param name="terminate" select="'no'" />
    <xsl:param name="severity" select="'ERROR'" />
  
    <func:result>
      <!-- Terminate does not allow variable so choose is used instead -->
      <xsl:choose>
        <xsl:when test="$terminate = 'yes'">
          <xsl:message terminate="yes"><xsl:value-of select="$severity" />: <xsl:value-of select="$message" /></xsl:message>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message terminate="no"><xsl:value-of select="$severity" />: <xsl:value-of select="$message" /></xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </func:result>
  </func:function>

</xsl:stylesheet>
