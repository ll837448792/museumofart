# museumofart
```
curl -k -X POST http://localhost:8080/project/add -H 'Content-Type:application/json' -d '{"projectName":"666","projectDescription":"222","tenderPeriod":"3344","budget":"1000","expectedTime":"11212","attachmentList":"[name1,name2]","skillList":"[java,go,nodejs,vue]"}'
```

```json
  {
    "projectName": "666",
    "projectDescription": "222",
    "tenderPeriod": "3344",
    "budget": "1000",
    "expectedTime": "11212",
    "attachmentList": "[name1,name2]",
    "skillList": "[java,go,nodejs,vue]"
  }
```

![postman](https://github.com/ll837448792/museumofart/blob/master/postman.png)
![mysql](https://github.com/ll837448792/museumofart/blob/master/mysql.png)

ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.
mysql> alter user user() identified by "smallsoup";

update user set authentication_string=password("smallsoup") where user="root";

修改root密码
关闭服务net stop MySQL，用安全模式打开，mysqld –skip-grant-tables。这个时候，光标会一直闪。注意，千万别急按回车或者关闭，这时候千万不要动，打开另一个命令行窗口。（安装在默认C盘的Program Files文件夹里的可以直接在命令行里输入mysql的登录指令，没有安装在默认C盘的，这时候必须先进入到mysql文件夹的bin文件夹下）登录 mysql -u root -p密码为空,直接回车；就可以进去了。然后use mysql;
（可能先前的版本密码的抬头是password，5.7.11是 authentication_string,可以select * from user,查看一下）
(老版本)update user set password=password(“123456”) where user=”root”;
（5.7.11以上版本）update user set authentication_string=password(“123456”) where user=”root”;
最后，flush privileges;（ 命令本质上的作用是将当前user和privilige表中的用户信息/权限设置从mysql库(MySQL数据库的内置库)中提取到内存里。）就OK了。
