<?xml version="1.0" encoding="UTF-8"?>

<!--
  Generate content of HTML <head />
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="partial-head">
    <xsl:param name="page" />

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
    <!-- Add global or page specific css from config.xml, pages.xml -->
    <xsl:for-each select="$stylesheets/stylesheet">
      <xsl:call-template name="add-stylesheet" mode="head">
        <xsl:with-param name="config" select="current()" />
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="$pages/page[@name = $page]/stylesheets">
      <xsl:call-template name="add-stylesheet" mode="head">
        <xsl:with-param name="config" select="current()" />
      </xsl:call-template>
    </xsl:for-each>
    <!-- Add global or page specific scripts from config.xml, pages.xml -->
    <xsl:for-each select="$scripts/script">
      <xsl:call-template name="add-script" mode="head">
        <xsl:with-param name="config" select="current()" />
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="$pages/page[@name = $page]/scripts/script">
      <xsl:call-template name="add-script" mode="head">
        <xsl:with-param name="config" select="current()" />
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!--
    Generate <script> element from config
  -->
  <xsl:template name="add-script" mode="head">
    <xsl:param name="config" />

    <xsl:choose>
      <xsl:when test="($config/@external = 'true') and ($config/@position = 'top')">
        <script type="{$config/@type}" src="{text()}" />
      </xsl:when>
      <xsl:when test="$config/@position = 'top'">
        <script type="{$config/@type}" src="{$static-url}/{text()}" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
    Generate <link> element from config
  -->
  <xsl:template name="add-stylesheet" mode="head">
    <xsl:param name="config" />

    <xsl:choose>
      <xsl:when test="$config/@external = 'true'">
        <link rel="stylesheet" href="{text()}" />
      </xsl:when>
      <xsl:otherwise>
        <link rel="stylesheet" href="{$static-url}/{text()}" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
