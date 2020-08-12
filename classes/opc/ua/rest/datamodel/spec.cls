Class opc.ua.rest.datamodel.spec Extends %REST.Spec [ ProcedureBlock ]
{

XData OpenAPI [ MimeType = application/json ]
{
{
  "swagger": "2.0",
  "info": {
    "title": "Datamodel generation API",
    "description": "Smart Industry datamodel generation API",
    "version": "1.0.0"
  },
  "basePath": "/api",
  "schemes": [
    "https",
    "http"
  ],
  "tags": [
    {
      "name": "Datamodel",
      "description": "Datamodel generation"
    }
  ],
  "paths": {
    "/datamodels": {
      "post": {
        "tags": [
          "Datamodel"
        ],
        "summary": "Generate a new or update existing datamodels based on all configurations of the equipment",
        "operationId": "PostDataModelGeneration",
        "description": "Generate a new or update existing datamodels based on all configurations of the equipment",
        "consumes": [
          "application/json"
        ],
        "produces": [
          "application/json"
        ],
        "parameters": [
          {
            "in": "body",
            "name": "body",
            "description": "Datamodel generation",
            "required": true,
            "schema": {
              "$ref": "#/definitions/DataModel"
            }
          }
        ],
        "responses": {
          "201": {
            "description": "Created"
          },
          "400": {
            "description": "Bad Request"
          },
          "500": {
            "description": "Internal Server Error"
          }
        }
      }
    },
    "/nodegen": {
      "post": {
        "summary": "Generate JSON node definitions from ASD CSV input.",
        "operationId": "NodeGeneration",
        "description": "",
        "consumes": [
          "text/plain"
        ],
        "produces": [
          "application/json"
        ],
        "parameters": [
          {
            "name": "input",
            "description": "CSV input.",
            "in": "body",
            "schema": {
              "$ref": "#/definitions/ASD_CSV"
            },
            "required": true
          },
          {
            "name": "namespace",
            "description": "Namepace to use in opc_ua_node field of Node definition.",
            "in": "query",
            "type": "string",
            "required": true
          },
          {
            "name": "machine_name",
            "description": "Machine name to use in opc_ua_node field of Node definition.",
            "in": "query",
            "type": "string",
            "required": true
          }
        ],
        "responses": {
          "201": {
            "description": "Created"
          },
          "400": {
            "description": "Bad Request"
          },
          "500": {
            "description": "Internal Server Error"
          }
        }
      }
    }
  },
  "definitions": {
    "DataModel": {
      "type": "object",
      "properties": {
        "equipment_name": {
          "type": "string"
        }
      }
    },
    "ASD_CSV": {
	    "type": "string"
    }
  }
}
}

}
