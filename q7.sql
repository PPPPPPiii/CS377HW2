--THIS WORK WAS MY (OUR) OWN WORK. IT WAS WRITTEN WITHOUT CONSULTING
--WORK WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES.
--Elizabeth Xu
SET search_path TO dimeDB;

/*
1. select top 3 contributors
2. contributor id + group their amount to candidates
3. contributor id + group their amount to committees
4. calculate candidate_prct
*/
CREATE VIEW top3 AS
    SELECT "bonica.cid","most.recent.contributor.name" AS name, COALESCE("amount.1980", 0) + COALESCE("amount.1982", 0) + COALESCE("amount.1984", 0) + COALESCE("amount.1986", 0) + COALESCE("amount.1988", 0) + COALESCE("amount.1990", 0) + COALESCE("amount.1992", 0) + COALESCE("amount.1994", 0) + COALESCE("amount.1996", 0) + COALESCE("amount.1998", 0) + COALESCE("amount.2000", 0) + COALESCE("amount.2002", 0) + COALESCE("amount.2004", 0) + COALESCE("amount.2006", 0) + COALESCE("amount.2008", 0) + COALESCE("amount.2010", 0) + COALESCE("amount.2012", 0) + COALESCE("amount.2014", 0) + COALESCE("amount.2016", 0) + COALESCE("amount.2018", 0) + COALESCE("amount.2020", 0) + COALESCE("amount.2022", 0) AS totalAmount
    FROM Contributor c
    ORDER BY totalAmount DESC NULLS LAST
    LIMIT 3;

CREATE VIEW Cancount AS
    SELECT "bonica.cid", sum(amount) as canamount
    FROM Contribution c
    WHERE c."bonica.cid" IN (SELECT "bonica.cid" FROM top3) AND "recipient.type" = 'CAND'
    GROUP BY c."bonica.cid";

CREATE VIEW Commcount AS
    SELECT "bonica.cid", sum(amount) as comamount
    FROM Contribution c
    WHERE c."bonica.cid" IN (SELECT "bonica.cid" FROM top3) AND "recipient.type" = 'COMM'
    GROUP BY c."bonica.cid";

CREATE VIEW Combined as
    SELECT COALESCE(ca."bonica.cid", co."bonica.cid") AS "bonica.cid",
       COALESCE(ca.canamount, 0) AS canamount,
       COALESCE(co.comamount, 0) AS comamount
    FROM Cancount ca
    FULL OUTER JOIN Commcount co
    ON ca."bonica.cid" = co."bonica.cid";

SELECT DISTINCT comb."bonica.cid", name as donor_name, comb.canamount as candidate_total,
comb.comamount as committee_total, ROUND((100.0*CAST(comb.canamount AS numeric)/(comb.canamount+comb.comamount))::NUMERIC,2) as candidate_prct
FROM Combined comb
JOIN top3 t
  ON t."bonica.cid" = comb."bonica.cid"
Order by donor_name ASC, comb."bonica.cid" ASC;
