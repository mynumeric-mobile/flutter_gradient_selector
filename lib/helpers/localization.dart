enum LocalisationCode { fr, en, es, de }

///Location settings
LocalizationOptions? _localizationOptions;

/// Get currently used localization options
LocalizationOptions get localizationOptions => _localizationOptions ?? LocalizationOptions(LocalisationCode.en);

/// Set localization options (translations) to this report mode
LocalizationOptions setLocalizationOptions(LocalisationCode? code) {
  _localizationOptions = LocalizationOptions._localizationMessages[code ?? LocalisationCode.en];
  return _localizationOptions ?? LocalizationOptions(LocalisationCode.en);
}

class LocalizationOptions {
  final LocalisationCode languageCode;
  final String ok;
  final String cancel;
  final String selectColor;
  final String startingPoint;
  final String endPoint;
  final String linearGradient;
  final String radialGradient;
  final String sweepGradient;
  final String changeColor;
  final String gradient;
  final String solid;

  LocalizationOptions(this.languageCode,
      {this.ok = "Ok",
      this.solid = "Simple",
      this.gradient = "Dégradé",
      this.cancel = "Cancel",
      this.selectColor = "Select color",
      this.linearGradient = "Linear gradient",
      this.radialGradient = "Radial gradient",
      this.sweepGradient = "Sweep gradient",
      this.startingPoint = "Select starting point",
      this.changeColor = "Color added. Click on colored disc to change color.",
      this.endPoint = "Select end point"});

  static final Map<LocalisationCode, LocalizationOptions> _localizationMessages = {
    LocalisationCode.en: LocalizationOptions(LocalisationCode.en),
    LocalisationCode.fr: LocalizationOptions(LocalisationCode.fr,
        ok: "Ok",
        solid: "Simple",
        gradient: "Dégradé",
        cancel: "Annuler",
        selectColor: "Sélectionnez une couleur",
        linearGradient: "Dégradé linéaire",
        radialGradient: "Dégradé axial",
        sweepGradient: "Dégradé de balayage",
        startingPoint: "Sélectionnez le position de départ",
        changeColor: "Couleur ajoutée. Cliquez sur le disque coloré pour en changer.",
        endPoint: "Sélectionnez la position de fin"),
    LocalisationCode.es: LocalizationOptions(LocalisationCode.es,
        ok: "Ok",
        solid: "Solid",
        gradient: "Gradient",
        cancel: "Cancelar",
        selectColor: "Seleccione un color",
        linearGradient: "Gradiente lineal",
        radialGradient: "Gradiente axial",
        sweepGradient: "Barrido de degradado",
        startingPoint: "Seleccione la posición de inicio",
        changeColor: "Color añadido. Haz clic en el disco de color para cambiarlo.",
        endPoint: "Seleccionar punto final"),
    LocalisationCode.de: LocalizationOptions(LocalisationCode.de,
        ok: "Ok",
        solid: "Einfach",
        gradient: "Gradient",
        cancel: "Abbrechen",
        selectColor: "Wählen Sie eine Farbe",
        linearGradient: "Linearer Gradient",
        radialGradient: "Axialer Gradient",
        sweepGradient: "Farbverlauf-Sweep",
        startingPoint: "Startposition auswählen",
        changeColor: "Farbe hinzugefügt. Klicken Sie auf die farbige Scheibe, um sie zu ändern.",
        endPoint: "Endpunkt auswählen")
  };
}
