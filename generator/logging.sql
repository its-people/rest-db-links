drop table logtab purge; 

create table logtab( tstmp timestamp default localtimestamp
                   , msg   varchar2(4000)
                   );
                   
                   
create or replace procedure lg(p_msg in varchar2)
is
  pragma autonomous_transaction;
begin
  insert into logtab(msg) values (p_msg);
  commit;
exception
  when others then null;  
end;
/
show errors

