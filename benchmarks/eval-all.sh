btool eval runscripts/runscript-metric-tplp-dentist-plain.xml > resultsv8/dentist-plain.xml
btool eval runscripts/runscript-metric-tplp-dentist-general.xml > resultsv8/dentist-general.xml
btool eval runscripts/runscript-metric-tplp-jobshop.xml > resultsv8/jobshop.xml
btool eval runscripts/runscript-metric-tplp-mapf.xml > resultsv8/mapf.xml
btool eval runscripts/runscript-metric-tplp-mapf-8.xml > resultsv8/mapf-8.xml

btool conv resultsv8/dentist-plain.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv8/dentist-plain.xlsx
btool conv resultsv8/dentist-general.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv8/dentist-general.xlsx
btool conv resultsv8/jobshop.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv8/jobshop.xlsx
btool conv resultsv8/mapf.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv8/mapf.xlsx
btool conv resultsv8/mapf-8.xml -m "time,stime,status,rules,ctime,fmtime,memout" -o resultsv8/mapf-8.xlsx
