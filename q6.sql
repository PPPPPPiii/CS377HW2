--THIS WORK WAS MY (OUR) OWN WORK. IT WAS WRITTEN WITHOUT CONSULTING
--WORK WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES.
--Elizabeth Xu
SET search_path TO dimeDB;


/*first step: find all legislators who sponsored bills & number of bills they sponsored
second step: find all legislators who sponsor the bill and vote against for it. return #of sponsored bills & id
exception
third step: JOIN id & number with party */

CREATE VIEW NoVote AS
    SELECT "bonica.rid" AS id, COUNT(DISTINCT "bill.id") as numbills
    FROM Vote
    WHERE sponsor = 1 AND "bonica.rid" NOT IN (
        SELECT "bonica.rid" AS id
        FROM Vote
        WHERE sponsor = 1 and "vote.choice" = 6 AND "bonica.rid" IS NOT NULL)
    Group by "bonica.rid";


SELECT DISTINCT NoVote.id, party, numbills
FROM NoVote
JOIN Recipient
ON NoVote.id = Recipient."bonica.rid"
ORDER By numbills DESC;
