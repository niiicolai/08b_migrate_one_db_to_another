
/**
 * Options:
 * -h: database host (default: localhost)
 * -p: database port (default: 5432)
 * -u: database user (default: root)
 * -pw: database password (default: '')
 * -d: database name (required)
 * -o: output directory (default: './migrations')
 * -c: client (default: 'pg')
 */
const options = {}
const optionKeys = ['h', 'p', 'u', 'pw', 'd', 'o', 'c', 'help'];
export default function readArguments(defaultDir=null) {
    for (let i = 2; i < process.argv.length; i++) {
        const arg = process.argv[i];
        
        if (arg.startsWith('-')) {
            const key = arg.substring(1);
            const value = process.argv[++i];
            if (key === 'help') {
                console.log('Options:');
                console.log('-h: database host (default: localhost)');
                console.log('-p: database port (default: 5432)');
                console.log('-u: database user (default: root)');
                console.log('-pw: database password (default: \'\')');
                console.log('-d: database name (required)');
                console.log('-o: output directory (default: \'./migrations\')');
                console.log('-c: client (default: \'pg\')');
                process.exit(0);
            } else {
                if (key ===  '') throw new Error('Invalid option: -; use --help to see available options');
                if (!optionKeys.includes(key)) throw new Error(`Invalid option: ${key}; use --help to see available options`);

                options[key] = value;
            }
        }
    }

    if (!options.c) options.c = 'pg';
    if (!options.p) options.p = '5432';
    if (!options.h) options.h = 'localhost';
    if (!options.u) options.u = 'root';
    if (!options.pw) options.pw = '';    
    if (!options.d) throw new Error('Database name is required');
    if (!options.o && !defaultDir) throw new Error('Output directory is required');
    else if (!options.o) options.o = defaultDir;
    
    return options;
}
