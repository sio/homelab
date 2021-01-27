timeout 5

REM Using winrm without call will result in this script exiting after
REM the first winrm invocation. Winrm script will just replace the current
REM batch file in the interpeter.
REM
REM See: https://stackoverflow.com/questions/7320074#comment23450424_9805955
call winrm s winrm/config/service @{AllowUnencrypted="false"}
call winrm s winrm/config/service/auth @{Basic="false"}

shutdown /s /t 0 /d p:4:1 /c "Packer Shutdown"
