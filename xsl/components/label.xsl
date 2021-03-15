<?xml version="1.0" encoding="UTF-8"?>

<!--
  Create a label (a.k.a pill)

  @see assets/css/components/label.css
  @see assets/javascript/components/label.js
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:riot-icons="http://ci.riot-os.org/functions">

  <xsl:template name="label">
    <xsl:param name="text" />
    <xsl:param name="status" />
    <xsl:param name="closeable" select="'false'" />
    <xsl:param name="size" select="'md'" />

    <xsl:variable name="status-class">
      <xsl:choose>
        <xsl:when test="$status='PASS'">c-label-pass</xsl:when>
        <xsl:when test="$status='FAIL'">c-label-fail</xsl:when>
        <xsl:when test="$status='INFO'">c-label-info</xsl:when>
        <xsl:otherwise>c-label-default</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="size-class">
      <xsl:choose>
        <xsl:when test="$size='sm'">c-label-sm</xsl:when>
        <xsl:when test="$size='md'">c-label-md</xsl:when>
        <xsl:when test="$size='lg'">c-label-lg</xsl:when>
        <xsl:otherwise>c-label-md</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div class="c-label {$status-class} {$size-class}">
      <xsl:value-of select="$text" />
      <xsl:if test="$closeable = 'true'">
        <div class="c-label-close z-50 cursor-pointer">
          <xsl:copy-of select="riot-icons:get-icon($icon-dir, 'close.svg', 'fill-current w-3 h-3 ml-3', 'true')" />
        </div>
      </xsl:if>
    </div>
  </xsl:template>

</xsl:stylesheet>
