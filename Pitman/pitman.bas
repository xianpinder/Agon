   10 REM =============
   20 REM  P I T M A N
   30 REM =============
   40 REM Original game by Yutaka Isokawa (C) 1985
   50 REM Originally published in OH! MZ Magazine 1985
   60 REM AGON BBC BASIC version by C.J.Pinder 2023
   70 REM 
   80 VDU 23, 0, &C1, 1
   90 MODE 1:COLS%=64:ROWS%=48
  100 WX%=(COLS%-33)/2:WY%=12
  110 PROCUdgChars
  120 PROCDrawLogo
  130 PROCInstructions
  140 NUMLEVELS%=50
  150 Level%=0
  160 MX%=0:MY%=0
  170 DIM LevelData$(NUMLEVELS%)
  180 DIM Map%(11,8)
  190 RESTORE 2220
  200 FOR I%=0 TO NUMLEVELS%-1
  210   READ LevelData$(I%)
  220 NEXT
  230 REPEAT
  240   Steps%=0
  250   PROCDrawLevel(Level%)
  260   LD%=FNPlayLevel
  270   IF LD%=1 THEN Level%=(Level%+1) MOD NUMLEVELS%
  280   IF LD%=3 THEN Level%=(Level%+1) MOD NUMLEVELS%
  290 UNTIL FALSE
  300 END
  310 REM :
  320 DEF FNPlayLevel
  330 ST%=0
  340 REPEAT
  350   PROCLevelSteps
  360   K%=GET:REM UP=11,DOWN=10,LEFT=8,RIGHT=21,R=82,S=83 
  380   IF K%=21 AND MX%<10 THEN PROCMoveAcross(1)
  390   IF K%=8 AND MX%>0 THEN PROCMoveAcross(-1)
  400   IF K%=11 AND MY%>0 THEN PROCMoveUp
  410   IF K%=10 AND MY%<7 THEN PROCMoveDown
  420   IF K%=82 THEN ST%=2
  430   IF K%=83 THEN ST%=3
  440   IF MY%<7 AND Map%(MX%,MY%+1)=0 AND Map%(MX%,MY%)<>1 THEN PROCDropMan
  450   Steps%=Steps%+1
  460   IF Gold%=0 THEN ST%=1:PROCLevelSteps:PROCWellDone
  470   COLOUR 0:COLOUR 128
  480 UNTIL ST%<>0
  490 =ST%
  500 REM :
  510 DEF PROCwait(T%)
  520 F%=TIME+T%
  530 REPEAT:UNTIL TIME>F%
  540 ENDPROC
  550 DEF PROCWellDone
  560 COLOUR 15:COLOUR 129
  570 PRINT TAB(WX%+2,WY%+10);"                             ";
  580 PRINT TAB(WX%+2,WY%+11);"                             ";
  590 PRINT TAB(WX%+2,WY%+12);"          WELL DONE          ";
  600 PRINT TAB(WX%+2,WY%+13);"                             ";
  610 PRINT TAB(WX%+2,WY%+14);"                             ";
  620 COLOUR 0:COLOUR 128:PRINT TAB(0,0);" "
  630 PROCwait(200)
  640 ENDPROC
  650 REM :
  660 DEF PROCMoveUp
  670 U%=Map%(MX%,MY%-1):C%=Map%(MX%,MY%)
  680 IF U%=0 OR (C%=1 AND U%=1) THEN PROCMoveMan(MX%,MY%,MX%,MY%-1):MY%=MY%-1:PROCGravity(MX%,MX%)
  690 ENDPROC
  700 REM :
  710 DEF PROCMoveDown
  720 D%=Map%(MX%,MY%+1)
  730 IF D%=0 OR D%=1 THEN PROCMoveMan(MX%,MY%,MX%,MY%+1):MY%=MY%+1:PROCGravity(MX%,MX%)
  740 ENDPROC
  750 REM :
  760 DEF PROCMoveAcross(DX%)
  770 B%=Map%(MX%+DX%, MY%)
  780 IF B%<4 THEN PROCMoveMan(MX%,MY%,MX%+DX%,MY%):PROCGravity(MX%,MX%):MX%=MX%+DX%
  790 IF B%=2 THEN Gold%=Gold%-1
  800 RX%=MX%+DX%+DX%
  810 IF B%=4 AND RX%>=0 AND RX%<11 THEN IF Map%(RX%,MY%)=0 THEN PROCPushRock(DX%)
  820 ENDPROC
  830 REM :
  840 DEF PROCPushRock(DX%)
  850 Map%(MX%+DX%,MY%)=0:PROCDrawChar(MX%+DX%,MY%,0)
  860 Map%(MX%+DX%+DX%,MY%)=4:PROCDrawChar(MX%+DX%+DX%,MY%,4)
  870 IF DX%=1 THEN XS%=MX%+1:XE%=MX%+2:I%=8 ELSE XS%=MX%-2:XE%=MX%-1:I%=7
  880 PROCDrawChar(MX%,MY%,I%)
  890 PROCwait(20)
  900 PROCDrawChar(MX%,MY%,6)
  910 PROCGravity(XS%,XE%)
  920 ENDPROC
  930 REM :
  940 DEFPROCMoveMan(OX%,OY%,NX%,NY%)
  950 IF Map%(OX%,OY%) <> 1 THEN Map%(OX%,OY%) = 0
  960 IF Map%(NX%,NY%) <> 1 THEN Map%(NX%,NY%) = 6
  970 PROCDrawChar(OX%,OY%,Map%(OX%,OY%))
  980 PROCDrawChar(NX%,NY%,6)
  990 ENDPROC
 1000 REM :
 1010 DEF PROCGravity(SX%, EX%)
 1020 REPEAT
 1030   Q%=0
 1040   FOR CX%=SX% TO EX%
 1050     FOR CY%=7 TO 1 STEP -1
 1060       I%=Map%(CX%,CY%-1)
 1070       IF Map%(CX%,CY%)=0 AND (I%=2 OR I%=4) THEN Map%(CX%,CY%)=I%:Map%(CX%,CY%-1)=0:PROCDrawChar(CX%,CY%,I%):PROCDrawChar(CX%,CY%-1,0):Q%=1
 1080     NEXT
 1090   NEXT
 1100   IF Q%=1 THEN PROCwait(10)
 1110 UNTIL Q%=0
 1120 ENDPROC
 1130 REM :
 1140 DEF PROCDropMan
 1150 REPEAT
 1160   PROCwait(10)
 1170   PROCMoveMan(MX%,MY%,MX%,MY%+1):MY%=MY%+1
 1180   PROCGravity(MX%,MX%)
 1190 UNTIL MY%>=7 OR Map%(MX%,MY%+1)<>0 OR Map%(MX%,MY%)=1
 1200 ENDPROC
 1210 REM :
 1220 REM 0 Blank, 1 Ladder, 2 Gold, 3 Earth, 4 Rock
 1230 REM 5 Block, 6 Man, 7 Kick Left, 8 Kick Right
 1240 DEF PROCDrawChar(CX%,CY%,CC%)
 1250 P1$=STR$(CC%):P2$=P1$:P3$=P1$
 1260 COLOUR 128
 1270 IF CC%=0 THEN P1$="   ":P2$="   ":P3$="   "
 1280 IF CC%=1 THEN P1$="[=]":P2$="[=]":P3$="[=]":COLOUR 15
 1290 IF CC%=2 THEN P1$=" _ ":P2$="}:{":P3$="***":COLOUR 11
 1300 IF CC%=3 THEN P1$="###":P2$="###":P3$="###":COLOUR 9
 1310 IF CC%=4 THEN P1$="%*$":P2$="***":P3$="'*^":COLOUR 9
 1320 IF CC%=5 THEN P1$="<->":P2$="| ?":P3$="~!&":COLOUR 15:COLOUR 142
 1330 IF CC%=6 THEN P1$=" @ ":P2$="(*)":P3$="?-|":COLOUR 15
 1340 IF CC%=7 THEN P1$="\@ ":P2$=" *)":P3$="--|":COLOUR 15
 1350 IF CC%=8 THEN P1$=" @/":P2$="(* ":P3$="?--":COLOUR 15
 1360 PRINT TAB(CX%*3+WX%,CY%*3+WY%);P1$
 1370 PRINT TAB(CX%*3+WX%,CY%*3+1+WY%);P2$
 1380 PRINT TAB(CX%*3+WX%,CY%*3+2+WY%);P3$
 1390 COLOUR 8:COLOUR 128:PRINT TAB(0,0);
 1400 ENDPROC
 1410 REM :
 1420 DEF PROCDrawLevel(N%)
 1430 A$=LevelData$(N%)
 1440 I%=1:Gold%=0
 1450 FOR GY%=0 TO 7
 1460   FOR GX%=0 TO 10
 1470     GC%=ASC(MID$(A$,I%,1))-48
 1480     PROCDrawChar(GX%,GY%,GC%)
 1490     IF GC%=2 THEN Gold%=Gold%+1
 1500     IF GC%=6 THEN MX%=GX%:MY%=GY%:GC%=0
 1510     Map%(GX%,GY%)=GC%
 1520     I%=I%+1
 1530   NEXT
 1540 NEXT
 1550 COLOUR 7:COLOUR 128
 1560 PRINT TAB(WX%+0,WY%+24);"*********************************"
 1570 COLOUR 0:COLOUR 128:PRINT TAB(0,0);" "
 1580 ENDPROC
 1590 DEF PROCDrawLogo
 1600 T%=(COLS%-38)/2
 1610 COLOUR 15:COLOUR 142
 1620 PRINT TAB(T%,0);"                                      "
 1630 PRINT TAB(T%,1);"  ****$ ** ****** **$%** %***$ **$**  "
 1640 PRINT TAB(T%,2);"  ***** ** ****** ****** ***** *****  "
 1650 PRINT TAB(T%,3);"  ** ** **   **   ****** ** ** *****  "
 1660 PRINT TAB(T%,4);"  ** ** **   **   **'^** ** ** **'**  "
 1670 PRINT TAB(T%,5);"  ***** **   **   **  ** ***** ** **  "
 1680 PRINT TAB(T%,6);"  ****^ **   **   **  ** ***** ** **  "
 1690 PRINT TAB(T%,7);"  **    **   **   **  ** ** ** ** **  "
 1700 PRINT TAB(T%,8);"  **    **   **   **  ** ** ** ** **  "
 1710 PRINT TAB(T%,9);"  **    **   **   **  ** ** ** ** **  "
 1720 PRINT TAB(T%,10);"                                      "
 1730 COLOUR 128
 1740 ENDPROC
 1750 DEF PROCInstructions
 1760 COLOUR 130
 1770 T%=(COLS%-50)/2
 1780 FOR I%=1 TO 10
 1790   PRINT TAB(T%,ROWS%-I%);"                                                  ";
 1800 NEXT
 1810 COLOUR 0
 1820 PRINT TAB(T%+7,ROWS%-7);"Use the arrow keys to move Pitman."
 1830 PRINT TAB(T%+5,ROWS%-6);"Climb ladders, push rocks, remove earth"
 1840 PRINT TAB(T%+5,ROWS%-5);"and try to collect all the gold to win."
 1850 PRINT TAB(T%+2,ROWS%-4);"If you get stuck press S to skip or R to retry."
 1860 COLOUR 8
 1870 PRINT TAB(T%+5,ROWS%-2);"Original game design by Yutaka Isokawa"
 1880 COLOUR 128:COLOUR 0
 1890 ENDPROC
 1900 DEF PROCLevelSteps
 1910 COLOUR 130:COLOUR 15
 1920 T%=(COLS%-50)/2
 1930 PRINT TAB(T%+15,ROWS%-9);"Level ";STR$(Level%+1);"    Steps ";STR$(Steps%);"    "
 1940 COLOUR 0:COLOUR 128:PRINT TAB(0,0);" ";
 1950 ENDPROC
 1960 REM :
 1970 DEF PROCUdgChars
 1980 VDU 23,125,15,15,15,15,15,15,15,15
 1990 VDU 23,123,240,240,240,240,240,240,240,240
 2000 VDU 23,58,15,15,15,15,240,240,240,240
 2010 VDU 23,95,0,0,0,0,255,255,255,255
 2020 VDU 23,64,0,60,126,126,126,126,60,0
 2030 VDU 23,42,255,255,255,255,255,255,255,255
 2040 VDU 23,37,1,3,7,15,31,63,127,255
 2050 VDU 23,39,255,127,63,31,15,7,3,1
 2060 VDU 23,36,128,192,224,240,248,252,254,255
 2070 VDU 23,94,255,254,252,248,240,224,192,128
 2080 VDU 23,91,8,8,8,8,15,8,8,8
 2090 VDU 23,93,16,16,16,16,240,16,16,16
 2100 VDU 23,61,0,0,0,0,255,0,0,0
 2110 VDU 23,35,170,85,170,85,170,85,170,85
 2120 VDU 23,60,255,128,128,128,128,128,128,128
 2130 VDU 23,45,255,0,0,0,0,0,0,0
 2140 VDU 23,62,255,1,1,1,1,1,1,1
 2150 VDU 23,124,128,128,128,128,128,128,128,128
 2160 VDU 23,63,1,1,1,1,1,1,1,1
 2170 VDU 23,126,128,128,128,128,128,128,128,255
 2180 VDU 23,33,0,0,0,0,0,0,0,255
 2190 VDU 23,38,1,1,1,1,1,1,1,255
 2200 ENDPROC
 2210 REM : 
 2220 DATA "0004000000015545055551100405000011063000000155550500001000050000012000000004155505550555"
 2230 DATA "0040000000000404000000005123000000051322000200513330333205100333005051000000650555555555"
 2240 DATA "0000605040000004151400000241512000023315122005211151550055555515200000000155005555555550"
 2250 DATA "0000040000002000300002031012545010002135254002031034320231016333403002055533132135233331"
 2260 DATA "5555555555542400005335444151053353330010533500215105335344001053352121510533510200165555"
 2270 DATA "0040000000006404000000133010000001003333111033332001542000030550442000050012450531015132"
 2280 DATA "0110400055501404006535014025515350140144153551502331535510011555355500515333535021155555"
 2290 DATA "3330500111133365203021333154032413441530354103415003041003151110310251555155101110000001"
 2300 DATA "0000400205315514015053105120150531051205505510514055001105553000511002005555110010060001"
 2310 DATA "0060005330204333152334023311543130303153331300401513313035310510131510303513330133133123"
 2320 DATA "0000020000000020002000020006000200000545000000000200000545454545450000000000050505050505"
 2330 DATA "0040010040000555100400000000004110055555434100111114041001323030312010420500110102105061"
 2340 DATA "3220052023334521051403135331053101353331050113033331014165113115423351410113433313330001"
 2350 DATA "0004000000000040000050011405551000143440000001403400000013033000206100400024055113000120"
 2360 DATA "0040060040011111311111100403040011032303230110353035301103330333011000101000110001010001"
 2370 DATA "4000554004330640030021153313330330240133030033331001030254015050004033333002031000001050"
 2380 DATA "1111100000012441420000142412440001242143210014241244100132214231005515124110252151111601"
 2390 DATA "1000000000113334333431103236324011033443420110322033301100320240011002403400110333303301"
 2400 DATA "0000003354515543133525150251435451104013354510033300333011533333441064040003350550505121"
 2410 DATA "0111111111160000000001502240424015000202020150442040401502000202015042402240150000000001"
 2420 DATA "0004000000005451455510004403600100233033001003501000010200300000105055555555050500000000"
 2430 DATA "0000533544000025555440000311153110040401200111434005001163340020011303300500111111115001"
 2440 DATA "3400000000036055555551032400000013032400000103032400001303032400010303032000130303030001"
 2450 DATA "1146400000010414000000104140000001054541000010040401000105505055001004040500210550505005"
 2460 DATA "3323405204021334055451400031504413315410035101504331401302330013133055413150236333151511"
 2470 DATA "3000004000030353111111305350000013035304000130000333001300003230013333033300100030060001"
 2480 DATA "5555611111153355000421533350042315355504231553520023155535550311535335202155355551015533"
 2490 DATA "0000000024000000000141000000550310000000005100200400001015055001550100000010000000006100"
 2500 DATA "0004053333300040555555011400000020143455555501404011111013030323010100502420161005012101"
 2510 DATA "1000000100013333330400140060005551305550000014022500120130545000101003330000130133333330"
 2520 DATA "3233040400033331111111305203000013033030000130006400001133033000010000000000155555555500"
 2530 DATA "0000000524000004040531133310315411000130153114040001001130331055211030013055416015301254"
 2540 DATA "3000043000033440331000313430310603103205555531004030250312040345003140403500031111155555"
 2550 DATA "0000640400000001504000040150040000415000402013000004050130000422001001003220055510032200"
 2560 DATA "0000041111000002461410000241114102024115131010411524011103325130011003551400110033311100"
 2570 DATA "5666566652055555555551000040005010152300050101514400501133323406011000333150111111111500"
 2580 DATA "0000044444000200422220001102422260000522422100000222421000152222410001022222100051111111"
 2590 DATA "0040400000000301111111000414000010003210020105004140501025030100010100000006155101511155"
 2600 DATA "0003400400000115311111100153000015501530400102015033301150150323011101103330100000000061"
 2610 DATA "1600040002113044244031105242425011024222420110542224501114222224111122222221111111111111"
 2620 DATA "0014004000200110110015204101020461041010101200110100411010101041000001010102000010000010"
 2630 DATA "3320040204033401205030344011111011330000033113304600401100013332011003000150130333301000"
 2640 DATA "0000000400415555555002111116000420400055102232000051042332000510243332020132233330501022"
 2650 DATA "0000052040000000054551000405020411555050505110020030301101500313111010002505110000610101"
 2660 DATA "1250000040014000401142125554001341400040010212330420103130032503301000125334055161250030"
 2670 DATA "5000000000551555255555515354040255155540224551020214235515255552055103060020555555555555"
 2680 DATA "0204100000015041000000150410000001304100040051041551400500416003105422330031050231210010"
 2690 DATA "0400510020013304101540102031010401033010033110006100401333331015012000000103155055505333"
 2700 DATA "2421424422242213460444422111300002441500111144413451224444513313330005531552011111113310"
 2710 DATA "3004333333641112241112422144210103214422111033131113330233310133201423111331012202221210"
               

