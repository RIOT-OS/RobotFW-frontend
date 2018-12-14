<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html"/>

<xsl:template match="/">
  <html lang="en">
    <head>
      <!-- Required meta tags -->
      <meta charset="utf-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />

      <!-- Bootstrap CSS -->
      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous" />
      <title>RIOT HIL</title>
    </head>
    <body>
      <!-- Optional JavaScript -->
      <!-- jQuery first, then Popper.js, then Bootstrap JS -->
      <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
      <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
      <div class="container-fluid bg-dark text-light pt-4">
        <div class="row justify-content-center mx-auto">
          <img src="https://ci.riot-os.org/static/logo.png" alt="" height="58" />
          <h1 class="display-4">HIL Test Results</h1>
        </div> <!-- row -->
      <div class="row justify-content-center mx-auto">
	<p><span class="badge badge-info">Click on the progress bars to get detailed results</span></p>
      </div> <!-- row -->
      </div> <!-- container -->
      <div class="container py-3">
        <xsl:apply-templates select="//boards" />
      </div> <!-- row -->
      <!-- activate tooltips -->
      <script type="text/javascript">
        $(document).ready(function(){
          $('a[data-toggle=tooltip]').tooltip();
        });
      </script>
      <!-- enable line breaks in tooltips and align text left -->
      <style>
        .tooltip-inner {
          white-space:pre;
          max-width:none;
          text-align:left;
        }
      </style>
    </body>
  </html>
</xsl:template>

<xsl:template match="boards">
  <table class="table table-hover">
    <thead class="thead-light">
      <tr>
        <th class="border-right">Board</th>
        <!-- generate header from first board testsuites -->
        <xsl:for-each select="board[1]/testsuite">
        <th><xsl:value-of select="@name" /></th>
        </xsl:for-each>
      </tr> 
    </thead>
    <tbody>
      <xsl:for-each select="board">
      <tr>
        <th class="border-right" scope="row">
        <xsl:value-of select="@name" />
        </th>
        <xsl:for-each select="testsuite">
          <xsl:variable name="board" select="../@name"/>
          <xsl:variable name="suite" select="translate(@name,' ','_')"/>
          <xsl:variable name="pass" select="@tests - @failures"/>
          <xsl:variable name="total" select="@tests"/>
          <xsl:variable name="fails" select="@failures"/>
          <xsl:variable name="percent" select="$pass div $total * 100"/>
          <td>
            <a class="card-link" href="{$board}/{$suite}/report.html">
              <!-- show list of failed tests in tooltip, if any -->
              <xsl:if test="number($fails) &gt; 0">
                <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
                <xsl:attribute name="data-placement">bottom</xsl:attribute>
                <xsl:attribute name="data-html">true</xsl:attribute>
                <xsl:attribute name="title">
                  <xsl:value-of select="concat('Failed Tests:', '&#013;')" />
                  <xsl:for-each select="testcase">
                    <xsl:if test="failure">
                      <xsl:value-of select="concat('- ', @name, '&#013;')" />
                    </xsl:if>
                  </xsl:for-each>
                </xsl:attribute>
              </xsl:if>
              <div class="progress bg-danger position-relative">
                <div class="progress-bar bg-success" role="progressbar" style="width: {$percent}%" aria-valuenow="{$percent}" aria-valuemin="0" aria-valuemax="100" /> 
                <bold class="justify-content-center d-flex position-absolute w-100 text-light">(<xsl:value-of select="$pass" />/<xsl:value-of select="$total" />)</bold>
              </div>
            </a>
          </td>
        </xsl:for-each>
      </tr>
      </xsl:for-each>
    </tbody>
  </table> 
</xsl:template>

</xsl:stylesheet>
