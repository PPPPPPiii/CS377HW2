SET search_path TO dimeDB;

'''
1. group on election level & gender
2. count of transcation.id for certain level
'''

CREATE VIEW FederalStats AS
SELECT 'federal' AS level,
       "contributor.gender", COUNT("transaction.id") as count,
       AVG(amount) AS average_amount
FROM Contribution
WHERE seat LIKE 'federal%'
  AND "contributor.gender" IN ('M', 'F')
GROUP BY "contributor.gender";

CREATE VIEW StateStats AS
SELECT 'state' AS level,
       "contributor.gender",COUNT("transaction.id") as count,
       AVG(amount) AS average_amount
FROM Contribution
WHERE seat LIKE 'state%'
  AND "contributor.gender" IN ('M', 'F')
GROUP BY "contributor.gender";

CREATE VIEW LocalStats AS
SELECT 'local' AS level,
       "contributor.gender",COUNT("transaction.id") as count,
       AVG(amount) AS average_amount
FROM Contribution
WHERE seat LIKE 'local%'
  AND "contributor.gender" IN ('M', 'F')
GROUP BY "contributor.gender";

CREATE VIEW LevelGenderAverages AS
SELECT * FROM FederalStats
UNION ALL
SELECT * FROM StateStats
UNION ALL
SELECT * FROM LocalStats;

SELECT * FROM LevelGenderAverages
ORDER BY level DESC, "contributor.gender" ASC;