
class User{
int id;
String username;
String password;
bool isMan;
String photo;

User({this.id, this.username, this.password, this.isMan, this.photo});

bool login(String username, String password){
  return username==this.username && password == this.password;
}


}