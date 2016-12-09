
connect restdblinksProv/restdblinks;

BEGIN
    ORDS.ENABLE_SCHEMA(p_enabled => FALSE);
    ORDS.drop_rest_for_schema();
    commit;
END;
/

commit;

connect sys/oracle as sysdba


drop user restdblinksProv cascade;
drop user restdblinksCons cascade;

-- Provider ( Data Source )
grant connect, resource, unlimited tablespace to restdblinksProv identified by restdblinks;

-- Consumer ( Origin of the link )
grant connect
    , resource
    , unlimited tablespace
    , create view
    , create database link
    to restdblinksCons identified by restdblinks;

select id, parsing_schema from all_ords_schemas;


