function editExperiment(ID,description,format,callback) {
    let postdata={ID:ID};
    if(description!=null)
        postdata.description=description;
    if(format!=null)
        postdata.format=format;
    $.post("Experiment/update",postdata,callback);
}

function editDescription(ID) {
    let description = $('#试验描述编辑textarea').val();
    document.getElementById('加载中').classList.add('show');
    editExperiment(ID,description,null,function (data, textStatus, jqXHR) {
        document.getElementById('加载中').classList.remove('show');
        if(data==='ok'){
            alert("修改成功");
            data_set.试验描述=description;
        }
        else
            alert("修改失败");
    });
    document.getElementById('试验描述编辑div').classList.remove('show');
}
