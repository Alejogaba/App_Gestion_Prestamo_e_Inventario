import '../flutter_flow/flutter_flow_autocomplete_options_list.dart';
import '../flutter_flow/flutter_flow_drop_down.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class AddItemWidget extends StatefulWidget {
  const AddItemWidget({Key? key}) : super(key: key);

  @override
  _AddItemWidgetState createState() => _AddItemWidgetState();
}

class _AddItemWidgetState extends State<AddItemWidget> {
  String? teamSelectValue;
  TextEditingController? shortBioController;
  TextEditingController? userNameController2;
  final userNameKey1 = GlobalKey();
  TextEditingController? userNameController1;
  String? userNameSelectedOption1;
  TextEditingController? userNameController3;
  String? userSelectValue;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    shortBioController = TextEditingController();
    userNameController1 = TextEditingController();
    userNameController2 = TextEditingController();
    userNameController3 = TextEditingController();
  }

  @override
  void dispose() {
    shortBioController?.dispose();
    userNameController2?.dispose();
    userNameController3?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: false,
        title: Text(
          'Registrar item',
          style: FlutterFlowTheme.of(context).title2,
        ),
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
            child: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30,
              buttonSize: 48,
              icon: Icon(
                Icons.close_rounded,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 30,
              ),
              onPressed: () async {
                context.pop();
              },
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                      child: Autocomplete<String>(
                        initialValue: TextEditingValue(),
                        optionsBuilder: (textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return ['Option 1'].where((option) {
                            final lowercaseOption = option.toLowerCase();
                            return lowercaseOption
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        optionsViewBuilder: (context, onSelected, options) {
                          return AutocompleteOptionsList(
                            textFieldKey: userNameKey1,
                            textController: userNameController1!,
                            options: options.toList(),
                            onSelected: onSelected,
                            textStyle: FlutterFlowTheme.of(context).title3,
                            textHighlightStyle: TextStyle(),
                            elevation: 4,
                            optionBackgroundColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            optionHighlightColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            maxHeight: 200,
                          );
                        },
                        onSelected: (String selection) {
                          setState(() => userNameSelectedOption1 = selection);
                          FocusScope.of(context).unfocus();
                        },
                        fieldViewBuilder: (
                          context,
                          textEditingController,
                          focusNode,
                          onEditingComplete,
                        ) {
                          userNameController1 = textEditingController;
                          return TextFormField(
                            key: userNameKey1,
                            controller: textEditingController,
                            focusNode: focusNode,
                            onEditingComplete: onEditingComplete,
                            onChanged: (_) => EasyDebounce.debounce(
                              'userNameController1',
                              Duration(milliseconds: 2000),
                              () => setState(() {}),
                            ),
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Nombre',
                              labelStyle:
                                  FlutterFlowTheme.of(context).title3.override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .title3Family,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .title3Family),
                                      ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0x00000000),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                  20, 32, 20, 12),
                            ),
                            style: FlutterFlowTheme.of(context).title3,
                            textAlign: TextAlign.start,
                          );
                        },
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                        child: TextFormField(
                          controller: userNameController2,
                          onChanged: (_) => EasyDebounce.debounce(
                            'userNameController2',
                            Duration(milliseconds: 3000),
                            () => setState(() {}),
                          ),
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Número serial',
                            labelStyle: FlutterFlowTheme.of(context).title3,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(20, 32, 20, 12),
                            suffixIcon: Icon(
                              Icons.qr_code_scanner_outlined,
                              color: Color(0xFF757575),
                              size: 32,
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).title3,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                      child: TextFormField(
                        controller: shortBioController,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Ingrese la descripción aquí...',
                          hintStyle: FlutterFlowTheme.of(context).bodyText2,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding:
                              EdgeInsetsDirectional.fromSTEB(20, 32, 20, 12),
                        ),
                        style: FlutterFlowTheme.of(context).bodyText1,
                        textAlign: TextAlign.start,
                        maxLines: 4,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                      child: FlutterFlowDropDown<String>(
                        initialOption: teamSelectValue ??= 'Crear categoría...',
                        options: ['Opción 1', 'Opción 2', 'Team 3'],
                        onChanged: (val) =>
                            setState(() => teamSelectValue = val),
                        width: double.infinity,
                        height: 60,
                        textStyle: FlutterFlowTheme.of(context).bodyText1,
                        hintText: 'Seleccione Categoría',
                        icon: Icon(
                          Icons.category,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 15,
                        ),
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        elevation: 2,
                        borderColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        borderWidth: 2,
                        borderRadius: 8,
                        margin: EdgeInsetsDirectional.fromSTEB(24, 4, 12, 4),
                        hidesUnderline: true,
                      ),
                    ),
                    if (teamSelectValue == 'Crear categoría...')
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                        child: TextFormField(
                          controller: userNameController3,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Nombre de la nueva categoría',
                            labelStyle: FlutterFlowTheme.of(context)
                                .title3
                                .override(
                                  fontFamily:
                                      FlutterFlowTheme.of(context).title3Family,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontWeight: FontWeight.normal,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .title3Family),
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding:
                                EdgeInsetsDirectional.fromSTEB(20, 32, 20, 12),
                          ),
                          style: FlutterFlowTheme.of(context).title3,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    if (teamSelectValue == 'Crear categoría...')
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: GridView(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1,
                                ),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'https://picsum.photos/seed/560/600',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'https://picsum.photos/seed/560/600',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'https://picsum.photos/seed/560/600',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      'https://picsum.photos/seed/560/600',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                      child: FlutterFlowDropDown<String>(
                        initialOption: userSelectValue ??= 'Oficina de las TIC',
                        options: ['User 1', 'Team 2', 'Team 3'],
                        onChanged: (val) =>
                            setState(() => userSelectValue = val),
                        width: double.infinity,
                        height: 60,
                        textStyle: FlutterFlowTheme.of(context).bodyText1,
                        hintText: 'Funcionario a asignar...',
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 15,
                        ),
                        fillColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        elevation: 2,
                        borderColor:
                            FlutterFlowTheme.of(context).primaryBackground,
                        borderWidth: 2,
                        borderRadius: 8,
                        margin: EdgeInsetsDirectional.fromSTEB(24, 4, 12, 4),
                        hidesUnderline: true,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 300,
                      constraints: BoxConstraints(
                        maxHeight: 500,
                      ),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/360_F_218218632_jF6XAkcrlBjv1mAg9Ow0UBMLBaJrhygH.jpg',
                            width: 300,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 14, 0, 16),
                  child: FFButtonWidget(
                    onPressed: () async {
                      if (formKey.currentState == null ||
                          !formKey.currentState!.validate()) {
                        return;
                      }

                      context.pop();
                    },
                    text: 'Registrar item',
                    options: FFButtonOptions(
                      width: 270,
                      height: 50,
                      color: FlutterFlowTheme.of(context).primaryColor,
                      textStyle: FlutterFlowTheme.of(context)
                          .subtitle1
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).subtitle1Family,
                            color: Colors.white,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).subtitle1Family),
                          ),
                      elevation: 3,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
