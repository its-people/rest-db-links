/*

ORA-29273: HTTP request failed
ORA-24247: network access denied by access control list (ACL)

*/

-- Execute as dba
grant execute on utl_http to rmougCons;
grant execute on dbms_lock to rmougCons;

BEGIN
  DBMS_NETWORK_ACL_ADMIN.drop_acl (
    acl          => 'local_rest_acl_file.xml'  );
end;
/



BEGIN
  DBMS_NETWORK_ACL_ADMIN.create_acl (
    acl          => 'local_rest_acl_file.xml',
    description  => 'Grant Access to REST Services on Host 192.168.56.101',
    principal    => 'RMOUGCONS',
    is_grant     => TRUE,
    privilege    => 'connect',
    start_date   => SYSTIMESTAMP,
    end_date     => NULL);
end;
/

begin
  DBMS_NETWORK_ACL_ADMIN.assign_acl (
    acl         => 'local_rest_acl_file.xml',
    host        => '192.168.56.101',
    lower_port  => 8080,
    upper_port  => NULL);
end;
/

commit;
