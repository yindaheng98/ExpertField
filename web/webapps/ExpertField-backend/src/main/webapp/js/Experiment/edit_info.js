function editExperiment(ID, description, format, callback) {
    let postdata = {ID: ID};
    if (description != null)
        postdata.description = description;
    if (format != null)
        postdata.format = JSON.stringify(format);
    $.post("Experiment/update", postdata, callback);
}

function editDescription(ID) {
    let description = $('#试验描述编辑textarea').val();
    document.getElementById('加载中').classList.add('show');
    editExperiment(ID, description, null, function (data, textStatus, jqXHR) {
        document.getElementById('加载中').classList.remove('show');
        if (data === 'ok') {
            alert("修改成功");
            data_set.试验描述 = description;
        } else
            alert("修改失败");
    });
    document.getElementById('试验描述编辑div').classList.remove('show');
}

function hide_edit_format() {
    $('.删除数据格式字段').hide();
    $('#新增数据格式字段').hide();
    $('#编辑试验数据格式').show();
    $('#取消编辑试验数据格式').hide();

}

function show_edit_format() {
    $('.删除数据格式字段').show();
    $('#新增数据格式字段').show();
    $('#编辑试验数据格式').hide();
    $('#取消编辑试验数据格式').show();
}

function deleteFormat(ID, format_name) {
    let new_format = JSON.parse(JSON.stringify(data_set.试验数据格式));
    delete new_format[format_name];
    document.getElementById('加载中').classList.add('show');
    editExperiment(ID, null, new_format, function (data, textStatus, jqXHR) {
        document.getElementById('加载中').classList.remove('show');
        if (data === 'ok') {
            alert("修改成功");
            data_set.试验数据格式 = new_format;
        } else
            alert("修改失败");
    });
}

function newFormat(ID) {
    let name = document.getElementById('新增数据格式字段名').value;
    if (!name) return;
    let type = document.getElementById('新增数据格式字段数据类型').value;
    if(type==='enum')
        type=JSON.stringify(document.getElementById('enum候选字段').value.split(','));
    let new_format = JSON.parse(JSON.stringify(data_set.试验数据格式));
    new_format[name] = type;
    document.getElementById('加载中').classList.add('show');
    editExperiment(ID, null, new_format, function (data, textStatus, jqXHR) {
        document.getElementById('加载中').classList.remove('show');
        if (data === 'ok') {
            alert("修改成功");
            data_set.试验数据格式 = new_format;
        } else
            alert("修改失败");
    });
}