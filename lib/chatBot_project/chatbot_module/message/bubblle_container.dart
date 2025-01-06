import 'package:chatbot_app_project/chatBot_project/chatbot_module/message/backup_bubble.dart';
import 'package:flutter/material.dart';

class BubbleMessage extends StatefulWidget {
  final String message;
  final bool isMe;
  final String groupid;
  final bool seens;
  const BubbleMessage(
      {super.key,
      required this.message,
      required this.isMe,
      required this.groupid,
      required this.seens});

  @override
  State<BubbleMessage> createState() => _BubbleMessageState();
}

class _BubbleMessageState extends State<BubbleMessage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BubbleSpecialThree(
        color: widget.isMe
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.secondaryContainer,
        tail: true,
        text: widget.message,
        textStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
        constraints: BoxConstraints.loose(Size(250, 500)),
        isSender: widget.isMe,
        delivered: true,
        seen: widget.seens);

    // Padding
    //   padding: const EdgeInsets.all(8.0),
    //   child: Container(
    //       decoration: BoxDecoration(
    //           color: isMe
    //               ? Theme.of(context).colorScheme.primaryContainer
    //               : Theme.of(context).colorScheme.primary.withOpacity(0.8),
    //           borderRadius: isMe
    //               ? BorderRadius.only(
    //                   bottomLeft: Radius.circular(rad),
    //                   bottomRight: Radius.circular(rad),
    //                   topLeft: Radius.circular(rad),
    //                   topRight: Radius.circular(0))
    //               : BorderRadius.only(
    //                   bottomLeft: Radius.circular(rad),
    //                   bottomRight: Radius.circular(rad),
    //                   topLeft: Radius.circular(0),
    //                   topRight: Radius.circular(rad))),
    //       child: Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Text(message),
    //       )),
    // );
  }
}
