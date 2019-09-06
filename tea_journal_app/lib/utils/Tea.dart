import 'package:jaguar_orm/jaguar_orm.dart';


class Tea {

  @Column(isNullable: false)
  String title;
  @Column(isNullable: false)
  String description;


  Tea({this.title, this.description });


  static const String titleName = "title";
  static const String descriptionName = "description";

  Map<String, dynamic> toJson() => {
    title : this.title,
    description : this.description
  };

}