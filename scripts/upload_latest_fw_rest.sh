#!/bin/bash

latestFwFile=$(find build -name wican-fw_obd_pro_*.bin)
latestFwFileLineCount=$(find build -name wican-fw_obd_pro_*.bin | wc -l)

if [[ -z "${latestFwFile}" ]]
then
    echo "❌  No valid firmware file found. Please try building first."
    exit 1
fi

if [[ ${latestFwFileLineCount} -ne 1 ]]
then
    printf "❌  Found ${latestFwFileLineCount} firmware bin files. Not sure which one to upload. Delete the old one(s) manually:\n${latestFwFile}\n"
    exit 1
fi

echo "Uploading '${latestFwFile}'..."
curl --progress-bar --form "ota_file=@${latestFwFile};type=application/octet-stream" http://192.168.0.10/upload/ota.bin
echo ""

lastError=$?
if [[ ${lastError} -eq 0 ]]
then
    echo "✅  Success. The device will now reboot."
else
    echo "❌  Upload failed."
fi
