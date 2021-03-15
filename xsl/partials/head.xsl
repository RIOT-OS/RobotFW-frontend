<?xml version="1.0" encoding="UTF-8"?>

<!--
  Generate content of HTML <head />
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="partial-head">
    <meta charset="{$charset}" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta http-equiv="x-ua-compatible" content="ie=edge" />
    <title><xsl:value-of select="$title" /></title>
    <link rel="apple-touch-icon" sizes="180x180" href="{$static-url}/apple-touch-icon.png" />
    <link rel="icon" type="image/png" sizes="32x32" href="{$static-url}/favicon-32x32.png" />
    <link rel="icon" type="image/png" sizes="16x16" href="{$static-url}/favicon-16x16.png" />
    <link rel="manifest" href="{$static-url}/site.webmanifest" />
    <link rel="mask-icon" href="{$static-url}/safari-pinned-tab.svg" color="#5bbad5" />
    <meta name="msapplication-TileColor" content="#2b5797" />
    <meta name="theme-color" content="#ffffff" />
    <link rel="stylesheet" href="{$static-url}/styles.css?v=1.0.1" />
     <xsl:for-each select="$scripts/script">
      <xsl:choose>
        <xsl:when test="(@external = 'true') and (@position = 'top')">
          <script type="{@type}" src="{text()}" />
        </xsl:when>
        <xsl:when test="@position = 'top'">
          <script type="{@type}" src="{$static-url}/{text()}" />
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>