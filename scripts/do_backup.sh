#/bin/sh

date=$(date '+%Y-%m-%d')
backup_dir=/scripts/backups/

db_command="show databases where \`Database\` NOT IN ('information_schema', 'mysql', 'performance_schema', 'sys')"

for DB in $(mysql -e "$db_command" -s --skip-column-names); do
    echo "Processing: $DB"
    mysqldump --single-transaction --events --routines --master-data=2 $DB > $backup_dir/.database.sql
    bin_ponum=$(grep 'MASTER_LOG_FILE' $backup_dir/.database.sql | sed -r "s/.*?bin\.(.*?)', MASTER_LOG_POS=(.*?);/bin-\1_pos-\2/")


    backup_file="${backup_dir}${DB}-${date}_${bin_ponum}.tgz"
    echo $backup_file
    gzip -c $backup_dir/.database.sql > $backup_file
done
