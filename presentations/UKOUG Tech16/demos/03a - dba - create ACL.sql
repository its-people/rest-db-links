/*

ORA-29273: HTTP request failed
ORA-24247: network access denied by access control list (ACL)

*/

-- Execute as dba
grant execute on utl_http to restdblinksCons;
grant execute on dbms_lock to restdblinksCons;

BEGIN
  DBMS_NETWORK_ACL_ADMIN.drop_acl (
    acl          => 'local_rest_acl_file.xml'  );
end;
/



BEGIN
  DBMS_NETWORK_ACL_ADMIN.create_acl (
    acl          => 'local_rest_acl_file.xml',
    description  => 'Grant Access to REST Services on Host 127.0.0.1',
    principal    => upper('restdblinksCONS'),
    is_grant     => TRUE,
    privilege    => 'connect',
    start_date   => SYSTIMESTAMP,
    end_date     => NULL);
end;
/

begin
  DBMS_NETWORK_ACL_ADMIN.assign_acl (
    acl         => 'local_rest_acl_file.xml',
    host        => '127.0.0.1',
    lower_port  => 8080,
    upper_port  => NULL);
end;
/

commit;
