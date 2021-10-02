#userid -- ORACLE username/password@IP:PUERTO/SID
#control -- control file name
#log -- log file name
#bad -- bad file name
sqlldr userid=LEONELCHS/cesarsican17@localhost:1521/xe control=[BD1]ArchivoControl.ctl log=log/[BD1]ArchivoControl.log bad=bad/[BD1]ArchivoControl.bad
echo " "
echo -e "\e[96m  ENTER PARA CONTINUAR ... \e[0m"
read