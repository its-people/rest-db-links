/*
Use from sqlcl.
It utilizes JS Scripts.

Parameter:
1: View Name
2: ORDS Metadata URL
3: opional: Parameter for URL
*/

  script ../generator/generator v_stock http://127.0.0.1:8080/ords/rdbl/metadata-catalog/Tab-StockTicker/ ?limit=5
