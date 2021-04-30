<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:func="http://exslt.org/functions"
  xmlns:riot-error="http://ci.riot-os.org/functions"
  extension-element-prefixes="func">

  <!-- Imports -->
  <xsl:import href="pages/overview.xsl" />
  <xsl:import href="pages/report.xsl" />
  <xsl:import href="pages/log.xsl" />
  <xsl:import href="partials/head.xsl" />
  <xsl:import href="partials/navbar.xsl" />
  <xsl:import href="utils/error.xsl" />

  <!-- Params -->
  <xsl:param name="config" select="'../config.xml'" />
  <xsl:param name="config-pages" select="'../pages.xml'" />
  <xsl:param name="project-basedir" />
  <xsl:param name="xml-basedir" />
  <xsl:param name="page" />
  <xsl:param name="path-prefix" />

  <!-- Documents -->
  <xsl:variable name="config-doc" select="document($config)" />
  <xsl:variable name="config-pages-doc" select="document($config-pages)" />
  <xsl:variable name="robot-doc" select="document(concat($xml-basedir, '/robot.xml'))" />
  <xsl:variable name="metadata-doc" select="document(concat($xml-basedir, '/metadata.xml'))" />

  <!-- Globals -->
  <xsl:variable name="lang" select="$config-doc/config/lang" />
  <xsl:variable name="charset" select="$config-doc/config/charset" />
  <xsl:variable name="title" select="$config-doc/config/title" />
  <xsl:variable name="page-title" select="$config-doc/config/page_title" />
  <xsl:variable name="icon-dir" select="concat($project-basedir, '/', $config-doc/config/paths/icons)" />
  <xsl:variable name="date-formats" select="$config-doc/config/date_formats" />
  <xsl:variable name="stylesheets" select="$config-doc/config/stylesheets" />
  <xsl:variable name="scripts" select="$config-doc/config/scripts" />
  <xsl:variable name="pages" select="$config-pages-doc/pages" />

  <xsl:variable name="base-url" select="$config-doc/config/urls/base" />
  <xsl:variable name="static-url" select="$config-doc/config/urls/static" />
  <xsl:variable name="image-url" select="concat($static-url, '/images')" />
  <xsl:variable name="icon-url" select="concat($static-url, '/images/zondicons')" />

  <!-- Configure output -->
  <xsl:output method="html" indent="no" />

  <xsl:template match="/">

    <!-- Check mandatory params -->
    <xsl:if test="$page = ''">
      <xsl:copy-of select="riot-error:raise-error('Missing param: page', 'yes')" />
    </xsl:if>

    <xsl:variable name="current-board" select="/robot/suite/meta[@name='RIOT-Board']" />
    <xsl:variable name="current-testsuite" select="/robot/suite/meta[@name='RIOT-Application']" />

    <html lang="{$lang}" class="bg-white antialiased">
      <head>
        <!-- call partials/head -->
        <xsl:call-template name="partial-head">
          <xsl:with-param name="page" select="$page" />
        </xsl:call-template>
      </head>
      <body class="overflow-hidden">
        <div id="header" class="fixed top-0 w-full h-16 z-50">
          <!-- call partials/navbar -->
          <xsl:call-template name="partial-navbar">
            <xsl:with-param name="page" select="$page" />
            <xsl:with-param name="page-title" select="$page-title" />
            <xsl:with-param name="current-board" select="$current-board" />
            <xsl:with-param name="current-testsuite" select="$current-testsuite" />
          </xsl:call-template>
        </div>
        <div id="main" class="w-full mt-16">
          <div id="content-wrapper" class="h-full w-full mx-auto overflow-y-auto">
            <!--
              Load a page template, see 'xsl/pages/'

              The wisdom of how this magic works will soon be forgotten,
              here are some links to guide you (and me) a path.
               - https://stackoverflow.com/a/5656591
               - https://stackoverflow.com/questions/9936762/xslt-pass-current-context-in-call-template
               - https://stackoverflow.com/questions/7005855/what-xslt-instructions-change-the-current-node-other-than-for-each
            -->
            <xsl:choose>
              <xsl:when test="$pages/page[@name = $page]/@name = $page">                  
                <xsl:apply-templates select="$pages/page[@name = $page]/template" mode="call-page">
                  <xsl:with-param name="context-node" select="current()"/>
                  <xsl:with-param name="current-board" select="$current-board" />
                  <xsl:with-param name="current-testsuite" select="$current-testsuite" />
                </xsl:apply-templates>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="riot-error:raise-error(concat('No page defined for param:', $page), 'yes')" />
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </div>
        <!-- Include js from config.xml settings file -->
        <xsl:for-each select="$scripts/script">
          <xsl:choose>
            <xsl:when test="(@external = 'true') and (@position = 'bottom')">
              <script type="{@type}" src="{text()}" />
            </xsl:when>
            <xsl:when test="@position = 'bottom'">
              <script type="{@type}" src="{$static-url}/{text()}" />
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>