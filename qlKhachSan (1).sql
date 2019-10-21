create database qlKhachSan
use qlKhachSan

create table tblChiTiet_Phong
(
	maLoaiPhong int identity(1,1) primary key,
	tenLoaiPhong Nvarchar(30),
	donGiaNgay int not null,
	donGiaGio int not null,
	donGia2GioDau int not null
)

create table tblPhong
(
	maPhong int identity(1,1) primary key,
	soPhong int not null,
	maLoaiPhong int,
	tinhTrang bit,
	
	constraint FK_Phong_CTphong 
	FOREIGN KEY (maLoaiPhong) 
	references tblChiTiet_phong(maLoaiPhong)
)

create table tblNhanVien
(
	maNhanVien int identity(1,1) primary key,
	tenNhanVien Nvarchar(30),
	ngaySinh smalldatetime,
	gioiTinh bit,
	ngayVaoLam smalldatetime,
	diaChi Nvarchar(50)
)

create table tblKhachHang
(
	maKhachHang int identity(1,1) primary key,
	tenKhachHang Nvarchar(30),
	soCMT varchar(15) unique,
	soDT varchar(15),
	ngaySinh smalldatetime
)

create table tblDichVu
(
	maDichVu int identity(1,1) primary key,
	tenDichVu Nvarchar(30),
	donGia int
)

create table tblHoaDon
(
	maHoaDon int identity(1,1) primary key,
	maKhachHang int not null references tblKhachHang(maKhachHang),
	maNhanVien int not null references tblNhanVien(maNhanVien),
	ngayLap datetime default(getdate()),
)

create table tblHD_datPhong
(
	maHoaDon int references tblHoaDon(maHoaDon),
	tgDat datetime default(getdate()),
	tienCoc int default('0')
)

alter table tblHD_phong
(
	maHoaDon int references tblHoaDon(maHoaDon),
	maPhong int references tblPhong(maPhong),
	gioCheckIn datetime is null,
	gioCheckOut datetime is null,

)

create table tblHD_dichvu
(
	mahoaDon int references tblHoaDon(maHoaDon),
	maPhong int references tblPhong(maPhong),
	maDichVu int references tblDichVu(maDichVu),
	soLanSD int default('0')
)
-------CODE CỦA TÙNG
--view---

--kiem tra thoi gian su dung cac phong trong hoa don--

create view tgsudung
as
select hdp.maHoaDon, hdp.maPhong, datediff(HOUR,hdp.gioCheckIn,hdp.gioCheckOut) as 'gio su dung'
from tblHD_phong as hdp, tblPhong as p
where hdp.maPhong = p.maPhong

select*from tgsudung

--kiem tra cac hoa don duoc lap trong thang nay--

create view hoadontrongthang
as
select hd.maHoaDon, kh.tenKhachHang, nv.tenNhanVien, hd.ngayLap
from tblHoaDon as hd, tblKhachHang as kh, tblNhanVien as nv
where MONTH(ngayLap) = MONTH(GETDATE()) and hd.maKhachHang = kh.maKhachHang and hd.maNhanVien = nv.maNhanVien

select*from hoadontrongthang
go
-- kiểm tra các dịch vụ sử dụng của từng phòng trong hóa đơn--

create view ktdichvu
as
select tblHoaDon.maHoaDon, tblPhong.soPhong, tblDichVu.tenDichVu, tblHD_dichvu.soLanSD
from tblHD_dichvu
inner join tblHoaDon on tblHD_dichvu.mahoaDon = tblHoaDon.maHoaDon
inner join tblPhong on tblHD_dichvu.maPhong = tblPhong.maPhong
inner join tblDichVu on tblHD_dichvu.maDichVu = tblDichVu.maDichVu


select*from ktdichvu
-- hien thi cac so tien coc cua tung hoa don--

create view kttiencoc
as
select tblHoaDon.maHoaDon, tblKhachHang.tenKhachHang,tblHD_datPhong.tgDat as 'thoi gian dat phong', tblHD_datPhong.tienCoc
from tblHD_datPhong 
 inner join tblHoaDon on tblHoaDon.maHoaDon = tblHD_datPhong.maHoaDon
 inner join tblKhachHang on tblKhachHang.maKhachHang = tblHoaDon.maKhachHang
 group by tblHoaDon.maHoaDon,tblKhachHang.tenKhachHang,tblHD_datPhong.tgDat,tblHD_datPhong.tienCoc

 select*from kttiencoc
Kết thúc cuộc trò chuyện
Nhập tin nhắn...



-- rang buoc trigger va proc--
go



-- lập hóa đơn--
create proc laphoadon
(
	@maKhachHang int, @maNhanVien int, @tienCoc int
)
as
begin
	insert into tblHoaDon( maKhachHang, maNhanVien)
	values (@maKhachHang, @maNhanVien)
	select @@identity 
	insert into tblHD_datPhong(maHoaDon,tienCoc)
	values(@@IDENTITY,@tienCoc)
end

go

exec laphoadon '6','2','200000'
go
-- kiểm tra hóa đơn bằng cách nhập vào số hóa đơn--

create proc ktHoaDon
(
	@maKhachHang int
)
as
begin
	select kh.maKhachHang as 'mã khách hàng', kh.tenKhachHang as 'tên Khách hàng', hd.maHoaDon as 'mã hóa đơn', 
	hd.ngayLap as 'ngày lập',nv.tenNhanVien as 'người lập' , hdp.tienCoc as 'tiền cọc'
	from tblKhachHang as kh, tblHoaDon as hd, tblNhanVien as nv, tblHD_datPhong as hdp
	where @maKhachHang = hd.maKhachHang and hd.maKhachHang = kh.maKhachHang and hd.maHoaDon = hdp.maHoaDon 
	and hd.maNhanVien = nv.maNhanVien
end
go

exec ktHoaDon '1'
go

-- kiểm tra các phòng trong hóa đơn bằng cách nhập vào số hóa đơn--
create proc kiemtraphong_hd
(
	@maHoaDon int
)
as
begin
	select hd.maHoaDon as 'mã hóa đơn', hdp.maPhong as 'mã phòng', p.soPhong as 'số phòng'
	from tblHoaDon as hd, tblHD_phong as hdp, tblPhong as p
	where @maHoaDon = hd.maHoaDon and hd.maHoaDon = hdp.maHoaDon and hdp.maPhong= p.maPhong
end

exec kiemtraphong_hd '3'
go


-- cập nhật các phòng được khách hàng thuê--
create proc thuePhong
(
	@maHoaDon int, @maPhong int
)
as
begin
	insert into tblHD_phong(maHoaDon,maPhong)
	values (@maHoaDon, @maPhong)
end
go

exec thuePhong '8','1'
exec thuePhong '1', '5'
go

-- cập nhật thời gian check in của từng phòng--
create proc updateNhanPhong
(
	@maHoaDon int, @maPhong int
)
as
begin
	declare @gioCheckIn datetime
	set @gioCheckIn = GETDATE()
	update tblHD_phong
	set gioCheckIn = @gioCheckIn
	where @maHoaDon = maHoaDon and @maPhong = maPhong
end

exec updateNhanPhong '3' , '3'
go


-- cập nhật thời gian check out của từng phòng--
create proc updateTraPhong
(
	@maHoaDon int, @maPhong int
)
as
begin
	declare @gioCheckOut datetime
	set @gioCheckOut = GETDATE()
	update tblHD_phong
	set gioCheckOut = @gioCheckOut
	where @maHoaDon = maHoaDon and @maPhong = maPhong
end
go


exec updateTraPhong '6','8'

--trigger khi thêm phòng vào hóa đơn đặt phòng- tình trạng phòng đó phải là true--

create trigger KTtinhtrangphong
on tblHD_phong
for insert, update
as
	if(UPDATE(maPhong))
	begin
		declare @tinhTrang bit, @maPhong int
		set @maPhong = (select maPhong from inserted)
		set @tinhTrang = (select tblPhong.tinhTrang from tblPhong where @maPhong = tblPhong.maPhong)
		if(@tinhTrang = 0)
		begin
			print(N'phòng đã được thuê hoặc đang sửa chữa')
			rollback tran
		end
		else
			begin
			print(N'Phòng được đặt thành công')
			end
	end

--trigger update lai tinh trang phong sau khi khach den nhan nhan phong--

create trigger upttphong
on tblHD_Phong
for insert, update
as
	if(UPDATE(gioCheckIn))
	begin	
		update tblPhong set tinhTrang = 0 
		from inserted
		where tblPhong.maPhong = inserted.maPhong
		print(N'đã cập nhật lại tình trạng phòng')
end

--trigger update lai tinh trang phong sau khi duoc tra phong--

create trigger upttphong2
on tblHD_Phong
for insert, update
as
	if(UPDATE(gioCheckOut))
	begin	
		update tblPhong set tinhTrang = 1 
		from inserted
		where tblPhong.maPhong = inserted.maPhong
		print(N'đã cập nhật lại tình trạng phòng')
end



									--CODE CỦA CHUNG
create proc laphoadon
(
	@maKhachHang int, @maNhanVien int, @tienCoc int
)
as
begin
	insert into tblHoaDon( maKhachHang, maNhanVien)
	values (@maKhachHang, @maNhanVien)
	select @@identity 
	insert into tblHD_datPhong(maHoaDon,tienCoc)
	values(@@IDENTITY,@tienCoc)
end
exec laphoadon '1','1','300000'
--thu tuc them 1 phong
create proc themphong
(@sophong int,@maloaiphong int, @tinhtrang bit)
as
begin
      insert into tblPhong(soPhong,maLoaiPhong,tinhTrang)
	  values(@sophong,@maloaiphong,@tinhtrang)
	  end
Exec themphong '300','1','1'
Exec themphong '333','2', '1'
Exec themphong '200','3','0'
Exec themphong '400','4','0'

--thu tuc them 1 dich vu
create proc themdichvu
(@tendichvu Nvarchar(20), @dongia int)
as
begin
       insert into tblDichVu(tenDichVu,donGia)
	   values(@tendichvu,@dongia)
	   end
Exec themdichvu 'Do uong','40000'
Exec themdichvu 'An trua','50000'

-- tao thu tuc them hoa don phong
create proc nhanphong
(@mahoadon int ,@maphong int ,@GiocheckIn datetime)
as
begin 
	insert into tblHD_phong(maHoaDon,maPhong,gioCheckIn)
	values(@mahoadon,@maphong,@GiocheckIn)
end	 
go
Exec nhanphong '1','1','2019-11-11 03:04:02'
--tao thu tuc them hoa don dich vu
create proc themhddv
(@mahd int, @maph int,@madv int, @solansd int)	
as 
begin
		insert into tblHD_dichvu(mahoaDon,maPhong,maDichVu,soLanSD)
		values(@mahd,@maph,@madv,@solansd)
end
exec themhddv  '1','1','1','3'



--pro tìm hóa đơn theo khách hàng
create proc ktHoaDonkh
(
	@maKhachHang int
)
as
begin
	select k.maKhachHang as 'mã khách hàng', k.tenKhachHang as 'tên Khách hàng', h.maHoaDon as 'mã hóa đơn', 
	h.ngayLap as 'ngày lập',n.tenNhanVien as 'người lập' , hp.tienCoc as 'tiền cọc'
	from tblKhachHang as k, tblHoaDon as h, tblNhanVien as n, tblHD_datPhong as hp
	where @maKhachHang = h.maKhachHang and h.maKhachHang = k.maKhachHang and h.maHoaDon = hp.maHoaDon 
	and h.maNhanVien = n.maNhanVien
end
go

exec ktHoaDon '1'
-- rang buoc trigger va proc--
create trigger ktratinhtrangphong on tblPhong
for  insert, update
as if update(tinhTrang)
begin
	 declare @Giocheckin datetime, @Giocheckout datetime   
     set @Giocheckin= (Select tblHD_phong.gioCheckIn from tblHD_phong)
	 set @Giocheckout=(Select tblHD_phong.gioCheckOut from tblHD_phong)
	 if(@Giocheckin != Null )
	 update tblPhong
	 set tinhTrang='1' 
	 from tblPhong , tblHD_phong
	 where tblHD_phong.maPhong=tblPhong.maLoaiPhong 
end
-- view1 xem danh sach khach hang da dat phong
create view dskhdadatphong 
as 
	select  tenKhachHang, soCMT ,tgDat 
	from tblKhachHang, tblHoaDon , tblHD_datPhong
	where tblHoaDon.maKhachHang=tblKhachHang.maKhachHang and  tblHD_datPhong.maHoaDon = tblHoaDon.maHoaDon

select*from dskhthuephong

create view dskhthuephong
as
select kh.maKhachHang, kh.tenKhachHang, hdp.gioCheckIn
from tblKhachHang as kh, tblHoaDon as hd, tblHD_phong as hdp
where kh.maKhachHang = hd.maKhachHang and hd.maHoaDon = hdp.maHoaDon
--view2 xem ds kh đặt trên 2 phòng và hiện số phòng đã đặt


select * from dskhdattren2p

drop view dskhdattren2p



 
--  view3 xem khach hang thue tren 2 phong
create view dskhdattren2p
as 
	SELECT  kh.maKhachHang,kh.tenKhachHang, p.maHoaDon ,COUNT(1) as sopdadat 
	FROM tblHD_phong as p inner join tblHoaDon as hd on p.maHoaDon=hd.maHoaDon inner join tblKhachHang as kh on hd.maKhachHang=kh.maKhachHang
	GROUP BY p.maHoaDon , kh.maKhachHang,kh.tenKhachHang
	HAVING COUNT(1) > 1 
-- view4 khach hang da su dung dich vu
create view khdasudungdichvu
as	
	select kh.maKhachHang, kh.tenKhachHang,dv.tenDichVu,hddv.soLanSD
	from tblKhachHang as kh, tblHoaDon as hd, tblHD_dichvu as hddv,tblDichVu as dv
	where hddv.maHoaDon =hd.maHoaDon and hd.maKhachHang = kh.maKhachHang and hddv.maDichVu=dv.maDichVu

select * from khdasudungdichvu
--view5 khach hang da su dung phong thuong đon
create view khdasudungpthuongdon
as
	SELECT  kh.maKhachHang,kh.tenKhachHang,p.soPhong,p.maLoaiPhong
	FROM tblPhong as p inner join tblHD_phong as hdp on p.maPhong=hdp.maPhong inner join tblHoaDon as hd on hdp.maHoaDon=hd.maHoaDon inner join tblKhachHang as kh on hd.maKhachHang=kh.maKhachHang
	where p.maLoaiPhong=1
select * from khdasudungpthuongdon
--view6 nhung phong con trong
create view phongchuasudung
as
	select* from tblPhong where tinhTrang=0
 -- view7 những khách hàng chỉ thue phòng theo giờ
 create view khchithuephongtheogio
 as
	select kh.maKhachHang, kh.tenKhachHang,DATEDIFF( hour,hdp.gioCheckIn,hdp.gioCheckOut) as sogiothue  from tblKhachHang as kh inner join tblHoaDon as hd on kh.maKhachHang=hd.maKhachHang inner join tblHD_phong as hdp on hd.maHoaDon=hdp.maHoaDon
	group by kh.maKhachHang ,kh.tenKhachHang,hdp.gioCheckIn,hdp.gioCheckOut
	having DATEDIFF( hour,hdp.gioCheckIn,hdp.gioCheckOut)!=null or DATEDIFF( hour,hdp.gioCheckIn,hdp.gioCheckOut)<24

select *from khchithuephongtheogio
--tính tổng tiền phòng khi xuất hóa đơn
alter proc tinhtien
 (@makhachhang int)
 as
 begin 
	DECLARE @dongiaphong float, @thoigianthue int,@giocheckin datetime,@giocheckout datetime;
	
		set @giocheckin=   (select   hdp.gioCheckIn from tblHD_phong as hdp , tblHoaDon as hd  , tblKhachHang as kh
		where @makhachhang=kh.maKhachHang and kh.maKhachHang=hd.maKhachHang and hdp.maHoaDon=hd.maHoaDon  );
		set @giocheckout=(select DISTINCT  hdp.gioCheckOut from tblHD_phong as hdp,tblHoaDon as hd, tblKhachHang as kh
		where @makhachhang=kh.maKhachHang and kh.maKhachHang=hd.maKhachHang and hd.maHoaDon=hdp.maHoaDon);
		DECLARE cursorCategories CURSOR FOR select   hdp.gioCheckIn,hdp.gioCheckOut from tblHD_phong as hdp , tblHoaDon as hd  , tblKhachHang as kh
		where @makhachhang=kh.maKhachHang and kh.maKhachHang=hd.maKhachHang and hdp.maHoaDon=hd.maHoaDon
		
	OPEN cursorCategories
	FETCH NEXT FROM cursorCategories INTO @giocheckin,@giocheckout

WHILE @@FETCH_STATUS = 0
begin
		set @thoigianthue=(  DATEDIFF(HOUR,@giocheckin,@giocheckout));
		if @thoigianthue < 2 
			begin
				set @dongiaphong= (select donGia2GioDau from tblChiTiet_Phong);
			end
		else set @dongiaphong= (select donGiaGio from tblChiTiet_Phong);
	select Sum(DATEDIFF(HOUR,giocheckin,gioCheckOut)*@dongiaphong) as tienphong
	from   tblChiTiet_Phong as ctp inner join tblPhong as p on ctp.maLoaiPhong=p.maLoaiPhong inner join tblHD_phong as hdp on p.maPhong=hdp.maPhong inner join tblHoaDon as hd on hdp.maHoaDon=hd.maHoaDon inner join tblKhachHang as kh on hd.maKhachHang=kh.maKhachHang
	where @makhachhang= kh.maKhachHang	
end		
end
exec tinhtien '1'
		


--							CODE CỦA HUY
create PROC doanhthutheothangvanam
@thang int,
@nam INT
as 
BEGIN
    
	select  Sum(DATEDIFF(HOUR,giocheckin,gioCheckOut)*donGiaGio+ soLanSD*donGia) as tongdoanhthu  
FROM
		(SELECT ph.maPhong,hdph.gioCheckOut,hdph.gioCheckIn,ctph.donGiaGio,hdph.maHoaDon
		from tblphong	 PH
		INNER join tblHD_Phong	 HDPH
		ON
		HDPH.maPhong=PH.maphong
		INNER join tblChiTiet_Phong	CTPH
		on PH.maLoaiPhong=CTPH.maLoaiPhong

		) S1
		LEFT  JOIN
		(select hddv.soLanSD,hd.maHoaDon,dv.donGia from tblHD_dichvu	hddv
			INNER join tblHoaDon hd
			on hddv.mahoaDon=hd.mahoaDon
			INNER join tblDichVu	  dv
			on dv.maDichVu=hddv.maDichVu
		) S2
		ON S1.mahoadon=S2.maHoaDon
		where YEAR(gioCheckOut)=@nam AND MONTH(gioCheckOut)=@thang
END
Exec doanhthutheothangvanam 11,2019;
------
-----test 2
drop PROC  doanhthunhanvientheothang
go
create proc doanhthunhanvientheothang
@thang int,
@nam int,
@maNhanVien INT
AS
BEGIN
	select  tblNhanVien.tenNhanVien,@nam as year, @thang as thang ,(select Sum(DATEDIFF(HOUR,giocheckin,gioCheckOut)*donGiaGio+ soLanSD*donGia)
	from
	(select hddv.soLanSD,hd.maHoaDon,dv.donGia,hd.manhanvien from tblHD_dichvu	hddv
			INNER join tblHoaDon hd
			on hddv.mahoaDon=hd.mahoaDon
			INNER join tblDichVu	  dv
			on dv.maDichVu=hddv.maDichVu
		) S1
		right JOIN
		(SELECT ph.maPhong,hdph.gioCheckOut,hdph.gioCheckIn,ctph.donGiaGio,hdph.maHoaDon
		from tblphong	 PH
		INNER join tblHD_Phong	 HDPH
		ON
		HDPH.maPhong=PH.maphong
		INNER join tblChiTiet_Phong	CTPH
		on PH.maLoaiPhong=CTPH.maLoaiPhong

		) S2
		ON S1.mahoadon=S2.maHoaDon
		
		where YEAR(gioCheckOut)=@nam AND MONTH(gioCheckOut)=@thang and maNhanVien=@maNhanVien	) as tongdoanhthu
	FROM  tblnhanvien
	where	tblNhanVien.maNhanVien=@maNhanVien
END		 
Exec doanhthunhanvientheothang 11,2019,1;
select tblnhanvien.tenNhanVien from tblnhanvien 
where tblnhanvien.manhanvien=1;

-----
go
--phong chua duoc su dung trong thang
create proc phong_e_theo_thang
@thang int,
@nam INT
as 
begin
	select ph.maphong,ph.soPhong from tblphong Ph
	EXCEPT
	SELECT ph.maphong,ph.soPhong
	from tblhd_phong hdph
	left join tblphong Ph
	on HDPH.maphong=ph.maphong
	where  year(hdph.giocheckin)=2018 and  MONTH(hdph.giocheckin)=1
	END
Exec phong_e_theo_thang 11,2019;
drop proc tinhtienhoadon
go 
create proc tinhtienhoadon
@mahoadon INT
AS
begin
	select DISTINCT @mahoadon as mahoadon,maphong,DATEDIFF(HOUR,giocheckin,gioCheckOut) as so_gio_o,maDichVu,soLanSD,(select Sum(DATEDIFF(HOUR,giocheckin,gioCheckOut)*donGiaGio+ soLanSD*donGia) as tongdoanhthu  
FROM
		(SELECT    hdph.maHoaDon,ph.maPhong,hdph.gioCheckOut,hdph.gioCheckIn,ctph.donGiaGio
		from tblphong	 PH
		INNER join tblHD_Phong	 HDPH
		ON
		HDPH.maPhong=PH.maphong
		INNER join tblChiTiet_Phong	CTPH
		on PH.maLoaiPhong=CTPH.maLoaiPhong

		) S1
		LEFT  JOIN
		(select hddv.madichvu,hddv.soLanSD,hd.maHoaDon,dv.donGia from tblHD_dichvu	hddv
			INNER join tblHoaDon hd
			on hddv.mahoaDon=hd.mahoaDon
			INNER join tblDichVu	  dv
			on dv.maDichVu=hddv.maDichVu
		) S2
		ON S1.mahoadon=S2.maHoaDon
		where S2.mahoaDon=@mahoadon) as tong_so_tien
		FROM
		(SELECT ph.maPhong,hdph.gioCheckOut,hdph.gioCheckIn,ctph.donGiaGio,hdph.maHoaDon
		from tblphong	 PH
		INNER join tblHD_Phong	 HDPH
		ON
		HDPH.maPhong=PH.maphong
		INNER join tblChiTiet_Phong	CTPH
		on PH.maLoaiPhong=CTPH.maLoaiPhong

		) S1
		LEFT  JOIN
		(select hddv.madichvu,hddv.soLanSD,hd.maHoaDon,dv.donGia from tblHD_dichvu	hddv
			INNER join tblHoaDon hd
			on hddv.mahoaDon=hd.mahoaDon
			INNER join tblDichVu	  dv
			on dv.maDichVu=hddv.maDichVu
		) S2
		ON S1.mahoadon=S2.maHoaDon
		where S2.mahoaDon=@mahoadon
	END
	EXEC tinhtienhoadon 3;
create proc tong_tien_khach_chi_tieu
	@makhachhang INT
	as
	BEGIN
		select @makhachhang as ma_khach_hang, tenKhachHang,(select Sum(DATEDIFF(HOUR,giocheckin,gioCheckOut)*donGiaGio+ soLanSD*donGia) as tongdoanhthu  
FROM
		(SELECT ph.maPhong,hdph.gioCheckOut,hdph.gioCheckIn,ctph.donGiaGio,hdph.maHoaDon
		from tblphong	 PH
		INNER join tblHD_Phong	 HDPH
		ON
		HDPH.maPhong=PH.maphong
		INNER join tblChiTiet_Phong	CTPH
		on PH.maLoaiPhong=CTPH.maLoaiPhong

		) S1
		LEFT  JOIN
		(select hd.maKhachHang,hddv.madichvu,hddv.soLanSD,hd.maHoaDon,dv.donGia from tblHD_dichvu	hddv
			INNER join tblHoaDon hd
			on hddv.mahoaDon=hd.mahoaDon
			INNER join tblDichVu	  dv
			on dv.maDichVu=hddv.maDichVu
		) S2
		ON S1.mahoadon=S2.maHoaDon
		where S2.makhachhang=@makhachhang) as tong_so_tien_da_chi
		from tblkhachhang
		where tblkhachhang.makhachhang=@makhachhang
		END
EXEC tong_tien_khach_chi_tieu 1;

		--						 CODE CỦA VIỆT
	--thủ tục thêm nhân viên
create proc themnhanvien
(@tennhanvien Nvarchar(15),@ngaysinh datetime,@gioitinh  bit,	@ngayVaoLam datetime,@diaChi Nvarchar(20)	)
as
begin	 
	  insert into tblNhanVien(tenNhanVien,ngaySinh,gioiTinh,ngayVaoLam,diaChi)
	  values(@tennhanvien,@ngaysinh,@gioitinh,@ngayVaoLam,@diaChi)
end
 Exec themnhanvien 'haha','19981001','1','20190706','NinhBinh'
select*from tblNhanVien		
	---xem những nhân viên đã tham gia lập hóa đơn
create view timnv
as
	select DISTINCT nv.maNhanVien,nv.tenNhanVien,nv.ngaySinh,nv.diaChi  from tblNhanVien as nv,tblHoaDon as hd
	where nv.maNhanVien=hd.maNhanVien
	select* from timnv	
	--xem những nhân viên có giới tính là nam
create view ktrgtinh
as
	select* from tblNhanVien where gioiTinh=1				