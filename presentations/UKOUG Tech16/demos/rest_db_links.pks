create or replace package rest_db_links
as
  type http_rest_response_row
    is record
    ( id           NUMBER
    , url          VARCHAR2(4000)
    , response     clob
    );

  type http_rest_response_tab
    is table of http_rest_response_row;

  function http_rest_request ( p_url          varchar2
                             , p_req_method   varchar2 default 'GET'
                             , p_req_body     varchar2 default null
                             , p_req_ctype    varchar2 default null
                             )
    return clob;

  function http_rest_response (p_url  in  varchar2)
    return http_rest_response_tab pipelined;
end rest_db_links;
/

show errors
