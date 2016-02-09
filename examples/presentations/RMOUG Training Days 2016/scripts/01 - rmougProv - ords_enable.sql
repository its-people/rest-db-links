begin
  ords.enable_schema;
  commit;  -- This commit is important!
end;
/


select * from user_ords_schemas;

select owner
     , view_name
  from all_views
 where view_name like 'USER_ORDS_%'
;

select *
  from user_ords_enabled_objects;

begin
  ords.enable_object (
    P_ENABLED        => true,
    P_SCHEMA         => 'RMOUGPROV',
    P_OBJECT         => 'STOCKTICKER',
    P_OBJECT_TYPE    => 'TABLE',
    P_OBJECT_ALIAS   => 'tab-StockTicker',
    P_AUTO_REST_AUTH => false
  );
  commit;  -- This commit is important, too!
end;
/

  
select *
  from user_ords_enabled_objects;
  

