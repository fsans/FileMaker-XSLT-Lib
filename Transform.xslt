<xsl:stylesheet version ="1.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method ="html" />

   <xsl:decimal-format name="dollars" decimal-separator="." grouping-separator="," minus-sign="-" zero-digit="0" digit="#" NaN="0.00"/>
   
  <!--=====================================-->
  <!-- Template that matches the root node -->
  <!--=====================================-->
  <xsl:template match ="/" >  
    <ROOT>
      <xsl:call-template name="texttorows" >
        <xsl:with-param name="StringToTransform" select="/ROOT" />
        <xsl:with-param name="RowNum" select="0"/>
      </xsl:call-template>
    </ROOT>
  </xsl:template>
  
  <!--===============================================-->
  <!-- Template to convert lines in the file to rows -->
  <!--===============================================-->
  <xsl:template name ="texttorows" >
    <xsl:param name ="StringToTransform" select ="''" />
    <xsl:param name ="RowNum"            select ="0" />

    <xsl:choose>
      <!--====================================-->
      <!-- string contains linefeed           -->
      <!--====================================-->
      <xsl:when test ="contains($StringToTransform,'&#xA;')" >
        <!--===================================-->
        <!-- Get everything up to the linefeed -->
        <!--===================================-->

    		<xsl:variable name="stringlen"><xsl:value-of select="string-length(substring-before($StringToTransform,'&#xA;'))"/>
		    </xsl:variable>

        <xsl:if test="$stringlen > 1">
          <ROW>
            <xsl:attribute name="RowNum"><xsl:value-of select="$RowNum"/></xsl:attribute>          
            <xsl:call-template name ="csvtoxml" >
              <xsl:with-param name ="StringToTransform" select ="substring-before($StringToTransform,'&#xA;')" />
            </xsl:call-template>
          </ROW>
        </xsl:if>


        <!--=================================================-->
        <!-- repeat for the remainder of the original string -->
        <!--=================================================-->
        <xsl:call-template name ="texttorows" >
          <xsl:with-param name ="StringToTransform" >
            <xsl:value-of select ="substring-after($StringToTransform,'&#xA;')" />
          </xsl:with-param>                
          <xsl:with-param name ="RowNum"  select="$RowNum + 1"/>
        </xsl:call-template>
      </xsl:when>
      
      <!--============================================-->
      <!-- string does not contain newline, ignore it -->
      <!--============================================-->
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
    
  
  <!--================================================-->
  <!-- Template to convert fields to XML nodes        -->
  <!--================================================-->
  <xsl:template name ="csvtoxml" >
    <xsl:param name ="StringToTransform" select ="''" />
    <xsl:param name ="FieldNum"          select ="1" />

    <xsl:choose>
      <!--=======================-->
      <!-- string contains comma -->
      <!--=======================-->
      <xsl:when test ="contains($StringToTransform,',')" >
        <!--======================================-->
        <!-- Get everything up to the first comma -->
        <!--======================================-->             
        <xsl:choose>
          <xsl:when test ="$FieldNum = 1">
            <NAME>
              <xsl:value-of select ="substring-before($StringToTransform,',')" />
            </NAME>
          </xsl:when>
          <xsl:when test ="$FieldNum = 2">
            <SOMEVALUE>
              <xsl:value-of select ="format-number(substring-before($StringToTransform,','),'#####0.00;-#####0.00','dollars')" />
            </SOMEVALUE>
          </xsl:when>
          <xsl:when test ="$FieldNum = 3">
            <SOMECODE>
              <xsl:value-of select ="substring-before($StringToTransform,',')" />
            </SOMECODE>
          </xsl:when>
          <xsl:otherwise>
            <SOMEDATE>
              <xsl:value-of select ="substring-before($StringToTransform,',')" />
            </SOMEDATE>
          </xsl:otherwise>
        </xsl:choose>
        
        <!--================================================-->
        <!-- repeat for the remainder of the original string-->
        <!--================================================-->
        <xsl:call-template name ="csvtoxml" >
          <xsl:with-param name ="StringToTransform" >
            <xsl:value-of select ="substring-after($StringToTransform,',')" />
          </xsl:with-param>

         <xsl:with-param name ="FieldNum"  select="$FieldNum + 1"/>
        </xsl:call-template>
      </xsl:when>
      
      <!--==========================================-->
      <!-- string does not contain comma, ignore it -->
      <!--==========================================-->
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
