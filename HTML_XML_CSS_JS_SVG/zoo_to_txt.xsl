<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/">
        <xsl:text>| Nazwa zwierzęcia |   Imie   | Wiek | Waga | Data urodzenia | Gatunek | Wybieg (sektor,powierzchnia,typ) |</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:text>-----------------------------------------------------------------------------------------------------------</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:variable name="space" select="'                                                                   '"/>
        <xsl:for-each select="zoo/zwierzeta/zwierze">
          <xsl:value-of
                  select="concat(@nazwaZwierzecia,substring($space,1,19-string-length(@nazwaZwierzecia)),' ',@imie,substring($space,1,10-string-length(@imie)),' ',
                  @wiek,substring($space,1,6-string-length(@wiek)),' ',@waga,substring($space,1,6-string-length(@waga)),' ',@dataUrodzenia,substring($space,1,17-string-length(@dataUrodzenia)),'',
                  Gatunek,substring($space,1,10-string-length(Gatunek)),Wybieg/@sektor, ', ' ,Wybieg/@powierzchnia,', ', Wybieg/@typ)"/>
          <xsl:text>&#xA;</xsl:text>
        </xsl:for-each>
        <xsl:text>&#xA;</xsl:text>
        <xsl:text>-----------------------------------------------------------------------------------------------------------</xsl:text>
        <xsl:text>&#xA;Statystyki &#xA;</xsl:text>
        <xsl:text>-----------------------------------------------------------------------------------------------------------</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat(substring(concat('Ilość ssaków:',$space),1,40),substring(concat(zoo/statystyki/iloscSsakow,$space),1,10))"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat(substring(concat('Ilość gadów:',$space),1,40), substring(concat(zoo/statystyki/iloscGadow,$space),1,10))"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat(substring(concat('Ilość płazów:',$space),1,40), substring(concat(zoo/statystyki/iloscPlazow,$space),1,10))"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat(substring(concat('Ilość ryb:',$space),1,40), substring(concat(zoo/statystyki/iloscRyb,$space),1,10))"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat(substring(concat('Ilość ptaków:',$space),1,40), substring(concat(zoo/statystyki/iloscPtakow,$space),1,10))"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat(substring(concat('Razem:',$space),1,40), substring(concat(zoo/statystyki/iloscZwierzat,$space),1,10))"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:text>-----------------------------------------------------------------------------------------------------------</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat(substring(concat('Ilość zwierząt w sektorze A:',$space),1,40),substring(concat(zoo/statystyki/iloscWybiegowA,$space),1,10))"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat(substring(concat('Ilość zwierząt w sektorze B:',$space),1,40), substring(concat(zoo/statystyki/iloscWybiegowB,$space),1,10))"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat(substring(concat('Ilość zwierząt w sektorze C:',$space),1,40), substring(concat(zoo/statystyki/iloscWybiegowC,$space),1,10))"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat(substring(concat('Ilość zwierząt we wszystkich sektorach:',$space),1,40), substring(concat(zoo/statystyki/iloscWybiegow,$space),1,10))"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:text>-----------------------------------------------------------------------------------------------------------</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat(substring(concat('Średnia waga zwierzęcia:',$space),1,40), substring(concat(zoo/statystyki/sredniaWaga,$space),1,10))"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat(substring(concat('Średnia powierzchnia wybiegu:',$space),1,40), substring(concat(zoo/statystyki/sredniaPowierzchniaWybiegu,$space),1,10))"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat(substring(concat('Średni wiek zwierzęcia:',$space),1,40), substring(concat(zoo/statystyki/sredniWiek,$space),1,10))"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:text>-----------------------------------------------------------------------------------------------------------</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat(substring(concat('Najcięższe zwierzę:',$space),1,40), substring(concat(zoo/statystyki/najciezszeZwierze,$space),1,10))"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat(substring(concat('Najlżejsze zwierzę:',$space),1,40), substring(concat(zoo/statystyki/najlzejszeZwierze,$space),1,10))"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat(substring(concat('NAjwiększy wybieg:',$space),1,40), substring(concat(zoo/statystyki/najwiekszyWybieg,$space),1,10))"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:text>-----------------------------------------------------------------------------------------------------------</xsl:text>
    </xsl:template>
</xsl:stylesheet>
