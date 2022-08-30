--1
SELECT created_time, engaged_fans, post_clicks, reach, impressions
FROM "PostInsights"
ORDER BY created_time DESC;
--2
SELECT "CountryCode", "NumberOfFans"
FROM "FansPerCountry" AS fpc
WHERE "Date" = '2018-10-16'
ORDER BY "NumberOfFans" DESC
LIMIT 10;
--3.1
SELECT DISTINCT date, new_likes
FROM "GlobalPage"
ORDER BY new_likes DESC;
--3.2
SELECT date, AVG(new_likes)
FROM "GlobalPage"
GROUP BY date
ORDER BY AVG DESC;
--4
SELECT date, gender, SUM(number_of_fans), ROUND(SUM(number_of_fans) / (SELECT SUM(number_of_fans) FROM "FansPerGenderAge" WHERE date = '2018-10-16') * 100, 2) AS percentage_per_gender
FROM "FansPerGenderAge"
WHERE date = '2018-10-16'
GROUP BY date, gender
ORDER BY date;
--5.1
SELECT "PopStats"."country_name", ROUND("FansPerCountry"."NumberOfFans" * 100.00 / "PopStats"."population", 2) AS penetration_ratio
FROM "FansPerCountry"
JOIN "PopStats"
ON "FansPerCountry"."CountryCode" = "PopStats"."country_code"
WHERE "FansPerCountry"."Date" = '2018-10-16'
ORDER BY penetration_ratio DESC
LIMIT 10;
--5.2
SELECT ps."country_name", ROUND(fpc."NumberOfFans" * 100.00 / ps."population", 2) AS penetration_ratio
FROM "FansPerCountry" AS fpc
JOIN "PopStats" AS ps
ON fpc."CountryCode" = ps."country_code"
WHERE fpc."Date" = '2018-10-16'
ORDER BY penetration_ratio DESC
LIMIT 10;
--6
SELECT ps."country_name", fpc."NumberOfFans"
FROM "PopStats" AS ps
JOIN "FansPerCountry" AS fpc
ON ps."country_code" = fpc."CountryCode"
WHERE ps."population" > 20000000
AND fpc."Date" = '2018-10-16'
ORDER BY fpc."NumberOfFans"
LIMIT 10;
--7
SELECT DISTINCT fpc.date, ps.country_name, fpc.city, fpc.number_of_fans
FROM "FansPerCity" AS fpc
JOIN "PopStats" AS ps
ON fpc."country_code" = ps."country_code"
WHERE fpc."date" = (SELECT MAX(date) FROM "FansPerCity")
ORDER BY fpc.number_of_fans DESC;
--8
SELECT country_id, date, gdp, AVG(gdp) OVER(PARTITION BY country_id) AS average_gdp
FROM "CountryStats";
--9
SELECT region, athlete_id, SUM("Gold") AS gold_medals_count,
ROW_NUMBER() OVER(PARTITION BY region ORDER BY SUM("Gold") DESC) AS rank_medals
FROM "GamesStats" AS gs
JOIN "CountryRegions" AS cr
ON gs."country_id" = cr."id"
JOIN "Athletes" AS ath
ON gs."athlete_id" = ath."id"
GROUP BY region, athlete_id;
--10
SELECT gs."sport",
CASE WHEN ath."weight" * 100.00 / (ath."height") ^ 2.00 < 0.25 THEN '< 0.25'
WHEN ath."weight" * 100.00 / (ath."height") ^ 2.00 >= 0.25 AND ath."weight" * 100.00 / (ath."height") ^ 2.00 <= 0.30 THEN '0.25 - 0.30' 
WHEN ath."weight" * 100.00 / (ath."height") ^ 2.00 > 0.30 THEN '> 0.30'
END AS bmi_bucket,
COUNT(DISTINCT ath."id") AS athletes_count
FROM "GamesStats" AS gs
JOIN "Athletes" AS ath
ON gs."athlete_id" = ath."id"
GROUP BY sport, bmi_bucket
ORDER BY sport, athletes_count DESC;
--11
SELECT *, AVG(close) OVER(ORDER BY date ROWS 5 PRECEDING) AS ma_6
FROM "StockPrice"
ORDER BY date ASC;
--12
SELECT CASE DATE_PART('DOW', cast(created_time AS date))
WHEN 0 THEN 'Domingo'
WHEN 1 THEN 'Lunes'
WHEN 2 THEN 'Martes'
WHEN 3 THEN 'Miercoles'
WHEN 4 THEN 'Jueves'
WHEN 5 THEN 'Viernes'
WHEN 6 THEN 'Sabado'
END AS day_of_week,
ROUND(AVG(engaged_fans * 100.00 / reach), 2) AS avg_engagement
FROM "PostInsights"
GROUP BY day_of_week
ORDER BY avg_engagement DESC;
--13
SELECT region, TRIM(REPLACE(REPLACE(region, '.', ''), '&', 'AND')) AS cleaned_region
FROM "CountryRegions"
WHERE region = 'LATIN AMER. & CARIB    '
GROUP BY region;
--14
SELECT sport, athlete_id, COALESCE(medal, 'NA') AS medal_clean
FROM "Games";
--15
SELECT *, REGEXP_MATCHES(event, 'Women|Men') women_men
FROM "GamesStats";

