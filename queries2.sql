WITH Group_Sum_Query AS
--спочатку створюємо перший запит з допомогою WITH
(    SELECT 
        S.[Id_session]
        ,SUM(S.[purchase]) AS [purchase]
    FROM
        [TestDB].[dbo].[Sales] AS S
    GROUP BY  [Id_session]
),
Main_Sum_Query AS 
(
    SELECT 
        S.[Id_session]
        ,S.[purchase]
        ,SS.[Id_test]
        ,SS.[Group]
    FROM Group_Sum_Query AS S
    JOIN --об'єднуємо таблицю Sales та  Session
        [TestDB].[dbo].[Session] AS SS
        ON SS.Id_session = S.Id_session
),
Sum_Query AS 
(
        SELECT
        [Id_test]
        ,[Group]
        ,'sales' AS [Event_type]
        ,SUM([purchase]) AS [For_sales_and_events]
    FROM
        Main_Sum_Query
    GROUP BY
        [Id_test]
        ,[Group]

),
Main_Event_Query AS
(
    SELECT 

        E.[Id]
        ,E.[Event_type]
        ,SS.[Id_test]
        ,SS.[Group]
    FROM
        [TestDB].[dbo].[Events] AS E

    JOIN --об'єднуємо таблицю Sales та  Session
        [TestDB].[dbo].[Session] AS SS
        ON SS.Id_session = E.Id_session
),
Event_Query AS
(
        SELECT
        [Id_test]
        ,[Group]
        ,[Event_type]
        ,COUNT([Id]) AS [For_sales_and_events]
    FROM
        Main_Event_Query
    GROUP BY
        [Id_test]
        ,[Group]
        ,[Event_type]
),
Events_and_sales AS --об'єднуємо запити подій та сум
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
SELECT --виведення остаточно результату
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