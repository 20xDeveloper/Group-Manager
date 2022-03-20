// You can pass any object to the arguments parameter.
// In this example, create a class that contains a customizable
// title and message.
class ScreenArguments {
  final String title;
  final String description;
  final String createdAt;
  final String webURL;
  List<dynamic> datas;



  // final String message;

  // data is the list of data you got back from the server. i named it data because this screenArguments widget is for all screens not just a specific one. So, I gave it a general name. 
  ScreenArguments(this.title, this.description, this.createdAt, this.webURL, this.datas);
}