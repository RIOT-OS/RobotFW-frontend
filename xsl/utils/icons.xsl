<?xml version="1.0" encoding="UTF-8"?>

<!--
  Icon utilities
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:func="http://exslt.org/functions"
  xmlns:riot-icons="http://ci.riot-os.org/functions"
  xmlns:svg="http://www.w3.org/2000/svg"
  extension-element-prefixes="func">

  <!--
    Include a SVG icon

    Based on the 'include' parameter the icon will be either included with a
    <img> tag or the content of the icon file will be copied inside a <svg> tag.
  -->
  <func:function name="riot-icons:get-icon">
    <xsl:param name="source" /><!-- static url for img or path to svg when include = true -->
    <xsl:param name="filename" />
    <xsl:param name="class" />
    <xsl:param name="include" select="'false'" />
  
    <func:result>
      <xsl:choose>
      <xsl:when test="$include = 'true'">
        <svg class="{$class}" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20">
          <xsl:copy-of select="document(concat($source, $filename))/svg:svg/*" />
        </svg>
      </xsl:when>
      <xsl:otherwise>
        <img class="{$class}" src="{$source}/{$filename}" />
      </xsl:otherwise>
      </xsl:choose>
    </func:result>
  </func:function>

</xsl:stylesheet>