#!/bin/bash
# İsim SOYİSİM: Atakan KORKMAZ
# Öğrenci Numarası: 2420171028
# Sertifika Bağlantıları: https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=nKqhn7NELB
#                         https://www.btkakademi.gov.tr/portal/certificate/validate?certificateId=pKmhqJpE7Z
#                         https://credsverse.com/credentials/0403af7d-dbec-4f62-b6f4-5e16d879e597

LOG_FILE="report.log"
OS="$(uname -s)"

date -u +"%Y-%m-%dT%H:%M:%SZ" > "$LOG_FILE"

[[ "$OS" == "Linux" || "$OS" == *"MINGW"* || "$OS" == *"CYGWIN"* || "$OS" == *"MSYS"* ]] && {
    echo "=== İşlemci Bilgisi ===" >> "$LOG_FILE"
    wmic cpu get Manufacturer, Name >> "$LOG_FILE" 2>/dev/null
    
    echo "=== RAM Bilgisi ===" >> "$LOG_FILE"
    wmic memorychip get Manufacturer, PartNumber, SerialNumber, Capacity >> "$LOG_FILE" 2>/dev/null
    
    echo "=== Anakart Bilgisi ve UUID Değeri ===" >> "$LOG_FILE"
    wmic baseboard get Manufacturer, Product, SerialNumber >> "$LOG_FILE" 2>/dev/null
    wmic csproduct get uuid >> "$LOG_FILE" 2>/dev/null
    
    echo "=== Disk Bilgisi ===" >> "$LOG_FILE"
    wmic diskdrive get Manufacturer, Model, SerialNumber, Size >> "$LOG_FILE" 2>/dev/null
    
    echo "=== MAC Adresi ===" >> "$LOG_FILE"
    getmac >> "$LOG_FILE" 2>/dev/null
}

[[ "$OS" == "Darwin" ]] && {
    echo "=== İşlemci Bilgisi ===" >> "$LOG_FILE"
    system_profiler SPHardwareDataType | grep -E "Processor Name|Processor Speed" >> "$LOG_FILE" 2>/dev/null
    
    echo "=== RAM Bilgisi ===" >> "$LOG_FILE"
    system_profiler SPMemoryDataType | grep -E "Manufacturer|Part Number|Serial Number|Size" >> "$LOG_FILE" 2>/dev/null
    
    echo "=== Anakart Bilgisi ve UUID Değeri ===" >> "$LOG_FILE"
    system_profiler SPHardwareDataType | grep -E "Model Identifier|Hardware UUID|Serial Number" >> "$LOG_FILE" 2>/dev/null
    
    echo "=== Disk Bilgisi ===" >> "$LOG_FILE"
    system_profiler SPStorageDataType | grep -E "Media Name|Capacity|Protocol" >> "$LOG_FILE" 2>/dev/null
    
    echo "=== MAC Adresi ===" >> "$LOG_FILE"
    ifconfig en0 | grep ether >> "$LOG_FILE" 2>/dev/null
}

echo -n "Lutfen parolanizi giriniz: "
read -rs PAROLA_RAW
echo ""

PAROLA=$(echo -n "$PAROLA_RAW" | tr -d '\r' | tr -d '\n')

echo "$PAROLA" | gpg --batch --yes --pinentry-mode loopback --passphrase-fd 0 --symmetric --cipher-algo AES256 "$LOG_FILE"

[ -f "report.log.gpg" ] && rm "$LOG_FILE" && echo "Islem basarili! Dosya AES256 ile sifrelendi."
[ -f "report.log.gpg" ] || echo "Hata! Sifreleme yapilamadi."