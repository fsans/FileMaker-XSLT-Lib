<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:fmp="http://www.filemaker.com/fmpxmlresult" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	exclude-result-prefixes="xsl fmp xsi">
	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>

	<xsl:template match="/fmp:FMPXMLRESULT">
		<ROOT>
			<xsl:for-each select="fmp:RESULTSET/fmp:ROW">
				<xsl:call-template name="getRecord">
					<xsl:with-param name="subset" select="." />
				</xsl:call-template>
			</xsl:for-each>
		</ROOT>
	</xsl:template>

	<xsl:template name="getRecord">
		<xsl:param name="subset"/>
		<RECORD>
			<xsl:for-each select="/fmp:FMPXMLRESULT/fmp:METADATA/fmp:FIELD">
				<xsl:variable name="pt" select="position()" />
				<xsl:element name="{@NAME}"> 
					<xsl:value-of select="$subset/fmp:COL[$pt]/fmp:DATA" />
				</xsl:element>
			</xsl:for-each>
		</RECORD>
	</xsl:template>

</xsl:stylesheet>