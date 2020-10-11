DROP PROCEDURE IF EXISTS [dbo].[get_effective_date];
GO
CREATE PROCEDURE get_effective_date @product nvarchar(20), @findDate DATE
AS

declare @datefrom datetime
declare @dateto datetime
declare @foundDate datetime
declare @count integer
declare @dateRet datetime

set @dateFrom = (select min(eff_date) from Prices where product = @product)
set @dateTo = (select max(eff_date) from Prices where product = @product)

set @dateTo = dateadd(day, 1, @dateTo)

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

RETURN (select price from prices where eff_date = @dateRet and product = @product)

GO
