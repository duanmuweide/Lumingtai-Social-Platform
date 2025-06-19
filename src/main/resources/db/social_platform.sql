-- 创建数据库
create database if not exists social_platform;
use social_platform;

-- 创建用户表(users)
create table users (
    uid int not null auto_increment,
    uname varchar(20) not null,
    upwd varchar(20) not null,
    uquestion varchar(255),
    uanswer varchar(255),
    ubirthday varchar(20),
    ugender boolean,
    uhobby varchar(255),
    usign varchar(255),
    uphonenumber varchar(20),
    uemail varchar(20),
    uimage varchar(255),
    primary key (uid)
) engine=innodb default charset=utf8mb4;

-- 创建帖子表(posts)
create table posts (
    pid int not null auto_increment,
    puid int not null,
    pmessage varchar(255) not null,
    pdate varchar(255) not null,
    pfile varchar(255),
    primary key (pid),
    foreign key (puid) references users(uid)
) engine=innodb default charset=utf8mb4;

-- 创建评论表(comments)
create table comments (
    cid int not null,
    cuid int not null,
    clike boolean not null,
    cfile varchar(255),
    cmessage varchar(255) not null,
    cdate varchar(255) not null,
    primary key (cid, cuid),
    foreign key (cid) references posts(pid),
    foreign key (cuid) references users(uid)
) engine=innodb default charset=utf8mb4;

-- 创建用户关系表(relationship)
create table relationship (
    rid int not null auto_increment,
    ruid int not null,
    rfiendid int not null,
    rtype int not null default 1,
    rdate varchar(20) not null,
    primary key (rid),
    foreign key (ruid) references users(uid),
    foreign key (rfiendid) references users(uid),
    constraint chk_rtype check (rtype between 1 and 5)
) engine=innodb default charset=utf8mb4;

-- 创建用户组表(usergroups)
create table usergroups (
    gid int not null auto_increment,
    gname varchar(255) not null,
    gdate varchar(255) not null,
    gimage varchar(255),
    gdescription varchar(255),
    gnumber int not null default 1,
    primary key (gid)
) engine=innodb default charset=utf8mb4;

-- 创建群成员表(groupspeople)
create table groupspeople (
    gpid int not null,
    gpuid int not null,
    gpname varchar(20),
    gpdate varchar(20) not null,
    gpidentity int not null default 1,
    primary key (gpid, gpuid),
    foreign key (gpid) references usergroups(gid),
    foreign key (gpuid) references users(uid),
    constraint chk_gpidentity check (gpidentity between 1 and 3)
) engine=innodb default charset=utf8mb4;

-- 创建群消息表(groupsconversations)
create table groupsconversations (
    gcid int not null auto_increment,
    gcgid int not null,
    gcuid int not null,
    gcmessage varchar(255) not null,
    gcdate varchar(20) not null,
    primary key (gcid),
    foreign key (gcgid) references usergroups(gid),
    foreign key (gcuid) references users(uid)
) engine=innodb default charset=utf8mb4;

-- 创建私聊消息表(conversations)
create table conversations (
    cid int not null auto_increment,
    csenderid int not null,
    creceiverid int not null,
    cmessage varchar(255) not null,
    cdate varchar(255) not null,
    primary key (cid),
    foreign key (csenderid) references users(uid),
    foreign key (creceiverid) references users(uid)
) engine=innodb default charset=utf8mb4;