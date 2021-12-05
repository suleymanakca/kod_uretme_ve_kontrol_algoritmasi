# KOD ÜRETME VE KONTROL ALGORİTMASI
Not: Scriptler MsSql veritabanı için Microsoft SQL Server Management Studio üzerinde yazılmıştır ve çalıştırılmıştır.

# AÇIKLAMA VE ÇÖZÜM

Hızlı tüketim sektöründe faaliyet gösteren bir gıda firması, ürün ambalajları içerisine bir kod 
yerleştirerek, bu kodlar aracılığı ile çeşitli kampanyalar düzenlemek istemektedir.

1. Öncelikle firmaya aşağıdaki özelliklere sahip 10.000.000 adet kod üretilecektir. 

* Kodlar 8 hane uzunluğunda ve unique olmalıdır.
* Kodlar ACDEFGHKLMNPRTXYZ234579 karakter kümesini içermelidir.
* Kolayca tahmin edilememesi için ardışık sıralı üretim yapılmamalıdır. 
2. Şartlar

* Kod üretimi ve kod kontrolü için T-SQL ile iki procedure hazırlanması gerekmektedir. 
* Kod üretimi belirlediğiniz bir algoritmaya uygun olarak yapılmalıdır. 
* Kodun geçerliliği veritabanındaki bir tablodan kontrol edilmeyecektir. 
* Kodun geçerli olup olmadığı algoritmik olarak tespit edilmelidir. 

Çözüm:
## KOD ÜRETME ALGORİTMASI
* Unique kod üretme işlemi için oluşacak kodların karakterlerinin arasındaki bağlantı ele alınmıştır.
* Bağlantıları; karakter_1 ile karakter_2, karakter_2 ile karakter_3, karakter_3 ile karakter_4, karakter_4 ile karakter_5, karakter_5 ile karakter_6, karakter_6 ile karakter_7, karakter_7 ile karakter_8 oluşturmaktadır ve toplamda 7 bağlantı elde edilmektedir. 
## Bağlantı ne anlama geliyor?
* Bağlantılar verilen 23 karakterli kümeden kodun herhangi bir index'indeki karakterden sonra gelecek olan karakteri işaret etmektedir. Artış miktarıdır.
* Karakter kümesini 1 den başlayarak 23'e kadar sıralı şekilde indexledim.
* Örneğin oluşturacağım kodun ilk karakteri C ve indexi 2.
* karakter_1 ile karakter_2 arasındaki bağlantıyı 7 varsayalım. Böylece 2. karakter 2+7 = 9 yani L olacaktır.
## Bağlantılar nasıl oluşmakta?
* Bağlantıların oluşma mantığı permütasyon hesaplamasına dayanmaktadır.
* Deneme için (2),(5),(6),(10),(16),(18),(21),(22) sayılarından oluşan 8 elemanlı bir küme oluşturulmuştur.
* Bu 8 elemanın 7'li parmütasyonu alınmıştır. P(8, 7) = 40.320
* Bu oluşan 40.320 elemanın hepsi eşsizdir tekrar etmez.
### Burası kritik!!!
* Burada 7 kolonlu 40.320 satırdan oluşan bir tablo/veri elde oluşmaktadır.
* Her satırını sıralı şekilde varchar olarak topladım.
* Örneğin bir satırda 21,2,6,16,18,5,22 mevcut. Sırayla topladığım zaman 21261618522 metni elde edilmektedir.
* Oluşturduğum metni bigint'e dönüştürdüm ve tabloya kolon ekleyerek satırların yanına kendi oluşan sayısını yazdım.
* Artık 8 kolondan ve 40.320 satırdan oluşan tablomu son oluşturduğum kolona göre büyükten küçüğe doğru sıraladım ve ilk 1000'ini aldım. Kontrol işleminde 1. ve 1000. satır kullanılacaktır. Açıklaması aşağıda kontrol işleminde yapılacak.
* Son işlemle beraber kullanacağım 1000 adet 7'li bağlantı kümelerini biliyorum.
## Kodlar nasıl oluşmakta?
* Kodlar, ilk indexleri kümeden sırayla alınarak oluşmaktadır. 
* Burada son karakter için bir durum oluşmaktadır. 1000, 23'e tam bölünemediği için son karakter ile başlayan (1000 % 22)= 10 adet kod üretilecektir ve diğer ilk 22 karakter ile başlayan 990/22 = 45 adet kod üretilecektir.
* Bu 45'li kodlar yukarda aldığım 1000'li tablodaki sıralı 45'li bloklardan oluşmaktadır.
* Örneğin A(kümedeki 1. index) ile başlayan ve arasındaki 7 bağlantı olacak olan kodları, yukardaki 1000'li tablodaki ilk 45 satır oluşturacaktır. C(kümedeki 2.index) ile başlayanları 2. 45 satır diye devam etmektedir. Son index(23. index) için son 10 satır kullanılacaktır.
## Örnek kod oluşturalım
* Örneğin D(3. index) ile başlayan 8 karakterli bir kod oluşturalım ve 8 karakterin arasındaki bağlantılar da 10,5,18,16,6,2,21 olsun.
* 1.karakter 3. index = D
* 2.karakter 3 + 10 = 13. index = R
* 3.karakter 3 + 10 + 2 = 15. index = X
* 4.karakter 3 + 10 + 2 + 18 = 33 (küme 23 karakter içeridiği için 33%23) = 10. index = M
* 5.karakter 3 + 10 + 2 + 18 + 16 = 49 (küme 23 karakter içeridiği için 49%23) = 3. index =  C
* 6.karakter 3 + 10 + 2 + 18 + 16 + 6 = 55 (küme 23 karakter içeridiği için 55%23) = 9. index = L
* 7.karakter 3 + 10 + 2 + 18 + 16 + 6 + 2 = 57 (küme 23 karakter içeridiği için 57%23) = 11. index = N
* 8.karakter 3 + 10 + 2 + 18 + 16 + 6 + 2 + 21 = 78 (küme 23 karakter içeridiği için 78%23) = 3. index = L
### Oluşan kod: DRXMCLNL
* Bu işlem 1000 kez yukarda belirlenen kurallar dahilinde tekrarlanmaktadır.

## KOD KONTROL ALGORİTMASI

* Gelen kodun karakterlerinin 23'lü küme içerisindeki indexlerini buldum.
* Indexleri arasındaki bağlantııyı buldum.

## Örnek kontrol yapalım
* ANE7EGPN kodunun kontrolünü yapalım
* Karakter indexleri:
* 1.karakter A: 1
* 2.karakter N: 11
* 3.karakter E: 4
* 4.karakter 7: 22
* 5.karakter E: 4
* 6.karakter G: 6
* 7.karakter P: 12
* 8.karakter N: 11

## Bağlantıları bulalım
* 1.Bağlantı: 11 - 1 = 10
* 2.Bağlantı: 4 - 11 = (4, 11'den küçük ve kümenin başına dönülür. 4 + 23 - 11) = 16
* 3.Bağlantı: 22 - 4 = 18
* 4.Bağlantı: 4 - 22 = (4, 22'den küçük ve kümenin başına dönülür. 4 + 23 - 22) = 5
* 5.Bağlantı: 6 - 4 = 2
* 6.Bağlantı: 12 - 6 = 6
* 7.Bağlantı: 11 - 12 = (11, 12'den küçük ve kümenin başına dönülür. 11+ 23 - 22) = 22

Bağlantılarım sırasıyla 10, 16, 18, 5, 2, 6, 22 olarak belirlendi.
### Burası kritik!!!
Bunları string şeklinde toplayalım ve bigint'e dönüştürelim. 10161852622. Bu sayıyı kullanacağım.

Bağlantılar (2),(5),(6),(10),(16),(18),(21),(22) kümesinin(oluşturken kullandığım küme) içerisinde olmalı ve tekrar etmemeli. Kümede en fazla bir bağlantı boşta kalmalı.
Bağlantılar küme içerisinden oluşmadıysa veya tekrar ediyorsa kod geçersiz.
Bağlantılar doğru şekilde oluştu, son bir kontrol yapılacak.
Az önce oluşturduğum 10161852622 sayısını, 8 kolondan ve 40.320 satırdan oluşan ve ilk 1000 satırının ilk ve son karakteri ile kontrol ettim.
10161852622 sayısı, ilk karaktere büyük veya eşit ve son karakterden küçük veya eşit olmalıdır.

### Son kontrol olamasaydı ne olurdu?
Son kontrol olmasaydı, bağlantıları (2),(5),(6),(10),(16),(18),(21),(22) oluşan bir kod geldiğini varsayalım. Bu kod P(8,7)= 40.320 adet bağlantı çeşidinden harhangi biri olabilirdi. Bağlantılardan oluşturulan sayıları küçükten büyüğe sıralayarak ve ilk 1000'ini alarak hangi bğlantıları kullandığımı bilerek herhngi bir kod olma ihtimalini devre dışı bıraktım.

Not: Çözüm 1000 kod oluşturmak için yazılmıştır.

#### 10.000.000 kod üretimi için ne yapılmalı?
10.000.000 kod üretimi için 2 ile 22 arasındaki sayıların kümesinin 7 li permütasyonu alınır ve P(21,7)=586.051.200 kadar olasılık elde edilir.
Bu olasılıklar yine satırları string toplama yapılarak ve sonrasında bigint'e çevrilir, küçükten büyüğe sıralanır, ilk 10.000.000 olasılık alınır.
Her harf ile başlayacak olan kod sayısı bulunur. İlk 22 karakter ile başlayacak 9.999.990 / 22 = 454.545, son karakter ile başlayacak 10 kod oluşacak.
Sonrasında harfler ile başlayan bloklardaki bağlantılar kullanılarak kodlar oluşur.

#### 10.000.000 kod kontrolü için ne yapılmalı?
Bağlantılar kontrol edilmeli ve 2 ile 22 arasındaki sayıların kümesi içinde olmalı tekrar etmemeli.
Bağlantılar string toplama yapılmalı ve string bigint'e çevrilmeli.
P(21,7)=586.051.200 kadar ihtimalin satırları string toplama yapılmalı ve sonrasında bigint'e çevrilmeli, küçükten büyüğe sıralanmalı.
Gelen kodun bağlantıları sayıya dönüştürülmüştü ve bu sayı 1. ve 10.000.000 satırların sayı değeri arasında veya eşit olmalı.


# DERLEME VE ÇALIŞTIRMA

Proje, Console Application tipinde oluşturulmuştur. Visual Studio ile doğrudan çalıştırabilirsiniz.

# SONUÇ

ACDEFGHKLMNPRTXYZ234579 karakter kümesini içeren, ardışık olmayacak şekilde belirlenen algoritmaya uygun olarak kodlar oluşturulmuştur.
Yine kod kontrolü kod tablosuna bakılmaksızın oluşturulan algoritma ile kontrol edilmiştir.
