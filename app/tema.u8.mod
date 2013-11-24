<!-- vim: set filetype=html :-->
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
  K tématu dvojrozměrného programování zde najdete editor FlatFox <i>(FF)</i>, FlatFox++ <i>(FF++)</i>,
  několik interaktivních hlavolamů a též plné verze účastnických článků s obrázky.

<!--
  <h2>Obsah</h2>

  <ul>
  <li><a href="#interpret">Interpret <i>FF</i> a <i>FF++</i></a>
    <ul>
    <li><a href="#interpret-jaknato">Jak na to</a>
    <li><a href="#interpret-implementace">Něco o implementaci</a>
    <li><a href="#interpret-format">Formát programů</a>
    </ul>
  <li><a href="#flatfox">Jazyk FlatFox</a>
  <li><a href="#flatfoxpp">Jazyk FlatFox++</a>
  <li><a href="#reseni">Řešení hlavolamů</a>
  <li><a href="#lieskovsky-1"><i>Matej Lieskovský:</i> FlatFox</a>
    <ul>
    <li><a href="#lieskovsky-1-">...</a>
    </ul>
  <li><a href="#rozhon-1"><i>Václav Rozhoň:</i> FlatFox</a>
    <ul>
    <li><a href="#rozhon-1-">...</a>
    </ul>
  </ul>
-->

  <h2>Interpret <i>FF</i> a <i>FF++</i><a name="interpret"></a></h2>

  Připravili jsme pro vás interaktivní editor a interpretr FlatFoxu a FlatFox++.
  <b>Součástí je i několik hlavolamů, za jejichž vyřešení můžete získat body.</b>
  Úlohy zadané v prvním čísle jsme uzavřeli se třetím číslem. Ve třetím čísle
  přibyly nové úlohy pro FF++, za které můžete získat body do termínu odeslání páté série.
  Řešení hlavolamů nám pošlete jako součást řešení témátka (nejlépe elektronicky) nebo jen
  emailem. Budeme rádi i za myšlenku vašeho řešení.

  <div class="FF-styled" ng-app="flatFoxApp">
    <div class="container">
      <div ng-view></div>
    </div>
    <script src="FLATFOX_BASE_URL/scripts/angular.js"></script>
    <script src="FLATFOX_BASE_URL/scripts/app.js"></script>
    <script src="FLATFOX_BASE_URL/scripts/modules.js"></script>
  </div>

  <p>
  Interpretr by měl fungovat v prohlížečích Chrome 13+, Opera 11+,
  Firefox 4+ a novějším Safari. Pokud narazíte na problémy (nezobrazí se,
  nejde spustit, nejde načíst/uložit, ...), dejte mi prosím vědět.

  <p><i>Tomáš (&#103;avento&#064;ucw&#46;cz)</i>


  <div class="hiddenTab" id="t2">
  <div class="tabTitle" onclick="changeVisibility('t2');"><h3>Jak na to<a name="interpret-jaknato"></a></h3></div>
  <div class="tabContent">
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
  </div></div>

  <div class="hiddenTab" id="t3">
  <div class="tabTitle" onclick="changeVisibility('t3');"><h3>Něco o implementaci<a name="interpret-implementace"></a></h3></div>
  <div class="tabContent">
  <p>
  Teď trochu o tom, jak interpretr funguje.
  Napsaný je v HTML, Javascriptu a
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
  Dokumentace a zdrojový kód jsou z většiny v angličtině, ale texty jsou v češtině.
  Pro spuštění u sebe na počítači budete potřebovat Linux, <a href='http://nodejs.org/'>Node.js</a> a pár
  dalších drobností, a též umět spstit několik příkazů v shellu, jak se dočtete v <code>README.md</code>.
  </div></div>

  <div class="hiddenTab" id="t4">
  <div class="tabTitle" onclick="changeVisibility('t4');"><h3>Formát programů<a name="interpret-format"></a></h3></div>
  <div class="tabContent">
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
  </div></div>


  <h2>Jazyk FlatFox<a name="flatfox"></a></h2>

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

  Pro vyjasnění připomínáme, že vyjetí z okraje "plochy" je stejně platné
  ukončení programu, jako symbol stop (<code>#</code>).


  <h2>Jazyk FlatFox++<a name="flatfoxpp"></a></h2>

  <p>
  <i>(Část textu zadání témátka v čísle 20.3.)</i>

  <p>
  FlatFox++ je dvourozměrný jazyk zpětně kompatibilní s FlatFoxem.
  Přibývají hlavně nové instrukce pro efektivnější operace s čísly
  a jedna instrukce pro ladění programů. Ve většině nových instrukcích má
  červený registr <code>R</code> speciální roli takzvaného <i>akumulátoru</i>, všechny
  nové instrukce ho používají jako jeden z operandů. Toto zmenšuje
  početo nových instrukcí, ale nelze tak například přímo sečíst
  registry <code>G</code> a <code>B</code>.

  <ul>
  <li><code>o</code> &dash; Tato instrukce pozastaví provádění programu, třeba za účelem ladění a inspekce.
  Rychlou simulaci programu je pak možné obnovit nebo třeba pokračovat krokováním.
  Při vyhodnocování hlavolamů se pole chová jako prázdné. Tuto instrukci inspirovaly návrhy
  Mateje Lieskovského a Václava Rozhoně.

  <li><code>R0, G0, B0, C0, M0, Y0</code> &dash; Tyto instrukce přímo vynulují daný registr.

  <li><code>GA, BA, CA, MA, YA</code> &dash; Přičtení <i>(Add)</i> hodnoty k registru <code>R</code>,
  hodnota zdrojového registru se nezmění.

  <li><code>GS, BS, CS, MS, YS</code> &dash; Odečtení <i>(Substract)</i> hodnoty od registru
  <code>R</code>, hodnota zdrojového registru se nezmění,
  pokud by mělo vyjít záporné číslo, výsledkem bude <code>R=0</code>.

  <li><code>GM, BM, CM, MM, YM</code> &dash; Vynásobení <i>(Multiply)</i> registru <code>R</code>
  jiným registrem.

  <li><code>GD, BD, CD, MD, YD</code> &dash; Vydělení <i>(Divide)</i> registru <code>R</code>
  jiným registrem se zbytkem.
  V registru <code>R</code> bude zbytek po dělení (jako bychom od něj opakovaně odečítali, dokud je to možné),
  ve druhém registru pak podíl.

  <li><code>GL, BL, CL, ML, YL</code> &dash; Zkopírování <i>(Load)</i> hodnoty registru <code>R</code>
  do jiného registru. Hodnota registru <code>R</code> se nezmění.
  </ul>

  <p>
  Tyto operace určitě drasticky sníží počet kroků (a též <i>časovou složitost</i>) různých operací.
  Nabízí se ale otázka, kterých a jak moc. Jak byste upravili programy své
  či ostatních a jakého zrychlení by tak šlo dosáhnout?
  Co soudíte o volbě právě tohoto typu rozšíření, jaké to má výhody a nevýhody a proč?

  <p>
  Zatímco si mnozí všimli, že násobit $a\times b$ nebylo možné rychleji než řádově $a\times b$ kroky,
  násobit $a\times b$ s pomocí nových instrukcí sčítání a pod. ale <i>bez</i> použití instrukcí
  pro násobení a dělení lze o dost rychleji než v řádově $\min\{a,b\}$ krocích. Jak na to?

  <p>
  Jaká další zlepšení FlatFoxu++ byste navrhli?


  <h2>Řešení hlavolamů<a name="reseni"></a></h2>

  <h2><i>Matej Lieskovský:</i> FlatFox<a name="lieskovsky-1"></a></h2>

  <h2><i>Václav Rozhoň:</i> FlatFox<a name="rozhon-1"></a></h2>



