DROP PROCEDURE IF EXISTS get_revenue;
GO
CREATE PROCEDURE get_revenue
AS

DECLARE 
    @product VARCHAR(20), 
    @sales_date DATE,
    @quantity INT,
    @price int,
    @revenue int,
    @total int;

DECLARE cursor_product CURSOR
FOR SELECT 
        product, 
        sales_date,
        quantity
    FROM 
        Sales;

set @total = 0;

OPEN cursor_product;

FETCH NEXT FROM cursor_product INTO 
    @product, 
    @sales_date,
    @quantity;

WHILE @@FETCH_STATUS = 0
    BEGIN
        --PRINT @product + char(9) + CAST(@sales_date AS varchar) + char(9) + CAST(@quantity AS varchar);
        EXEC @price = effdate @product, @sales_date;
        set @revenue = @price * @quantity;
        set @total = @total + @revenue;
        --print @total;

        FETCH NEXT FROM cursor_product INTO 
            @product, 
            @sales_date,
            @quantity;
    END;

print @total
CLOSE cursor_product;

DEALLOCATE cursor_product;

