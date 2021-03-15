<?xml version="1.0" encoding="UTF-8"?>

<!--
  Generate the summary section.
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:date="http://exslt.org/dates-and-times"
  xmlns:riot-date="http://ci.riot-os.org/functions"
  xmlns:riot-icons="http://ci.riot-os.org/functions"
  xmlns:riot-robot="http://ci.riot-os.org/functions"
  extension-element-prefixes="date">

  <xsl:import href="../utils/robot.xsl" />
  <xsl:import href="../utils/date.xsl" />
  <xsl:import href="../components/label.xsl" />
  <xsl:import href="../components/commit-id-nav.xsl" />
  <xsl:import href="../components/progress-circle.xsl" />

  <xsl:template name="summary" match="/robot/suite" mode="summary">
    <xsl:variable name="starttime" select="riot-robot:parse-robot-datetime(./status/@starttime)" />
    <xsl:variable name="endtime" select="riot-robot:parse-robot-datetime(./status/@endtime)" />
    <xsl:variable name="duration" select="riot-date:time-diff($starttime, $endtime)" />

    <div class="flex flex-col sm:flex-row">
      <!-- Summary Table -->
      <div class="w-full sm:w-1/2 flex order-2 sm:order-1 p-3">
        <table class="c-table-vertical c-table-hover text-left w-full table-auto border-collapse">
          <tbody>
            <xsl:apply-templates mode="summary" select="/robot/suite/metadata/item[@name='RIOT-Board']">
              <xsl:with-param name="title" select="'Board'" />
            </xsl:apply-templates>
            <xsl:apply-templates mode="summary" select="/robot/suite/metadata/item[@name='RIOT-Application']">
              <xsl:with-param name="title" select="'Testsuite'" />
            </xsl:apply-templates>
            <xsl:apply-templates mode="summary" select="/robot/statistics/total/stat[text() = 'Critical Tests']">
              <xsl:with-param name="title" select="'Status'" />
            </xsl:apply-templates>
            <xsl:apply-templates mode="summary" select="$metadata-doc/metadata/RIOT/commit_id">
              <xsl:with-param name="title" select="'RIOT Version'" />
              <xsl:with-param name="version" select="$metadata-doc/metadata/RIOT/version" />
              <xsl:with-param name="url" select="$config-doc/config/url/riot_commit_url" />
            </xsl:apply-templates>
            <xsl:apply-templates mode="summary" select="$metadata-doc/metadata/RobotFW-Tests/commit_id">
              <xsl:with-param name="title" select="'HIL Tests Version'" />
              <xsl:with-param name="url" select="$config-doc/config/url/robot_fw_commit_url" />
            </xsl:apply-templates>
            <xsl:call-template name="summary-row-time">
              <xsl:with-param name="title" select="'Date / Time'" />
              <xsl:with-param name="starttime" select="$starttime" />
              <xsl:with-param name="duration" select="$duration" />
            </xsl:call-template>
          </tbody>
        </table>
      </div>
      <!-- Circle -->
      <div class="w-full sm:w-1/2 flex order-1 sm:order-2 items-center justify-around p-3">

        <xsl:variable name="tests-pass" select="/robot/statistics/total/stat/@pass" />
        <xsl:variable name="tests-fail" select="/robot/statistics/total/stat/@fail" />
        <xsl:variable name="tests-total" select="$tests-pass + $tests-fail" />
        <xsl:variable name="tests-percent" select="floor($tests-pass div $tests-total * 100)" />

        <div>
          <!-- call components/progress-circle -->
          <xsl:call-template name="progress-cirlce">
            <xsl:with-param name="progress" select="$tests-percent" />
            <xsl:with-param name="status">
              <xsl:choose>
                <xsl:when test="number($tests-fail) > 0">fail</xsl:when>
                <xsl:otherwise>pass</xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </div>
      </div>
    </div>
  </xsl:template>

  <!--
    Generate generic table row from text().
  -->
  <xsl:template name="summary-row" match="item|commit_timestamp" mode="summary">
    <xsl:param name="title" />

    <tr>
      <th><xsl:value-of select="$title" /></th>
      <td><xsl:value-of select="text()" /></td>
    </tr>
  </xsl:template>

  <!--
    Generate table row from 'metadata/*/commit_id'.
  -->
  <xsl:template name="summary-row-commit-id" match="commit_id" mode="summary">
    <xsl:param name="title" />
    <xsl:param name="version" />
    <xsl:param name="url" />

    <tr>
      <th><xsl:value-of select="$title" /></th>
      <td>
        <xsl:call-template name="commit-id-nav">
          <xsl:with-param name="commit-id" select="text()" />
          <xsl:with-param name="text" select="$version" />
          <xsl:with-param name="commit-timestamp" select="../commit_timestamp" />
          <xsl:with-param name="url" select="$url" />
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>

  <!--
    Generate table row from /robot/statistics/total/stat[text() = 'Critical Tests'].

    Dont't use 'suite/status' as it is set to 'FAIL' even if skipped tasks fail!
  -->
  <xsl:template name="summary-row-status" match="/robot/statistics/total/stat[text() = 'Critical Tests']" mode="summary">
    <xsl:param name="title" />

    <xsl:variable name="status">
      <xsl:choose>
        <xsl:when test="@fail = 0">PASS</xsl:when>
        <xsl:otherwise>FAIL</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <tr>
      <th><xsl:value-of select="$title" /></th>
      <td>
        <xsl:call-template name="label">
          <xsl:with-param name="text" select="$status" />
          <xsl:with-param name="status" select="$status" />
        </xsl:call-template>
      </td>
    </tr>
  </xsl:template>

  <!--
    Generate a table row with date and time information.
  -->
  <xsl:template name="summary-row-time">
    <xsl:param name="title" />
    <xsl:param name="starttime" />
    <xsl:param name="duration" />

    <tr>
      <th><xsl:value-of select="$title" /></th>
      <td>
        <div class="flex flex-col lg:flex-row flex-start">
          <span class="flex flex-start items-center mr-4 mb-1 lg:mb-0 ">
            <!-- call components/tooltip -->
            <xsl:call-template name="tooltip">
              <xsl:with-param name="content" select="'Date of testing'" />
            </xsl:call-template>
            <xsl:copy-of select="riot-icons:get-icon($icon-dir, 'calendar.svg', 'c-fill-gray w-4 h-4 mr-1', 'true')" />
            <xsl:value-of select="date:format-date($starttime, $date-formats/short)" />
          </span>
          <span class="flex flex-start items-center mr-4 mb-1 lg:mb-0 ">
            <!-- call components/tooltip -->
            <xsl:call-template name="tooltip">
              <xsl:with-param name="content" select="'Starttime of testing'" />
            </xsl:call-template>
            <xsl:copy-of select="riot-icons:get-icon($icon-dir, 'time.svg', 'c-fill-gray w-4 h-4 mr-1', 'true')" />
            <xsl:value-of select="date:format-date($starttime, $date-formats/time)" />
          </span>
          <span class="flex flex-start items-center mr-4 mb-1 lg:mb-0 ">
            <!-- call components/tooltip -->
            <xsl:call-template name="tooltip">
              <xsl:with-param name="content" select="'Duration of testing'" />
            </xsl:call-template>
            <xsl:copy-of select="riot-icons:get-icon($icon-dir, 'timer.svg', 'c-fill-gray w-4 h-4 mr-1', 'true')" />
            <xsl:value-of select="date:format-date($duration, $date-formats/duration)" />
          </span>
        </div>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
