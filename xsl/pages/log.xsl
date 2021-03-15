<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../partials/summary.xsl" />
  <xsl:import href="../partials/log.xsl" />

  <xsl:template name="page-overview" match="page/template[text() = 'page-log']" mode="call-page">
  <xsl:param name="context-node" />

    <xsl:for-each select="$context-node">

      <div id="content" class="c-page-log flex lg:max-w-screen-lg xl:max-w-screen-xl mx-auto">
        <div class="pt-4 mb-16 w-full">
          <!-- Summary -->
          <div class="flex">
            <div class="c-content-inner">
              <h1 class="flex-grow">Summary</h1>
              <hr class="my-4 border-b-2 border-gray-200" />
              <xsl:apply-templates mode="summary" select="/robot/suite" />
            </div>
          </div>
          <!-- Log -->
          <div class="flex">
            <div id="c-log-wrapper" class="c-content-inner">
              <h1>Log</h1>
              <hr class="my-4 border-b-2 border-gray-200" />
              <xsl:apply-templates mode="log" select="/robot/suite" />
            </div>
          </div>
        </div>
      </div>

    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>