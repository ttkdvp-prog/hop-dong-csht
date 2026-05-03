function doGet(e) {
  // Thay ID Google Sheet của bạn vào đây
  const SHEET_ID = '1s_TLOzKvpneKTVpJql-CDqzzeQk9O3YKk6QKxL8wTGw';
  const SHEET_NAME = 'CSHT'; // Tên trang tính (sheet) chứa dữ liệu
  
  // CORS setup
  var headers = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET",
    "Access-Control-Allow-Headers": "Content-Type"
  };

  var id = e.parameter.id;
  if (!id) {
    return ContentService.createTextOutput(JSON.stringify({ error: "Missing ID" }))
                         .setMimeType(ContentService.MimeType.JSON);
  }

  try {
    var sheet = SpreadsheetApp.openById(SHEET_ID).getSheetByName(SHEET_NAME);
    if (!sheet) {
        return ContentService.createTextOutput(JSON.stringify({ error: "Sheet not found" }))
                             .setMimeType(ContentService.MimeType.JSON);
    }
    
    var data = sheet.getDataRange().getValues();
    var colHeaders = data[0];
    
    var result = null;
    for (var i = 1; i < data.length; i++) {
      var match = false;
      // Tìm ID trên tất cả các cột của hàng này
      for (var c = 0; c < data[i].length; c++) {
        if (String(data[i][c]).trim() === String(id).trim()) {
          match = true;
          break;
        }
      }
      
      if (match) { 
        result = {};
        for (var j = 0; j < colHeaders.length; j++) {
          result[colHeaders[j]] = data[i][j];
        }
        break;
      }
    }

    if (result) {
      return ContentService.createTextOutput(JSON.stringify({ success: true, data: result }))
                           .setMimeType(ContentService.MimeType.JSON);
    } else {
      return ContentService.createTextOutput(JSON.stringify({ error: "Record not found" }))
                           .setMimeType(ContentService.MimeType.JSON);
    }
  } catch (error) {
    return ContentService.createTextOutput(JSON.stringify({ error: error.message }))
                         .setMimeType(ContentService.MimeType.JSON);
  }
}
