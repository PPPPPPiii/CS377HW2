--THIS WORK WAS MY (OUR) OWN WORK. IT WAS WRITTEN WITHOUT CONSULTING
--WORK WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES.
--Elizabeth Xu
SET search_path TO dimeDB;

CREATE VIEW top3 AS(
SELECT DISTINCT "bonica.cid", "most.recent.contributor.name" AS name, "contributor.type" AS type,  
    COALESCE("amount.1980", 0)
    + COALESCE("amount.1982", 0)
    + COALESCE("amount.1984", 0)
    + COALESCE("amount.1986", 0)
    + COALESCE("amount.1988", 0)
    + COALESCE("amount.1990", 0)
    + COALESCE("amount.1992", 0)
    + COALESCE("amount.1994", 0)
    + COALESCE("amount.1996", 0)
    + COALESCE("amount.1998", 0)
    + COALESCE("amount.2000", 0)
    + COALESCE("amount.2002", 0)
    + COALESCE("amount.2004", 0)
    + COALESCE("amount.2006", 0)
    + COALESCE("amount.2008", 0)
    + COALESCE("amount.2010", 0)
    + COALESCE("amount.2012", 0)
    + COALESCE("amount.2014", 0)
    + COALESCE("amount.2016", 0)
    + COALESCE("amount.2018", 0)
    + COALESCE("amount.2020", 0)
    + COALESCE("amount.2022", 0) AS totalAmount
FROM Contributor
ORDER BY totalAmount DESC
LIMIT 3);

CREATE VIEW can AS(
SELECT "bonica.cid", SUM(amount) AS candidate_total
FROM contribution
WHERE ("recipient.type" = 'CAND') AND ("bonica.cid" in (SELECT "bonica.cid" FROM top3))
GROUP BY "bonica.cid"
);

CREATE VIEW com AS(
SELECT "bonica.cid", SUM(amount) AS committee_total
FROM contribution
WHERE ("recipient.type" = 'COMM') AND ("bonica.cid" in (SELECT "bonica.cid" FROM top3))
GROUP BY "bonica.cid"
);

SELECT DISTINCT comb."bonica.cid", name as donor_name, ROUND(comb.canamount::NUMERIC,2) as candidate_total,
ROUND(comb.comamount::NUMERIC,2) as committee_total, ROUND((100.0*CAST(comb.canamount AS numeric)/(comb.canamount+comb.comamount))::NUMERIC,2) as candidate_prct
ORDER BY donor_name ASC, "bonica.cid" ASC;
