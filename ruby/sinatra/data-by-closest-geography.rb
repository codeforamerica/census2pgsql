require 'sinatra'
require 'json'
require 'pg'

$db_config = YAML::load_file('config.yml')['database']

get '/data' do
  conn = PGconn.connect($db_config['host'], $db_config['port'], '', '', $db_config['db'], $db_config['user'], $db_config['password'])
  
  res = conn.exec(%&SELECT *, ST_Distance_Sphere("the_geom", ST_Point($1, $2)) AS "dist" FROM census WHERE "SUMLEV" = '$3' ORDER BY "dist" DESC LIMIT 1&, 
    [params[:lon], params[:lat], params[:sumlev]])
  
  
end