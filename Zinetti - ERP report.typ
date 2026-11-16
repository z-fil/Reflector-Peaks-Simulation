#import "@preview/physica:0.9.1": *
//#import "physica.typ": *
#let version = "0.9.7"
#import "@preview/wordometer:0.1.5": word-count, total-words
#import "@preview/chemformula:0.1.2": ch


#import "@preview/subpar:0.2.2"

#let title = "Neutron Flux Mapping Experiment"
#let coursename = "PHYS-E0467 - Experimental Reactor Physics D" //"Chemistry of the Nuclear Fuel Cycle"
#let coursecode = ""//"KEM352"  
#let author = "Filippo Zinetti"
#let date = datetime.today().display("[day].[month].[year]")

#set document(
  title: [#coursename; (#coursecode): \ #title]
)

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

#pad(y: 50pt, outline(depth:3))
#pagebreak()


#let tot_words = 0
#let tot_chars = 0
#show: word-count

#word-count(total => [



= Introduction
Every nuclear reactor employs neutron detectors. Their use spans from power measurement to flux distribution determination. These tools enable not only to determine the intensity of chain reactions at different points in time and space during reactor operations, but also to corroborate theoretical models and simulations to better understand the reactor itself.

This report covers firstly the neutron detector calibration and secondly the experiment in axial neutron flux mapping, conducted at the VR-1 reactor. These measurements are related such that, in order to present and discuss the results pertaining the flux distribution, it will be initially necessary to explain the setup and calibration of the neutron detector. The document is structured as follows. @theory introduces the phenomena at work and the tools employed. @methods describes the methodology of the experiments and the simulation setup, @results presents the results of the measurements, and @discussion discusses the findings and potential sources of error. All technical information concerning the reactor has been acquired from the official training book @janratajReactorPhysicsCourse.


= Theory
<theory>
== The VR-1 Reactor
The VR-1 reactor is a "zero-power" reactor with a modular core design employing 19.75% enriched #ch("UO_2") and moderated by light water. Since it is operated as an open pool, it is easy to interact with the fuel through various tools and samples. This allows to install mobile detectors in different places of the core.
//Indeed, the results here presented are acquired from detectors placed in different points of interest inside the core

== Neutron Detectors Overview
<ch_neutron_det>
Neutrons/* are born at different energies, but since they*/ do not interact with electric fields, therefore indirect ways to infer their presence are needed. To this end, two types of detector exist: passive and active. Passive detectors respond proportionally to the integral of the neutron flux via a neutron activation mechanism, but measurement of the activity and data acquisition can happen only in separate instances. Therefore, active detectors are needed for online measurements. These offer an immediate feedback of the live flux. In the experiments here reported, the types of active detector used are gas-filled ones. These work via ionisation of the gas, which gives rise to an electric field.

The mechanism is as follows. A high voltage is applied to a gas chamber which is insulating under normal conditions. However, the gas is ionised by the incoming gamma and neutron radiation, and the $alpha$ and $beta$ ions produced generate a current peak by their movement towards the electrodes at the edges of the chamber. A He-3 gas-filled 05NH1 detector is used. He-3 is a so-called $1 \/ v$ absorber---its neutron capture cross section follows a regular behaviour which decreases at faster neutron spectra. Therefore, its sensitivity is higher in the thermal regime. 

There are three operating modes: pulse, current, and Campbelling mode. These are chosen according to the amount of pulses produced. Pulse mode measures each ionisation event, but it is sensitive to a measurement delay called dead time. Current mode is an averaging technique employed when the current is too high to register every burst individually. Campbelling mode is a more advanced statistical model for extracting more data from the signal. In the subsequent experiments, pulse mode is used by our detectors, while current mode is used exclusively for calibration.

== Paralysation Compensation
An essential factor to take into account in pulse detection mode is the dead time of the detector. Dead time describes the inability of a system to register events that happen too close together in a certain time period because it is busy processing the previous input. To some extent, every electronic apparatus is sensitive to dead time due to the delay caused by processing or even transferring the signal. However, in some systems, this phenomenon might be negligible. This is not the case for the 05NH1 detector at our disposal. In fact, at certain neutron count rates, this detector becomes saturated with pulses and it stops distinguishing every event. The reaction of a detector to an exceedingly high amount of counts can be of two types. If the tool freezes completely until the end of the processing step, we call this non-paralysable. If, instead, a device already busy processing can be further delayed by another input, we define it as paralysable. Clearly, the second case is less desirable, since a very high input rate might be underestimated as one single event.
//[TODO: COMPENSATED IONISATION CHAMBER?!]

In any case, a correction must be applied to account for this non-linearity. To understand how this adjustment is performed, let us call $N$ the true count rate and $M$ the raw measured count rate. The relation between these quantities will be of the form
$ N_M = k_T (M) M, $ <eq_k_nm_exp>

where $k_T (M)$ is the non-linear correction factor needed to convert among the two, and the argument denotes the dependency on the measured count rate.

Introduce the electric current $I_k$. At the VR-1 facility, this is measured by a detection system composed of a compensated ionisation chamber connected to a LCM310 analyser. This detector is highly linear with respect to the power because the detector in current mode does not suffer from dead time @janratajReactorPhysicsCourse. Thanks to the linearity of this current, we can also express the true neutron flux as a proportional increase over its base value:
$ N_k = I_k/(I_0) N_0 $ <eq_nk>

To employ such a mathematical model, an initial reference count value for $N_0$ is needed. Thus, a reasonable assumption can be made that, at low powers, the dead time is sufficiently negligible and the detector is not paralysed. Under this approximation it follows that, at a certain initial very low power, the device can count roughly every ionisation event, allowing to establish $N_0 approx M_0$.

Comparing @eq_k_nm_exp and @eq_nk allows us to define the correction factor as
$ k_T (M) = k_T (I_k, I_0, N_0, M) = I_k/(I_0 M) N_0, $ <eq_k>

which improves with every additional measurement of the power-dependent current $I_k$ and the raw count rate $M$.
This method works exclusively for fully non-paralysable detectors, or in the non-paralysable regime of the paralysable system, because beyond this point the same measured count rate $M$ corresponds to multiple current values $I_k$, and therefore $k_T (M)$ is not single valued anymore.

There exists a second way to estimate the true count rate. In fact, for a paralysable detector it also holds that
$ M = N e^(-N tau) $ <eq_exp>
where $tau$ is the system's dead time. Since for a truly linear detector the count rate should scale proportionally with the current, it must also be true that $N = I times c$ for an arbitrary constant $c$. Under this assumption of a linear current with respect to flux, the measured count rate $M$ can be fitted to @eq_exp to obtain both this proportionality ratio $c$ and the dead time $tau$.


== Simplified Neutron Flux Model
The axial flux distribution follows from the one-group diffusion equation and appropriate boundary conditions in the following way.
The standard reactor equation for a steady-state system is
$ D laplacian phi.alt - Sigma_a phi.alt = -S, $ <reac_eq>
where $D$ is the one-group diffusion coefficient, $Sigma_a$ is the macroscopic absorption cross-section and $S$ is the source density. The source can be expressed as
$ S = 1/k nu Sigma_f phi.alt. $

Intuitively, this describes how each neutron in the flux $phi.alt$ has probability $Sigma_f$ (the fuel fission cross-section) of causing a fission event, which in turn produces $nu$ new neutrons, while $k$ skews this intensity towards increasing or decreasing values. All constants can now be collected into the geometric buckling $B^2$:
$ B^2 = 1/D (1/k Sigma_f - Sigma_a), $
and the reactor equation can be rewritten as an eigenvalue problem:
$ laplacian phi.alt + B^2 phi.alt = 0. $

By treating the thin fuel rod as an infinite bare slabs of width $a$ and assuming a negligible radial contribution, the one-group reactor equation in this 1D approximation is now simply
$ (d^2 phi.alt)/(d x^2) + B^2 phi.alt = 0. $ <1D_eigenv>

The standard solution to this second-order linear ODE is
$ phi.alt(z) = A sin(B z) + C cos(B z), $

and by imposing the boundary condition that the flux must vanish at the outer (extrapolated) boundaries, we get a value for the $A$ coefficient:
$ phi.alt(tilde(a)/2) = phi.alt(-tilde(a)/2) => A = 0. $
This is true when the origin of the system $z=0$ is placed in the middle of the rod.
In the non-trivial case, we therefore solve for $B$ as
$ phi.alt(tilde(a)/2) = 0 = C cos(B tilde(a)/2) => B_n = (n pi)/tilde(a). $
This yields the eigenvalues for $B_n$, but in a critical rector only the first root is relevant @lamarshIntroductionNuclearEngineering2001, therefore, the flux takes the shape
$ phi.alt(z) = C cos(pi/tilde(a) z), $
where $C$ is an intensity amplitude defined by the reactor power. In summary, the flux shape expected is a cosinusoidal centred in the middle of the rod. This holds for either bare fuel elements or in places where the influence of a reflector is negligible.

In the case of a reflected reactor, like the VR-1, we would observe a peculiar effect at the axial limits of the fuel assemblies. 
In fact, demineralised water acts as a reflectors from above and below the rods to even out the flux shape, and this gives origin to two distinct peaks near the upper and lower edges @lamarshIntroductionNuclearEngineering2001. However, a two-groups calculation is needed to describe this phenomenon appropriately. With a second flux, it is possible to correctly model the effect of the fast flux slowing in the reflector, which locally increases the thermal flux by scattering neutrons from this higher spectrum. This involves finding the two piecewise fluxes of the following coupled ordinary differential equations:


$ -D_1 laplacian phi.alt_1 + Sigma_a phi.alt_1 = S_1, $ <fast_eq2>
$ -overline(D) laplacian phi.alt_T + overline(Sigma)_a phi.alt_T = S_T, $ <reac_eq2>

where the subscript "$1$" refers to the fast flux, while the subscript "$T$" and the overline refer to the thermal flux. The key mechanism here is that each source depends on the opposite flux, according to
$ S_1 = 1/k nu Sigma_f phi.alt_T, $
$ S_T = Sigma_(s 1) phi.alt_1. $

This interaction gives rise to reflector peaks. However, because of the rather complex theoretical derivation needed to demonstrate the existence of this effect, it is possible instead to model such behaviour by computational means, as described in @sim. 


#pagebreak()

= Methods
<methods>
== Detector Calibration
The first experiment aims at understanding the performance of the 05NH1 neutron detector to correctly interpret the subsequent measurements. To this end, a compensated ionisation chamber in current mode is used to calibrate the detectors, which are instead in pulse mode. // p.31 start
The correction is achieved via an experimental procedure that consists of three phases. First, the electrical current and the neutron count rate are measured at a very low flux. Second, the current and the count rate are recorded at higher powers until the detector displays a paralysed behaviour. Third, the new true flux is found by applying a correction formula, and with enough data points a polynomial fit can be used to interpolate any count rate strictly within the non-paralysable region.

During the experiment, the reactor operator changes the power at quasi-logarithmic step. The reactor is in automatic mode and, for each step, after stabilisation of the power, the count rate is averaged over a $60$ s time interval. This average data is manually transferred from the measurement screen to a spreadsheet, which is prepared to perform the conversion from measured count rate $M$ to the true count rate $N_k$ according to @eq_nk and to find the correction factor $k_T (M)$ via @eq_k.
With enough count rate measurements in the non-paralysable regime of the detector, a 5th degree polynomial is fitted to the resulting $k_T (M)$, /*In this case, 13 data points have been collected, but only 11 are confidently outside the paralysable region.*/ and the continuous function obtained is ready to be used for the second experiment.

For comparison, the second method employing @eq_exp is implemented, and the two estimated dead times are evaluated. The fit can only be performed until the function's maxima at $1/(tau e)$, after which it becomes double valued. In the dataset, the maximum occurs near the 12th data point, therefore fitting is performed on 12 points. According to this model, it will be possible to obtain an estimate for $tau$ according to
$ tau = -ln(M/(N_k))/(N_k) $ <eq_tau>

whose precision is expected to improve at higher count rates, since this function diverges at low inputs. Obtaining similar $tau$ values from the two methods will ascertain the validity of the detector performance model and thus the reliability of the $k_T (M)$ correction. However, employing this correction factor remains the only method fully able to predict any $N$ given exclusively information about $M$. //suffers from numerical instabilities

== Flux Measurement Procedure
With the information about the non-linear correction needed for the neutron detector, it is possible to employ the device for other tests. For the second experiment, three neutron detectors are positioned at different points of interest at the bottom of the reactor pool, each inside a tube. These placements can be read from @fig_core as blue icons with labels "25" or "32", corresponding to the diameter in millimetres of the vertical channel containing the detector. One is inside a fuel assembly (position C4), one in an empty fuel structure (C3), and one outside the reactor (G4). Most of the analysis will be performed using data from the detector in C4, while C3 and G4 will only serve as a final comparison. The reactor is in automatic mode for the entire experiment in order to remain critical and at the same power level despite the presence and the movement of the detector.

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 0pt,
        image("./imgs/core_config.jpg", width: 70%),
    ),
  caption: [The core configuration scheme. The label "25" in cells C4 and C3 indicates a 25-mm-wide channels while "32" in G4 is a \ 32-mm-wide channel. Each channel is a dry tube containing a 05NH1 neutron detector, held from the top by its connection cable. \ The detector at C4 is inside a 6-tube fuel assembly, while the ones at C3 and G4 are inside fuel dummies.]
) <fig_core>

The detector is then raised at intervals of $5$ cm and held in position until stable data is collected for at least $60$ s. At a certain height above the fuel the measurements are stopped and the data is analysed. The chosen maximum measurement height is 80 cm.

== Simulation
<sim>
Due to the convoluted mathematics involved at the fuel-reflector interface with two flux groups, reflector peaks can be demonstrated computationally. The minimum setup required involves a 1D slab-like reactor with negligible radial component, which can be treated with a finite-difference method as a mesh of discrete cells. The cross-sections and diffusion properties can be given cell-wise, which is particularly useful to model the correct behaviour at the interface between reflector and fuel. This kind of simulation requires first to discretise the steady-state reactor equation and then to perform a self-consistent iteration over the multiplication factor $k_("eff")$. The procedure is derived in details in @app_discretisation, while here only the main final results are presented.// which are explained next.

Four cases of the reactor equations need to be considered to account for two fluxes and two reactor regions (fuel and reflector, next summarised together by the subscript $x in {f,r}$):
$ -D_(1,x) (d^2 phi.alt_1)/(d x^2) + Sigma_(a,x) phi.alt_1 =
cases(
  1/k_("eff") nu Sigma_f phi.alt_T quad "(fuel)",
  0  quad   quad   quad   quad "  (reflector)") $ 

$ -overline(D)_x (d^2 phi.alt_T)/(d x^2) + overline(Sigma)_(a,x) phi.alt_T = Sigma_(s 1,x) phi.alt_1. $

The only difference between the fuel and reflector regions will therefore be the source term of the fast flux. However, it is essential to model four different absorption cross sections and four diffusion coefficients.

#pagebreak()
With a finite-difference approach of a $L$ cells-wide reactor, the operator acting of $phi.alt$ is discretised as an $L times L$ matrix, whose rows will be
$ [A_(i,i-1), A_(i,i), A_(i,i+1)] = underbrace(D_i /((Delta x)^2) [1, -2, 1], D d^2 / (d x^2)) + Sigma_(a,i) [0, 1, 0]. $

To ensure continuity of current and flux at the boundary between fuel and reflector, the interfacial diffusion coefficient is averaged between the two sides. \ Taking as example a fuel ($x=i$) $->$ reflector ($x=i+1$) interface, this boundary condition is formalised as
$ underbrace(D_f/((Delta x)^2) phi.alt_(i - 1), "Unchanged from bulk") - underbrace((D_f + D_("avg"))/((Delta x)^2) phi.alt_i + (D_("avg"))/((Delta x)^2) phi.alt_(i + 1), "Terms to adjust") $

With the discretised operator, the fluxes and source terms are iteratively calculated until they stabilise, indicating that criticality is achieved. By the definition of $k_"eff"$, this involves finding $k_("eff") = S_1/S_(1",old")$,
and the condition to stop iterating is convergence to zero of $| k_("eff") - k_("eff,old") |$.

=== Choice of Physical Constants
Despite the substantial level of approximation in this simulation, an attempt can be made to implement reactor parameters faithful to reality, or at least with plausible ratios among them. These are listed in @tab_params and grouped into three categories based on how they were derived.

#figure(
  kind: table,
  align(center)[
  #table(
    columns: (auto, auto, auto, 10em),
    inset: 6pt,
    align: (left, center, left, left),

    [*Description*], [*Symbol*], [*Value*], [*Category*],
    [Average neutrons per fission], [$nu$], [$2.43$],table.cell(rowspan: 2)[Not significant due to normalisation],
    [Fuel fission cross-section], [$Sigma_f$], [$57.27$ $c m^(-1)$],
    [Scattering from fast to thermal group], [$Sigma_(s 1)$], [$0.0419$ $c m^(-1)$],table.cell(rowspan: 3)[Found or calculated from data in Lamarsh @lamarshIntroductionNuclearEngineering2001],
    [Diffusion in fuel (thermal flux)], [$overline(D)_f$], [$0.881$  $c m$],
    [Diffusion in reflector, (thermal flux)], [$overline(D)_r$], [$0.16$  $c m$],
    [Thermal absorption cross-section in fuel], [$overline(Sigma)_(a,f)$], [$0.025$ $c m^(-1)$],
    table.cell(rowspan: 6)[Educated guess],
    [Fast flux absorption cross-section in fuel], [$Sigma_(1a,f)$], [$0.005$ $c m^(-1)$],
    [Thermal absorption cross-section in reflector], [$overline(Sigma)_(a,r)$], [$0.006$ $c m^(-1)$],
    [Fast flux absorption cross-section in reflector], [$Sigma_(1a,r)$], [$0.001$ $c m^(-1)$],
    [Diffusion in fuel (fast flux)], [$D_(1,f)$], [3 $c m$],
    [Diffusion in reflector (fast flux)], [$D_(1,r)$], [$1.13$  $c m$],
  )
  ],
  caption: [The physical reactor parameters considered in the simulation. Some could not be accurately determined, \ because their value is highly dependent on the specific construction of the reactor.]
) <tab_params>

Note that some of the guessed constants could have been derived from other information (such as $overline(Sigma)_(a,f)$ from the fuel enrichment amount), but attempts to calculate them did not yield visually meaningful simulation results.


=== Constants Assessment by Data Fit
Through data fitting, the experimental measurements can be employed to evaluate the correctness of the initial parameters of the simulation. At the same time, this allows to /*the simulation can also be used to*/gauge the similarity between the VR-1 reactor and an ideal 1D slab. However, the experimental flux data must initially be polished in a form suitable to fit the simulation. The implemented conditions are the following. First, symmetry is imposed by selecting a certain portion of the data, since the simulated flux is strictly symmetric in its current implementation. Second, the reflectors are set at reasonable positions because it is not clear from the experiment at which height they are placed exactly. Third, a small flux is extrapolated outside of the original simulation boundaries by manually adding points. Fourth, it is assumed that the detector records the entire flux spectrum.

Under these conditions, the simulation parameters of @tab_params are let vary in a range between 0.1 and 10 times the original value, and non-linear regression is performed by comparing the corrected measured count rate $N_M$ to the combined simulated flux $phi.alt_T + phi.alt_1$ until an optimal solution is reached. The ratio between the simulated fluxes is kept constant, but normalised so that the largest value corresponds to one. Thus, in the end, the result is upscaled to match the magnitude of the experimental data.


#pagebreak()

= Results
<results>
== Detector Calibration Results
<res_det_cal>
=== Correction Factor Implementation
According to the procedure, the reactor power sweep yielded an equivalent current profile in the LCM310 analyser.
The linear relation between power and current is especially visible in @fig_powerCurrent(a), while @fig_powerCurrent(b) highlights the logarithmic nature of the sweep series. The measured ranges are the following:

#nonum($I in [2.08 times 10^(-8); 4.44 times 10^(-5)] "(A)"$)
#nonum($ P in [2 times 10^4; 5 times 10^7] "(pulses/s)" $)

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 5pt,
        [ #image("./imgs/01a_cp.pdf", width: 97%) ],
        [ #image("./imgs/01b_ci.pdf", width: 109%) ],
    ),
    caption: [Initial assessment of the sweep range of the experiment. (a) The linear relationship between power and current. \ (b) The increase in power performed in quasi-logarithmic steps. Notice the logarithmic y axis.]
) <fig_powerCurrent>

In @fig_NMvsI, current readings have then been paired with the corresponding neutrons counted by the 05NH1, whose data come from averaging over $60$ s after visual stabilisation of the count rate. 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 5pt,
        [ #image("./imgs/02a_nmI.pdf", width: 100%) ],
        [ #image("./imgs/02b_kM.pdf", width: 100%) ],
    ),
    caption: [Two perspectives on the paralysation of the detector. (a) The raw count rate $M$ and the true rate $N_k$ calculated via @eq_nk. Note that $N_k$ is not limited by paralysation since it does not depend on $M$, but only on $I$. (b) The correction factor $k_T (M)$ and two fits, both exhibiting a good degree of fidelity according to their $R^2$ values.]
) <fig_NMvsI>

@fig_NMvsI(a) shows the raw counts and inferred values adjusted via the correction factor with @eq_k_nm_exp.
From this figure it is visible how, until the third to last data point, the measured counts rate $M$ clearly lies in a non-paralysed regime. At higher currents, however, the plateau becomes more remarked, indicating a switch to the paralysed regime. Therefore, the fit of $k_T (M)$ has been performed on the first 11 points out of 13, which includes one point of safety margin before the start of the plateau. Two degrees of fit are shown in @fig_NMvsI(b), both achieving sufficient $R^2$ values. This plot remarks the importance of performing the fit exclusively in the non-paralysable regime, since the correction factor becomes multi-valued afterwards. //The need for a high-degree polynomial is justified by noticing that $k_T (M)$ has a complex shape at low count rates, which is not visually captured

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 5pt,
        [ #image("./imgs/03a_nm_vs_I.pdf", width: 100%) ],
        [ #image("./imgs/03b_tau.pdf", width: 100%) ],
  ),
  caption: [Comparison between different linearisations of the raw count rate. (a) Three true count rates: $N_M$ inferred from the fitted correction factor according to @eq_k_nm_exp, $N_k$ independently calculated with @eq_nk, and $N_"fit"$ fitted on @eq_exp. (b) The dead times calculated via @eq_tau associated with their limit values.]
) <fig_NMvsN>

In @fig_NMvsN(a), the true count rate $N_M$ is plotted together with the previously measured true count $N_k$. The high fidelity of the fitted $k_T (M)$ allows for an excellent prediction of $N_M$ which corroborates the validity of this model in interpolating any true count rate in the range of power up to $3 times 10^7$ pulses/s.

The corrected $N_M$ can be further compared to the exponential fit of $M$, whose result is denoted $N_"fit"$ in @fig_NMvsN(a). Apart from the clear slope correspondence between $N_M$ and $N_"fit"$, the dead times $tau$ also match with a relative error of only around 0.2% (corresponding to $plus.minus 7$ ns). This is plotted in @fig_NMvsN(b) according to @eq_tau, and as expected the estimation of $tau$ improves at higher count rates. The numerical instabilities that this function suffers from may be physically understood in the following way. Since in the linear and in the non-paralysable regime the effect of dead time $tau$ is less pronounced, it is naturally harder to infer it from the data, because the parameter does not influence the count rate. Only when approaching the paralysed regime $tau$ becomes significant. //In short, this exponential model allows to predict $N$ given only $I$ by finding $I times c$, but this assumes that another fully linear detector is present

=== Error Propagation
Deriving the correction factor through multiple parameters introduces a certain level of error, which can be estimated. Specifically, the propagation of uncertainty for a function $f$ with independent variables $x_i$ is calculated using the formula

$ Delta f = sqrt(sum_i ((partial f) / (partial x_i) Delta x_i)^2). $

With the definition of @eq_k, after simplification, the power-dependent uncertainty in the correction factor becomes

$ Delta k_(T,k) = k_T (M_k) sqrt( ((Delta I_k)/I_k)^2 + ((Delta I_0 )/(I_0))^2 + ((Delta N_0)/(N_0))^2+ ((Delta M_k)/(M_k))^2). $ <eq_prop>

To estimate the deltas, the following experimental result is used: the measured data include readings conducted by two groups (which will now be denoted by subscripts "$1$" and "$2$") that have been using the same device. That is, the same neutron detector's output has been independently read by two people. Therefore, what varies between groups is the averaging timestamp and length/*has been taken at different points in */, such that, for each variable $x_i$ and data points $p_1$, $p_2$ collected by the respective group, we can estimate $Delta x_i = (|p_1-p_2|) / 2$. This results in
$Delta I_0 = 5 times 10^(-12)$ A and $Delta N_0 = 1.5$ 1/s, while the other variables depend on the power level, indicated with the subscript $k$.

#figure(
    grid(
        columns: (auto, 2.5em),
        rows:    (auto, auto),
        gutter: 0pt,
        image("./imgs/04_deltak.pdf", width: 75%),
    ),
  caption: [Correction factor uncertainty calculated by two methods: $Delta k_(T,"prop")$ with @eq_prop, and $Delta k_(T,"naive")$ with @eq_k_naive.]
) <fig_deltak>

The obtained uncertainty is shown in @fig_deltak, which compares two approaches. The uncertainty propagation formula leads to an average value of $Delta k_(T,"prop") = 1.13%$.

An average relative difference between the collected data can also be calculated via
$ Delta k_(T,"naive") = (|k_(T,1)(M_1)-k_(T,2)(M_2)|)/(k_(T,1)(M_1)). $ <eq_k_naive>
This more naive estimation yields a 1.42% relative error. However, these are two different approaches and offer different information about the error of $k_T (M)$: the relative difference is an empirical spread, while the error propagation formula gives a statistical prediction of the uncertainty. It is therefore not surprising that a certain discrepancy between the two exists. Nonetheless, both methods confirm that the final uncertainty is minimal.

#pagebreak()
== Flux Distribution Results
In the second experiment, movement of the detectors yielded a flux distribution curve which was then subject to the correction factor $k_T (M)$ determined in @res_det_cal. The corrected model must be used to capture the true shape of the neutron flux, which would normally be underestimated by a raw detector reading, resulting in a flatter profile. Applying $k_T (M)$ is possible as long as the power level employed during the experiment/*produced a flux well*/ is kept within the non-paralysable region of the detector. In @fig_flux(a), this maximum count rate is represented by the vertical line on the right, and it defines the safe rate below which the corrected model can be trusted.

#figure(
  image("./imgs/05b_diff.pdf", width: 100%),
  caption: [The flux in cell C4 and its relative difference between two independent acquisitions of the same data. Note that the count rate at point $z=70$ cm has been lost from one dataset, therefore it has been removed from this comparison. (a) Raw and true count rates. Since these lie well below the detector paralysation limit, marked with a dashed line on the right, $N_M$ is a meaningful correction. The error bars represent the absolute difference between the two datasets. (b) The relative difference between the datasets, highlighting the minor differences in $M$ and flux-proportional difference in $N_M$. (c) The relative error between datasets, expressed as a percentage. ]
) <fig_flux>

The measured combined (thermal and fast) flux of @fig_flux(a) also clearly shows reflector peaks at both ends of the fuel assembly. These peaks are not symmetric, which might be explained by the presence of uneven structures above and below the channel. On the bottom, the reflection appears to be slightly more pronounced, which could be due to a larger amount of reflecting/moderating water under the fuel holder grate. Instead, above it the geometry appears to be more complex due to various devices and tubes, which might be more transparent to neutrons and therefore promote leakage.

To assess the measurement uncertainty, @fig_flux(b) and @fig_flux(c) represent, respectively, the absolute count and percentage difference established by the two groups collecting the same data from the same device, but averaging at slightly different moments in time. The measured rate $M$ shows a negligible variance between datasets, reaching a maximum of 0.6% (around $plus.minus 200$ neutrons/s) of the total flux at $z=65$ cm. On the other hand, due to the systematic uncertainty of $N_M$ propagating from using a slightly different $k_T (M)$, its variance oscillates around 1.7%, or up to $plus.minus 1300$ neutrons/s. This is moderately higher than the naive difference calculated in @res_det_cal, highlighting the presence in this experiment of additional errors. These might originate, for instance, from fitting $k_T (M)$ and from performing more averages while reading $M$. This is confirmed by the flux-shaped $N_M$ in @fig_flux(b), which represents a difference proportional to the strength of the corrected flux, and therefore also proportional to the correction factor. //Overall, the uncertainty is small, 

//#pagebreak()
The other detectors, placed in the emtpy structures C3 and G4, measured a different profile. On the one hand, C4 captures the shape of the flux that most accurately represents the internal neutron distribution of the fuel thanks to its proximity to the fissioning material. On the other hand, C3 and G4 are bare water containers relatively far from the bundles, which therefore lose information about fuel and reflector interactions, but gain contribution from each neighbouring assembly.

#figure(
    grid(
        columns: (auto, 3.5em),
        rows:    (auto, auto),
        gutter: 0pt,
        image("./imgs/055_comparison.pdf", width: 80%),
    ),
  caption: [The flux shape of three neutron detectors placed in different positions within the core. The raw count rates $M$ are indicated by crosses ($times$) on data points, whereas circles (●) denote the true count rates $N_M$. Each $N_M$ dataset has been corrected via a $k_T (M)$ determined independently for each detector. The vertical lines indicate the maximum raw count rates $M$ that can be linearised by each correction factor. Since no $M$ exceeds its corresponding threshold, all $N_M$ are valid corrections.]
) <fig_fluxDummy>

The fluxes captured by all three detectors are shown in @fig_fluxDummy. Indeed, the fluxes measured inside fuel dummies do not exhibit reflector peaks, which is consistent with the theoretical predictions for a bare 1D slab reactor.
However, it is noteworthy how their overall count rate magnitude is increased compared to that measured directly inside the fuel in C4. This appears counterintuitive, as C4 is closer to fuel and therefore should receive an higher irradiation, but four factors could explain this observation. First, C4 could be susceptible to a large amount of shielding from the fuel structure directly around it, which likely restricts the only measurable flux to that produced by the 6-tube assembly of that cell. This relates to the second explanation that considers how, according to the schematics of @fig_core, the detectors in the fuel dummies are surrounded by more fuel assemblies. According to this logic, C3 shows the highest count rate because it neighbours five fuel elements, followed by G4 with three neighbours, and finally C4, which has five neighbours but is potentially shielded by its own fuel. Thus, it is reasonable to assume that their measurements are a sum of the fluxes coming from all the surrounding fuel structures, although inside the fuel itself a strong self shielding occurs.
// according to the schematics of @fig_core, the detector in the fuel dummy is surrounded by more fuel assemblies.
Alternatively, as a third explanation, the core geometry suggests that C4 might be subject to a stronger influence by the surrounding control rods, which definitely absorb part of the flux instead of letting neutrons potentially reflect back to the detector. Finally, a fourth factor to consider is that, near the fuel, there could be a higher likelihood that neutrons will induce fission prior to (and instead of) being captured by the detector, therefore diminishing its counts.

Finally, it remains to justify the skew of C3's flux towards the top of the fuel. The two factors influencing it are control rods position and the ratio of water to other materials. Since C3 receives the highest flux despite being closer to a control rod than G4, the latter explanation appears more plausible, and it involves complex moderation, reflection, and absorption mechanisms shared among the tubes' materials and water. Overall, this remain a peculiar and unusual observation due to its uniqueness compared to the other two measured fluxes.

//This is substantiated by the observation of a higher flux in the detector outside the core (G4), which appears to be under the weakest influence of control rods, according to the core schematics of @fig_core. //This also provides an explanation the skew of the flux at the G4 point: the higher flux near the top could be due to a contribution by the 8-tube assemblies at F3 and F4, both which do not contain any control rod.


== Simulation Assessment
The simulation converges to a solution representing the critical flux distribution, with an //$k_("eff") > 1$
effective multiplication factor $k_("eff") approx 1$. This represents a neutron count consistent between each subsequent generation, indicating a critical state. 

#figure(
    grid(
        columns: (auto, auto),
        rows:    (auto, auto),
        gutter: 5pt,
        [ #image("./imgs/06a_default.pdf", width: 100%) ],
        [ #image("./imgs/06b_LamarshLike.pdf", width: 100%) ],
    ),
    caption: [Examples of a simulation result, where each cell represents a 1-mm-wide slab portion. (a) The stable solution with the default parameters of @tab_params. The reflectors, not indicated for clarity, span $150$ cells and are positioned at $z < 150$ mm and $ z > 650$ mm. The amplitude of the derivatives has been manually increased. (b) Right side of the simulation, with parameters adapted to highlight the difference between single and double flux. The vertical line represents the interface between fuel (left) and reflector (right). ]
) <fig_fluxSim>

As previously mentioned, the parameters that most closely reflect reality do not immediately yield a visually pleasant simulation. With the minimum adjustments presented in @tab_params, the result of @fig_fluxSim(a) is reached by default. The result is physically reasonable: the flux decays slightly outside the simulation boundaries as expected, and both fluxes are continuous even at the interface between fuel and reflector. The latter can be seen from the derivative which exhibit only a minor jump. /*Clearly, being this a discrete simulation, a small discontinuity in the derivative is unavoidable. /Its sharpness is proportional to a combination of the jump between $D_f$ and $D_r$ and between $Sigma_(a,f)$ and $Sigma_(a,r)$. With the default parameters, the thermal flux has the largest diffusion coefficient and absorption cross-section relative difference compared to the fast flux, which results in the sharper peak of $d / (d z) phi.alt_T$.*/ With further tuning, the shape of @fig_fluxSim(b) can be achieved, which reflects the plot shown in Figure 6.5 of Laramsh's book @lamarshIntroductionNuclearEngineering2001 although it is unclear whether the latter had been produced by a simulation or if it only shows a qualitative shape.

#figure(
    grid(
        columns: (auto, 20pt),
        rows:    (auto, auto),
        gutter: 0pt,
        [ #image("./imgs/07a_fit_good_half.pdf", width: 75%) ],
    ),
    caption: [Fitting in the lower half of the experimental flux. The reflector position is estimated and shown with a vertical black line. Because the detector measured both fluxes, it is assumed that the experimental data correspond on average to the direct sum of thermal and fast flux, as $phi.alt_"sum" = phi.alt_T + phi.alt_1$.]
) <fig_fluxFit>


It is also possible to fit the simulation to the experimental data. Because of the asymmetry of flux, only the left (lower) portion of the flux is analysed.
The result of the fit is shown in @fig_fluxFit. The combined flux matches precisely the experimental data, and this is achieved with relatively small variations to the initial constants. The complete list of the resulting parameter values is presented in @tab_sim. Although this experiment did not measure the individual thermal and fast spectra, it is possible to compare this result with the example data of Figure 2.12 of the coursebook @janratajReactorPhysicsCourse. Remarkably, the simulation models quite well the relative ratio between total and fast flux, despite having no prior information about the latter. Note that, despite the normalisation applied to the fluxes, the ratios between them remain consistent and comparable.



#figure(
  kind: table,
  align(center)[
  #table(
    columns: (9em, auto, auto, auto, auto, auto, auto, auto, auto, auto),
    inset: 6pt,
    align: left,
    table.header([Coefficient], [$Sigma_(s 1)$], [$overline(Sigma)_(a,f)$], [$Sigma_(1a,f)$], [$overline(Sigma)_(a,r)$], [$Sigma_(1a,r)$], [$overline(D)_f$], [$D_(1,f)$], [$overline(D)_r$], [$D_(1,r)$]),
    [Original value], [$0.042$], [$0.025$], [$0.005$], [$0.006$], [$0.001$], [$0.881$], [$3.000$], [$0.160$], [$1.130$],
    [Fitted value], [$0.0521$], [$0.0178$], [$0.0024$], [$0.0029$], [$0.0005$], [$2.0492$], [$0.5581$], [$1.4966$], [$3.0121$],
    [Relative deviation], [$124.4%$], [$71.1%$], [$47.2%$], [$47.7%$], [$52.0%$], [$232.5%$], [$18.6%$], [$935.4%$], [$266.6%$]
  )
  ],
  caption: [Comparison between the default parameters and those to which the simulation converged. The maximum relative deviation is bounded in the range 10% ("default was overestimated") to 1000% ("default was underestimated"), where 100% would indicate no change.]
) <tab_sim>

Overall, the magnitude of alteration in the new constants is surprisingly confined below a factor of $~3$, except for the fuel diffusion coefficient of the fast flux $D_(1,f)$ and the reflector diffusion coefficient for the thermal flux $overline(D)_r$. The former inconsistency is likely strongly due to the true geometry of the fuel assemblies, while the latter can be ascribed to the imposition of a forced zero-flux at $z=-100$ mm.


#pagebreak()
= Discussion
<discussion>
This report illustrated the setup of a neutron detector and its use in measuring the axial neutron flux distribution of the VR-1 reactor. The work consisted of two experiments. Initially, because the detector employed suffered from paralysation, it has been necessary to establish its non-paralysed operating regime and to define a mathematical correction for its readings. To corroborate the findings, multiple estimations have been compared and the uncertainty evaluated, concluding acceptably low margins of error. Afterwards, the detector has been employed to survey the axial neutron flux distribution in the core. Measurements of the flux far from the fuel agree with the theoretical framework initially presented. The more complex case of a detector close to the fuel has been addressed through computational means: a basic simulation has been prepared to represent the core, and the result confirmed not only the emergence of relfector peaks, but it has also been compared with the experimental data. A satisfactory alignment has been achieved, considering the clear limitations inherent to such simulation.

Nevertheless, there are a few sources of error to highlight. First, every data point is the result of an average over detector readings. Thus, this uncertainty is inversely proportional to the averaging length. In any case, a statistical error remains unavoidable due to the inherent randomness of the fission reactions themselves, but at least the systematic error has been reduced by correcting the raw count rates and by validating this correction among two datasets. To reduce this variance, the calibration experiment should be performed multiple times, and the averaging time should be increased. However, a balance had to be found between the optimal parameters and the limited available time. // With the limited time resources available for the conducted experiment, the choice of parameters appears as a balanced way to minimise this error source.

A second source of error was the size of the measurement device itself. The 05NH1 detector employed is relatively small, with a diameter of $10$ mm and an active length of $10$ mm. This allowed us to consider it as a point detector relative to the $820$ mm of length of the fuel assemblies. Nonetheless, the ratio of the detector to the fuel already introduces an uncertainty of 1.22% ($plus.minus 10$ mm) in every axial measurement. This is exacerbated by the manual movement of the detector relative to a simple plastic ruler. This methodology, together with the suboptimal working position, may have been the source of an additional $plus.minus 10$ mm at each measurement step. To minimise this error, an automated detector lift mechanism would improve these experimental steps. However, this uncertainty is concealed by the intrinsically asymmetric flux distribution. In this regard, it can be excluded that the uneven flux shape has been caused by an improper experimental data collection, since the VR-1 coursebook also presents an asymmetric distribution, but performing multiple readings would further support this claim.

The role of the simulation was to evaluate the fidelity of the chosen constants to the measured flux, and to provide insights about how close the VR-1 reactor is to an ideal 1D slab. However, the simplistic nature of this simulation makes the outcome not particularly informative. Several reasons distinguish the true reactor from an ideal case, and this complicates the fitting procedure. A few examples are the asymmetric flux shape, the large flux at the boundaries, as well as incomplete information about the true fuel length and reflector start positions. To account for some of these, the simulation could be improved with small enhancements, such as asymmetric diffusion coefficients support and arbitrary zero-flux extrapolation outside the boundaries. These would already yield more flexible fits without significantly transforming the logic. //, and this could reveal instabilities
// Therefore, many details might need to be changed to make the simulation closer to the real conditions. 

It must also be mentioned that in reality, as explained in @ch_neutron_det, the assumption of the detector measuring a linear sum of fast and thermal fluxes is an approximation of the true $1 \/ v$ absorbing behaviour of He-3. The extent of this systematic error is not clear, but it does not invalidate the fitting nor the overall measured flux. To evaluate this imprecision, the experiment could be conducted again with a coating on the detector in order to subtract one of the two fluxes.

Moreover, the 1D slab model does not match the true geometry of the fuel assemblies, which are instead concentric square tubes. Even disregarding the surrounding geometry of the core, the shape of the bundles already undoubtedly leads to complex flux interactions that would require more sophisticated simulations. Additionally, the detector is positioned not directly within the fuel, but in a spot designed to resemble the conditions found inside it. Nonetheless, the simulation reinforces the hypothesis that this geometry remains sufficiently simple to produce roughly a 1D infinite slab-like flux distribution.

In conclusion, these two complementary experiments provide key information about the behaviour of a reactor. Neutron detectors are the fundamental monitoring and diagnostic tool of nuclear reactors, and must be calibrated to operate correctly in the chosen power regime. The axial flux distribution informs about power, heat, and fuel burn-up distributions, and the simple measurement procedure here implemented allowed to substantiate theoretical and simulation results. In this report, both experiments have been concluded successfully, and therefore they clearly show how the behaviour of a real reactor reflects the theory presented in textbooks.


//It must be mentioned that, according to photos taken during the experiment, it is unclear whether the detector in the fuel dummy was truly placed in C3, as it appears more likely to have been positioned in E3. This would not invalidate the results obtained nor the conclusions drawn, but  
//Overall, comparing two datasets allowed to exclude (or compensate for) human error in copying data on the spreadsheet.
//The assumption of the detector measuring a linear sum of fast and thermal fluxes is not verified
//The ratio of fluxes of the simulation fit matching that presented in the coursebook could be a random chance 

//It is not possible to directly compare all datasets acquired, because the detectors were positioned in different places inside the reactor. Nonetheless, two stations performed independent analysis on the same data is possible

//so not fully point detector, but small enough (p. 28)


//Systematic error: k_T (M) stable

//Simulation good ratio could be by chance

//More or less thermal/fast flux could reach the detector, so sum direct is not optimal
//== Improvements
//- using more coefficients in fit/simulation
/*
- moving 5cm?
- measuring only after 2-3 seconds (was it relevant? Nah.
- k_T factor is a function 5th degree... experimental
  - coming from previous calibration
- object dropped at 55cm up...
- 
*/

//tot_words = total.words

#pagebreak()

/*
#let tot_words = total.words - 27
#let tot_chars = total.characters

= Essay Word Count
According to the automatic counter of typst's "wordometer" extension, the text above contains #tot_words words and #tot_chars characters (excluding whitespaces and excluding this paragraph). //The word limit required me to delete .*/
])


#heading("AI use Statement", numbering: none)
//Perplexity and ChatGPT were used to create the document template.
//Perplexity was used as an online search engine to find potential sources, but all original documents have been accessed directly /*and the content has always been verified.*/
A local Ollama setup and Overleaf's Writefull were used to check grammar correctness and to brainstorm words synonyms.
//DeepL AI-powered write mode was used to enhance parts of a few selected sentences.
//NotebookLM was used as a source-exclusive brainstorming tool and a source-exclusive rapid search tool.
//All information mentioned by NotebookLM has always been personally verified through the original texts.
No sections of the report have been written by an LLM.
No full sentences generated by an LLM have been directly used.

Perplexity and ChatGPT have been used as guides to understand the simulation structure and outline the code steps, but the main logic has been manually implemented.
Some short code snippets of minor importance have been generated by and copied from Perplexity or ChatGPT for efficiency purposes.

//The underlying structure of the python code to convert the plots from excel to matplotlib figures has been generated by ChatGPT.
//The report is written by consulting directly the original papers, not by drawing information generated by any LLM.
//No other AI has been directly employed for writing or research.

#bibliography("ERP_report.bib")//, style:"custom-vancouver.csl")


#pagebreak()
#heading("Appendices", numbering: none)

#set heading(
  offset: 1,
  numbering: (_, ..rest) => "" + numbering("A.1", ..rest),
  supplement: [Appendix] // <- Important
)

= Simulation Code Details <app_discretisation>
The full code is available at the following #link("https://github.com/z-fil/Reflector-Peaks-Simulation","GitHub repository link: z-fil/Reflector-Peaks-Simulation"). The simulation has been implemented in Python, with the help of basic libraries such as numpy and scipy.

== Discretisation
It is essential to correctly translate the physical equations and conditions into a faithful code. To this end, this section illustrates the derivations of the fundamental simulation components.

First, the diffusion equations for this slab reactor in the fuel assemblies are
$ -D_(1,f) (d^2 phi.alt_1)/(d x^2) + Sigma_(a,f) phi.alt_1 = 1/k_("eff") nu Sigma_f phi.alt_T, $ 
$ -overline(D)_f (d^2 phi.alt_T)/(d x^2) + overline(Sigma)_(a,f) phi.alt_T = Sigma_(s 1,f) phi.alt_1, $

while in the reflector there is no fission alimenting the fast flux, therefore the first source term cancels, and we are left with
$ -D_(1,r) (d^2 phi.alt_1)/(d x^2) + Sigma_(a,r) phi.alt_1 = 0, $

$ -overline(D)_(r) (d^2 phi.alt_T)/(d x^2) + overline(Sigma)_(a,r) phi.alt_T = Sigma_(s 1,r) phi.alt_1. $

The flux is found as a solution of these reactor equations. With a finite-difference approach, the left-hand side operator must be discretised, for example using the central difference formula
$ A f^('')(x) = A (d^2 f(x))/(d x^2) /*A d/(d x) d/(d x) f = A d/(d x) (f_(i+1)-f_(i))/(Delta x) 
$*/ overset(==>, "discretised") f^('')_i = (A_(i-1)f_(i-1) - 2 A_i f_(i) + A_(i+1)f_(i+1))/((Delta x)^2). /*overset(==>, A_(i-1) = A_i = A_(i-1)) f^('')_i = A (f_(i-1) - 2 f_(i) + f_(i+1))/((Delta x)^2).*/ $

In the code, these will constitute the elements of the operator matrix. In the bulk of each considered section, its rows will be simply
$ [A_(i,i-1), A_(i,i), A_(i,i+1)] = D_i /((Delta x)^2) [1, -2, 1] + Sigma_(a,i) [0, 1, 0]. $ <eq_op>

The interfaces will require additional care and logic that will alter the operator of @eq_op. In fact, there are two boundary conditions to consider. The first one is the zero-flux at the extrapolated boundaries, which can be found via a linear extrapolation of the edge cell to the extrapolated length $tilde(d)$. Taking the right boundary as example, this condition will alter the last row of the operator matrix as:
$ 0 = phi.alt(z+tilde(d)) approx phi.alt(z) + tilde(d)(d phi.alt)/(d x) $ //=>  phi.alt(z) = -tilde(d)(d phi.alt)/(d x) $
$ overset(==>, "discretised") 0 = phi.alt_n + tilde(d)(phi.alt_(n)-phi.alt_(n-1))/(Delta x) $
$ => phi.alt_n (1+(tilde(d))/( Delta x)) - phi.alt_(n-1) (tilde(d))/( Delta x) = 0 $

/*
$ 0 = phi.alt(-tilde(d)) approx phi.alt(0) - tilde(d)(d phi.alt)/(d x) =>  phi.alt(0) = tilde(d)(d phi.alt)/(d x) $
$ overset(==>, "discretised") phi.alt_0 = tilde(d)(phi.alt_(1)-phi.alt_(0))/(Delta x) $
$ => phi.alt_0 (1+(tilde(d))/(Delta x)) - phi.alt_(1) (tilde(d))/( Delta x) = 0 $
*/


The second condition is continuity of flux $phi.alt_f = phi.alt_r$ (where the subscripts indicate fuel and reflector, respectively), in addition to continuity current $bold(J) = -D grad phi.alt$ at the interface between fuel and reflector, which is written as
$ D_("fuel") lr((d phi.alt_f)/(d x)|)_(z=R) = D_("reflector") lr((d phi.alt_(r))/(d x)|)_(z=R). $

In discretised form, an approach to enforce these conditions involves using a mean diffusion coefficient at half-cells on the interfaces. For example, at the right interface, let the last fuel cell be at $i$ and the first reflector cell at $i+1$. Now, the current at these half-cells will be
$ J_(i plus.minus 1 \/ 2) = /*D d/(d x) phi.alt approx*/ minus.plus D_(i plus.minus 1 \/ 2) (phi.alt_(i plus.minus 1) - phi.alt_(i))/ (Delta x) $ <eq_current>
where the half-cell diffusion coefficient can be calculated as the harmonic mean of its neighbours:
$ D_(i plus.minus 1 \/ 2) = (2 D_i D_(i plus.minus 1))/(D_i + D_(i plus.minus 1)). $

In full generality, using @eq_current, the new operator becomes 
$ -d/(d x) (D d/(d x)phi.alt) overset(approx, "discretised") -(J_(i+1 \/ 2) - J_(i-1 \/ 2))/(Delta x) $
$ = -1/(Delta x) (-D_(i + 1 \/ 2) (phi.alt_(i + 1) - phi.alt_i)/(Delta x) -D_(i - 1 \/ 2) (phi.alt_(i-1) - phi.alt_i)/(Delta x)) $
$ = (D_(i - 1 \/ 2))/((Delta x)^2) phi.alt_(i - 1) - (D_(i - 1 \/ 2) + D_(i + 1 \/ 2))/((Delta x)^2) phi.alt_i + (D_(i + 1 \/ 2))/((Delta x)^2) phi.alt_(i + 1). $ <eq_staggered>

Since on the right interface of the simulation it holds that $D_(i-1 \/ 2) = D_f$, @eq_staggered simplifies to
$ underbrace(D_f/((Delta x)^2) phi.alt_(i - 1), "Unchanged from bulk") - underbrace((D_f + D_(i + 1 \/ 2))/((Delta x)^2) phi.alt_i + (D_(i + 1 \/ 2))/((Delta x)^2) phi.alt_(i + 1), "Terms to adjust") $

which can now directly be applied to the code. A similar approach must be used to correct the coefficients at $i+1$.


== Criticality Iteration
The second part of the simulation involves an iteration until stability of the multiplication factor $k_("eff")^((n+1))$, where the superscript indicates the generation index. By definition of $k$, this is performed by comparing the new and the current (old) neutron populations, i.e. the magnitude of the source, as
$ k_("eff")^((n+1)) = (sum_i S_i^((n+1))) / (sum_i S_i^((n))), quad "where" quad S^((n)) = nu Sigma_a phi.alt^((n)), $
//where the new source is found with the new flux $phi.alt^((n+1))$,

and convergence is considered reached when
$ | k_("eff")^((n+1)) - k_("eff")^((n)) | < epsilon. $ <eq_eps>

As starting parameters, the simple geometry allows for basic values like $bold(phi.alt)^(0) = bold(1) $, $bold(S)^(0) = bold(1)$, and $k_("eff")^(0)=1$. This holds for both fast and thermal flux. The iteration works according to the following logic:
$ "Define" S_(1",old") = S_1 --> "solve" phi.alt_1 (S_1) --> "find" S_T (phi.alt_1) --> "solve" phi.alt_T (S_T) \ --> "normalise fluxes" --> "find" S_1(phi.alt_T) --> "find" k_("eff") = S_1/S_(1",old") $ <eq_loop>

where the exit condition is @eq_eps, and the arguments between brackets indicate function inputs. These functions are represented via the following linear systems, which can be expressed in the form $A bold(x)=bold(b)$ to be solved for $bold(x)$:

$ A_1 bold(phi.alt)_1^((n + 1)) = bold(b)_1^((n)) quad "where" quad bold(b)_1^((n)) = S_1 =
  cases(
    1/k_("eff") nu Sigma_f phi.alt_T^((n)) quad "(fuel)",
    0  quad   quad   quad   quad "   (reflector)"
  ) $
$ A_T bold(phi.alt)_T^((n + 1)) = bold(b)_T^((n))  quad "where" quad bold(b)_T^((n)) = S_T = Sigma_(s 1) bold(phi.alt)_1^((n)) quad "(fuel and reflector)", $

where, because of normalisation, the term $nu Sigma_f$ of the fast source becomes a negligible amplitude. The latter two equations are the most computationally intensive parts of the code, therefore, the simulation in maintained below 1000 cells for compatibility with the fitting process which calls these functions multiple times via the iteration in @eq_loop, scaling as $n$ (fit optimisation steps) $times i$ (iterations for convergence).

//= temporary sources test
//a@haniaThoriumOxideFuel2012 @lewisFissionProductChemistry2012 @meyerCompositeFuelCermet2012 
//Sources are  thing @araiNitrideFuel2012 @benesMoltenSaltReactor2012 @senguptaCarbideFuel2012 @lewisFissionProductChemistry2012 @ogataMetalFuel2012 @haniaThoriumOxideFuel2012
//a@haniaThoriumOxideFuel2012 @lewisFissionProductChemistry2012 @meyerCompositeFuelCermet2012 @ogataMetalFuel2012 
//then@pillonActinideBearingFuelsTransmutation2012, @cerulloGenerationIVReactor2012
//?? examples@cerulloGenerationIVReactor2012 @benesMoltenSaltReactor2020 @leeMaterialPerformanceMolten2020 @advancesBenes2020 
//This significant shift occurs alongside the emergence of two distinct categories.
// not only to improve on gen III characteristics, but also to complement their
//in combination with common water-moderated reactors
//a massive engineering challenge arise. 


= Neutron Detector Movement
#figure(
  image("./imgs/detector_movement.JPG", width: 80%),
  caption: [Image showing the manual stepwise lift of the neutron detector. \ In this case, the detector being operated was the one in the empty fuel structure outside the core (G4).]
) <fig_det_mov>

// we need more care in the boundary conditions and solve fissioning and non-fissioning parts separately

/*, which will now be called core and reflector, respectively. Inside the core, the reduced cosinusoidal solution is still valid but it follows from the symmetric nature of the problem around $z=0$:
$ phi.alt_c (z) = C cos(B z), $
while for the reflector we need to resort to the reactor equation @reac_eq. Assume therefore a reflector of length $d$ placed above (z=a/2) and below (z=-a/2) the core. Since here there is no active source of neurons, following the same procedure as above yields the simplified case
$ (d^2 phi.alt_r)/(d x^2) + 1/L^2 phi.alt_r = 0. $
which is analogous to @1D_eigenv, but $L_r^2 = Sigma_(a r)/D_r $ is the one-group reflector diffusion area. The new boundary conditions for this portion outside the core are
$ phi.alt_r (plus.minus a/2 plus.minus tilde(d)) = 0 $
$ phi.alt_r (plus.minus a/2) = phi.alt_c (plus.minus a/2); $ <c_flux>
$ D_r d/(d x) phi.alt_r (plus.minus a/2) = D_c d/(d x) phi.alt_c (plus.minus a/2). $ <c_curr>
The first two conditions imply that the shape of the flux will have an exponential decay trend, which can be conveniently rewritten with hyperbolic functions as
$ phi.alt_r(z) = U sinh(z/L_r) + V cosh(-z/L_r). $

Accounting for the origin system and discarding the nonphysical part of this solution, it can be shown that the reflector flux becomes
$ phi.alt_r (z) = U sinh((z-a/2-tilde(d))/L_r) $

We now use the continuity of flux (@c_flux) and continuity of current (@c_curr) to solve for $U$ and $C$.
$ U lr(sinh((z-a/2-tilde(d))/L_r)|)_(z=a/2) = C lr(cos(B z)|)_(z=a/2) $
$ U sinh((-tilde(d))/L_r) = C cos(B a/2) $
$ U = C cos(B a/2)/(sinh((-tilde(d))/L_r)) $
and
$ U D_r d/(d x) lr(sinh((z-a/2-tilde(d))/L_r)|)_(z=a/2) = D_c d/(d x) C lr(cos(B z)|)_(z=a/2) $
$ U D_r 1/L_r lr(cosh((z-a/2-tilde(d))/L_r)|)_(z=a/2) = -D_c C B lr(sin(B z)|)_(z=a/2) $
$ U D_r 1/L_r cosh((-tilde(d))/L_r) = -D_c C B sin(B a/2) $
$ B = -(U D_r)/(C D_c) 1/L_r cosh((-tilde(d))/L_r)/(sin(B a/2)) $
$ B = -cos(B a/2)/(sinh((-tilde(d))/L_r)) (D_r)/(D_c) 1/L_r cosh((-tilde(d))/L_r)/(sin(B a/2)) $
$ B = -1/(tanh((-tilde(d))/L_r)) (D_r)/(D_c) 1/L_r/(tan(B a/2)) $
*/

//which, in the absence of external sources, becomes
// radio max flux vs average flux
// 
//In summary, according to standard reactor theory, the axial flux is expected to follow a cosine shape, but reflector peaks will also be visible especially near the fuel rods. // according to [.........]