<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xhtml" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" indent="yes"/>
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml" xmlns:z="http://www.XMLTechnologies.org/zoo" xml:lang="pl" lang="pl">
			<head>
        <title>Zoo raport</title>
        <style type="text/css">
          body
          {
            color: #000;
            font-size: 20px;
          }
          h1
          {
            text-align: center;
            font-size: 60px;
            font-weight: bold;
          }
          h2
          {
            text-align: center;
            font-size: 40px;
            font-weight: bold;
            margin-top: 30px;
          }
          .tabela
          {
            text-align: center;
            background-color: #3f3f3f;
            margin-left: auto;
            margin-right: auto;
            border: 2px solid #0B0C10;
            color: #FFF;
          }
        </style>
      </head>
			<body style="background-color:#FFFFFF;">
				<h1>Zoo raport</h1>
        <h2>Tabela 1 - zwierzeta w zoo</h2>
				<table class="tabela" border="2px">
					<tr>
						<th>Nazwa zwierzecia</th>
						<th>Imie</th>
						<th>Wiek</th>
						<th>Waga</th>
						<th>Data urodzenia</th>
						<th>Gatunek</th>
						<th>Sektor</th>
						<th>Powierzchnia wybiegu</th>
						<th>Typ wybiegu</th>
						<th>Powierzchnia na kilogram [m^2/kg]</th>
					</tr>
					<xsl:for-each select="zoo/zwierzeta/zwierze">
						<tr>
							<td>
								<xsl:value-of select="@nazwaZwierzecia"/>
							</td>
							<td>
								<xsl:value-of select="@imie"/>
							</td>
							<td>
								<xsl:value-of select="@wiek"/>
							</td>
							<td>
								<xsl:value-of select="@waga"/>
							</td>
							<td>
								<xsl:value-of select="@dataUrodzenia"/>
							</td>
              <td>
                <xsl:value-of select="Gatunek"/>
              </td>
              <td>
                <xsl:value-of select="Wybieg/@sektor"/>
              </td>
              <td>
                <xsl:value-of select="Wybieg/@powierzchnia"/>
              </td>
              <td>
                <xsl:value-of select="Wybieg/@typ"/>
              </td>
              <td>
                <xsl:value-of select="powierzchniaNaKg"/>
              </td>
						</tr>
					</xsl:for-each>
				</table>
        <h2>Tabela prezentujaca licznosc ze wzgledu na gatunek</h2>
        <table class="tabela" border="2px">
          <tr>
            <th colspan="2" >Licznosc ze wzgledu na gatunek</th>
          </tr>
          <tr>
            <th>Ilość ssakow</th>
            <td>
              <xsl:value-of select="zoo/statystyki/iloscSsakow"/>
            </td>
          </tr>
          <tr>
            <th>Ilość gadow</th>
            <td>
              <xsl:value-of select="zoo/statystyki/iloscGadow"/>
            </td>
          </tr>
          <tr>
            <th>Ilość płazow</th>
            <td>
              <xsl:value-of select="zoo/statystyki/iloscPlazow"/>
            </td>
          </tr>
          <tr>
            <th>Ilość ryb</th>
            <td>
              <xsl:value-of select="zoo/statystyki/iloscRyb"/>
            </td>
          </tr>
          <tr>
            <th>Ilość ptakow</th>
            <td>
              <xsl:value-of select="zoo/statystyki/iloscPtakow"/>
            </td>
          </tr>
          <tr>
            <th>Razem</th>
            <td>
              <xsl:value-of select="zoo/statystyki/iloscZwierzat"/>
            </td>
          </tr>
        </table>
        <h2>Tabela 3 - prezętuje dane o wybiegach</h2>
        <table class="tabela" border="2px">
          <tr>
            <th colspan="2" >Liczność wybiegów w danym sektorze</th>
          </tr>
          <tr>
            <th>Ilość wybiegów w sektorze A</th>
            <td>
              <xsl:value-of select="zoo/statystyki/iloscWybiegowA"/>
            </td>
          </tr>
          <tr>
            <th>Ilość wybiegow w sektorze B</th>
            <td>
              <xsl:value-of select="zoo/statystyki/iloscWybiegowB"/>
            </td>
          </tr>
          <tr>
            <th>Ilość wybiegów w sektorze C</th>
            <td>
              <xsl:value-of select="zoo/statystyki/iloscWybiegowC"/>
            </td>
          </tr>
          <tr>
            <th>Ilość wybiegów łacznie</th>
            <td>
              <xsl:value-of select="zoo/statystyki/iloscWybiegowA"/>
            </td>
          </tr>
        </table>
        <h2>Tabela 4 - prezętuje pewne uśrednione dane</h2>
        <table class="tabela" border="2px">
          <tr>
            <th colspan="2" >Wartości średnie</th>
          </tr>
          <tr>
            <th>Średnia waga zwierzęcia</th>
            <td>
              <xsl:value-of select="concat(zoo/statystyki/sredniaWaga, ' kg')"/>
            </td>
          </tr>
          <tr>
            <th>Średnia powierzchnia wybiegu</th>
            <td>
              <xsl:value-of select="concat(zoo/statystyki/sredniaPowierzchniaWybiegu, ' m^2')"/>
            </td>
          </tr>
          <tr>
            <th>Średni wiek zwierzęcia</th>
            <td>
              <xsl:value-of select="zoo/statystyki/sredniWiek"/>
            </td>
          </tr>
        </table>
        <h2>Tabela 5 - prezętuje wartości maksymalne oraz minimalne</h2>
        <table class="tabela" border="2px">
          <tr>
            <th colspan="2" >Ekstrema</th>
          </tr>
          <tr>
            <th>Najcięższe zwierze</th>
            <td>
              <xsl:value-of select="zoo/statystyki/najciezszeZwierze"/>
            </td>
          </tr>
          <tr>
            <th>Najlżejsze zwierze</th>
            <td>
              <xsl:value-of select="zoo/statystyki/najlzejszeZwierze"/>
            </td>
          </tr>
          <tr>
            <th>najwiekszyWybieg</th>
            <td>
              <xsl:value-of select="zoo/statystyki/najwiekszyWybieg"/>
            </td>
          </tr>
        </table>
			</body>
		</html>
  </xsl:template>
</xsl:stylesheet>
