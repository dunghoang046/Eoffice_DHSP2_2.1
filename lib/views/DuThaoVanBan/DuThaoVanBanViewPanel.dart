import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:app_eoffice/models/DuThaoVanBanItem.dart';
import 'package:app_eoffice/utils/Base.dart';

class ViewDuThaoVanBanPanel extends StatelessWidget {
  DuThaoVanBanItem obj;
  ViewDuThaoVanBanPanel({@required this.obj});

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
        // border: Border.all(
        //   color: Colors.red[500],
        // ),
      ),
      padding: EdgeInsets.all(7),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: <Widget>[
          containerRow(
              'Ngày tạo: ',
              obj.ngaytao != null
                  ? formatDate(
                      DateTime.parse(obj.ngaytao), [dd, '/', mm, '/', yyyy])
                  : ''),
          containerRow('Người tạo: ', obj.tennguoitao),
          containerRow('Trạng thái: ', obj.strTrangThai),
          containerRow('Người phê duyệt: ', obj.tennguoiky),
          containerRow('Loại văn bản: ', obj.tenloaivanban),
          containerRow('Trích yếu: ', obj.trichyeu),
          if ((obj.trangthaiid == 5 || obj.isvanbandi) &&
              nguoidungsessionView.id == obj.nguoitaoid)
            containerRow('Trạng thái người dùng: ', 'Đã xử lý'),
          if (nguoidungsessionView.id == obj.nguoitaoid &&
              (obj.trangthaiid != 5 || !obj.isvanbandi))
            containerRow('Trạng thái người dùng: ', 'Đang xử lý'),
          if (obj.lstfile.length > 0) containerRow('File đính kèm: ', ''),
          for (var i = 0; i < obj.lstfile.length; i++)
            containerRow('', obj.lstfile[i].ten),
        ],
      ),
    );
  }

  var underlineStyle =
      TextStyle(decoration: TextDecoration.underline, color: Colors.black);
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
}