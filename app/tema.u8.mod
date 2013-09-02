<?php
  global $head,$body;
  $head.='
    <link rel="stylesheet" href="FLATFOX_BASE_URL/styles/main.css">
    <!--[if lt IE 9]>
      <script src="FLATFOX_BASE_URL/vendor/es5-shim.js"></script>
      <script src="FLATFOX_BASE_URL/vendor/json3.js"></script>
    <![endif]-->
    '
?>

  <h1>Dvojrozměrné programování</h1>

  <p>
  Připravili jsme pro vás interaktivní editor a interpretr FlatFoxu, se kterým si můžete hrát níže.
  <b>Součástí je i několik hlavolamů, za jejichž vyřešení můžete získat body.</b> Až je vyřešíte,
  pošlete nám řešení jako součást řešení témátka (nejlépe elektronicky). Budeme rádi i za
  myšlenku vašeho řešení.

  <p>
  Pod aplikací najdete návod a pár technických
  podrobností, které se do článku v čísle nevešly. Interpretr by měl fungovat v prohlížečích Chrome 13+, Opera 11+,
  Firefox 4+ a novějším Safari. Pokud narazíte na problémy (nezobrazí se, nejde spustit, nejde načíst/uložit, ...),
  dejte mi prosím vědět.
  Pro vyjasnění připomínáme, že vyjetí z okraje "plochy" je stejně platné ukončení programu, jako symbol
  stop (<code>#</code>).

  <p><i>Tomáš (&#103;avento&#064;ucw&#46;cz)</i>

  <div class="FF-styled" ng-app="flatFoxApp">
    <div class="container">
      <div ng-view></div>
    </div>
    <script src="FLATFOX_BASE_URL/scripts/angular.js"></script>
    <script src="FLATFOX_BASE_URL/scripts/app.js"></script>
    <script src="FLATFOX_BASE_URL/scripts/modules.js"></script>
  </div>

  <h2>Jak na to</h2>

  <p>
  V editoru (druhý řádek tlačítek) vybíráte kombinaci barvy (R, G, B, C, M, Y a černá/žádná) a
  symbolu (plus/mínus, šipky, prázdné pole, start a konec). Některé kombinace nedávají smysl a ty
  vám editor nedovolí vybrat. Zvolenou kombinaci aplikujete klikáním na políčka programu.

  <p>
  Tlačítko <b>Ulož</b> by mělo stáhnout soubor s programem k vám do počítače. Tlačítko
  <b>Nahraj</b> pak zas zobrazit malý dialog, kde zvolte "Zvolit soubor" (či podobně) a tím vyberete
  uložený program ze svého disku. Formát souboru je popsán níže.

  <p>Pro ovládání interpretu pro různé zkoušení vašeho prográmku použijte první ovládací řádek.
  Když program právě neběží, můžete si libovolně nastavit hodnoty registrů.
  Spustit a sledovat jde program buď krokováním (<i class='icon-step-forward'></i>), nebo
  plynule se zadanou prodlevou mezi kroky (<i class='icon-play'></i>,
  <i class='icon-pause'></i> a <i>Krok [ms]</i>, který může být i neceločíselný či 0). Program je pak potřeba zastavit
  (<i class='icon-stop'></i>), čímž se obnoví hodnoty registrů do stavu před začátkem spuštění.

  <p>
  Tlačítko <b>Otestuj</b> se vyskytuje jen u hlavolamů a spustí váš program pro několik různých vstupů
  a zhodnotí, zda program odpověděl správně či zda se nezacyklil. Test standartně provede 1000 kroků.
  Pro test není potřeba měnit hodnoty registrů, testuje se jen program a úplně nezávisle na aktuálním stavu
  krom samotného programu.

  <h2>Programování ve FlatFoxu</h2>

  <p>
  <i>(Část textu zadání témátka v čísle 20.1.)</i>

  <p>
  Dvojrozměrný program je mřížka příkazů a prázdných políček.
  Po mřížce se pohybuje <i>hlava</i>, která určuje aktuálně prováděný příkaz programu
  (můžete si ji představit i jako robota pochodujícího po ploše).
  Hlava si pamatuje svůj aktuální směr a šest nezáporných celých čísel v registrech pojmenovaných
  R, G, B, C, M a Y po anglických zkratkách šesti základních barev.
  Po provedení každého příkazu se hlava posune o na další pole svým směrem a vykoná příkaz,
  který tam najde, nebo se posunuje dál.

  <p>
  Mezi základní příkazy patří čtyři černé šipky, které nastavují směr pohybu hlavy.
  Šipky mohou být i barevné a potom nastaví nový směr pohybu hlavy jen když má registr dané barvy
  hodnotu 0, jinak hlava pole přejde, jako by bylo prázdné. Barevné jsou i příkazy <code>+</code>
  a <code>-</code>, které hodnotu stejnobarevného registru zvýší či sníží o 1. Pokud by se měla snížit
  hodnota registru pod hodnotu 0, nic se nestane. Ještě se v programu musí vyskytnout
  právě jeden znak <code>@</code>, kde hlava vždy začíná nasměrovaná doprava, a mohou se tam vyskytnout
  příkazy <code>#</code>, které program zastaví a ukončí. Program skončí i když by hlava měla vyjet
  z plochy programu. Za vstup programu můžeme považovat počáteční hodnoty některých
  registrů a za výstup jejich koncové hodnoty. Zaveďme konvenci, že vstup bude primárně registr
  R (červený) a ostatní registry budou nastaveny na 0, aby je program mohl použít.


  <h2>Něco o implementaci</h2>

  <p>
  Teď trochu o tom, jak interpretr funguje. Napsaný je v HTML, Javascriptu a
  <a href='http://coffeescript.org/'>Coffeescriptu</a> (což je trochu pěknější dialekt Javascriptu)
  a běží jen u vás v prohlížeči bez jakékoliv potřeby serveru.
  Program používá frameworky
  <a href='http://angularjs.org/'>Angular JS</a> pro logiku a synchronizaci prvků,
  <a href='http://getbootstrap.com/'>Bootstrap</a> pro základní stavební bloky stránky a
  ikony z <a href='http://glyphicons.com/'>Glyphicons</a>.

  <p>
  Program je interpretován přímočaře krok za krokem bez jakékoliv kompilace či podobně.
  I při nastaveném nulovém kroku trvají kroky programu skoro stejně bez ohledu na jejich typ.
  Maximální rychlost záleží na vašem počítači a prohlížeči - například na mém notebooku
  s procesorem Intel-i5 2.5 GHz a prohlížečem Chromium 26 asi 2 000 000 kroků za sekundu.

  <p>
  Zdroják programu si můžete prohlédnout a stáhnout na <a href='https://github.com/gavento/flat-fox'>GitHubu</a>.
  Česká verze upravená pro MaM je ve větvi <code>mam</code>.
  Bohužel vyvíjím interpretr primárně pro stránky MaM, takže není zatím snadné jej u sebe spustit
  (i tak byste potřebovali Linux, nainstalovaný Node.js a pár dalších drobností). Časem bude ale o něco
  uklizenější a použitelný i mimo web MaMka.

  <h2>Formát programů</h2>

  <p>
  Programy jsou ukládány jako textové soubory. Na každém řádku souboru je jeden řádek programu, každé políčko je
  zapsáno 1-2 znaky a pole jsou odděleny libovolným počtem mezer. Pokud by počet polí na každém řádku nebyl stejný,
  program je doplněn prázdnými poli na obdélník. Prázdné řádky vstupního souboru jsou ignorovány.

  <p>
  Pole je popsáno vždy jedním ci dvěma znaky: nejprve volitelnou barvou, která je
  z <code>RGBCMY</code> (žádná barva znamená "černo-bílá"), a pak symbolem, který je
  z <code>+-@#.&lt;&gt;^v</code>. Znaky odpovídají znakům v editoru, <code>.</code> je prázdné pole
  a <code>&lt;&gt;^v</code> vyjadřují šipky. Například <code>@ . R+  Rv R- &lt;</code> je jednořádkový
  program obsahující start, prázdné pole, červené plus, červenou šipku dolů, červené mínus a nakonec šipku vlevo.

  <p>
  Náš editor je poměrně jednoduchý a neumožňuje žádné pokročilejší operace, jako je kopírování.
  Pokud tedy budete chtít dělat složitější či opakující se konstrukce, doporučujeme vám
  program uložit jako text, upravit ve vašem oblíbném textovém editoru a opět načíst.


