import 'package:flutter/material.dart';
import 'package:spider_web_control/spider_web_control.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spider Web Control Example',
      theme: _isDarkTheme == false
          ? ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            )
          : ThemeData.dark(),

      home: Scaffold(
        appBar: AppBar(
          title: Text('Spider Web Control Demo'),
          actions: [
            IconButton(
              icon: Icon(_isDarkTheme ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  _isDarkTheme = !_isDarkTheme;
                });
              },
            ),
          ],
        ),
        body: SpiderWebExample(),
      ),
    );
  }
}

class SpiderWebExample extends StatefulWidget {
  const SpiderWebExample({super.key});

  @override
  State<SpiderWebExample> createState() => _SpiderWebExampleState();
}

class _SpiderWebExampleState extends State<SpiderWebExample> {
  String _currentDirection = 'None';
  String _lastDirection = 'None';
  int _directionCount = 0;
  double _webSize = 300.0;
  Color _threadColor = Colors.blue;
  final Color _dewDropColor = Colors.lightBlue;
  bool _isTouching = false;

  final List<String> _directionHistory = [];

  void _onDirectionChanged(String direction) {
    setState(() {
      _lastDirection = _currentDirection;
      _currentDirection = direction;
      _directionCount++;
      _directionHistory.insert(0, direction);
      if (_directionHistory.length > 10) {
        _directionHistory.removeLast();
      }
    });

    // Simulate sending to device
  }

  void _onTouchStart() {
    setState(() {
      _isTouching = true;
    });
  }

  void _onTouchEnd() {
    setState(() {
      _isTouching = false;
      _currentDirection = 'None';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Status Card
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _isTouching
                            ? Icons.touch_app
                            : Icons.touch_app_outlined,
                        color: _isTouching ? Colors.green : Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Text('Touch: ${_isTouching ? "Active" : "Inactive"}'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text('Current: $_currentDirection'),
                  Text('Last: $_lastDirection'),
                  Text('Count: $_directionCount'),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Spider Web Control
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Spider Web Control',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),
                  SpiderWebControl(
                    config: SpiderWebConfig(
                      size: _webSize,
                      threadColor: _threadColor,
                      dewDropColor: _dewDropColor,
                      minorThreadColor: Colors.grey[400]!,
                    ),
                    onDirectionChanged: _onDirectionChanged,
                    onTouchStart: _onTouchStart,
                    onTouchEnd: _onTouchEnd,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Controls
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Controls',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),

                  // Size Slider
                  Text('Size: ${_webSize.round()}px'),
                  Slider(
                    value: _webSize,
                    min: 200,
                    max: 400,
                    divisions: 20,
                    onChanged: (value) {
                      setState(() {
                        _webSize = value;
                      });
                    },
                  ),

                  SizedBox(height: 16),

                  // Color Selection
                  Text('Thread Color'),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        [
                              Colors.blue,
                              Colors.red,
                              Colors.green,
                              Colors.purple,
                              Colors.orange,
                              Colors.cyan,
                            ]
                            .map(
                              (color) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _threadColor = color;
                                  });
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: _threadColor == color
                                        ? Border.all(
                                            color: Colors.white,
                                            width: 3,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Direction History
          if (_directionHistory.isNotEmpty)
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Directions',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: _directionHistory
                          .map(
                            (direction) => Chip(
                              label: Text(direction),
                              backgroundColor: _getDirectionColor(direction),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _directionHistory.clear();
                          _directionCount = 0;
                          _currentDirection = 'None';
                          _lastDirection = 'None';
                        });
                      },
                      child: Text('Clear History'),
                    ),
                  ],
                ),
              ),
            ),

          SizedBox(height: 20),

          // Direction Legend
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Direction Legend',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children: [
                      _buildDirectionTile('FL', 'Forward Left'),
                      _buildDirectionTile('F', 'Forward'),
                      _buildDirectionTile('FR', 'Forward Right'),
                      _buildDirectionTile('L', 'Left'),
                      _buildDirectionTile('Center', 'Disabled Zone'),
                      _buildDirectionTile('R', 'Right'),
                      _buildDirectionTile('BL', 'Back Left'),
                      _buildDirectionTile('B', 'Back'),
                      _buildDirectionTile('BR', 'Back Right'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionTile(String code, String description) {
    bool isActive = _currentDirection == code;
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(8),
        border: isActive ? Border.all(color: Colors.green, width: 2) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            code,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.green : null,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? Colors.green : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getDirectionColor(String direction) {
    switch (direction) {
      case 'F':
        return Colors.blue;
      case 'B':
        return Colors.red;
      case 'L':
        return Colors.green;
      case 'R':
        return Colors.orange;
      case 'FR':
        return Colors.purple;
      case 'FL':
        return Colors.cyan;
      case 'BR':
        return Colors.pink;
      case 'BL':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}
