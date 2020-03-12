# Secure Gateway for SSH logging

This project is for deploying secured, logging, ssh Gateway.
You can limit accesses based on predefined rules, modify ssh commands on the fly, and with a script command record whole session, which can be reversely replayed like a video, or can be accessed as a text for simplified searching. Current implementation is grabbing ssh keys from LDAP, with a modification of `get_ldap_sshkeys.sh` you can download keys from any provider.


## Level of access separation
Broker scrip is deciding to let user pass based on 3 rules which are defined in authorized_keys file.

```
$SSH_KEY_GROUP - authenticated ssh keys from ldap_group
$TUSER	- remote server user
$TSERVER	- remote server
```
$SSH_KEY_GROUP - group of people getting access to defined group of server  
$TUSER - access can be granted also on user level  
$TSERVER - or on exact server  
