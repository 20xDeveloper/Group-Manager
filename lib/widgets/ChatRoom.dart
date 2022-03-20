import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';

import './Main_Drawer.dart';
import './UserMessageContainer.dart';
import './../utils/GlobalVariables.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io/socket_io.dart';

class ChatRoom extends StatefulWidget {
  static const routeName = "/contacts/messages";

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  FocusNode focusNode = FocusNode();
  final messageController = TextEditingController();
  List<String> messages = [];
  String hintText = "Enter your message here.";
  // double textFieldContainerMargin = 324;
  List<dynamic> chat_previous_messages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        hintText = '';
      } else {
        hintText = "Enter your message here.";
      }
      setState(() {});
    });
  }

  final appBar = AppBar(
    title: Text("Messages"),
  );

//   get_chat_messages(route_args) async {
//     final url = GlobalVariables.apiURL + "/chat/chat-channels/previous-messages";
// print("here is the value for the rotue_args variable dgsd " + GlobalVariables.users['id'].toString());
// //print route args is where i left off
//         final response = await http.post(url, body: json.encode({
//               'user_1_ID': GlobalVariables.users["id"],
//               'user_2_ID': route_args.toString()
//             }), headers: {
//                 "accept": "application/json",
//                 "content-type": "application/json"
//               });

//         var chat_messages = await json.decode(response.body);

//       print("here is the value for the chat_messages " + chat_messages.toString());

//         // await setState(() {
//         //   chat_previous_messages = chat_messages['all_users_on_this_app']; // this is where i left off in the front end. I need to refactor the backend to get the list of previous messages for the chat room.
//         // });
//   }

//   sendMessage() {
//     // THIS IS WHERE I LEFT OFF
//     messages.add(messageController.text);
//     print("Here is the value for messages " + messages.toString());
//     // setState(){
//     //   messages =updatedListOfMessages;
//     // }
//   }

  get_chat_messages(route_args) async {

    print("here is the value for the first user id " + GlobalVariables.users['id'].toString());
    print("here is the value for the second user id " + route_args.toString());


    List<String> past_messages = [];

    List<int> both_users_ID = [GlobalVariables.users['id'], route_args];

    // print("here is the value for the global variables users property " + route_args.toString());

    // Dart client
    IO.Socket socket = await IO.io(GlobalVariables.apiURL.toString(), <String, dynamic>{
   'transports': ['websocket'],
   'autoConnect': false,
});

    // socket.on('connect', (_){
    //   print("connecting...");
    // });
    socket.connect();

    socket.on('was connection successful', (connection_status) {

    // THIS IS WHERE I LEFT OFF
    socket.emit('user started messaging', both_users_ID);
      
    });

    // -- THIS IS WEHERE I LEFT OFF. CHECK HOW IT KNOWS WHICH MESSAGE TO GET FOR THIS CHAT ROOM --
    // -- ALSO REMEMBER TO SET THE STATE FOR THE PAST MESSAGES. I JUST UPDATED THE LOCAL VARIABLE IN THIS FUNCTION TO HAVE THE PAST MESSAGES THAT WAS RECIEVED FROM OUR EXPRESS SERVER --
    socket.on('recieve past messages for this conversation',
        (past_user_messages) => {past_messages = past_user_messages});

    socket.on('recieve user message',
        (user_message) => {past_messages.add(user_message)});


    // Note: Ask the flutter community why we use setState when we can just manually store the variable with the equal sign.
    chat_previous_messages = past_messages;

    print("here is the value for the previous messages " + chat_previous_messages.toString());
    // -- I just have to test it that is WHERE I LEFT OFF -- 














    // socket.on('disconnect', (_) => print('disconnect'));
    // socket.on('fromServer', (_) => print(_));
    // this.socket = SocketIOClient(this.props.API_URL);

    //     this.socket.on('was connection successful', (connection_status) => {
    //         // if(connection_status === true){
    //         //     this.setState({are_you_online: true})
    //         // }

    //         this.socket.emit('new user joined the room', this.props.user_data.name, navigation.getParam('channel_name', 'channel_name was not passed as a navigation parameter'))
    //     });

    //     await this.socket.on("recieve list of online users", async (online_users) => {
    //         console.log("here is the list of online user we got from the express server ", online_users)
    //        await this.props.save_list_of_online_users({online_users}) // Destructuring ES2015 syntax
    //        const { navigation } = this.props; // ES2015 destructuring syntax

    //     let navigation_for_left_drawer = navigation.getParam("left_drawer_for_navigation", "left drawer navigation was not passed as param")
    //       let header = <Header
    //        leftComponent={<BackArrow navigation={this.props.navigation} navigate_back_to="Chat Menu"/>}
    //        centerComponent={{ text: "#" + navigation.getParam("channel_name", "channel_name was not passed as a navigation parameter"), style: { color: '#fff' } }}
    //        rightComponent={<Who_is_online_icon navigation={this.props.navigation}/>}
    //        containerStyle={{
    //        backgroundColor: '#a52a2a',
    //        border: "none",
    //        }}
    //    />
    //    this.setState({header})
    //     })

    //     this.socket.on("recieve past messages for this channel", (past_messages_for_this_channel) => {
    //         this.setState({past_messages_for_this_channel, loading_dialog: null}) // ES6 Object Destructuring syntax
    //         setTimeout(this.scrollToEnd, 3000)

    //     })

    //     // this can be your message that you sent or someones elses. Just letting you know so you have a better understanding of how everything works.
    //     this.socket.on("recieve user message",  (user_message) => {
    //         let past_messages_for_this_channel = [...this.state.past_messages_for_this_channel] // this makes it immutable. Never knew what the point was this but it's a good practice
    //         past_messages_for_this_channel.push(user_message)
    //          this.setState({past_messages_for_this_channel}) // ES6 Object Destructuring syntax
    //          setTimeout(this.scrollToEnd, 0)

    //     })
  }

  sendMessage() {
    //     this.socket.emit("broadcast user message", this.state.user_input_message, this.props.user_data.name, this.props.navigation.getParam('channel_name', 'channel_name was not passed as a navigation parameter'), this.state.image)
    //     this.setState({user_input_message: ""})
  }

  // send_message = async () => {
  //     this.socket.emit("broadcast user message", this.state.user_input_message, this.props.user_data.name, this.props.navigation.getParam('channel_name', 'channel_name was not passed as a navigation parameter'), this.state.image)
  //     this.setState({user_input_message: ""})
  // }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    get_chat_messages(args);
    // print("here is the value for appBar.preferredSize.height " + MediaQuery.of(context).);
    final contentHeight = (MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top);
    return Scaffold(
        // bottomSheet: TextField(
        //     controller: messageController,
        //     style: TextStyle(fontSize: 12),

        //     // textAlignVertical: TextAlignVertical(y: 0),
        //     focusNode: focusNode,
        //     decoration: InputDecoration(
        //       suffixIcon: GestureDetector(
        //           child: Icon(
        //             Icons.send,
        //             size: 12,
        //           ),
        //           onTap: sendMessage),

        //       contentPadding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
        //       alignLabelWithHint: true,
        //       hintText: hintText,
        //       // labelText: "Enter your message here.",
        //       border: new OutlineInputBorder(
        //         borderRadius: const BorderRadius.all(
        //           const Radius.circular(10.0),
        //         ),
        //       ),
        //     )),
        appBar: appBar,
        drawer: MainDrawer(),
        // body: ListView.builder(
        //   itemBuilder: (ctx, index) {

        //     return InfoCard(
        //         appBar.preferredSize.height,
        //         newsisInfoCardState[index]['title'],
        //         newsisInfoCardState[index]['createdAt'],
        //         newsisInfoCardState[index]['description'],
        //         // firebaseImageURLState,
        //          newsisInfoCardState[index]['firebaseImageUrl'],

        //         newsisInfoCardState[index]['newsURL']
        //         );
        //   },
        //   itemCount: newsisInfoCardState.length,
        // ),
        body: Container(
          child: Column(
            children: <Widget>[
              UserMessageContainer(
                  contentHeight, "test", "test", 'test', "testing"),

              // -- The text input field at the bottom for sending messages --
              // THIS IS WHERE I LEFT OFF. I NEED TO STICK THE INPUT FIELD DYNAMICALLY TO THE BOTTOM OF THE SCREEN. CAN'T USE BOTTOMSHEET BECAUSE IT WILL CREATE BUG WHERE IT CLOSES THE TEXT FIELD WHEN EVER YOU FOCUS ON IT.
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: TextField(
                      controller: messageController,
                      style: TextStyle(fontSize: 12),

                      // textAlignVertical: TextAlignVertical(y: 0),
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            child: Icon(
                              Icons.send,
                              size: 12,
                            ),
                            onTap: sendMessage),

                        contentPadding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                        alignLabelWithHint: true,
                        hintText: hintText,
                        // labelText: "Enter your message here.",
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                      )),
                ),
              ),
              // TextField(
              // controller: messageController,
              // style: TextStyle(fontSize: 12),

              // // textAlignVertical: TextAlignVertical(y: 0),
              // focusNode: focusNode,
              // decoration: InputDecoration(
              //   suffixIcon: GestureDetector(
              //       child: Icon(
              //         Icons.send,
              //         size: 12,
              //       ),
              //       onTap: sendMessage),

              //   contentPadding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              //   alignLabelWithHint: true,
              //   hintText: hintText,
              //   // labelText: "Enter your message here.",
              //   border: new OutlineInputBorder(
              //     borderRadius: const BorderRadius.all(
              //       const Radius.circular(10.0),
              //     ),
              //   ),
              // )),
              // -- Ends here. --
            ],
          ),
        ));
  }
}
