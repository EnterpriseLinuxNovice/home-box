#!/usr/bin/env bash
# VARS
CRED="/home/$USER/.aws/credentials"
CONF="/home/$USER/.aws/config"
ACCESS_KEY="changeme"
SECRET_KEY="changeme"
PARAM1="region = changeme" 
PARAM2="output = changeme"

# ROOT
if [[ "$UID" -ne "0" ]]; then
    echo "RUN AS ROOT. EXITING"
    exit 1
fi

# FUNCTIONS
CRED_RESET() {
    if [[ ! -e "$CRED" ]]; then
        ADD_KEYS
    else
        rm "$CRED"
        ADD_KEYS
    fi  
}

ADD_KEYS() {
    touch $CRED &> /dev/null
    echo "[default]" > "$CRED"
    echo "aws_access_key_id = $ACCESS_KEY" >> "$CRED"
    echo "aws_secret_access_key = $SECRET_KEY" >> "$CRED"
}

CONF_RESET() {
    if [[ ! -e "$CONF" ]]; then
        ADD_PARAM
    else
        rm "$CONF"
        ADD_PARAM
    fi  
}

ADD_PARAM() {
    touch $CONF &> /dev/null
    echo "[default]" > "$CONF"
    echo "$PARAM1" >> "$CONF"
    echo "$PARAM2" >> "$CONF"
}


# STEPS
CRED_RESET
CONF_RESET
