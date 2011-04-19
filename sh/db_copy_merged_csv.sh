for FILE in *.csv; do echo "set client_encoding = 'latin1'; COPY census from '/home/donkey/code/census2pgsql/data/$FILE'" | psql -d census2010; done
