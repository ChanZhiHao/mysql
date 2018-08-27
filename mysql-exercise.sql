create database if not exists NIIT CHARACTER set utf8;
use NIIT;

create table if not exists stu
( rollno int primary key auto_increment,
  stu_name varchar(50) not null,
  gender char(1) default 'M',
  tel varchar(11) unique
)ENGINE=InnoDB;

create table course
(
course_id int primary key,
course_name varchar(50)
)ENGINE=InnoDB;
create table mark
(
mark_id int primary key,
stu_id int,
course_id int,
score int,
foreign key (stu_id) references stu(rollno),
foreign key (course_id) references course(course_id)
)ENGINE=InnoDB;
insert into stu(stu_name,gender,tel) values
('Amy','M','17822220001'),
('Bob','F','17822220002'),
('Cindy','M','17822220003'),
('Dandy','F','17822220004'),
('Steve','F','17822220005');
insert into course values
(001,'Math'),
(002,'English'),
(003,'Chinese');
insert into mark values
(0001,1,001,90),
(0002,1,002,89),
(0003,1,003,60),
(0004,2,001,70),
(0005,2,002,85),
(0006,3,001,40),
(0007,3,002,25),
(0008,3,003,04),
(0009,4,002,45),
(0010,4,003,64),
(0011,5,001,70),
(0012,5,002,80);



create user 'niit'@'%' identified by 'niit';
grant select,insert,update,delete on NIIT.* to 'niit'@'%';

select stu.rollno,stu_name,mark.score from stu join mark where stu.rollno=mark.stu_id and mark.score is not null;
select stu.rollno,stu_name,course.course_name,mark.score from course inner join mark on course.course_id=mark.course_id  join  stu on stu.rollno=mark.stu_id ;
select stu.rollno,stu_name,max(mark.score) from stu join mark where stu.rollno=mark.stu_id and mark.score is not null;
select stu.rollno,stu_name,max(mark.score) from stu join mark where stu.rollno=mark.stu_id group by mark.course_id;

delimiter //
create procedure proc_avglevel(in search_stu_id int,out level varchar(50))
begin
	declare avg int;
    select avg(mark.score) into avg from stu join mark where stu.rollno=mark.stu_id and mark.stu_id=search_stu_id ;
	if avg > 80 then
    set level= '优秀';
    
    else if avg between 70 and 80 then set level= '良好';
    else if avg between 60 and 70 then set level= '一般';
    else set level= '不及格';
    end if;
    end if;
    end if;
end

//
delimiter ;
call proc_avglevel(2,@level);
select @level;
drop  procedure proc_avglevel;


DELIMITER //
CREATE FUNCTION Course_Avg(cid int) 
RETURNS double
BEGIN
declare avg float;
select avg(score)  into avg from mark where course_id=cid;
return avg;
END//
select  Course_Avg(001);

delimiter //
create trigger delete_stu before delete on stu for each row 
begin
	if exists(select * from stu,mark where stu.rollno=mark.stu_id) then
		signal sqlstate '45000'
		set message_text='先删除成绩再删除学生';
    end if;
end;
//
delimiter ;
delete from stu where rollno=1;
select  *from  mark;