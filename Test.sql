--структура page_type та event_type
SELECT 
      DISTINCT([page_type])
      ,[event_type]
  FROM [test].[dbo].[data_set_da_test]



-- загальний запит до лійки
SELECT 
	[pages],
	[event_type],
	COUNT(*) AS [opened_pages]
FROM
	(SELECT
		CASE 
		WHEN page_type = 'search_listing_page' THEN 'listing_page'
		ELSE page_type END as pages,
		[event_type]
	FROM
		test.dbo.data_set_da_test) AS A
GROUP BY [pages],[event_type]
ORDER BY [opened_pages] DESC

SELECT 
	[page_type],
	[event_type],
	COUNT(*) AS [opened_pages]
FROM
	test.dbo.data_set_da_test AS A
GROUP BY [page_type],[event_type]
ORDER BY [opened_pages] DESC

-- запит для з'ясування поточного стану різних сценаріїв
WITH listing AS
(
SELECT

    [session],
    [page_type]
FROM
    test.dbo.data_set_da_test
WHERE 
    page_type = 'listing_page'
	OR
	page_type = 'search_listing_page'

),
 product AS    (
        SELECT
            [session],
            [page_type]
        FROM
    test.dbo.data_set_da_test
    WHERE 
    page_type = 'product_page'
    ),
orders AS
    (
        SELECT
            [session],
            [page_type]
        FROM
    test.dbo.data_set_da_test
    WHERE 
    page_type = 'order_page'
    ),
types_join as (
SELECT
	[session], l.page_type as lp, product.page_type as pp, orders.page_type as op
FROM
	listing as l
FULL OUTER JOIN
	product
	ON l.session = product.session_p
FULL OUTER JOIN
	orders
	ON l.session = orders.session_o
	)
SELECT
	lp, pp, op, COUNT([session]) as numbers
from types_join
GROUP BY lp, pp, op
ORDER BY numbers


2

2.1 
--допрацювати
SELECT
	[user],
	[session],
	[page_type],
	COUNT(*) as c
FROM 
	test.dbo.data_set_da_test
WHERE
	[session] NOT IN ( анти джойн із зі списком сесій, в яких не було event_type add_to cart чи page_type = order_page)
GROUP BY [user], [page_type],[session];