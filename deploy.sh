#!/usr/bin/env bash

#
# deploy
#
# Upload and deploy Microvisor application code
#
# @author    Tony Smith
# @copyright 2022, Twilio
# @version   1.0.2
# @license   MIT
#

# GLOBALS
do_log=0
zip_path="UNDEFINED"

# FUNCTIONS
show_help() {
    echo -e "Usage:\n"
    echo -e "  deploy [-l] [-h] /path/to/Microvisor/app/bundle.zip\n"
    echo -e "Options:\n"
    echo "  -l / --log      After deployment, start log streaming. Default: no logging"
    echo "  -h / --help     Show this help screen"
    echo
}

stream_log() {
    echo "Logging from ${MV_DEVICE_SID}..."
    twilio microvisor:logs:stream "${MV_DEVICE_SID}"
}

# RUNTIME START
for arg in "$@"; do
    check_arg=${arg,,}
    if [[ "$check_arg" = "--log" || "$check_arg" = "-l" ]]; then
        do_log=1
    elif [[ "$check_arg" = "--help" || "$check_arg" = "-h" ]]; then
        show_help
        exit 0
    else
        zip_path="$arg"
    fi
done

# Check we have a path
if [[ "${zip_path}" == "UNDEFINED" || ! -e "${zip_path}" ]]; then
    echo "[ERROR] No bundle specified, or file does not exist"
    exit 1
fi

# Check we have what looks like a bundle
extension="${zip_path##*.}"
if [[ "${extension}" != "zip" ]]; then
    echo "[ERROR] ${zip_path} does not indicate a .zip file"
    exit 1
fi

# Try to upload the bundle
echo "Uploading ${zip_path}..."
upload_action=$(curl -X POST https://microvisor-upload.twilio.com/v1/Apps -H "Content-Type: multipart/form-data" -u "${TWILIO_API_KEY}:${TWILIO_API_SECRET}" -s -F File=@"${zip_path}")

app_sid=$(echo "${upload_action}" | jq -r '.sid')

if [[ -z "${app_sid}" ]]; then
    echo "[ERROR] Could not upload app"
    exit 1
else
    # Success... try to assign the app
    echo "Assigning app ${app_sid} to device ${MV_DEVICE_SID}..."
    update_action=$(curl -X POST "https://microvisor.twilio.com/v1/Devices/${MV_DEVICE_SID}" -u "${TWILIO_API_KEY}:${TWILIO_API_SECRET}" -s -d AppSid="${app_sid}")
    up_date=$(echo "${update_action}" | jq -r '.date_updated')

    if [[ "${up_date}" != "null" ]]; then
        echo "Updated device ${MV_DEVICE_SID} @ ${up_date}"

        # Start logging if requested to do so
        if [[ $do_log -eq 1 ]]; then
            stream_log
        fi
    else
        echo "[ERROR] Could not assign app ${app_sid} to device ${MV_DEVICE_SID}"
        echo "Response from server:"
        echo "$update_action"
        exit 1
    fi
fi

exit 0
