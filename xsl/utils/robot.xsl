<?xml version="1.0" encoding="UTF-8"?>

<!--
  Robot Framework specific utilities
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:date="http://exslt.org/dates-and-times"
  xmlns:func="http://exslt.org/functions"
  xmlns:riot-error="http://ci.riot-os.org/functions"
  xmlns:riot-robot="http://ci.riot-os.org/functions"
  extension-element-prefixes="date func">

  <xsl:import href="./error.xsl" />

  <!--
    Convert a robot framework datetime string to a xsd:dateTime.

    @example "20200702 02:10:40.190" becomes "2020-07-02T02:10:40.190"

    @see https://robotframework.org/robotframework/latest/libraries/DateTime.html
    @see https://www.w3.org/TR/xmlschema-2/#dateTime
    @see https://www.w3.org/TR/xmlschema-2/#time
    @see https://www.w3.org/TR/xmlschema-2/#date
  -->
  <func:function name="riot-robot:parse-robot-datetime">
    <xsl:param name="robot-datestring" />

    <xsl:variable name="date" select="substring-before($robot-datestring,' ')" />
    <xsl:variable name="time" select="substring-after($robot-datestring,' ')" />

    <xsl:variable name="year" select="substring($robot-datestring,1,4)" />
    <xsl:variable name="month" select="substring($robot-datestring,5,2)" />
    <xsl:variable name="day" select="substring($robot-datestring,7,2)" />

    <func:result>
      <xsl:value-of select="concat($year,'-',$month,'-',$day,'T',$time)" />
    </func:result>
  </func:function>

  <!--
    Get all testsuites

    This function transforms '$robot-doc/result/boards' and extracts and merges all
    testsuites from all boards.

    @see http://www.jenitennison.com/xslt/grouping/muenchian.html
  -->
  <func:function name="riot-robot:get-all-testsuites">
    <xsl:param name="boards" />

    <func:result>
      <xsl:apply-templates mode="utils-robot" select="$boards" />
    </func:result>
  </func:function>

  <!-- grouping key -->
  <xsl:key name="board-by-testsuite" match="testsuite" use="@name"/>

  <xsl:template name="get-all-testsuites-boards" match="boards" mode="utils-robot">
    <xsl:element name="testsuites">
      <xsl:apply-templates mode="utils-robot" select="board" />
    </xsl:element>
  </xsl:template>

  <xsl:template name="get-all-testsuites-board" match="board" mode="utils-robot">
      <xsl:apply-templates select="testsuite" mode="utils-robot">
        <xsl:sort select="@name" data-type="text" order="ascending" />
      </xsl:apply-templates>
  </xsl:template>

  <xsl:template name="get-all-testsuites-board-suite" match="testsuite[generate-id() = generate-id(key('board-by-testsuite', @name)[1])]" mode="utils-robot">
    <xsl:element name="testsuite">
      <xsl:value-of select="@name" />
    </xsl:element>
  </xsl:template>


  <!--
    Generate url to pages without <board>/<testsuite>
  -->
  <func:function name="riot-robot:get-base-page-url">
    <xsl:param name="page" select="''" />

    <func:result>
      <xsl:value-of select="riot-robot:generate-page-url('', '', $page)" />
    </func:result>
  </func:function>

  <!--
    Generate url to pages with <board>/<testsuite>
  -->
  <func:function name="riot-robot:get-testsuite-page-url">
    <xsl:param name="board" select="''" />
    <xsl:param name="testsuite" select="''" />
    <xsl:param name="page" select="''" />

    <xsl:if test="($board = '') or ($testsuite = '')">
      <xsl:copy-of select="riot-error:raise-error('Wrong param value: riot-robot:get-testsuite-page-url', 'yes')" />
    </xsl:if>

    <func:result>
      <xsl:value-of select="riot-robot:generate-page-url($board, $testsuite, $page)" />
    </func:result>
  </func:function>

  <!--
    Generate page url
  -->
  <func:function name="riot-robot:generate-page-url">
    <xsl:param name="board" select="''" />
    <xsl:param name="testsuite" select="''" />
    <xsl:param name="page" select="''" />
    <xsl:param name="absolute" select="$config-doc/config/absolute_urls" />

    <xsl:if test="$page = ''">
      <xsl:copy-of select="riot-error:raise-error('Wrong param value: riot-robot:generate-page-url: page', 'yes')" />
    </xsl:if>

    <xsl:variable name="prefix">
      <xsl:choose>
        <xsl:when test="$path-prefix != ''">
          <xsl:value-of select="concat('/', $path-prefix, '/')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'/'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="relative-url">
      <xsl:choose>
        <xsl:when test="($board != '') and ($testsuite != '')">
          <xsl:value-of select="concat($prefix, $board, '/', $testsuite, '/', $page)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($prefix, $page)" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="result-url">
      <xsl:choose>
        <xsl:when test="$absolute = 'true'">
          <xsl:value-of select="concat($base-url, $relative-url)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$relative-url" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <func:result>
      <xsl:value-of select="$result-url" />
    </func:result>
  </func:function>

</xsl:stylesheet>