import 'package:app_eoffice/models/ThongTinDatPhongItem.dart';
import 'package:app_eoffice/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_html/flutter_html.dart';

class DatPhongViewPanel extends StatelessWidget {
  ThongTinDatPhongItem obj;
  DatPhongViewPanel({@required this.obj});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.green, width: 5),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.all(7),
      child: Column(
        children: <Widget>[
          containerRow('Nội dung: ', obj.noidung),
          containerRow('Điện thoại: ', obj.sodienthoai),
          containerRow('Email: ', obj.email),
          containerRow(
              'Thời gian: ',
              (obj.thoigianbatdau != null
                      ? formatDate(DateTime.parse(obj.thoigianbatdau),
                          [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn])
                      : '') +
                  (obj.thoigianketthuc != null
                      ? ' - ' +
                          formatDate(DateTime.parse(obj.thoigianketthuc),
                              [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn])
                      : '')),
          if (obj.lanhdaochutri != null)
            containerRow('Lãnh đạo chủ trì: ', obj.lanhdaochutri.toString()),
          if (obj.donvidangky != null)
            containerRow('Đơn vị đăng ký: ', obj.donvidangky),
          if (obj.nguoidangky != null && obj.nguoidangky.length > 0)
            containerRow('Người đăng ký: ', obj.nguoidangky),
          if (obj.thanhphanthamgia != null && obj.thanhphanthamgia.length > 0)
            containerRow('Thành phần: ', obj.thanhphanthamgia),

          if (obj.trangthaiid == 0 || obj.trangthaiid == 4)
            containerRow('Trạng thái: ', 'Tạo mới'),
          if (obj.trangthaiid == 1) containerRow('Trạng thái: ', 'Chờ duyệt'),
          if (obj.trangthaiid == 3) containerRow('Trạng thái: ', 'Đã duyệt'),
          if (obj.trangthaiid == 2) containerRow('Trạng thái: ', 'Từ chối'),
          if (obj.songuoi != null && obj.songuoi.length > 0)
            containerRow('Số người tham gia: ', obj.songuoi),
          if (obj.yeucau != null && obj.yeucau.length > 0)
            containerRow('Yêu cầu: ', obj.yeucau),
          if (obj.trangthaiid == 2) containerRow('Lý do: ', obj.lydo),
          // containerRow('Trạng thái: ', obj.strTrangthai),
          if (obj.lstfile != null && obj.lstfile.length > 0)
            containerRow('File đính kèm: ', ''),
          for (var i = 0; i < obj.lstfile.length; i++)
            containerRowViewfile(
                obj.lstfile[i].ten, obj.lstfile[i].id, obj.lstfile[i].filelink),
        ],
      ),
    );
  }

  Widget containerRow(String label, String value) => Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black26,
            ),
            // right: BorderSide(color: Colors.green, width: 6),
          ),
        ),
        padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
                child: RichText(
                    softWrap: true,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: label + '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      TextSpan(
                          text: value, style: TextStyle(color: Colors.black))
                    ])))
          ],
        ),
      );

  Widget containerRowHtml(String label, String value) => Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black26,
            ),
            // right: BorderSide(color: Colors.green, width: 6),
          ),
        ),
        padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
        child: Row(
          children: <Widget>[
            Expanded(child: Html(data: "<b>" + label + "</b>" + value)),
          ],
        ),
      );
}
