class ComponenteExterno {
  int id;
  String idEquipoComputo;
  String idComponente;
  
  
  ComponenteExterno({
    this.id = 0,
    this.idEquipoComputo = '',
    this.idComponente = '',
  });
  
  factory ComponenteExterno.fromMap(Map<String, dynamic> map) {
    return ComponenteExterno(
      id: map['ID'] ?? 0,
      idEquipoComputo: map['ID_EQUIPO_COMPUTO'] ?? '',
      idComponente: map['ID_COMPONENTE'] ?? '',
    );
  }
}
