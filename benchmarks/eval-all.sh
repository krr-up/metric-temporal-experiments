# btool eval runscripts/runscript-metric-tplp-dentist-plain.xml > resultsv10/dentist-plain.xml
# btool eval runscripts/runscript-metric-tplp-dentist-general.xml > resultsv10/dentist-general.xml
# btool eval runscripts/runscript-metric-tplp-jobshop.xml > resultsv10/jobshop.xml
btool eval runscripts/runscript-metric-tplp-mapf.xml > resultsv10/mapf.xml
btool eval runscripts/runscript-metric-tplp-mapf-8.xml > resultsv10/mapf-8.xml

# btool conv resultsv10/dentist-plain.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv10/dentist-plain.xlsx
# btool conv resultsv10/dentist-general.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv10/dentist-general.xlsx
# btool conv resultsv10/jobshop.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv10/jobshop.xlsx
btool conv resultsv10/mapf.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv10/mapf.xlsx
btool conv resultsv10/mapf-8.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv10/mapf-8.xlsx
