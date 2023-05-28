CREATE
OR REPLACE VIEW view_eventtype AS
SELECT CAST(id AS number(19)) id, eventType
FROM eventtypecategory
;

CREATE
OR REPLACE VIEW view_currencySymbol AS
SELECT CAST(id AS number(19)) id, currencySymbol
FROM currencySymbolcategory
;

CREATE
OR REPLACE VIEW view_locale_name AS
SELECT CAST(id AS number(19)) id, locale_name
FROM locale_namecategory
;

CREATE
OR REPLACE VIEW view_localeLanguage AS
SELECT CAST(id AS number(19)) id, localeLanguage
FROM localeLanguagecategory
;

CREATE
OR REPLACE VIEW view_projectId AS
SELECT CAST(id AS number(19)) id, projectId
FROM projectIdcategory
;

CREATE
OR REPLACE VIEW view_sub_projectId AS
SELECT CAST(id AS number(19)) id, sub_projectId
FROM sub_projectIdcategory
;

CREATE
OR REPLACE VIEW view_facts AS
SELECT CAST(id AS number(19))                         id,
       TIME_STAMP,
       to_number(to_char(TIME_STAMP, 'yyyymmddhh24')) DATE_KEY,
       REMOTEHOST,
       CAST(EVENTTYPE AS number(19))                  EVENTTYPE,
       CAST(USERAGENTNAMEVERSION AS number(19))       USERAGENTNAMEVERSION,
       CAST(USERAGENTFAMILY AS number(19))            USERAGENTFAMILY,
       CAST(USERAGENTVENDOR AS number(19))            USERAGENTVENDOR,
       CAST(USERAGENTTYPE AS number(19))              USERAGENTTYPE,
       CAST(USERAGENTDEVICECATEGORY AS number(19))    USERAGENTDEVICECATEGORY,
       CAST(USERAGENTOSFAMILY AS number(19))          USERAGENTOSFAMILY,
       CAST(USERAGENTOSVENDOR AS number(19))          USERAGENTOSVENDOR,
       CAST(PROJECTID AS number(19))                  PROJECTID,
       CAST(SUB_PROJECTID AS number(19))              SUB_PROJECTID,
       CAST(CURRENCYSYMBOL AS number(19))             CURRENCYSYMBOL,
       CAST(LOCALELANGUAGE AS number(19))             LOCALELANGUAGE,
       CAST(LOCALE_NAME AS number(19))                LOCALE_NAME
FROM facts;

CREATE
OR REPLACE VIEW view_userAgentDeviceCategory AS
SELECT CAST(id AS number(19)) id, userAgentDevice
FROM userAgentDeviceCategory
;

CREATE
OR REPLACE VIEW view_userAgentFamilyCategory AS
SELECT CAST(id AS number(19)) id, userAgentFamily
FROM userAgentFamilyCategory
;

CREATE
OR REPLACE VIEW view_userAgentNameCategory AS
SELECT CAST(id AS number(19)) id, userAgentName, userAgentVersion
FROM userAgentNameCategory
;

CREATE
OR REPLACE VIEW view_userAgentOsFamilyCategory AS
SELECT CAST(id AS number(19)) id, userAgentOsFamily
FROM userAgentOsFamilyCategory
;

CREATE
OR REPLACE VIEW view_userAgentOsVendorCategory AS
SELECT CAST(id AS number(19)) id, userAgentOsVendor
FROM userAgentOsVendorCategory
;

CREATE
OR REPLACE VIEW view_userAgentVendorCategory AS
SELECT CAST(id AS number(19)) id, userAgentVendor
FROM userAgentVendorCategory
;

CREATE
OR REPLACE VIEW view_userAgentTypeCategory AS
SELECT CAST(id AS number(19)) id, userAgentType
FROM userAgentTypeCategory
;

CREATE
OR replace VIEW view_date AS
WITH new_keys AS (
    SELECT to_number(to_char(to_date('2022060100', 'yyyymmddhh24') + LEVEL/24 - 1/24, 'yyyymmddhh24')) dt_key
      FROM dual
      CONNECT BY to_date('2022060100', 'yyyymmddhh24') + LEVEL/24 - 1/24 < trunc(sysdate + 4/24,'hh24') + 1/24
    )
SELECT dt_key
     -- HOURS
     , to_char(to_date(dt_key, 'yyyymmddhh24'), 'dd/mm/yyyy hh24:mi')                         full_date_hh24
     , to_char(to_date(dt_key, 'yyyymmddhh24'), 'hh24:mi')                                    hh24_name
     -- DAYS
     , to_char(to_date(dt_key, 'yyyymmddhh24'), 'dd/mm/yyyy')                                 full_date
     , to_number(to_char(to_date(dt_key, 'yyyymmddhh24'), 'yyyymmdd'))                        full_date_key
     , EXTRACT(DAY FROM to_date(dt_key, 'yyyymmddhh24'))                                      day_of_mon
     , to_char(to_date(dt_key, 'yyyymmddhh24'), 'DAY', 'NLS_DATE_LANGUAGE = ENGLISH')         week_day
     , to_char(to_date(dt_key, 'yyyymmddhh24'), 'D', 'NLS_DATE_LANGUAGE = ENGLISH')           week_day_num
     -- WEEK
     , to_char(trunc(to_date(dt_key, 'yyyymmddhh24'), 'IW'), 'dd.mm.yyyy') || ' - ' ||
       to_char(trunc(to_date(dt_key, 'yyyymmddhh24') + 7, 'IW') - 1, 'dd.mm.yyyy')            week
     , to_number(to_char(trunc(to_date(dt_key, 'yyyymmddhh24'), 'IW'), 'yyyymmdd'))           week_num
     --MONTH
     , EXTRACT(MONTH FROM to_date(dt_key, 'yyyymmddhh24'))                                    month_number
     , TRIM(to_char(to_date(dt_key, 'yyyymmddhh24'), 'Month', 'NLS_DATE_LANGUAGE = ENGLISH')) || ' ' ||
       EXTRACT(YEAR FROM to_date(dt_key, 'yyyymmddhh24'))                                     year_mon
     , TRIM(to_char(to_date(dt_key, 'yyyymmddhh24'), 'Month', 'NLS_DATE_LANGUAGE = ENGLISH')) mon
     --YEAR
     , EXTRACT(YEAR FROM to_date(dt_key, 'yyyymmddhh24')) YEAR
     , to_date(dt_key, 'yyyymmddhh24')                                                        dt_key_new
     , to_number(to_char(to_date(dt_key, 'yyyymmddhh24'), 'yyyymm'))                          month_year_key
FROM new_keys;

