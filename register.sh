 #!/bin/bash

set -eu

readonly TEMP_RESPONSE_FILE="register_response"
readonly THING_CREDENTIAL_DIR="certs"

readonly REGISTER_URL="http://192.168.100.105:3000/things.json"
readonly SERIAL_NO=`source ./get_cpu_serial.sh`
readonly MODEL="Raspberry Pi Zero WH"
readonly DATA="'{\"thing\": {\"serial_no\": \"${SERIAL_NO}\", \"model\": \"${MODEL}\"}}'"

readonly ROOT_CA_URL="https://www.symantec.com/content/en/us/enterprise/verisign/roots/VeriSign-Class%203-Public-Primary-Certification-Authority-G5.pem"

eval "curl -sS -H 'Content-Type:application/json' -XPOST -d ${DATA} ${REGISTER_URL} > ${TEMP_RESPONSE_FILE}"

if [ -f ./${TEMP_RESPONSE_FILE} ]; then
    if [ ! -d ./${THING_CREDENTIAL_DIR} ]; then
       mkdir ${THING_CREDENTIAL_DIR}
    fi

    cat ./${TEMP_RESPONSE_FILE} |jq -r '.certificate_arn' > ${THING_CREDENTIAL_DIR}/certificate_arn
    cat ./${TEMP_RESPONSE_FILE} |jq -r '.certificate_id' > ${THING_CREDENTIAL_DIR}/certificate_id
    cat ./${TEMP_RESPONSE_FILE} |jq -r '.certificate_pem' > ${THING_CREDENTIAL_DIR}/certificate_pem
    cat ./${TEMP_RESPONSE_FILE} |jq -r '.private_key' > ${THING_CREDENTIAL_DIR}/private_key

    rm ./${TEMP_RESPONSE_FILE}
else
    echo "${TEMP_RESPONSE_FILE} is not found. Register thing may have failed."
fi

curl ${ROOT_CA_URL} >> ${THING_CREDENTIAL_DIR}/root-CA.crt



