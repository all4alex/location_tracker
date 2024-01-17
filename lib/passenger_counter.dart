import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';

class CounterWidget extends StatefulWidget {
  final int max;
  final Function(int) onUpdateCount;

  const CounterWidget(
      {super.key, required this.max, required this.onUpdateCount});

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _currentCount = 0;
  int _maxCount = 0;

  @override
  void initState() {
    _maxCount = widget.max;
    super.initState();
  }

  void _incrementCount() {
    if (_currentCount < _maxCount) {
      setState(() {
        _currentCount++;
      });
      widget.onUpdateCount(_currentCount);
    }
  }

  void _decrementCount() {
    if (_currentCount > 0) {
      setState(() {
        _currentCount--;
      });
    }
    widget.onUpdateCount(_currentCount);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      // color: Colors.purple.withOpacity(.7),
      margin: EdgeInsets.only(bottom: 100, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.people_alt,
            size: 70,
            color: Colors.purple,
          ),
          // Text('$_maxCount Max Total', style: TextStyle(fontSize: 12)),
          Text('$_currentCount / $_maxCount max',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          IconButton(
            onPressed: _incrementCount,
            icon: const CircleAvatar(
              backgroundColor: Colors.purple,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: _decrementCount,
            icon: const CircleAvatar(
              backgroundColor: Colors.purple,
              child: Icon(
                Icons.remove,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
