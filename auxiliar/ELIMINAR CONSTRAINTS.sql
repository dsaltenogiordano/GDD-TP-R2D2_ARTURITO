-- Declarar las variables necesarias
DECLARE @schemaName NVARCHAR(128) = 'R2D2_ARTURITO' -- Reemplaza 'tu_schema' con el nombre de tu esquema
DECLARE @tableName NVARCHAR(128)
DECLARE @constraintName NVARCHAR(128)
DECLARE @sql NVARCHAR(MAX)

-- Eliminar todos los FOREIGN KEY constraints del esquema especificado
DECLARE fk_cursor CURSOR FOR
SELECT table_name, constraint_name
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE constraint_type = 'FOREIGN KEY' AND table_schema = @schemaName
OPEN fk_cursor
FETCH NEXT FROM fk_cursor INTO @tableName, @constraintName
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = 'ALTER TABLE ' + @schemaName + '.' + @tableName + ' DROP CONSTRAINT ' + @constraintName
    EXEC sp_executesql @sql
    FETCH NEXT FROM fk_cursor INTO @tableName, @constraintName
END
CLOSE fk_cursor
DEALLOCATE fk_cursor

-- Eliminar todos los PRIMARY KEY, UNIQUE y CHECK constraints del esquema especificado
DECLARE pk_uc_ck_cursor CURSOR FOR
SELECT table_name, constraint_name
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE constraint_type IN ('PRIMARY KEY', 'UNIQUE', 'CHECK') AND table_schema = @schemaName
OPEN pk_uc_ck_cursor
FETCH NEXT FROM pk_uc_ck_cursor INTO @tableName, @constraintName
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = 'ALTER TABLE ' + @schemaName + '.' + @tableName + ' DROP CONSTRAINT ' + @constraintName
    EXEC sp_executesql @sql
    FETCH NEXT FROM pk_uc_ck_cursor INTO @tableName, @constraintName
END
CLOSE pk_uc_ck_cursor
DEALLOCATE pk_uc_ck_cursor

-- Eliminar todas las tablas del esquema especificado
DECLARE table_cursor CURSOR FOR
SELECT table_name
FROM INFORMATION_SCHEMA.TABLES
WHERE table_schema = @schemaName AND table_type = 'BASE TABLE'
OPEN table_cursor
FETCH NEXT FROM table_cursor INTO @tableName
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @sql = 'DROP TABLE ' + @schemaName + '.' + @tableName
    EXEC sp_executesql @sql
    FETCH NEXT FROM table_cursor INTO @tableName
END
CLOSE table_cursor
DEALLOCATE table_cursor