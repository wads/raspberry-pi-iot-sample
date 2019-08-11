#!/bin/bash

set -eu

readonly TEMP_RESPONSE_FILE="register_response"
readonly THING_CREDENTIAL_DIR="cert"

readonly REGISTER_URL="http://example.com/things"
readonly SERIAL_NO=`source ./get_cpu_serial.sh`
readonly MODEL="Raspberry Pi Zero WH"
readonly DATA="'{\"SerialNo\": \"${SERIAL_NO}\", \"Model\": \"${MODEL}\"}'"

readonly ROOT_CA_URL="https://www.amazontrust.com/repository/AmazonRootCA1.pem"

eval "curl -sS -H 'Content-Type:application/json' -XPOST -d ${DATA} ${REGISTER_URL} > ${TEMP_RESPONSE_FILE}"

if [ -f ./${TEMP_RESPONSE_FILE} ]; then
    if [ ! -d ./${THING_CREDENTIAL_DIR} ]; then
       mkdir ${THING_CREDENTIAL_DIR}
    fi

    cat ./${TEMP_RESPONSE_FILE} |jq -r '.CertificateArn' > ${THING_CREDENTIAL_DIR}/certificate_arn
    cat ./${TEMP_RESPONSE_FILE} |jq -r '.CertificateId' > ${THING_CREDENTIAL_DIR}/certificate_id
    cat ./${TEMP_RESPONSE_FILE} |jq -r '.CertificatePem' > ${THING_CREDENTIAL_DIR}/certificate.pem
    cat ./${TEMP_RESPONSE_FILE} |jq -r '.PrivateKey' > ${THING_CREDENTIAL_DIR}/private.key

    rm ./${TEMP_RESPONSE_FILE}
else
    echo "${TEMP_RESPONSE_FILE} is not found. Register thing may have failed."
fi

curl ${ROOT_CA_URL} >> ${THING_CREDENTIAL_DIR}/amazon_root_ca1.pem



