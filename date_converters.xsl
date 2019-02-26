<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"

	xmlns:date="http://exslt.org/dates-and-times"
	extension-element-prefixes="date"

    exclude-result-prefixes="xsl xsi">
	
<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration='yes' />



<xsl:variable name="rdate" select="String(Thu, 22 Mar 2012 17:07:03 +0100)"/>

<xsl:template match="/">
	<dates>

		<dateout>
			<xsl:call-template name="parseDate">
				<xsl:with-param name="article" select="."/>
			</xsl:call-template>
		</dateout>

	</dates>

</xsl:template>	



	<!-- Date parser -->

	<xsl:template name="parseDate">
		<xsl:param name="thedate" />
		<xsl:variable name="year"><xsl:value-of select="substring($thedate,1,4)"/></xsl:variable>
		<xsl:variable name="month"><xsl:value-of select="substring($thedate,6,2)"/></xsl:variable>
		<xsl:variable name="day"><xsl:value-of select="substring($thedate,9,2)"/></xsl:variable>
		<xsl:variable name="hour"><xsl:value-of select="substring($thedate,12,2)"/></xsl:variable>
		<xsl:variable name="minute"><xsl:value-of select="substring($thedate,15,2)"/></xsl:variable>
		<xsl:variable name="second"><xsl:value-of select="substring($thedate,18,2)"/></xsl:variable>
		<xsl:value-of select="concat($day,'/',$month,'/',$year,' ',$hour,':',$minute,':',$second)"/>
	</xsl:template>





<xsl:template name="RFC822toISO8601">

	<xsl:param name="datetime"/>

	<xsl:variable name="year" 	select="date:year($datetime)" />

	<xsl:variable name="month" >
		<xsl:call-template name="padd">
             <xsl:with-param name="str" select="date:month-in-year($datetime)" />
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="day" >
		<xsl:call-template name="padd">
             <xsl:with-param name="str" select="date:day-in-month($datetime)" />
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="hour" 	select="date:hour-in-day($datetime)" />

	<xsl:variable name="minute" >
		<xsl:call-template name="padd">
             <xsl:with-param name="str" select="date:minute-in-hour($datetime)" />
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="zone" select="string('Local Time')" />

	<xsl:variable name="amhour">
		<xsl:choose>
			<xsl:when test="$hour > 12">
				<xsl:call-template name="padd">
                  <xsl:with-param name="str" select="$hour mod 12" />
				</xsl:call-template>
			</xsl:when>
				
			<xsl:otherwise>
				<xsl:call-template name="padd">
                  <xsl:with-param name="str" select="$hour" />
               </xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="midday">
		<xsl:choose>
			<xsl:when test="string($hour) = 'NaN'" />
			<xsl:when test="$hour >= 12">PM</xsl:when>
			<xsl:otherwise>AM</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- "'MM/dd/yyyy hh:mm a zzzz'" -->

	<xsl:value-of select="concat($month,'/',$day,'/',$year,' ',$amhour,':',$minute,' ',$midday,' ',$zone)"/>

</xsl:template>

<xsl:template name="padd">
	<xsl:param name="str"/>
	<xsl:variable name="fill" select="00" />
	<xsl:variable name="arg" select="concat($fill,$str)" />
	<xsl:variable name="start" select="string-length($arg)-1" />
	<xsl:value-of select="substring($arg, $start , 2)" />
</xsl:template>

</xsl:stylesheet>