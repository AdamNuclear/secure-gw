#!/bin/bash
binder_pass="{{ ldap_binder_password }}"
ldap_groups=({{ ldap_group_access | default("ldap_devops") }})

#Go trough groups and get members Uid
for GROUP in  "${ldap_groups[@]}"
do
#Get uid of member in group
  for GROUP_MEMBER in $(/usr/bin/ldapsearch -LLL -H ldap_url -x -D "cn=foo,dc=foo,dc=foo" -w $binder_pass -b 'cn=foo,dc=foo,dc=foo' "(&(objectClass=posixGroup)(cn=$GROUP))" "memberUid" | grep -v dn| awk {'print $2'})
  do
     #Get SSH_KEY from each user
     SSH_KEY=$(/usr/bin/ldapsearch -LLL -H ldaps://ldap.skypicker.com:636 -x -D "cn=foo,dc=foo,dc=foo" -w $binder_pass -b 'cn=foo,dc=foo,dc=foo' "uid=$GROUP_MEMBER" "sshPublicKey" | grep -v dn | sed -e 's/sshPublicKey://g' | sed ':a;N;$!ba;s/\n //g')
     #There where is ssh_key in ldap set enviroment
     if [ ! -z "$SSH_KEY" ]; then
      #Add default environment variables and force broker command
      SSH_KEY_CONFIG="environment=\"SSH_KEY_OWNER=$GROUP_MEMBER\",environment=\"SSH_KEY_GROUP=$GROUP\",command=\"/bin/broker\" $SSH_KEY"
      echo $SSH_KEY_CONFIG
     fi
  done
done
