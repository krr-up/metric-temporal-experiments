# btool eval runscripts/runscript-metric-tplp-dentist-plain.xml > resultsv9/dentist-plain.xml
# btool eval runscripts/runscript-metric-tplp-dentist-general.xml > resultsv9/dentist-general.xml
btool eval runscripts/runscript-metric-tplp-jobshop.xml > resultsv9/jobshop.xml
# btool eval runscripts/runscript-metric-tplp-mapf.xml > resultsv9/mapf.xml
# btool eval runscripts/runscript-metric-tplp-mapf-8.xml > resultsv9/mapf-8.xml

# btool conv resultsv9/dentist-plain.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv9/dentist-plain.xlsx
# btool conv resultsv9/dentist-general.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv9/dentist-general.xlsx
btool conv resultsv9/jobshop.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv9/jobshop.xlsx
# btool conv resultsv9/mapf.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv9/mapf.xlsx
# btool conv resultsv9/mapf-8.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv9/mapf-8.xlsx
