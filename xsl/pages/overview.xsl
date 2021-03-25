<?xml version="1.0" encoding="UTF-8"?>

<!--
  Styles the Overview Page (Grid View)
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common"
  xmlns:riot-icons="http://ci.riot-os.org/functions"
  xmlns:riot-robot="http://ci.riot-os.org/functions"
  extension-element-prefixes="exsl">

  <xsl:import href="../components/progress-bar.xsl" />
  <xsl:import href="../components/label.xsl" />
  <xsl:import href="../utils/robot.xsl" />

  <xsl:template name="page-overview" match="page/template[text() = 'page-overview']" mode="call-page">
    <xsl:param name="context-node" />

    <xsl:for-each select="$context-node">
      <!-- Calculate the height without the navbar -->
      <div id="content" class="c-page-overview h-full overflow-hidden flex flex-col" style="height: calc(100% - 4em);">

        <!-- TODO: Remove or move
        <div class="c-label-wrapper flex justify-around py-4">
          <xsl:call-template name="label">
            <xsl:with-param name="text" select="'Click on the progress bars to get detailed results'" />
            <xsl:with-param name="status" select="'INFO'" />
            <xsl:with-param name="closeable" select="'true'" />
          </xsl:call-template>
        </div>
        -->

        <div class="h-full w-full relative">
          <div class="overflow-auto absolute flex flex-col top-0 left-0 bottom-0 right-0">
            <!-- grid -->
            <xsl:apply-templates mode="overview-grid" select="/result/boards" />
            <!-- sidebar -->
            <div id="content-sidebar" class="shadow collapse">
              <div class="c-content-sidebar-header flex">
                <button class="c-content-sidebar-close m-4" type="button" data-toggle="collapse" data-target="#content-sidebar" aria-expanded="false" aria-controls="content-sidebar">
                  <xsl:copy-of select="riot-icons:get-icon($icon-dir, 'close.svg', 'w-4 h-4', 'true')" />
                  <span class="sr-only">Close</span>
                </button>
                <div id="content-sidebar-title"></div> <!-- populated with js, see overview.js -->
              </div>
              <div class="c-content-sidebar-body">
                <div class="c-content-sidebar-body-inner">
                  <xsl:apply-templates mode="overview-sidebar" select="/result/boards" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </xsl:for-each>
  </xsl:template>

  <!--
    Generate a table from the 'boards' element
  -->
  <xsl:template match="boards" mode="overview-grid">
    <xsl:variable name="all-testsuites" select="riot-robot:get-all-testsuites($robot-doc/result/boards)" />
    <table class="table-auto border-collapse w-full text-center">
      <thead>
        <tr class="mb-4">
          <th class="text-left sticky left-0 top-0 z-30">Board</th>
          <xsl:for-each select="exsl:node-set($all-testsuites)/testsuites/*">
            <th class="sticky top-0 z-20">
              <xsl:value-of select="substring(current(), 7)" /> <!-- remove 'tests_' prefix -->
            </th>
          </xsl:for-each>
        </tr>
      </thead>
      <tbody class="h-full">
        <xsl:for-each select="board">
          <xsl:variable name="board" select="current()"/>
          <tr>
            <th class="sticky">
              <xsl:value-of select="@name" />
            </th>
            <xsl:for-each select="exsl:node-set($all-testsuites)/testsuites/*">
              <xsl:variable name="testsuite" select="$board/testsuite[@name = current()]"/>
              <xsl:choose>
                <xsl:when test="$testsuite/@name = current()">
                  <xsl:apply-templates mode="overview-grid" select="$testsuite"/>
                </xsl:when>
                <xsl:otherwise>
                  <td>
                    <div class="c-cell">
                      <xsl:call-template name="label">
                        <xsl:with-param name="text" select="'NO RESULTS'" />
                        <xsl:with-param name="size" select="'sm'" />
                      </xsl:call-template>
                    </div>
                  </td>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>

  <!--
    Generate table cells from the 'testsuite' element
  -->
  <xsl:template match="testsuite" mode="overview-grid">

    <xsl:variable name="board" select="../@name"/>
    <xsl:variable name="suite" select="translate(@name,' ','_')"/>
    <xsl:variable name="pass" select="@tests - @failures - @skipped"/>
    <xsl:variable name="total" select="@tests"/>
    <xsl:variable name="fails" select="@failures"/>
    <xsl:variable name="skips" select="@skipped"/>
    <xsl:variable name="pass_percent" select="$pass div $total * 100"/>
    <xsl:variable name="fail_percent" select="$fails div $total * 100"/>
    <xsl:variable name="skip_percent" select="$skips div $total * 100"/>

    <td>
      <div class="c-cell block">
        <div class="block relative">

          <!-- call components/progress-bar -->
          <div class="px-4 py-2">
            <xsl:call-template name="progress-bar">
              <xsl:with-param name="total" select="$total" />
              <xsl:with-param name="pass" select="$pass" />
              <xsl:with-param name="fails" select="$fails" />
              <xsl:with-param name="skips" select="$skips" />
            </xsl:call-template>
          </div>

          <div class="c-cell-overlay">
            <div class="c-cell-overlay-nav">
              <div class="c-cell-overlay-nav-view" title="Show report" data-toggle="tooltip" data-placement="bottom" data-delay="150">
                <a class="block">
                  <xsl:attribute name="href">
                    <xsl:value-of select="riot-robot:get-testsuite-page-url($board, $suite, 'report')" />
                  </xsl:attribute>
                  <xsl:copy-of select="riot-icons:get-icon($icon-dir, 'chart-pie.svg', 'w-4 h-4 fill-current', 'true')" />
                </a>
              </div>
              <div class="c-cell-overlay-nav-sidebar" title="Toggle sidebar" data-toggle="tooltip" data-placement="bottom" data-delay="150">
                <a class="block relative" data-toggle="details-sidebar" data-board="{$board}" data-suite="{$suite}" role="button" aria-expanded="false" href="#sidebar-panel-{$board}-{$suite}" aria-controls="#sidebar-panel-{$board}-{$suite}">
                  <xsl:copy-of select="riot-icons:get-icon($icon-dir, 'navigation-more.svg', 'c-icon-open w-4 h-4 fill-current', 'true')" />
                  <xsl:copy-of select="riot-icons:get-icon($icon-dir, 'close.svg', 'c-icon-close w-4 h-4 fill-current hidden', 'true')" />
                </a>
              </div>
            </div>
            <div class="c-cell-overlay-nav-mobile hidden">
              <a class="block relative" data-toggle="details-sidebar" data-board="{$board}" data-suite="{$suite}" role="button" aria-expanded="false" href="#sidebar-panel-{$board}-{$suite}" aria-controls="#sidebar-panel-{$board}-{$suite}"></a>
            </div>
          </div>
        </div>
      </div>
    </td>
  </xsl:template>

  <!--
    Generate the sidebar
  -->
  <xsl:template match="testsuite" mode="overview-sidebar">
    <xsl:variable name="board" select="../@name"/>
    <xsl:variable name="suite" select="translate(@name,' ','_')"/>
    <xsl:variable name="pass" select="@tests - @failures - @skipped"/>
    <xsl:variable name="total" select="@tests"/>
    <xsl:variable name="fails" select="@failures"/>
    <xsl:variable name="skips" select="@skipped"/>
    <xsl:variable name="pass_percent" select="$pass div $total * 100"/>
    <xsl:variable name="fail_percent" select="$fails div $total * 100"/>
    <xsl:variable name="skip_percent" select="$skips div $total * 100"/>

    <xsl:call-template name="overview-sidebar-content">
      <xsl:with-param name="board" select="$board" />
      <xsl:with-param name="suite" select="$suite" />
      <xsl:with-param name="data-toggle" select="'tooltip'" />
      <xsl:with-param name="data-placement" select="'bottom'" />
      <xsl:with-param name="data-html" select="'true'" />
      <xsl:with-param name="fails" select="$fails" />
      <xsl:with-param name="skips" select="$skips" />
    </xsl:call-template>
  </xsl:template>

  <!--
    Generate the sidebar content panels
  -->
  <xsl:template name="overview-sidebar-content">
    <xsl:param name="board" />
    <xsl:param name="suite" />
    <xsl:param name="data-toggle" />
    <xsl:param name="data-placement" />
    <xsl:param name="data-html" />
    <xsl:param name="skips" />
    <xsl:param name="fails" />

    <div id="sidebar-panel-{$board}-{$suite}" class="c-sidebar-panel collapse">
      <div class="c-sidebar-panel-buttons">
        <div class="c-inline-buttons c-inline-buttons-centered">
          <xsl:call-template name="button">
            <xsl:with-param name="element" select="'a'" />
            <xsl:with-param name="button-text" select="'Show Report'" />
            <xsl:with-param name="css-class" select="'c-button-primary'" />
            <xsl:with-param name="href" select="riot-robot:get-testsuite-page-url($board, $suite, 'report')" />
          </xsl:call-template>
          <xsl:call-template name="button">
            <xsl:with-param name="element" select="'a'" />
            <xsl:with-param name="button-text" select="'Show Log'" />
            <xsl:with-param name="css-class" select="'c-button-primary'" />
            <xsl:with-param name="href" select="riot-robot:get-testsuite-page-url($board, $suite, 'log')" />
          </xsl:call-template>
        </div>
      </div>
      <!-- Show status labels with skip and failure count -->
      <div class="c-sidebar-panel-status">
        <xsl:choose>
          <xsl:when test="number($fails) > 0">
            <!-- failed -->
            <div>
              <xsl:call-template name="label">
                <xsl:with-param name="text" select="'FAIL'" />
                <xsl:with-param name="status" select="'FAIL'" />
                <xsl:with-param name="size" select="'sm'" />
              </xsl:call-template>
              <span class="font-bold"><xsl:value-of select="number($fails)" /> tests failed</span>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <!-- passed -->
            <div>
              <xsl:call-template name="label">
                <xsl:with-param name="text" select="'PASS'" />
                <xsl:with-param name="status" select="'PASS'" />
                <xsl:with-param name="size" select="'sm'" />
              </xsl:call-template>
              <span class="font-bold">All tests passed</span>
            </div>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="number($skips) > 0">
          <!-- skipped -->
          <div>
            <xsl:call-template name="label">
              <xsl:with-param name="text" select="'SKIP'" />
              <xsl:with-param name="status" select="'DEFAULT'" />
              <xsl:with-param name="size" select="'sm'" />
            </xsl:call-template>
            <span class="font-bold"><xsl:value-of select="number($skips)" /> tests skipped</span>
          </div>
        </xsl:if>
      </div>
      <!-- List failed and skipped tests -->
      <xsl:if test="(number($fails) > 0) or (number($skips) > 0)">
        <div class="c-sidebar-panel-details">
          <xsl:if test="number($fails) > 0">
            <!-- failed -->
            <span class="font-bold">Failed Tests</span>
            <div class="mb-2">
              <ul class="ml-2 list-inside list-disc">
                <xsl:for-each select="testcase">
                  <xsl:if test="failure">
                    <li><xsl:value-of select="@name" /></li>
                  </xsl:if>
                </xsl:for-each>
              </ul>
            </div>
          </xsl:if>
          <xsl:if test="number($skips) > 0">
            <!-- skipped -->
            <span class="font-bold">Skipped Tests</span>
            <div class="mb-2">
              <ul class="ml-2 list-inside list-disc">
                <xsl:for-each select="testcase">
                  <xsl:if test="skipped">
                    <li><xsl:value-of select="@name" /></li>
                  </xsl:if>
                </xsl:for-each>
              </ul>
            </div>
          </xsl:if>
        </div>
      </xsl:if>
    </div>
  </xsl:template>

</xsl:stylesheet>
