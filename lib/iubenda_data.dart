class IubendaData {
  final String siteId;
  final String cookiesId;
  final bool showPreferences;

  const IubendaData(
      {required this.siteId,
      required this.cookiesId,
      this.showPreferences = false});

  Map<String, dynamic> toJson() => {
        'siteId': siteId,
        'cookiesId': cookiesId,
        'showPreferences': showPreferences,
      };
}

class IubendaResponse {
  final bool consent;
  final bool isGooglePersonalised;

  const IubendaResponse(
      {required this.consent, required this.isGooglePersonalised});
}
