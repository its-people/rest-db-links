set define off
create or replace trigger StockTicker_ORDS_IUD
instead of insert or update or delete on StockTicker_ORDS
for each row
declare
  c_content_type constant varchar2(256) := 'application/json';
  l_response_body clob;
  l_json_content varchar2(32767);
begin
  l_json_content := ' { "symbol": "'||:new.symbol||'"'
                   ||', "tstamp": "'||to_char( cast (cast (:new.tstamp AS TIMESTAMP WITH TIME ZONE) at time zone 'UTC' as date) 
                                             , 'YYYY-MM-DD"T"HH24:MI:SS"Z"')||'"'
                   ||', "price": "' ||to_char(:new.price, '999999999999D99999999','nls_numeric_characters=''.,''' )||'"'
                   ||'}'
                   ;
  if deleting 
    then
      lg('Deleting from view StockTicker_ORDS');
      l_response_body := rest_db_links.http_rest_request
                           ( :old.selfurl
                           , 'DELETE'
                           , '{}'
                           , c_content_type );
      lg('Delete from view StockTicker_ORDS responded: '||l_response_body);
  end if;
  if updating
    then
      lg('Updating view StockTicker_ORDS. json_content: '||l_json_content);
      l_response_body := rest_db_links.http_rest_request
                           ( :old.selfurl
                           , 'PUT'
                           , l_json_content
                           , c_content_type );
      lg('Update view StockTicker_ORDS responded: '||l_response_body);
  end if;
  if inserting then
      lg('Inserting into view StockTicker_ORDS. json_content: '||l_json_content);
      l_response_body := rest_db_links.http_rest_request
                           ( 'http://192.168.56.101:8080/ords/rmougprov/tab-StockTicker/'
                            ||:new.symbol
                            ||','||to_char( cast (cast (:new.tstamp AS TIMESTAMP WITH TIME ZONE) at time zone 'UTC' as date) 
                                             , 'YYYY-MM-DD"T"HH24:MI:SS"Z"')
                           , 'PUT'
                           , l_json_content
                           , c_content_type);
      lg('Insert view StockTicker_ORDS responded: '||l_response_body);
  end if;
end;
/
show errors

exit

select count(*)
  from StockTicker_ORDS
;

delete
  from StockTicker_ORDS
where 
      rownum < 11
;

commit;

select symbol, count(*)
  from StockTicker_ORDS
  group by grouping sets ((symbol),())
;

truncate table logtab;

select * from logtab
order by tstmp desc;

insert into StockTicker_ORDS (symbol, price, tstamp)
values ('RMOUG', 500, sysdate);

commit;

select * from STOCKTICKER_ORDS;

update STOCKTICKER_ORDS
   set price = 5000
 where symbol ='RMOUG'
;