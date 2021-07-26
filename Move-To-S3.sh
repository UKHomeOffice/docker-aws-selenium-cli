#!/bin/sh

Logs () {

    Date=$(date -u +%Y-%m-%d)
    DateTime="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

    Var1=$1
    Var2=$2
    pwd='/import'

    if [[ -d $pwd/logs ]]; then
        if [[ -f logs-$Date.txt ]]; then
            
            echo "[$Var1] - $DateTime - $Var2 " >> $pwd/logs/logs-$Date.txt
            
        elif [[ ! -f logs-$Date.txt ]]; then
            touch $pwd/logs/logs-$Date.txt
            echo "[$Var1] - $DateTime - $Var2 " >> $pwd/logs/logs-$Date.txt

        fi  

    elif [[ ! -d $pwd/logs ]]; then

        mkdir $pwd/logs 
        touch $pwd/logs/logs-$Date.txt
        echo "[$Var1] - $DateTime - $Var2 " >> $pwd/logs/logs-$Date.txt

    fi
}
Logs "INFO" "Starting backup movment. Backup being moved $(date -u +%Y-%B-%d--0100.zip)"

AWS_ACCESS_KEY_ID=$access_key_id AWS_SECRET_ACCESS_KEY=$secret_access_key aws s3 cp s3://$bucket_name/$(date -u +%Y-%b-%d--0100.zip) /import/import/ --sse aws:kms --sse-kms-key-id $kms_key_id || Logs "ERROR" "Command failed to run $?"

Logs "INFO" "Script has finished"