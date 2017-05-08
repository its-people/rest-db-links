ALTER SESSION SET TIME_ZONE = 'MST';

connect restdblinksProv/restdblinks;

truncate table STockTicker;

-- Insert 10,000 rows

insert into StockTicker ( symbol, tstamp, price)
select symbol, tstamp, startPrice + rn * Dev price
from ( select 'ORCL' symbol
            , 35 startPrice
            , 1/4 Dev
         from dual
       union all
       select 'TDC' symbol
            , 24 startPrice
            , -1/8 Dev
         from dual
     ) smbls
  , ( select rownum -1 rn
           , (trunc(sysdate, 'hh') + 1 + rownum/(24*60))-1/(24*60) tstamp
        from dual
      connect by rownum <= 5000
    ) timestream
/

commit
/

exit


/* cleanup
drop database link restdblinks_prov;
drop table st_perf_dbl        purge;
drop table st_perf_rest_25    purge;
drop table st_perf_rest_100   purge;
drop table st_perf_rest_500   purge;
drop table st_perf_rest_1000  purge;
drop table st_perf_rest_5000  purge;
drop table st_perf_rest_10000 purge;
drop table st_perf_rest_15000 purge;


*/

create database link restdblinks_prov
  connect to restdblinksprov identified by restdblinks
  using '//192.168.56.101/orcl';


set timing on
set feedback on
create table st_perf_dbl
  as select * from stockticker@restdblinks_prov;

create table st_perf_rest_25
as
select symbol
     , to_number(price, '999999999999D99999999','nls_numeric_characters=''.,''' )  price
     , to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') tstamp_json
     , cast( to_timestamp_tz(to_char(to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'), 'YYYY-MM-DD HH24:MI:SS "UTC"'), 'YYYY-MM-DD HH24:MI:SS TZR')
             at time zone sessiontimezone as date ) tstamp
  from table(http_rest_response('http://192.168.56.101:8080/ords/restdblinksprov/tab-StockTicker/')) t
     , json_table(t.response, '$.items[*]'
                   columns ( symbol  varchar2 path '$.symbol'
                           , tstamp  varchar2 path '$.tstamp'
                           , price   varchar2 path '$.price'
                           , selfurl varchar2 path '$.links[0].href'
                           )
                 ) j
/

create table st_perf_rest_100
as
select symbol
     , to_number(price, '999999999999D99999999','nls_numeric_characters=''.,''' )  price
     , to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') tstamp_json
     , cast( to_timestamp_tz(to_char(to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'), 'YYYY-MM-DD HH24:MI:SS "UTC"'), 'YYYY-MM-DD HH24:MI:SS TZR')
             at time zone sessiontimezone as date ) tstamp
  from table(http_rest_response('http://192.168.56.101:8080/ords/restdblinksprov/tab-StockTicker/?limit=100')) t
     , json_table(t.response, '$.items[*]'
                   columns ( symbol  varchar2 path '$.symbol'
                           , tstamp  varchar2 path '$.tstamp'
                           , price   varchar2 path '$.price'
                           , selfurl varchar2 path '$.links[0].href'
                           )
                 ) j
/

create table st_perf_rest_500
as
select symbol
     , to_number(price, '999999999999D99999999','nls_numeric_characters=''.,''' )  price
     , to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') tstamp_json
     , cast( to_timestamp_tz(to_char(to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'), 'YYYY-MM-DD HH24:MI:SS "UTC"'), 'YYYY-MM-DD HH24:MI:SS TZR')
             at time zone sessiontimezone as date ) tstamp
  from table(http_rest_response('http://192.168.56.101:8080/ords/restdblinksprov/tab-StockTicker/?limit=500')) t
     , json_table(t.response, '$.items[*]'
                   columns ( symbol  varchar2 path '$.symbol'
                           , tstamp  varchar2 path '$.tstamp'
                           , price   varchar2 path '$.price'
                           , selfurl varchar2 path '$.links[0].href'
                           )
                 ) j
/

create table st_perf_rest_1000
as
select symbol
     , to_number(price, '999999999999D99999999','nls_numeric_characters=''.,''' )  price
     , to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') tstamp_json
     , cast( to_timestamp_tz(to_char(to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'), 'YYYY-MM-DD HH24:MI:SS "UTC"'), 'YYYY-MM-DD HH24:MI:SS TZR')
             at time zone sessiontimezone as date ) tstamp
  from table(http_rest_response('http://192.168.56.101:8080/ords/restdblinksprov/tab-StockTicker/?limit=1000')) t
     , json_table(t.response, '$.items[*]'
                   columns ( symbol  varchar2 path '$.symbol'
                           , tstamp  varchar2 path '$.tstamp'
                           , price   varchar2 path '$.price'
                           , selfurl varchar2 path '$.links[0].href'
                           )
                 ) j
/

create table st_perf_rest_5000
as
select symbol
     , to_number(price, '999999999999D99999999','nls_numeric_characters=''.,''' )  price
     , to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') tstamp_json
     , cast( to_timestamp_tz(to_char(to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'), 'YYYY-MM-DD HH24:MI:SS "UTC"'), 'YYYY-MM-DD HH24:MI:SS TZR')
             at time zone sessiontimezone as date ) tstamp
  from table(http_rest_response('http://192.168.56.101:8080/ords/restdblinksprov/tab-StockTicker/?limit=5000')) t
     , json_table(t.response, '$.items[*]'
                   columns ( symbol  varchar2 path '$.symbol'
                           , tstamp  varchar2 path '$.tstamp'
                           , price   varchar2 path '$.price'
                           , selfurl varchar2 path '$.links[0].href'
                           )
                 ) j
/

create table st_perf_rest_10000
as
select symbol
     , to_number(price, '999999999999D99999999','nls_numeric_characters=''.,''' )  price
     , to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') tstamp_json
     , cast( to_timestamp_tz(to_char(to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'), 'YYYY-MM-DD HH24:MI:SS "UTC"'), 'YYYY-MM-DD HH24:MI:SS TZR')
             at time zone sessiontimezone as date ) tstamp
  from table(http_rest_response('http://192.168.56.101:8080/ords/restdblinksprov/tab-StockTicker/?limit=10000')) t
     , json_table(t.response, '$.items[*]'
                   columns ( symbol  varchar2 path '$.symbol'
                           , tstamp  varchar2 path '$.tstamp'
                           , price   varchar2 path '$.price'
                           , selfurl varchar2 path '$.links[0].href'
                           )
                 ) j
/

create table st_perf_rest_15000
as
select symbol
     , to_number(price, '999999999999D99999999','nls_numeric_characters=''.,''' )  price
     , to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') tstamp_json
     , cast( to_timestamp_tz(to_char(to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'), 'YYYY-MM-DD HH24:MI:SS "UTC"'), 'YYYY-MM-DD HH24:MI:SS TZR')
             at time zone sessiontimezone as date ) tstamp
  from table(http_rest_response('http://192.168.56.101:8080/ords/restdblinksprov/tab-StockTicker/?limit=15000')) t
     , json_table(t.response, '$.items[*]'
                   columns ( symbol  varchar2 path '$.symbol'
                           , tstamp  varchar2 path '$.tstamp'
                           , price   varchar2 path '$.price'
                           , selfurl varchar2 path '$.links[0].href'
                           )
                 ) j
/


select count(*) cnt_dbl   from st_perf_dbl        union all
select count(*) cnt_25    from st_perf_rest_25    union all
select count(*) cnt_100   from st_perf_rest_100   union all
select count(*) cnt_500   from st_perf_rest_500   union all
select count(*) cnt_1000  from st_perf_rest_1000  union all
select count(*) cnt_5000  from st_perf_rest_5000  union all
select count(*) cnt_10000 from st_perf_rest_10000 union all
select count(*) cnt_15000 from st_perf_rest_15000;


/*
ST_PERF_DBL       0.096
ST_PERF_REST_25   113.902
ST_PERF_REST_100   36.742
ST_PERF_REST_500   13.980
ST_PERF_REST_1000   13.781
ST_PERF_REST_5000   13.899
*/
