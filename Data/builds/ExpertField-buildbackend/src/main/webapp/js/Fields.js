function newField() {
    let name = $('#新试验田名称').val();
    let description = $('#新试验田描述').val();
    document.getElementById('加载中').classList.add('show');
    $.post("Field/new", {
        name: name,
        description: description
    }, function (data, textStatus, jqXHR) {
        document.getElementById('加载中').classList.remove('show');
        if (data.indexOf('ok') !== -1) {
            alert("新建成功");
            let ID = data.split(':')[1];
            window.location.reload();//TODO:从nodejs处请求试验田数据并动态添加
        } else
            alert("新建失败");
    });

}

let cur_qr = null;

function create_qrcode(text) {
    qrcode.stringToBytes = qrcode.stringToBytesFuncs['UTF-8'];
    var qr = qrcode("0", 'H');
    qr.addData(text, 'Byte');
    qr.make();
    document.getElementById('QR码窗口').classList.add("show");
    document.getElementById('QR码img').innerHTML = qr.createSvgTag();
    document.getElementById('QR码标题').innerText = JSON.parse(text).试验田名称;
    cur_qr = qr;
}

function save_qrcode() {
    let title = document.getElementById('QR码标题').innerText;
    let qrcode = cur_qr.createSvgTag(50);

    console.log("调用了save_qrcode\n标题=" + title + "\n要保存的qr码=" + qrcode);
    var canvas = document.createElement('canvas');  //准备空画布
    var qrimg = $('#QR码img svg');
    document.createElement('div').appendChild(canvas);
    canvg(canvas, qrcode);
    let ctx = canvas.getContext("2d");
    ctx.font = "180px '微软雅黑'";
    ctx.fillText(title, 0, 180);
    var a = document.createElement('a');
    a.href = canvas.toDataURL('image/png');  //将画布内的信息导出为png图片数据
    a.download = "二维码-" + title + '.png';  //设定下载名称
    a.click(); //点击触发下载
}

function edit_description(ID) {
    let description = $('#编辑试验田描述textarea').val();
    document.getElementById('加载中').classList.add('show');
    $.post("Field/update", {
        ID: ID,
        description: description
    }, function (data, textStatus, jqXHR) {
        document.getElementById('加载中').classList.remove('show');
        if (data === 'ok') {
            alert("修改成功");
            data_set[ID].试验田描述 = description;
            document.getElementById('编辑试验田描述div').classList.remove('show');
        } else
            alert("修改失败");
    });
}