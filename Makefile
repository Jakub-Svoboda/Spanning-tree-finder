# FLP 2nd Project
# Jakub Svoboda, FIT VUTBR
# xsvobo0z@stud.fit.vutbr.cz

make:
	swipl -o flp20-log -q -g main -t true -c flp20-log.pl

clean:
	rm -f flp20-log