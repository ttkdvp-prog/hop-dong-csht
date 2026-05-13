$formInPath = "d:\OneDrive - VNPT\AI\thueCSHT\vercel-static-hopdong\form_in.html"
$camKetPath = "d:\OneDrive - VNPT\AI\thueCSHT\vercel-static-hopdong\cam_ket.html"

# Function to process file
function Process-HtmlFile {
    param([string]$FilePath)
    
    $html = Get-Content -Path $FilePath -Raw -Encoding UTF8

    # 1. Tờ trình title bold and straight
    if ($FilePath -match "cam_ket") {
        $html = $html -replace 'class="center bold italic" style="margin-bottom: 20px;">Về việc xem xét thanh toán', 'class="center bold" style="margin-bottom: 20px;">Về việc xem xét thanh toán'
    }

    # 2. Capitalize name in JS
    $jsFunc = @"
                        // Capitalize name function
                        const toTitleCase = (str) => {
                            if (!str) return '...';
                            return String(str).toLowerCase().split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
                        };
"@
    if ($html -notmatch "const toTitleCase =") {
        $html = $html -replace "const setTextForAll = \(className, text\) => \{", ($jsFunc + "`n                        const setTextForAll = (className, text) => {")
    }

    $html = $html -replace "setTextForAll\('Ben_A_Ho_Ten', data.HoTen\);", "setTextForAll('Ben_A_Ho_Ten', toTitleCase(data.HoTen));"

    # 3 & 4. Reduce spacing
    if ($FilePath -match "cam_ket") {
        $html = $html -replace '\.signature-space \{ height: 100px; \}', '.signature-space { height: 60px; }'
        $html = $html -replace 'p \{ margin: 5px 0;', 'p { margin: 3px 0;'
        $html = $html -replace 'margin-bottom: 20px;', 'margin-bottom: 10px;'
        $html = $html -replace 'margin-bottom: 15px;', 'margin-bottom: 8px;'
        $html = $html -replace 'margin-top: 15px;', 'margin-top: 8px;'
    }

    # 5. Handle "ông/bà"
    $html = $html -replace '(?<!<span class="data-field Ben_A_Danh_Xung">)ông/bà(?!</span>)', '<span class="data-field Ben_A_Danh_Xung">ông/bà</span>'
    $html = $html -replace '(?<!<span style="text-transform: capitalize;" class="data-field Ben_A_Danh_Xung">)Ông/bà(?!</span>)', '<span style="text-transform: capitalize;" class="data-field Ben_A_Danh_Xung">Ông/bà</span>'

    $jsDanhXung = @"
                        let danhXung = 'ông/bà';
                        if (data.GioiTinh) {
                            if (String(data.GioiTinh).toLowerCase() === 'nam') danhXung = 'ông';
                            else if (String(data.GioiTinh).toLowerCase() === 'nữ' || String(data.GioiTinh).toLowerCase() === 'nu') danhXung = 'bà';
                        }
                        setTextForAll('Ben_A_Danh_Xung', danhXung);
"@
    if ($html -notmatch "setTextForAll\('Ben_A_Danh_Xung'") {
        $html = $html -replace "setTextForAll\('So_Hop_Dong', data.SoHopDong\);", ($jsDanhXung + "`n                        setTextForAll('So_Hop_Dong', data.SoHopDong);")
    }

    $html | Set-Content -Path $FilePath -Encoding UTF8
}

Process-HtmlFile $formInPath
Process-HtmlFile $camKetPath
