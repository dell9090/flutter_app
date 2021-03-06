import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

// this is a test

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return new MaterialApp(
        title: "Startup Name Generator",
        theme: new ThemeData(
          primaryColor: Colors.blue,
        ),
        home: new RandomWords(),
      );
    }
}

class RandomWords extends StatefulWidget {
    @override
    createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
    var _suggestions = <WordPair>[];
    final _biggerFont = const TextStyle(fontSize: 18.0);
    final _saved = new Set<WordPair>();

    Widget _buildSuggestions() { // build list view
        return new ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, i) {
                if (i.isOdd) {
                    return new Divider();
                }

                final index = i ~/ 2;
                if (index >= _suggestions.length) {
                    //_suggestions.clear();
                    _suggestions.addAll(generateWordPairs().take(10));

                }
                return _buildRow(_suggestions[index]);
            }
        );
    }

    Widget _buildRow(WordPair pair) {// one row of the list
      final alreadySaved = _saved.contains(pair);

      return new ListTile(
          title: new Text(
              pair.asPascalCase,
              style: _biggerFont,
          ),

          trailing: new Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null,
          ),

          onTap: (){
            setState(() {
              if (alreadySaved) {
                _saved.remove(pair);
              } else {
                _saved.add(pair);
              }
            });
          },
      );
    }

    @override
    Widget build(BuildContext context) {
      // TODO: implement build
        return new Scaffold(
            appBar: new AppBar(
              title: new Text("Startup Name Generator"),
              actions: <Widget>[
                new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
              ],
            ),
            body: _buildSuggestions(),
        );
    }

    void _pushSaved() {
      Navigator.of(context).push(
        new MaterialPageRoute<void>(
            builder: (BuildContext context){
              final Iterable<ListTile> tiles = _saved.map(
                  (WordPair pair) {
                    return new ListTile(
                      title: new Text(
                        pair.asPascalCase,
                        style: _biggerFont,
                      ),
                    );
                  }
              );

              final List<Widget> divided = ListTile
                  .divideTiles(
                    context: context,
                    tiles: tiles,
                  )
                  .toList();

              return new Scaffold(
                appBar: new AppBar(
                  title: const Text("Saved Suggestions"),
                ),
                body: new ListView(children: divided,),
              );
            },
        ),
      );
    }
}