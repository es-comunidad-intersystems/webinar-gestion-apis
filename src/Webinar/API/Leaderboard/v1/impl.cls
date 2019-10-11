/// A dummy player leaderboard API<br/>
/// Business logic class defined by OpenAPI in Webinar.API.Leaderboard.v1.spec<br/>
/// Created Oct 9, 2019 09:49:35
Class Webinar.API.Leaderboard.v1.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 0;

/// Add a new player<br/>
/// The method arguments hold values for:<br/>
///     body, Player object to be added<br/>
ClassMethod addPlayer(body As %DynamicObject) As %DynamicObject
{
    set player = ##class(Webinar.Data.Player).%New()
    do player.%JSONImport(body)
    set sc = player.%Save()
    if $$$ISERR(sc) {
    	do ..%SetStatusCode(405)
    	quit ""
    }
    do player.%JSONExportToStream(.stream)
    quit stream
}

/// Return all players
ClassMethod getPlayers() As %DynamicObject
{
    set sql = "SELECT Id, Name, Alias FROM Webinar_Data.Player order by Score"
    set statement = ##class(%SQL.Statement).%New()
    set sc = statement.%Prepare(sql)
    set rs = statement.%Execute()
    
    set array = []
    while rs.%Next() {
    	do array.%Push( 
    		{
    			"Id": (rs.%Get("Id")),
    			"Name": (rs.%Get("Name")),
    			"Alias": (rs.%Get("Alias"))
    		})
    }
    
    quit array
}

/// Returns a single player<br/>
/// The method arguments hold values for:<br/>
///     playerId, ID of player to return<br/>
ClassMethod getPlayerById(playerId As %Integer) As %DynamicObject
{
    set player = ##class(Webinar.Data.Player).%OpenId(playerId)
    if '$isobject(player) {
    	do ..%SetStatusCode(404)
    	quit ""
    }
    do player.%JSONExportToStream(.stream)
    quit stream
}

/// Update an existing player<br/>
/// The method arguments hold values for:<br/>
///     playerId, Player id to update<br/>
///     body, Player object to be updated<br/>
ClassMethod updatePlayer(playerId As %Integer, body As %DynamicObject) As %DynamicObject
{
    set player = ##class(Webinar.Data.Player).%OpenId(playerId)
    if '$isobject(player) {
    	do ..%SetStatusCode(404)
    	quit ""
    }
    do player.%JSONImport(body)
    do player.%Save()
    do player.%JSONExportToStream(.stream)
    quit stream
}

/// Deletes a player<br/>
/// The method arguments hold values for:<br/>
///     playerId, Player id to delete<br/>
ClassMethod deletePlayer(playerId As %Integer) As %DynamicObject
{
    set sc = ##class(Webinar.Data.Player).%DeleteId(playerId)
    if $$$ISERR(sc) {
    	do ..%SetStatusCode(404)
    }
    quit ""
}

}
