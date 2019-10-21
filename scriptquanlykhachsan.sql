
create database qlKhachSan;
use qlKhachSan;

create table tblChiTiet_Phong
(
	maLoaiPhong int identity(1,1) primary key,
	tenLoaiPhong Nvarchar(30),
	
	donGiaGio int not null,
	
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
    gioiTinh nvarchar(5),
	ngaySinh datetime
)
alter table tblkhachhang
alter COLUMN ngaySinh datetime;

create table tblDichVu
(
	maDichVu int identity(1,1) primary key,
	tenDichVu Nvarchar(30),
	donGia int
)
drop TABLE tblhoadon
create table tblHoaDon
(
	maHoaDon int identity(1,1) not null,
	maKhachHang int not null references tblKhachHang(maKhachHang),
	maNhanVien int not null references tblNhanVien(maNhanVien),
	ngayLap datetime default(getdate()),
	
)
ALTER table tblHoaDon
 add primary key(mahoadon);

create table tblHD_datPhong
(
	maHoaDon int PRIMARY key ,
	tgDat datetime default(getdate()),
	tienCoc int default('0'),
	 FOREIGN KEY(mahoadon) REFERENCES tblHoaDon(mahoadon)
	
)


create table tblHD_phong
(
	maHoaDon int not null references tblHoaDon(maHoaDon),
	maPhong int not null references tblPhong(maPhong),
	gioCheckIn datetime,
	gioCheckOut datetime,

);
 alter table tblhd_phong
add PRIMARY key(mahoadon,maphong);

create table tblHD_dichvu
(
	mahoaDon int not null references tblHoaDon(maHoaDon),
	maPhong int not null references tblPhong(maPhong),
	maDichVu int not null references tblDichVu(maDichVu),
	soLanSD int default('0')
)
alter table tblHD_dichvu
add PRIMARY key(maHoaDon,maphong,maDichVu);
DELETE tblKhachHang;
use qlKhachSan;
insert into tblKhachHang (tenKhachHang,soDT,soCMT,gioiTinh,ngaySinh)
VALUES
(N'Trần Đức Huy','0347112405','013506263','nam','1997-04-28');
insert into tblKhachHang (tenKhachHang,soDT,soCMT,gioiTinh,ngaySinh)
VALUES
(N'Ivan','03456667898','012506465','nam','2001-3-20');
insert into tblKhachHang (tenKhachHang,soDT,soCMT,gioiTinh,ngaySinh)
VALUES
(N'Iosif Vissarionovich Stalin','03479573116','012406465','nam','1878-2-21');
insert into tblKhachHang (tenKhachHang,soDT,soCMT,gioiTinh,ngaySinh)
VALUES
(N'Adolf Hitler','03424688265','63422406','nam','1889-4-20');

insert into tblKhachHang (tenKhachHang,soDT,soCMT,gioiTinh,ngaySinh)
VALUES
(N'Benito Mussolini ','03424688265','66601237','nam','1883-7-29');

insert into tblKhachHang (tenKhachHang,soDT,soCMT,gioiTinh,ngaySinh)
VALUES
(N'Adolf Hitler','03424688265','99959334','nam','1889-4-20');
----phong--
INSERT into tblPhong(soPhong,maLoaiPhong,tinhTrang) VALUES
(101,1,1),(201,2,1),(301,2,1),(302,3,1);

--loaiphong--
insert INTO tblChiTiet_Phong(tenLoaiPhong,donGiaGio)
VALUES(N'phòng đơn',50000),(N'phòng đôi',50000),(N'Phòng đơn view biển',99000);
--nhanvien--
insert into tblNhanVien(tenNhanVien) values(N'Diễm Quyên'),(N'Đức Huy'),(N'Tuệ Minh');
--dichvu--
insert into tblDichVu (tenDichVu,donGia) VALUES(N'Massage',200000),(N'Thuê xe máy',100000),(N'xe điện ra biển',10000);
--hoadon--
insert into tblHoaDon(maKhachHang,maNhanVien,ngayLap) VALUEs
(1,1,'2018-1-2'),(1,1,'2018-1-20'),(2,2,'2019-4-28'),(3,1,'2018-8-20');
--hoadon-datphong--
insert into tblHD_datPhong (maHoaDon,tienCoc)values(4,200000),(2,300000),(3,200000);
--hoadonphong--
insert into tblHD_phong(maHoaDon,maPhong,gioCheckIn,gioCheckOut) VALUES(2,3,'2018-1-2 14:00:00','2018-1-5 10:00:00');
insert into tblHD_phong(maHoaDon,maPhong,gioCheckIn,gioCheckOut) VALUES(2,4,'2018-1-2 14:00:00','2018-1-5 14:00:00');
insert into tblHD_phong(maHoaDon,maPhong,gioCheckIn,gioCheckOut) VALUES(3,3,'2018-1-20 14:00:00','2018-1-22 10:00:00');
insert into tblHD_phong(maHoaDon,maPhong,gioCheckIn,gioCheckOut) VALUES(4,6,'2019-4-28 14:00:00','2019-4-30 10:00:00');
insert into tblHD_phong(maHoaDon,maPhong,gioCheckIn,gioCheckOut) VALUES(5,5,'2018-8-20 14:00:00','2018-8-29 10:00:00');
--hoadondichvu--
insert into tblHD_dichvu(maHoaDon,maPhong,maDichVu,soLanSD)
VALUES(2,3,1,3),(2,3,2,1),(2,4,1,3),(3,3,1,1),(4,6,1,2),(5,5,3,3);

use qlKhachSan
SELECT * from tblChiTiet_Phong;
select * from tblKhachHang;
select * from tblphong;
select * from tblNhanVien;
SELECT * from tblDichVu;
select * from tblHoaDon;
select * from tblHD_datPhong;
select * from tblHD_phong;
SELECT * from tblHD_dichvu;

-----view------------
GO



GO
---trigger--
create trigger gioitinh on tblKhachHang  after insert,update
as
	declare @gioitinh nvarchar(3)
begin
	select @gioitinh= (select gioitinh from inserted)
	if(@gioitinh != N'nam' AND @gioitinh != N'nữ')
		begin
		raiserror(N'giới tính sai, nhập lại',16,1)
		rollback tran
		end
end
drop TRIGGER tuoi;
Go
create TRIGGER tuoi on tblKhachHang for insert,update
as
    declare @tuoi INT
    BEGIN
        select @tuoi= (select DATEDIFF(YEAR,ngaysinh,GETDATE()) as tuoi from inserted)
            if(@tuoi <17)
            BEGIN
            RAISERROR(N'Không lưu thông tin khách hàng dưới 16 tuổi',16,1)
            ROLLBACK TRAN
            end

end


GO
------proc---------------

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
Exec doanhthutheothangvanam 1,2018;
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
Exec doanhthunhanvientheothang 1,2018,1;
select tblnhanvien.tenNhanVien from tblnhanvien 
where tblnhanvien.manhanvien=1;

-----
go
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
Exec phong_e_theo_thang 1,2018;
drop proc tinhtienhoadon
go 
create proc tinhtienhoadon
@mahoadon INT
AS
begin
	select  @mahoadon as mahoadon,maphong,DATEDIFF(HOUR,giocheckin,gioCheckOut) as so_gio_o,maDichVu,soLanSD,(select Sum(DATEDIFF(HOUR,giocheckin,gioCheckOut)*donGiaGio+ soLanSD*donGia) as tongdoanhthu  
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
