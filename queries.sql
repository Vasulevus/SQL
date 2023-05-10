WITH Main_Query AS --спочатку створюємо основний запит з допомогою WITH
(
    SELECT 
        S.[Id_session]
        ,S.[purchase]
        ,E.[Id]
        ,E.[Event_type]
        ,SS.[Id_test]
        ,SS.[Group]
    FROM
        [TestDB].[dbo].[Sales] AS S
    JOIN --об'єднуємо таблицю Sales та  Events
        [TestDB].[dbo].[Events] AS E
        ON S.Id_session = E.Id_session
    JOIN --об'єднуємо таблицю Sales та  Session
        [TestDB].[dbo].[Session] AS SS
        ON SS.Id_session = S.Id_session
), --таким чином ми створили запит з усіма потрібними даними
Sum_Query AS --створюємо запит для отримання сум для груп та id
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
Event_Query AS--створюємо запит для отримання подій з id та group
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