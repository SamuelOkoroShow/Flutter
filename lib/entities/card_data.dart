class CardData {
  int id;
  var owner;
  // ignore: non_constant_identifier_names
  String html_url;
  int stargazers;
  String name;

  CardData(this.id, this.name, this.owner, this.html_url, this.stargazers);
  CardData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    owner = json['owner'];
    html_url = json['html_url'];
    stargazers = json['stargazers_count'];
  }
}
