const fs = require('fs');

function processFile(file) {
    let html = fs.readFileSync(file, 'utf8');

    if (file.includes('cam_ket.html')) {
        html = html.replace('class="center bold italic" style="margin-bottom: 20px;">Về việc xem xét thanh toán', 'class="center bold" style="margin-bottom: 20px;">Về việc xem xét thanh toán');
        html = html.replace('p { margin: 5px 0;', 'p { margin: 3px 0;');
        html = html.replace('p { margin: 5px 0;', 'p { margin: 3px 0;'); // Replace in JS string too
        html = html.replace('.signature-space { height: 100px; }', '.signature-space { height: 65px; }');
        html = html.replace('.signature-space { height: 100px; }</style>', '.signature-space { height: 65px; }</style>');
    }

    // Capitalize name
    const jsFunc = `
                        const toTitleCase = (str) => {
                            if (!str) return '...';
                            return String(str).toLowerCase().split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
                        };
`;
    if (!html.includes('const toTitleCase')) {
        html = html.replace('const setTextForAll = (className, text) => {', jsFunc + '                        const setTextForAll = (className, text) => {');
    }
    html = html.replace("setTextForAll('Ben_A_Ho_Ten', data.HoTen);", "setTextForAll('Ben_A_Ho_Ten', toTitleCase(data.HoTen));");

    // Replace ông/bà
    // First, undo any previous replacement just in case
    html = html.replace(/<span[^>]*class="data-field Ben_A_Danh_Xung"[^>]*>ông\/bà<\/span>/g, 'ông/bà');
    html = html.replace(/<span[^>]*class="data-field Ben_A_Danh_Xung"[^>]*>Ông\/bà<\/span>/g, 'Ông/bà');
    
    // Now apply fresh replacement
    html = html.replace(/ông\/bà/g, '<span class="data-field Ben_A_Danh_Xung">ông/bà</span>');
    html = html.replace(/Ông\/bà/g, '<span style="text-transform: capitalize;" class="data-field Ben_A_Danh_Xung">Ông/bà</span>');

    const jsDanhXung = `
                        let danhXung = 'ông/bà';
                        if (data.GioiTinh) {
                            if (String(data.GioiTinh).toLowerCase() === 'nam') danhXung = 'ông';
                            else if (String(data.GioiTinh).toLowerCase() === 'nữ' || String(data.GioiTinh).toLowerCase() === 'nu') danhXung = 'bà';
                        }
                        setTextForAll('Ben_A_Danh_Xung', danhXung);
`;
    if (!html.includes("setTextForAll('Ben_A_Danh_Xung'")) {
        html = html.replace("setTextForAll('So_Hop_Dong', data.SoHopDong);", jsDanhXung + "                        setTextForAll('So_Hop_Dong', data.SoHopDong);");
    }

    fs.writeFileSync(file, html, 'utf8');
}

processFile('d:/OneDrive - VNPT/AI/thueCSHT/vercel-static-hopdong/form_in.html');
processFile('d:/OneDrive - VNPT/AI/thueCSHT/vercel-static-hopdong/cam_ket.html');
