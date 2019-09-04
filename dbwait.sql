REM
REM wait event.
REM zongziheng
REM
set linesize 300
set pagesize 5000
col event for a35
col sess for a12
col username for a15
col client for a20
col INST_ID for 99
col module for a30
col OSPID for a20
col logon_time for a20
select a.INST_ID,
       substr(a.event, 1, 25) event,
       substr(b.MODULE, 1, 30) module,
       b.sid || ',' || b.serial# sess,
       decode(sql_hash_value, 0, prev_hash_value, sql_hash_value) sql_hash,
       b.username,
       substr(b.osuser || '@' || b.machine, 1, 40) client,
       c.SPID OSPID,
       to_char(b.logon_time, 'mm-dd hh24:mi') logon_time
  from gv$session_wait a, gv$session b, gv$process c
 where a.sid = b.sid
   and a.INST_ID = b.INST_ID
   and c.ADDR = b.PADDR
   and a.event not like '%SQL%'
   and a.event not like '%message%'
   and a.event not like '%time%'
   and a.event not like 'jobq slave%'
   and a.event not like 'Streams AQ%'
   and a.event not like 'DIAG idle%'
   and a.event not like 'VKTM Logical Idle Wait%'
   and a.event not like 'Space Manager: slave idle%'
   and a.wait_class <> 'Idle'
 order by 1,6,a.EVENT;
