SELECT
    [Id_test]
    ,[Group]
    ,[Event_type]
    ,SUM([purchase]) AS purchase_sum
    ,COUNT([Id]) AS count_events
FROM
(    SELECT 
        S.[Id_session]
        ,S.[purchase]
        ,E.[Id]
        ,E.[Event_type]
        ,SS.[Id_test]
        ,SS.[GROUP]
    FROM
        [TestDB].[dbo].[Sales] AS S
    FULL OUTER JOIN
        [TestDB].[dbo].[Events] AS E
        ON S.Id_session = E.Id_session
    FULL OUTER JOIN
        [TestDB].[dbo].[Session] AS SS
        ON SS.Id_session = S.Id_session
) AS A
GROUP BY     
    [Id_test]
    ,[Group]
    ,[Event_type]


WITH A AS(
    SELECT 
        S.[Id_session]
        ,S.[purchase]
        ,E.[Id]
        ,E.[Event_type]
        ,SS.[Id_test]
        ,SS.[GROUP]
    FROM
        [TestDB].[dbo].[Sales] AS S
    FULL OUTER JOIN
        [TestDB].[dbo].[Events] AS E
        ON S.Id_session = E.Id_session
    FULL OUTER JOIN
        [TestDB].[dbo].[Session] AS SS
        ON SS.Id_session = S.Id_session
)