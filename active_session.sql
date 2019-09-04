REM
REM File name: 	active_session.sql
REM Purpose:	Current active session.
REM Warning:
REM Author: 	Ahern
REM Usage: 		
REM Example:	sqlplus / as sysdba		@active_session
REM Version:
REM Notes:
REM

set linesize 240
col SESS for a15
col PROGRAM for a35
col MACHINE for a22
col USERNAME for a10
col SPID for a12
col LOGON_TIME for a15
col COMMAND for a20
select a.INST_ID,
       a.sid || ',' || a.serial# as sess,
       a.username,
       a.sql_hash_value,
       a.sql_id,
       c.spid,
       a.last_call_et ET,
       substr(a.program, 1, 39) program,
       b.name as command,
       to_char(a.logon_time, 'mm-dd hh24:mi') as logon_time,
       a.machine
  from gv$session a, audit_actions b, gv$process c
 where a.command = b.action(+)
   and a.status = 'ACTIVE'
   and a.paddr = c.addr
   and (a.program not like 'oracle%' or a.program is null)
   and a.PROGRAM not like 'em%'
   and a.program not like 'racgimo%'
 order by a.SQL_HASH_VALUE,a.INST_ID,a.last_call_et desc; 
