
module.exports = (db) ->

  connections = {}

  model =
    # Maps `id` to a partial sql snippet set in `content` for query reuse 
    snippet: (id, content) ->
      @_snippets ?= {}
      @_snippets[id] = content


    # Runs `sql` and returns a promise.
    # If `values` is set, it'll be used as/for a sql prepared statemet.
    # It also accepts the `snippetId` of a previously set partial sql.
    query: (group='master') ->

      unless group of connections
        connections[group] = db.connect(group)
      
      (sql, values, snippetId) =>

        if snippetId?
          # The `sql` passed will be appended to the snippet.
          sql = @_snippets?[snippetId].concat sql

        connections[group]
          .bind(@)
          .then (connection) ->
            connection.query(sql, values)
              .spread (rows, fields) ->
                return rows




    begin: (group='master') ->
      unless group of connections
        connections[group] = db.connect(group)
   
      (callback) ->
        connections[group].then (connection) ->
          connection.begin(group, callback)
            .finally ->
              connection.end()


    end: (group) ->
      if group? and group of connections
        connections[group].then (connection) ->
          connection.end()

        delete connections[group]
      else
        for groupName of connections
          connections[groupName].then (connection) ->
            connection.end()
          
        connections = {}



    insert: (table, values) ->
      @query "INSERT INTO #{table} SET ?", values

