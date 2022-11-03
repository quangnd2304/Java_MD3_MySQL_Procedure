/*
	DELIMITER &&     -->kết thúc và mở 1 vùng nhớ cache để lưu trữ procedure
    DROP PROCEDURE IF EXISTS [procedureName];
    CREATE PROCEDURE [produceName](
		-->Định nghĩa các tham số vào và tham số ra
        --> IN/OUT paramName datatype
        IN param1 int,
        IN param2 float,
        OUT param3 nvarchar(10),
        OUT param 4 bit
    )
    BEGIN
		Block SQL Statements;
    END &&
    DELIMITER &&
*/
-- 1. Tạo procedure cho phép lấy tất cả thông tin danh mục
DELIMITER &&
DROP PROCEDURE IF EXISTS proc_GetAllCatalog &&
CREATE PROCEDURE proc_GetAllCatalog()
BEGIN
	Select c.catalogId,c.catalogname from Catalog c;
END &&
DELIMITER &&
call proc_GetAllCatalog();
-- 2. Tạo procedure cho phép thêm mới 1 danh mục
DELIMITER &&
CREATE PROCEDURE proc_InsertCatalog(IN catname varchar(50))
BEGIN
	insert into Catalog(catalogname)
    values(catname);
END &&
DELIMITER &&
call proc_InsertCatalog('Danh mục Java-8');
-- 3. Viết procedure cho phép cập nhật thông tin danh mục
DELIMITER &&
CREATE PROCEDURE proc_UpdateCatalog(IN catID int, IN catname varchar(50))
BEGIN
	Update catalog
    set catalogname = catname
    where catalogid = catId;
END &&
DELIMITER &&
call proc_UpdateCatalog(7,'Danh mục cập nhật');
-- 4. Viết proceduer cho phép xóa danh mục và trả về số danh mục còn lại
/*
	CÚ PHÁP khai báo biến:
		DECLARE [variableName] [datatype] DEFAULT [value]
*/
DELIMITER &&
CREATE PROCEDURE proc_DeleteCatalog(IN catId int,OUT cnt int)
BEGIN
	-- Lấy số danh mục còn lại
	Declare soDM int default 0;
	Delete from Catalog where catalogid = catid;
    Select count(c.catalogId) into soDM from Catalog c;
    -- C2: set soDM = select count(c.catalogId) from Catalog c;
    set cnt = soDM;    
END &&
DELIMITER &&

call proc_DeleteCatalog(7,@result);
select @result;

-- 5. Tạo proc cho phép thêm mới sản phẩm - nếu chưa có danh mục thì tự tạo danh mục mới
DELIMITER &&
CREATE PROCEDURE proc_InsertProduct(IN proName varchar(50), IN price float,IN catName varchar(50))
BEGIN
	DECLARE cnt int DEFAULT 0;
    DECLARE catId int default 0;
	-- Kiem tra ten danh muc da ton tai chua
    
    select count(c.catalogid) into cnt from Catalog c where c.catalogname = catName;
    IF cnt = 0 then		
		-- Tên danh mục chưa tồn tại --> danh mục chưa có
		call proc_InsertCatalog(catName);  
        select max(c.catalogid) into catid from catalog c;
	ELSE
		-- Danh mục đã tồn tại
		select c.catalogid into catid from catalog c where c.catalogname = catname;
	END IF;
    
    insert into Product(productname,price,catalogid)
    values(proname,price,catid);
END &&
DELIMITER &&
Select * from Product;
select * from catalog;
call proc_insertProduct('Áo java 08',100,'Danh mục java 08');







