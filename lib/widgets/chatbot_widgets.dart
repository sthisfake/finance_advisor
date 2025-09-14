import 'package:flutter/material.dart';
import '../pages/chatbot_page.dart';

class BotMessage {
  final String text;
  final List<String>? options;
  final bool fromBot;
  BotMessage({required this.text, required this.options, required this.fromBot});
}

class ChatList extends StatelessWidget {
  final List<BotMessage> messages;
  ChatList({required this.messages});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, idx) {
        final m = messages[idx];
        if (m.fromBot) return BotBubble(text: m.text, options: m.options);
        return UserBubble(text: m.text);
      },
    );
  }
}

class BotBubble extends StatelessWidget {
  final String text;
  final List<String>? options;
  BotBubble({required this.text, required this.options});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical:8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(child: Icon(Icons.smart_toy_rounded), backgroundColor: Colors.transparent),
        SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF0D1A2B), borderRadius: BorderRadius.circular(12)), child: Text(text, style: TextStyle(color: Colors.white70))),
            if (options != null && options!.isNotEmpty) Wrap(spacing: 8, runSpacing: 6, children: options!.map((o) => OptionPill(label: o)).toList())
          ]),
        )
      ]),
    );
  }
}

class OptionPill extends StatelessWidget {
  final String label;
  OptionPill({required this.label});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final state = context.findAncestorStateOfType<ChatbotPageState>();
        state?.userPick(label);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal:12, vertical:8),
        decoration: BoxDecoration(color: Color(0xFF0F2236), borderRadius: BorderRadius.circular(999)),
        child: Text(label, style: TextStyle(color: Colors.white70)),
      ),
    );
  }
}

class UserBubble extends StatelessWidget {
  final String text;
  UserBubble({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical:8),
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(12)), child: Text(text, style: TextStyle(color: Colors.black))),
      ]),
    );
  }
}

class QuickReplies extends StatelessWidget {
  final void Function(String) onPick;
  final List<String> lastBotOptions;
  QuickReplies({required this.onPick, required this.lastBotOptions});
  @override
  Widget build(BuildContext context) {
    final options = lastBotOptions.isNotEmpty ? lastBotOptions : ['See summary','Add reminder','Categorize txns','Help'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: options.map((o) => Padding(padding: EdgeInsets.only(right:8), child: InkWell(onTap: ()=>onPick(o), child: Container(padding: EdgeInsets.symmetric(horizontal:14, vertical:10), decoration: BoxDecoration(color: Color(0xFF0F2236), borderRadius: BorderRadius.circular(999)), child: Text(o, style: TextStyle(color: Colors.white70)))))).toList()),
    );
  }
}
