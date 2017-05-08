alter session set nls_numeric_characters=',.';
alter session set nls_numeric_characters='.,';
ALTER SESSION SET TIME_ZONE = 'EST';

select j.*
     , t.*
  from table(rest_db_links.http_rest_response('http://127.0.0.1:8080/ords/rdbl/Tab-StockTicker/')) t
     , json_table(t.response, '$.items[*]'
                   columns ( symbol  varchar2 path '$.symbol'
                           , tstamp  varchar2 path '$.tstamp'
                           , price   number path '$.price'
                           , selfurl varchar2 path '$.links[0].href'
                           )
                 ) j
  ;

select sysdate from dual;

select symbol
     , to_number(id1) id1
     , to_number(price, '999999999999D99999999','nls_numeric_characters=''.,''' )  price
     , to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') tstamp_json
     , cast( to_timestamp_tz(to_char(to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'), 'YYYY-MM-DD HH24:MI:SS "UTC"'), 'YYYY-MM-DD HH24:MI:SS TZR')
             at time zone sessiontimezone as date ) tstamp
     , selfurl
  from table(rest_db_links.http_rest_response('http://127.0.0.1:8080/ords/rdbl/Tab-StockTicker/')) t
     , json_table(t.response, '$.items[*]'
                   columns ( symbol  varchar2 path '$.symbol'
                           , id1     varchar2 path '$.id1'
                           , tstamp  varchar2 path '$.tstamp'
                           , price   varchar2 path '$.price'
                           , selfurl varchar2 path '$.links[0].href'
                           )
                 ) j
  ;




create or replace view StockTicker_ORDS
as
select symbol
     , to_number(id1) id1
     , to_number(price, '999999999999D99999999','nls_numeric_characters=''.,''' )  price
     , to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') tstamp_json
     , cast( to_timestamp_tz(to_char(to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'), 'YYYY-MM-DD HH24:MI:SS "UTC"'), 'YYYY-MM-DD HH24:MI:SS TZR')
             at time zone sessiontimezone as date ) tstamp
     , selfurl
  from table(rest_db_links.http_rest_response('http://127.0.0.1:8080/ords/rdbl/Tab-StockTicker/')) t
     , json_table(t.response, '$.items[*]'
                   columns ( symbol  varchar2 path '$.symbol'
                           , id1     varchar2 path '$.id1'
                           , tstamp  varchar2 path '$.tstamp'
                           , price   varchar2 path '$.price'
                           , selfurl varchar2 path '$.links[0].href'
                           )
                 ) j
  ;


select symbol, id1,tstamp, price
  from StockTicker_ORDS
;

select symbol, id1,tstamp, price
  from restdblinksprov.StockTicker;


select symbol, id1, tstamp, price
  from StockTicker_ORDS
minus
select symbol, id1, tstamp, price
  from restdblinksprov.StockTicker;

select symbol, id1,tstamp, price
  from restdblinksprov.StockTicker
minus
select symbol, id1,tstamp, price
  from StockTicker_ORDS
;




