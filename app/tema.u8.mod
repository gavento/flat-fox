<!-- vim: set filetype=html :-->
<?php
  global $head,$body;
  $head.='
    <link rel="stylesheet" href="FLATFOX_BASE_URL/styles/main.css">
    <style> code {color: black; } .ffimg { text-align:center; margin: 5mm; } .ffsrc { display:block; }</style>
    <script type="text/x-mathjax-config">
      MathJax.Hub.Config({
	tex2jax: {
	  inlineMath: [ ["$","$"] ],
	  processEscapes: true
	}
      });
    </script>
    <script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_HTML"></script>
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


  <div class="hiddenTab" id="t2"><div class="tabTitle" onclick="changeVisibility('t2');">
  <h3>Jak na to?<a name="interpret-jaknato"></a></h3>
  </div><div class="tabContent">
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

  <div class="hiddenTab" id="t3"><div class="tabTitle" onclick="changeVisibility('t3');">
  <h3>Něco o implementaci<a name="interpret-implementace"></a></h3>
  </div><div class="tabContent">
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

  <div class="hiddenTab" id="t4"><div class="tabTitle" onclick="changeVisibility('t4');">
  <h3>Formát programů<a name="interpret-format"></a></h3>
  </div><div class="tabContent">
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
  Zemí neprobádanou jsou další vylepšení a rozšíření FlatFoxu. Jaká byste navrhli vy?


  <div class="hiddenTab" id="t5"><div class="tabTitle" onclick="changeVisibility('t5');">
  <h2>Řešení hlavolamů<a name="reseni"></a></h2>
  </div><div class="tabContent">

  </div></div>

  <h2>Dr.<sup>MM</sup> Matej Lieskovský: <i>FlatFox</i><a name="lieskovsky-1"></a></h2>

  <h3>Užitečné součástky</h3>

  <p>
  Když jsem dostal tento programovací jazyk, chvilku jsem si s ním hrál a pak jsem si položil jednoduchou otázku: "Co všechno to umí?"
  Takový hezký základ by bylo dokázat, že je FlatFox Turingovsky úplný. A to se nejlépe dokazuje odsimulováním Turingova stroje.
  Jelikož to není úplně triviální, nejdříve si vyrobím několik základních součástek. Které pak budu moct použít (nejen) v Turingově stroji.

  <p>
  Pokud možno, tak hlava bude vstupovat do komponenty levým horním rohem a opouštět ji levým dolním rohem. Tím docílíme snadnější řetězení operací.

  <div class='ffimg'><img class src='FLATFOX_BASE_URL/mam/lieskovsky-presun.png'></div>

  <p>
  Pro násobení konstantou přidáme v přesunu další pluska.

  <p>
  Celočíselné dělení konstantou, ať už jako modulo konstanta (vynecháme <code>G+</code>), dělení beze zbytku (<code>B+</code>),
  nebo divmod:

  <div class='ffimg'><img class src='FLATFOX_BASE_URL/mam/lieskovsky-divmod.png'></div>

  <p>
  Jelikož umíme přesouvat mezi registry, můžeme nadefinovat in-place operace, které ale potřebují pomocné registry.
  Tím se hezky dostáváme k pokročilejší správě registrů. FlatFox má jenom 6 registrů. Pokud chceme z jednoduchých
  funkcí poskládat větší program, musíme se ujistit, že nám bude 6 registrů stačit. Jednoduché instrukce si vystačí
  s 2-3 registry, ale co když chceme mít například 10 proměnných? Elegantním  řešením by bylo poskládat několik
  registrů do jednoho.

  <h4>Zásobník</h4>

  Nejdříve si vyrobme z jednoho registru zásobník. Do zásobníku bude sice možné ukládat pouze čísla od 0 do $n-1$, ale
  výměnou se nám do něj vejde těchto  čísel libovolně mnoho.

  <p>
  V ukázce je <code>R</code> prvek, <code>G</code> manipulační prostor a <code>B</code> samotný zásobník.
  Číslo $n$ je pevně nakódované do toho, jakou konstantou násobím nebo dělím <code>B</code>. Ukázka používá $n=2$.

  <div class='ffimg'>
    <div class='ffimg'><img class src='FLATFOX_BASE_URL/mam/lieskovsky-stack.png'></div>
    <a class='ffsrc' href='FLATFOX_BASE_URL/mam/lieskovsky-stack.txt'>[zdrojový kód]</a>
  </div>

  <p>
  Celý princip je hezky vidět, pokud si představíme, jak bude číslo v <code>B</code> vypadat v soustavě o základu $n$.
  Nové prvky jsou pak jen cifry připsané na konec tohoto čísla.

  <h4>Komprese registrů</h4>

  <p>
  Následující program vezme čísla v <code>R</code> a <code>G</code>,
  sezipuje jeich binární zápisy dohromady a uloží je do <code>B</code>. Druhý blok je pak zase vyjme.

  <div class='ffimg'>
    <img class src='FLATFOX_BASE_URL/mam/lieskovsky-zip.png'>
    <a class='ffsrc' href='FLATFOX_BASE_URL/mam/lieskovsky-zip.txt'>[zdrojový kód]</a>
  </div>

  <p>
  Všimněte si, že k <code>B</code> přičítám a následně odčítám jedničku, která mi indikuje konec "souboru".
  Jinak by selhalo ukládání pro sudé <code>R</code>.
  Když program přechází z levého (komprimačního) do pravého (extrahujícího) bloku, jsou všechny registry kromě
  <code>B</code> prázdné. Umíme tedy, pomocí 2 registrů (a za cenu dalšího spomalení i pouze jednoho) slít dva
  registry do třetího. Tímto se alespoň částečně zbavujeme omezení na 6 registrů, což se nám jistě bude hodit.

  <p>
  Tímto končí můj první soupis podprogramů ve FlatFoxu. Pro stavbu Turingova stroje máme již všechny potřebné
  součástky, dejme se tedy do jeho stavby.
  Pozn.: Uvedené programy nejsou optimalizovány, snažil jsem se spíše o čitelnost.

  <h3>Turingův stroj</h3>

  <p>
  Turingův stroj je teoretický model počítače popsaný Alanem Turingem v~roce 1936. Je vybaven
  nekonečnou páskou rozdělenou na políčka, kde v~každém políčku je zapsán jeden znak z~nějaké
  předem zvolené abecedy, která je konečná a obsahuje mezeru. Nad páskou se pohybuje hlava, která umí
  přečíst znak zapsaný v~políčku pod ní a případně jej i přepsat na jiný. Činnost stroje ovládá řídící
  jednotka, která se vždy nachází v~jednom z~konečného počtu stavů. Program je kromě abecedy a seznamu
  stavů definován rozhodovací tabulkou, která pro každou kombinaci stavu a znaku pod hlavou určí, zda
  a na jaký znak  má být políčko pod hlavou přepsáno, zda a kterým směrem se má hlava posunout o~jedno
  políčko a do kterého stavu se má řídící jednotka přepnout.

  <p>
  Navzdory své jednoduchosti je Turingův stroj schopen modelovat jakýkoliv algoritmus. Pokud by se
  někdo chtěl dovědět o~Turingově stroji více, doporučuju přečíst si
  <a href='http://ksp.mff.cuni.cz/tasks/26/tasks1.html#task8'>první část letošního
  seriálu</a> Korespondenčního Semináře z~Programování.

  <p>
  Představme si Turingův stroj s~abecedou o~velikosti $a$ a počtem stavů $s$.
  Nejdříve postavíme tu nekonečnou pásku se čtecí hlavou. Pole aktuálně pod čtecí hlavou bude
  v~registru <code>G</code>, páska před hlavou <code>R</code>, páska za hlavou <code>B</code>,
  kde <code>R</code> a <code>B</code> budou zásobníky
  s~$n=s$. Posun pásky budou zařizovat dva bloky, jeden pro posun dopředu a druhý pro posun dozadu.
  Posun dopředu provedeme <code>Push_B(G)</code> a pak <code>G=Pop_R()</code>, pro posun dozadu zaměnit
  <code>R</code> a <code>B</code>.

  <p>
  A~teď rozhodovací tabulka. Nejdříve potřebujeme vědět, jak bude vypadat jedna buňka. Buňka musí být
  schopná nastavit libovolný stav a zapsat libovolný znak - to určitě umíme v~prostoru o~straně
  $O(\sqrt{sa})$ i bez nějakých pokročilejších triků. Zda se má páska posunout doleva, nebo doprava bude
  určovat, zda buňku opustíme podél její levé, nebo pravé hrany. V~tabulce si tedy nejdříve nalezneme
  řádek odpovídající aktuálnímu stavu a pak sloupec odpovídající aktuální
  hodnotě v <code>G</code> - tím současně obojí vynulujeme.

  <div class='ffimg'>
    <img class src='FLATFOX_BASE_URL/mam/lieskovsky-turing.png'>
    <a class='ffsrc' href='FLATFOX_BASE_URL/mam/lieskovsky-turing.txt'>[zdrojový kód]</a>
  </div>

  <p>
  Pro ilustraci jsem sestavil Turingův stroj, který kontroluje, zda je na pásce stejný počet~1~a~2.
  Jo, je to ten
  nejjednodušší Turingův stroj, který mě napadl, ale myslím, že princip konstrukce libovolného
  jednopáskového Turingova stroje je zřejmý. Dalším krokem by bylo sestrojení Univerzálního Turingova
  stroje (Turingova stroje, který na vstupu dostane popis jiného Turingova stroje a vstup, na který
  má být tento stroj spuštěn), ale vzhledem k~nízké rychlosti FlatFoxu je takový stroj neprakticky
  pomalý i pro triviální vstupy.

  Abeceda je $\{0,1,2,3\}$, kde 0 je mezera, 1 a 2 jsou znaky na vstupu a 3 je speciální znak, kterým
  budeme přepisovat už použité znaky.
  Stavy jsou $\{0,1,2,3\}$, kde 0 je počáteční stav, ve kterém se čtecí hlava vždy přesune na začátek
  vstupu. Pak stroj přejde do stavu 3, kdy budeme hledat 1 nebo 2, následně přejdeme do odpovídajícího
  stavu, nalezneme znak opačný a ve stavu 0 se vrátíme na začátek. Pokud algoritmus nějaký znak
  nenajde, skončí a <code>C</code> bude indikovat, kterého znaku je víc.
  0 značí, že znaků bylo stejně.

  <h2>Mgr.<sup>MM</sup> Václav Rozhoň: <i>FlatFox</i><a name="rozhon-1"></a></h2>



