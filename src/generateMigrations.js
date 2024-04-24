import optionParser from './optionParser.js';
import fs from 'fs';
import Knex from 'knex';

function getFileName(dir, table_name) {
    const time = new Date().getTime();
    return `./${dir}/${time}_${table_name}.js`;
}

function getDataType(column) {
    switch (column['DATA_TYPE']) {
        case 'int':
            return 'integer';
        case 'char':
            return 'varchar';
        default:
            return column['DATA_TYPE'];
    }
}

function getDefaultValue(column) {
    if (column['COLUMN_DEFAULT'] === 'CURRENT_TIMESTAMP') {
        return `.defaultTo(knex.fn.now())`;
    } else if (column['COLUMN_DEFAULT']) {
        return `.defaultTo('${column['COLUMN_DEFAULT']}')`;
    }
    return '';
}

function getMigrationContent(table, columns) {
    return `export const up = function(knex) {
    return knex.schema.createTable('${table}', function(table) {
        ${columns.map((column) => {
            const dataType = getDataType(column);
            const columnDefault = getDefaultValue(column);
            const columnName = column['COLUMN_NAME'];
            const length = column['CHARACTER_MAXIMUM_LENGTH'];
            const nullable = column['IS_NULLABLE'] === 'YES' ? '.nullable()' : '.notNullable()';
            const pk = column['COLUMN_KEY'] === 'PRI';
            const fk = column['COLUMN_KEY'] === 'MUL';
            const unique = column['COLUMN_KEY'] === 'UNI';
            const index = column['COLUMN_KEY'] === 'MUL';
            const autoIncrement = column['EXTRA'] === 'auto_increment';
            const unsigned = column['COLUMN_TYPE'].includes('unsigned');
            const comment = column['COLUMN_COMMENT'] ? `.comment('${column['COLUMN_COMMENT']}')` : '';
   
            if (autoIncrement) {
                return `table.increments('${columnName}')${pk ? '.primary()' : ''};`;
            }

            return `table.${dataType}('${columnName}'${length ? `, ${length}` : ''})${nullable}${columnDefault}${comment};`;

        }).join('\n\t\t')}
    })
}

export const down = function(knex) {
    return knex.schema.dropTable('${table}');
}`
}

async function generateMigrations(connectOptions = {}, database, outputDir = './migrations') {
    if (!connectOptions.client) throw new Error('Client is required');
    if (!connectOptions.connection) throw new Error('Connection is required');
    if (!database) throw new Error('Database name is required');
    if (!outputDir) throw new Error('Output directory is required');

    if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir);
    }

    // Remove all files in the output directory
    fs.readdirSync(outputDir).forEach((file) => {
        fs.unlinkSync(`${outputDir}/${file}`);
    });

    // connect to database
    const knex = Knex(connectOptions);

    const records = await knex('information_schema.columns')
        .select()
        .where('table_schema', database);

    const tables = [...new Set(records.map((record) => record['TABLE_NAME']))];

    // create migration files
    tables.forEach((table) => {
        const migrationFile = getFileName(outputDir, table);
        const columns = records.filter((record) => record['TABLE_NAME'] === table);
        const content = getMigrationContent(table, columns);
        fs.writeFileSync(migrationFile, content);
    });

    console.log('Migrations generated successfully');
    knex.destroy();
}

try {
    const options = optionParser();
    generateMigrations({
        client: options.c,
        connection: {
            port: options.p,
            host: options.h,
            user: options.u,
            password: options.pw,
            database: options.d
        }
    }, options.d, options.o);
} catch (error) {
    console.error(error.message);
}