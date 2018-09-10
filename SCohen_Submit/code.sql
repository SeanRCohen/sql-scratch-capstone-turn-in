-- Distict Campaigns
SELECT DISTINCT utm_campaign AS Campaigns
FROM page_visits;
 
--Distinct Source
SELECT DISTINCT utm_source AS Source
FROM page_visits;
 
--Campaign Source Relation
SELECT utm_campaign AS Campaigns, utm_source AS Source, COUNT(timestamp) AS Instance
FROM page_visits
GROUP BY Campaigns
ORDER BY Instance DESC;
 
--Site map
SELECT 
	DISTINCT page_name AS Page, 
	COUNT(timestamp) AS Instance
FROM page_visits
GROUP BY Page
ORDER BY Instance DESC;
 
--First touch for each campaign
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT 
	pv.utm_campaign AS Campaign,
	pv.utm_source As Source,
	COUNT(ft.first_touch_at) AS First_Touches
FROM first_touch ft
JOIN page_visits pv
	ON ft.user_id = pv.user_id
	AND ft.first_touch_at = pv.timestamp
 GROUP BY Campaign
 ORDER BY First_Touches DESC;
 
--Last touch for each campaign
WITH last_touch AS (
SELECT 
	user_id, 
	MAX(timestamp) AS 'last_touch_at',
	utm_source
FROM page_visits
GROUP BY user_id)
SELECT 
	pv.utm_campaign AS Campaign,
	pv.utm_source As Source,
	COUNT(lt.last_touch_at) AS Last_Touches
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
	ON lt.user_id = pv.user_id
 	AND lt.last_touch_at = pv.timestamp
 GROUP BY Campaign
 ORDER BY Last_Touches DESC;
 
--Visitors Making Purchase
SELECT DISTINCT COUNT(user_id) AS 'Visitors Making Purchase'
From page_visits
WHERE page_name = '4 - purchase';
 
--Last touch purchases for each campaign
WITH last_touch AS (
 SELECT 
	user_id,
	MAX(timestamp) AS 'last_touch_at',
	utm_source
FROM page_visits
WHERE page_name IS '4 - purchase'
GROUP BY user_id)
 
SELECT 
	pv.utm_campaign AS Campaign,
	pv.utm_source AS Source,
	COUNT(lt.last_touch_at) AS Purchase_Last_Touches
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
	ON lt.user_id = pv.user_id
	AND lt.last_touch_at = pv.timestamp
 GROUP BY Campaign
 ORDER BY Purchase_Last_Touches DESC;