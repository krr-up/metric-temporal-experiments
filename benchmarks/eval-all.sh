# btool eval runscripts/runscript-metric-tplp-dentist-plain.xml > resultsv11/dentist-plain.xml
# btool eval runscripts/runscript-metric-tplp-dentist-general.xml > resultsv11/dentist-general.xml
# btool eval runscripts/runscript-metric-tplp-jobshop.xml > resultsv11/jobshop.xml
btool eval runscripts/runscript-metric-tplp-mapf.xml > resultsv11/mapf.xml
btool eval runscripts/runscript-metric-tplp-mapf-8.xml > resultsv11/mapf-8.xml

# btool conv resultsv11/dentist-plain.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv11/dentist-plain.xlsx
# btool conv resultsv11/dentist-general.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv11/dentist-general.xlsx
# btool conv resultsv11/jobshop.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv11/jobshop.xlsx
btool conv resultsv11/mapf.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv11/mapf.xlsx
btool conv resultsv11/mapf-8.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv11/mapf-8.xlsx
