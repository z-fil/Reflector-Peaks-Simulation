#import "@preview/physica:0.9.1": *
//#import "physica.typ": *
#let version = "0.9.7"
#import "@preview/wordometer:0.1.5": word-count, total-words
#import "@preview/chemformula:0.1.2": ch


#import "@preview/subpar:0.2.2"

#let title = "Neutron Flux Experiment - Addition"
#let coursename = "PHYS-E0467 - Experimental Reactor Physics D" //"Chemistry of the Nuclear Fuel Cycle"
#let coursecode = ""//"KEM352"  
#let author = "Filippo Zinetti"
#let date = datetime.today().display("[day].[month].[year]")

#let overset(a, b) = {
 math.attach(math.limits(a), t: b)
}
#let nonum(eq) = math.equation(block: true, numbering: none, eq)

#show raw: set text(font: "Cascadia Code NF")

// Reset raw blocks to the same size as normal text,
// but keep inline raw at the reduced size.
#show raw.where(block: true): set text(1em / 0.8)

#set text(size: 11pt, hyphenate: false)//, font:"Arial") // font: "STIX Two Text"
#set par(justify: true, leading: 1em, spacing: 1.5em, linebreaks: "optimized", first-line-indent: 1.5em)

#set page(numbering: "1", margin:2cm)
#set math.equation(numbering: "(1)", supplement: [Eq.])
#set heading(numbering: "1.", supplement: [Section]) 
#set heading(numbering: (..nums)=>counter(heading).display("1.1.1").split("-").last())

#show heading.where(level: 1): set text(size: 18pt)
#show heading.where(level: 2): set text(size: 15pt)
#show heading.where(level: 3): set text(size: 13pt)


// centered caption
#show figure.caption: it => { set align(center); set text(size: 9pt); block(inset: 0em, it) }

// bold figure/table initial text (numbering problema)
/*#show figure.caption: it => {
  if it != none and it.kind == image {
    [*Figure #counter(i).display():* #it.body]
  } else {
    [*Table #counter(figure).display():* #it.body]
  }
}*/

#show ref: it => {
  if it.element != none and it.element.func() == image {
    "Fig. " + it.element.numbering
  } else {
    it
  }
}

#show bibliography: it => {
  show heading.where(level: 1): set block(below: 1em)
  it
}

#show heading.where(level: 1): set block(below: 1em)
#show heading.where(level: 2): set block(below: 1em)
#show link: underline

#align(center, text(20pt)[* #title; *]+ text(18pt)[* \ _#coursename; #coursecode;_ * \ #author, #date])

//#pad(y: 50pt, outline(depth:3))
//#pagebreak()

= Task
#figure(
    grid(
        columns: (auto, 3.5em),
        rows:    (auto, auto),
        gutter: 0pt,
        image("./imgs/055_comparison.pdf", width: 80%),
    ),
  caption: [The flux shape of three neutron detectors placed in different positions within the core. The raw count rates $M$ are indicated by crosses ($times$) on data points, whereas circles (●) denote the true count rates $N_M$. Each $N_M$ dataset has been corrected via a $k_T (M)$ determined independently for each detector. The vertical lines indicate the maximum raw count rates $M$ that can be linearised by each correction factor. Since no $M$ exceeds its corresponding threshold, all $N_M$ are valid corrections.]
) <fig_fluxDummy>

_«Sensible considerations about the observed differences. It would be valuable to discuss the typical distance that a neutron travels in fuel material and in the moderator. Can you easily obtain such estimates and compare them to reactor dimensions?»_

= Answer
== Analysis
Neutrons have very different lifetimes depending on the material in which they travel and their energy. Therefore, in order to discuss their travel distance, multiple parameters must be considered. However, a proper analysis should start by distinguishing between distance metrics, specifically:
- mean free path (the straight-line collision-free distance travelled by a neutron, usually expressed in centimetres in neutron physics):
  $ lambda_("tr") = 1/(Sigma_("tr")) $
- diffusion coefficient (Fick's law proportionality constant that quantifies the diffusiveness of a medium):
  $ D approx lambda_("tr")/3 = 1/(3 Sigma_"tr") $ <eq_D>
  where the transport cross-section can be further approximated via the average of the scattering angle $overline(mu)$ as:
  $ Sigma_"tr" = Sigma_s (1-overline(mu)) quad "with" quad overline(mu) = 2/(3A) $ <eq_mu>
- diffusion length (the maximum average "crow-flight" distance reached by a neutron before undergoing capture, calculated from birth to absorption position):
  $ L = sqrt(D/Sigma_a) $ <eq_L>
- mean absorption-free path (the actual cumulative distance travelled by a neutron in a zig-zag path, before capture):
  $ lambda_a = D lambda_a = (lambda_("tr") lambda_a)/3 = 1/(3 Sigma_"tr" Sigma_a ) $ <eq_max_path>

Since we are discussing neutron detection systems, the most relevant metric appears to be the diffusion length $L$. This can be found as stand-alone parameter or it can also be estimated via the diffusion coefficient and the total macroscopic absorption cross-sections, defined as
$ underbrace(Sigma_a, "absorption") = underbrace(Sigma_f, "fission") + underbrace(Sigma_gamma, "capture"). $

A higher $L$ directly correlates to a more diffusive material where absorption is less impactful. Therefore, according to @fig_fluxDummy, the hypothesis is that water-filled structures C3 and G4 should present an higher diffusion length compared to those with fuel. //, and, in the case of G4, the flux is also favoured at elevated points.//, but also a larger flux. //a higher neutron diffusion length

//The variables to consider are therefore, at least, the following:
//We must therefore account for both the mean absorption-free path in the material $lambda_a$, given by 
//$ lambda = 1/Sigma_a quad "where" quad underbrace(Sigma_a, "absorption") = underbrace(Sigma_f, "fission") + underbrace(Sigma_gamma, "capture") $
// we must thus find the diffusion length in each material which
The travelled distance is also highly affected by the energy spectrum of the neutron, which influences the probability of a material to undergo fission or perform capture. Therefore, a full study should include a complete analysis of the groups scattering cross-sections to understand the transition to different energies and correctly estimate the travel distance. However, it also holds that $l_p approx t_d $, i.e. the average total prompt neutron lifetime $l_p$ corresponds approximately to the mean diffusion time of the neutron in the thermal spectrum $t_d$ @lamarshIntroductionNuclearEngineering2001. Therefore, since the neutrons spend most of their lifetime in the thermal spectrum, using only thermal data appears to be a good approximation. //*****

/*
#figure(
  kind: table,
  align(center)[
  #table(
    columns: (11em, auto, auto, auto, auto, auto, auto),
    inset: 6pt,
    align: left,
    table.header([Material], [$L_T$ (cm)], [D (cm)],[$sigma_f$], [$sigma_gamma$], [$sigma_a$], [$Sigma_a$ ($c m^(-1)$)]),
    [$H_2 O$], [2.85] ,[0.16 T], [-], [], [0.23], [0.0222, 0.0197T],
    [$A l$], [], [],  [-], [0.002F], [0.002F], [0.0139],
    [U-235], [], [],  [1.4F], [0.25F], [1.65F = 680.8 barn], [],
    [U-238], [], [],  [0.095F], [0.16F], [0.255F, 3.67T?], [],
    [$U O_2$ ($approx$ 20% enritched)], [1.55 (U), 3.7 ($U_3 O_8$)], [], [], [], [], [67.61]
  )
  ],
  caption: [Parameters from Lamarsh @lamarshIntroductionNuclearEngineering2001.]
) <tab_sim>
*/

== Results and Discussion
Here, we are interested in three materials: light water (moderator and reflector), aluminium (assembly cladding and general structural material used extensively in the VR-1 core), and 19.7% enriched $U O_2$. 
Except for water, however, precise values of $L$ are hard to find due to the energy-dependent cross-sections and the multiple approximations that are required to calculate it. Databases exists, but they usually list the constant parameters rather than variable ones, while experimental data about the actual diffusion length is more limited. //In short,  // it might also not be relevant.
Nonetheless, some estimations can be performed. The results are shown in @tab_L. //via the absorption cross section alone, for example those provided
#figure(
  kind: table,
  align(center)[
    #table(
      columns: (6em, auto, auto, auto, auto, auto, 6em, 6.6em),
      inset: 6pt,
      align: left,
      table.header([Material], [$Sigma_a$ ($c m^(-1)$)], [$Sigma_s$ ($c m^(-1)$)], [A (\#)], [$Sigma_tr$ ($c m^(-1)$)], [D ($c m$)], [L (calc, $c m$)], [$L_T$ (true, $c m$)]),
      [Al], [0.014], [0.08976], [27], [0.088], [3.808], [16.575], [?],
      [U (natural)], [0.367], [0.4301], [238.03], [0.429], [0.777], [1.456], [1.55],
      //[U235], [33.286], [0.4301], [235], [0.429], [0.777], [0.153], [?],
      [$U O_2$ (20%)], [6.950 (\*)], [0.4301 (\*)], [270], [0.429], [0.777], [0.334], [?],
      [$H_2 0$], [0.022], [3.443], [18], [3.315], [0.101], [2.128], [2.85],
      [*Source*], table.cell(colspan: 3)[*Lamarsh*], [*@eq_mu*], [*@eq_D*], [*@eq_L*], [*Lamarsh*]
    )
  ],
  caption: [$Sigma_a$, $Sigma_s$, $A$, and $L_T$ (true) are based on Lamarsh (table 5.2, 6.4, and II.3) @lamarshIntroductionNuclearEngineering2001. The other parameters have been calculated using equations also found in the same book. Values marked with (\*) have been estimated with data from the book.] //$L$ (true) indicates thermal values, while $L$ (calc) is the calculated average among every ]
) <tab_L>


//The diffusion lengths calculated with the available data are shown in @tab_L, and
A comparison between the estimated values of $L$ and the few predetermined ones reveals only a minor underestimation in the calculations. Despite the lack of complete data, the scale of these results appear plausible. For example, enriched uranium oxide has a much smaller $L$ than natural uranium, since U-235 has a large $Sigma_a$ and therefore absorbs neutrons more readily. //It is also noteworthy how 

The diffusion lengths in the fuel and in water are in the order of few centimetres, which is surprisingly short given that the fuel assemblies are almost 6.97 cm wide. This suggests that employing the neutron transparency of Al may be helping to extend this distance, thanks to its large diffusion length of around $16.6$ cm. On the other hand, a fuel layer as thin as 0.33 cm is enough to stop neutrons. With these information it becomes possible to estimate the diffusion length across assembly layers, as shown next.

Fuel assemblies are composed by 0.6-mm-thick layers of fuel surrounded by 0.5-mm-thick Al cladding, and are configured as 6-tube or 8-tube. Using the fact that Al does not contribute substantially in absorbing neutrons compared to the fuel, we can proceed by 
//considering that the fuel alone will provide a sufficient estimate of the length that neutrons will be likely stopped in. 
evaluating whether the fuel component alone of an assembly would be sufficient to stop neutrons.
The total fuel thickness of an assembly, which is found as _fuel thickness $times$ tubes number $times$ 2_, is 0.72 mm and 0.96 mm for 6-tube and 8-tube structures, respectively. According to these data, and given $L_(U O 2)=0.334$ cm, we can conclude that a neutron is unlikely to travel further than half of any fuel assembly, even without accounting for the interstitial water and Al layers. This corroborates the previous self-shielding hypothesis, according to which a detector placed inside a fuel assembly will detect mostly neutrons born in that assembly itself, and the contribution from the other assemblies will be minimal.

On other other hand, neutrons born close to the surface of each fuel assembly will definitely be able to reach a detector in a neighbouring dummy structure, since this alternates only Al and water.// definitely measure neutrons coming from the surface of each surrounding fuel assembly,
Moreover, as hypothesised in the main report, it still holds that the measured flux in a detector in a dummy assembly will likely be proportional to the summed contribution of each structure surrounding it.

Finally, in light of these relatively short diffusion lengths, it is reasonable to assume that the flux of neutrons travelling at larger angles compared to the horizontal plane will be suppressed for the detector, because they need to traverse a thicker fuel layer.
This relates to the observation of a lower flux at higher levels in the pool, which has been previously attributed to the effect of control rods: the rods, inserted at a certain height, lower the flux around them. Since the neutrons travelling the furthest must follow a mostly horizontal path to minimise the contact with the fuel layer, the height of the surrounding rods must affects the flux at that level. In other words, neutrons are unlikely to circumvent rods and be detected at much higher $z$ than what they are born at. Thus, the only explanation for the skew in C3's flux would be a raised control rod, but this does not find confirmation from the core geometry and the other fluxes.

//, in the presence of many rods (as for C3), the lower flux at the bottom will be stronger than that on the top. Instead, for G4 //, and it supports the conjecture reduced flux 

//However, none of these data explains why C4 and G4 have a similar shape while C3 presents a stronger flux higher in the pool.



#bibliography("ERP_report.bib")//, style:"custom-vancouver.csl")
