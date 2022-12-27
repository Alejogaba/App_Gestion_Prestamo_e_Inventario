import 'dart:async';

import 'package:app_gestion_prestamo_inventario/flutter_flow/flutter_flow_theme.dart';
import 'package:app_gestion_prestamo_inventario/flutter_flow/nav/nav.dart';

import 'package:flutter/material.dart';

import 'package:update_app/bean/download_process.dart';

import 'package:update_app/update_app.dart';

class ActualizarPageWidget extends StatefulWidget {
  final String url;
  const ActualizarPageWidget({Key? key, required this.url}) : super(key: key);
  @override
  _ActualizarPageWidgetState createState() =>
      _ActualizarPageWidgetState(this.url);
}

class _ActualizarPageWidgetState extends State<ActualizarPageWidget> {
  //定时更新进度
  Timer? timer;

  //下载进度
  double downloadProcess = 0;

  //下载状态
  String downloadStatus = "";
  String url;

  _ActualizarPageWidgetState(this.url);

  @override
  void initState() {
    super.initState();
    download(context, url);
  }

  @override
  Widget build(BuildContext context1) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Actualizar aplicacion',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context1).primaryColor,
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  color: FlutterFlowTheme.of(context1).primaryColor,
                  value: downloadProcess,
                  strokeWidth: 10,
                ),
              ),
              Text("Estado de descarga: $downloadStatus"),
            ],
          ),
        ),
        bottomNavigationBar: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Descargando...'),
              ],
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            download(context1, url);
          },
          child: Icon(Icons.file_download),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void download(BuildContext context1, String url) async {
    var downloadId = await UpdateApp.updateApp(url: url, appleId: "375380948");

    //本地已有一样的apk, 下载成功
    if (downloadId == 0) {
      setState(() {
        downloadProcess = 1;
        downloadStatus = ProcessState.STATUS_SUCCESSFUL.toString();
      });
      return;
    }

    //出现了错误, 下载失败
    if (downloadId == -1) {
      setState(() {
        downloadProcess = 1;
        downloadStatus = ProcessState.STATUS_FAILED.toString();
      });
      return;
    }

    //正在下载文件
    timer = Timer.periodic(Duration(milliseconds: 50), (timer) async {
      var process = await UpdateApp.downloadProcess(downloadId: downloadId);
      //更新界面状态
      setState(() {
        downloadProcess = process.current / process.count;
        downloadStatus = process.status.toString();
      });

      if (process.status == ProcessState.STATUS_SUCCESSFUL ||
          process.status == ProcessState.STATUS_FAILED) {
        //如果已经下载成功, 取消计时
        timer.cancel();
        if (process.status == ProcessState.STATUS_SUCCESSFUL) {
          // ignore: use_build_context_synchronously
          context.pop();
        }
      }
    });
  }
}
