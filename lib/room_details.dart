import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _RoomDetails extends StatefulWidget {
  const _RoomDetails({super.key});

  @override
  State<_RoomDetails> createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<_RoomDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Details'),
      ),
    );
  }
}