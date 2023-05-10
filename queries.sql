WITH Main_Query AS(
    SELECT 
        S.[Id_session]
        ,S.[purchase]
        ,E.[Id]
        ,E.[Event_type]
        ,SS.[Id_test]
        ,SS.[Group]
    FROM
        [TestDB].[dbo].[Sales] AS S
    JOIN
        [TestDB].[dbo].[Events] AS E
        ON S.Id_session = E.Id_session
    JOIN
        [TestDB].[dbo].[Session] AS SS
        ON SS.Id_session = S.Id_session
),
Sum_Query AS
(
    SELECT
        [Id_test]
        ,[Group]
        ,'Sales' AS [Event_type]
        ,SUM([purchase]) AS [For_sales_and_events]
    FROM
        Main_Query
    GROUP BY
        [Id_test]
        ,[Group]
        ,[Event_type]
),
Event_Query AS
(
    SELECT
        [Id_test]
        ,[Group]
        ,[Event_type]
        ,COUNT([Id]) AS [For_sales_and_events]
    FROM
        Main_Query
    GROUP BY
        [Id_test]
        ,[Group]
        ,[Event_type]
),
Events_and_sales AS
(
    SELECT 
        [Id_test]
        ,[Group]
        ,[Event_type]
        ,[For_sales_and_events]
    FROM 
        Sum_Query
    UNION ALL
        SELECT 
        [Id_test]
        ,[Group]
        ,[Event_type]
        ,[For_sales_and_events]
    FROM 
        Event_Query
)
SELECT 
    [Id_test]
    ,[Group]
    ,[Event_type]
    ,[For_sales_and_events]
FROM 
    Events_and_sales
ORDER BY
    [Id_test]
    ,[Group]
    ,[Event_type]