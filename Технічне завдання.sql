WITH Group_Sum_Query AS
--спочатку запит з допомогою CTE
(    SELECT -- в цьому запиті ми групуємо дані сум по сесіям, це необхідно для кінцевого запиту
        S.[Id_session]
        ,SUM(S.[purchase]) AS [purchase]
    FROM
        [TestDB].[dbo].[Sales] AS S
    GROUP BY  [Id_session]
),
Main_Sum_Query AS 
(
    SELECT --в цьому запиті з'єднуємо попередній із даними по сесіям
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
        SELECT -- в цьому запиті групуємо поля попереднього запиту та додаємо поле Event_type
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
    SELECT --об'єднуємо таблицю сесій та подій в єдину таблицю
        E.[Id]
        ,E.[Event_type]
        ,SS.[Id_test]
        ,SS.[Group]
    FROM
        [TestDB].[dbo].[Events] AS E

    JOIN --об'єднуємо таблицю Events та  Session
        [TestDB].[dbo].[Session] AS SS
        ON SS.Id_session = E.Id_session
),
Event_Query AS
(
        SELECT --групуємо поля попереднього запиту та рахуємо кількість подій
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