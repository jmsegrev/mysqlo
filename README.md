# Mysqlo

If you prefer to use SQL instead of ORMs to query your Mysql database, this will help you organize better.


## Install

`npm install jmsegrev/mysqlo`

## Usage

### Configuration

```CoffeeScript
mysqlo = require 'mysqlo'                       
                                                                                  
configuration = 
  # path to where the models will be loaded from 
  modelsPath: __dirname + '/models'
  # mysqlp databases configuration
  database:                                                                       
    master:                                                                       
      host: "localhost"                                                           
      database: "coolflow"                                                        
      user: "root"                                                                
      password: "3414"                                                            
    topo:                                                                         
      host: "localhost",                                                          
      database: "topografico",                                                    
      user: "root",                                                               
      password: "3414"                                                            

models = mysqlo.config configuration
```

For more details on databases configuration and quering please refer to [Mysqlp](https://github.com/jmsegrev/mysqlp).

### Models definition

On your configured `modelsPath` will be the files that will describe your models. The filename will identify the object that holds your definition.

```CoffeeScript

# inside your models dir 'user.coffee'

crypto = require 'crypto'
   
# must return a function that accepts db object
module.exports = (db) -> 

  # creates a snippet that can be resudes later
  db.snippet 1, "
    SELECT 
      user_id AS id,
      username,
      fullname,
      added_at AS registered
    FROM users
  "

  # attach as many functions as you want for later use
  db.findById = (id) ->

    # check Mysqlp module for how to make queries
    @query('master') "
      WHERE user_id = ? # this will be appended to the sql snippet
    ", [id], 1 # the 1 refers to the snippet id, could also be a string


  db.findOne = (username, password) ->

    hash = crypto.createHash('md5').update(password).digest 'hex'

    @query('master') "
      WHERE username = ?
      AND password = ?
    ", [username, hash], 1
```

### Executing your queries

```CoffeeScript

models = mysqlo.config configuration
# after configuration is set 'mysqlo.models' will also have your models

models.user.findById(98323).then (result) ->
  console.log result
