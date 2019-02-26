<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:fmp="http://www.filemaker.com/fmpxmlresult" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	exclude-result-prefixes="xsl fmp">
	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>

	<xsl:template match="/fmp:FMPXMLRESULT">
		<root>
			<nodeSet>
				<xsl:attribute name="error">
					<xsl:value-of select="fmp:ERRORCODE"/>
				</xsl:attribute>

				<xsl:attribute name="records">
					<xsl:value-of select="fmp:DATABASE/@RECORDS"/>
				</xsl:attribute>

				<xsl:attribute name="found">
					<xsl:value-of select="fmp:RESULTSET/@FOUND"/>
				</xsl:attribute>

				<xsl:for-each select="fmp:RESULTSET/fmp:ROW">
					<xsl:call-template name="getRecord">
						<xsl:with-param name="subset" select="." />
						<xsl:with-param name="modid" select="@MODID" />
						<xsl:with-param name="recordid" select="@RECORDID" />
					</xsl:call-template>
				</xsl:for-each>
			</nodeSet>
		</root>
	</xsl:template>

	<xsl:template name="getRecord">
		<xsl:param name="subset"/>
		<xsl:param name="modid"/>
		<xsl:param name="recordid"/>
		<node>

			<xsl:element name="modid">
				<xsl:value-of select="$modid"/>
			</xsl:element>
			
			<xsl:element name="recordid">
				<xsl:value-of select="$recordid"/>
			</xsl:element>
			
			<xsl:for-each select="/fmp:FMPXMLRESULT/fmp:METADATA/fmp:FIELD">
				<xsl:variable name="pt" select="position()" />
				
				<xsl:element name="{@NAME}">
					<xsl:value-of select="$subset/fmp:COL[$pt]/fmp:DATA"/>
				</xsl:element>
					
			</xsl:for-each>
		</node>
	</xsl:template>

</xsl:stylesheet>