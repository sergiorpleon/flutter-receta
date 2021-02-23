import 'package:flutter/material.dart';

typedef OnIngredientDeleteCallback = Function(int index);
typedef OnIngredientEditCallback = Function(int index);

class IngredientWidget extends StatefulWidget {
  final int index;
  final String ingredient;
  final OnIngredientDeleteCallback onIngredientDeleteCallback;
  final OnIngredientEditCallback onIngredientEditCallback;

  IngredientWidget(
      {@required this.index,
      @required this.ingredient,
      @required this.onIngredientDeleteCallback,
      @required this.onIngredientEditCallback});

  @override
  _IngredientWidgetState createState() => _IngredientWidgetState();
}

class _IngredientWidgetState extends State<IngredientWidget> {
  //bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (widget.index%2==0)?Colors.white:Colors.grey[200],
      child: Row(
        
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("${widget.index +1}"),
            ),
          ),
          Expanded(child: Container(child: new Text(widget.ingredient))),
          Container(
            child: new IconButton(
              icon: new Icon(Icons.edit),
              onPressed: (){
                widget.onIngredientEditCallback(widget.index);
              },
            ),
          ),
          Container(
            child: new IconButton(
              icon: new Icon(Icons.delete),
              onPressed: (){
                widget.onIngredientDeleteCallback(widget.index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
