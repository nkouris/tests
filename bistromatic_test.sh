#!/bin/bash

	declare -a str=('4-4' '7-(-4)' '(-7)-4' '-7-(-4)'\
					'4-7' '4-(-7)' '(-4)-7' '(-4)-(-7)'\
					'716-4' '716-(-4)' '(-716)-4' '-716-(-4)'\
					'4-716' '4-(-716)' '(-4)-716' '(-4)-(-716)'\
					'7-416' '7-(-416)' '(-7)-416' '-7-(-416)'\
					'416-7' '416-(-7)' '(-416)-7' '(-416)-(-7)'\
					'7+4' '7+(-4)' '(-7)+4' '-7+(-4)'\
					'4+7' '4+(-7)' '(-4)+7' '(-4)+(-7)'\
					'716+4' '716+(-4)' '(-716)+4' '-716+(-4)'\
					'4+716' '4+(-716)' '(-4)+716' '(-4)+(-716)'\
					'7+416' '7+(-416)' '(-7)+416' '-7+(-416)'\
					'416+7' '416+(-7)' '(-416)+7' '(-416)+(-7)'\
					'7*4' '7*(-4)' '(-7)*4' '-7*(-4)'\
					'4*7' '4*(-7)' '(-4)*7' '(-4)*(-7)'\
					'716*4' '716*(-4)' '(-716)*4' '-716*(-4)'\
					'4*716' '4*(-716)' '(-4)*716' '(-4)*(-716)'\
					'7*416' '7*(-416)' '(-7)*416' '-7*(-416)'\
					'416*7' '416*(-7)' '(-416)*7' '(-416)*(-7)'\
					'7*4' '7*(-4)' '(-7)*4' '-7*(-4)'\
					'4*7' '4*(-7)' '(-4)*7' '(-4)*(-7)'\
					'71616*4' '71616*(-4)' '(-71616)*4' '-71616*(-4)'\
					'4*71616' '4*(-71616)' '(-4)*71616' '(-4)*(-71616)'\
					'7*41616' '7*(-41616)' '(-7)*41616' '-7*(-41616)'\
					'41616*7' '41616*(-7)' '(-41616)*7' '(-41616)*(-7)'\
					'7+4+516' '7+(-4)+516' '(-7)+4+516' '-7+(-4)+516'\
					'4+7+516' '4+(-7)+516' '(-4)+7+516' '(-56+32*6)-4'\
					'2+7+287384+901+2+17+90+178+34' '12*(-9)' '12*-9'\
					'(32-41)+66672-1923*(12+2)' '(13+2)*(23-3)+(16-2)'\
					'1923+(12*2)' '1923*(12+2)' '1923*1233+2' '12*12'\
					'65481-213542*3+(1276-486953*(12*4)+62)' '++--6*12'\
					'-(12-(4*32))' '123-120+120394*(123*2)-1276602*126+(2634*827)*8*80*800*8000-(142*1765-(1283+12385-(123*965)))' '(-7)*(-2389146)*1236*90123-(192735*2394)' '((((((24+24))))))' '-(-(-(-(17+78))))' '(1246+1239846-293846*1723984+(193856+129843)*123745-1293847*(2138461298347))')

	arrlen=${#str[@]}
	for ((i=0; i<arrlen; i++))
	do
		strlen=`echo -n ${str[i]} | wc -m`
		bc=`echo ${str[i]} | bc`
		bistro=`echo ${str[i]} | ./calc "0123456789" $strlen | cat | head -n1`
	#	result=`diff -u <(echo $bc) <(echo $bistro)`
		if test "$bc" != "$bistro"; then
			echo
			echo "test with: echo \"${str[i]}\" | ./calc "0123456789" $strlen"
			echo
		fi
		printf "%-20s %s %s %10s\n" "${str[i]} bc: $bc, bistro: $bistro $result"
	done
exit 0
