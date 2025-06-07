class OauthConfig {
  final String clientId;
  final String redirectUri;
  final String discoveryUrl;
  final List<String> scopes;

  const OauthConfig({
    required this.clientId,
    required this.redirectUri,
    required this.discoveryUrl,
    required this.scopes,
  });
}
