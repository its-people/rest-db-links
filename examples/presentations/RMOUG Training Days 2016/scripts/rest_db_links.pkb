create or replace package body rest_db_links
as
  function http_rest_request ( p_url          varchar2
                             , p_req_method   varchar2 default 'GET'
                             , p_req_body     varchar2 default null
                             , p_req_ctype    varchar2 default null
                             )
    return clob
  as
    l_http_request   UTL_HTTP.req;
    l_http_response  UTL_HTTP.resp;
    l_text           varchar2(32767);
    l_clob           clob;
  begin
    lg('p_req_method: '||p_req_method||' URL: '||p_url||' p_req_body: '||nvl(p_req_body, '**NULL**'));
    -- prepare request
    l_http_request := utl_http.begin_request (url=> p_url, method => p_req_method);
    if p_req_ctype is not null
      then    
        utl_http.set_header ( r      =>  l_http_request
                            , name   =>  'Content-Type'
                            , value  =>  p_req_ctype);
    end if;
    if p_req_body is not null
      then     
        utl_http.set_header ( r      =>   l_http_request
                            , name   =>   'Content-Length'
                            , value  =>   length(p_req_body));
        utl_http.write_text ( r      =>   l_http_request
                            , data   =>   p_req_body);
    end if;
    -- execute request    
    l_http_response := utl_http.get_response(l_http_request);
    -- Initialize the CLOB.
    DBMS_LOB.createtemporary(l_clob, false);
    -- Copy the response into the CLOB.
    begin
      loop
        UTL_HTTP.read_text(l_http_response, l_text, 32766);
        DBMS_LOB.writeappend (l_clob, length(l_text), l_text);
      end loop;
    exception
      when UTL_HTTP.end_of_body
        then UTL_HTTP.end_response(l_http_response);
    end;

    return l_clob;
  end http_rest_request;

  function http_rest_response (p_url  in  varchar2)
    return http_rest_response_tab pipelined
  as
    l_hasmore        varchar2(  10) := 'true';
    l_row            http_rest_response_row;
  begin
    l_row.id :=0;
    l_row.url := p_url;
    while coalesce(l_hasmore, 'false') = 'true'
    loop
      l_row.id := l_row.id +1;
      -- Piping Row
      l_row.response := http_rest_request(l_row.url);
      pipe row(l_row);
      --
      select hasMore, href
        into l_hasMore
           , l_row.url
        from json_table ( l_row.response, '$'
                          columns ( hasMore varchar2  path '$.hasMore'
                                  , nested path '$.links[*]'
                                    columns ( rel varchar2 path '$.rel'
                                            , href varchar2 path '$.href' )
                                            )
                        ) j
       where hasmore='true'
         and rel='next';
    end loop;
  end http_rest_response;
end rest_db_links;
/
show errors
