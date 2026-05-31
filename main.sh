#!/bin/bash
# İsim SOYİSİM: Atakan KORKMAZ
# Öğrenci Numarası:2420171028
# Sertifika Bağlantıları: https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=nKqhn7NELB
#                         https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=pKmhqJpE7Z
#                         https://credsverse.com/credentials/0403af7d-dbec-4f62-b6f4-5e16d879e597

LOG_FILE="report.log"
OS="$(uname -s)"

date -u +"%Y-%m-%dT%H:%M:%SZ" > "$LOG_FILE"

[[ "$OS" == "Linux" || "$OS" == *"MINGW"* || "$OS" == *"CYGWIN"* || "$OS" == *"MSYS"* ]] && {
    echo "İşlemci bilgisi:" >> "$LOG_FILE"
    wmic cpu get name >> "$LOG_FILE" 2>/dev/null
    echo "Ram bilgisi:" >> "$LOG_FILE"
    wmic memorychip get capacity, speed >> "$LOG_FILE" 2>/dev/null
    echo "Anakart bilgisi ve UUID değeri:" >> "$LOG_FILE"
    wmic baseboard get product, manufacturer >> "$LOG_FILE" 2>/dev/null
    wmic csproduct get uuid >> "$LOG_FILE" 2>/dev/null
    echo "Disk bilgisi:" >> "$LOG_FILE"
    wmic diskdrive get model, size >> "$LOG_FILE" 2>/dev/null
    echo "MAC adresi:" >> "$LOG_FILE"
    getmac >> "$LOG_FILE" 2>/dev/null
}
[[ "$OS" == "Darwin" ]] && {
    echo "İşlemci bilgisi:" >> "$LOG_FILE"
    system_profiler SPHardwareDataType | grep "Processor Name" >> "$LOG_FILE" 2>/dev/null
    system_profiler SPHardwareDataType | grep "Processor Speed" >> "$LOG_FILE" 2>/dev/null
    echo "Ram bilgisi:" >> "$LOG_FILE"
    system_profiler SPHardwareDataType | grep "Memory" >> "$LOG_FILE" 2>/dev/null
    echo "Anakart bilgisi ve UUID değeri:" >> "$LOG_FILE"
    system_profiler SPHardwareDataType | grep "Model Identifier" >> "$LOG_FILE" 2>/dev/null
    system_profiler SPHardwareDataType | grep "Hardware UUID" >> "$LOG_FILE" 2>/dev/null
    echo "Disk bilgisi:" >> "$LOG_FILE"
    system_profiler SPStorageDataType | grep -E "Media Name|Capacity" >> "$LOG_FILE" 2>/dev/null
    echo "MAC adresi:" >> "$LOG_FILE"
    ifconfig en0 | grep ether >> "$LOG_FILE" 2>/dev/null
}

echo -n "Lutfen parolanizi giriniz: "
read -s PAROLA
echo ""

gpg --batch --yes --passphrase "$PAROLA" --symmetric --cipher-algo AES256 "$LOG_FILE"

[ -f "report.log.gpg" ] && rm "$LOG_FILE" && echo "Islem basarili!"
[ -f "report.log.gpg" ] || echo "Hata!"