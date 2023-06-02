<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:template match="/">
        <svg width="1500" height="1000" xmlns="http://www.w3.org/2000/svg" style="background-image: url('t.jpeg');background-attachment: fixed;background-size: cover;">
            <text x="50%" y="60" font-family="arial" font-size="50" font-weight="bold" fill="#FFF">
                Statystyki zoo - wykres wieku
            </text>
            <xsl:for-each select="zoo/zwierzeta/zwierze">
                <xsl:variable name="number" select="(position()-1) * 50"/>
                <xsl:variable name="age" select="number(@wiek)* 20"/>
                <text x="{$number + 72}" y="{600-$age}" font-family="arial" font-size="25" fill="#FFF">
                    <xsl:value-of select="$age div 20"/>
                </text>
                <rect  x="{$number + 70}" y="{610-$age}" height="{$age}" width="0"
                      fill="#3f3f3f"
                      opacity="0.8"
                      stroke="black" stroke-width="2">
                    <animate attributeType="XML" attributeName="width" from="0" to="30"
                             dur="2s" fill="freeze"/>
                    <animate attributeType="XML" attributeName="fill" values="#CB2D6F;#e8834d;#2F2FA2;#C3073F" dur="4s" repeatCount="indefinite"/>
                </rect>
                <text writing-mode="tb-rl" x="{$number + 90}" y="620" font-family="arial" font-size="25"
                      fill="#FFF" text-decoration="underline">
                    <xsl:value-of select="@imie"/>
                </text>

            </xsl:for-each>
        </svg>
    </xsl:template>
</xsl:stylesheet>
