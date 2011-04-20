require 'sinatra'
require 'json'
require 'pg'
require 'yaml'

class CensusService < Sinatra::Base
  $db_config = YAML::load_file('config.yml')['database']

  get '/data' do
    #TODO: set content type
    #TODO: handle any exceptions gracefully
    
    conn = PGconn.connect($db_config['host'], $db_config['port'], '', '', $db_config['db'], $db_config['user'], $db_config['password'])
  
    res = conn.exec(%&SELECT *, ST_Distance_Sphere("the_geom", ST_SetSRID(ST_Point($1, $2), 4269)) AS "dist" FROM census WHERE "SUMLEV" = $3 ORDER BY "dist" LIMIT 1&, 
      [params[:lon], params[:lat], params[:sumlev]])
  
    #TODO: make sure we have a result
    res[0].to_json
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
