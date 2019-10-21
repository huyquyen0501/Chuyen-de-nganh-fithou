use qlKhachSan;
drop TRIGGER gioitinh;
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
--proc
---proc tinh hoa don--

------
create PROC doanhthutheothang 
@thang int,
@nam INT,
@temp INT
as 
BEGIN
    select (select DATEDIFF(HOUR,giocheckin,giocheck))



---select thu--
select *--Sum(DATEDIFF(HOUR,giocheckin,gioCheckOut)*donGiaGio+ soLanSD*donGia)
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
		LEFT JOIN
		(select hd.manhanvien,nv.tenNhanVien from tblNhanVien nv
			left join tblhoadon Hd
			on nv.maNhanVien=hd.maNhanVien
		
		) S3
		ON S1.manhanvien=S3.manhanvien
		where YEAR(gioCheckOut)=2018 AND MONTH(gioCheckOut)=1 and S3.maNhanVien=1


        select *--  Sum(DATEDIFF(HOUR,giocheckin,gioCheckOut)*donGiaGio+ soLanSD*donGia) as tongdoanhthu  
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
		where YEAR(gioCheckOut)=2018 AND MONTH(gioCheckOut)=1

        SELECT sum(DATEDIFF(hour,giocheckin,giocheckout))



        select * from tblhoadon

        select Sum(DATEDIFF(HOUR,giocheckin,gioCheckOut)*donGiaGio+ soLanSD*donGia) as tongdoanhthu  
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
		where S1.mahoaDon=5
        select DATEDIFF(hour,giocheckin,gioCheckOut)
        from tblHD_Phong
        WHERE mahoadon=5