<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:z="http://www.XMLTechnologies.org/zoo" xmlns:math="http://exslt.org/math" version="2.0">
  <xsl:key name="idG" match="z:zoo/z:gatunki/z:gatunek" use="@idG"/>
  <xsl:key name="idWybiegu" match="z:zoo/z:wybiegi/z:wybieg" use="@idWybiegu"/>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/">
      <xsl:element name="zoo">
        <xsl:element name="zwierzeta">
          <xsl:for-each select="z:zoo/z:zwierzeta/z:zwierze">
            <xsl:sort select="z:imie"/>
            <xsl:element name="zwierze">
              <xsl:attribute name="nazwaZwierzecia">
                <xsl:value-of select="z:nazwaZwierzecia"/>
              </xsl:attribute>
              <xsl:attribute name="imie">
                <xsl:value-of select="z:imie"/>
              </xsl:attribute>
              <xsl:attribute name="wiek">
                <xsl:value-of select="z:wiek"/>
              </xsl:attribute>
              <xsl:attribute name="waga">
                <xsl:value-of select="z:waga"/>
              </xsl:attribute>
              <xsl:attribute name="dataUrodzenia">
                <xsl:value-of select="z:dataUrodzenia"/>
              </xsl:attribute>
              <xsl:attribute name="nazwaZwierzecia">
                <xsl:value-of select="z:nazwaZwierzecia"/>
              </xsl:attribute>
              <xsl:element name="Gatunek">
                <xsl:value-of select="key('idG', @idG)"/>
              </xsl:element>
              <xsl:element name="Wybieg">
                <xsl:attribute name="sektor">
                  <xsl:value-of select="key('idWybiegu', @idWybiegu)/z:sektor"/>
                </xsl:attribute>
                <xsl:attribute name="powierzchnia">
                  <xsl:value-of select="concat(key('idWybiegu', @idWybiegu)/z:powierzchnia,key('idWybiegu', @idWybiegu)/z:powierzchnia/@jednostka)"/>
                </xsl:attribute>
                <xsl:attribute name="typ">
                  <xsl:value-of select="key('idWybiegu', @idWybiegu)/z:typ"/>
                </xsl:attribute>
              </xsl:element>
              <xsl:element name="powierzchniaNaKg">
                <xsl:value-of select="format-number((key('idWybiegu', @idWybiegu)/z:powierzchnia) div z:waga, '0.00')"/>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
        <xsl:element name="statystyki">
          <xsl:element name="iloscZwierzat">
            <xsl:value-of select="count(z:zoo/z:zwierzeta/z:zwierze)"/>
          </xsl:element>
          <xsl:element name="iloscSsakow">
            <xsl:value-of select="count(z:zoo/z:zwierzeta/z:zwierze[@idG='01'])"/>
          </xsl:element>
          <xsl:element name="iloscGadow">
            <xsl:value-of select="count(z:zoo/z:zwierzeta/z:zwierze[@idG='02'])"/>
          </xsl:element>
          <xsl:element name="iloscPlazow">
            <xsl:value-of select="count(z:zoo/z:zwierzeta/z:zwierze[@idG='03'])"/>
          </xsl:element>
          <xsl:element name="iloscRyb">
            <xsl:value-of select="count(z:zoo/z:zwierzeta/z:zwierze[@idG='04'])"/>
          </xsl:element>
          <xsl:element name="iloscPtakow">
            <xsl:value-of select="count(z:zoo/z:zwierzeta/z:zwierze[@idG='05'])"/>
          </xsl:element>
          <xsl:element name="sredniaWaga">
            <xsl:value-of select="format-number(sum(z:zoo/z:zwierzeta/z:zwierze/z:waga) div count(z:zoo/z:zwierzeta/z:zwierze), '0.00')"/>
          </xsl:element>
          <xsl:element name="najciezszeZwierze">
            <xsl:for-each select="z:zoo/z:zwierzeta/z:zwierze">
              <xsl:sort select="z:waga" data-type="number" order="descending"/>
                <xsl:if test="position() = 1">
                  <xsl:value-of select="z:imie"/>
                </xsl:if>
            </xsl:for-each>
          </xsl:element>
          <xsl:element name="najlzejszeZwierze">
            <xsl:for-each select="z:zoo/z:zwierzeta/z:zwierze">
              <xsl:sort select="z:waga" data-type="number" order="ascending"/>
                <xsl:if test="position() = 1">
                  <xsl:value-of select="z:imie"/>
                </xsl:if>
            </xsl:for-each>
          </xsl:element>
          <xsl:element name="iloscWybiegow">
            <xsl:value-of select="count(z:zoo/z:wybiegi/z:wybieg)"/>
          </xsl:element>
          <xsl:element name="iloscWybiegowA">
            <xsl:value-of select="count(z:zoo/z:wybiegi/z:wybieg[z:sektor = 'A'])"/>
          </xsl:element>
          <xsl:element name="iloscWybiegowB">
            <xsl:value-of select="count(z:zoo/z:wybiegi/z:wybieg[z:sektor = 'B'])"/>
          </xsl:element>
          <xsl:element name="iloscWybiegowC">
            <xsl:value-of select="count(z:zoo/z:wybiegi/z:wybieg[z:sektor = 'C'])"/>
          </xsl:element>
          <xsl:element name="sredniaPowierzchniaWybiegu">
            <xsl:value-of select="format-number(sum(z:zoo/z:wybiegi/z:wybieg/z:powierzchnia) div count(z:zoo/z:wybiegi/z:wybieg), '0.00')"/>
          </xsl:element>
          <xsl:element name="sredniWiek">
            <xsl:value-of select="format-number(sum(z:zoo/z:zwierzeta/z:zwierze/z:wiek) div count(z:zoo/z:zwierzeta/z:zwierze), '0.00')"/>
          </xsl:element>
          <xsl:element name="najwiekszyWybieg">
            <xsl:for-each select="z:zoo/z:wybiegi/z:wybieg">
              <xsl:sort select="z:powierzchnia" data-type="number" order="descending"/>
                <xsl:if test="position() = 1">
                  <xsl:value-of select="@idWybiegu"/>
                </xsl:if>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:template>
</xsl:stylesheet>
