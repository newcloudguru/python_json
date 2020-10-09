declare @dateFrom datetime
declare @dateTo datetime
declare @product varchar(20)
declare @findDate datetime
declare @foundDate datetime
declare @count integer
declare @dateRet datetime

set @product = 'product_1'
set @findDate = '2018-01-03'
set @dateFrom = (select min(eff_date) from Prices where product = @product)
set @dateTo = (select max(eff_date) from Prices where product = @product)

--set @dateTo = dateadd(day, 1, @dateTo)

while (@dateFrom < @dateTo)
begin
	set @count = (select count(*) from prices where eff_date = @dateFrom and product = @product)

	if @count = 0
	begin
		if datalength(@dateRet) = 0
			set @dateRet = @dateFrom
		else
		begin
		if @findDate = @dateFrom
			begin
				set @dateRet = @foundDate
				break
			end
		end
	end
	else
	begin
		set @foundDate = @dateFrom

		if @findDate = @dateFrom
		begin
			set @dateRet = @dateFrom
			break
		end
		else
			set @dateRet = @foundDate
	end

select @dateFrom = dateadd(day, 1, @dateFrom)
end
 
--select @dateRet, @foundDate
select price from prices where eff_date = @dateRet and product = @product