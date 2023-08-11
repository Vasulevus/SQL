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