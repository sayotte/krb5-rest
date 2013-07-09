{
	"type":  "object",
	"title": "principals",
	"description": "CRUD on Krb5 principals",
	"properties": {
		"name": {
			"description": "Principal to be created/updated/deleted",
			"type": "string"
		},
		"secret": {
			"description": "Secret used to obtain credentials on this principal",
			"type": "string"
		}
	},
	"require": ["name"]
}
	
