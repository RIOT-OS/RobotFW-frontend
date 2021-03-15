<?xml version="1.0" encoding="UTF-8"?>

<!--
  Partial to generate a navbar.

  @depends_on $robot-doc
  @depends_on $page-title
  @depends_on $base-url
  @depends_on $static-url
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:func="http://exslt.org/functions"
  xmlns:riot-icons="http://ci.riot-os.org/functions"
  xmlns:riot-error="http://ci.riot-os.org/functions"
  xmlns:riot-robot="http://ci.riot-os.org/functions"
  extension-element-prefixes="func">

  <xsl:import href="../components/button.xsl" />
  <xsl:import href="../utils/error.xsl" />
  <xsl:import href="../utils/robot.xsl" />

  <!--
    Generate a navbar
  -->
  <xsl:template name="partial-navbar">
    <xsl:param name="page" />
    <xsl:param name="current-board" />
    <xsl:param name="current-testsuite" />

    <div class="h-full flex items-stretch bg-white border-b border-gray-200 shadow">
      <div class="c-container">
        <div class="h-full flex flex-col md:flex-row items-center">
          <!-- Logo -->
          <div class="flex flex-row w-full lg:w-1/3 h-full md:h-auto pl-6 pr-6 lg:pr-8">
            <div class="flex items-center w-4/5">
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="riot-robot:get-base-page-url('overview')" />
                </xsl:attribute>

                <img class="inline-block align-text-bottom h-10 w-auto" src="{$image-url}/riot.png"></img>
                <span class="c-font-family-miso text-2xl leading-none font-bold">
                  <xsl:value-of select="$page-title" />
                </span>
              </a>
            </div>
            <!-- Burger menu -->
            <xsl:if test="$page != 'overview'">
              <div class="w-1/5 flex justify-end items-center md:hidden">
                <button class="flex-inline lg:mr-6" type="button" data-toggle="collapse" data-target="#navbar-menu" aria-expanded="false" aria-controls="navbar-menu">
                  <img class="inline-block align-text-bottom h-10 w-auto" src="{$icon-url}/menu.svg"></img>
                </button>
              </div>
            </xsl:if>
          </div>
          <xsl:if test="$page != 'overview'">
            <xsl:variable name="page-button-text">
              <xsl:choose>
                <xsl:when test="$page = 'report'">Show log</xsl:when>
                <xsl:when test="$page = 'log'">Show report</xsl:when>
              </xsl:choose>
            </xsl:variable>
            <xsl:variable name="page-button-url">
              <xsl:choose>
                <xsl:when test="$page = 'report'">
                  <xsl:value-of select="riot-robot:get-testsuite-page-url($current-board, $current-testsuite, 'log')" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="riot-robot:get-testsuite-page-url($current-board, $current-testsuite, 'report')" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <!-- Navbar menu -->
            <div id="navbar-menu" class="collapse c-collapse-till-sm absolute md:relative w-full md:w-2/3 mt-16 md:mt-0 pl-6 pr-6 pt-4 md:pt-0 lg:pr-8">
              <div class="flex flex-col sm:flex-row items-center justify-end">
                <div class="w-full mb-2 sm:mb-0 sm:w-auto">
                  <!-- Report / Log switch -->
                  <xsl:call-template name="button">
                    <xsl:with-param name="element" select="'a'" />
                    <xsl:with-param name="button-text" select="$page-button-text" />
                    <xsl:with-param name="css-class" select="'c-button-primary'" />
                    <xsl:with-param name="href" select="$page-button-url" />
                  </xsl:call-template>
                </div>
                <div class="w-full mb-2 sm:mb-0 sm:w-auto">
                  <!-- Boards dropdown -->
                  <xsl:call-template name="navbar-dropdown">
                    <xsl:with-param name="current-board" select="$current-board" />
                    <xsl:with-param name="current-testsuite" select="$current-testsuite" />
                    <xsl:with-param name="button-text" select="$current-board" />
                    <xsl:with-param name="dropdown-content" select="'boards'" />
                  </xsl:call-template>
                </div>
                <div class="w-full mb-2 sm:mb-0 sm:w-auto">
                  <!-- Testsuites dropdown -->
                  <xsl:call-template name="navbar-dropdown">
                    <xsl:with-param name="current-board" select="$current-board" />
                    <xsl:with-param name="current-testsuite" select="$current-testsuite" />
                    <xsl:with-param name="button-text" select="$current-testsuite" />
                    <xsl:with-param name="dropdown-content" select="'applications'" />
                  </xsl:call-template>
                </div>
              </div>
            </div>
          </xsl:if>
        </div>
      </div>
    </div>
  
  </xsl:template>

  <!--
    Navbar dropdown-button
  -->
  <xsl:template name="navbar-dropdown">
    <xsl:param name="button-text" />
    <xsl:param name="dropdown-content" />
    <xsl:param name="current-board" />
    <xsl:param name="current-testsuite" />

    <xsl:variable name="css-id">
     <xsl:choose>
        <xsl:when test="$dropdown-content = 'boards'">navbar-dropdown-boards</xsl:when>
        <xsl:when test="$dropdown-content = 'applications'">navbar-dropdown-applications</xsl:when>
        <xsl:otherwise><xsl:copy-of select="riot-error:raise-error('Wrong param value: dropdown-content', 'yes')" /></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <div class="dropdown">
      <xsl:call-template name="button">
        <xsl:with-param name="css-id" select="$css-id" />  
        <xsl:with-param name="button-text" select="$button-text" />
        <xsl:with-param name="type" select="'dropdown'" />
        <xsl:with-param name="icon-filename" select="'cheveron-down.svg'" />
      </xsl:call-template>
      <div class="c-dropdown dropdown-menu dropdown-menu-right" aria-labelledby="{$css-id}">
        <!-- Choose which dropdown-menu content should be added -->
        <xsl:choose>
          <xsl:when test="$dropdown-content = 'boards'">
            <xsl:apply-templates mode="navbar" select="$robot-doc/result/boards/board">
              <xsl:with-param name="current-board" select="$current-board" />
              <!--
                Always link to the first testsuite of a specific boards as it is not guaranteed
                every suite exists for every board which would result in broken links. 
              -->
              <xsl:with-param name="current-testsuite" select="$robot-doc/result/boards/board[@name = $current-board]/testsuite[1]/@name" />
            </xsl:apply-templates>
          </xsl:when>
          <xsl:when test="$dropdown-content = 'applications'">
            <xsl:apply-templates mode="navbar" select="$robot-doc/result/boards/board[@name = $current-board]/testsuite">
              <xsl:with-param name="current-board" select="$current-board" />
              <xsl:with-param name="current-testsuite" select="$current-testsuite" />
            </xsl:apply-templates>
          </xsl:when> 
          <xsl:otherwise><xsl:copy-of select="riot-error:raise-error('Wrong param value: dropdown-content', 'yes')" /></xsl:otherwise>
        </xsl:choose>
      </div>
    </div>
  </xsl:template>


  <!--
    The boards dropdown-menu content
  -->
  <xsl:template match="board" mode="navbar">
    <xsl:param name="current-board" />
    <xsl:param name="current-testsuite" />

    <xsl:variable name="active-class">
      <xsl:if test="$current-board = @name">active</xsl:if>
    </xsl:variable>

    <a class="c-dropdown-item {$active-class}">
      <xsl:attribute name="href">
        <xsl:value-of select="riot-robot:get-testsuite-page-url(@name, $current-testsuite, 'report')" />
      </xsl:attribute>
      <span><xsl:value-of select="@name" /></span>
    </a>
  </xsl:template>


  <!--
    The testsuites dropdown-menu content
  -->
  <xsl:template match="testsuite" mode="navbar">
    <xsl:param name="current-board" />
    <xsl:param name="current-testsuite" />

    <xsl:variable name="active-class">
      <xsl:if test="$current-testsuite = @name">active</xsl:if>
    </xsl:variable>

    <xsl:variable name="status">
      <xsl:choose>
        <xsl:when test="@failures = '0'">PASS</xsl:when> 
        <xsl:otherwise>FAIL</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
  
    <a class="c-dropdown-item {$active-class}">
      <xsl:attribute name="href">
        <xsl:value-of select="riot-robot:get-testsuite-page-url($current-board, @name, 'report')" />
      </xsl:attribute>
      <span class="mr-4"><xsl:value-of select="@name" /></span>
      <xsl:call-template name="label">
        <xsl:with-param name="text" select="$status" />
        <xsl:with-param name="status" select="$status" />
        <xsl:with-param name="size" select="'sm'" />
      </xsl:call-template>
    </a>
  </xsl:template>

</xsl:stylesheet>
