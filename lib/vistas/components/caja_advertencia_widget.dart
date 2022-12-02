import '../../servicios/activoController.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CajaAdvertenciaWidget extends StatefulWidget {
  final String mensaje;
  final String objetoaEliminar;
  final String id;
  final bool blur;

  const CajaAdvertenciaWidget(
      {Key? key,
      required this.mensaje,
      required this.objetoaEliminar,
      required this.id,
      required this.blur})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _CajaAdvertenciaWidgetState createState() =>
      _CajaAdvertenciaWidgetState(mensaje, objetoaEliminar, id, blur);
}

class _CajaAdvertenciaWidgetState extends State<CajaAdvertenciaWidget> {
  final String mensaje;
  final String objetoaEliminar;
  final String id;
  bool blur;

  _CajaAdvertenciaWidgetState(
      this.mensaje, this.objetoaEliminar, this.id, this.blur);

  @override
  Widget build(BuildContext contextCajaAdvertencia) {
    return Align(
      alignment: AlignmentDirectional(0, 0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 5),
        child: Container(
          width: 450,
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: 300,
          ),
          decoration: BoxDecoration(
            color:
                FlutterFlowTheme.of(contextCajaAdvertencia).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 7,
                color: Color(0x4D000000),
                offset: Offset(0, 3),
              )
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text(
                    'Advertencia',
                    style: FlutterFlowTheme.of(contextCajaAdvertencia)
                        .title2
                        .override(
                          fontFamily: 'Poppins',
                          color: Color(0xBFDF2424),
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(contextCajaAdvertencia)
                                  .title2Family),
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Text(
                    mensaje,
                    style: FlutterFlowTheme.of(contextCajaAdvertencia)
                        .bodyText1
                        .override(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(contextCajaAdvertencia)
                                  .bodyText1Family),
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () {
                      eliminarObjeto(
                          contextCajaAdvertencia, objetoaEliminar, id);
                    },
                    text: 'Sí, deseo eliminar este $objetoaEliminar',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50,
                      color: Color(0xFFFC4253),
                      textStyle: FlutterFlowTheme.of(contextCajaAdvertencia)
                          .subtitle2
                          .override(
                            fontFamily: 'Poppins',
                            color: FlutterFlowTheme.of(contextCajaAdvertencia)
                                .whiteColor,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(contextCajaAdvertencia)
                                    .subtitle2Family),
                          ),
                      elevation: 2,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    showLoadingIndicator: false,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          return 'cerrar';
                        },
                        text: 'No, cancelar',
                        options: FFButtonOptions(
                          width: 170,
                          height: 50,
                          color: FlutterFlowTheme.of(contextCajaAdvertencia)
                              .primaryBackground,
                          textStyle: FlutterFlowTheme.of(contextCajaAdvertencia)
                              .subtitle2
                              .override(
                                fontFamily: 'Poppins',
                                color:
                                    FlutterFlowTheme.of(contextCajaAdvertencia)
                                        .primaryText,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(contextCajaAdvertencia)
                                        .subtitle2Family),
                              ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        showLoadingIndicator: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  eliminarObjeto(context, String objeto, String id) async {
    switch (objeto) {
      case 'activo':
        ActivoController activoController = ActivoController();
        final res = await activoController.eliminarActivo(context, id);
        if (res == 'ok') context.pop;
        break;
      default:
    }
  }
}
