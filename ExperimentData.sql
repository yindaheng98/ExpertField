set names utf8;
drop database if exists ExperimentData;
create database ExperimentData DEFAULT CHARACTER SET utf8;
use ExperimentData;
create table 试验
(
ID int primary key auto_increment,
创建时间 datetime not null,
试验名称 varchar(255) not null,
试验数据格式 json not null,
试验描述 text,
已结束 boolean default false,
unique index(试验名称,创建时间)
);
create table 试验田
(
ID int primary key auto_increment,
创建时间 datetime not null,
试验田名称 varchar(255) not null,
试验田描述 text,
unique index(试验田名称,创建时间)
);
create table 试验_试验田
(
ID int primary key auto_increment,
试验ID int not null,
试验田ID int not null,
unique index(试验ID,试验田ID),
foreign key(试验ID) references 试验(ID),
foreign key(试验田ID) references 试验田(ID)
);
create table 试验数据
(
ID int primary key auto_increment,
试验_试验田ID int not null,
录入时间 datetime not null,
数据 json,
语音 json,
foreign key (试验_试验田ID) references 试验_试验田(ID)
);
drop user if exists ExperimentData@'%';
create user ExperimentData@'%' identified WITH mysql_native_password by 'ExperimentData' PASSWORD EXPIRE NEVER;
grant select,update,insert,delete on ExperimentData.* to ExperimentData@'%';
flush privileges;

use ExperimentData;
insert into 试验(创建时间,试验名称,试验数据格式,试验描述)values
(date_sub(now(),interval 1 minute),"1秒前的某个实验",'{
"天气": ["阴","晴","雨","雪"],
"湿度": "double",
"日照情况": "int",
"谁写的": "string"
}',"我是1秒前的某个实验的实验描述"),
(date_sub(now(),interval 1 hour),"1秒前的某个实验",'{
"天气": ["阴","晴","雨","雪"],
"湿度": "double",
"日照情况": "int",
"谁写的": "string"
}',"要试一下unique有没有用就把这一条now()-2000改成now()-1000"),
(date_sub(now(),interval 1 day),"昨天的某个实验",'{
"温度": "float",
"一个很大的数": "long",
"季节": ["春","夏","秋","冬"],
"到底是谁写的": "string"
}',"我是昨天的某个实验的实验描述"),
(date_sub(now(),interval 1 month),"一个->查了一下百度->的实验",'{
"季节": ["春","夏","秋","冬"],
"温度": "float",
"一个很大的数": "long",
"究竟谁写的": "string"
}',"‘试验’说着好别扭啊，但是从百度的定义上来说中科院的院士们做的确实应该叫试验"),
(date_sub(now(),interval 2 month),"一个->说一下JSON里面这个列表->的实验",'{
"可选的变量类型": ["int","long","float","double","枚举列表"],
"我是一个bool型变量": ["是","否"],
"下雨了吗": ["下了","并没有"],
"是这几个人写的": ["ydh","scx","gyq","gch"]
}',"试验数据格式里面这个JSON列表代表枚举型变量，在界面上输入数据的时候对应一个下列框；还有就是bool型变量就用一个二元的枚举型变量代替好了");
insert into 试验(创建时间,试验名称,试验数据格式,试验描述,已结束)values
(date_sub(now(),interval 2 month),"一个->说一下里面这个已结束->的实验",'{
"可选的变量类型": ["int","long","float","double","枚举列表"],
"我是一个bool型变量": ["是","否"],
"下雨了吗": ["下了","并没有"],
"是这几个人写的": ["ydh","scx","gyq","gch"]
}',"已结束字段为true的试验不显示在填数据时的那个选择试验的界面，然后在后台管理界面显示一个‘已结束’之类的标记",true);

insert into 试验田(创建时间,试验田名称,试验田描述)values
(date_sub(now(),interval 1 second),"1秒前开的某个试验田","我是1秒前开的某个试验田的描述"),
(date_sub(now(),interval 1 day),"昨天开的某个试验田","我是昨天开的某个试验田的描述"),
(date_sub(now(),interval 1 month),"不知所云试验田","不知所云的试验田描述"),
(date_sub(now(),interval 2 month),"不明所以试验田","不明所以的试验田描述"),
(date_sub(now(),interval 3 day),"关于排序的试验田","不管查什么数据只要是设计时间的统统order by 时间"),
(date_sub(now(),interval 5 day),"冒泡排序田","冒泡排序田的试验田描述"),
(date_sub(now(),interval 1 year),"ん田","ん？"),
(date_sub(now(),interval 1 month),"还很弱田","还很弱"),
(date_sub(now(),interval 1 day),"要来了田","要来了"),
(date_sub(now(),interval 1 second),"田.UC","→↑↓→↓↑↓→↑");

insert into 试验_试验田(试验ID,试验田ID)values
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),
(2,1),(2,2),(2,3),(2,4),(2,5),(2,6),(2,7),(2,8),
(3,1),(3,2),(3,3),(3,4),(3,5),(3,6),
(4,1),(4,2),(4,3),(4,4),
(5,1),(5,2);

insert into 试验数据(试验_试验田ID,录入时间,数据,语音)values
(1,now(),'{"天气": "阴","湿度": 12.34523634645,"日照情况": 7,"谁写的": "不是我"}','["http://www.ytmp3.cn/down/60925.mp3"]'),
(1,now(),'{"天气": "测试1","湿度": 12.34523634645,"日照情况": 7,"谁写的": "不是我"}','["http://www.ytmp3.cn/down/60816.mp3"]'),
(1,now(),'{"天气": "测试2","湿度": 12.34523634645,"日照情况": 7,"谁写的": "不是我"}','["http://www.ytmp3.cn/down/60816.mp3","http://www.ytmp3.cn/down/60925.mp3"]'),
(1,now(),'{"天气": "测试3","湿度": 12.34523634645,"日照情况": 7,"谁写的": "不是我"}','["http://www.ytmp3.cn/down/60816.mp3","http://www.ytmp3.cn/down/60817.mp3"]'),
(2,now(),'{"天气": "晴","湿度": 13.0592,"日照情况": 9,"谁写的": "是他"}','["http://www.ytmp3.cn/down/60817.mp3"]'),
(2,now(),'{"天气": "测试21","湿度": 13.0592,"日照情况": 9,"谁写的": "是他"}','["http://www.ytmp3.cn/down/60817.mp3"]'),
(2,now(),'{"天气": "测试22","湿度": 13.0592,"日照情况": 9,"谁写的": "是他"}',null),
(3,now(),'{"天气": "雨","湿度": 15.344563456,"日照情况": 14,"谁写的": "是他"}',null),
(4,now(),'{"天气": "雪","湿度": 19.344563456,"日照情况": 19,"谁写的": "就是他"}',null),
(19,now(),'{"温度": 12.34523634645,"一个很大的数": 10000000000000,"季节": "春","到底是谁写的": "ん？"}',null),
(19,now(),'{"温度": 13.0592,"一个很大的数": 12000000000000,"季节": "夏","到底是谁写的": "ん？"}','["http://www.ytmp3.cn/down/60925.mp3"]'),
(19,now(),null,'["http://kolber.github.io/audiojs/demos/mp3/juicy.mp3"]');