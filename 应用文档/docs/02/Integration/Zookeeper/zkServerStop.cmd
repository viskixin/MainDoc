@echo off
 setlocal
 TASKLIST /svc | findstr /c:"%ZOOKEEPER_SERVICE%" > %ZOOKEEPER_HOME%\zookeeper_svc.pid
 FOR /F "tokens=2 delims= " %%G IN (%ZOOKEEPER_HOME%\zookeeper_svc.pid) DO (
    @set zkPID=%%G
 )
 taskkill /PID %zkPID% /T /F
 del %ZOOKEEPER_HOME%/zookeeper_svc.pid
