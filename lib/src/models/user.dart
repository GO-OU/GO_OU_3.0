// User Data Model
class User {
  final int id;
  final String email;
  final String password; //TODO: We need to hide this somehow

  User(this.id, this.email, this.password);
}