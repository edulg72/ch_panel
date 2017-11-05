#!/bin/bash

LOG_FILE=/home/ubuntu/scan_PU.log

cd /var/www/ch_panel/scripts

echo "Start: $(date '+%d/%m/%Y %H:%M:%S')"

psql -h $POSTGRESQL_DB_HOST -d ch_panel -U $POSTGRESQL_DB_USERNAME -c 'delete from ur; delete from mp;'

ruby scan_UR.rb $1 $2 7.45 47.82 9.7 47.57 0.25
ruby scan_UR.rb $1 $2 6.7 47.57 9.7 47.32 0.25
ruby scan_UR.rb $1 $2 6.45 47.32 9.7 47.07 0.25

ruby scan_UR.rb $1 $2 6.2 47.07 10.7 46.82 0.25
ruby scan_UR.rb $1 $2 5.95 46.82 10.7 46.57 0.25
ruby scan_UR.rb $1 $2 5.95 46.57 10.7 46.32 0.25

ruby scan_UR.rb $1 $2 5.95 46.32 6.45 46.07 0.25
ruby scan_UR.rb $1 $2 6.7 46.32 10.2 46.07 0.25
ruby scan_UR.rb $1 $2 6.7 46.07 8.2 45.82 0.25
ruby scan_UR.rb $1 $2 8.7 46.07 9.2 45.82 0.25
ruby scan_UR.rb $1 $2 8.95 45.82 9.2 45.57 0.25

psql -h $POSTGRESQL_DB_HOST -d ch_panel -U $POSTGRESQL_DB_USERNAME -c 'update ur set state_id = (select id from states where ST_Contains(geom, ur.position) limit 1) where state_id is null;'
psql -h $POSTGRESQL_DB_HOST -d ch_panel -U $POSTGRESQL_DB_USERNAME -c 'update mp set state_id = (select id from states where ST_Contains(geom, mp.position) limit 1) where state_id is null;'
psql -h $POSTGRESQL_DB_HOST -d ch_panel -U $POSTGRESQL_DB_USERNAME -c 'update ur set comments = 0 where comments is null;'
psql -h $POSTGRESQL_DB_HOST -d ch_panel -U $POSTGRESQL_DB_USERNAME -c 'update mp set weight = 0 where weight is null;'
psql -h $POSTGRESQL_DB_HOST -d ch_panel -U $POSTGRESQL_DB_USERNAME -c 'refresh materialized view vw_ur;'
psql -h $POSTGRESQL_DB_HOST -d ch_panel -U $POSTGRESQL_DB_USERNAME -c 'refresh materialized view vw_mp;'
psql -h $POSTGRESQL_DB_HOST -d ch_panel -U $POSTGRESQL_DB_USERNAME -c "update updates set updated_at = current_timestamp where object = 'ur';"
psql -h $POSTGRESQL_DB_HOST -d ch_panel -U $POSTGRESQL_DB_USERNAME -c 'vacuum analyze;'

echo "End: $(date '+%d/%m/%Y %H:%M:%S')"
