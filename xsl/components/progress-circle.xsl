<?xml version="1.0" encoding="UTF-8"?>

<!--
  Create a circle-shaped progress bar with percentage display.

  @see assets/css/components/progress-cirlce.css
  @see assets/css/vendor/cirlce.css
  @see https://github.com/afuersch/css-percentage-circle
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="progress-cirlce">
    <xsl:param name="progress" />
    <xsl:param name="status" />

    <div class="c100 p{$progress} big green center">
        <span><xsl:value-of select="$progress" />%</span>
        <div class="slice">
          <div class="bar"></div>
          <div class="fill"></div>
        </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
