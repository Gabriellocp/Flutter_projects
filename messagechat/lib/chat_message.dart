import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(this.data, this.mine);
  final bool mine;
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        children: [
          !mine
              ? Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(data["senderPhotoUrl"]),
                  ),
                )
              : Container(),
          Expanded(
            child: data['img'] != null
                ? Image.network(
                    data['img'],
                    width: 250.0,
                  )
                : Text(
                    data['msg'],
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    textAlign: mine ? TextAlign.right : TextAlign.left,
                  ),
          ),
          mine
              ? Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(data["senderPhotoUrl"]),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
