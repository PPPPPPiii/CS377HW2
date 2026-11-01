--THIS WORK WAS MY (OUR) OWN WORK. IT WAS WRITTEN WITHOUT CONSULTING
--WORK WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES.
--Elizabeth Xu
SET search_path TO dimeDB;

CREATE VIEW top3 AS
    SELECT c."bonica.cid", ct."most.recent.contributor.name" AS name, SUM(c.amount) AS totalAmount
    FROM Contribution c
    LEFT JOIN Contributor ct ON ct."bonica.cid" = c."bonica.cid"
    GROUP BY c."bonica.cid", ct."most.recent.contributor.name"
    ORDER BY totalAmount DESC NULLS LAST
    LIMIT 3;

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

SELECT "bonica.cid", name AS donor_name, ROUND(candidate_total::NUMERIC,2) AS candidate_total, ROUND(committee_total::NUMERIC,2)AS committee_total, ROUND(((COALESCE(candidate_total, 0) / NULLIF(COALESCE(candidate_total, 0) + COALESCE(committee_total, 0), 0)) * 100)::NUMERIC, 2) AS candidate_prct
FROM top3 natural left join can natural left join com
ORDER BY donor_name ASC, "bonica.cid" ASC;
