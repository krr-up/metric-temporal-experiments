btool eval runscripts/runscript-metric-tplp-dentist-plain.xml > resultsv7/dentist-plain.xml
btool eval runscripts/runscript-metric-tplp-dentist-general.xml > resultsv7/dentist-general.xml
btool eval runscripts/runscript-metric-tplp-jobshop.xml > resultsv7/jobshop.xml
btool eval runscripts/runscript-metric-tplp-mapf.xml > resultsv7/mapf.xml
btool eval runscripts/runscript-metric-tplp-mapf-8.xml > resultsv7/mapf-8.xml

btool conv resultsv7/dentist-plain.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv7/dentist-plain.xlsx
btool conv resultsv7/dentist-general.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv7/dentist-general.xlsx
btool conv resultsv7/jobshop.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv7/jobshop.xlsx
btool conv resultsv7/mapf.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv7/mapf.xlsx
btool conv resultsv7/mapf-8.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv7/mapf-8.xlsx
