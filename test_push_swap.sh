#!/bin/bash
# Because this project sucks, let me know if something is weird

GREEN='\033[0;32m'
RED='\033[0;31m'
LBLUE='\033[1;34m'
NA='\033[0m'
TEST=""
MAX="0"
MOVE="0"
WORST=""
AVG=()
FAILS="0"
REP=""


################################################################################
#                                                                              #
#	Helper/Work functions .....................................................#
#                                                                              #
################################################################################

function reinit {
	unset TEST
	TEST=""
	unset AVG
	AVG=()
	total=0
	MAX="0"
	MOVE="0"
	WORST=""
	FAILS="0"
}

function avrg {
	for var in "${AVG[@]}"
	do
		total=$((total + var))
	done
	total=$((total/${#AVG[@]}))
}

function catchio {
	printf "Enter # of random integers to test with:\n"
	read ints
	printf "Enter a # >50 to rigourously test with $ints of integers, or don't:\n"
	read cycles
}

function maxmoves {
	MOVE=`./push_swap ${TEST} | tr " " "\n" | wc -l`
	if (( $MOVE > $MAX )); then
		MAX=$MOVE
		WORST=${TEST}
	fi
	if [[ $MOVE == 0 && "$rep" =~ ^[0-9]+$ ]]; then
		printf "FAIL\n"
		FAILS=$((FAILS+=1))
	else
		AVG+=($MOVE)
	fi
}

function printavrg {
	if (( ($1 > 100 && $2 <= 5300)
		|| ($1 > 5 && $2 <= 700)
		|| ($1 <= 5 && $2 <= 12) )); then
		printf "${GREEN}Average: $2${NA}\n"
	else
		printf "${RED}!! Averages: $2${NA}\n"
	fi

}

function printmoves {
	if (( ($1 > 100 && $2 <= 5300)
		|| ($1 > 5 && $2 <= 700)
		|| ($1 <= 5 && $2 <= 12) )); then
		printf "${GREEN}Total moves: $2${NA}\n"
	else
		FAILS=$((FAILS+=1))
		printf "${RED}!! total moves: $2${NA}\n"
	fi
}

function errinit {
	unset rep
	rep=""
}

function catchrep {
	rep=`echo "${TEST}" | tr " " "\n" | sort | uniq -c | awk '{ print $1 }' | grep -v "1"`
	if [[ "$rep" =~ ^[0-9]+$ ]]; then
		printf "${RED}Duplicate Number Error${NA}\n"
		return 0
	fi
}

function numbers {
	flip=1
	for ((j=0; j<$1; j++)); do
		ent=`jot -r 1 -2147483648 2147483647`
		if (( $flip == 1 )); then
			TEST+="${ent}"
			flip=0
		else
			TEST+=" ${ent}"
		fi
	done
	catchrep
	if [[ "$rep" =~ ^[0-9]+$ ]]; then
		return 0
	fi
}

################################################################################
#                                                                              #
#	Main calls from hanging while loop ........................................#
#                                                                              #
################################################################################

################################################################################
#		Case 3                                                                 # 
################################################################################

function combo {
	printf "Verbose? y/n?\n"
	read verb
	if [[ $verb == "n" ]]; then
		printf "Do you want to see the integers tested? y/n?\n"
		read nums
	fi
	for ((i=1; i<=$cycles; i++)); do
		echo "Test $i"
		numbers $ints
		if [[ $verb == "y" ]]; then
			maxmoves
			echo `./push_swap ${TEST} | tr " " "\n"\
				| ./checker -v ${TEST}`
		else
			maxmoves
			echo `./push_swap ${TEST} | tr " " "\n" |\
				./checker ${TEST}`
		fi
		if [[ $nums == "y" ]]; then
			printf "\nTEST WITH:\n"
			printf "./push_swap \"${TEST}\" | ./checker \"${TEST}\"\n"
		fi
		printmoves $ints $MOVE
		unset TEST
		TEST=""
		errinit
	done
}

################################################################################
#		Case 2                                                                 # 
################################################################################

function makem {
	for ((i=1; i<=$cycles; i++)); do
		numbers $ints
		printf "\n${LBLUE}TEST WITH:${NA}\n"
		printf "./checker \"${TEST}\"\n"
		errinit
		reinit
	done
	printf "\n"
}

################################################################################
#		Case 1                                                                 # 
################################################################################

function push {
	if (( $cycles < 5 && $ints < 20)); then
		printf "Do you want to see my moves? y/n?\n"
		read move
	else
		move="n"
	fi
	if [[ $move == "n" ]]; then
		printf "Do you want to see the integers tested? y/n?\n"
		read nums
	fi
	for ((i=1; i<=$cycles; i++)); do
		numbers $ints
		if [[ $move == "y" ]]; then
			echo "Test $i"
			echo `./push_swap ${TEST}` | tr " " "\n"
			printf "TEST WITH:\n"
			printf "./push_swap \"${TEST}\"\n"
			nums="n"
			maxmoves 
		else
			maxmoves
		fi
		if [[ $nums == "y" ]]; then
			printf "\nTEST WITH:\n"
			printf "./push_swap \"${TEST}\"\n"
		fi
		printmoves $ints $MOVE
		unset TEST
		TEST=""
		errinit
	done
	avrg
	printf "\nFAILED $FAILS/$cycles\n"
	printf "AVERAGE Ops for $ints integers: \n"
	printavrg $ints $total
	printf "MAX Ops for $ints integers:\n"
	printmoves $ints $MAX
	printf "\nTEST MAX WITH:\n./push_swap \"${WORST}\"\n\n"
}

################################################################################
#                                                                              # 
#	Main body of the test .....................................................#
#                                                                              # 
################################################################################

while true;
do
	printf "${LBLUE}Select one of these test options:\n\
....(1) push program\n\
....(2) checker/randnum program\n\
....(3) push | checker\n\
....(4) exit\n${NA}"
	read input
	if [[ $input < 4 && "$input" =~ ^[0-9]+$ ]]; then
		catchio
	fi
	case $input in
		1)
			printf "${LBLUE}Push_swap Test (hit enter if stuck)${NA}\n"
			push
			;;
		2)
			printf "${RED}Checker Test-it yourself${NA}"
			makem
			;;
		3)
			printf "${LBLUE}Push_swap | Checker Test${NA}\n"
			combo
			;;
		4)
			break
			;;
	esac
	reinit
done
