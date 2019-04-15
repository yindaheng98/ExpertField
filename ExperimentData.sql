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
语音 text,
foreign key (试验_试验田ID) references 试验_试验田(ID)
);
drop user if exists ExperimentData@localhost;
create user ExperimentData@localhost identified by 'ExperimentData';
grant select,update,insert,delete on ExperimentData.* to ExperimentData@localhost;
flush privileges;