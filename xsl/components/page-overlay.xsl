<?xml version="1.0" encoding="UTF-8"?>

<!--
  Create a semi-transparent page overlay.

  If param 'remove-when-loaded' is 'true' the overlay is removed if the page
  is fully loaded. Set param 'spinner' to 'circle' or 'dots' to include an
  animated spinner.

  @see assets/css/components/page-overlay.css
  @see assets/javascript/components/page-overlay.js
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="page-overlay">
    <xsl:param name="spinner" />
    <xsl:param name="remove-when-loaded" />

    <div id="page-overlay">
      <xsl:if test="$remove-when-loaded = 'true'">
        <xsl:attribute name="class">remove-when-loaded</xsl:attribute>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="$spinner = 'circle'">
          <div id="spinner" class="lds-ring"><div></div><div></div><div></div><div></div></div>
        </xsl:when>
        <xsl:when test="$spinner = 'dots'">
          <div id="spinner" class="lds-ellipsis"><div></div><div></div><div></div><div></div></div>
        </xsl:when>
      </xsl:choose>
    </div>

  </xsl:template>

</xsl:stylesheet>
