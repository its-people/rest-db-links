select *
  from StockTicker
order by tstamp, symbol
/


select symbol, count(*)
  from StockTicker
 group by symbol
/ 

