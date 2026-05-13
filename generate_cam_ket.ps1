$html = Get-Content -Raw -Encoding UTF8 form_in.html
$html = $html -replace '<title>In Hợp Đồng Thuê CSHT</title>', '<title>In Bản Cam Kết</title>'
$html = $html -replace 'Đang tải dữ liệu hợp đồng...', 'Đang tải dữ liệu bản cam kết...'

$pattern = '(?s)<div id="content">.*?</script>'
$newContent = @"
<div id="content">
    <div class="print-page">
        <div class="center bold">
            CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM<br>
            Độc lập - Tự do - Hạnh phúc<br>
            --------------------
        </div>
        <div class="italic" style="margin-left: 50%; text-align: center;">Phú Thọ, ngày <span class="data-field Ngay_Ky_Day">...</span> tháng <span class="data-field Ngay_Ky_Month">...</span> năm <span class="data-field Ngay_Ky_Year">...</span></div>
        
        <div class="center title" style="margin-top: 15px;">BẢN CAM KẾT</div>
        <div class="center bold italic" style="margin-bottom: 20px;">Về nguồn gốc, quá trình sử dụng mặt bằng phục vụ trạm viễn thông</div>
        
        <p class="bold italic">Kính gửi: Viễn thông Phú Thọ</p>
        <p>Tôi tên là: <span class="data-field bold Ben_A_Ho_Ten">...</span></p>
        <p>Sinh ngày: <span class="data-field Ben_A_Ngay_Sinh">...</span></p>
        <p>Số CCCD/căn cước: <span class="data-field Ben_A_CCCD">...</span> cấp ngày <span class="data-field Ben_A_Ngay_Cap">...</span> tại <span class="data-field Ben_A_Noi_Cap">...</span></p>
        <p>Địa chỉ thường trú: <span class="data-field Ben_A_Dia_Chi">...</span></p>
        <p>Số điện thoại liên hệ: <span class="data-field Ben_A_SDT">...</span></p>
        <p>Hiện nay, tôi là người đang trực tiếp quản lý, sử dụng phần mặt bằng tại: <span class="data-field Dia_Chi_Tram">...</span></p>
        <p>Phần mặt bằng nêu trên hiện đang được cho Viễn thông Phú Thọ thuê để lắp đặt, duy trì trạm viễn thông mã trạm/tên trạm: <span class="data-field Ma_Tram">...</span> / <span class="data-field Vi_Tri_Thue">...</span> theo hồ sơ/hợp đồng đã thực hiện từ giai đoạn trước.</p>
        
        <p>Tôi xin cam kết với Viễn thông Phú Thọ các nội dung sau:</p>
        <p>1/ Chịu trách nhiệm về nguồn gốc, quá trình quản lý, sử dụng phần mặt bằng đang cho Viễn thông Phú Thọ sử dụng để lắp đặt, duy trì trạm viễn thông. Tôi cam kết tại thời điểm hiện tại phần mặt bằng nêu trên do tôi quản lý, sử dụng ổn định; chưa phát sinh tranh chấp, khiếu kiện; Trường hợp sau này phát sinh tranh chấp, khiếu kiện đối với phần mặt bằng nêu trên, làm ảnh hưởng đến việc duy trì, vận hành trạm viễn thông hoặc làm phát sinh thiệt hại, chi phí cho Viễn thông Phú Thọ, tôi cam kết phối hợp giải quyết với các bên liên quan và cơ quan có thẩm quyền; đồng thời hoàn trả các khoản tiền đã nhận không có căn cứ và bồi hoàn thiệt hại, chi phí phát sinh cho Viễn thông Phú Thọ theo quy định.</p>
        <p>2/ Tạo điều kiện cho Viễn thông Phú Thọ và các đơn vị liên quan ra, vào vị trí trạm để vận hành, kiểm tra, bảo dưỡng, sửa chữa, xử lý sự cố, ứng cứu thông tin theo yêu cầu của Viễn thông Phú Thọ. Trường hợp phải điều chỉnh, di dời trạm theo yêu cầu của cơ quan Nhà nước hoặc theo nhu cầu của Viễn thông Phú Thọ tôi cam kết phối hợp, tạo điều kiện để Viễn thông Phú Thọ kiểm tra, tháo dỡ, di chuyển, thu hồi thiết bị theo kế hoạch của đơn vị.</p>
        <p>Tôi cam kết thực hiện đúng các điều khoản trong hợp đồng cho thuê mặt bằng đã ký với Viễn thông Phú Thọ và không có yêu cầu nào khác liên quan đến việc Viễn thông Phú Thọ sử dụng phần mặt bằng nêu trên.</p>
        <p>Tôi đã đọc, hiểu rõ toàn bộ nội dung cam kết này và tự nguyện ký tên dưới đây. Mọi thông tin tôi cung cấp là đúng sự thật; nếu sai, tôi xin hoàn toàn chịu trách nhiệm trước pháp luật và trước Viễn thông Phú Thọ.</p>
        
        <div class="signature-box">
            <div class="signature-col"></div>
            <div class="signature-col">
                <span class="bold">NGƯỜI CAM KẾT</span><br>
                (Ký, ghi rõ họ tên)<br>
                <div class="signature-space"></div>
                <span class="data-field bold Ben_A_Ho_Ten">...</span>
            </div>
        </div>
    </div>
</div>
<script>
"@
$html = $html -replace $pattern, $newContent

$scriptPattern = "(?s)setTextForAll\('Dien_Tich_Thue', data\.DienTichThue_m2\);"
$scriptAdditions = "setTextForAll('Dien_Tich_Thue', data.DienTichThue_m2); setTextForAll('Dia_Chi_Tram', data.DiaChiTram); if (data.NgaySinh) { const dateSinh = new Date(data.NgaySinh); if (!isNaN(dateSinh.getTime())) { setTextForAll('Ben_A_Ngay_Sinh', dateSinh.toLocaleDateString('vi-VN')); } }"

$html = $html -replace $scriptPattern, $scriptAdditions

$html | Set-Content -Encoding UTF8 cam_ket.html
