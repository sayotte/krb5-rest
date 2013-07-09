krb5-rest
=========

Sinatra-based REST server for managing Kerberos principals and keytabs.

Overview
========
This tool was developed to solve the problem of hosts powering-on in a datacenter and acquiring an identity, without a priori knowledge of their arrival or hostname. As part of their imaging process, they should be able to create a principal for themselves and obtain a keytab containing the secrets associated with that principal, all without having user-level access to the KDC.

Security
========

Authorization
-------------
None.


Authentication
--------------
None.

Replay Attacks
--------------
Each host (regardless of the number of service principals associated with it) can have exactly one keytab, and that keytab can be downloaded exactly one time.

Secrecy
-------
Sinatra supports SSL (through Thin), and it's enabled by default in Krb5-REST. Client-cert verification is disabled, since that would require acquiring a cryptographic identity that would likely obviate the need for this tool to begin with.

Miscellaneous
-------------
I plan to add features to:
*   restrict the set of principals that can be created
*   prevent keytabs from being re-created
*   disable the principal-deletion feature by default

API
===

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

