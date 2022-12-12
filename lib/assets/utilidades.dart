class Utilidades {
  String mayusculaPrimeraLetra(String value) {
    value = value.trim().toLowerCase();
    var result = value[0].toUpperCase();
    bool cap = true;
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " " && cap == true) {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
        cap = false;
      }
    }
    return result;
  }

  String mayusculaTodasPrimerasLetras(String value) {
    value = value.trim().toLowerCase();
    var result = value[0].toUpperCase();
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " ") {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  String mayusculaPrimeraLetraFrase(String value) {
    value = value.trim().toLowerCase();
    var result = value[0].toUpperCase();
    bool caps = false;
    bool start = true;

    for (int i = 1; i < value.length; i++) {
      if (start == true) {
        if (value[i - 1] == " " && value[i] != " ") {
          result = result + value[i].toUpperCase();
          start = false;
        } else {
          result = result + value[i];
        }
      } else {
        if (value[i - 1] == " " && caps == true) {
          result = result + value[i].toUpperCase();
          caps = false;
        } else {
          if (caps && value[i] != " ") {
            result = result + value[i].toUpperCase();
            caps = false;
          } else {
            result = result + value[i];
          }
        }

        if (value[i] == ".") {
          caps = true;
        }
      }
    }
    return result;
  }
}
