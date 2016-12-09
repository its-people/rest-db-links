@logging.sql
@rest_db_links.pks
@rest_db_links.pkb

exit

select *
  from table( rest_db_links.http_rest_response
              ( 'http://127.0.0.1:8080/ords/rdbl/Tab-StockTicker/?limit=50')
            ) t;



select  j.*, t.*
  from table(rest_db_links.http_rest_response('http://127.0.0.1:8080/ords/rdbl/Tab-StockTicker/?limit=50')) t
     , json_table ( response, '$'
                    columns ( hasMore varchar2  path '$.hasMore'
                            , nested path '$.links[*]'
                              columns ( rel varchar2 path '$.rel'
                                      , href varchar2 path '$.href'
                                      )
                            )
                  ) j
where t.id=1
--  and hasmore='true'
--  and rel='next'
  ;

