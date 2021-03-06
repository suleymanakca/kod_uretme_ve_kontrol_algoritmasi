USE [kaizen_case_Q1]
GO
/****** Object:  StoredProcedure [dbo].[check_code2]    Script Date: 5.12.2021 15:14:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[check_code]
@Code varchar(8),
@IsValid int out
AS
BEGIN
	declare @kume nvarchar(23)
	select @kume = 'ACDEFGHKLMNPRTXYZ234579'
	-- gelen kodun karakterlerini tutacak değişkenler
	declare @c1 nvarchar(1)
	declare @c2 nvarchar(1)
	declare @c3 nvarchar(1)
	declare @c4 nvarchar(1)
	declare @c5 nvarchar(1)
	declare @c6 nvarchar(1)
	declare @c7 nvarchar(1)
	declare @c8 nvarchar(1)

	-- karakterler arasındaki artışı/bağlantıyı tutacak değişkenler
	declare @baglanti1 int
	declare @baglanti2 int
	declare @baglanti3 int
	declare @baglanti4 int
	declare @baglanti5 int
	declare @baglanti6 int
	declare @baglanti7 int

	-- karakterlerin indexini tutacak değişkenler
	declare @index1 int
	declare @index2 int
	declare @index3 int
	declare @index4 int
	declare @index5 int
	declare @index6 int
	declare @index7 int
	declare @index8 int

	-- karakterlerin indexini aldım
	select @c1 = SUBSTRING(@Code,1,1)
	select @index1 = CHARINDEX(@c1,@kume)

	select @c2 = SUBSTRING(@Code,2,1)
	select @index2 = CHARINDEX(@c2,@kume)

	select @c3 = SUBSTRING(@Code,3,1)
	select @index3 = CHARINDEX(@c3,@kume)

	select @c4 = SUBSTRING(@Code,4,1)
	select @index4 = CHARINDEX(@c4,@kume)

	select @c5 = SUBSTRING(@Code,5,1)
	select @index5 = CHARINDEX(@c5,@kume)

	select @c6 = SUBSTRING(@Code,6,1)
	select @index6 = CHARINDEX(@c6,@kume)

	select @c7 = SUBSTRING(@Code,7,1)
	select @index7 = CHARINDEX(@c7,@kume)

	select @c8 = SUBSTRING(@Code,8,1)
	select @index8 = CHARINDEX(@c8,@kume)

	-- sırasıyla 7 bağlantıyı aldım
	-- b1
	if @index1 > @index2
	BEGIN
		select @baglanti1 = @index2 + 23 -@index1
	END
	ELSE 
	BEGIN
		select @baglanti1 = @index2 -@index1
	END

	-- b2
	if @index2 > @index3
	BEGIN
		select @baglanti2 = @index3 + 23 -@index2
	END
	ELSE 
	BEGIN
		select @baglanti2 = @index3 -@index2
	END

	-- b3
	if @index3 > @index4
	BEGIN
		select @baglanti3 = @index4 + 23 -@index3
	END
	ELSE 
	BEGIN
		select @baglanti3 = @index4 -@index3
	END

	-- b4
	if @index4 > @index5
	BEGIN
		select @baglanti4 = @index5 + 23 -@index4
	END
	ELSE 
	BEGIN
		select @baglanti4 = @index5 -@index4
	END

	-- b5
	if @index5 > @index6
	BEGIN
		select @baglanti5 = @index6 + 23 -@index5
	END
	ELSE 
	BEGIN
		select @baglanti5 = @index6 -@index5
	END

	-- b6
	if @index6 > @index7
	BEGIN
		select @baglanti6 = @index7 + 23 -@index6
	END
	ELSE 
	BEGIN
		select @baglanti6 = @index7 -@index6
	END

	-- b7
	if @index7 > @index8
	BEGIN
		select @baglanti7 = @index8 + 23 - @index7
	END
	ELSE 
	BEGIN
		select @baglanti7 = @index8 -@index7
	END
	
	-- kodları oluştururken kullandığım 8'li küme için tablo oluşturdum ve kullandığımı güncelledim
	DECLARE @myTable TABLE (id INT, b int)
	insert into @myTable values(2,0),(5,0),(6,0),(10,0),(16,0),(18,0),(21,0),(22,0)

	update @myTable set b = @baglanti1 where id = @baglanti1
	update @myTable set b = @baglanti2 where id = @baglanti2
	update @myTable set b = @baglanti3 where id = @baglanti3
	update @myTable set b = @baglanti4 where id = @baglanti4
	update @myTable set b = @baglanti5 where id = @baglanti5
	update @myTable set b = @baglanti6 where id = @baglanti6
	update @myTable set b = @baglanti7 where id = @baglanti7

		-- bağlantısı olmayan kayıtları buldum
		-- en fazla 1 bağlantı boşta kalabilir
		declare @olmayan_baglanti int 
		select @olmayan_baglanti = COUNT(*) from @myTable where b = 0
		if(@olmayan_baglanti > 1)
		BEGIN
			set @IsValid = 0
		END
		ELSE 
		BEGIN
			set @IsValid = 1
		END

		-- bağlantı aşaması tamam ise
		declare @sayi_str bigint
		if(@IsValid = 1)
		BEGIN
		-- bağlantıların varchar halini tutacak değişkenler
		declare @sayi_str1 varchar(10)
		declare @sayi_str2 varchar(10)
		declare @sayi_str3 varchar(10)
		declare @sayi_str4 varchar(10)
		declare @sayi_str5 varchar(10)
		declare @sayi_str6 varchar(10)
		declare @sayi_str7 varchar(10)

		-- varchara dönüştürüp atama yaptım
		set @sayi_str1 = CAST(@baglanti1 as varchar(10))
		set @sayi_str2 = CAST(@baglanti2 as varchar(10))
		set @sayi_str3 = CAST(@baglanti3 as varchar(10))
		set @sayi_str4 = CAST(@baglanti4 as varchar(10))
		set @sayi_str5 = CAST(@baglanti5 as varchar(10))
		set @sayi_str6 = CAST(@baglanti6 as varchar(10))
		set @sayi_str7 = CAST(@baglanti7 as varchar(10))

		-- birleştirdim
		SET @sayi_str = @sayi_str1 + @sayi_str2 + @sayi_str3 + @sayi_str4 + @sayi_str5 +  @sayi_str6 + @sayi_str7

		-- birleştirdiğim sayıları bigint'e dönüştürdüm
		-- bu sayı kodu oluştururken kullandığım yönteme göre satırların birleşip sayı oluşturduğu sayılardan biri olmalı
		declare @baglanti_sayisi bigint
		set @baglanti_sayisi = CAST(@sayi_str AS bigint)

		declare @max_sayi bigint
		declare @min_sayi bigint


		-- bir tablo oluşturdum ve bu tabloya 8 değer ekledim
		-- bu 8 kaydın 7'li permütasyonunu aldım(1000den fazla ediyor)
		-- 7 kolonlu eşsiz satırlar elde ettim, permütasyon sayesinde
		-- satırdaki kolonları varchar olacak şekilde birleştirdim
		-- birleştirdiğim varcharları bigint'e dönüştürdüm
		-- oluşan sayılara göre küçükten büyüğe sıraladım, ilk 1000'ini aldım
		-- bu bana başlangıç ve bitişini bildiğim 8 eleman arasındaki 7 bağlantıyı verdi
		-- ilk satırım başlangıç noktamdır
		-- son satırım bitiş noktamdır



		DECLARE @myTable2 TABLE (id INT)
		insert into @myTable2 values(2),(5),(6),(10),(16),(18),(21),(22)


				select @min_sayi = tbl.a_number from(
				SELECT TOP(1000)
				ROW_NUMBER() OVER (ORDER BY CAST((CAST(T1.id as varchar(10)) + '' + CAST(T2.id as varchar(10)) + '' + CAST(T3.id as varchar(10)) + '' + CAST(T4.id as varchar(10))+ '' + CAST(T5.id as varchar(10)) + '' + CAST(T6.id as varchar(10))+ '' + CAST(T7.id as varchar(10))) as  bigint) asc) as a_row
				,T1.id AS c1, T2.id AS c2, T3.id AS c3, T4.id AS c4, T5.id AS c5, T6.id AS c6, T7.id AS c7
				,CAST((CAST(T1.id as varchar(10)) + '' + CAST(T2.id as varchar(10)) + '' + CAST(T3.id as varchar(10)) + '' + CAST(T4.id as varchar(10))+ '' + CAST(T5.id as varchar(10)) + '' + CAST(T6.id as varchar(10))+ '' + CAST(T7.id as varchar(10))) as  bigint) as a_number
				,LEN((CAST(T1.id as varchar(10)) + '' + CAST(T2.id as varchar(10)) + '' + CAST(T3.id as varchar(10)) + '' + CAST(T4.id as varchar(10))+ '' + CAST(T5.id as varchar(10)) + '' + CAST(T6.id as varchar(10))+ '' + CAST(T7.id as varchar(10)))) as a_text_length
				FROM     @myTable2 AS T1 INNER JOIN
				                  @myTable2 AS T2 ON T2.id NOT IN (T1.id) INNER JOIN
				                  @myTable2 AS T3 ON T3.id NOT IN (T1.id, T2.id) INNER JOIN
				                  @myTable2 AS T4 ON T4.id NOT IN (T1.id, T2.id, T3.id) INNER JOIN
				                  @myTable2 AS T5 ON T5.id NOT IN (T1.id, T2.id, T3.id, T4.id) INNER JOIN
				                  @myTable2 AS T6 ON T6.id NOT IN (T1.id, T2.id, T3.id, T4.id, T5.id) INNER JOIN
				                  @myTable2 AS T7 ON T7.id NOT IN (T1.id, T2.id, T3.id, T4.id, T5.id, T6.id)
								  order by CAST((CAST(T1.id as varchar(10)) + '' + CAST(T2.id as varchar(10)) + '' + CAST(T3.id as varchar(10)) + '' + CAST(T4.id as varchar(10))+ '' + CAST(T5.id as varchar(10)) + '' + CAST(T6.id as varchar(10))+ '' + CAST(T7.id as varchar(10))) as  bigint) asc

				) as tbl
				where tbl.a_row = 1

				select @max_sayi = tbl.a_number from(
				SELECT TOP(1000)
				ROW_NUMBER() OVER (ORDER BY CAST((CAST(T1.id as varchar(10)) + '' + CAST(T2.id as varchar(10)) + '' + CAST(T3.id as varchar(10)) + '' + CAST(T4.id as varchar(10))+ '' + CAST(T5.id as varchar(10)) + '' + CAST(T6.id as varchar(10))+ '' + CAST(T7.id as varchar(10))) as  bigint) asc) as a_row
				,T1.id AS c1, T2.id AS c2, T3.id AS c3, T4.id AS c4, T5.id AS c5, T6.id AS c6, T7.id AS c7
				,CAST((CAST(T1.id as varchar(10)) + '' + CAST(T2.id as varchar(10)) + '' + CAST(T3.id as varchar(10)) + '' + CAST(T4.id as varchar(10))+ '' + CAST(T5.id as varchar(10)) + '' + CAST(T6.id as varchar(10))+ '' + CAST(T7.id as varchar(10))) as  bigint) as a_number
				,LEN((CAST(T1.id as varchar(10)) + '' + CAST(T2.id as varchar(10)) + '' + CAST(T3.id as varchar(10)) + '' + CAST(T4.id as varchar(10))+ '' + CAST(T5.id as varchar(10)) + '' + CAST(T6.id as varchar(10))+ '' + CAST(T7.id as varchar(10)))) as a_text_length
				FROM     @myTable2 AS T1 INNER JOIN
				                  @myTable2 AS T2 ON T2.id NOT IN (T1.id) INNER JOIN
				                  @myTable2 AS T3 ON T3.id NOT IN (T1.id, T2.id) INNER JOIN
				                  @myTable2 AS T4 ON T4.id NOT IN (T1.id, T2.id, T3.id) INNER JOIN
				                  @myTable2 AS T5 ON T5.id NOT IN (T1.id, T2.id, T3.id, T4.id) INNER JOIN
				                  @myTable2 AS T6 ON T6.id NOT IN (T1.id, T2.id, T3.id, T4.id, T5.id) INNER JOIN
				                  @myTable2 AS T7 ON T7.id NOT IN (T1.id, T2.id, T3.id, T4.id, T5.id, T6.id)
								  order by CAST((CAST(T1.id as varchar(10)) + '' + CAST(T2.id as varchar(10)) + '' + CAST(T3.id as varchar(10)) + '' + CAST(T4.id as varchar(10))+ '' + CAST(T5.id as varchar(10)) + '' + CAST(T6.id as varchar(10))+ '' + CAST(T7.id as varchar(10))) as  bigint) asc

				) as tbl
				where tbl.a_row = 1000

				-- yukarda gelen kod için bağlantılarınının birleşip oluşturduğu sayı belirlediğim sayılar arasında mı

				if(@baglanti_sayisi >= @min_sayi and @baglanti_sayisi <=@max_sayi)
				BEGIN
					set @IsValid = 1
				END
				ELSE
				BEGIN
					set @IsValid = 0
				END



		END

			select 'valid' = @IsValid
END