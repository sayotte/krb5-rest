{
	"type":  "object",
	"title": "keytabs",
	"description": "CRUD on Krb5 keytabs",
	"properties": {
		"name": {
			"description": "Principal to be created/updated/deleted",
			"type": "string"
		}
	},
	"require": ["name"]
}
	
