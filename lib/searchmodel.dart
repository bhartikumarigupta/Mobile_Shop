// class searchmodel {
//   List<Null> makes;
//   List<Null> models;
//   String message;

//   searchmodel({this.makes, this.models, this.message});

//   searchmodel.fromJson(Map<String, dynamic> json) {
//     if (json['makes'] != null) {
//       makes = new List<Null>();
//       json['makes'].forEach((v) {
//         makes.add(new Null.fromJson(v));
//       });
//     }
//     if (json['models'] != null) {
//       models = new List<Null>();
//       json['models'].forEach((v) {
//         models.add(new Null.fromJson(v));
//       });
//     }
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.makes != null) {
//       data['makes'] = this.makes.map((v) => v.toJson()).toList();
//     }
//     if (this.models != null) {
//       data['models'] = this.models.map((v) => v.toJson()).toList();
//     }
//     data['message'] = this.message;
//     return data;
//   }
// }
