# NRS Populations Data Visualisations

Some data visualisations created from [NRS](https://www.nrscotland.gov.uk) population data (estimates and projections), using [R](https://www.r-project.org) and [ggplot](https://ggplot2.tidyverse.org). Data was obtained from NHS Scotland's [CKAN](https://ckan.org) [OpenData](https://www.opendata.nhs.scot) portal, using [ckanr](https://github.com/ropensci/ckanr). Animation were produced using [gganimate](https://github.com/thomasp85/gganimate). Code can be found [here](NRS_populations_viz.R).

## Age Distribution | 2020
![Age distribution for Scotland's population as of 2020](plot_age_dist_2020.png)

## Animated Age Distribution | 1974 -- 2043
![Animated age distributions for Scotland's population, from 1974 -- 2043 ](plot_age_dist_anim.gif)

## Population Age Distribution Heatmap
![Population age distribution heatmap](plot_carpet1.png)

## Population Birth Year Distribution Heatmap
![Population birth year distribution heatmap](plot_carpet2.png)

## Decadal Birth Year Population Curves
![Decadal birth year population curves](plot_10years.png)

## Animated Annual Relative Change in Population, by Birth Year
(note: red is projected data)
![Animated annual relative change in population, by birth year](plot_birth_year_change_anim.gif)

## Unknown Pleasures Ripoffs
Inspired by the [famous](https://blogs.scientificamerican.com/sa-visual/pop-culture-pulsar-origin-story-of-joy-division-s-unknown-pleasures-album-cover-video/) [pulsar](https://en.wikipedia.org/wiki/PSR_B1919%2B21) timing chart / Joy Division album [cover](https://www.google.com/search?q=unknown+pleasures&bih=837&biw=1440&hl=en-GB&sxsrf=ACYBGNTyRWgVql-yZuNNQVfS3d7hamRTBg:1577980303072&source=lnms&tbm=isch&sa=X&ved=2ahUKEwj7-bTbouXmAhVoQEEAHVHCA7QQ_AUoAXoECBEQAw).

Same data as animated plot above, but stacked vertically rather than animated.
![](plot_unknown_pleasures.png)

Finally, a more stylised version of the above.
![](plot_unknown_pleasures2.png)



