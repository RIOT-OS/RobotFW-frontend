<?xml version="1.0" encoding="UTF-8"?>

<!--
  Displays a shortened commit-id with with a timestamp and
  a copy-to-clipboard button.

  @see assets/css/components/commit-id-nav.css
  @see assets/javascript/components/commit-id-nav.js
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:date="http://exslt.org/dates-and-times"
  xmlns:riot-date="http://ci.riot-os.org/functions"
  xmlns:riot-icons="http://ci.riot-os.org/functions"
  extension-element-prefixes="date">

  <xsl:import href="./tooltip.xsl"/>

  <!--
    This component displays a short commit ID or version string

    @see assets/javascript/components/commit-id-nav/
    @see assets/css/components/commit-id-nav.css
  -->

  <xsl:template name="commit-id-nav">
    <xsl:param name="commit-id" />
    <xsl:param name="text" select="''" />
    <xsl:param name="commit-timestamp" select="''" />
    <xsl:param name="url" select="''" />

    <xsl:variable name="commit-id-short" select="substring($commit-id, 1, 10)" />

    <xsl:variable name="content-inner">
      <xsl:choose>
        <xsl:when test="$text != ''">
          <span class="c-copy-content-inner">
            <xsl:value-of select="$text" />
            <span class="c-copy-inner-value hidden"><xsl:value-of select="$commit-id-short" /></span>
          </span>
        </xsl:when>
        <xsl:otherwise>
          <span class="c-copy-content-inner c-copy-inner-value"><xsl:value-of select="$commit-id-short" /></span>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div class="c-commit-id-nav flex flex-start items-center">
      <span class="mr-4">
        <xsl:choose>
          <xsl:when test="$url != ''">
            <a class="c-copy-content" target="_blank">
              <xsl:attribute name="href">
                <xsl:value-of select="concat($url, $commit-id)" />
              </xsl:attribute>
              <xsl:copy-of select="$content-inner" />
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy-of select="$content-inner" />
          </xsl:otherwise>
        </xsl:choose>
      </span>
      <div class="c-commit-id-nav-buttons">
        <!-- Copy to clipboard -->
        <span class="c-copy-to-clipboard mr-2 cursor-pointer">
          <!-- call components/tooltip -->
          <xsl:call-template name="tooltip">
            <xsl:with-param name="content" select="'Copy commit ID'" />
          </xsl:call-template>
          <xsl:copy-of select="riot-icons:get-icon($icon-dir, 'clipboard.svg', 'c-fill-gray w-4 h-4', 'true')" />
        </span>
        <!-- Commit timestamp -->
        <xsl:if test="$commit-timestamp != ''">
          <xsl:variable name="commit-date" select="date:format-date($commit-timestamp, $date-formats/short)" />
          <xsl:variable name="commit-time" select="date:format-date($commit-timestamp, $date-formats/time)" />

          <span class="mr-2">
            <!-- call components/tooltip -->
            <xsl:call-template name="tooltip">
              <xsl:with-param name="content" select="concat($commit-date, ' | ', $commit-time)" />
            </xsl:call-template>
            <xsl:copy-of select="riot-icons:get-icon($icon-dir, 'information-outline.svg', 'c-fill-gray w-4 h-4', 'true')" />
          </span>
        </xsl:if>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
