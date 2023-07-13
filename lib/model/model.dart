part of main_class.model;

abstract class Model<T> {
  T? id;

  Model({this.id});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Model<T> && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
