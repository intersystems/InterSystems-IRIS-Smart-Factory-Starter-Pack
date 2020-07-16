Class opc.ua.rest.equipment.spec Extends %REST.Spec [ ProcedureBlock ]
{

XData OpenAPI [ MimeType = application/json ]
{
{
  "swagger":"2.0",
  "info":{
    "title":"Equipment API",
    "description":"Smart Industry equipment configuration",
    "version":"1.0.0"
  },
  "basePath":"/api",
  "schemes":[
    "https",
    "http"
  ],
  "tags":[
    {
      "name":"Equipment",
      "description":"Equipment management"
    },
    {
      "name":"Configuration",
      "description":"Configuration management"
    },
    {
      "name":"Node",
      "description":"Node management"
    },
    {
	  "name":"Yield",
      "description":"Yield management"
    }    
  ],
  "paths":{
	"/yields":{
      "get":{
        "tags":[
          "Yield"
        ],
        "summary":"Returns all yields",
        "operationId":"GetYields",
        "description":"Return all yields",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "responses":{
          "200":{
            "description":"OK",
            "schema":{
              "$ref":"#/definitions/Yields"
            }
          },
          "500":{
            "description":"Internal Server Error"
          }
        }
      }
	},     
	"/equipmenttypes":{
      "get":{
        "tags":[
          "Equipment"
        ],
        "summary":"Returns all equipment types",
        "operationId":"GetEquipmentTypes",
        "description":"Return all equipment types",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "responses":{
          "200":{
            "description":"OK",
            "schema":{
              "$ref":"#/definitions/EquipmentTypes"
            }
          },
          "500":{
            "description":"Internal Server Error"
          }
        }
      }
	},   
    "/equipments":{
      "get":{
        "tags":[
          "Equipment"
        ],
        "summary":"Returns all equipments",
        "operationId":"GetEquipments",
        "description":"Return all equipments",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "responses":{
          "200":{
            "description":"OK",
            "schema":{
              "$ref":"#/definitions/Equipments"
            }
          },
          "500":{
            "description":"Internal Server Error"
          }
        }
      },
      "post":{
        "tags":[
          "Equipment"
        ],
        "summary":"Add new equipment definition",
        "operationId":"PostEquipment",
        "description":"Add new equipment definition",
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
            "description":"Add new equipment",
            "required":true,
            "schema":{
              "$ref":"#/definitions/Equipments"
            }
          }
        ],
        "responses":{
          "201":{
            "description":"Created"            
          },
          "400":{
            "description":"Bad Request"
          },
          "500":{
            "description":"Internal Server Error"
          }
        }
      }
    },
    "/equipments/{equipment_name}":{
      "get":{
        "tags":[
          "Equipment"
        ],
        "summary":"Returns info for the given equipment name",
        "operationId":"GetEquipment",
        "description":"Returns info for the given equipment name",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "in":"path",
            "name":"equipment_name",
            "type":"string",
            "required":true
          }
        ],
        "responses":{
          "200":{
            "description":"OK",
            "schema":{
              "$ref":"#/definitions/Equipment"
            }
          },
          "404":{
            "description":"Not Found"
          }
        }
      },
      "put":{
        "tags":[
          "Equipment"
        ],
        "summary":"Updates given equipment",
        "operationId":"PutEquipment",
        "description":"Updates given equipment",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "in":"path",
            "name":"equipment_name",
            "type":"string",
            "required":true
          },
          {
            "in": "body",
            "name": "body",
            "description": "Update the equipment",
            "required": true,
            "schema": {
              "$ref": "#/definitions/Equipment"
            }
          }
        ],
        "responses":{
          "200":{
            "description":"OK"
          },
          "400":{
            "description":"Bad Request"
          },
          "404":{
            "description":"Not Found"
          },
          "500":{
            "description":"Internal Server Error"
          }
        }
      }
    },
    "/equipments/{equipment_name}/configurations":{
      "get":{
        "tags":[
          "Equipment"
        ],
        "summary":"Returns the available configurations",
        "operationId":"GetEquipmentConfigurations",
        "description":"Returns the specified configuration for the given equipment name",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "in":"path",
            "name":"equipment_name",
            "type":"string",
            "required":true
          }
        ],
        "responses":{
          "200":{
            "description":"OK",
            "schema":{
              "$ref":"#/definitions/Configurations"
            }
          },
          "400":{
            "description":"Bad Request"
          },
          "500":{
            "description":"Internal Server Error"
          }
        }
      }
    },
    "/equipments/{equipment_name}/configurations/{configuration_name}":{
	  "put":{
        "tags":[
          "Equipment"
        ],
        "summary":"Add configuration to the equipment",
        "operationId":"AddConfigurationToEquipment",
        "description":"Add configuration to the equipment",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "in":"path",
            "name":"equipment_name",
            "type":"string",
            "required":true
          },
          {
            "in":"path",
            "name":"configuration_name",
            "type":"string",
            "required":true
          }          
        ],
        "responses":{
          "200":{
            "description":"OK"
          },
          "400":{
            "description":"Bad Request"
          },
          "404":{
            "description":"Not Found"
          },
          "409":{
	        "description":"Conflict"  
          },    
          "500":{
            "description":"Internal Server Error"
          }
        }
      },  
      "get":{
        "tags":[
          "Equipment"
        ],
        "summary":"Returns the specified configuration for the given equipment name",
        "operationId":"GetEquipmentConfiguration",
        "description":"Returns the specified configuration for the given equipment name",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "in":"path",
            "name":"equipment_name",
            "type":"string",
            "required":true
          },
          {
            "in":"path",
            "name":"configuration_name",
            "type":"string",
            "required":true
          }
        ],
        "responses":{
          "200":{
            "description":"OK",
            "schema":{
              "$ref":"#/definitions/Configuration"
            }
          },
          "404":{
            "description":"Not Found"
          }
        }
      }
    },
    "/configurations":{
      "get":{
        "tags":[
          "Configuration"
        ],
        "summary":"Returns all configurations",
        "operationId":"GetConfigurations",
        "description":"Returns all configurations",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "responses":{
          "200":{
            "description":"OK",
            "schema":{
              "$ref":"#/definitions/Configurations"
            }
          },
          "400":{
            "description":"Bad Request"
          },
          "500":{
            "description":"Internal Server Error"
          }
        }
      },
      "post":{
        "tags":[
          "Configuration"
        ],
        "summary":"Add new configuration",
        "operationId":"PostConfigurations",
        "description":"Add new configuration",
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
            "description":"Add new configuration",
            "required":true,
            "schema":{
              "$ref":"#/definitions/Configurations"
            }
          }
        ],
        "responses":{
          "201":{
            "description":"Created"
          },
          "400":{
            "description":"Bad Request"
          },
          "500":{
            "description":"Internal Server Error"
          }
        }
      }
    },
    "/configurations/{configuration_name}":{
      "get":{
        "tags":[
          "Configuration"
        ],
        "summary":"Returns configuration for specified name",
        "operationId":"GetConfiguration",
        "description":"Returns configuration for specified name",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "in":"path",
            "name":"configuration_name",
            "type":"string",
            "required":true
          }
        ],
        "responses":{
          "200":{
            "description":"OK",
            "schema":{
              "$ref":"#/definitions/Configuration"
            }
          },
          "400":{
            "description":"Bad Request"
          },
          "404":{
            "description":"Not Found"
          },
          "500":{
            "description":"Internal Server Error"
          }
        }
      },
      "put":{
        "tags":[
          "Configuration"
        ],
        "summary":"Updates given configuration",
        "operationId":"PutConfiguration",
        "description":"Updates given configuration",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "in":"path",
            "name":"configuration_name",
            "type":"string",
            "required":true
          },
          {
            "in": "body",
            "name": "body",
            "description": "Update the Configuration",
            "required": true,
            "schema": {
              "$ref": "#/definitions/Configuration"
            }
          }
        ],
        "responses":{
          "200":{
            "description":"OK"            
          },
          "400":{
            "description":"Bad Request"
          },
          "404":{
            "description":"Not Found"
          },
          "500":{
            "description":"Internal Server Error"
          }
        }
      }
    },
    "/configurations/{configuration_name}/nodes":{
      "post":{
        "tags":[
          "Configuration"
        ],
        "summary":"Add nodes to the configuration",
        "operationId":"PostConfigurationNodes",
        "description":"Add nodes to the configuration",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "in":"path",
            "name":"configuration_name",
            "type":"string",
            "required":true
          },
          {
            "in":"body",
            "name":"body",
            "description":"Add new nodes to the configuration",
            "required":true,
            "schema":{
              "$ref":"#/definitions/Nodes"
            }
          }
        ],
        "responses":{
          "201":{
            "description":"Created"            
          },
          "400":{
            "description":"Bad Request"
          },
          "500":{
            "description":"Internal Server Error"
          }
        }
      },
      "get":{
        "tags":[
          "Configuration"
        ],
        "summary":"Returns list of nodes for the given configuration",
        "operationId":"GetNodesForConfiguration",
        "description":"Returns list of nodes for the given configuration",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "in":"path",
            "name":"configuration_name",
            "type":"string",
            "required":true
          }          
        ],
        "responses":{
          "200":{
            "description":"OK",
            "schema":{
              "$ref":"#/definitions/Nodes"
            }
          },
          "400":{
            "description":"Bad Request"
          },
          "404":{
            "description":"Not Found"
          },
          "500":{
            "description":"Internal Server Error"
          }
        }
      }      
    },
    "/configurations/{configuration_name}/nodes/{node_id}":{
      "put":{
        "tags":[
          "Configuration"
        ],
        "summary":"Add the specified node to the configuration",
        "operationId":"AddNodeToConfiguration",
        "description":"Add the specified node to the configuration",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "in":"path",
            "name":"configuration_name",
            "type":"string",
            "required":true
          },
          {
            "in":"path",
            "name":"node_id",
            "type":"string",
            "required":true
          }             
        ],
        "responses":{
          "200":{
            "description":"OK"            
          },
          "400":{
            "description":"Bad Request"
          },
          "404":{
            "description":"Not Found"
          },
          "409": {
	        "description":"Conflict"  
          },    
          "500":{
            "description":"Internal Server Error"
          }
        }
      }
    },  
    "/nodes":{
      "get":{
        "tags":[
          "Node"
        ],
        "summary":"Returns all nodes",
        "operationId":"GetNodes",
        "description":"Returns all nodes",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "responses":{
          "200":{
            "description":"OK",
            "schema":{
              "$ref":"#/definitions/Nodes"
            }
          },
          "400":{
            "description":"Bad Request"
          },
          "500":{
            "description":"Internal Server Error"
          }
        }
      },
      "post":{
        "tags":[
          "Node"
        ],
        "summary":"Add a new node",
        "operationId":"PostNode",
        "description":"Add a new node",
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
            "description":"Add new Node",
            "required":true,
            "schema":{
              "$ref":"#/definitions/Nodes"
            }
          }
        ],
        "responses":{
          "201":{
            "description":"Created"            
          },
          "400":{
            "description":"Bad Request"
          },
          "500":{
            "description":"Internal Server Error"
          }
        }
      }
    },
    "/nodes/{node_id}":{
      "put":{
        "tags":[
          "Node"
        ],
        "summary":"Update the specified node",
        "operationId":"PutNode",
        "description":"Update the specified node",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "in":"path",
            "name":"node_id",
            "type":"string",
            "required":true
          },
          {
            "in": "body",
            "name": "body",
            "description": "Update the Node",
            "required": true,
            "schema": {
              "$ref": "#/definitions/Node"
            }
          }
        ],
        "responses":{
          "200":{
            "description":"OK",
            "schema":{
              "$ref":"#/definitions/Node"
            }
          },
          "400":{
            "description":"Bad Request"
          },
          "404":{
            "description":"Not Found"
          },
          "500":{
            "description":"Internal Server Error"
          }
        }
      },
      "get":{
        "tags":[
          "Node"
        ],
        "summary":"Get the specified node",
        "operationId":"GetNode",
        "description":"Get the specified node",
        "consumes":[
          "application/json"
        ],
        "produces":[
          "application/json"
        ],
        "parameters":[
          {
            "in":"path",
            "name":"node_id",
            "type":"string",
            "required":true
          }
        ],
        "responses":{
          "200":{
            "description":"OK",
            "schema":{
              "$ref":"#/definitions/Node"
            }
          },
          "400":{
            "description":"Bad Request"
          },
          "404":{
            "description":"Not Found"
          },
          "500":{
            "description":"Internal Server Error"
          }
        }
      }
    }
  },
  "definitions":{	  
	"EquipmentType":{
	  "type":"object",
      "properties":{
        "name":{
          "type":"string"
        },
        "description":{
          "type":"string"
        }
}   
    },       
	"EquipmentTypes":{
	  "type":"array",
      "items":{
        "$ref": "#/definitions/EquipmentType"
      }
    }, 
	"Yield":{
	  "type":"object",
      "properties":{
        "name":{
          "type":"string"
        },
        "value": {
	      "type":"string"
        }
      }   
    },
	"Yields":{
	  "type":"array",
      "items":{
        "$ref": "#/definitions/Yield"
      }
    }, 
    "Equipment":{
	  "type":"object",
      "properties":{
        "name":{
          "type":"string"
        },
        "description":{
          "type":"string"
        },
        "equipment_type":{
          "$ref": "#/definitions/EquipmentType"
        },
        "class_package":{
          "type":"string"
        },
        "location":{
          "type":"string"
        },
        "uom":{
          "type":"string"
        },
        "yields":{
          "type":"array",
      	  "items":{
	      	  "$ref": "#/definitions/Yield"
      	  }
        }
      }   
    },       
    "Equipments":{
      "type":"array",
      "items":{
        "$ref": "#/definitions/Equipment"
      }
    },
    "Configuration":{
	  "type":"object",
      "properties":{
        "name":{
          "type":"string"
        },
        "config_type":{
          "type":"string",
          "enum":[
            "staging",
            "transforming",
            "serving"
          ]
        },
        "description":{
          "type":"string"
        },
        "version":{
          "type":"string"
        },
        "current_version":{
          "type":"boolean"
        },
        "effective_begin":{
          "type":"string",
          "format":"date-time"
        },
        "effective_end":{
          "type":"string",
          "format":"date-time"
        },
        "standard_oee_fields":{
          "type":"boolean"
        },
        "create_powerbi_dataset":{
          "type":"boolean"
        }                
      }   
    },   
    "Configurations":{
      "type":"array",
      "items":{
        "$ref": "#/definitions/Configuration"
      }
    },
    "Node":{
	   "type":"object", 
	   "properties":{
		   "id":{
            "type":"string"
          },
          "name":{
            "type":"string"
          },
		  "display_name":{
            "type":"string"
          },
		  "description":{
            "type":"string"
          },
		  "opc_ua_node":{
            "type":"string"
          },
		  "database_attribute":{
            "type":"string"
          },
		  "database_type":{
            "type":"string",
			"enum": [
                "string",
                "integer",
                "double",
                "float",
				"decimal",
				"boolean",
				"time",
				"timestamp",
				"date"
              ]
          },
		  "database_length":{
			"type":"integer"
		  },
		  "is_indexed":{
			"type":"boolean"
		  }
	   }   
    }, 
    "Nodes":{
      "type":"array",
      "items":{
        "$ref": "#/definitions/Node"
      }
    }
  }
}
}

}
