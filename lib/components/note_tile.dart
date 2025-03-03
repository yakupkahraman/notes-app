import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:binote/models/note.dart';
import 'package:binote/models/note_database.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class NoteTile extends StatefulWidget {
  final int id;
  final String title;
  final String content;
  final VoidCallback onTap;
  final VoidCallback onSlidableTap;
  final String updatedAt;

  const NoteTile({
    super.key,
    required this.title,
    required this.content,
    required this.onTap,
    required this.id,
    required this.onSlidableTap,
    required this.updatedAt,
  });

  @override
  State<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  bool _isPressed = false;
  Color _backgroundColor = Colors.grey;
  bool _hasVibrated = false;

  @override
  Widget build(BuildContext context) {
    DateTime updatedAtDate = DateTime.parse(widget.updatedAt);
    String formattedDate = DateFormat('MMMd').format(updatedAtDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 25, right: 25),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Dismissible(
          key: Key(widget.id.toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => _handleDismissed(context, updatedAtDate),
          onUpdate: (details) => _handleUpdate(details),
          background: _buildDismissibleBackground(),
          child: GestureDetector(
            onTapDown: (_) => _handleTapDown(),
            onTapUp: (_) => _handleTapUp(),
            onTapCancel: () => _handleTapCancel(),
            child: AnimatedScale(
              scale: _isPressed ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 100),
              child: _buildListTile(context, formattedDate),
            ),
          ),
        ),
      ),
    );
  }

  void _handleUpdate(DismissUpdateDetails details) {
    setState(() {
      if (details.progress > 0.35) {
        _backgroundColor = Colors.red;
        if (!_hasVibrated) {
          Vibration.vibrate(duration: 100);
          _hasVibrated = true;
        }
      } else {
        _backgroundColor = Theme.of(context).colorScheme.secondary; // Change to grey
        if (_hasVibrated) {
          Vibration.vibrate(duration: 100); // Vibrate again when changing to grey
          _hasVibrated = false;
        }
      }
    });
  }

  void _handleDismissed(BuildContext context, DateTime updatedAtDate) {
    final deletedNote = Note()
      ..id = widget.id
      ..title = widget.title
      ..content = widget.content
      ..updatedAt = updatedAtDate;

    widget.onSlidableTap();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note deleted'),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.blue,
          onPressed: () {
            context.read<NoteDatabase>().addNoteWithId(
              deletedNote.id,
              deletedNote.title,
              deletedNote.content,
              deletedNote.updatedAt!,
            );
          },
        ),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  Widget _buildDismissibleBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: _backgroundColor,
      child: const Icon(
        HugeIcons.strokeRoundedDelete02,
        color: Colors.white,
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String formattedDate) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          widget.title.isNotEmpty ? widget.title : 'No Title',
          maxLines: 1,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        isThreeLine: true,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.content.isNotEmpty ? widget.content : 'No Content',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              formattedDate,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTapDown() {
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp() {
    setState(() {
      _isPressed = false;
    });
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }
}
