<?xml version="1.0" encoding="UTF-8"?>

<!--
  Create a tooltip and add it to an existing element using attributes.

  @see https://thednp.github.io/bootstrap.native/#componentTooltip
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="tooltip">
    <xsl:param name="content" />
    <xsl:param name="placement" select="'bottom'" />

    <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
    <xsl:attribute name="data-html">true</xsl:attribute>
    <xsl:attribute name="data-placement"><xsl:value-of select="$placement" /></xsl:attribute>
    <xsl:attribute name="title"><xsl:value-of select="$content" /></xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
