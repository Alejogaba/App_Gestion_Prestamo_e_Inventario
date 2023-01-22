class Hardware {
  String id;
  String idEquipoComputo;
  String idFuncionario;
  String componente;
  String marca;
  String modelo;
  String serial;
  String numInventario;
  String detalles;
  String componentesTorre;
  String marcaComponentesTorre;
  String velocidadComponentesTorre;
  String otrasCaracteristicas;
  
  Hardware({
    this.id = '',
    this.idEquipoComputo = '',
    this.idFuncionario = '',
    this.componente = '',
    this.marca = '',
    this.modelo = '',
    this.serial = '',
    this.numInventario = '',
    this.detalles = '',
    this.componentesTorre = '',
    this.marcaComponentesTorre = '',
    this.velocidadComponentesTorre = '',
    this.otrasCaracteristicas = '',
  });
  
  factory Hardware.fromMap(Map<String, dynamic> map) {
    return Hardware(
      id: map['ID'] ?? '',
      idEquipoComputo: map['ID_EQUIPO_COMPUTO'] ?? '',
      idFuncionario: map['ID_FUNCIONARIO'] ?? '',
      componente: map['COMPONENTE'] ?? '',
      marca: map['MARCA'] ?? '',
      modelo: map['MODELO'] ?? '',
      serial: map['SERIAL'] ?? '',
      numInventario: map['NUM_INVENTARIO'] ?? '',
      detalles: map['DETALLES'] ?? '',
      componentesTorre: map['COMPONENTES_TORRE'] ?? '',
      marcaComponentesTorre: map['MARCA_COMPONENTES_TORRE'] ?? '',
      velocidadComponentesTorre: map['VELOCIDAD_COMPONENTES_TORRE'] ?? '',
      otrasCaracteristicas: map['OTRAS_CARACTERISTICAS'] ?? ''
    );
  }
}
