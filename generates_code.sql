USE [kaizen_case_Q1]
GO
/****** Object:  StoredProcedure [dbo].[generates_code2]    Script Date: 5.12.2021 12:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[generates_code]
AS
BEGIN

-- karakter kümesi tanımlandı
declare @kume nvarchar(23)
select @kume = 'ACDEFGHKLMNPRTXYZ234579'

-- test amaçlı 8 sayı ele alındı. bu sayıların 7'li permütasyonu alınacak ve oluşacak 8 karakterin arasındaki beğlantıları tespit edecek
DECLARE @myTable TABLE (id INT)
insert into @myTable values(2),(5),(6),(10),(16),(18),(21),(22)

-- harf sırası için kullanılacak değişken
declare @sira int
select @sira = 1

-- oluşacak kod sayısı
declare @kod_sayisi int
SET @kod_sayisi = 1000

-- kod sayısının 22 ye bölümünden kalanı: 10
declare @kalan int
SET @kalan = 1000 % 22

-- kod sayısını 22 ye bölümü(kalan kariç)
-- ilk 22 karakter ile başlayacak olan kod sayısı: 45
declare @harf_ile_baslayan int
SET @harf_ile_baslayan = (1000 - @kalan) / 22

-- oluşacak kodun sırası(işlem içinde anlatılacak)
declare @kod_sira int
SET @kod_sira = 1

-- bağlantılar
declare @b1 int
declare @b2 int
declare @b3 int
declare @b4 int
declare @b5 int
declare @b6 int
declare @b7 int

-- karakterler
declare @c1 nvarchar(1)
declare @c2 nvarchar(1)
declare @c3 nvarchar(1)
declare @c4 nvarchar(1)
declare @c5 nvarchar(1)
declare @c6 nvarchar(1)
declare @c7 nvarchar(1)
declare @c8 nvarchar(1)

-- oluşan permütasyonda kullanılacak satır
declare @tablo_sira int

-- bağlantılar sonucu oluşan karakterin indexleri
declare @b_toplam1 int
declare @b_toplam2 int
declare @b_toplam3 int
declare @b_toplam4 int
declare @b_toplam5 int
declare @b_toplam6 int
declare @b_toplam7 int

-- kümedeki karakter sayısı kadar dönecek
WHILE (@sira < 24)
BEGIN

	if(@sira != 23)
		BEGIN
		-- alinacak kodun sırası her seferinde başa alındı
		-- çünkü örüntüsel şekilde artacak ve orada kullanılacak
		SET @kod_sira = 1
		-- karakter ile başlayan 45 kod olabilir, 45 kere dönecek
		while(@kod_sira < (@harf_ile_baslayan + 1))
		BEGIN
			-- oluşan permütasyon tablosundaki sıra
			-- burası kritik
			-- örneğin 2. index( C ) ile başlayan 4. kod oluşacak
			-- tablodaki sira ->> tablo_sira = 2 (45 * (2 - 1)), yani 47
			-- 3. index ile başlayan 4. kod 92 olacaktı, 45 45 artıyor
			SET @tablo_sira = @kod_sira + (@harf_ile_baslayan * (@sira -1))

			-- yukarıda (2),(5),(6),(10),(16),(18),(21),(22) dan oluşan 8 elemanlı bir küme verildi
			-- bu 8 elemanlı kümenin 7'li permütasyonunu aldım(1000den fazla ediyor)
			-- 7 kolonlu eşsiz satırlar elde ettim, permütasyon sayesinde
			-- satırdaki kolonları varchar olacak şekilde birleştirdim
			-- birleştirdiğim varcharları bigint'e dönüştürdüm
			-- oluşan sayılara göre küçükten büyüğe sıraladım, ilk 1000'ini aldım
			-- bu bana başlangıç ve bitişini bildiğim 8 eleman arasındaki 7 bağlantıyı verdi
			-- kodları kontrol ederken aralarındaki artış miktarına bakılacak 
			-- ve artış miktarları 8li küme içindeki sayılar kadar olmalıdır
			-- aynı artış miktarından 2 tane olamaz
			-- aynı artış miktarından 1'den fazla varsa kodu ben üretmedim
			-- yani sadece 1 artış miktarı boşta kalabilir
			-- burada kritik nokta şurası:
			-- 8li kümem dahilinde doğru şekilde artış miktarları karşıma çıkabilir ancak bu artışlar benim belirlediğim 1000'lik kayıt içerisinde olmayabilir
			-- burada sayıları varchar şeklinde toplayıp yine bigint'e çeviriyorum
			-- ve bu sayı yine yukarıda bu düzende oluşturduğum bigint kolonundaki en düşük ve en yüksek sayı aralığında mı baktım
			-- aralıkta ise ben oluşturmuşumdur
				select @b1 = tbl.c1, @b2 = tbl.c2, @b3 = tbl.c3, @b4 = tbl.c4, @b5 = tbl.c5, @b6 = tbl.c6, @b7 = tbl.c7 from(
				SELECT TOP(1000)
				ROW_NUMBER() OVER (ORDER BY CAST((CAST(T1.id as varchar(10)) + '' + CAST(T2.id as varchar(10)) + '' + CAST(T3.id as varchar(10)) + '' + CAST(T4.id as varchar(10))+ '' + CAST(T5.id as varchar(10)) + '' + CAST(T6.id as varchar(10))+ '' + CAST(T7.id as varchar(10))) as  bigint) asc) as a_row
				,T1.id AS c1, T2.id AS c2, T3.id AS c3, T4.id AS c4, T5.id AS c5, T6.id AS c6, T7.id AS c7
				,CAST((CAST(T1.id as varchar(10)) + '' + CAST(T2.id as varchar(10)) + '' + CAST(T3.id as varchar(10)) + '' + CAST(T4.id as varchar(10))+ '' + CAST(T5.id as varchar(10)) + '' + CAST(T6.id as varchar(10))+ '' + CAST(T7.id as varchar(10))) as  bigint) as a_number
				,LEN((CAST(T1.id as varchar(10)) + '' + CAST(T2.id as varchar(10)) + '' + CAST(T3.id as varchar(10)) + '' + CAST(T4.id as varchar(10))+ '' + CAST(T5.id as varchar(10)) + '' + CAST(T6.id as varchar(10))+ '' + CAST(T7.id as varchar(10)))) as a_text_length
				FROM     @myTable AS T1 INNER JOIN
				                  @myTable AS T2 ON T2.id NOT IN (T1.id) INNER JOIN
				                  @myTable AS T3 ON T3.id NOT IN (T1.id, T2.id) INNER JOIN
				                  @myTable AS T4 ON T4.id NOT IN (T1.id, T2.id, T3.id) INNER JOIN
				                  @myTable AS T5 ON T5.id NOT IN (T1.id, T2.id, T3.id, T4.id) INNER JOIN
				                  @myTable AS T6 ON T6.id NOT IN (T1.id, T2.id, T3.id, T4.id, T5.id) INNER JOIN
				                  @myTable AS T7 ON T7.id NOT IN (T1.id, T2.id, T3.id, T4.id, T5.id, T6.id)
								  order by CAST((CAST(T1.id as varchar(10)) + '' + CAST(T2.id as varchar(10)) + '' + CAST(T3.id as varchar(10)) + '' + CAST(T4.id as varchar(10))+ '' + CAST(T5.id as varchar(10)) + '' + CAST(T6.id as varchar(10))+ '' + CAST(T7.id as varchar(10))) as  bigint) asc

				) as tbl
				where tbl.a_row = @tablo_sira

				-- başlangıç karakter 1. indekten başlayarak sırayla gider
				select @c1 = SUBSTRING(@kume,@sira,1)
				
				-- 2. karakter için permütasyonun 1. sütunu alınır ve bu sayı artış miktarı olur
				select @b_toplam1 = @sira +  @b1
				-- index + artış miktarı 23 ten büyük ise karakter kümesinin sonuna gelinmiştir ve başa dönülmüştür
				if(@b_toplam1 > 23)
				begin
					-- artış miktarı 23 den ziyade 46, 69 olabilir
					-- bunların modu 0 çıkar, ancak 23. karaktere işaret edilmektedir
					-- buna göre sıradaki karaker alınır
					set @b_toplam1 = @b_toplam1 % 23
					if(@b_toplam1 = 0)
						BEGIN
							select @b_toplam1 = 23
							select @c2 = SUBSTRING(@kume,@b_toplam1,1)
						END
					ELSE
						BEGIN
							select @c2 = SUBSTRING(@kume,@b_toplam1,1)
						END
					
				end
				else
				begin
					--index + artış miktarı 23 ten küçük ise indexi arttır ve karakteri al
					select @c2 = SUBSTRING(@kume,@sira + @b1,1)
				end

				-- 3. karakter için permütasyonun 2. sütunu alınır ve bu sayı artış miktarı olur
				select @b_toplam2 = @sira +  @b1 +  @b2
				-- index + artış miktarı 23 ten büyük ise karakter kümesinin sonuna gelinmiştir ve başa dönülmüştür
				if(@b_toplam2 > 23)
				begin
					-- artış miktarı 23 den ziyade 46, 69 olabilir
					-- bunların modu 0 çıkar, ancak 23. karaktere işaret edilmektedir
					-- buna göre sıradaki karaker alınır
					set @b_toplam2 = @b_toplam2 % 23
					if(@b_toplam2 = 0)
						BEGIN
							select @b_toplam2 = 23
							select @c3 = SUBSTRING(@kume,@b_toplam2,1)
						END
					ELSE
						BEGIN
							select @c3 = SUBSTRING(@kume,@b_toplam2,1)
						END
					
				end
				else
				begin
					--index + artış miktarı 23 ten küçük ise indexi arttır ve karakteri al
					select @c3 = SUBSTRING(@kume,@sira + @b1 + @b2,1)
				end

				-- 4. karakter için permütasyonun 3. sütunu alınır ve bu sayı artış miktarı olur
				select @b_toplam3 = @sira +  @b1 +  @b2+  @b3
				-- index + artış miktarı 23 ten büyük ise karakter kümesinin sonuna gelinmiştir ve başa dönülmüştür
				if(@b_toplam3 > 23)
				begin
					-- artış miktarı 23 den ziyade 46, 69 olabilir
					-- bunların modu 0 çıkar, ancak 23. karaktere işaret edilmektedir
					-- buna göre sıradaki karaker alınır
					set @b_toplam3 = @b_toplam3 % 23
					if(@b_toplam3 = 0)
						BEGIN
							select @b_toplam3 = 23
							select @c4 = SUBSTRING(@kume,@b_toplam3,1)
						END
					ELSE
						BEGIN
							select @c4 = SUBSTRING(@kume,@b_toplam3,1)
						END
					
				end
				else
				begin
					--index + artış miktarı 23 ten küçük ise indexi arttır ve karakteri al
					select @c4 = SUBSTRING(@kume,@sira + @b1 + @b2+  @b3,1)
				end

				-- 5. karakter için permütasyonun 4. sütunu alınır ve bu sayı artış miktarı olur
				select @b_toplam4 = @sira +  @b1 +  @b2 +  @b3 + @b4 
				-- index + artış miktarı 23 ten büyük ise karakter kümesinin sonuna gelinmiştir ve başa dönülmüştür
				if(@b_toplam4 > 23)
				begin
					-- artış miktarı 23 den ziyade 46, 69 olabilir
					-- bunların modu 0 çıkar, ancak 23. karaktere işaret edilmektedir
					-- buna göre sıradaki karaker alınır
					set @b_toplam4 = @b_toplam4 % 23
					if(@b_toplam4 = 0)
						BEGIN
							select @b_toplam4 = 23
							select @c5 = SUBSTRING(@kume,@b_toplam4,1)
						END
					ELSE
						BEGIN
							select @c5 = SUBSTRING(@kume,@b_toplam4,1)
						END
					
				end
				else
				begin
					--index + artış miktarı 23 ten küçük ise indexi arttır ve karakteri al
					select @c5 = SUBSTRING(@kume,@sira + @b1 + @b2+  @b3 + @b4,1)
				end

				-- 6. karakter için permütasyonun 5. sütunu alınır ve bu sayı artış miktarı olur
				select @b_toplam5 = @sira +  @b1 +  @b2 +  @b3 + @b4 + @b5
				-- index + artış miktarı 23 ten büyük ise karakter kümesinin sonuna gelinmiştir ve başa dönülmüştür
				if(@b_toplam5 > 23)
				begin
					-- artış miktarı 23 den ziyade 46, 69 olabilir
					-- bunların modu 0 çıkar, ancak 23. karaktere işaret edilmektedir
					-- buna göre sıradaki karaker alınır
					set @b_toplam5 = @b_toplam5 % 23
					if(@b_toplam5 = 0)
						BEGIN
							select @b_toplam5 = 23
							select @c6 = SUBSTRING(@kume,@b_toplam5,1)
						END
					ELSE
						BEGIN
							select @c6 = SUBSTRING(@kume,@b_toplam5,1)
						END
					
				end
				else
				begin
					--index + artış miktarı 23 ten küçük ise indexi arttır ve karakteri al
					select @c6 = SUBSTRING(@kume,@sira + @b1 + @b2+  @b3 + @b4 + @b5,1)
				end

				-- 7. karakter için permütasyonun 6. sütunu alınır ve bu sayı artış miktarı olur
				select @b_toplam6 = @sira +  @b1 +  @b2 +  @b3 + @b4 + @b5 + @b6 
				-- index + artış miktarı 23 ten büyük ise karakter kümesinin sonuna gelinmiştir ve başa dönülmüştür
				if(@b_toplam6 > 23)
				begin
					-- artış miktarı 23 den ziyade 46, 69 olabilir
					-- bunların modu 0 çıkar, ancak 23. karaktere işaret edilmektedir
					-- buna göre sıradaki karaker alınır
					set @b_toplam6 = @b_toplam6 % 23
					if(@b_toplam6 = 0)
						BEGIN
							select @b_toplam6 = 23
							select @c7 = SUBSTRING(@kume,@b_toplam6,1)
						END
					ELSE
						BEGIN
							select @c7 = SUBSTRING(@kume,@b_toplam6,1)
						END
					
				end
				else
				begin
					--index + artış miktarı 23 ten küçük ise indexi arttır ve karakteri al
					select @c7 = SUBSTRING(@kume,@sira + @b1 + @b2+  @b3 + @b4 + @b5 + @b6 ,1)
				end

				-- 8. karakter için permütasyonun 7. sütunu alınır ve bu sayı artış miktarı olur
				select @b_toplam7 = @sira +  @b1 +  @b2 +  @b3 + @b4 + @b5 + @b6 + @b7  
				-- index + artış miktarı 23 ten büyük ise karakter kümesinin sonuna gelinmiştir ve başa dönülmüştür
				if(@b_toplam7 > 23)
				begin
					-- artış miktarı 23 den ziyade 46, 69 olabilir
					-- bunların modu 0 çıkar, ancak 23. karaktere işaret edilmektedir
					-- buna göre sıradaki karaker alınır
					set @b_toplam7 = @b_toplam7 % 23
					if(@b_toplam7 = 0)
						BEGIN
							select @b_toplam7 = 23
							select @c8 = SUBSTRING(@kume,@b_toplam7,1)
						END
					ELSE
						BEGIN
							select @c8 = SUBSTRING(@kume,@b_toplam7,1)
						END
					
				end
				else
				begin
					--index + artış miktarı 23 ten küçük ise indexi arttır ve karakteri al
					select @c8 = SUBSTRING(@kume,@sira + @b1 + @b2+  @b3 + @b4 + @b5 + @b6 + @b7,1)
				end
				-- oluşan karakterlerden kod elde edilir
				insert into tbl_fmcg_code(a_kod) VALUES (@c1 + '' + @c2 + '' + @c3+ '' + @c4+ '' + @c5+ '' + @c6+ '' + @c7+ '' + @c8)


			SET @kod_sira = @kod_sira + 1
		END
	END

	ELSE


		BEGIN
			-- sıradaki kodu almak için kullanılır
			SET @kod_sira = 1
			-- son karakterden 1000 % 22 kadar oluşacak, gerekli döngüye girer
			while(@kod_sira < (@kalan + 1))
			BEGIN
				-- tablodaki sırası alınır
				-- tablo_sira =  1 + (45 (23 -1)) --> 991
				SET @tablo_sira = @kod_sira + (@harf_ile_baslayan * (23 -1))
				-- yukarıdaki işlemlerin aynısı yapılıyor

				select @b1 = tbl.c1, @b2 = tbl.c2, @b3 = tbl.c3, @b4 = tbl.c4, @b5 = tbl.c5, @b6 = tbl.c6, @b7 = tbl.c7 from(
				SELECT TOP(1000)
				ROW_NUMBER() OVER (ORDER BY CAST((CAST(T1.id as varchar(10)) + '' + CAST(T2.id as varchar(10)) + '' + CAST(T3.id as varchar(10)) + '' + CAST(T4.id as varchar(10))+ '' + CAST(T5.id as varchar(10)) + '' + CAST(T6.id as varchar(10))+ '' + CAST(T7.id as varchar(10))) as  bigint) asc) as a_row
				,T1.id AS c1, T2.id AS c2, T3.id AS c3, T4.id AS c4, T5.id AS c5, T6.id AS c6, T7.id AS c7
				,CAST((CAST(T1.id as varchar(10)) + '' + CAST(T2.id as varchar(10)) + '' + CAST(T3.id as varchar(10)) + '' + CAST(T4.id as varchar(10))+ '' + CAST(T5.id as varchar(10)) + '' + CAST(T6.id as varchar(10))+ '' + CAST(T7.id as varchar(10))) as  bigint) as a_number
				,LEN((CAST(T1.id as varchar(10)) + '' + CAST(T2.id as varchar(10)) + '' + CAST(T3.id as varchar(10)) + '' + CAST(T4.id as varchar(10))+ '' + CAST(T5.id as varchar(10)) + '' + CAST(T6.id as varchar(10))+ '' + CAST(T7.id as varchar(10)))) as a_text_length
				FROM     @myTable AS T1 INNER JOIN
				                  @myTable AS T2 ON T2.id NOT IN (T1.id) INNER JOIN
				                  @myTable AS T3 ON T3.id NOT IN (T1.id, T2.id) INNER JOIN
				                  @myTable AS T4 ON T4.id NOT IN (T1.id, T2.id, T3.id) INNER JOIN
				                  @myTable AS T5 ON T5.id NOT IN (T1.id, T2.id, T3.id, T4.id) INNER JOIN
				                  @myTable AS T6 ON T6.id NOT IN (T1.id, T2.id, T3.id, T4.id, T5.id) INNER JOIN
				                  @myTable AS T7 ON T7.id NOT IN (T1.id, T2.id, T3.id, T4.id, T5.id, T6.id)
								  order by CAST((CAST(T1.id as varchar(10)) + '' + CAST(T2.id as varchar(10)) + '' + CAST(T3.id as varchar(10)) + '' + CAST(T4.id as varchar(10))+ '' + CAST(T5.id as varchar(10)) + '' + CAST(T6.id as varchar(10))+ '' + CAST(T7.id as varchar(10))) as  bigint) asc

				) as tbl
				where tbl.a_row = @tablo_sira

				select @c1 = SUBSTRING(@kume,@sira,1)
				
				select @b_toplam1 = @sira +  @b1
				if(@b_toplam1 > 23)
				begin
					set @b_toplam1 = @b_toplam1 % 23
					if(@b_toplam1 = 0)
						BEGIN
							select @b_toplam1 = 23
							select @c2 = SUBSTRING(@kume,@b_toplam1,1)
						END
					ELSE
						BEGIN
							select @c2 = SUBSTRING(@kume,@b_toplam1,1)
						END
					
				end
				else
				begin
					select @c2 = SUBSTRING(@kume,@sira + @b1,1)
				end


				select @b_toplam2 = @sira +  @b1 +  @b2
				if(@b_toplam2 > 23)
				begin
					set @b_toplam2 = @b_toplam2 % 23
					if(@b_toplam2 = 0)
						BEGIN
							select @b_toplam2 = 23
							select @c3 = SUBSTRING(@kume,@b_toplam2,1)
						END
					ELSE
						BEGIN
							select @c3 = SUBSTRING(@kume,@b_toplam2,1)
						END
					
				end
				else
				begin
					select @c3 = SUBSTRING(@kume,@sira + @b1 + @b2,1)
				end

				select @b_toplam3 = @sira +  @b1 +  @b2+  @b3
				if(@b_toplam3 > 23)
				begin
					set @b_toplam3 = @b_toplam3 % 23
					if(@b_toplam3 = 0)
						BEGIN
							select @b_toplam3 = 23
							select @c4 = SUBSTRING(@kume,@b_toplam3,1)
						END
					ELSE
						BEGIN
							select @c4 = SUBSTRING(@kume,@b_toplam3,1)
						END
					
				end
				else
				begin
					select @c4 = SUBSTRING(@kume,@sira + @b1 + @b2+  @b3,1)
				end

				select @b_toplam4 = @sira +  @b1 +  @b2 +  @b3 + @b4 
				if(@b_toplam4 > 23)
				begin
					set @b_toplam4 = @b_toplam4 % 23
					if(@b_toplam4 = 0)
						BEGIN
							select @b_toplam4 = 23
							select @c5 = SUBSTRING(@kume,@b_toplam4,1)
						END
					ELSE
						BEGIN
							select @c5 = SUBSTRING(@kume,@b_toplam4,1)
						END
					
				end
				else
				begin
					select @c5 = SUBSTRING(@kume,@sira + @b1 + @b2+  @b3 + @b4,1)
				end

				select @b_toplam5 = @sira +  @b1 +  @b2 +  @b3 + @b4 + @b5
				if(@b_toplam5 > 23)
				begin
					set @b_toplam5 = @b_toplam5 % 23
					if(@b_toplam5 = 0)
						BEGIN
							select @b_toplam5 = 23
							select @c6 = SUBSTRING(@kume,@b_toplam5,1)
						END
					ELSE
						BEGIN
							select @c6 = SUBSTRING(@kume,@b_toplam5,1)
						END
					
				end
				else
				begin
					select @c6 = SUBSTRING(@kume,@sira + @b1 + @b2+  @b3 + @b4 + @b5,1)
				end

				select @b_toplam6 = @sira +  @b1 +  @b2 +  @b3 + @b4 + @b5 + @b6 
				if(@b_toplam6 > 23)
				begin
					set @b_toplam6 = @b_toplam6 % 23
					if(@b_toplam6 = 0)
						BEGIN
							select @b_toplam6 = 23
							select @c7 = SUBSTRING(@kume,@b_toplam6,1)
						END
					ELSE
						BEGIN
							select @c7 = SUBSTRING(@kume,@b_toplam6,1)
						END
					
				end
				else
				begin
					select @c7 = SUBSTRING(@kume,@sira + @b1 + @b2+  @b3 + @b4 + @b5 + @b6 ,1)
				end

				select @b_toplam7 = @sira +  @b1 +  @b2 +  @b3 + @b4 + @b5 + @b6 + @b7  
				if(@b_toplam7 > 23)
				begin
					set @b_toplam7 = @b_toplam7 % 23
					if(@b_toplam7 = 0)
						BEGIN
							select @b_toplam7 = 23
							select @c8 = SUBSTRING(@kume,@b_toplam7,1)
						END
					ELSE
						BEGIN
							select @c8 = SUBSTRING(@kume,@b_toplam7,1)
						END
					
				end
				else
				begin
					select @c7 = SUBSTRING(@kume,@sira + @b1 + @b2+  @b3 + @b4 + @b5 + @b6 + @b7,1)
				end

				insert into tbl_fmcg_code(a_kod) VALUES (@c1 + '' + @c2 + '' + @c3+ '' + @c4+ '' + @c5+ '' + @c6+ '' + @c7+ '' + @c8)




				SET @kod_sira = @kod_sira + 1
			END					

	END


	SET @sira = @sira + 1
END


END