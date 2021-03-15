<?xml version="1.0" encoding="UTF-8"?>

<!--
  Create a button using an <a> or <button> element.

  @see assets/css/components/button.css
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:riot-icons="http://ci.riot-os.org/functions">

  <xsl:import href="../utils/icons.xsl" />

  <xsl:template name="button">
    <xsl:param name="button-text" />
    <xsl:param name="css-id" />
    <xsl:param name="css-class" />
    <xsl:param name="type" select="'normal'" />
    <xsl:param name="element" select="'button'" />
    <xsl:param name="href" />
    <xsl:param name="icon-filename" />
  
    <xsl:element name="{$element}">
      <xsl:if test="$css-id != ''">
        <xsl:attribute name="id">
          <xsl:value-of select="$css-id"></xsl:value-of>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="class">
        <xsl:if test="$css-class != ''">
          <xsl:value-of select="$css-class"></xsl:value-of>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:text>c-button</xsl:text>
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="$element = 'a'">
          <xsl:attribute name="role">button</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$href" />
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="$type = 'dropdown'">
          <xsl:attribute name="data-toggle">dropdown</xsl:attribute>
          <xsl:attribute name="aria-haspopup">true</xsl:attribute>
          <xsl:attribute name="aria-expanded">false</xsl:attribute>
        </xsl:when>
      </xsl:choose>

      <span><xsl:value-of select="$button-text" /></span>
      <xsl:if test="$icon-filename != ''">
        <xsl:copy-of select="riot-icons:get-icon($icon-dir, $icon-filename, 'fill-current w-4 h-4 ml-2', 'true')" />
      </xsl:if>
    </xsl:element>

  </xsl:template>

</xsl:stylesheet>
