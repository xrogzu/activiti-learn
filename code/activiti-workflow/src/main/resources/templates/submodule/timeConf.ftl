<div class="my-time-conf">
<#--已部署的流程-->
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>已部署的流程</legend>
    </fieldset>
    <div class="layui-form">
        <table class="layui-table">
            <colgroup>
                <col width="150">
                <col width="80">
                <col width="150">
                <col width="400">
                <col width="400">
                <col width="200">
            </colgroup>
            <thead>
            <tr>
                <th>ID</th>
                <th>部署ID</th>
                <th>工作流名称</th>
                <th>工作流资源</th>
                <th>流程图资源</th>
                <th>Key</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>assessment:1:6</td>
                <td>1</td>
                <td>My Process</td>
                <td>/apache-tomcat-8.0.45/webapps/activiti-explorer/WEB-INF/classes/org/activiti/explorer/conf</td>
                <td>/apache-tomcat-8.0.45/webapps/activiti-explorer/WEB-INF/classes/org/activiti/explorer/conf</td>
                <td>assessment</td>
            </tr>
            </tbody>
        </table>
    </div>
    <br>
    <br>
<#--课程配置-->
    <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
        <legend>课程配置</legend>
    </fieldset>
    <div class="layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">课程代码</label>
            <div class="layui-input-block">
                <input type="text" name="courseCode" lay-verify="required" placeholder="请输入" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">课程名称</label>
            <div class="layui-input-block">
                <input type="text" name="courseName" lay-verify="required" placeholder="请输入" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">GitHub地址</label>
            <div class="layui-input-block">
                <input type="text" name="githubAddress" lay-verify="required" placeholder="请输入" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">互评开始</label>
                <div class="layui-input-inline">
                    <input type="text" lay-verify="required" name="judgeStartTime"
                           class="layui-input my-time-conf-judgeStartTime"
                           placeholder="yyyy-MM-dd HH:mm:ss">
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">互评结束</label>
                <div class="layui-input-inline">
                    <input type="text" lay-verify="required" name="judgeEndTime"
                           class="layui-input my-time-conf-judgeEndTime"
                           placeholder="yyyy-MM-dd HH:mm:ss">
                </div>
            </div>
            <#--<div class="layui-inline">-->
                <#--<label class="layui-form-label">成绩发布</label>-->
                <#--<div class="layui-input-inline">-->
                    <#--<input type="text" lay-verify="required" name="publishTime"-->
                           <#--class="layui-input my-time-conf-publishTime"-->
                           <#--placeholder="yyyy-MM-dd HH:mm:ss">-->
                <#--</div>-->
            <#--</div>-->
        </div>
        <div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit="" lay-filter="my-time-conf-submit">立即提交</button>
                <button type="reset" class="my-time-conf-cancel layui-btn layui-btn-primary">重置</button>
            </div>
        </div>
    </div>
    <br>
    <br>
    <fieldset class="layui-elem-field" style="margin-top: 30px;">
        <legend>已配置的课程</legend>
        <div>
            <table class="my-time-conf-table" lay-filter="my-time-conf-table">
            </table>
            <div style="margin-left: 15%;" id="my-time-conf-LayPage"></div>
        </div>
    </fieldset>

</div>

<script>
    layui.use(['form', 'layedit', 'laydate', 'table', 'laypage'], function () {
        var form = layui.form, layer = layui.layer, layedit = layui.layedit, laydate = layui.laydate, $ = layui.jquery;
        var table = layui.table;
        var laypage = layui.laypage;
        var list = ['startTime', 'commitEndTime', 'judgeStartTime', 'judgeEndTime', 'auditStartTime', 'auditEndTime', 'publishTime'];
        for (var index in list) {
            //时间选择器
            laydate.render({
                elem: '.my-time-conf-' + list[index],
                type: 'datetime'
            });
        }
        /**
         * 加载数据表格
         */
        var loadTable = function () {
            $.ajax({
                url: './api/common/countAllScheduleTime',
                dataType: 'json',
                success: function (data) {
                    laypage.render({
                        elem: 'my-time-conf-LayPage',
                        count: data.data.count,
                        theme: '#FF5722',
                        limit: 5,
                        limits: [5, 10, 15],
                        layout: ['count', 'prev', 'page', 'next', 'limit', 'skip'],
                        jump: function (obj) {
                            var param = {page: obj.curr, limit: obj.limit};
                            $.ajax({
                                url: './api/common/selectAllScheduleTime',
                                data: param,
                                dataType: 'json',
                                success: function (data) {
                                    table.render({
                                        elem: '.my-time-conf-table',
                                        data: data.data,
                                        height: 272,
                                        width: 3000,
                                        cols: [[ //标题栏
                                            {field: 'courseName', title: '课程名称', width: 150},
                                            {field: 'courseCode', title: '课程代码', width: 150},
                                            {field: 'githubAddress', title: 'GitHub地址', width: 700},
                                            {field: 'judgeStartTimeString', title: '互评开始时间', width: 200},
                                            {field: 'judgeEndTimeString', title: '互评结束时间', width: 200},
//                                            {field: 'publishTimeString', title: '成绩发布时间', width: 200},
                                            {
                                                field: 'operation',
                                                title: '操作',
                                                width: 100,
                                                templet: '#my-time-conf-operation'
                                            }
                                        ]],
                                        skin: 'row', //表格风格
                                        even: true,
                                        page: false //是否显示分页
                                    })
                                }
                            })
                        }
                    });
                }
            });
        };
        //监听提交
        form.on('submit(my-time-conf-submit)', function (data) {
            $.ajax({
                url: './api/common/insertScheduleTime',
                data: {data: JSON.stringify(data.field)},
                dataType: 'json',
                success: function (result) {
                    if (result.success) {
                        layer.alert(JSON.stringify(result), {
                            title: '部署成功'
                        });
                        loadTable();
                    }
                    else
                        layer.alert(JSON.stringify(result), {
                            title: '部署失败'
                        });
                }
            });
            return false;
        });

        $('.my-time-conf .my-time-conf-cancel').on('click', function () {
            $('.my-time-conf input').val('');
        });

        loadTable();

        table.on('tool(my-time-conf-table)', function (obj) {
            var courseCode = obj.data.courseCode;
            if (obj.event === 'delete') {
                $.ajax({
                    url: './api/common/removeScheduleTime',
                    data: {courseCode: courseCode},
                    dataType: 'json',
                    success: function (result) {
                        if (result.success) {
                            layer.open({
                                title: '操作成功',
                                shadeClose: true,
                                content: '<p>' + result.data + '<p>'
                            });
                            loadTable();
                        } else {
                            layer.open({
                                title: '操作失败',
                                shadeClose: true,
                                content: '<p>' + result.errorMessage + '<p>'
                            });
                        }
                    }
                })
            }
        });
    })
</script>

<script type="text/html" id="my-time-conf-operation">
    <a class="layui-btn layui-btn-danger layui-btn-mini" lay-event="delete">删除</a>
</script>