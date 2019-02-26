<xsl:stylesheet version ="1.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method ="html" />
   
  <!--=====================================-->
  <!-- Template that matches the root node -->
  <!--=====================================-->
  <xsl:template match ="/" >  
    <ROOT>
      <xsl:call-template name="linestorows" >
        <xsl:with-param name="StringToTransform" select="/ROOT" />
        <xsl:with-param name="RowNum" select="0"/>
      </xsl:call-template>
    </ROOT>
  </xsl:template>
  
  <!--===============================================-->
  <!-- Template to convert lines in the file to rows -->
  <!--===============================================-->
  <xsl:template name ="linestorows" >
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
            <xsl:call-template name ="fieldstoxml" >
              <xsl:with-param name ="StringToTransform" select ="substring-before($StringToTransform,'&#xA;')" />
            </xsl:call-template>
          </ROW>
        </xsl:if>


        <!--=================================================-->
        <!-- repeat for the remainder of the original string -->
        <!--=================================================-->
        <xsl:call-template name ="linestorows" >
          <xsl:with-param name ="StringToTransform" >
            <xsl:value-of select ="substring-after($StringToTransform,'&#xA;')" />
          </xsl:with-param>                
          <xsl:with-param name ="RowNum"  select="$RowNum + 1"/>
        </xsl:call-template>
      </xsl:when>
      
      <!--============================================-->
      <!-- string does not contain newline, ignore it -->
      <!-- (uncomment to output it)                   -->
      <!--============================================-->
      <xsl:otherwise>
      <!--
        <ROW>
          <xsl:call-template name ="fieldstoxml" >
            <xsl:with-param name ="StringToTransform" select ="$StringToTransform" />
          </xsl:call-template>
        </ROW>
        -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
    
  
  <!--================================================-->
  <!-- Template to convert fields to XML nodes        -->
  <!--================================================-->
  <xsl:template name ="fieldstoxml" >
    <xsl:param name ="StringToTransform" select ="''" />
    <xsl:param name ="FieldNum"          select ="1" />

    <xsl:choose>
      <!--==========================-->
      <!-- string contains linefeed -->
      <!--==========================-->
      <xsl:when test ="contains($StringToTransform,'|')" >
        <!--======================================-->
        <!-- Get everything up to the first comma -->
        <!--======================================-->
        <elem>
          <xsl:value-of select ="substring-before($StringToTransform,'|')" />
        </elem>
        
        <!--================================================-->
        <!-- repeat for the remainder of the original string-->
        <!--================================================-->
        <xsl:call-template name ="fieldstoxml" >
          <xsl:with-param name ="StringToTransform" >
            <xsl:value-of select ="substring-after($StringToTransform,'|')" />
          </xsl:with-param>

         <xsl:with-param name ="FieldNum"  select="$FieldNum + 1"/>
        </xsl:call-template>
      </xsl:when>
      
      <!--==========================================-->
      <!-- string does not contain comma, ignore it -->
      <!-- (uncomment to output it)                 -->
      <!--==========================================-->
      <xsl:otherwise>
      <!--
        <elem>
          <xsl:value-of select ="$StringToTransform" />
        </elem>
      -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
