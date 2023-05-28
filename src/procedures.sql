CREATE
OR replace PROCEDURE p_rep_amount_for_user(
    L_CURSOR OUT SYS_REFCURSOR
)
IS
BEGIN

OPEN L_CURSOR FOR
        WITH stat_users AS
        (
        SELECT remotehost
            , projectid
            , COUNT(*) amount
            FROM facts
            GROUP BY remotehost, projectid
            ORDER BY COUNT(*) DESC
        ),
        stat AS
        (
        SELECT (remotehost) user_id
            , pic.projectid projectid
            , amount
            FROM stat_users st
            LEFT JOIN projectidcategory pic
                ON pic.id = st.projectid
            ORDER BY amount DESC, user_id
        )
SELECT *
FROM stat
         --todo: 0 instead null
         pivot(max(amount) FOR projectid IN (
            'MOBILE',
            'WEB',
            'SITEACCESS',
            'LANDINGS',
            'MLIVE_GAMES',
            'TOTO',
            'MVIRTUAL_SPORTS',
            'MTOTO',
            'QUIZ',
            'LIVECASINO',
            'MCASINO',
            'MLIVECASINO',
            'ESPORT',
            'LIVE_GAMES',
            'VIRTUAL_SPORTS',
            'CASINO',
            'CONSTRUCTOR'
            ))
     --where user_id='91.142.86.132'
ORDER BY user_id;

END;











CREATE
OR replace PROCEDURE p_rep_inter_top3_proj_browser(
    L_CURSOR OUT SYS_REFCURSOR
)
IS
BEGIN

OPEN L_CURSOR FOR
        WITH inter AS (
            SELECT remotehost, projectid, useragentnameversion FROM facts
            WHERE useragentnameversion = ANY (SELECT * FROM (SELECT  useragentnameversion
                FROM facts
                GROUP BY useragentnameversion
                ORDER BY COUNT(useragentnameversion) DESC) WHERE rownum <= 3)
            GROUP BY remotehost, projectid, useragentnameversion

            INTERSECT

            SELECT remotehost, projectid, useragentnameversion FROM facts
            WHERE locale_name != localelanguage
            AND projectid IN (SELECT * FROM (
            SELECT projectid
            FROM facts
            LEFT JOIN eventtypecategory et
                ON et.id = facts.eventtype AND et.eventtype LIKE '%view%'
            GROUP BY projectid
            ORDER BY COUNT(*) DESC) WHERE rownum <= 3)
            GROUP BY remotehost, projectid, useragentnameversion
        )
SELECT remotehost, pi.projectid, un.useragentname
FROM inter
         LEFT JOIN projectidcategory pi
                   ON pi.id = inter.projectid
         LEFT JOIN useragentnamecategory un
                   ON un.id = inter.useragentnameversion;

END;








CREATE
OR replace PROCEDURE p_rep_sub_project_amount(
    L_CURSOR OUT SYS_REFCURSOR
)
IS
BEGIN

OPEN L_CURSOR FOR

WITH filt AS (SELECT sub_projectid sub_id,
                COUNT(sub_projectid) amount
                FROM facts f
                GROUP BY sub_projectid)

SELECT p.sub_projectId
     , amount
     , round(percent_rank() over (ORDER BY amount) *100, 2) || '%' percent_rank
     , CASE ntile(3) over (ORDER BY amount DESC) WHEN 1 THEN 'first'
            WHEN 2 THEN 'second'
            WHEN 3 THEN 'third'
END significance
FROM filt s
        LEFT JOIN sub_projectidcategory p
            ON p.id = s.sub_id
        ORDER BY p.sub_projectId;
END;




CREATE
OR replace PROCEDURE p_rep_stat_comparison(
    L_CURSOR OUT SYS_REFCURSOR
)
IS
BEGIN

OPEN L_CURSOR FOR
        WITH sts AS (
        SELECT remotehost
            , COUNT(remotehost) amount
            , round((COUNT(remotehost)/(SELECT COUNT(*) FROM facts)) * 100, 3) persent_events
            FROM facts
            GROUP BY remotehost
            )
        , DATA AS (
            SELECT median(amount) med
            , SUM(amount) SUM
            , round(AVG(amount), 1) AVG
            , MAX(amount) MAX FROM sts
        )
SELECT remotehost
     , COUNT(remotehost)                                    amount
     , round(RATIO_TO_REPORT(COUNT(remotehost)) OVER (), 5) ratio_r
     , CASE
           WHEN COUNT(remotehost) > (SELECT med FROM data)
               THEN 'gr'
           ELSE 'less' END                                  med_comparison
     , CASE
           WHEN COUNT(remotehost) > (SELECT avg FROM data)
               THEN 'gr'
           ELSE 'less' END                                  avg_comparison
FROM facts
GROUP BY remotehost
ORDER BY COUNT(remotehost) DESC;

END;


CREATE
OR replace PROCEDURE p_rep_users_type_amount(
    L_CURSOR OUT SYS_REFCURSOR
)
IS
BEGIN

OPEN L_CURSOR FOR
        WITH rank_users AS
        (
                SELECT remotehost
                , projectid
                , eventtype
                , COUNT(*) COUNT

                FROM facts
                GROUP BY remotehost, projectid, eventtype
                ORDER BY COUNT(*) DESC
        )

SELECT CONCAT('user-', (ORA_HASH(remotehost))) user_id
     , pic.projectid                           project
     , etc.eventtype                           event
     , count

FROM rank_users st
         LEFT JOIN eventtypecategory etc
                   ON etc.id = st.eventtype
         LEFT JOIN projectidcategory pic
                   ON pic.id = st.projectid
ORDER BY count DESC, user_id
;

END;


