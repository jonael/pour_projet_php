class Cat {
    int id_cat;
    String name_cat;

    Cat({required this.id_cat, required this.name_cat});

    factory Cat.fromJson(Map<String, dynamic> json) {
        return Cat(
            id_cat: json['id_cat'],
            name_cat: json['name_cat'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id_cat'] = this.id_cat;
        data['name_cat'] = this.name_cat;
        return data;
    }
}