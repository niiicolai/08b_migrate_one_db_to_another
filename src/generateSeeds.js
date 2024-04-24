import optionParser from './optionParser.js';
import fs from 'fs';
import Knex from 'knex';

function getFileName(dir, table_name) {
    const time = new Date().getTime();
    return `./${dir}/${time}_${table_name}.js`;
}

function getSeedContent(table, records) {
    return `export const seed = function(knex) {
    return knex('${table}').insert(${JSON.stringify(records, null, 4)});
}`;
}

async function generateSeeds(connectOptions = {}, database, outputDir = './seeds') {
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
    for (const table of tables) {
        const seedFile = getFileName(outputDir, table);
        const records = await knex(table).select();
        if (!records.length) continue;
        const content = getSeedContent(table, records);
        fs.writeFileSync(seedFile, content);
    }

    console.log('Seeds generated successfully');
    knex.destroy();
}

try {
    const options = optionParser();
    generateSeeds({
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