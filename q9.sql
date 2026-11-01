--THIS WORK WAS MY (OUR) OWN WORK. IT WAS WRITTEN WITHOUT CONSULTING
--WORK WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES.
--Elizabeth Xu
SET search_path TO dimeDB;
BEGIN;

CREATE TEMP TABLE ind_rid AS
SELECT DISTINCT "bonica.rid" AS rid
FROM Recipient
WHERE party = '328';

CREATE TEMP TABLE ind_cid AS
SELECT DISTINCT "bonica.cid" AS cid
FROM Recipient
WHERE party = '328' AND "bonica.cid" IS NOT NULL;

DELETE FROM Bill
WHERE "bill.id" IN (
    SELECT "bill.id"
    FROM Vote
    WHERE sponsor = 1
      AND "bonica.rid" IN (SELECT rid FROM ind_rid)
);

DELETE FROM Vote
WHERE "bonica.rid" IN (SELECT rid FROM ind_rid)
   OR party = '328';

DELETE FROM Contribution
WHERE "bonica.rid" IN (SELECT rid FROM ind_rid)
   OR "recipient.party" = '328'
   OR "bonica.cid" IN (SELECT cid FROM ind_cid);

DELETE FROM Contributor
WHERE "bonica.cid" IN (SELECT cid FROM ind_cid);

DELETE FROM Recipient
WHERE party = '328';

SELECT COUNT(*) FROM Recipient WHERE party = '328';
SELECT COUNT(*) FROM Vote WHERE party = '328';

COMMIT;

