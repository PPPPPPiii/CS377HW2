--THIS WORK WAS MY (OUR) OWN WORK. IT WAS WRITTEN WITHOUT CONSULTING
--WORK WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES.
--Elizabeth Xu
DROP TABLE IF EXISTS Influence;

CREATE TABLE Influence (
  "bill.id" varchar REFERENCES Bill("bill.id"),
  "vote.id" varchar REFERENCES Vote("vote.id"),
  "dw.economy"        float DEFAULT 0 CHECK ("dw.economy"        BETWEEN 0 AND 1),
  "dw.environment"    float DEFAULT 0 CHECK ("dw.environment"    BETWEEN 0 AND 1),
  "dw.foreign.policy" float DEFAULT 0 CHECK ("dw.foreign.policy" BETWEEN 0 AND 1),
  "dw.womens.issues"  float DEFAULT 0 CHECK ("dw.womens.issues"  BETWEEN 0 AND 1),
  "dw.guns"           float DEFAULT 0 CHECK ("dw.guns"           BETWEEN 0 AND 1),
  "dw.healthcare"     float DEFAULT 0 CHECK ("dw.healthcare"     BETWEEN 0 AND 1),
  PRIMARY KEY("bill.id", "vote.id")
);

INSERT INTO Influence ("bill.id", "vote.id", "dw.environment", "dw.foreign.policy")
SELECT v."bill.id", v."vote.id", 0.3, 0.7
FROM Vote v
WHERE v."bill.id" IN (
    SELECT "bill.id"
    FROM Vote
    WHERE cosponsor = 1
    GROUP BY "bill.id"
    HAVING COUNT(cosponsor) = (
        SELECT MAX(cnt)
        FROM (
            SELECT COUNT(cosponsor) AS cnt
            FROM Vote
            WHERE cosponsor = 1
            GROUP BY "bill.id"
        ) t
    )
);
