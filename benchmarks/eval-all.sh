btool eval runscripts/runscript-metric-tplp-dentist-plain.xml > resultsv5/dentist-plain.xml
btool eval runscripts/runscript-metric-tplp-dentist-general.xml > resultsv5/dentist-general.xml
# btool eval runscripts/runscript-metric-tplp-jobshop.xml > resultsv5/jobshop.xml
# btool eval runscripts/runscript-metric-tplp-mapf.xml > resultsv5/mapf.xml
# btool eval runscripts/runscript-metric-tplp-mapf-8.xml > resultsv5/mapf-8.xml

btool conv resultsv5/dentist-plain.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv5/dentist-plain.xlsx
btool conv resultsv5/dentist-general.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv5/dentist-general.xlsx
# btool conv resultsv5/jobshop.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv5/jobshop.xlsx
# btool conv resultsv5/mapf.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv5/mapf.xlsx
# btool conv resultsv5/mapf-8.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv5/mapf-8.xlsx
