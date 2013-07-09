Krb5-REST
=========

Sinatra-based REST server for managing Kerberos principals and keytabs.

Overview
========
This tool was developed to solve the problem of hosts powering-on in a datacenter and acquiring an identity, without a priori knowledge of their arrival or hostname. As part of their imaging process, they should be able to create a principal for themselves and obtain a keytab containing the secrets associated with that principal, all without having user-level access to the KDC.

API
===
See the "scripts" sub-directory for working examples. They are thin because this is intended to be thin ;)

Principals
----------
### PUT /api/principals
Creates a new principal.

Expects a JSON body like so:

        { "name": "principal/name.goes.here@DOMAIN.TLD"}

### DELETE /api/principals/url-encoded-principal-goes-here
Deletes an existing principal.

Keytabs
-------
### PUT /api/keytabs
Creates a new keytab containing the secrets for a principal.

The keytab created will be named for only the host component of the principal, e.g. specifying the principal ldap/host.testlab.tld@TESTLAB.TLD would produce a keytab named "host.testlab.tld". Despite this, a single principal must be specified (and will be the only one present in the keytab file... I know, I know, this is actually very limiting).

Expects a JSON body containing the name of the principal in question, as in the PUT /api/principals method above.

### GET /api/keytabs/keytab.name.goes.here
Streams the keytab file in binary form (MIME type 'application/octet-stream').
Marks the "keytab registry" so that this keytab may not be downloaded again.

Setup
=====
Dependencies
------------
Krb5-REST was developed under Ruby-1.8.7. You should *probably* run it under a more recent Ruby, but the support is there if you want it.

The following Ruby Gems are required:

*   json
*   json-schema
*   sinatra
*   thin

System Configuration
--------------------
The application expects to be running as a user who has sudo privileges to run the "kadmin.local" command, so sudo should be configured appropriately. Yes, this is actually a lot of power to put in the hands of a little Ruby script, but it doesn't have many moving parts to break down.

Application Configuration
-------------------------
The server is configured via a YAML file, 'config.yaml'. When empty or not present, a set of defaults are used. 

The current set of config knobs being used can be dumped in YAML format (the format required for the config file itself) by running this snippet in the top-level directory:

	ruby -e 'require "config"; c = Krb5REST::Config.instance; puts YAML.dump(c)'

Should one want to change any value from the default, they could pipe that output into a file named "config.yaml", and then modify the appropriate line. 

Here's the output when using only defaults:

	--- !ruby/object:Krb5REST::Config 
	keytab_registry: ./keytab_registry.txt
	listen_port: 6789
	log_use_stderr: true
	log_use_stdout: false
	log_use_syslog: true
	princnames_rules: ./principal-names-rules.txt
	sinatra_raise_errors: true
	sinatra_show_exceptions: false
	spec_path: ./apispec
	ssl_certfile: ./ssl/server.pem
	ssl_enable: true
	ssl_keyfile: ./ssl/privkey.pem
	ssl_verifypeer: false
	syslog_ident: krb5_rest

Security Configuration
----------------------
This section is still a little thin, hehe.

Creation of principals can be controlled using the file "principal-names-rules.txt" file in the top-level directory (or whatever file is specified in config.yaml under the 'princnames_rules' key). 

Each line in the file is compiled into a regular expression and compared to the principal name for any incoming creation-request; if no lines in the file match the requested name, the request will be rejected.

If this file does not exist a new one will be created with a single rule, ".*", effectively permitting everything. To be clear: _the default behavior is to permit everything_.

If, instead, the file exists but is empty (e.g. created by using the 'touch' command in the shell), no requests will be matched, and all will be denied.

Startup
-------
Just run the "krb5-rest" executable, e.g.:

	./krb5-rest

Security
========

Authorization
-------------
None per-user (since there is no authentication).
Rules may be specified around what principals may be created, using the 'principal-names-rules.txt' file.

Authentication
--------------
None.

Replay Attacks
--------------
Each host (regardless of the number of service principals associated with it) can have exactly one keytab, and that keytab can be downloaded exactly one time.

Secrecy
-------
Sinatra supports SSL (through Thin), and it's enabled by default in Krb5-REST. Client-cert verification is disabled, since that would require acquiring a cryptographic identity that would likely obviate the need for this tool to begin with.

Malformed Queries
-----------------
All write-operations require a JSON body specifying the relevant arguments. This JSON is validated against a specfile to ensure it is well-formed.

Miscellaneous
-------------
I plan to add features to:

*   prevent keytabs from being re-created
*   disable the principal-deletion feature by default
