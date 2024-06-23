import 'package:flutter/material.dart';
import 'package:gemini_chatbot/model/model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class GeminiChatBot extends StatefulWidget {
  const GeminiChatBot({super.key});

  @override
  State<GeminiChatBot> createState() => _GeminiChatBotState();
}

class _GeminiChatBotState extends State<GeminiChatBot> {
  TextEditingController promptController = TextEditingController();
  static const apiKey = "AIzaSyACrBPA6G4VsNNfl6xKOZNtoD801Tp5s4w";
  final model = GenerativeModel(model: "gemini-pro", apiKey: apiKey);
  final List<ModelMessage> prompt = [];

  Future<void> sendMessage() async {
    final message = promptController.text;
    setState(() {
      promptController.clear();
      prompt.add(
          ModelMessage(isPrompt: true, message: message, time: DateTime.now()));
    });
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    setState(() {
      prompt.add(ModelMessage(
          isPrompt: false, message: response.text ?? "", time: DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        title: const Text("AI ChatBot"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: prompt.length,
                  itemBuilder: (context, index) {
                    final message = prompt[index];
                    return userPrompt(
                        isPrompt: message.isPrompt,
                        message: message.message,
                        date: DateFormat('hh:mm a').format(message.time));
                  })),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                    flex: 20,
                    child: TextField(
                      controller: promptController,
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25)),
                          hintText: "Enter a prompt here"),
                    )),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: const CircleAvatar(
                    radius: 29,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container userPrompt(
      {required final bool isPrompt,
      required String message,
      required String date}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 15)
          .copyWith(left: isPrompt ? 80 : 15, right: isPrompt ? 15 : 80),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: isPrompt ? Colors.blue[800] : Colors.grey,
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: isPrompt ? const Radius.circular(20) : Radius.zero,
              bottomRight: isPrompt ? Radius.zero : const Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
                fontWeight: isPrompt ? FontWeight.bold : FontWeight.normal,
                fontSize: 18,
                color: isPrompt ? Colors.white : Colors.black),
          ),
          Text(
            date,
            style: TextStyle(
                fontSize: 14, color: isPrompt ? Colors.white : Colors.black),
          )
        ],
      ),
    );
  }
}
