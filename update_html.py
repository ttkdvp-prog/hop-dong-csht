import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        html = f.read()

    # 1. Change Tờ trình title to bold and straight (non-italic)
    if 'cam_ket.html' in filepath:
        html = html.replace('class="center bold italic" style="margin-bottom: 20px;">Về việc xem xét thanh toán',
                            'class="center bold" style="margin-bottom: 20px;">Về việc xem xét thanh toán')

    # 2. Capitalize name in JS
    js_func = """
                        // Capitalize name function
                        const toTitleCase = (str) => {
                            if (!str) return '...';
                            return str.toLowerCase().split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
                        };
"""
    if "const toTitleCase =" not in html:
        html = html.replace("const setTextForAll = (className, text) => {", js_func + "\n                        const setTextForAll = (className, text) => {")

    # Change how HoTen is set
    html = html.replace("setTextForAll('Ben_A_Ho_Ten', data.HoTen);", "setTextForAll('Ben_A_Ho_Ten', toTitleCase(data.HoTen));")

    # 3 & 4. Reduce spacing
    if 'cam_ket.html' in filepath:
        html = html.replace('.signature-space { height: 100px; }', '.signature-space { height: 60px; }')
        html = html.replace('p { margin: 5px 0;', 'p { margin: 3px 0;')
        # also reduce some margin-bottoms
        html = html.replace('margin-bottom: 20px;', 'margin-bottom: 10px;')
        html = html.replace('margin-bottom: 15px;', 'margin-bottom: 8px;')
        html = html.replace('margin-top: 15px;', 'margin-top: 8px;')

    # 5. Handle "ông/bà" -> data-field Ben_A_Danh_Xung
    # Replace literal "ông/bà" in text with the span.
    # Note: case sensitive. We should replace "ông/bà " and "ông/bà" but not mess up JS.
    # Let's replace "do ông/bà" -> "do <span class="data-field Ben_A_Danh_Xung">ông/bà</span>"
    # "hiện do ông/bà" -> "hiện do <span class="data-field Ben_A_Danh_Xung">ông/bà</span>"
    html = html.replace("ông/bà", '<span class="data-field Ben_A_Danh_Xung">ông/bà</span>')
    html = html.replace("Ông/bà", '<span style="text-transform: capitalize;" class="data-field Ben_A_Danh_Xung">Ông/bà</span>')

    # Add the JS logic for danhXung
    js_danh_xung = """
                        let danhXung = 'ông/bà';
                        if (data.GioiTinh) {
                            if (data.GioiTinh.toLowerCase() === 'nam') danhXung = 'ông';
                            else if (data.GioiTinh.toLowerCase() === 'nữ' || data.GioiTinh.toLowerCase() === 'nu') danhXung = 'bà';
                        }
                        setTextForAll('Ben_A_Danh_Xung', danhXung);
"""
    if "setTextForAll('Ben_A_Danh_Xung'" not in html:
        html = html.replace("setTextForAll('So_Hop_Dong', data.SoHopDong);", js_danh_xung + "\n                        setTextForAll('So_Hop_Dong', data.SoHopDong);")

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(html)

process_file('d:/OneDrive - VNPT/AI/thueCSHT/vercel-static-hopdong/form_in.html')
process_file('d:/OneDrive - VNPT/AI/thueCSHT/vercel-static-hopdong/cam_ket.html')
