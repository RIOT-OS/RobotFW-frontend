<?xml version="1.0" encoding="UTF-8"?>

<!--
  Date and time utilities
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:date="http://exslt.org/dates-and-times"
  xmlns:func="http://exslt.org/functions"
  xmlns:riot-date="http://ci.riot-os.org/functions"
  extension-element-prefixes="date func">

  <xsl:import href="../lib/date.format-date.function.xsl" />
  
  <!--
    Calculate the difference between two dateTimes.

    @example with date:    2020-08-17T01:02:04.008, 2020-08-16T02:04:08.016
             without date: 01:02:04.008, 02:04:08.016
             both becomes: 01:02:04.008
  -->
  <func:function name="riot-date:time-diff">
    <xsl:param name="start" />
    <xsl:param name="end" />
    <xsl:param name="format" select="'HH:mm:ss.SSS'" />

    <xsl:variable name="datetime-start">
      <xsl:choose>
        <xsl:when test="not(contains($start, 'T'))">
          <xsl:value-of select="concat('0001-01-01T', $start)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$start" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="datetime-end">
      <xsl:choose>
        <xsl:when test="not(contains($end, 'T'))">
          <xsl:value-of select="concat('0001-01-01T', $end)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$end" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="diff-duration" select="date:difference($datetime-start, $datetime-end)" />
    
    <!-- date:add needs a date (e.g. 0001-01-01) which is stipped afterwards -->
    <xsl:variable name="diff-time" select="date:time(date:add('0001-01-01T00:00:00', $diff-duration))" />

    <func:result>
      <xsl:value-of select="date:format-date($diff-time, $format)" />
    </func:result>
  </func:function>

</xsl:stylesheet>