<?xml version="1.0" encoding="UTF-8"?>

<!--
  Generate the log section.
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:date="http://exslt.org/dates-and-times"
  xmlns:riot-date="http://ci.riot-os.org/functions"
  xmlns:riot-icons="http://ci.riot-os.org/functions"
  xmlns:riot-robot="http://ci.riot-os.org/functions"
  extension-element-prefixes="date">

  <xsl:import href="../utils/robot.xsl" />
  <xsl:import href="../components/label.xsl" />

  <!--
    Suite/kw/test element
  -->
  <xsl:template name="log-element" match="suite|test|kw" mode="log">
    <xsl:param name="parent-id" select="''" />
    <xsl:param name="collapsed" select="'false'" />
    <xsl:param name="current-board" select="''" />
    <xsl:param name="current-testsuite" select="''" />

    <xsl:variable name="starttime" select="riot-robot:parse-robot-datetime(./status/@starttime)" />
    <xsl:variable name="endtime" select="riot-robot:parse-robot-datetime(./status/@endtime)" />
    <xsl:variable name="duration" select="riot-date:time-diff($starttime, $endtime)" />

    <xsl:variable name="css-id">
      <xsl:choose>
        <xsl:when test="@id != ''">
          <xsl:value-of select="@id" />
        </xsl:when> 
        <xsl:otherwise>
          <xsl:value-of select="$parent-id" />
          <xsl:text>-k</xsl:text>
          <xsl:number count="kw" level="single" format="1" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div id="{$css-id}" class="c-log c-log-{name()}">
      <!-- Collapsible Header -->
      <div type="button" aria-expanded="false" aria-controls="collapseExample" data-toggle="collapse" data-target="#div-{$css-id}">
        <!-- Manage collapsible classes -->
        <xsl:variable name="classes" select="'c-log-header'" />
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="$collapsed = 'true'">
              <xsl:value-of select="concat($classes, ' collapsed')" />
            </xsl:when> 
            <xsl:otherwise>
              <xsl:value-of select="$classes" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>

        <div class="inline-flex flex-1 items-center">
          <div class="flex items-center">
            <span class="mr-1 sm:mr-2">
              <!-- toggle icon -->
              <span class="c-log-close block ml-2">
                <xsl:copy-of select="riot-icons:get-icon($icon-url, 'minus-outline.svg', 'c-fill-gray w-4 h-4 mr-1', 'false')" />
              </span>
              <span class="c-log-open block ml-2">
                <xsl:copy-of select="riot-icons:get-icon($icon-url, 'add-outline.svg', 'c-fill-gray w-4 h-4 mr-1', 'false')" />
              </span>
            </span>
            <!-- include status label -->
            <xsl:apply-templates mode="log" select="./status/@status">
              <xsl:with-param name="element" select="name()" />
            </xsl:apply-templates>
          </div>
          <div class="hidden items-center md:flex md:flex-wrap md:items-start">
            <!-- title -->
            <xsl:apply-templates mode="log" select="@name" />
          </div>
        </div>
        <div class="no-trigger-collapse relative inline-flex items-center mr-2">
          <!-- include log-nav -->
          <xsl:call-template name="log-nav">
            <xsl:with-param name="css-id" select="$css-id" />
            <xsl:with-param name="duration" select="$duration" />
            <xsl:with-param name="current-board" select="$current-board" />
            <xsl:with-param name="current-testsuite" select="$current-testsuite" />
          </xsl:call-template>
        </div>
        <div class="w-full inline-flex items-center">
          <div class="flex md:hidden flex-wrap items-center ml-8">
            <!-- mobile title -->
            <xsl:apply-templates mode="log" select="@name" />
          </div>
        </div>
      </div>

      <!-- Collapsible Body -->
      <div id="div-{$css-id}">
        <!-- Manage collapsible classes -->
        <xsl:variable name="classes" select="'c-log-body collapse'" />
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="$collapsed = 'true'">
              <xsl:value-of select="$classes" />
            </xsl:when> 
            <xsl:otherwise>
              <xsl:value-of select="concat($classes, ' show')" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>

        <div class="c-log-container">
          <table class="text-left">
            <tbody>
              <xsl:apply-templates select="doc" mode="log-summary" />
              <xsl:apply-templates select="status" mode="log-summary" />
              <xsl:apply-templates select="@source" mode="log-summary" />
            </tbody>
          </table>
        </div>
        <xsl:if test="msg != ''">
          <div class="c-log-container">
            <div class="c-log-messages">
              <xsl:apply-templates select="msg" mode="log" />
            </div>
          </div>
        </xsl:if>

        <!--
          Apply this template on children recursively
        -->
        <xsl:apply-templates mode="log" select="./suite|./test|./kw">
          <xsl:with-param name="parent-id" select="$css-id" />
          <xsl:with-param name="collapsed" select="'true'" />
          <xsl:with-param name="current-board" select="$current-board" />
          <xsl:with-param name="current-testsuite" select="$current-testsuite" />
        </xsl:apply-templates>
      </div>
    </div>
  </xsl:template>

  <!--
    Generate label from status
  -->
  <xsl:template name="log-label-status" match="status/@status" mode="log">
    <xsl:param name="element" />

    <xsl:variable name="label-text">
      <xsl:choose>
        <xsl:when test="$element = 'kw'">keyword</xsl:when> 
        <xsl:otherwise><xsl:value-of select="$element" /></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="label">
      <xsl:with-param name="text" select="$label-text" /> 
      <xsl:with-param name="status" select="." />
      <xsl:with-param name="size" select="'sm'" />
    </xsl:call-template>
  </xsl:template>

  <!--
    Titles
  -->
  <xsl:template name="log-name-suite" match="suite/@name" mode="log">
    <span class="font-bold"><xsl:value-of select="current()" /></span>
  </xsl:template>

  <xsl:template name="log-name-test" match="test/@name" mode="log">
    <span class="font-bold"><xsl:value-of select="current()" /></span>
  </xsl:template>

  <xsl:template name="log-name-kw" match="kw/@name" mode="log">
    <span class="inline-flex flex-wrap mr-4">
      <xsl:if test="../@library != ''">
        <span>
          <xsl:value-of select="../@library" /><xsl:text>.</xsl:text>
        </span>
      </xsl:if>
      <span class="font-bold"><xsl:value-of select="current()" /></span>
    </span>
    <xsl:apply-templates mode="log" select="../arguments" />
  </xsl:template>

  <!--
    Log summary
  -->
  <xsl:template name="log-info-doc" match="doc" mode="log-summary">
    <tr>
      <th class="align-top pr-2"><span class="font-bold">Documentation: </span></th>
      <td><xsl:value-of select="text()" /></td>
    </tr>
  </xsl:template>

  <xsl:template name="log-info-source" match="@source" mode="log-summary">
    <tr>
      <th class="align-top pr-2"><span class="font-bold">Source: </span></th>
      <td><xsl:value-of select="." /></td>
    </tr>
  </xsl:template>

  <xsl:template name="log-info-start-end" match="status" mode="log-summary">
    <xsl:variable name="starttime" select="riot-robot:parse-robot-datetime(@starttime)" />
    <xsl:variable name="endtime" select="riot-robot:parse-robot-datetime(@endtime)" />
    <xsl:variable name="duration" select="riot-date:time-diff($starttime, $endtime)" />

    <tr>
      <th class="align-top pr-2"><span class="font-bold">Start / End: </span></th>
      <td>
        <xsl:value-of select="date:format-date($starttime, $date-formats/short)" />
        <xsl:text> - </xsl:text>
        <xsl:value-of select="date:format-date($starttime, $date-formats/time)" />
        <xsl:text> / </xsl:text>
        <xsl:value-of select="date:format-date($endtime, $date-formats/short)" />
        <xsl:text> - </xsl:text>
        <xsl:value-of select="date:format-date($endtime, $date-formats/time)" />
      </td>
    </tr>
  </xsl:template>

  <!--
    Log Navigation
  -->
  <xsl:template name="log-nav">
    <xsl:param name="css-id" />
    <xsl:param name="duration" select="'99:99:99.999'" />
    <xsl:param name="current-board" />
    <xsl:param name="current-testsuite" />

    <xsl:variable name="anchor-href" select="riot-robot:get-testsuite-page-url($current-board, $current-testsuite, concat('log', '#', $css-id))" />

    <div class="flex flex-row items-center">
      <div class="c-log-nav flex">
        <span class="c-log-toggle-children c-log-open-children block ml-2">
          <xsl:copy-of select="riot-icons:get-icon($icon-url, 'cheveron-outline-down.svg', 'c-fill-gray w-4 h-4 mr-1', 'false')" />
        </span>
        <span class="c-log-toggle-children c-log-close-children block ml-2">
          <xsl:copy-of select="riot-icons:get-icon($icon-url, 'cheveron-outline-up.svg', 'c-fill-gray w-4 h-4 mr-1', 'false')" />
        </span>
        <a class="inline-flex items-center" href="{$anchor-href}">
          <span class="block mr-4 ml-2">
            <xsl:copy-of select="riot-icons:get-icon($icon-url, 'link.svg', 'c-fill-gray w-4 h-4 mr-1', 'false')" />
          </span>
          <span class="sr-only">Link-to</span>
        </a>
      </div>
      <div>
        <span><xsl:value-of select="$duration" /></span>
      </div>
    </div>
  </xsl:template>

  <!-- optional keyword tags -->
  <xsl:template name="log-tags" match="tags" mode="log">
    <div>
      <xsl:apply-templates mode="log" select="./tag" />
    </div>
  </xsl:template>

  <!-- optional keyword tag -->
  <xsl:template name="log-tag" match="tags/tag" mode="log">
    <span class="font-bold mr-2"><xsl:value-of select="." /></span>
  </xsl:template>

  <!-- optional keyword arguments -->
  <xsl:template name="log-arguments" match="arguments" mode="log">
    <div class="inline-flex flex-wrap font-mono">
      <xsl:apply-templates mode="log" select="arg" />
    </div>
  </xsl:template>

  <!-- optional keyword argument -->
  <xsl:template name="log-arg" match="arg" mode="log">
    <span class="mr-2"><xsl:value-of select="." />
      <xsl:if test="position() != last()">
        <xsl:text>,</xsl:text>
      </xsl:if>
    </span>
  </xsl:template>

  <!-- optional keyword message -->
  <xsl:template name="log-msg" match="msg" mode="log">
    <xsl:variable name="datetime" select="riot-robot:parse-robot-datetime(@timestamp)" />

    <div class="c-log-message">
      <pre class="bg-gray-200 p-2 mr-4">
        <code class="inline-flex items-center w-full">
          <span class="mr-2">
            <xsl:value-of select="date:format-date($datetime, $date-formats/duration)" />
          </span>
          <span class="mr-2">
            <xsl:call-template name="label">
              <xsl:with-param name="text" select="@level" />
              <xsl:with-param name="status" select="@level" />
              <xsl:with-param name="size" select="'sm'" />
            </xsl:call-template>
          </span>
          <span class="mr-2"><xsl:value-of select="." /></span>
        </code>
      </pre>
    </div>
  </xsl:template>

</xsl:stylesheet>
