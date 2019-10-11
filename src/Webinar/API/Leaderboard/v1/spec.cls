Class Webinar.API.Leaderboard.v1.spec Extends %REST.Spec [ ProcedureBlock ]
{

XData OpenAPI [ MimeType = application/json ]
{
{
  "swagger":"2.0",
  "info":{
    "description":"A dummy player leaderboard API",
    "version":"1.0.0",
    "title":"Leaderboard API"
  },
  "basePath":"/leaderboard/api/v1",
  "tags":[
    {
      "name":"player",
      "description":"All you need to manage your players!"
    }
  ],
  "schemes":[
    "http"
  ],
  "paths":{
    "/player":{
      "post":{
        "tags":[
          "player"
        ],
        "summary":"Add a new player",
        "description":"",
        "operationId":"addPlayer",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "in":"body",
            "name":"body",
            "description":"Player object to be added",
            "required":true,
            "schema":{
              "$ref":"#/definitions/Player"
            }
          }
        ],
        "responses":{
          "405":{
            "description":"Invalid input"
          }
        }
      },
      "get":{
        "tags":[
          "player"
        ],
        "summary":"Return all players",
        "description":"Return all players",
        "operationId":"getPlayers",
        "produces":[
          "application/json"
        ],
        "responses":{
          "200":{
            "description":"successful operation",
            "schema":{
              "type":"array",
              "items":{
                "$ref":"#/definitions/Player"
              }
            }
          }
        }
      }
    },
    "/player/{playerId}":{
      "get":{
        "tags":[
          "player"
        ],
        "summary":"Find player by ID",
        "description":"Returns a single player",
        "operationId":"getPlayerById",
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "name":"playerId",
            "in":"path",
            "description":"ID of player to return",
            "required":true,
            "type":"integer",
            "format":"int64"
          }
        ],
        "responses":{
          "200":{
            "description":"successful operation",
            "schema":{
              "$ref":"#/definitions/Player"
            }
          },
          "404":{
            "description":"Player not found"
          }
        }
      },
      "put":{
        "tags":[
          "player"
        ],
        "summary":"Update an existing player",
        "description":"",
        "operationId":"updatePlayer",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "name":"playerId",
            "in":"path",
            "description":"Player id to update",
            "required":true,
            "type":"integer",
            "format":"int64"
          },
          {
            "in":"body",
            "name":"body",
            "description":"Player object to be updated",
            "required":true,
            "schema":{
              "$ref":"#/definitions/Player"
            }
          }
        ],
        "responses":{
          "404":{
            "description":"Player not found"
          }
        }
      },
      "delete":{
        "tags":[
          "player"
        ],
        "summary":"Deletes a player",
        "description":"",
        "operationId":"deletePlayer",
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "name":"playerId",
            "in":"path",
            "description":"Player id to delete",
            "required":true,
            "type":"integer",
            "format":"int64"
          }
        ],
        "responses":{
          "404":{
            "description":"Player not found"
          }
        }
      }
    }
  },
  "definitions":{
    "Player":{
      "type":"object",
      "properties":{
        "Id":{
          "type":"integer",
          "format":"int64",
          "example":123
        },
        "Name":{
          "type":"string",
          "example":"John Doodle"
        },
        "Alias":{
          "type":"string",
          "example":"superscorer33"
        },
        "Score":{
          "type":"number",
          "example":1400
        },
        "Team":{
          "$ref":"#/definitions/Team"
        }
      }
    },
    "Team":{
      "type":"object",
      "properties":{
        "Id":{
          "type":"integer",
          "format":"int64",
          "example":675
        },
        "Name":{
          "type":"string",
          "example":"Superteam"
        },
        "City":{
          "type":"string",
          "example":"Tatooine"
        }
      }
    }
  }
}
}

}
