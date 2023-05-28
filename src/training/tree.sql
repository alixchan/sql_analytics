--задана структура предприятия - отделы компаний

--дерево
SELECT lpad(' ', 3 * level) || title AS Tree, level, id, pid, title
FROM test_table START WITH pid = 3
CONNECT BY pid = PRIOR id
ORDER SIBLINGS BY title;

--путь
SELECT SYS_CONNECT_BY_PATH(title, ' | ') AS Path, level, id, pid, title
FROM test_table START WITH pid IS NULL
CONNECT BY PRIOR id = pid;

--метка листа и вывод корня
SELECT id,
       pid,
       title,
       level,
       CONNECT_BY_ISLEAF AS IsLeaf, PRIOR title AS Parent, CONNECT_BY_ROOT title AS Root
FROM test_table
START WITH pid IS NULL
CONNECT BY PRIOR id = pid
ORDER SIBLINGS BY title;

--исключение ноды
SELECT lpad(' ', 3 * level) || title AS Tree, level, id, pid, title
FROM test_table
WHERE title NOT LIKE 'Сервер%' START
WITH pid IS NULL
CONNECT BY pid = PRIOR id
ORDER SIBLINGS BY title;

--исключение ветки
SELECT lpad(' ', 3 * level) || title AS Tree, level, id, pid, title
FROM test_table START WITH pid IS NULL
CONNECT BY pid = PRIOR id AND title NOT LIKE 'Воронеж'
ORDER SIBLINGS BY title;

--у Праймари Пресс хочу (дядей, отца)
WITH data AS (SELECT test_table.*, level l FROM test_table start
WITH pid IS NULL
CONNECT BY pid = PRIOR id )
SELECT *
FROM data
         LEFT JOIN data d
                   ON d.title LIKE 'Праймари%'
WHERE data.l = (d.l - 1);
-- AND data.id not in d.pid; --чтобы отца убрать

-- получить (сиблингов) у Главного
WITH data AS (SELECT test_table.*, level l FROM test_table start
WITH pid IS NULL
CONNECT BY pid = PRIOR id )
SELECT data.*
FROM data
         LEFT JOIN data d
                   ON d.title LIKE 'Главный%'
WHERE data.l = d.l
  AND data.pid = d.pid
  AND data.id <> d.id;

--срез верхушки
WITH data AS (SELECT test_table.*, level l FROM test_table start
WITH pid IS NULL
CONNECT BY pid = PRIOR id )
SELECT data.*
FROM data
         LEFT JOIN data d
                   ON d.title LIKE 'Главный%'
WHERE data.l > d.l;

--дети и потомки
WITH data AS (SELECT test_table.*, level l FROM test_table start
WITH pid IS NULL
CONNECT BY pid = PRIOR id )
SELECT data.*, d.*
FROM data
         LEFT JOIN data d
                   ON d.title LIKE 'ОАО%'
WHERE data.l > d.l
  AND data.id;