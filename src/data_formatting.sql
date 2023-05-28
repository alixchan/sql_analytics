SELECT *
FROM view_date;
SELECT *
FROM view_facts;

CREATE
OR replace VIEW view_date AS
WITH new_keys AS (
    SELECT to_number(to_char(to_date('2019010100', 'yyyymmddhh24') + LEVEL/24 - 1/24, 'yyyymmddhh24')) dt_key
      FROM dual
      CONNECT BY to_date('2019010100', 'yyyymmddhh24') + LEVEL/24 - 1/24 < trunc(sysdate + 4/24,'hh24') + 1/24
    )
SELECT CAST(dt_key AS number(19))                                                             dt_key
     -- HOURS
     , to_char(to_date(dt_key, 'yyyymmddhh24'), 'dd.mm.yyyy hh24:mi')                         full_date_hh24
     , to_char(to_date(dt_key, 'yyyymmddhh24'), 'hh24:mi')                                    hh24_name
     , to_date(dt_key, 'yyyymmddhh24')                                                        dt_hour_value
     -- DAYS
     , to_char(to_date(dt_key, 'yyyymmddhh24'), 'dd.mm.yyyy')                                 full_date
     , CAST(to_number(to_char(to_date(dt_key, 'yyyymmddhh24'), 'yyyymmdd')) AS number (19))   full_date_key
     , EXTRACT(DAY FROM to_date(dt_key, 'yyyymmddhh24'))                                      day_of_mon
     , to_char(to_date(dt_key, 'yyyymmddhh24'), 'DAY', 'NLS_DATE_LANGUAGE = ENGLISH')         week_day
     , to_char(to_date(dt_key, 'yyyymmddhh24'), 'D', 'NLS_DATE_LANGUAGE = ENGLISH')           week_day_num
     , trunc(to_date(dt_key, 'yyyymmddhh24'))                                                 dt_date_value
     -- WEEK
     , to_char(trunc(to_date(dt_key, 'yyyymmddhh24'), 'IW'), 'dd.mm.yyyy') || ' - ' ||
       to_char(trunc(to_date(dt_key, 'yyyymmddhh24') + 7, 'IW') - 1, 'dd.mm.yyyy')            week
     , CAST(to_number(to_char(trunc(to_date(dt_key, 'yyyymmddhh24'), 'IW'), 'yyyymmdd')) AS number
            (19))                                                                             week_num
     --MONTH
     , EXTRACT(MONTH FROM to_date(dt_key, 'yyyymmddhh24'))                                    month_number
     , TRIM(to_char(to_date(dt_key, 'yyyymmddhh24'), 'Month', 'NLS_DATE_LANGUAGE = ENGLISH')) || ' ' ||
       EXTRACT(YEAR FROM to_date(dt_key, 'yyyymmddhh24'))                                     year_mon
     , TRIM(to_char(to_date(dt_key, 'yyyymmddhh24'), 'Month', 'NLS_DATE_LANGUAGE = ENGLISH')) mon
     --YEAR
     , EXTRACT(YEAR FROM to_date(dt_key, 'yyyymmddhh24')) YEAR
     , to_date(dt_key, 'yyyymmddhh24')                                                        dt_key_new
     , CAST(to_number(to_char(to_date(dt_key, 'yyyymmddhh24'), 'yyyymm')) AS number (19))     month_year_key
     , CAST(to_number(to_char(to_date(dt_key, 'yyyymmddhh24'), 'q')) AS number (19)) AS       quarter_key
     , 'Q' || to_char(to_date(dt_key, 'yyyymmddhh24'), 'q')                          AS       quarter_name
     , 'M' || to_char(to_date(dt_key, 'yyyymmddhh24'), 'mm')                         AS       month_short_name
     , 'D' || to_char(to_date(dt_key, 'yyyymmddhh24'), 'dd')                         AS       day_short_name

FROM new_keys;


