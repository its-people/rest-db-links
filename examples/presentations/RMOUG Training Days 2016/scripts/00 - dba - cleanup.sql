
connect rmougProv/rmoug;

begin
  ords.drop_rest_for_schema('RMOUGPROV');
end;
/

commit;

connect sys/oracle as sysdba


drop user rmougProv cascade;
drop user rmougCons cascade;    

-- Provider ( Data Source )
grant connect, resource, unlimited tablespace to rmougProv identified by rmoug;

-- Consumer ( Origin of the link )
grant connect
    , resource
    , unlimited tablespace 
    , create view
    , create database link
    to rmougCons identified by rmoug;

select id, parsing_schema from all_ords_schemas;


