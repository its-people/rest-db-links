drop table StockTicker purge;

create table StockTicker
  ( symbol    varchar2(20)  not null
  , id1        number        not null
  , tstamp    date          not null
  , price     number
  , constraint pk_StockTicker primary key (id1)
  )
/


ALTER SESSION SET TIME_ZONE = 'CET';


insert into StockTicker ( symbol, id1,tstamp, price)
select symbol, rownum, tstamp, startPrice + rn * Dev price
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
           , (trunc(sysdate, 'hh') + rownum/(24*60))-1/(24*60) tstamp
        from dual
      connect by rownum < 62
    ) timestream
/

commit
/

select symbol
     , count(*) cnt
     , to_char(min(tstamp), 'HH24:MI') strt, to_char(max(tstamp), 'HH24:MI') stop
     , min(price), max(price)
  from StockTicker
 group by symbol
;



grant select on StockTicker to restdblinkscons;
