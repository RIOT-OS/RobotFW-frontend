<?xml version="1.0" encoding="UTF-8"?>

<!--
  Generate the statistics section.
  As '/robot/statistics' is limited in detail (e.g. skips), the sub-suite
  statistics are fetched from 'suite/suite/test'.
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:date="http://exslt.org/dates-and-times"
  xmlns:func="http://exslt.org/functions"
  xmlns:riot-robot="http://ci.riot-os.org/functions"
  extension-element-prefixes="date func">

  <xsl:import href="../components/progress-bar.xsl" />
  <xsl:import href="../utils/robot.xsl" />

  <xsl:template name="statistics" match="/robot" mode="statistics">

    <div class="flex justify-between p-3">
      <table class="c-table-responsive">
        <thead>
          <xsl:for-each select="suite|suite/suite">
            <tr class="c-table-responsive-row">
              <th>Name</th>
              <th>Total</th>
              <th>Pass</th>
              <th>Fail</th>
              <th>Skip</th>
              <th><span class="invisible">Distribution</span></th>
            </tr>
          </xsl:for-each>
        </thead>
        <tbody class="flex-1 sm:flex-none">
          <!--
            Apply for sub-suites first. The template for the main-suite is applied
            at the end, because it displays the summary in the last row.
          -->
          <xsl:apply-templates mode="statistics" select="./suite/suite" />
          <xsl:apply-templates mode="statistics" select="./suite" />
        </tbody>
      </table>
    </div>
  </xsl:template>

  <!--
    Aggregate 'test' results for each sub-suite and generates a table row.
  -->
  <xsl:template name="statistics-suite" match="suite/suite" mode="statistics">
    <xsl:variable name="current-board" select="../meta[@name='RIOT-Board']" />
    <xsl:variable name="current-testsuite" select="../meta[@name='RIOT-Application']" />

    <xsl:variable name="pass">
      <xsl:value-of select="count(./test/status[@status = 'PASS'])"/>
    </xsl:variable>

    <xsl:variable name="fail">
      <xsl:value-of select="count(./test/status[@status = 'FAIL'])"/>
    </xsl:variable>

    <xsl:variable name="skips">
      <xsl:value-of select="count(./test/status[@status = 'SKIP'])"/>
    </xsl:variable>

    <xsl:variable name="total">
      <xsl:value-of select="$pass + $fail + $skips"/>
    </xsl:variable>

    <tr class="c-table-responsive-row">
      <td>
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="riot-robot:get-testsuite-page-url($current-board, $current-testsuite, concat('log#', @id))" />
          </xsl:attribute>
          <xsl:value-of select="@name" />
        </a>
      </td>
      <td><xsl:value-of select="$total" /></td>
      <td><xsl:value-of select="$pass" /></td>
      <td><xsl:value-of select="$fail" /></td>
      <td><xsl:value-of select="$skips" /></td>
      <td>
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="riot-robot:get-testsuite-page-url($current-board, $current-testsuite, concat('log#', @id))" />
          </xsl:attribute>

          <!-- call components/progress-bar -->
          <xsl:call-template name="progress-bar">
            <xsl:with-param name="total" select="$total" />
            <xsl:with-param name="pass" select="$pass" />
            <xsl:with-param name="fails" select="$fail" />
            <xsl:with-param name="skips" select="$skips" />
          </xsl:call-template>
        </a>
      </td>
    </tr>
  </xsl:template>

  <!--
    Generate '/robot/statistics' as a table row.
  -->
  <xsl:template name="statistics-summary" match="suite" mode="statistics">

    <xsl:variable name="pass">
      <xsl:value-of select="/robot/statistics/total/stat[text() = 'All Tests']/@pass" />
    </xsl:variable>

    <xsl:variable name="fail">
      <xsl:value-of select="sum(/robot/statistics/total/stat[text() = 'All Tests']/@fail)" />
    </xsl:variable>

    <xsl:variable name="skips">
      <xsl:value-of select="sum(/robot/statistics/total/stat[text() = 'All Tests']/@skip)" />
    </xsl:variable>

    <xsl:variable name="total">
      <xsl:value-of select="$pass + $fail + $skips" />
    </xsl:variable>

    <tr class="c-table-responsive-row">
      <td><xsl:text>All Tests</xsl:text></td>
      <td><xsl:value-of select="$total" /></td>
      <td><xsl:value-of select="$pass" /></td>
      <td><xsl:value-of select="$fail" /></td>
      <td><xsl:value-of select="$skips" /></td>
      <td>
        <!-- call components/progress-bar -->
        <xsl:call-template name="progress-bar">
          <xsl:with-param name="total" select="$total" />
          <xsl:with-param name="pass" select="$pass" />
          <xsl:with-param name="fails" select="$fail" />
          <xsl:with-param name="skips" select="$skips" />
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
