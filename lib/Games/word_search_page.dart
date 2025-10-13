import 'package:wordgame/library.dart';

/// ---------------- WordSearchModel ----------------
class WordSearchModel {
  final Map<int, List<String>> levels = {
    1: ["CAT", "DOG", "BIRD", "FISH"],
    2: ["APPLE", "PEAR", "PLUM", "MANGO", "GRAPE"],
    3: ["RED", "BLUE", "GREEN", "YELLOW", "PINK"],
    4: ["CAR", "BUS", "TRAIN", "PLANE", "BIKE"],
    5: ["JAVA", "DART", "FLUTTER", "KOTLIN", "PYTHON"],
    6: ["EARTH", "MARS", "VENUS", "JUPITER", "PLUTO"],
    7: ["BOOK", "PEN", "PAPER", "BAG", "CHAIR"],
    8: ["MUSIC", "DANCE", "PAINT", "MOVIE", "DRAMA"],
    9: ["TASHKENT", "LONDON", "PARIS", "TOKYO", "BERLIN"],
    10: ["UZBEKISTAN", "KAZAKHSTAN", "KYRGYZSTAN", "TAJIKISTAN", "TURKMENISTAN"],
  };

  List<String> getWords(int level) => levels[level] ?? [];
}

/// ---------------- WordSearchPage ----------------
class WordSearchPage extends StatefulWidget {
  const WordSearchPage({super.key});
  @override
  State<WordSearchPage> createState() => _WordSearchPageState();
}

class _WordSearchPageState extends State<WordSearchPage> {
  final WordSearchModel model = WordSearchModel();
  final int gridSize = 12;

  int currentLevel = 1;
  late List<String> targetWords;
  late List<List<String>> grid;
  late Set<_Cell> fixedSelected;
  late List<_Cell> dragPreview;
  late Set<String> foundWords;
  late List<_Placement> placements;

  _Cell? dragStart;
  _Dir? lockedDir;

  @override
  void initState() {
    super.initState();
    _startLevel(1);
  }

  void _startLevel(int level) {
    targetWords = model.getWords(level).map((w) => w.toUpperCase()).toList();
    _generateGrid();
  }

  void _generateGrid() {
    final rand = Random();
    grid = List.generate(
      gridSize,
      (_) => List.filled(gridSize, ''),
    );

    placements = [];
    for (final w in targetWords) {
      bool placed = false;
      for (int tries = 0; tries < 400 && !placed; tries++) {
        final dir = _Dir.random(rand);
        final startRow = rand.nextInt(gridSize);
        final startCol = rand.nextInt(gridSize);

        if (_canPlace(w, startRow, startCol, dir)) {
          _placeWord(w, startRow, startCol, dir);
          placements.add(_Placement(w, startRow, startCol, dir));
          placed = true;
        }
      }
      if (!placed) {
        _generateGrid();
        return;
      }
    }

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        grid[r][c] = grid[r][c].isEmpty
            ? String.fromCharCode(65 + rand.nextInt(26))
            : grid[r][c];
      }
    }

    fixedSelected = {};
    dragPreview = [];
    foundWords = {};
    dragStart = null;
    lockedDir = null;
    setState(() {});
  }

  bool _canPlace(String word, int r, int c, _Dir dir) {
    final dr = dir.dr, dc = dir.dc;
    final endR = r + dr * (word.length - 1);
    final endC = c + dc * (word.length - 1);
    if (endR < 0 || endR >= gridSize || endC < 0 || endC >= gridSize) {
      return false;
    }
    for (int i = 0; i < word.length; i++) {
      final rr = r + dr * i;
      final cc = c + dc * i;
      final ch = grid[rr][cc];
      if (ch.isNotEmpty && ch != word[i]) return false;
    }
    return true;
  }

  void _placeWord(String word, int r, int c, _Dir dir) {
    final dr = dir.dr, dc = dir.dc;
    for (int i = 0; i < word.length; i++) {
      final rr = r + dr * i;
      final cc = c + dc * i;
      grid[rr][cc] = word[i];
    }
  }

  _Cell? _hitTestCell(Offset localPos, double cellSize) {
    final row = (localPos.dy ~/ cellSize);
    final col = (localPos.dx ~/ cellSize);
    if (row < 0 || row >= gridSize || col < 0 || col >= gridSize) return null;
    return _Cell(row, col);
  }

  List<_Cell> _lineCells(_Cell a, _Cell b) {
    final dr = (b.row - a.row);
    final dc = (b.col - a.col);
    final steps = max(dr.abs(), dc.abs());
    if (steps == 0) return [a];

    int stepR = dr == 0 ? 0 : dr ~/ dr.abs();
    int stepC = dc == 0 ? 0 : dc ~/ dc.abs();

    if (!((stepR == 0) ^ (stepC == 0))) {
      return [a];
    }

    final out = <_Cell>[];
    for (int i = 0; i <= steps; i++) {
      final r = a.row + stepR * i;
      final c = a.col + stepC * i;
      if (r < 0 || r >= gridSize || c < 0 || c >= gridSize) break;
      out.add(_Cell(r, c));
    }
    return out;
  }

  String _cellsToString(List<_Cell> cells) {
    final sb = StringBuffer();
    for (final cell in cells) {
      sb.write(grid[cell.row][cell.col]);
    }
    return sb.toString();
  }

  void _onPanStart(Offset localPos, double cellSize) {
    final start = _hitTestCell(localPos, cellSize);
    if (start == null) return;
    setState(() {
      dragStart = start;
      dragPreview = [start];
      lockedDir = null;
    });
  }

  void _onPanUpdate(Offset localPos, double cellSize) {
    if (dragStart == null) return;
    final current = _hitTestCell(localPos, cellSize);
    if (current == null) return;

    lockedDir ??= _Dir.fromDelta(
      current.row - dragStart!.row,
      current.col - dragStart!.col,
    );

    if (lockedDir == null) {
      setState(() => dragPreview = [dragStart!]);
      return;
    }

    final snappedEnd = _snapToLine(dragStart!, current);
    final line = _lineCells(dragStart!, snappedEnd);

    setState(() {
      dragPreview = line;
    });
  }

  _Cell _snapToLine(_Cell a, _Cell b) {
    final dr = b.row - a.row;
    final dc = b.col - a.col;
    if (dr == 0 && dc == 0) return a;

    int stepR = dr == 0 ? 0 : dr ~/ dr.abs();
    int stepC = dc == 0 ? 0 : dc ~/ dc.abs();

    if (!((stepR == 0) ^ (stepC == 0))) {
      return a;
    }

    int r = a.row, c = a.col;
    while (true) {
      final nr = r + stepR;
      final nc = c + stepC;
      if (nr < 0 || nr >= gridSize || nc < 0 || nc >= gridSize) break;
      r = nr;
      c = nc;
      if (nr == b.row && nc == b.col) break;
    }
    return _Cell(r, c);
  }

  Future<void> _onPanEnd() async {
    if (dragPreview.isEmpty) {
      setState(() {
        dragStart = null;
        lockedDir = null;
      });
      return;
    }

    final picked = _cellsToString(dragPreview);
    final pickedRev = picked.split('').reversed.join();

    String? matched;
    for (final p in placements) {
      if (foundWords.contains(p.word)) continue;
      final cells = p.cells();
      final s = _cellsToString(cells);
      final sRev = s.split('').reversed.join();
      if (picked == s || picked == sRev || pickedRev == s || pickedRev == sRev) {
        matched = p.word;
        setState(() {
          fixedSelected.addAll(cells);
          foundWords.add(p.word);
        });
        break;
      }
    }

    setState(() {
      dragPreview = [];
      dragStart = null;
      lockedDir = null;
    });

    if (matched != null && foundWords.length == targetWords.length) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;

      if (currentLevel < 10) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Zo‘r! 🎉'),
            content: Text('Level $currentLevel tugadi. Keyingi levelga o‘tasizmi?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    currentLevel++;
                    _startLevel(currentLevel);
                  });
                },
                child: const Text('Ha'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Yo‘q'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Tabriklaymiz! 🏆'),
            content: const Text('Siz barcha 10 levelni tugatdingiz!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    currentLevel = 1;
                    _startLevel(currentLevel);
                  });
                },
                child: const Text('Yangi o‘yin'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final foundCount = foundWords.length;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('WordSearch - Level $currentLevel'),
        actions: [
          IconButton(
            tooltip: 'Restart level',
            onPressed: () => _startLevel(currentLevel),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: targetWords.map((w) {
                      final isFound = foundWords.contains(w);
                      return Chip(
                        label: Text(
                          w,
                          style: TextStyle(
                            decoration: isFound ? TextDecoration.lineThrough : null,
                            color: isFound ? Colors.green.shade800 : null,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        side: BorderSide(
                          color: isFound ? Colors.green : Colors.grey.shade400,
                        ),
                        avatar: Icon(
                          isFound ? Icons.check_circle : Icons.search,
                          color: isFound ? Colors.green : Colors.grey.shade600,
                          size: 18,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                Text('$foundCount / ${targetWords.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cellSize = constraints.maxWidth / gridSize;
                    return Listener(
                      onPointerDown: (e) {
                        final box = context.findRenderObject() as RenderBox;
                        final local = box.globalToLocal(e.position);
                        _onPanStart(local, cellSize);
                      },
                      onPointerMove: (e) {
                        final box = context.findRenderObject() as RenderBox;
                        final local = box.globalToLocal(e.position);
                        _onPanUpdate(local, cellSize);
                      },
                      onPointerUp: (_) => _onPanEnd(),
                      onPointerCancel: (_) => _onPanEnd(),
                      child: CustomPaint(
                        painter: _GridPainter(
                          grid: grid,
                          gridSize: gridSize,
                          fixedSelected: fixedSelected,
                          dragPreview: dragPreview,
                        ),
                        child: Container(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

/// -------- Helper Classes --------

class _Cell {
  final int row;
  final int col;
  const _Cell(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Cell && row == other.row && col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}

class _Dir {
  final int dr;
  final int dc;
  const _Dir(this.dr, this.dc);

  static const List<_Dir> all = [
    _Dir(-1, 0), // ↑
    _Dir(1, 0),  // ↓
    _Dir(0, 1),  // →
    _Dir(0, -1), // ←
  ];

  static _Dir random(Random r) => all[r.nextInt(all.length)];

  static _Dir? fromDelta(int dr, int dc) {
    if (dr == 0 && dc == 0) return null;
    if (!(dr == 0 || dc == 0)) return null;
    int sdr = dr == 0 ? 0 : dr ~/ dr.abs();
    int sdc = dc == 0 ? 0 : dc ~/ dc.abs();
    return _Dir(sdr, sdc);
  }
}

class _Placement {
  final String word;
  final int r0, c0;
  final _Dir dir;
  _Placement(this.word, this.r0, this.c0, this.dir);

  List<_Cell> cells() {
    final out = <_Cell>[];
    for (int i = 0; i < word.length; i++) {
      out.add(_Cell(r0 + dir.dr * i, c0 + dir.dc * i));
    }
    return out;
  }
}

class _GridPainter extends CustomPainter {
  final List<List<String>> grid;
  final int gridSize;
  final Set<_Cell> fixedSelected;
  final List<_Cell> dragPreview;

  _GridPainter({
    required this.grid,
    required this.gridSize,
    required this.fixedSelected,
    required this.dragPreview,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellW = size.width / gridSize;
    final cellH = size.height / gridSize;

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0x33000000);

    final fixedPaint = Paint()..color = Colors.green.withOpacity(0.35);
    final previewPaint = Paint()..color = Colors.amber.withOpacity(0.35);

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        final rect = Rect.fromLTWH(c * cellW, r * cellH, cellW, cellH);
        final cell = _Cell(r, c);
        if (fixedSelected.contains(cell)) {
          canvas.drawRect(rect, fixedPaint);
        } else if (dragPreview.contains(cell)) {
          canvas.drawRect(rect, previewPaint);
        }
      }
    }

    for (int i = 0; i <= gridSize; i++) {
      final y = i * cellH;
      final x = i * cellW;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), borderPaint);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), borderPaint);
    }

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        final ch = grid[r][c];
        final style = const TextStyle(
          fontSize: 14,
          color: Colors.black,
        );
        textPainter.text = TextSpan(text: ch, style: style);
        textPainter.layout();
        final offset = Offset(
          c * cellW + (cellW - textPainter.width) / 2,
          r * cellH + (cellH - textPainter.height) / 2,
        );
        textPainter.paint(canvas, offset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) {
    return old.grid != grid ||
        old.fixedSelected != fixedSelected ||
        old.dragPreview != dragPreview;
  }
}