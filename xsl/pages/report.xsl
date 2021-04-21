<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../partials/summary.xsl" />
  <xsl:import href="../partials/statistics.xsl" />

  <xsl:template name="page-report" match="page/template[text() = 'page-report']" mode="call-page">
    <xsl:param name="context-node" />

    <xsl:for-each select="$context-node">

      <xsl:variable name="current-board" select="/robot/suite/metadata/item[@name='RIOT-Board']" />
      <xsl:variable name="current-testsuite" select="/robot/suite/metadata/item[@name='RIOT-Application']" />

      <div id="content" class="flex max-w-screen-xl mx-auto">

        <div class="pt-4 mb-16 w-full">
          <!-- Summary -->
          <div class="flex">
            <div class="c-content-inner">
              <h1 class="flex-grow">Summary</h1>
              <hr class="my-4 border-b-2 border-gray-200" />
              <xsl:apply-templates mode="summary" select="/robot/suite" />
            </div>
          </div>
          <!-- Statistics -->
          <div class="flex">
            <div class="c-content-inner">
              <h1>Statistics</h1>
              <hr class="my-4 border-b-2 border-gray-200" />
              <xsl:apply-templates mode="statistics" select="/robot" />
            </div>
          </div>
          <!--
            Plots

            This does not work with the original plotly snippets as it contains malformed <br> instead of <br />
          -->
          <xsl:if test="$pages/page[@name = 'report']/testsuites/testsuite[@name = $current-testsuite]">
            <div class="flex">
              <div class="c-content-inner">
                <h1>Plots</h1>
                <hr class="my-4 border-b-2 border-gray-200" />
                <xsl:for-each select="$pages/page[@name = 'report']/testsuites/testsuite[@name = $current-testsuite]/plots/plot">
                  <div class="c-plotly-container">
                    <xsl:copy-of select="document(concat($xml-basedir, '/', $current-board, '/', $current-testsuite, '/includes/', @name,'.html'))" />
                  </div>
                </xsl:for-each>
              </div>
            </div>
          </xsl:if>
        </div>
      </div>

    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>