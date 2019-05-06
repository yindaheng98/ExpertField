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

function show_edit_field() {
}

function add_field(ID) {
    let fieldID = document.getElementById('选择新增试验田').value;
    document.getElementById('加载中').classList.add('show');
    $.post("ExpertField/new", {
        experimentID: ID,
        fieldID: fieldID
    }, function (data, textStatus, jqXHR) {
        document.getElementById('加载中').classList.remove('show');
        if (data.indexOf('ok') !== -1) {
            alert("添加成功");
            let field = JSON.parse(JSON.stringify(data_set.所有试验田[fieldID]));
            field.试验数据 = {};
            data_set.试验田[fieldID] = field;
        } else
            alert("添加失败");
    })
}

function deleteData(dataID, fieldID) {
    document.getElementById('加载中').classList.add('show');
    $.post("Data/delete", {ID: dataID}, function (data, textStatus, jqXHR) {
        if (data.indexOf('ok') !== -1) {
            document.getElementById('加载中').classList.remove('show');
            alert("删除成功");
            delete data_set.试验田[fieldID].试验田数据[dataID];
            window.location.reload();
        } else
            alert("删除失败");
    })
}

function delete_field(ID, fieldID) {
    document.getElementById('加载中').classList.add('show');
    $.post("ExpertField/del", {experimentID: ID, fieldID: fieldID}, function (data, textStatus, jqXHR) {
        if (data.indexOf('ok') !== -1) {
            document.getElementById('加载中').classList.remove('show');
            alert("删除成功");
            delete data_set.试验田[fieldID];
            window.location.reload();
        } else
            alert("删除失败");
    })
}

function edit_metadata(dataID, ele, fieldID) {
    let newdata = {};
    $(ele).prev().prev().find('input').each(function () {
        newdata[$(this).attr('name')] = $(this).val();
    });
    document.getElementById('加载中').classList.add('show');
    $.post("Data/update", {ID: dataID, data: JSON.stringify(newdata)}, function (data, textStatus, jqXHR) {
        if (data.indexOf('ok') !== -1) {
            document.getElementById('加载中').classList.remove('show');
            alert("修改成功");
            data_set.试验田[fieldID].试验田数据[dataID] = newdata;
            $(ele).parent().hide();
            $(ele).parent().prev().show();
            window.location.reload();
        } else
            alert("修改失败");
    })
}