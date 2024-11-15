import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String boardName;  // The name of the message board
  ChatScreen({required this.boardName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to send a message to the selected board
  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _firestore.collection('messageBoards')
          .doc(widget.boardName)
          .collection('messages')
          .add({
            'username': 'John Doe',  // This should be the current user's name
            'message': _messageController.text,
            'timestamp': FieldValue.serverTimestamp(),
          });
      _messageController.clear();  // Clear the input field after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardName),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messageBoards')
                  .doc(widget.boardName)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,  // This ensures the most recent messages are at the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index];
                    final username = messageData['username'];
                    final message = messageData['message'];
                    final timestamp = messageData['timestamp']?.toDate();

                    return ListTile(
                      title: Text(username),
                      subtitle: Text(message),
                      trailing: Text(
                        timestamp != null ? '${timestamp.hour}:${timestamp.minute}' : '',
                        style: TextStyle(fontSize: 12),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          // Message input area
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
