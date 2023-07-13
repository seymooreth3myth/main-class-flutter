part of main_class.utils;

launchEndereco(String endereco) async {
  if (Platform.isIOS) {
    String encoded = Uri.encodeQueryComponent(endereco);
    print("maps://maps.apple.com/?daddr=$encoded");
    Uri url = Uri.parse("maps://maps.apple.com/?daddr=$encoded");
    launchUrl(url);
  } else {
    Uri url = Uri.parse("geo:0,0?q=$endereco");
    launchUrl(url);
  }
}

launchTelefone(String telefone) async {
  Uri url = Uri.parse("tel:0$telefone");
  launchUrl(url);
}

launchEmail(String email) async {
  Uri url = Uri.parse("mailto:$email");
  launchUrl(url);
}

launchWhatsapp(String whatsapp) async {
  Uri url = Uri.parse("https://wa.me/$whatsapp");
  launchUrl(url);
}

launchYoutube(String id) async {
  String path = "www.youtube.com/watch?v=$id";

  if (Platform.isIOS) {
    Uri url = Uri.parse('youtube://$path');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Uri url = Uri.parse('https://$path');
      await launchUrl(url);
    }
  } else {
    Uri url = Uri.parse('https://$path');
    await launchUrl(url);
  }
}

launchSite(String site) async {
  if (site.startsWith("http")) {
    Uri url = Uri.parse(site);
    launchUrl(url);
  } else {
    Uri url = Uri.parse("http://$site");
    launchUrl(url);
  }
}

launchMail(String email) async {
  Uri url = Uri.parse(email);
  launchUrl(url);
}
