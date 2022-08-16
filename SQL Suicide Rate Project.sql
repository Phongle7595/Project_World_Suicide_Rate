--Exploring Suicide Rate data from Kaggle. 2000 - 2019. Link: https://www.kaggle.com/datasets/sandragracenelson/suicide-rate-of-countries-per-every-year

Select *
From PortfolioProject..suiciderateall

--Delete the duplicated title row

DELETE From PortfolioProject..suiciderateall
WHERE Country = 'Country'

--Double checking it was deleted property

Select *
From PortfolioProject..suiciderateall

--Finding average rate for each country and showing countries with highest rates.

Select Country,
	(Select AVG(Myaverage) 
	FROM (VALUES ([2000]),([2001]),([2002]),([2003]),([2004]),([2005])
				,([2006]),([2007]),([2008]),([2009]),([2010]),([2011])
				,([2012]),([2013]),([2014]),([2015]),([2016]),([2017])
				,([2018]),([2019])) V(Myaverage)) AS Average
From PortfolioProject..suiciderateall
Order by Average desc

--Average Suicide Rate per Country by Gender

Select M.Country, 
(Select AVG(Myaverage) 
	FROM (VALUES (M.[2000]),(M.[2001]),(M.[2002]),(M.[2003]),(M.[2004]),(M.[2005])
				,(M.[2006]),(M.[2007]),(M.[2008]),(M.[2009]),(M.[2010]),(M.[2011])
				,(M.[2012]),(M.[2013]),(M.[2014]),(M.[2015]),(M.[2016]),(M.[2017])
				,(M.[2018]),(M.[2019])) V(Myaverage)) AS Male_Average,
(Select AVG(Myaverage) 
	FROM (VALUES (F.[2000]),(F.[2001]),(F.[2002]),(F.[2003]),(F.[2004]),(F.[2005])
				,(F.[2006]),(F.[2007]),(F.[2008]),(F.[2009]),(F.[2010]),(F.[2011])
				,(F.[2012]),(F.[2013]),(F.[2014]),(F.[2015]),(F.[2016]),(F.[2017])
				,(F.[2018]),(F.[2019])) V(Myaverage)) AS Female_Average
From PortfolioProject..suicideratemale M join PortfolioProject..suicideratefemale F on M.Country=F.Country
Order by Country

--Using Temp table to find the top 10 biggest differences between genders in each country

With Genderaverage AS
(
Select M.Country, 
(Select AVG(Myaverage) 
	FROM (VALUES (M.[2000]),(M.[2001]),(M.[2002]),(M.[2003]),(M.[2004]),(M.[2005])
				,(M.[2006]),(M.[2007]),(M.[2008]),(M.[2009]),(M.[2010]),(M.[2011])
				,(M.[2012]),(M.[2013]),(M.[2014]),(M.[2015]),(M.[2016]),(M.[2017])
				,(M.[2018]),(M.[2019])) V(Myaverage)) AS Male_Average,
(Select AVG(Myaverage) 
	FROM (VALUES (F.[2000]),(F.[2001]),(F.[2002]),(F.[2003]),(F.[2004]),(F.[2005])
				,(F.[2006]),(F.[2007]),(F.[2008]),(F.[2009]),(F.[2010]),(F.[2011])
				,(F.[2012]),(F.[2013]),(F.[2014]),(F.[2015]),(F.[2016]),(F.[2017])
				,(F.[2018]),(F.[2019])) V(Myaverage)) AS Female_Average
From PortfolioProject..suicideratemale M join PortfolioProject..suicideratefemale F on M.Country=F.Country
)
Select TOP 10 *, (Male_Average - Female_Average) As Differences
From Genderaverage
Order by Differences desc

-- Comparing the latest five years rates with average total of each country and year added at the end.

With aaa as
(
Select * from suiciderateall
)
Select ISNULL(Country,'Yearly_Average') AS Country,
	Avg([2015]) [2015],
       Avg([2016]) [2016],
       Avg([2017]) [2017],
       Avg([2018]) [2018],
       Avg([2019]) [2019],
       ( Avg([2015]) + Avg([2016]) + Avg([2017])
         + Avg([2018]) + Avg([2019]) ) / 5 as 'Country_Average'
FROM   aaa
GROUP  BY Country WITH rollup 