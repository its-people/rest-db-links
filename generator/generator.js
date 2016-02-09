/*
create or replace view StockTicker_ORDS
as
select symbol
     , to_number(price, '999999999999D99999999','nls_numeric_characters=''.,''' )  price
     , to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') tstamp_json
     , cast( to_timestamp_tz(to_char(to_date(tstamp, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'), 'YYYY-MM-DD HH24:MI:SS "UTC"'), 'YYYY-MM-DD HH24:MI:SS TZR')
             at time zone sessiontimezone as date ) tstamp
     , selfurl
  from table(http_rest_response('http://192.168.56.101:8080/ords/rmougprov/tab-StockTicker/')) t
     , json_table(t.response, '$.items[*]'
                   columns ( symbol  varchar2 path '$.symbol'
                           , tstamp  varchar2 path '$.tstamp'
                           , price   varchar2 path '$.price'
                           , selfurl varchar2 path '$.links[0].href'
                           )
                 ) j
  ;

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
*/


template="set define off"+"\n"
+"create or replace view %VIEWNAME%"+"\n"
+"as"+"\n"
+"select %VIEWCOLS%selfurl"+"\n"
+"  from table(http_rest_response('%RESTURL%%QPARAMS%')) t"+"\n"
+"     , json_table(t.response, '$.items[*]'"+"\n"
+"                   columns ( %JSONCOLS%selfurl varchar2 path '$.links[0].href'"+"\n"
+"                           )"+"\n"
+"                 ) j"+"\n"
+"/"+"\n"
+"show errors"+"\n"
+""+"\n"
+"create or replace trigger %VIEWNAME%_IUD"+"\n"
+"instead of insert or update or delete on %VIEWNAME%"+"\n"
+"for each row"+"\n"
+"declare"+"\n"
+"  c_content_type constant varchar2(256) := 'application/json';"+"\n"
+"  l_response_body clob;"+"\n"
+"  l_json_content varchar2(32767);"+"\n"
+"begin"+"\n"
+"  l_json_content := %TRIGGERCOLJSON%"+"\n"
+"  if deleting "+"\n"
+"    then"+"\n"
+"      lg('Deleting from view %VIEWNAME%');"+"\n"
+"      l_response_body := rest_db_links.http_rest_request"+"\n"
+"                           ( :old.selfurl"+"\n"
+"                           , 'DELETE'"+"\n"
+"                           , '{}'"+"\n"
+"                           , c_content_type );"+"\n"
+"      lg('Delete from view %VIEWNAME% responded: '||l_response_body);"+"\n"
+"  end if;"+"\n"
+"  if updating"+"\n"
+"    then"+"\n"
+"      lg('Updating view %VIEWNAME%. json_content: '||l_json_content);"+"\n"
+"      l_response_body := rest_db_links.http_rest_request"+"\n"
+"                           ( :old.selfurl"+"\n"
+"                           , 'PUT'"+"\n"
+"                           , l_json_content"+"\n"
+"                           , c_content_type );"+"\n"
+"      lg('Update view %VIEWNAME% responded: '||l_response_body);"+"\n"
+"  end if;"+"\n"
+"  if inserting then"+"\n"
+"      lg('Inserting into view %VIEWNAME%. json_content: '||l_json_content);"+"\n"
+"      l_response_body := rest_db_links.http_rest_request"+"\n"
+"                           ( '%RESTURL%%URLPK%"+"\n"
+"                           , 'PUT'"+"\n"
+"                           , l_json_content"+"\n"
+"                           , c_content_type);"+"\n"
+"      lg('Insert view %VIEWNAME% responded: '||l_response_body);"+"\n"
+"  end if;"+"\n"
+"end;"+"\n"
+"/"+"\n"
+"show errors"+"\n";

function enhanceCol(name, type, loc)
{ var ret = "";
  switch(type)
  {
  	case "NUMBER":
  		if (loc =="View")
  		{ ret = "to_number("+name+", '999999999999D99999999','nls_numeric_characters=''.,''' )  " +name;
   		} else { ret = "to_char("+name+", '999999999999D99999999','nls_numeric_characters=''.,''' )";
   		       }
   		break;
  	case "DATE":
  		if (loc =="View")
  		{ ret = "cast( to_timestamp_tz( to_char( to_date("+name+", 'YYYY-MM-DD\"T\"HH24:MI:SS\"Z\"')\n"
  			  +"                              , 'YYYY-MM-DD HH24:MI:SS \"UTC\"')\n"
              +"                      , 'YYYY-MM-DD HH24:MI:SS TZR')\n"
              +"       at time zone sessiontimezone as date )  " +name;
   		} else 
   			{ ret = "to_char( cast (cast ( "+name+" AS TIMESTAMP WITH TIME ZONE)\n" 
   			    	+ "                    at time zone 'UTC' as date)\n" 
                    + "       , 'YYYY-MM-DD\"T\"HH24:MI:SS\"Z\"')";
   		    };
   		break;
   	default:
   	   ret = name	       
  }
  return ret;
}


ctx.write("/* Debug Info: \n");

for(var arg in args) {
   ctx.write(arg + ":" + args[arg]);
   ctx.write("\n");
}

viewname=args[1];
metaurl=args[2];
qparams=args[3];

res=util.executeReturnList("select to_char(rest_db_links.http_rest_request('"+metaurl+"')) c from dual",null);

ctx.write(res[0].C+"\n");
ctx.write("\n");

var obj=JSON.parse(res[0].C);
ctx.write("generating view and trigger for table: "+obj.name+"\n");
var resturl="";

/* Looping through links in search of resturl */
for (var i=0;i<obj.links.length;i++)
{ 
 	if (obj.links[i].rel=="describes")
  	{
  		resturl=obj.links[i].href
  	}
}

/* Looping through members (the columns)  */
var cols=obj.members;
var pk=obj.primarykey;
var viewcols = "";
var jsoncols = "";
var urlpk = "";
var triggercoljson = "'{ ";
var sep =""
for (var i=0;i<cols.length;i++)
{ 
	ctx.write(cols[i].name+" "+cols[i].type+"\n");
    viewcols = viewcols + enhanceCol(cols[i].name,cols[i].type, "View") +"\n     , ";
    jsoncols = jsoncols + cols[i].name +" varchar2 path '$."+cols[i].name+"'\n                           , ";
    triggercoljson=triggercoljson+sep+'"'+cols[i].name
                    +'": "\'||'
                    +enhanceCol(':new.'+cols[i].name,cols[i].type, "Trig")
                    +"||'\"'";
    sep="\n          ||', ";
    for (j=0;j<pk.length;j++)
	{
		if (pk[j]==cols[i].name)
			{ pk[j]=enhanceCol(":new."+cols[i].name,cols[i].type,"Trig");}
	}
}
triggercoljson=triggercoljson+"||' }';";
sep="'\n                           ||";
for (j=0;j<pk.length;j++)
{ urlpk = urlpk + sep +pk[j];
  sep = "\n                           ||','||";	
}

ctx.write("viewname: "+viewname+"\n");
ctx.write("resturl:  "+resturl+"\n");
ctx.write("viewcols: "+viewcols+"\n");
ctx.write("jsoncols: "+jsoncols+"\n");
ctx.write("triggercoljson: "+triggercoljson+"\n");
ctx.write("urlpk: "+urlpk+"\n");

dml=template;
dml=dml.replace(/%VIEWNAME%/g, viewname);
dml=dml.replace(/%RESTURL%/g,  resturl);
dml=dml.replace(/%QPARAMS%/g,  qparams);
dml=dml.replace(/%VIEWCOLS%/g, viewcols);
dml=dml.replace(/%JSONCOLS%/g, jsoncols);
dml=dml.replace(/%TRIGGERCOLJSON%/g, triggercoljson);
dml=dml.replace(/%URLPK%/g, urlpk);


ctx.write("end debug */\n");
ctx.write(dml+"\n");

ctx.write("\n");

exit
