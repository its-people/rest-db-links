BEGIN
    ORDS.ENABLE_SCHEMA(p_enabled => TRUE,
                       p_schema => 'RESTDBLINKSPROV',
                       p_url_mapping_type => 'BASE_PATH',
                       p_url_mapping_pattern => 'rdbl',
                       p_auto_rest_auth => false);
    commit;  -- This commit is important!
END;
/


select * from user_ords_schemas;

select owner
     , view_name
  from all_views
 where view_name like 'USER_ORDS_%'
;

select *
  from user_ords_enabled_objects;

BEGIN
    ORDS.ENABLE_OBJECT(p_enabled => TRUE,
                       p_schema => 'RESTDBLINKSPROV',
                       p_object => 'STOCKTICKER',
                       p_object_type => 'TABLE',
                       p_object_alias => 'Tab-StockTicker',
                       p_auto_rest_auth => FALSE);
    commit;   -- This commit is important, too!
END;
/


select *
  from user_ords_enabled_objects;


