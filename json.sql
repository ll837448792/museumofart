参考自：http://www.lnmp.cn/mysql-57-new-features-json.html

update user set authentication_string=password("Huawei@123") where user="root";


show databases;

use artmuseum;

CREATE TABLE project (
    `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
    `skill` JSON NOT NULL,
    `student` JSON NOT NULL,
    PRIMARY KEY (`id`)
);

INSERT INTO `project` (student, skill) VALUES ('{"id": 1, "name": "ggjg"}', '["java", "go", "vue"]');
INSERT INTO `project` (student, skill) VALUES ('{"id": 5, "name": "ggjg111111"}', '[]');
INSERT INTO `project` (student, skill) VALUES ('{"id": 3, "name": "lglg"}', '["php", "py", "mysql"]');
INSERT INTO `project` (student, skill) VALUES ('{"id": 4, "name": "guogege"}', '[1,2,3]');
INSERT INTO `project` (student, skill) VALUES ('{"id": 2, "name": "smallsoup"}', '["shell", "python", "js"]');

 select * from project;
 
 图片

更多生成 JSON 值的函数请参考： 
https://dev.mysql.com/doc/refman/5.7/en/json-creation-functions.html

查询 JSON
查询 json 中的数据用 column->path 的形式，其中对象类型 path 这样表示 $.path, 而数组类型则是 $[index]
SELECT id, student->'$.id', student->'$.name', skill->'$[0]', skill->'$[2]' FROM project;

图片

可以看到对应字符串类型的 category->'$.name' 中还包含着双引号，这其实并不是想要的结果，可以用 JSON_UNQUOTE 函数将双引号去掉，从 MySQL 5.7.13 起也可以通过这个操作符 ->> 这个和 JSON_UNQUOTE 是等价的

SELECT id, student->'$.name', JSON_UNQUOTE(student->'$.name'), student->>'$.name' FROM project;

图片


下面说下 JSON 作为条件进行搜索。因为 JSON 不同于字符串，所以如果用字符串和 JSON 字段比较，是不会相等的

SELECT * FROM project WHERE student = '{"id": 1, "name": "ggjg"}';

图片


这时可以通过 CAST 将字符串转成 JSON 的形式

 SELECT * FROM project WHERE student = CAST('{"id": 1, "name": "ggjg"}' as JSON);
 
 图片
 
 通过 JSON 中的元素进行查询, 对象型的查询同样可以通过 column->path
 json中的string类型做条件
  SELECT * FROM project WHERE student->'$.name' = 'ggjg';
  图片
  
 
  
  
  要特别注意的是，JSON 中的元素搜索是严格区分变量类型的，比如说整型和字符串是严格区分的
  
  SELECT * FROM project WHERE student->'$.id' = '1';  
  搜索不到
  
   json中的int类型做条件
    SELECT * FROM project WHERE student->'$.id' = 1 or student->'$.id' = 2;  
	
	SELECT * FROM project WHERE json_extract(student,'$.id') = 1;
	
	SELECT * FROM project WHERE JSON_CONTAINS[skill, "java"];  
	
  
可以看到搜索字符串 1 和整型 1 的结果是不一样的。

除了用 column->path 的形式搜索，还可以用JSON_CONTAINS 函数，但和 column->path 的形式有点相反的是，JSON_CONTAINS 第二个参数是不接受整数的，无论 json 元素是整型还是字符串，否则会出现这个错误

图片
SELECT * FROM project WHERE JSON_CONTAINS(student, 1, '$.id');
ERROR 3146 (22032): Invalid data type for JSON data in argument 2 to function json_contains; a JSON string or JSON type is required.

这里必须是要字符串 1

 SELECT * FROM project WHERE JSON_CONTAINS(student, '1', '$.id');
 图片
 
 对于数组类型的 JSON 的查询，比如说 skill 中包含有 3 的数据，同样要用 JSON_CONTAINS 函数，同样第二个参数也需要是字符串
 
 SELECT * FROM project WHERE JSON_CONTAINS(skill, '2');
 
 
 更多搜索 JSON 值的函数请参考：http://dev.mysql.com/doc/refman/5.7/en/json-search-functions.html

https://www.jianshu.com/p/d294baa873ff
