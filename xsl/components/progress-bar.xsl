<?xml version="1.0" encoding="UTF-8"?>

<!--
  Create a progress bar which shows the distribution
  of skipped, failed and passed tests.
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="progress-bar">
    <xsl:param name="total" />
    <xsl:param name="pass" />
    <xsl:param name="fails" />
    <xsl:param name="skips" />

    <xsl:variable name="pass_percent" select="$pass div $total * 100"/>
    <xsl:variable name="fail_percent" select="$fails div $total * 100"/>
    <xsl:variable name="skip_percent" select="$skips div $total * 100"/>

    <div class="relative">
      <div class="overflow-hidden h-5 text-xs flex bg-white">
        <div style="width: {$pass_percent}%" class="shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center bg-green-600"></div>
        <div style="width: {$fail_percent}%" class="shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center bg-red-600"></div>
        <div style="width: {$skip_percent}%" class="shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center bg-gray-600"></div>
        <div class="w-full absolute flex flex-col text-center whitespace-nowrap text-white font-bold justify-center self-center">
          <xsl:text>( </xsl:text>
          <xsl:value-of select="$pass" />
          <xsl:text> / </xsl:text>
          <xsl:value-of select="$total" />
          <xsl:text> )</xsl:text>
        </div>
      </div>
    </div>

  </xsl:template>

</xsl:stylesheet>
