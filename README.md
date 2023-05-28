### О проекте

Аналитика для БД собранных логов сайта.

#### Файлы

**create_tables** - создание таблиц-справочников:

````
- Таблица eventTypeCategory: категории событий и их идентификаторы.

- Таблица userAgentNameCategory: категории имен пользовательских агентов (программное обеспечение,
  используемое клиентами для доступа к веб-ресурсам) и их версии.

- Таблица userAgentFamilyCategory: категории семейств пользовательских агентов.

- Таблица userAgentVendorCategory: категории производителей пользовательских агентов.

- Таблица userAgentTypeCategory: категории типов пользовательских агентов.

- Таблица userAgentDeviceCategory: категории устройств пользовательских агентов.

- Таблица userAgentOsFamilyCategory: категории семейств операционных систем пользовательских агентов.

- Таблица userAgentOsVendorCategory: категории производителей операционных систем пользовательских агентов.

- Таблица projectIdCategory: категории идентификаторов проектов.

- Таблица sub_projectIdCategory: категории под-идентификаторов проектов.

- Таблица currencySymbolCategory: категории символов валют.

- Таблица localeLanguageCategory: категории языков.

- Таблица locale_nameCategory: категории имен локалей.
````

**data_formatting** - создание представления данных, которое можно использовать для анализа и отчетности,
основанной на атрибутах даты и времени.

**facts** - создает таблицу facts, которая содержит информацию о событиях. определяет хранимую процедуру
print_contact, которая вставляет данные в таблицу facts из временной таблицы staging_table.

**fill_tables** - в ProcessingFacts выполняется обработка фактов и производится вставка данных в
различные таблицы на основе данных из таблицы staging_table.

**procedures** опеределяет следующие процедуры:

````
- p_rep_amount_for_user открывает курсор, который выполняет запрос, в результате которого получается статистика количества событий для каждого пользователя и проекта. Затем результат сортируется по убыванию количества событий и идентификатору пользователя. Итоговый результат включает все столбцы из статистики.

- p_rep_inter_top3_proj_browser открывает курсор, который выполняет запрос, в результате которого получается пересечение данных о хосте, идентификаторе проекта и версии браузера для записей, где версия браузера входит в топ-3 наиболее часто встречающихся версий, а также для записей, где язык локали не соответствует языку проекта (locale_name != localelanguage). Итоговый результат включает столбцы remotehost, projectid и useragentname из пересечения, а также связанные имена проектов и имена пользовательских агентов.

- p_rep_sub_project_amount открывает курсор, который выполняет запрос, в результате которого получается количество записей для каждого под-идентификатора проекта. Затем результат сортируется по идентификатору под-проекта, а также вычисляются процентные ранги, указывающие, какую долю от общего количества записей составляет каждый под-проект. Итоговый результат включает столбцы sub_projectId, amount (количество записей), percent_rank (процентный ранг) и significance (значимость), указывающую, является ли под-проект первым, вторым или третьим по количеству записей.

- p_rep_stat_comparison открывает курсор, который выполняет запрос, в результате которого получается статистика по количеству событий для каждого хоста. Затем вычисляются различные метрики, такие как медиана, сумма, среднее и максимальное значение количества событий. Итоговый результат включает хост, количество событий, долю событий относительно общего количества записей, сравнение количества событий с медианой и средним значением.

- p_rep_users_type_amount открывает курсор, который выполняет запрос, в результате которого получается статистика количества событий для каждого пользователя, проекта и типа события. Результат сортируется по убыванию количества событий и идентификатору пользователя. Итоговый результат включает идентификатор пользователя (сгенерированный на основе хеша хоста), идентификатор проекта, тип события и количество событий.
````

**views** - создает несколько представлений в базе данных: каждое отображает определенную
таблицу или набор данных с различными преобразованиями.