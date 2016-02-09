/* 
Use from sqlcl. 
It utilizes JS Scripts.

Parameter:
1: View Name
2: ORDS Metadata URL
3: opional: Parameter for URL
*/

script ../generator/generator v_stock http://192.168.56.101:8080/ords/rmougprov/metadata-catalog/tab-StockTicker/ ?limit=5 
