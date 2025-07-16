# Building and Running an Aquatic Ecosystem Model Ensemble in R

> ℹ️ **Info:** Workshop materials are still currently being updated.
> Please check back later for the latest version.

--------------------------------------------------------------------------------

:spiral_calendar: July 23, 2025\
:alarm_clock: 19:00 - 21:00 UTC :busts_in_silhouette: Tadhg Moore, Whitney Woelmer & Deniz Özkundakci\
:computer: [Material](https://github.com/tadhg-moore/Ecological-Modelling-Workshop)
:open_book:
[Presentation](https://docs.google.com/presentation/d/e/2PACX-1vSnuZRU60QIKCpXdnhWJCNwOLI1xTPusY_AGQRkk9qEtJNvN-diVZGJbd26YHdnQAovjhoGCkh3CiR6/pub?start=true&loop=false&delayms=5000)

--------------------------------------------------------------------------------

## Description

This workshop will guide participants through the process of setting up and
running an aquatic ecosystem model ensemble in R, covering data requirements,
handling missing data, and implementing one-dimensional lake models.
Participants will gain hands-on experience with model setup, execution, and
customization for new lakes, using R-based coding.

## Learning Objectives

1.  Define and understand aquatic ecosystem models.

2.  Identify and source inputs for 1D process-based lake models using national
    or global datasets.

3.  Use the AEME R package to set up, run, and analyze aquatic ecosystem model
    ensembles.

4.  Evaluate the benefits of ensemble modeling and large-scale lake modeling.

5.  Develop a plan to configure inputs and parameters for modeling new lake
    systems.

## Pre-requisites

Running the Aquatic Ecosystem Model Ensemble (AEME) requires a Windows
environment. Participants should have the following software installed on their
computers:

1.  Install [R](https://cran.r-project.org/) and [RStudio
    Desktop](https://posit.co/downloads/) on your computer.

2.  Install the AEME package by running the following code in RStudio:

``` r
install.packages("remotes")
remotes::install_github("limnotrack/AEME")
remotes::install_github("limnotrack/aemetools")
```

## Workshop Outline

| **Time** | **Activity** |
|----|----|
| 19:00 | Welcome |
| 19:05 | Introduction to Aquatic Ecosystem Modelling |
| 19:10 | Overview of Lake Ecosystem Research New Zealand (LERNZ) Modelling Platform |
| 19:30 | Explore LERNZmp |
| 20:00 | Introduction to R Activity |
| 20:10 | R Activity - Setting up and running of AEME in R |
| 21:30 | Using AEME in your lake |

## Useful Links

-   [AEME](https://limnotrack.github.io/AEME/)
-   [aemetools](https://github.com/limnotrack/aemetools)
-   [bathytools](https://github.com/limnotrack/bathytools)
-   [LERNZmp](https://limnotrack.shinyapps.io/LERNZmp/)
-   [LERNZ](https://www.waikato.ac.nz/research/institutes-centres-entities/entities/lake-ecosystem-research-new-zealand-lernz/)
