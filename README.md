# $15 Federal Minimum Wage

## Part 1 : Too High or Low?

During the drafting and amendment phases of the American Rescure Plan bill, Democrats in the House and Senate proposed the [Raise the Wage Act](https://www.congress.gov/congressional-report/116th-congress/house-report/150) which aimed to incremently increase the federal minimum wage to $15 by 2025, from the $7.25 wage legalised since 2009. Although it eventually wasn't included in the passed bill, it remains a key point in the bulleted wish list of progressive Congress democrats. Eighteen states have approved bills to raise the state floor to $15, including most recently [Florida](https://www.cnbc.com/2020/11/04/florida-votes-to-raise-minimum-wage-to-15-in-2020-election.html) which gave its majority vote to Trump in the 2020 election. However, aside from political feasibility, is 15$ an appropriate national limit? 

US [nation-wide analysis](https://www.cbo.gov/system/files/2019-07/CBO-55410-MinimumWage2019.pdf) by the Congressional Budget Office shows mild to significant wage increases as the minimum increases to 15$, with 17 million workers seeing their wage increasing to meet the minimum. However the number of those that are estimated to be lifted out of poverty by this increase is estimated to match the number of those that would lose employment as a direct effect of wage increases. 

To deem a "safe" threshold for minimum wage, a common metric used is the [ratio of minimum wage to median wage](https://www.ilo.org/global/topics/wages/minimum-wages/setting-adjusting/WCMS_439253/lang--en/index.htm), which most developed countries tend to keep between [40% to 60%](https://stats.oecd.org/Index.aspx?DataSetCode=MIN2AVE#). We'll use this metric on a dataset of overall wages in 389 metro area in the US and see how many under a $15 minimum wage would lie within this threshold. All wages in the dataset are adjusted on the average [CPI projected inflation](https://knoema.com/kyaewad/us-inflation-forecast-2021-2022-and-long-term-to-2030-data-and-charts) over the next 5 years.

![farwest](https://github.com/KVasq/minimum_wage_2021/blob/main/wage_pct_farwest.png)

![mideast](https://github.com/KVasq/minimum_wage_2021/blob/main/wage_pct_mideast.png)

![newengland](https://github.com/KVasq/minimum_wage_2021/blob/main/wage_pct_newengland.png)

![plains](https://github.com/KVasq/minimum_wage_2021/blob/main/wage_pct_plains.png)

![rockies](https://github.com/KVasq/minimum_wage_2021/blob/main/wage_pct_rockies.png)

![southeast](https://github.com/KVasq/minimum_wage_2021/blob/main/wage_pct_southeast.png)

![southwest](https://github.com/KVasq/minimum_wage_2021/blob/main/wage_pct_southwest.png)

**Out of the 389 metro areas, 35 fall under the maximum 60% threshold and 6 areas under 50% - only 9% of metro areas are within the "safe" threshold for minimum wage.**

Below is the table of the metropolitan areas in this threshold:

![table](https://github.com/KVasq/minimum_wage_2021/blob/main/greenareas.png)

## Part 2: One Size Fits All?

The analysis up to now invites the question of "what would be a more appropriate national wage if not $15?". In addition to this we'll invite another question, "Should the US minimum wage be a federal issue or should we heed to state legislature?" We'll try to answer these from a stats perspective given an ideal scenario within the criterea we set before. Below are charts showing wages at 60% of the associated area's inflation adjusted median, as well as the mean wage for each state:

![farwest_prop](https://github.com/KVasq/minimum_wage_2021/blob/main/charts/min_prop_farwest.png)

![mideast_prop](https://github.com/KVasq/minimum_wage_2021/blob/main/charts/min_prop_mideast.png)

![newengland_prop](https://github.com/KVasq/minimum_wage_2021/blob/main/charts/min_prop_newengland.png)

![plains_prop](https://github.com/KVasq/minimum_wage_2021/blob/main/charts/min_prop_plains.png)

![rockies_prop](https://github.com/KVasq/minimum_wage_2021/blob/main/charts/min_prop_rockies.png)

![southeast_prop](https://github.com/KVasq/minimum_wage_2021/blob/main/charts/min_prop_southeast.png)

![southwest_prop](https://github.com/KVasq/minimum_wage_2021/blob/main/charts/min_prop_southwest.png)

Using the mean of all proposed area wages in a state may not be the most thorough metric (doesn't consider area population or occupational demographics) but should give a relative indicator for ideal wages in each state.

![table_min_prop](https://github.com/KVasq/minimum_wage_2021/blob/main/charts/min_estimate.png)

![table_min_prop_cont](https://github.com/KVasq/minimum_wage_2021/blob/main/charts/min_estimate2.png)

Treating all states equal, we can see that $12-13 is what an ideal projected minimum would look like (depending how much you want to be safe in rounding down). Calling a quick statistical summary will let us know how well this fits on all states.

```
> summary(state_minimums$MIN_ESTIMATE)
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  10.76   11.79   12.72   12.93   13.73   19.35 
> sd(state_minimums$MIN_ESTIMATE)
[1] 1.578836
```
A standard deviation of $1.58 isn't terrible but under a dollar is probably ideal. Cases below the 1st quartile (of which there are 12 states) are the most susceptible to inflationary effects but at the same time $15 in the state with the highest median wage may not lower the poverty rate as much as a higher wage would. The theme being observed here is that each state falls anywhere on the spectrum and wages that are senstive to each scenario are definitely more ideal than one wage between all 50 states. No doubt that most lawmakers in-favor of $15 already know this; most the time simplicity can make for more effective policy advocacy, in which case the sentiment isn't something to be condemned. Here's hoping that the conversation sparked can spur Congress to make the over-due decision to raise the minimum to atleast a "bi-partisan" level federally (with a bill maintaining the annual raise in median wage increases from the Raise the Wage act) and then local democrats can continue pushing in their respective constituencies. 

Any critisims of this repo is welcome, I am mainly attempting to learn R through topics I find interesting so such there is likely to be something I missed, please feel free to comment and recommend changes.
