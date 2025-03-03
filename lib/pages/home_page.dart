import 'package:binote/components/my_button.dart';
import 'package:binote/components/note_tile.dart';
import 'package:binote/models/note.dart';
import 'package:binote/models/note_database.dart';
import 'package:binote/pages/settings_page.dart';
import 'package:binote/pages/edit_page.dart'; 
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearchVisible = false;
  final FocusNode _searchFocusNode = FocusNode();
  List<Note>? _searchResults;

  @override
  void initState() {
    super.initState();
    readNotes();
    _searchFocusNode.addListener(_handleSearchFocusChange);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_handleSearchFocusChange);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _handleSearchFocusChange() {
    if (!_searchFocusNode.hasFocus) {
      setState(() {
        _isSearchVisible = false;
      });
    } else {
      searchNotes("");
    }
  }

  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  Future<void> searchNotes(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = null;
      });
    } else {
      final results = await NoteDatabase.isar.notes
          .filter()
          .titleContains(query, caseSensitive: false)
          .or()
          .contentContains(query, caseSensitive: false)
          .findAll();
      setState(() {
        _searchResults = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    List<Note> currentNotes = noteDatabase.currentNotes;

    currentNotes.sort(
      (a, b) => (b.updatedAt ?? DateTime(0)).compareTo(a.updatedAt ?? DateTime(0)),
    );

    List<Note> displayNotes = _searchResults ?? currentNotes;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildFloatingActionButton(context),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          _buildSearchContainer(),
          _buildNoteList(displayNotes, noteDatabase),
        ],
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditPage()),
        ).then((_) {
          setState(() {
            _searchResults = null;
          });
        });
      },
      child: const Icon(HugeIcons.strokeRoundedAdd01),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      snap: true,
      floating: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      expandedHeight: 150.0,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 2,
        titlePadding: const EdgeInsets.only(left: 25.0, bottom: 10.0),
        title: Text(
          "bi'Note",
          style: TextStyle(
            fontFamily: "MadimiOne",
            fontSize: 34,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        background: Stack(
          children: [
            Positioned(
              bottom: 26,
              right: 16,
              child: MyButton(
                icon: Icon(HugeIcons.strokeRoundedSearch01,size: 22,),
                onPressed: () {
                  setState(() {
                    _isSearchVisible = !_isSearchVisible;
                  });
                  if (_isSearchVisible) {
                    Future.delayed(Duration(milliseconds: 300), () {
                      // ignore: use_build_context_synchronously
                      FocusScope.of(context).requestFocus(_searchFocusNode);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: MyButton(
            icon: Icon(HugeIcons.strokeRoundedSettings03),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchContainer() {
    return SliverToBoxAdapter(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _isSearchVisible ? 60.0 : 0.0,
        child: Visibility(
          visible: _isSearchVisible,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildSearchTextField(),
          ),
        ),
      ),
    );
  }

  TextField _buildSearchTextField() {
    return TextField(
      focusNode: _searchFocusNode,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 5),
        hintText: 'Search notes...',
        prefixIcon: Icon(Icons.search),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      onChanged: searchNotes,
      onSubmitted: (value) {
        setState(() {
          _searchResults = null;
        });
      },
    );
  }

  Widget _buildNoteList(List<Note> displayNotes, NoteDatabase noteDatabase) {
    if (_searchResults != null && _searchResults!.isEmpty && _isSearchVisible) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Note not found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        ),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return NoteTile(
              title: displayNotes[index].title,
              content: displayNotes[index].content,
              updatedAt: displayNotes[index].updatedAt.toString(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPage(note: displayNotes[index]),
                  ),
                ).then((_) {
                  setState(() {
                    _searchResults = null;
                  });
                });
              },
              id: displayNotes[index].id,
              onSlidableTap: () {
                noteDatabase.deleteNote(displayNotes[index].id);
              },
            );
          },
          childCount: displayNotes.length,
        ),
      );
    }
  }
}
