#/bin/bash

 E='echo -e';e='echo -en';trap "R;exit" 2
 ESC=$( $e "\e")
  TPUT(){ $e "\e[${1};${2}H";}
 CLEAR(){ $e "\ec";}
 CIVIS(){ $e "\e[?5l";}
  DRAW(){ $e "\e%@\e(0";}
 WRITE(){ $e "\e(B";}
# цвет и вид текста перед курсором
   MARK(){ $e "\e[7m";}
# цвет и вид текста меню
 UNMARK(){ $e "\e[27m";}
# цвет и вид фона меню
      R(){ CLEAR ;stty sane;$e "\ec\e[37;1m\e[J";};
   HEAD(){ DRAW
# Цикл боковых элементов
           for each in $(seq 1 13);do
           $E "x                                                x"
           done
           WRITE;MARK;TPUT 1 2
           $E "   Работа с дисками                             ";UNMARK;}
           i=0; CLEAR; CIVIS;NULL=/dev/null
   FOOT(){ MARK;TPUT 13 2
       printf "   Enter - select,next                          ";UNMARK;}
  ARROW(){ read -s -n3 key 2>/dev/null >&2
           if [[ $key = $ESC[A ]];then echo up;fi
           if [[ $key = $ESC[B ]];then echo dn;fi;}
# M0(){ TPUT отступ сверху отступ слева; $e "текст";}
 M0(){ TPUT  3  5; $e "Установить утилиту udiskie";}
 M1(){ TPUT  4  5; $e "Как система определила диск";}
 M2(){ TPUT  5  5; $e "Показать древо примонтрованных дисков";}
 M3(){ TPUT  6  5; $e "Показать все диски";}
 M4(){ TPUT  7  5; $e "Примонтировать диск";}
 M5(){ TPUT  8  5; $e "Отмонтировать диск";}
 M6(){ TPUT  9  5; $e "Подключить устройства автоматически";}
 M7(){ TPUT 10  5; $e "Показать в виде дерева USB устройства ";}
 M8(){ TPUT 11  5; $e "EXIT";}
# Количество прохождения ступеней
 LM=8
   MENU(){ for each in $(seq 0 $LM);do M${each};done;}
    POS(){ if [[ $cur == up ]];then ((i--));fi
           if [[ $cur == dn ]];then ((i++));fi
           if [[ $i -lt 0   ]];then i=$LM;fi
           if [[ $i -gt $LM ]];then i=0;fi;}
REFRESH(){ after=$((i+1)); before=$((i-1))
           if [[ $before -lt 0  ]];then before=$LM;fi
           if [[ $after -gt $LM ]];then after=0;fi
           if [[ $j -lt $i      ]];then UNMARK;M$before;else UNMARK;M$after;fi
           if [[ $after -eq 0 ]] || [ $before -eq $LM ];then
           UNMARK; M$before; M$after;fi;j=$i;UNMARK;M$before;M$after;}
   INIT(){ R;HEAD;FOOT;MENU;}
     SC(){ REFRESH;MARK;$S;$b;cur=`ARROW`;}
     ES(){ MARK;$e "Enter = main menu ";$b;read;INIT;};INIT
  while [[ "$O" != " " ]]; do case $i in
        0) S=M0;SC;if [[ $cur == "" ]];then R;echo "sudo apt install udiskie";ES;fi;;
        1) S=M1;SC;if [[ $cur == "" ]];then R;echo "lsblk";ES;fi;;
        2) S=M2;SC;if [[ $cur == "" ]];then R;echo "findmnt";ES;fi;;
        3) S=M3;SC;if [[ $cur == "" ]];then R;echo "sudo fdisk -l";ES;fi;;
        4) S=M4;SC;if [[ $cur == "" ]];then R;echo "udisksctl mount -b /dev/sdb1";ES;fi;;
        5) S=M5;SC;if [[ $cur == "" ]];then R;echo "udisksctl unmount -b /dev/sdb1";ES;fi;;
        6) S=M6;SC;if [[ $cur == "" ]];then R;echo "
     udiskie -a  -n -t
    -a - выполнять автоматическое монтирование.
    -n - показывать всплывающее уведомление.
    -t - показывать значок в трее.";ES;fi;;
        7) S=M7;SC;if [[ $cur == "" ]];then R;echo "lsusb -tv";ES;fi;;
        8) S=M8;SC;if [[ $cur == "" ]];then R;exit 0;fi;;
 esac;POS;done
