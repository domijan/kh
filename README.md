<!-- README.md is generated from README.Rmd. Please edit that file -->

# kh package

<!-- badges: start -->
<!-- badges: end -->

The goal of `kh` is to make it easier to fit areal spatial models which
deal with contiguity.

It aims to do this with a collection of pre- and post-processing tools.

Two packages which are commonly used to fit such models are `mgcv` and
`brms`.

1.  This package has *pre-processing tools* which take an `sf` spatial
    object and generate a contiguity structure in the form which is
    required by the modelling package.

| Function                | Stage      | Purpose                                                                                                              |
|-------------------|-------------------|-----------------------------------|
| make_contigs()          | **CREATE** | generates a contiguity object, by any chosen level, with the option of joining islands to their nearest k neighbours |
| quickmap_contigs()      | **CHECK**  | generates a quick-reference contiguity map of a contiguity object                                                    |
| find_neighbours()       | **EDIT**   | outputs the names of any unit’s neighbours within the contiguity object                                              |
| manual_link_name()      | **EDIT**   | link two units (by name) as neighbours which are not already neighbours                                              |
| manual_unlink_name()    | **EDIT**   | unlink two units (by name) which are currently neighbours                                                            |
| manual_link_numeric()   | **EDIT**   | link two units (by index number) as neighbours which are not already neighbours                                      |
| manual_unlink_numeric() | **EDIT**   | unlink two units (by index number) which are currently neighbours                                                    |

1.  The model can then be fit as normal within `mgcv` or `brms`.
2.  The *post-processing tools* then extract the results of the model
    into a tidy `sf` format so they can easily be mapped.

| Function         | Purpose               |
|------------------|-----------------------|
| tidy_estimates() | **TIDY RESULTS**      |
| quickmap()       | **VISUALISE RESULTS** |

## Installation

You can install the development version of `kh` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("horankev/kh")
```

For this example, we load some spatial data from these sources:

``` r
# required packages
packages <- c(
  "rnaturalearth",
  "sf",
  "tidyverse",
  "parlitools",
  "ggpubr",
  "mgcv"
  )

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Packages loading
invisible(lapply(packages, library, character.only = TRUE, quietly = TRUE))
```

## Example

Often when preparing areal spatial data, the presence of uncontiguous
areas (such as islands or exclaves) can create difficulties. We might
also want to account for some hidden contiguities by allowing bridges,
tunnels etc. to render two uncontiguous areas as neighbours. These
*pre-processing* functions help to make the process of generating
neighbourhood structures less complicated.

### Pre-processing functions

The following set of functions are useful for preparing a neighbourhood
structure from an `sf` object for use with `mgcv`. They suggest three
stages in this process: *creation*, *checking* and *editing*. The second
and third can be looped as necessary. First *create* a contiguity list,
then *check* a map of it to see if it looks appropriate. Functions for
further manual *editing* can then be used until it looks as it should.

| Function                | Stage      | Purpose                                                                                                              |
|-------------------|-------------------|-----------------------------------|
| make_contigs()          | **CREATE** | generates a contiguity object, by any chosen level, with the option of joining islands to their nearest k neighbours |
| quickmap_contigs()      | **CHECK**  | generates a quick-reference contiguity map of a contiguity object                                                    |
| find_neighbours()       | **EDIT**   | outputs the names of any unit’s neighbours within the contiguity object                                              |
| manual_link_name()      | **EDIT**   | link two units (by name) as neighbours which are not already neighbours                                              |
| manual_unlink_name()    | **EDIT**   | unlink two units (by name) which are currently neighbours                                                            |
| manual_link_numeric()   | **EDIT**   | link two units (by index number) as neighbours which are not already neighbours                                      |
| manual_unlink_numeric() | **EDIT**   | unlink two units (by index number) which are currently neighbours                                                    |

``` r
library(kh)
## basic example code
```

#### make_contigs()

#### quickmap_contigs()

The following is a map of the UK from the `rnaturalearth` package. It
features many non-contiguous units. In the following example of
`make_contigs`, the argument k is set to one. This means that in
addition to all of the normal contiguities, all islands will be joined
to the one unit which is closest to them. This can be piped into the
`quickmap_contigs` function so that the contiguities can be visually
inspected.

For a country with many islands such as Indonesia, we can compute
contiguities by individual island:

``` r

indonesia <- ne_states(country="indonesia", returnclass = "sf") |> 
  st_cast("POLYGON")
indonesia$id <-1:nrow(indonesia)
indonesia_cont <- make_contigs(data = indonesia,
                               unit = id,
                               link_islands_k = 2, 
                               modelling.package = "brms") |> 
  quickmap_contigs(indonesia, id)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

Rather than operating at the individual island level, this can be done
at a higher level by changing an argument in the function.

``` r

indonesia <- ne_states(country="indonesia", returnclass = "sf") |> 
  st_cast("POLYGON")
indonesia$id <-1:nrow(indonesia)
indonesia_cont <- make_contigs(data = indonesia,
                               unit = name,
                               link_islands_k = 2,
                               modelling.package = "mgcv") |> 
  quickmap_contigs(indonesia, name)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

If we wish to use `mgcv`, we get a neighbourhood list:

``` r

make_contigs(data = indonesia,
             unit = name,
             link_islands_k = 2,
             modelling.package = "mgcv") |> 
  head(8)
#> $Aceh
#> [1] 32
#> 
#> $Bali
#> [1] 11 20
#> 
#> $`Bangka-Belitung`
#> [1]  8 31
#> 
#> $Banten
#> [1] 7 9
#> 
#> $Bengkulu
#> [1]  8 17 30 31
#> 
#> $Gorontalo
#> [1] 27 29
#> 
#> $`Jakarta Raya`
#> [1] 4 9
#> 
#> $Jambi
#> [1]  3  5 16 24 30 31
```

Or we can get a neighbourhood matrix by selecting `brms`:

``` r

temp <- make_contigs(data = indonesia,
                     unit = name,
                     link_islands_k = 2,
                     modelling.package = "brms") 
temp[1:10,1:10]
#>                 [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#> Aceh               0    0    0    0    0    0    0    0    0     0
#> Bali               0    0    0    0    0    0    0    0    0     0
#> Bangka-Belitung    0    0    0    0    0    0    0    1    0     0
#> Banten             0    0    0    0    0    0    1    0    1     0
#> Bengkulu           0    0    0    0    0    0    0    1    0     0
#> Gorontalo          0    0    0    0    0    0    0    0    0     0
#> Jakarta Raya       0    0    0    1    0    0    0    0    1     0
#> Jambi              0    0    1    0    1    0    0    0    0     0
#> Jawa Barat         0    0    0    1    0    0    1    0    0     1
#> Jawa Tengah        0    0    0    0    0    0    0    0    1     0
```

This could be changed to join each island to the two closest units as in
this example with the countries of Asia.

``` r

asia <- ne_countries(continent="asia", returnclass = "sf")
asia_cont <- make_contigs(data = asia,
                    unit = admin,
                    link_islands_k = 2) |> 
  quickmap_contigs(asia, admin)
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />

``` r

make_contigs(data = asia,
             unit = admin,
             link_islands_k = 2,
             modelling.package = "mgcv") |> 
  head(8)
#> $Afghanistan
#> [1]  8 14 31 40 43 45
#> 
#> $Armenia
#> [1]  3 11 14 42
#> 
#> $Azerbaijan
#> [1]  2 11 14 42
#> 
#> $Bangladesh
#> [1] 12 26
#> 
#> $Bhutan
#> [1]  8 12
#> 
#> $Brunei
#> [1] 24 33
#> 
#> $Cambodia
#> [1] 22 41 46
#> 
#> $China
#>  [1]  1  5 12 19 21 22 25 26 27 28 31 39 40 46
```

``` r

temp <- make_contigs(data = asia,
                     unit = admin,
                     link_islands_k = 2,
                     modelling.package = "brms")
temp[1:10,1:10]
#>             [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#> Afghanistan    0    0    0    0    0    0    0    1    0     0
#> Armenia        0    0    1    0    0    0    0    0    0     0
#> Azerbaijan     0    1    0    0    0    0    0    0    0     0
#> Bangladesh     0    0    0    0    0    0    0    0    0     0
#> Bhutan         0    0    0    0    0    0    0    1    0     0
#> Brunei         0    0    0    0    0    0    0    0    0     0
#> Cambodia       0    0    0    0    0    0    0    0    0     0
#> China          1    0    0    0    1    0    0    0    0     0
#> Cyprus         0    0    0    0    0    0    0    0    0     0
#> East Timor     0    0    0    0    0    0    0    0    0     0
```

Applied to the situation of modelling voting behaviour in the UK, we can
set up contiguities according to administrative level.

``` r

# prepare the data
# extract and join census and election data from parlitools package
census_11 <- parlitools::census_11 |> 
  select(-constituency_name,-constituency_type,-pano, -region, -country)
bes_2019 <- parlitools::bes_2019

elect_results <- left_join(bes_2019,census_11, by=c("ons_const_id"))
uk_map_download <- st_read(
  "https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WPC_Dec_2019_UGCB_UK_2022/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson",
  quiet = TRUE)

# only need the boundaries and the IDs for merging with parlitools data
uk <- uk_map_download |> 
  select(pcon19cd,geometry) |> 
  st_transform(crs=27700)

uk_admins <- elect_results |> 
  left_join(uk, by=c("ons_const_id"="pcon19cd")) |> 
  mutate(region = factor(region),
         county = factor(county),
         constituency_name = factor(constituency_name),
         geometry = geometry) |> 
  rename(constituency = constituency_name) |> 
  st_as_sf()
```

For regions, counties and constituencies:

``` r

ggarrange(
uk_admins |> 
  make_contigs(unit = region,
                    link_islands_k = 1) |> 
  quickmap_contigs(uk_admins, region),

uk_admins |> 
  make_contigs(unit = county,
                    link_islands_k = 1) |> 
  quickmap_contigs(uk_admins, county),

uk_admins |> 
  make_contigs(unit = constituency,
                    link_islands_k = 1) |> 
  quickmap_contigs(uk_admins, constituency),

ncol=3
)
```

<img src="man/figures/README-unnamed-chunk-11-1.png" width="100%" />

#### manual_link_name()

#### manual_unlink_name()

#### manual_link_numeric()

#### manual_unlink_numeric()

We can use `manual_link_name` to add additional contiguities using the
name of the units. This can also be done using the number of the unit
(which is provided in the neighbourhood list, rather than the names)
using `manual_link_numeric`. Here we link Northern Ireland to Cornwall:

``` r

make_contigs(data = uk_admins,
                    unit = county,
                    link_islands_k = 1) |> 
  manual_link_name("Northern Ireland","Cornwall") |> 
  quickmap_contigs(uk_admins, county)
```

<img src="man/figures/README-unnamed-chunk-12-1.png" width="100%" />

or `manual_unlink_name` to unlink units using their names. Here, we
unlink the East and West Midlands, and also the North West and North
East:

``` r

make_contigs(data = uk_admins,
                    unit = region,
                    link_islands_k = 1) |> 
  manual_unlink_name("East Midlands","West Midlands") |> 
  manual_unlink_name("North West","North East") |> 
  quickmap_contigs(uk_admins, region)
```

<img src="man/figures/README-unnamed-chunk-13-1.png" width="100%" />

In the following example, we link island constituencies to their nearest
3 constituencies:

``` r

uk_admins |> 
  make_contigs(unit = constituency,
                    link_islands_k = 3) |> 
  quickmap_contigs(uk_admins, constituency)
```

<img src="man/figures/README-unnamed-chunk-14-1.png" width="100%" />

#### find_neighbours()

But which three constituencies have now been link to the Isle of Wight?
Using the `find_neighbours` function…

``` r

uk_admins |> 
  make_contigs(unit = constituency,
                      link_islands_k = 3) |> 
  find_neighbours("Isle Of Wight")
#> [1] "Gosport"         "New Forest East" "New Forest West"
```

I only wanted Gosport. So I will remove the other two…

``` r

uk_admins |> 
  make_contigs(unit = constituency,
                      link_islands_k = 3) |> 
  manual_unlink_name("Isle Of Wight","New Forest East") |> 
  manual_unlink_name("Isle Of Wight","New Forest West") |> 
  find_neighbours("Isle Of Wight")
#> [1] "Gosport"
```

### Post-processing functions

| Function         | Purpose               |
|------------------|-----------------------|
| tidy_estimates() | **TIDY RESULTS**      |
| quickmap()       | **VISUALISE RESULTS** |

The function `tidy_estimates` takes a fitted `mgcv::gam` model and
returns computed estimates and standard errors for any random effects
and/or Markov random field spatial smoothing components, attached to an
appropriate (spatial) dataframe.

First use the pre-functions:

``` r

nb_england <- uk_admins |> 
  filter(country %in% "England") |> 
  make_contigs(unit = constituency,
                    link_islands_k = 3) |> 
  manual_unlink_name("Isle Of Wight","New Forest East") |> 
  manual_unlink_name("Isle Of Wight","New Forest West")
  
df_england <- uk_admins |> 
  filter(country %in% "England") |> 
  mutate(constituency = factor(constituency),
         region = factor(region),
         county = factor(county))
```

Then fit a `gam` model with a combination of random effects and ICAR
components:

``` r

model <- gam(con_17 ~ 
               born_england + 
               deprived_1 + 
               degree + 
               s(region, bs="re") +
               s(county, bs="re") +
               s(constituency, by=born_england, bs='mrf', xt=list(nb=nb_england),k=50) +
               s(constituency, by=deprived_1, bs='mrf', xt=list(nb=nb_england),k=50) +
               s(constituency, by=degree, bs='mrf', xt=list(nb=nb_england),k=50),
             data=df_england, method="REML")
```

Then use the post-functions to generate output:

#### tidy_estimates()

``` r

output <- tidy_estimates(model, df_england)
```

The output shown below displays the estimates and standard errors of
each component of the model for the first 5 constituencies
alphabetically, as an `sf` dataframe which can be easily mapped:

``` r

head(output[,1:10])
#> Simple feature collection with 6 features and 10 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 368282 ymin: 101579.6 xmax: 532401.3 ymax: 393553.9
#> Projected CRS: OSGB36 / British National Grid
#>   random.effect.region random.effect.county
#> 1         6.073839e-04             1.706711
#> 2        -5.774813e-05            -2.703870
#> 3        -4.414490e-04            -1.505832
#> 4         2.417885e-05             1.090575
#> 5         6.073839e-04             2.668064
#> 6         2.417885e-05            -2.382387
#>   mrf.smooth.constituency|born_england mrf.smooth.constituency|deprived_1
#> 1                            11.629070                           28.52421
#> 2                             1.872756                           19.69007
#> 3                           -12.234466                           11.23745
#> 4                            -2.637204                           17.71635
#> 5                             7.127869                           25.82921
#> 6                            -2.938126                           18.32714
#>   mrf.smooth.constituency|degree se.random.effect.region
#> 1                       1.067502              0.03766500
#> 2                       6.371619              0.03766566
#> 3                      19.993120              0.03766621
#> 4                       4.072850              0.03766501
#> 5                      -4.036583              0.03766500
#> 6                       2.438712              0.03766501
#>   se.random.effect.county se.mrf.smooth.constituency|born_england
#> 1                2.508186                                3.901682
#> 2                2.365326                                3.417439
#> 3                2.358090                                4.065510
#> 4                2.264675                                3.712115
#> 5                2.513013                                5.573187
#> 6                2.596432                                4.025844
#>   se.mrf.smooth.constituency|deprived_1 se.mrf.smooth.constituency|degree
#> 1                              11.64201                          2.738666
#> 2                              11.78601                          1.792209
#> 3                              10.57810                          4.511394
#> 4                              11.17196                          1.572283
#> 5                              11.84416                          3.871403
#> 6                              11.61155                          1.121780
#>                         geometry
#> 1 MULTIPOLYGON (((485408.1 15...
#> 2 MULTIPOLYGON (((406519.5 30...
#> 3 MULTIPOLYGON (((379104.1 39...
#> 4 MULTIPOLYGON (((444868.5 35...
#> 5 MULTIPOLYGON (((506643.3 12...
#> 6 MULTIPOLYGON (((449576.1 36...
```

#### quickmap()

A list containing plots (maps, as they are spatial) of the components
can be generated with this function:

``` r

plot_list <- quickmap(output)
ggarrange(plotlist = plot_list, 
          legend = "none",
          ncol = 3,
          nrow = 2)
```

<img src="man/figures/README-unnamed-chunk-21-1.png" width="100%" />
