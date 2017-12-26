
--a)istenen departmanda çalýþanlarýn isimleri ve adreslerini göster

SELECT E.Fname,E.Lname,E.Address
FROM Employee E,Department D
WHERE D.DNumber=E.Dno AND D.DName='muhasebe'

--b)istenen þehirdeki çalýþanlarýn isimleri ,doðumu, projeleri göster.inner

SELECT P.PNumber,E.Lname,E.Address,E.Bdate
FROM Employee E,Project P
WHERE P.DNum=E.Dno AND P.Plocations='çin'

--c)iliþkisi olan tüm çalýþanlarýn isimlerini göster.

SELECT E.Fname,E.Lname,D.Dependent_name
FROM Employee E,Dependent D
WHERE E.Ssn=D.Essn

--d)çalýþanlarý ve projelerini göster.departmanlara göre listele.
--departmanlardaki çalýþanlarýn soyisimlerine göre alfabetik olarak sýralar

SELECT E.Lname, E.Fname,P.PName
FROM Employee E,Project P
WHERE P.DNum=E.Dno ORDER BY E.Lname ASC

--e)istenen departmandaki,ortalama,min,max maaþlarý getir.

SELECT 
SUM(E.Salary) AS Toplam, 
MAX(E.Salary) AS maximum  ,
MIN(E.Salary) AS minumum ,
AVG(E.Salary)  AS Ortalama
FROM Employee E,Department D
WHERE D.DNumber=E.Dno AND D.DName='alýþ' 

--f)her proje için isimlerini,nolarýný ve kaç kiþi çalýþtýðýný getir.numara ve isimi istediði için
SELECT    Pnumber, PName, COUNT (*)
FROM	  Project, Works_on
WHERE	  Pnumber = Pno
GROUP BY  Pnumber, PName


--g) Create AFTER INSERT TRIGGER on the Department table. This trigger also insert records into Dept_Locations.default a ata
alter trigger Dept_LocationEkleme on Department
FOR insert
as
 declare @dnumber int;
 declare @dname nvarchar(50);
 declare @Mgr_ssn int;
 declare @Mgr_start_date datetime;
 declare @dlocation  nvarchar(50);
 select @dnumber=i.DNumber from inserted i;
  select @dlocation='Fransa';--DEFAULT OLARAK GÝRÝLDÝ.
 --güncelleme iþi sanal tablodan giriliyor.
 
 insert into Department
 (Dname,Dnumber,Mgr_ssn ,Mgr_start_date)
 values(@dname,@dnumber,@Mgr_ssn,@Mgr_start_date);

 insert into Dept_Locations
(Dnumber,Dlocations)
values(@dnumber,@dlocation);

 
--h)Create instead of TRIGGER on the Employee table. This trigger also delete corresponding records from Dependent table.

CREATE TRIGGER DependentSilme ON Employee
INSTEAD OF DELETE
AS
DECLARE @Essn int;
SELECT @Essn=d.Ssn FROM deleted d;


DELETE FROM  Dependent WHERE Dependent.Essn=@Essn;


-- i) Create AFTER UPDATE TRIGGER on the Project table. This trigger print message which column is updated,
--  i.e. when Pname column is updated “Project name is updated” is displayed. 
--  The messages and updated record Pnumber is stored in a table named as ProjectLog table.

alter TRIGGER ProjectUpdate ON Project
FOR UPDATE
AS
declare @Pnumber int;
declare @MPname nvarchar(50);
declare @MPnumber int;
declare @MPlocations nvarchar(50);
declare @MDnum int;

select @MPname=i.Pname from inserted i;
select @MPnumber=i.Pnumber from inserted i;
select @Pnumber=i.Pnumber from inserted i;
select @MPlocations=i.Plocations from inserted i;
select @MDnum=i.Dnum from inserted i;
 
if update(Pname)
set @MPname='Proje ismi güncellendi.';
if update(Pnumber)
set @MPnumber='Proje numarasý güncellendi.';
if update(Plocations)
set @MPlocations ='Proje lokasyonu güncellendi.';
if update(Dnum)
set @MDnum = 'FK Department numarasý güncellendi.';

insert into  ProjectLog
(Pnumber,MPname,MPlocations,MDnum,MPnumber)
values(@Pnumber,@MPname,@MPlocations,@MDnum,@MPnumber);

PRINT 'UPDATE Trigger çalýþtý.'

