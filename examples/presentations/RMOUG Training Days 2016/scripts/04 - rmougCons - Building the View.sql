alter session set nls_numeric_characters=',.';
alter session set nls_numeric_characters='.,';

select j.*
     , t.*
  from table(rest_db_links.http_rest_response('http://192.168.56.101:8080/ords/rmougprov/tab-StockTicker/')) t
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
     , to_number(price, '999999999999D99999999','nls_numeric_characters=''.,''' )  price
     , to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') tstamp_json
     , cast( to_timestamp_tz(to_char(to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'), 'YYYY-MM-DD HH24:MI:SS "UTC"'), 'YYYY-MM-DD HH24:MI:SS TZR')
             at time zone sessiontimezone as date ) tstamp
     , selfurl
  from table(rest_db_links.http_rest_response('http://192.168.56.101:8080/ords/rmougprov/tab-StockTicker/')) t
     , json_table(t.response, '$.items[*]'
                   columns ( symbol  varchar2 path '$.symbol'
                           , tstamp  varchar2 path '$.tstamp'
                           , price   varchar2 path '$.price'
                           , selfurl varchar2 path '$.links[0].href'
                           )
                 ) j
  ;



ALTER SESSION SET TIME_ZONE = 'MST';

create or replace view StockTicker_ORDS
as
select symbol
     , to_number(price, '999999999999D99999999','nls_numeric_characters=''.,''' )  price
     , to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') tstamp_json
     , cast( to_timestamp_tz(to_char(to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'), 'YYYY-MM-DD HH24:MI:SS "UTC"'), 'YYYY-MM-DD HH24:MI:SS TZR')
             at time zone sessiontimezone as date ) tstamp
     , selfurl
  from table(rest_db_links.http_rest_response('http://192.168.56.101:8080/ords/rmougprov/tab-StockTicker/')) t
     , json_table(t.response, '$.items[*]'
                   columns ( symbol  varchar2 path '$.symbol'
                           , tstamp  varchar2 path '$.tstamp'
                           , price   varchar2 path '$.price'
                           , selfurl varchar2 path '$.links[0].href'
                           )
                 ) j
  ;


select symbol, tstamp, price
  from StockTicker_ORDS
;

select symbol, tstamp, price
  from rmougprov.StockTicker;


select symbol, tstamp, price
  from StockTicker_ORDS
minus
select symbol, tstamp, price
  from rmougprov.StockTicker;

select symbol, tstamp, price
  from rmougprov.StockTicker
minus
select symbol, tstamp, price
  from StockTicker_ORDS
;




