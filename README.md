# NRS Populations Data Visualisations
Some data visualisations created from [NRS](https://www.nrscotland.gov.uk) population data (estimates and projections), using [R](https://www.r-project.org) and [ggplot](https://ggplot2.tidyverse.org). Data was obtained from the [NHS Scotland](https://www.scot.nhs.uk) [CKAN](https://ckan.org) [OpenData](https://www.opendata.nhs.scot) portal, using [ckanr](https://github.com/ropensci/ckanr). Animations were produced using [gganimate](https://github.com/thomasp85/gganimate). Code can be found [here](NRS_populations_viz.R), and a slightly more detailed blog post [here](blog.bobtaylor.xyz/population-data-viz/).


## Age Distribution | 2020
A histogram of the age distribution of Scotland's current population. 

![Age distribution for Scotland's population as of 2020](plot_age_dist_2020.png)

* the large peak at 90 years old represents the population of age 90 *and over*.)


## Animated Age Distribution | 1974 - 2043
An annotated and annotated histogram of Scotland's age distribution, showing how it has evolved, and is projected to evolve over time.

![Animated age distributions for Scotland's population, from 1974 -- 2043 ](plot_age_dist_anim.gif)

* the following groups are annotated: [Baby Boomers](https://en.wikipedia.org/wiki/Baby_boomers), [Gen-X](https://en.wikipedia.org/wiki/Generation_X), [Gen-Y](https://en.wikipedia.org/wiki/Millennials), and [Gen-α](https://www.theguardian.com/society/shortcuts/2019/jan/04/move-over-millennials-and-gen-z-here-comes-generation-alpha).


## Population Age Distribution Heat-map
A heat-map, showing the same data as the animated histogram above. The data is represented with the single year population age "bins" along the x-axis as before, but with the time dimension now on the y-axis. Larger population is shown as dark blue, with smaller populations as lighter blues.

![Population age distribution heatmap](plot_carpet1.png)

* any data above the red line is a projection (i.e. into the future) rather than an estimation
* different population age groups are noticeable as diagonal features, which generally become lighter (smaller population) as they age
* there is a notable lighter vertical band to the left of the 19 year old age group, from about 1985 onward, indicating an *increase* in this age group occurs each year



## Population Birth Year Distribution Heat-map
A version of the previous heat-map, re-framed in terms of birth year rather than age.

![Population birth year distribution heatmap](plot_carpet2.png)

* the lighter band around WWI implies fewer births in this period (with a corresponding increase shortly after the war)
* a similar effect is visible after WWII, with a very notable dark band around 1946/1947 indicating a larger population with those birth years


## Decadal Birth Year Population Curves
Population curves for different birth year groups (one per decade).

![Decadal birth year population curves](plot_10years.png)

* those born from 1900 - 1970 are generally decreasing sharply in this period; the 1980 group is roughly flat; and the 1990 - 2040 groups are increasing
* the 1990 - 2020 groups show the increase in population at about 19 years old that was visible in previous plots


## Animated Annual Relative Change in Population
By comparing the population to that in the preceding year, we can see how much the population changes in each birth year group; e.g. if there are 10,000 people who were born in 1940, alive in 1980, and in 1981 this has changed to 9,500 people, the change would be -5%. The animation below shows this plot for each birth year group.

![Animated annual relative change in population, by birth year](plot_birth_year_change_anim.gif)

* the red dotted lines represent projected data
* as you would expect, the is larger *negative* change towards larger age
* as noted previously, one significant feature is the increase in population in 19-year-olds from the mid-1980s onward


## **Unknown Pleasures** Ripoffs
Inspired by the [famous](https://blogs.scientificamerican.com/sa-visual/pop-culture-pulsar-origin-story-of-joy-division-s-unknown-pleasures-album-cover-video/) [pulsar](https://en.wikipedia.org/wiki/PSR_B1919%2B21) timing chart / Joy Division album [cover](https://www.google.com/search?q=unknown+pleasures&bih=837&biw=1440&hl=en-GB&sxsrf=ACYBGNTyRWgVql-yZuNNQVfS3d7hamRTBg:1577980303072&source=lnms&tbm=isch&sa=X&ved=2ahUKEwj7-bTbouXmAhVoQEEAHVHCA7QQ_AUoAXoECBEQAw).

The data is identical to the animated plot above, but with each birth year stacked vertically rather than animated. The *smoothness* of the projected (red) data, compared to the estimated data, is quite visible. 
![](plot_unknown_pleasures.png)


Finally, a more stylised version of the above.
![](plot_unknown_pleasures2.png)



