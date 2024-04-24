import optionParser from './optionParser.js';
import fs from 'fs';
import __dirname from 'path';

function getKnexFileContent(development) {
    if (!development.client) throw new Error('Client is required');
    if (!development.host) throw new Error('Host is required');
    if (!development.port) throw new Error('Port is required');
    if (!development.user) throw new Error('User is required');
    if (!development.password) throw new Error('Password is required');
    if (!development.database) throw new Error('Database name is required');

    return `export default {
    development: {
        client: '${development.client}',
        connection: {
            host: '${development.host}',
            port: '${development.port}',
            user: '${development.user}',
            password: '${development.password}',
            database: '${development.database}'
        }
    },
};`
}

function generateKnexFile(options) {
    const path = 'knexfile.js';
    const content = getKnexFileContent(options);
    fs.writeFileSync(path, content);
    console.log('Knexfile.js generated successfully');
}

try {
    const options = optionParser(' ');
    generateKnexFile({
        client: options.c,
        host: options.h,
        port: options.p,
        user: options.u,
        password: options.pw,
        database: options.d
    });
} catch (error) {
    console.error(error.message);
}
