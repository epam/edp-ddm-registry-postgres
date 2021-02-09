--liquibase formatted sql
--changeset platform:add-workers-master splitStatements:false context:"pub"
--validCheckSum: ANY
do
$$
declare
    i RECORD;
begin
for i in 
       select substring(replace(unnest, 'jdbc:postgresql://', '') from '(.*)\:') host
              ,substring(replace(unnest, 'jdbc:postgresql://', '') from '\:(.*)') port
       from unnest(string_to_array('${masterWorkers}', ' ')) loop
              perform master_add_node(i.host, i.port::int4);
       end loop;
end;
$$ language plpgsql;


--changeset platform:add-workers-replica splitStatements:false context:"sub"
--validCheckSum: ANY
do
$$
declare
    i RECORD;
begin
for i in 
       select substring(replace(unnest, 'jdbc:postgresql://', '') from '(.*)\:') host
              ,substring(replace(unnest, 'jdbc:postgresql://', '') from '\:(.*)') port
       from unnest(string_to_array('${replicaWorkers}', ' ')) loop
              perform master_add_node(i.host, i.port::int4);
       end loop;
end;
$$ language plpgsql;