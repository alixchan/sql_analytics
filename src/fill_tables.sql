CREATE
OR replace PACKAGE BODY PACKAGE_PROC_FACTS AS

  PROCEDURE ProcessingFacts AS
BEGIN
INSERT INTO eventTypeCategory(eventType)
WITH event AS (SELECT DISTINCT eventType FROM staging_table WHERE eventType IS NOT NULL)
SELECT b.eventType
FROM event b
         LEFT JOIN eventTypeCategory a
                   ON a.eventType = b.eventType
WHERE id IS NULL;

MERGE INTO userAgentNameCategory t USING (SELECT userAgentName,
                                                 MAX(userAgentVersion) KEEP (DENSE_RANK FIRST ORDER BY time_stamp) userAgentVersion
                                          FROM staging_table s
                                          WHERE userAgentVersion IS NOT NULL
                                            AND userAgentName IS NOT NULL
                                          GROUP BY userAgentName) s ON (t.userAgentName = s.userAgentName) WHEN MATCHED THEN UPDATE SET t.userAgentVersion = s.userAgentVersion WHERE t.userAgentVersion <> s.userAgentVersion
        WHEN NOT MATCHED
            THEN INSERT (userAgentName, userAgentVersion)
            VALUES(s.userAgentName, s.userAgentVersion);
COMMIT;

INSERT INTO userAgentFamilyCategory(userAgentFamily)
WITH familyCategory AS (SELECT DISTINCT userAgentFamily FROM staging_table WHERE userAgentFamily IS NOT NULL)
SELECT b.userAgentFamily
FROM familyCategory b
         LEFT JOIN userAgentFamilyCategory a
                   ON a.userAgentFamily = b.userAgentFamily
WHERE id IS NULL;

INSERT INTO userAgentVendorCategory(userAgentVendor)
WITH vendorCategory(userAgentVendor) AS (SELECT DISTINCT userAgentVendor
                                         FROM staging_table
                                         WHERE userAgentVendor IS NOT NULL)
SELECT b.userAgentVendor
FROM vendorCategory b
         LEFT JOIN userAgentVendorCategory a
                   ON a.userAgentVendor = b.userAgentVendor
WHERE id IS NULL;

INSERT INTO userAgentTypeCategory(userAgentType)
WITH typeCategory AS (SELECT DISTINCT userAgentType FROM staging_table WHERE userAgentType IS NOT NULL)
SELECT b.userAgentType
FROM typeCategory b
         LEFT JOIN userAgentTypeCategory a
                   ON a.userAgentType = b.userAgentType
WHERE id IS NULL;

INSERT INTO userAgentDeviceCategory(userAgentDevice)
WITH deviceCategory AS (SELECT DISTINCT userAgentDeviceCategory
                        FROM staging_table
                        WHERE userAgentDeviceCategory IS NOT NULL)
SELECT b.userAgentDeviceCategory
FROM deviceCategory b
         LEFT JOIN userAgentDeviceCategory a
                   ON a.userAgentDevice = b.userAgentDeviceCategory
WHERE id IS NULL;

INSERT INTO userAgentOsFamilyCategory(userAgentOsFamily)
WITH familyOsCategory(userAgentOsFamily) AS (SELECT DISTINCT userAgentOsFamily
                                             FROM staging_table
                                             WHERE userAgentOsFamily IS NOT NULL)
SELECT b.userAgentOsFamily
FROM familyOsCategory b
         LEFT JOIN userAgentOsFamilyCategory a
                   ON a.userAgentOsFamily = b.userAgentOsFamily
WHERE id IS NULL;

INSERT INTO userAgentOsVendorCategory(userAgentOsVendor)
WITH vendorOsCategory(userAgentOsVendor) AS (SELECT DISTINCT userAgentOsVendor
                                             FROM staging_table
                                             WHERE userAgentOsVendor IS NOT NULL)
SELECT b.userAgentOsVendor
FROM vendorOsCategory b
         LEFT JOIN userAgentOsVendorCategory a
                   ON a.userAgentOsVendor = b.userAgentOsVendor
WHERE id IS NULL;

INSERT INTO projectIdCategory(projectId)
WITH projectCategory(projectId) AS (SELECT DISTINCT projectId FROM staging_table WHERE projectId IS NOT NULL)
SELECT b.projectId
FROM projectCategory b
         LEFT JOIN projectIdCategory a
                   ON a.projectId = b.projectId
WHERE id IS NULL;

INSERT INTO sub_projectIdCategory(sub_projectId)
WITH sub_projectCategory(sub_projectId) AS (SELECT DISTINCT sub_projectId
                                            FROM staging_table
                                            WHERE sub_projectId IS NOT NULL)
SELECT b.sub_projectId
FROM sub_projectCategory b
         LEFT JOIN sub_projectIdCategory a
                   ON a.sub_projectId = b.sub_projectId
WHERE id IS NULL;

INSERT INTO currencySymbolCategory(currencySymbol)
WITH currencyCategory(currencySymbol) AS (SELECT DISTINCT currencySymbol
                                          FROM staging_table
                                          WHERE currencySymbol IS NOT NULL)
SELECT b.currencySymbol
FROM currencyCategory b
         LEFT JOIN currencySymbolCategory a
                   ON a.currencySymbol = b.currencySymbol
WHERE id IS NULL;

INSERT INTO localeLanguageCategory(localeLanguage)
WITH localeCategory(localeLanguage) AS (SELECT DISTINCT localeLanguage
                                        FROM staging_table
                                        WHERE localeLanguage IS NOT NULL)
SELECT b.localeLanguage
FROM localeCategory b
         LEFT JOIN localeLanguageCategory a
                   ON a.localeLanguage = b.localeLanguage
WHERE id IS NULL;

INSERT INTO locale_nameCategory(locale_name)
WITH lnameCategory(locale_name) AS (SELECT DISTINCT locale_name
                                    FROM staging_table
                                    WHERE locale_name IS NOT NULL)
SELECT b.locale_name
FROM lnameCategory b
         LEFT JOIN locale_nameCategory a
                   ON a.locale_name = b.locale_name
WHERE id IS NULL;


END ProcessingFacts;

END PACKAGE_PROC_FACTS;