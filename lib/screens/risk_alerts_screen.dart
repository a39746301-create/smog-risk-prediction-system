import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RiskAlertsScreen extends StatefulWidget {
  const RiskAlertsScreen({super.key});

  @override
  State<RiskAlertsScreen> createState() => _RiskAlertsScreenState();
}

class _RiskAlertsScreenState extends State<RiskAlertsScreen>
    with TickerProviderStateMixin {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color navy = Color(0xFF040B14);
  static const Color navy2 = Color(0xFF07111D);
  static const Color panel = Color(0xFF0A1826);
  static const Color panel2 = Color(0xFF0E2133);

  static const Color cyan = Color(0xFF20D9FF);
  static const Color purple = Color(0xFF8B5CF6);

  static const Color white = Color(0xFFF5F9FC);
  static const Color muted = Color(0xFFA7B8C8);
  static const Color muted2 = Color(0xFF6D8498);

  static const Color border = Color(0xFF18354B);
  static const Color borderSoft = Color(0xFF102A3E);

  static const Color moderate = Color(0xFFF59E0B);
  static const Color high = Color(0xFFF97316);
  static const Color critical = Color(0xFFEF4444);
  static const Color safe = Color(0xFF22C55E);

  // ============================================================
  // STATE
  // ============================================================

  List<Map<String, dynamic>> _data = [];

  String _filter = 'ALL';
  String _search = '';

  bool _loading = true;
  String? _error;

  String? _selectedCity;

  late AnimationController _pageAnimation;
  late AnimationController _pulseAnimation;
  late AnimationController _refreshAnimation;

  final MapController _mapController = MapController();

  final TextEditingController _searchController =
      TextEditingController();

  // ============================================================
  // CITY COORDINATES
  // ============================================================

  final Map<String, LatLng> _cityCoordinates = {
    'lahore': const LatLng(31.5204, 74.3587),
    'islamabad': const LatLng(33.6844, 73.0479),
    'faisalabad': const LatLng(31.4504, 73.1350),
    'multan': const LatLng(30.1575, 71.5249),
  };

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _pageAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _pulseAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _refreshAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _loadBackendData();
  }

  @override
  void dispose() {
    _pageAnimation.dispose();
    _pulseAnimation.dispose();
    _refreshAnimation.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // BACKEND DATA
  // ============================================================

  Future<void> _loadBackendData() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    _refreshAnimation.repeat();

    try {
      final raw = await rootBundle.loadString(
        'assets/data/latest_risk.json',
      );

      final decoded = jsonDecode(raw);

      if (!mounted) return;

      if (decoded is List) {
        final loaded = decoded
            .whereType<Map>()
            .map(
              (item) => Map<String, dynamic>.from(item),
            )
            .toList();

        setState(() {
          _data = loaded;
          _loading = false;
        });

        _pageAnimation
          ..reset()
          ..forward();
      } else {
        setState(() {
          _data = [];
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Unable to load latest risk data.';
        _data = [];
      });
    } finally {
      _refreshAnimation.stop();
      _refreshAnimation.reset();
    }
  }

  // ============================================================
  // DATA HELPERS
  // ============================================================

  String _city(Map<String, dynamic> item) {
    return (item['city'] ?? 'Unknown').toString().trim();
  }

  String _risk(Map<String, dynamic> item) {
    return (item['risk_level'] ?? 'UNKNOWN')
        .toString()
        .trim()
        .toUpperCase();
  }

  String _routeForCity(String city) {
    switch (city.toLowerCase().trim()) {
      case 'lahore':
      case 'islamabad':
        return 'M-2';
      case 'faisalabad':
        return 'M-3';
      case 'multan':
        return 'M-4';
      default:
        return 'Motorway';
    }
  }

  Color _riskColor(String risk) {
    switch (risk.toUpperCase()) {
      case 'CRITICAL':
        return critical;
      case 'HIGH':
        return high;
      case 'MODERATE':
        return moderate;
      case 'SAFE':
      case 'LOW':
        return safe;
      default:
        return muted;
    }
  }

  IconData _riskIcon(String risk) {
    switch (risk.toUpperCase()) {
      case 'CRITICAL':
        return Icons.dangerous_rounded;
      case 'HIGH':
        return Icons.warning_rounded;
      case 'MODERATE':
        return Icons.warning_amber_rounded;
      case 'SAFE':
      case 'LOW':
        return Icons.check_circle_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  String _value(
    Map<String, dynamic> item,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = item[key];

      if (value != null &&
          value.toString().trim().isNotEmpty &&
          value.toString() != 'null') {
        return value.toString();
      }
    }

    return '--';
  }

  bool _isActiveRisk(Map<String, dynamic> item) {
    final risk = _risk(item);
    return risk != 'SAFE' && risk != 'LOW';
  }

  List<Map<String, dynamic>> get _activeData {
    return _data.where(_isActiveRisk).toList();
  }

  int _countRisk(String risk) {
    return _data.where((item) => _risk(item) == risk).length;
  }

  int get _criticalCount => _countRisk('CRITICAL');

  int get _highCount => _countRisk('HIGH');

  int get _moderateCount => _countRisk('MODERATE');

  int get _safeCount {
    return _data.where((item) {
      final risk = _risk(item);
      return risk == 'SAFE' || risk == 'LOW';
    }).length;
  }

  int get _monitoredCities {
    final cities = <String>{};

    for (final item in _data) {
      cities.add(_city(item).toLowerCase());
    }

    return cities.length;
  }

  String _highestRiskForCity(String city) {
    final records = _data
        .where(
          (item) =>
              _city(item).toLowerCase() ==
              city.toLowerCase(),
        )
        .toList();

    if (records.isEmpty) return 'NO DATA';

    const priority = {
      'CRITICAL': 5,
      'HIGH': 4,
      'MODERATE': 3,
      'LOW': 2,
      'SAFE': 1,
    };

    records.sort(
      (a, b) => (priority[_risk(b)] ?? 0)
          .compareTo(priority[_risk(a)] ?? 0),
    );

    return _risk(records.first);
  }

  String _networkRisk() {
    if (_criticalCount > 0) return 'CRITICAL';
    if (_highCount > 0) return 'HIGH';
    if (_moderateCount > 0) return 'MODERATE';
    if (_safeCount > 0) return 'SAFE';
    return 'NO DATA';
  }

  Map<String, dynamic>? _highestRiskRecord() {
    if (_data.isEmpty) return null;

    const priority = {
      'CRITICAL': 5,
      'HIGH': 4,
      'MODERATE': 3,
      'LOW': 2,
      'SAFE': 1,
    };

    final records = [..._data];

    records.sort(
      (a, b) => (priority[_risk(b)] ?? 0)
          .compareTo(priority[_risk(a)] ?? 0),
    );

    return records.first;
  }

  List<Map<String, dynamic>> get _filteredAlerts {
    final query = _search.trim().toLowerCase();

    final result = _activeData.where((item) {
      final risk = _risk(item);

      if (_filter != 'ALL' && risk != _filter) {
        return false;
      }

      if (query.isEmpty) return true;

      final city = _city(item).toLowerCase();
      final route = _routeForCity(_city(item)).toLowerCase();

      return city.contains(query) ||
          route.contains(query);
    }).toList();

    const priority = {
      'CRITICAL': 4,
      'HIGH': 3,
      'MODERATE': 2,
      'LOW': 1,
      'SAFE': 0,
    };

    result.sort(
      (a, b) => (priority[_risk(b)] ?? 0)
          .compareTo(priority[_risk(a)] ?? 0),
    );

    return result;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth >= 1050;

            return Column(
              children: [
                _topHeader(desktop),
                Expanded(
                  child: _loading
                      ? _loadingView()
                      : _error != null
                          ? _errorView()
                          : _dashboard(desktop),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // DASHBOARD
  // ============================================================

  Widget _dashboard(bool desktop) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        desktop ? 28 : 13,
        desktop ? 18 : 13,
        desktop ? 28 : 13,
        30,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1500,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _animatedSection(
                0.00,
                _dashboardIntro(desktop),
              ),
              const SizedBox(height: 12),
              _animatedSection(
                0.08,
                _mainWorkspace(desktop),
              ),
              const SizedBox(height: 12),
              _animatedSection(
                0.18,
                _environmentStrip(),
              ),
              const SizedBox(height: 12),
              _animatedSection(
                0.28,
                _lowerAnalytics(desktop),
              ),
              const SizedBox(height: 12),
              _animatedSection(
                0.40,
                _riskEventsWorkspace(desktop),
              ),
              const SizedBox(height: 18),
              _footer(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ANIMATION
  // ============================================================

  Widget _animatedSection(
    double start,
    Widget child,
  ) {
    return AnimatedBuilder(
      animation: _pageAnimation,
      child: child,
      builder: (context, child) {
        final end = (start + .30).clamp(0.0, 1.0);

        final animation = CurvedAnimation(
          parent: _pageAnimation,
          curve: Interval(
            start,
            end,
            curve: Curves.easeOutCubic,
          ),
        );

        final value = animation.value;

        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              14 * (1 - value),
            ),
            child: child,
          ),
        );
      },
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _topHeader(bool desktop) {
    return Container(
      height: desktop ? 68 : 62,
      padding: EdgeInsets.symmetric(
        horizontal: desktop ? 26 : 12,
      ),
      decoration: BoxDecoration(
        color: navy2,
        border: Border(
          bottom: BorderSide(
            color: borderSoft,
          ),
        ),
      ),
      child: Row(
        children: [
          _iconButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 11),
          Container(
            width: desktop ? 38 : 36,
            height: desktop ? 38 : 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  cyan,
                  purple,
                ],
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.radar_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  desktop
                      ? 'SMOG RISK / PREDICTION SYSTEM'
                      : 'SMOG RISK',
                  style: const TextStyle(
                    color: white,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .5,
                  ),
                ),
                if (desktop)
                  const Text(
                    'Motorway Safety Intelligence',
                    style: TextStyle(
                      color: muted2,
                      fontSize: 8,
                    ),
                  ),
              ],
            ),
          ),
          _liveIndicator(),
          const SizedBox(width: 7),
          _refreshButton(),
        ],
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: panel,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: borderSoft,
            ),
          ),
          child: Icon(
            icon,
            color: muted,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _refreshButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _loadBackendData,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: cyan.withAlpha(8),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: cyan.withAlpha(50),
            ),
          ),
          child: AnimatedBuilder(
            animation: _refreshAnimation,
            builder: (_, child) {
              return Transform.rotate(
                angle: _refreshAnimation.value * 6.283,
                child: child,
              );
            },
            child: const Icon(
              Icons.refresh_rounded,
              color: cyan,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _liveIndicator() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: safe,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: safe.withAlpha(
                      60 +
                          (_pulseAnimation.value * 60).toInt(),
                    ),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            const Text(
              'LIVE',
              style: TextStyle(
                color: safe,
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: .8,
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // INTRO
  // ============================================================

  Widget _dashboardIntro(bool desktop) {
    final risk = _networkRisk();
    final color = _riskColor(risk);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: desktop ? 20 : 14,
        vertical: desktop ? 15 : 13,
      ),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: borderSoft,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 43,
            decoration: BoxDecoration(
              color: cyan,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: cyan.withAlpha(70),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MOTORWAY RISK MONITORING',
                  style: TextStyle(
                    color: white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Monitor current smog risk across M-2, M-3 and M-4 before your journey.',
                  maxLines: desktop ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: muted2,
                    fontSize: 9,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (desktop) ...[
            const SizedBox(width: 20),
            _introStat(
              '$_monitoredCities',
              'LOCATIONS',
              cyan,
            ),
            _verticalDivider(),
            _introStat(
              '${_activeData.length}',
              'ACTIVE',
              _activeData.isEmpty ? safe : high,
            ),
            _verticalDivider(),
            _introStatus(
              risk,
              color,
            ),
          ],
        ],
      ),
    );
  }

  Widget _introStat(
    String value,
    String label,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: muted2,
              fontSize: 7,
              fontWeight: FontWeight.w800,
              letterSpacing: .5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _introStatus(
    String risk,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(12),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: color.withAlpha(50),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _riskIcon(risk),
            color: color,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            risk,
            style: TextStyle(
              color: color,
              fontSize: 8,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 29,
      color: borderSoft,
    );
  }

  // ============================================================
  // MAIN WORKSPACE
  // FIXED: BOUNDED HEIGHT
  // ============================================================

  Widget _mainWorkspace(bool desktop) {
    final map = _mapPanel(desktop);
    final network = _networkPanel();

    if (!desktop) {
      return Column(
        children: [
          SizedBox(
            height: 360,
            child: map,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 430,
            child: network,
          ),
        ],
      );
    }

    return SizedBox(
      height: 430,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 7,
            child: map,
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: network,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MAP
  // ============================================================

  Widget _mapPanel(bool desktop) {
    return _dashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _panelHeading(
            icon: Icons.map_rounded,
            title: 'MOTORWAY MAP',
            subtitle: 'M-2 • M-3 • M-4',
            color: cyan,
            trailing: 'INTERACTIVE',
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: borderSoft,
                ),
              ),
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: const LatLng(
                        31.65,
                        72.75,
                      ),
                      initialZoom: 6.7,
                      minZoom: 5.5,
                      maxZoom: 11,
                      interactionOptions:
                          const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                      onTap: (_, __) {
                        setState(() {
                          _selectedCity = null;
                        });
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'com.example.smog_risk_prediction_system',
                      ),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: const [
                              LatLng(
                                31.5204,
                                74.3587,
                              ),
                              LatLng(
                                32.15,
                                74.00,
                              ),
                              LatLng(
                                33.6844,
                                73.0479,
                              ),
                            ],
                            strokeWidth: 5,
                            color: cyan.withAlpha(205),
                          ),
                          Polyline(
                            points: const [
                              LatLng(
                                31.5204,
                                74.3587,
                              ),
                              LatLng(
                                31.4504,
                                73.1350,
                              ),
                            ],
                            strokeWidth: 5,
                            color: purple.withAlpha(205),
                          ),
                          Polyline(
                            points: const [
                              LatLng(
                                31.4504,
                                73.1350,
                              ),
                              LatLng(
                                30.75,
                                72.30,
                              ),
                              LatLng(
                                30.1575,
                                71.5249,
                              ),
                            ],
                            strokeWidth: 5,
                            color: moderate.withAlpha(205),
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: _buildMapMarkers(),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: _mapOverlay(
                      Icons.navigation_rounded,
                      'PUNJAB MOTORWAYS',
                      'M-2 • M-3 • M-4',
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: _mapLegend(),
                  ),
                  if (_selectedCity != null)
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: _selectedMapCity(),
                    ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: navy2.withAlpha(225),
                        borderRadius:
                            BorderRadius.circular(8),
                        border: Border.all(
                          color: borderSoft,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.touch_app_rounded,
                            color: cyan,
                            size: 12,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Tap location',
                            style: TextStyle(
                              color: muted,
                              fontSize: 7,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapOverlay(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: navy2.withAlpha(235),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderSoft,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: cyan,
            size: 13,
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: white,
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: muted2,
                  fontSize: 6.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Marker> _buildMapMarkers() {
    final markers = <Marker>[];

    const cities = [
      'Lahore',
      'Islamabad',
      'Faisalabad',
      'Multan',
    ];

    for (final city in cities) {
      final coordinate =
          _cityCoordinates[city.toLowerCase()];

      if (coordinate == null) continue;

      final risk = _highestRiskForCity(city);
      final color = _riskColor(risk);
      final selected = _selectedCity == city;

      markers.add(
        Marker(
          point: coordinate,
          width: 130,
          height: 78,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedCity = city;
              });
            },
            child: Column(
              children: [
                AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 220),
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: navy2.withAlpha(240),
                    borderRadius:
                        BorderRadius.circular(7),
                    border: Border.all(
                      color: selected
                          ? Colors.white
                          : color.withAlpha(170),
                      width: selected ? 1.4 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withAlpha(
                          selected ? 90 : 35,
                        ),
                        blurRadius:
                            selected ? 16 : 8,
                      ),
                    ],
                  ),
                  child: Text(
                    '$city • $risk',
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontSize: 7,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 220),
                  width: selected ? 28 : 23,
                  height: selected ? 28 : 23,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: selected ? 2 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withAlpha(120),
                        blurRadius:
                            selected ? 16 : 9,
                      ),
                    ],
                  ),
                  child: Icon(
                    _riskIcon(risk),
                    color: Colors.white,
                    size: selected ? 14 : 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return markers;
  }

  Widget _mapLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: navy2.withAlpha(235),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderSoft,
        ),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 5,
        children: [
          _legendDot('Critical', critical),
          _legendDot('High', high),
          _legendDot('Moderate', moderate),
          _legendDot('Safe', safe),
        ],
      ),
    );
  }

  Widget _legendDot(
    String text,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: muted,
            fontSize: 6.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _selectedMapCity() {
    final city = _selectedCity!;
    final risk = _highestRiskForCity(city);
    final color = _riskColor(risk);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: navy2.withAlpha(245),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: color.withAlpha(90),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _riskIcon(risk),
            color: color,
            size: 14,
          ),
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                city,
                style: const TextStyle(
                  color: white,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                _routeForCity(city),
                style: const TextStyle(
                  color: muted2,
                  fontSize: 6.5,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          _smallBadge(risk, color),
        ],
      ),
    );
  }

  // ============================================================
  // CURRENT NETWORK
  // ============================================================

  Widget _networkPanel() {
    final risk = _networkRisk();
    final riskColor = _riskColor(risk);

    return _dashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _panelHeading(
            icon: Icons.radar_rounded,
            title: 'CURRENT NETWORK',
            subtitle: 'Risk by monitored location',
            color: riskColor,
            trailing: risk,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: riskColor.withAlpha(9),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: riskColor.withAlpha(35),
              ),
            ),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (_, __) {
                    return Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: riskColor.withAlpha(14),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: riskColor.withAlpha(
                            50 +
                                (_pulseAnimation.value *
                                        25)
                                    .toInt(),
                          ),
                        ),
                      ),
                      child: Icon(
                        _riskIcon(risk),
                        color: riskColor,
                        size: 17,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NETWORK STATUS',
                        style: TextStyle(
                          color: muted2,
                          fontSize: 6.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .6,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        risk,
                        style: TextStyle(
                          color: riskColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${_activeData.length}',
                      style: TextStyle(
                        color: riskColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: muted2,
                        fontSize: 5.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            'LOCATION STATUS',
            style: TextStyle(
              color: muted2,
              fontSize: 6.5,
              fontWeight: FontWeight.w900,
              letterSpacing: .6,
            ),
          ),
          const SizedBox(height: 3),
          _locationRiskRow('Lahore', 'M-2'),
          _locationRiskRow('Islamabad', 'M-2'),
          _locationRiskRow('Faisalabad', 'M-3'),
          _locationRiskRow('Multan', 'M-4'),
          const Spacer(),
          Container(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: borderSoft,
                ),
              ),
            ),
            child: Row(
              children: [
                _compactCount(
                  'CRITICAL',
                  _criticalCount,
                  critical,
                ),
                _compactCount(
                  'HIGH',
                  _highCount,
                  high,
                ),
                _compactCount(
                  'MODERATE',
                  _moderateCount,
                  moderate,
                ),
                _compactCount(
                  'SAFE',
                  _safeCount,
                  safe,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationRiskRow(
    String city,
    String route,
  ) {
    final risk = _highestRiskForCity(city);
    final color = _riskColor(risk);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: borderSoft,
          ),
        ),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration:
                const Duration(milliseconds: 220),
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(80),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              city,
              style: const TextStyle(
                color: white,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            route,
            style: const TextStyle(
              color: muted2,
              fontSize: 7,
            ),
          ),
          const SizedBox(width: 8),
          _smallBadge(
            risk,
            color,
          ),
        ],
      ),
    );
  }

  Widget _compactCount(
    String title,
    int value,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              color: muted2,
              fontSize: 5.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ENVIRONMENT
  // ============================================================

  Widget _environmentStrip() {
    Map<String, dynamic>? selected;

    if (_selectedCity != null) {
      final matches = _data.where(
        (item) =>
            _city(item).toLowerCase() ==
            _selectedCity!.toLowerCase(),
      );

      if (matches.isNotEmpty) {
        selected = matches.first;
      }
    }

    selected ??= _highestRiskRecord();

    final cityName =
        selected == null ? 'Network' : _city(selected);

    final items = [
      _EnvironmentItem(
        'PM2.5',
        selected == null
            ? '--'
            : _value(
                selected,
                [
                  'pm25',
                  'PM2.5',
                  'pm_25',
                ],
              ),
        'µg/m³',
        Icons.blur_on_rounded,
        purple,
      ),
      _EnvironmentItem(
        'PM10',
        selected == null
            ? '--'
            : _value(
                selected,
                [
                  'pm10',
                  'PM10',
                  'pm_10',
                ],
              ),
        'µg/m³',
        Icons.grain_rounded,
        high,
      ),
      _EnvironmentItem(
        'TEMP',
        selected == null
            ? '--'
            : _value(
                selected,
                [
                  'temperature',
                  'temp',
                ],
              ),
        '°C',
        Icons.thermostat_rounded,
        high,
      ),
      _EnvironmentItem(
        'HUMIDITY',
        selected == null
            ? '--'
            : _value(
                selected,
                ['humidity'],
              ),
        '%',
        Icons.water_drop_rounded,
        cyan,
      ),
      _EnvironmentItem(
        'WIND',
        selected == null
            ? '--'
            : _value(
                selected,
                [
                  'wind',
                  'wind_speed',
                ],
              ),
        '',
        Icons.air_rounded,
        safe,
      ),
      _EnvironmentItem(
        'VISIBILITY',
        selected == null
            ? '--'
            : _value(
                selected,
                [
                  'visibility_km',
                  'visibility',
                ],
              ),
        'km',
        Icons.visibility_rounded,
        cyan,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderSoft,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.cloud_rounded,
                color: cyan,
                size: 15,
              ),
              const SizedBox(width: 7),
              const Text(
                'ENVIRONMENT',
                style: TextStyle(
                  color: white,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .5,
                ),
              ),
              const SizedBox(width: 7),
              Container(
                width: 3,
                height: 3,
                decoration: const BoxDecoration(
                  color: muted2,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Available conditions • $cityName',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: muted2,
                    fontSize: 7,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact =
                  constraints.maxWidth < 700;

              if (compact) {
                return Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: items
                      .map(
                        (item) => SizedBox(
                          width:
                              (constraints.maxWidth -
                                      7) /
                                  2,
                          child:
                              _environmentMetric(item),
                        ),
                      )
                      .toList(),
                );
              }

              return Row(
                children: [
                  for (int i = 0;
                      i < items.length;
                      i++) ...[
                    Expanded(
                      child:
                          _environmentMetric(
                        items[i],
                      ),
                    ),
                    if (i != items.length - 1)
                      Container(
                        width: 1,
                        height: 34,
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal: 7,
                        ),
                        color: borderSoft,
                      ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _environmentMetric(
    _EnvironmentItem item,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: navy.withAlpha(100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            item.icon,
            color: item.color,
            size: 15,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: muted2,
                    fontSize: 6.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.value,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          color: item.color,
                          fontSize: 13,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ),
                    if (item.unit.isNotEmpty) ...[
                      const SizedBox(width: 3),
                      Text(
                        item.unit,
                        style: const TextStyle(
                          color: muted2,
                          fontSize: 6.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOWER ANALYTICS
  // ============================================================

  Widget _lowerAnalytics(bool desktop) {
    final analytics = _riskAnalytics();
    final guidance = _travelGuidance();

    if (!desktop) {
      return Column(
        children: [
          analytics,
          const SizedBox(height: 10),
          guidance,
          const SizedBox(height: 10),
          _corridorStrip(),
        ],
      );
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: analytics,
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 4,
              child: guidance,
            ),
          ],
        ),
        const SizedBox(height: 10),
        _corridorStrip(),
      ],
    );
  }

  // ============================================================
  // RISK ANALYTICS
  // ============================================================

  Widget _riskAnalytics() {
    final total = _data.length;

    return _dashboardPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _panelHeading(
            icon: Icons.bar_chart_rounded,
            title: 'RISK DISTRIBUTION',
            subtitle: 'Latest backend records',
            color: purple,
            trailing: '$total RECORDS',
          ),
          const SizedBox(height: 13),
          _riskBarCompact(
            'CRITICAL',
            _criticalCount,
            total,
            critical,
          ),
          const SizedBox(height: 10),
          _riskBarCompact(
            'HIGH',
            _highCount,
            total,
            high,
          ),
          const SizedBox(height: 10),
          _riskBarCompact(
            'MODERATE',
            _moderateCount,
            total,
            moderate,
          ),
          const SizedBox(height: 10),
          _riskBarCompact(
            'SAFE / LOW',
            _safeCount,
            total,
            safe,
          ),
        ],
      ),
    );
  }

  Widget _riskBarCompact(
    String title,
    int count,
    int total,
    Color color,
  ) {
    final ratio =
        total == 0 ? 0.0 : count / total;

    final percentage =
        (ratio * 100).toStringAsFixed(0);

    return Row(
      children: [
        SizedBox(
          width: 76,
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 7,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(10),
            child: Stack(
              children: [
                Container(
                  height: 9,
                  color: navy2,
                ),
                FractionallySizedBox(
                  widthFactor:
                      ratio.clamp(0.0, 1.0),
                  child: Container(
                    height: 9,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 34,
          child: Text(
            '$percentage%',
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: muted,
              fontSize: 7,
            ),
          ),
        ),
        const SizedBox(width: 7),
        SizedBox(
          width: 20,
          child: Text(
            '$count',
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: white,
              fontSize: 8,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TRAVEL GUIDANCE
  // ============================================================

  Widget _travelGuidance() {
    final current = _highestRiskRecord();

    final risk =
        current == null ? 'SAFE' : _risk(current);

    final color = _riskColor(risk);

    final city =
        current == null ? 'Network' : _city(current);

    final recommendation = current == null
        ? 'No active backend recommendation is available because no active risk event is currently detected.'
        : _value(
            current,
            [
              'recommendations',
              'recommendation',
            ],
          );

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withAlpha(55),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withAlpha(14),
              borderRadius:
                  BorderRadius.circular(9),
            ),
            child: Icon(
              risk == 'SAFE'
                  ? Icons.check_circle_rounded
                  : Icons.lightbulb_rounded,
              color: color,
              size: 19,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'TRAVEL GUIDANCE',
                      style: TextStyle(
                        color: white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .5,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Flexible(
                      child: _smallBadge(
                        city,
                        color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  recommendation,
                  maxLines: 5,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 8.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _smallBadge(
            risk,
            color,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOTORWAY CORRIDORS
  // ============================================================

  Widget _corridorStrip() {
    return _dashboardPanel(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.route_rounded,
                color: purple,
                size: 15,
              ),
              const SizedBox(width: 7),
              const Text(
                'MOTORWAY CORRIDORS',
                style: TextStyle(
                  color: white,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .5,
                ),
              ),
              const Spacer(),
              const Text(
                'CURRENT STATUS',
                style: TextStyle(
                  color: muted2,
                  fontSize: 6.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact =
                  constraints.maxWidth < 650;

              final cards = [
                _routeCompact(
                  'M-2',
                  'Lahore → Islamabad',
                  [
                    'Lahore',
                    'Islamabad',
                  ],
                  cyan,
                ),
                _routeCompact(
                  'M-3',
                  'Lahore → Faisalabad',
                  [
                    'Lahore',
                    'Faisalabad',
                  ],
                  purple,
                ),
                _routeCompact(
                  'M-4',
                  'Faisalabad → Multan',
                  [
                    'Faisalabad',
                    'Multan',
                  ],
                  moderate,
                ),
              ];

              if (compact) {
                return Column(
                  children: [
                    for (int i = 0;
                        i < cards.length;
                        i++) ...[
                      cards[i],
                      if (i != cards.length - 1)
                        const SizedBox(
                          height: 7,
                        ),
                    ],
                  ],
                );
              }

              return Row(
                children: [
                  for (int i = 0;
                      i < cards.length;
                      i++) ...[
                    Expanded(
                      child: cards[i],
                    ),
                    if (i != cards.length - 1)
                      const SizedBox(width: 8),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _routeCompact(
    String route,
    String subtitle,
    List<String> cities,
    Color routeColor,
  ) {
    String highest = 'SAFE';
    int alertCount = 0;

    const priority = {
      'CRITICAL': 5,
      'HIGH': 4,
      'MODERATE': 3,
      'LOW': 2,
      'SAFE': 1,
    };

    for (final city in cities) {
      final risk =
          _highestRiskForCity(city);

      if ((priority[risk] ?? 0) >
          (priority[highest] ?? 0)) {
        highest = risk;
      }

      alertCount += _data.where(
        (item) =>
            _city(item).toLowerCase() ==
                city.toLowerCase() &&
            _isActiveRisk(item),
      ).length;
    }

    final statusColor =
        _riskColor(highest);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: borderSoft,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: routeColor.withAlpha(12),
              borderRadius:
                  BorderRadius.circular(7),
            ),
            child: Icon(
              Icons.route_rounded,
              color: routeColor,
              size: 15,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      route,
                      style: const TextStyle(
                        color: white,
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$alertCount active',
                      style: const TextStyle(
                        color: muted2,
                        fontSize: 6.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: muted2,
                    fontSize: 6.5,
                  ),
                ),
              ],
            ),
          ),
          _smallBadge(
            highest,
            statusColor,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RISK EVENTS
  // ============================================================

  Widget _riskEventsWorkspace(bool desktop) {
    return _dashboardPanel(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _eventsToolbar(desktop),
          const SizedBox(height: 10),
          _alertsContent(desktop),
        ],
      ),
    );
  }

  // ============================================================
  // TOOLBAR
  // ============================================================

  Widget _eventsToolbar(bool desktop) {
    final searchBox = Container(
      height: 38,
      constraints: const BoxConstraints(
        maxWidth: 320,
      ),
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderSoft,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _search = value;
          });
        },
        style: const TextStyle(
          color: white,
          fontSize: 9,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText:
              'Search city or motorway...',
          hintStyle: const TextStyle(
            color: muted2,
            fontSize: 8,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: cyan,
            size: 17,
          ),
          suffixIcon: _search.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();

                    setState(() {
                      _search = '';
                    });
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: muted2,
                    size: 14,
                  ),
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 10,
          ),
        ),
      ),
    );

    final filters = Wrap(
      spacing: 5,
      runSpacing: 5,
      children: [
        _filterChip(
          'ALL',
          cyan,
        ),
        _filterChip(
          'MODERATE',
          moderate,
        ),
        _filterChip(
          'HIGH',
          high,
        ),
        _filterChip(
          'CRITICAL',
          critical,
        ),
      ],
    );

    if (!desktop) {
      return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_active_rounded,
                color: critical,
                size: 15,
              ),
              const SizedBox(width: 7),
              const Text(
                'ACTIVE RISK EVENTS',
                style: TextStyle(
                  color: white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Text(
                '${_filteredAlerts.length} results',
                style: const TextStyle(
                  color: muted2,
                  fontSize: 7,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          searchBox,
          const SizedBox(height: 7),
          filters,
        ],
      );
    }

    return Row(
      children: [
        const Icon(
          Icons.notifications_active_rounded,
          color: critical,
          size: 16,
        ),
        const SizedBox(width: 7),
        const Text(
          'ACTIVE RISK EVENTS',
          style: TextStyle(
            color: white,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: muted2,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${_filteredAlerts.length}',
          style: const TextStyle(
            color: muted2,
            fontSize: 7,
          ),
        ),
        const Spacer(),
        searchBox,
        const SizedBox(width: 8),
        filters,
      ],
    );
  }

  Widget _filterChip(
    String value,
    Color color,
  ) {
    final selected = _filter == value;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _filter = value;
          });
        },
        borderRadius: BorderRadius.circular(7),
        child: AnimatedContainer(
          duration:
              const Duration(milliseconds: 180),
          padding:
              const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: selected
                ? color.withAlpha(18)
                : navy,
            borderRadius:
                BorderRadius.circular(7),
            border: Border.all(
              color: selected
                  ? color.withAlpha(85)
                  : borderSoft,
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              color:
                  selected ? color : muted,
              fontSize: 6.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ALERT CONTENT
  // ============================================================

  Widget _alertsContent(bool desktop) {
    final alerts = _filteredAlerts;

    if (alerts.isEmpty) {
      return _noAlerts();
    }

    return Column(
      children: [
        if (desktop) _alertTableHeader(),
        ...alerts.asMap().entries.map(
          (entry) => _alertRow(
            entry.value,
            entry.key,
            desktop,
          ),
        ),
      ],
    );
  }

  Widget _alertTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: navy,
        borderRadius:
            BorderRadius.circular(7),
      ),
      child: const Row(
        children: [
          SizedBox(width: 30),
          Expanded(
            flex: 3,
            child: Text(
              'LOCATION',
              style: TextStyle(
                color: muted2,
                fontSize: 6,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(
            width: 65,
            child: Text(
              'ROUTE',
              style: TextStyle(
                color: muted2,
                fontSize: 6,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(
            width: 75,
            child: Text(
              'RISK',
              style: TextStyle(
                color: muted2,
                fontSize: 6,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(
            width: 90,
            child: Text(
              'VISIBILITY',
              style: TextStyle(
                color: muted2,
                fontSize: 6,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              'RECOMMENDATION',
              style: TextStyle(
                color: muted2,
                fontSize: 6,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(width: 82),
        ],
      ),
    );
  }

  Widget _alertRow(
    Map<String, dynamic> item,
    int index,
    bool desktop,
  ) {
    final risk = _risk(item);
    final city = _city(item);
    final route = _routeForCity(city);
    final color = _riskColor(risk);

    final visibility = _value(
      item,
      [
        'visibility_km',
        'visibility',
      ],
    );

    final datetime = _value(
      item,
      [
        'datetime',
        'timestamp',
      ],
    );

    final recommendation = _value(
      item,
      [
        'recommendations',
        'recommendation',
      ],
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0,
        end: 1,
      ),
      duration: Duration(
        milliseconds: 250 + index * 45,
      ),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              8 * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: Container(
        margin:
            const EdgeInsets.only(top: 5),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: navy,
          borderRadius:
              BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
              color: color,
              width: 2.5,
            ),
            top: BorderSide(
              color: borderSoft,
            ),
            right: BorderSide(
              color: borderSoft,
            ),
            bottom: BorderSide(
              color: borderSoft,
            ),
          ),
        ),
        child: desktop
            ? _desktopAlertRow(
                item,
                risk,
                city,
                route,
                color,
                visibility,
                datetime,
                recommendation,
              )
            : _mobileAlertRow(
                item,
                risk,
                city,
                route,
                color,
                visibility,
                datetime,
                recommendation,
              ),
      ),
    );
  }

  Widget _desktopAlertRow(
    Map<String, dynamic> item,
    String risk,
    String city,
    String route,
    Color color,
    String visibility,
    String datetime,
    String recommendation,
  ) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withAlpha(12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _riskIcon(risk),
            color: color,
            size: 14,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                city,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  color: white,
                  fontSize: 9,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
              if (datetime != '--')
                Text(
                  datetime,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: muted2,
                    fontSize: 6,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          width: 65,
          child: Text(
            route,
            style: const TextStyle(
              color: muted,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SizedBox(
          width: 75,
          child: Align(
            alignment:
                Alignment.centerLeft,
            child: _smallBadge(
              risk,
              color,
            ),
          ),
        ),
        SizedBox(
          width: 90,
          child: Row(
            children: [
              const Icon(
                Icons.visibility_rounded,
                color: cyan,
                size: 12,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  '$visibility km',
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 7.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            recommendation,
            maxLines: 2,
            overflow:
                TextOverflow.ellipsis,
            style: const TextStyle(
              color: muted,
              fontSize: 7,
              height: 1.35,
            ),
          ),
        ),
        SizedBox(
          width: 82,
          child: TextButton(
            onPressed: () {
              _showDetails(item);
            },
            style: TextButton.styleFrom(
              foregroundColor: cyan,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 6,
              ),
            ),
            child: const Text(
              'DETAILS →',
              style: TextStyle(
                fontSize: 6.5,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _mobileAlertRow(
    Map<String, dynamic> item,
    String risk,
    String city,
    String route,
    Color color,
    String visibility,
    String datetime,
    String recommendation,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 31,
              height: 31,
              decoration: BoxDecoration(
                color: color.withAlpha(12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _riskIcon(risk),
                color: color,
                size: 15,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    city,
                    style: const TextStyle(
                      color: white,
                      fontSize: 10,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  Text(
                    '$route • $datetime',
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: muted2,
                      fontSize: 6.5,
                    ),
                  ),
                ],
              ),
            ),
            _smallBadge(
              risk,
              color,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _mobileMetric(
              Icons.visibility_rounded,
              '$visibility km',
              cyan,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                recommendation,
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  color: muted,
                  fontSize: 7,
                  height: 1.35,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _showDetails(item);
              },
              child: const Text(
                'DETAILS',
                style: TextStyle(
                  color: cyan,
                  fontSize: 6.5,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _mobileMetric(
    IconData icon,
    String value,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        borderRadius:
            BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 11,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 6.5,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DETAILS
  // ============================================================

  void _showDetails(
    Map<String, dynamic> item,
  ) {
    final risk = _risk(item);
    final city = _city(item);
    final route = _routeForCity(city);
    final color = _riskColor(risk);

    final visibility = _value(
      item,
      [
        'visibility_km',
        'visibility',
      ],
    );

    final pm25 = _value(
      item,
      [
        'pm25',
        'PM2.5',
        'pm_25',
      ],
    );

    final pm10 = _value(
      item,
      [
        'pm10',
        'PM10',
        'pm_10',
      ],
    );

    final temp = _value(
      item,
      [
        'temperature',
        'temp',
      ],
    );

    final humidity = _value(
      item,
      ['humidity'],
    );

    final wind = _value(
      item,
      [
        'wind',
        'wind_speed',
      ],
    );

    final datetime = _value(
      item,
      [
        'datetime',
        'timestamp',
      ],
    );

    final recommendation = _value(
      item,
      [
        'recommendations',
        'recommendation',
      ],
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.all(15),
          child: Container(
            constraints:
                const BoxConstraints(
              maxWidth: 700,
              maxHeight: 850,
            ),
            padding:
                const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: panel,
              borderRadius:
                  BorderRadius.circular(17),
              border: Border.all(
                color: color.withAlpha(70),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration:
                            BoxDecoration(
                          color:
                              color.withAlpha(15),
                          borderRadius:
                              BorderRadius.circular(
                            11,
                          ),
                        ),
                        child: Icon(
                          _riskIcon(risk),
                          color: color,
                          size: 23,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              'MOTORWAY RISK DETAIL',
                              style: TextStyle(
                                color: color,
                                fontSize: 7,
                                fontWeight:
                                    FontWeight.w900,
                                letterSpacing: .8,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              city,
                              style:
                                  const TextStyle(
                                color: white,
                                fontSize: 19,
                                fontWeight:
                                    FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                          );
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          color.withAlpha(10),
                      borderRadius:
                          BorderRadius.circular(
                        9,
                      ),
                      border: Border.all(
                        color:
                            color.withAlpha(35),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _riskIcon(risk),
                          color: color,
                          size: 17,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          risk,
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.route_rounded,
                          color: muted2,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          route,
                          style:
                              const TextStyle(
                            color: muted,
                            fontSize: 8,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _detailsGrid([
                    _DetailMetric(
                      'VISIBILITY',
                      '$visibility km',
                      Icons.visibility_rounded,
                      cyan,
                    ),
                    _DetailMetric(
                      'PM2.5',
                      pm25,
                      Icons.blur_on_rounded,
                      purple,
                    ),
                    _DetailMetric(
                      'PM10',
                      pm10,
                      Icons.grain_rounded,
                      high,
                    ),
                    _DetailMetric(
                      'TEMPERATURE',
                      temp,
                      Icons.thermostat_rounded,
                      high,
                    ),
                    _DetailMetric(
                      'HUMIDITY',
                      humidity,
                      Icons.water_drop_rounded,
                      cyan,
                    ),
                    _DetailMetric(
                      'WIND',
                      wind,
                      Icons.air_rounded,
                      safe,
                    ),
                  ]),
                  const SizedBox(height: 8),
                  _detailsInfoBox(
                    'LAST AVAILABLE UPDATE',
                    datetime,
                    Icons.schedule_rounded,
                    purple,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(13),
                    decoration:
                        BoxDecoration(
                      color: navy,
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                      border: Border.all(
                        color: borderSoft,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_rounded,
                          color: color,
                          size: 18,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              const Text(
                                'TRAVEL RECOMMENDATION',
                                style: TextStyle(
                                  color: muted2,
                                  fontSize: 7,
                                  fontWeight:
                                      FontWeight.w900,
                                  letterSpacing: .5,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                recommendation,
                                style:
                                    const TextStyle(
                                  color: muted,
                                  fontSize: 8.5,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(
                          dialogContext,
                        );
                      },
                      style:
                          OutlinedButton.styleFrom(
                        foregroundColor: cyan,
                        side: BorderSide(
                          color:
                              cyan.withAlpha(80),
                        ),
                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 11,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            8,
                          ),
                        ),
                      ),
                      child: const Text(
                        'CLOSE',
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailsGrid(
    List<_DetailMetric> items,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            constraints.maxWidth < 450 ? 2 : 3;

        return GridView.builder(
          shrinkWrap: true,
          physics:
              const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
            childAspectRatio:
                columns == 2 ? 1.8 : 2.05,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return Container(
              padding:
                  const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: navy,
                borderRadius:
                    BorderRadius.circular(8),
                border: Border.all(
                  color: borderSoft,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    item.icon,
                    color: item.color,
                    size: 14,
                  ),
                  const Spacer(),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: muted2,
                      fontSize: 6,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.value,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color: item.color,
                      fontSize: 9,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _detailsInfoBox(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: navy,
        borderRadius:
            BorderRadius.circular(8),
        border: Border.all(
          color: borderSoft,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 15,
          ),
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: muted2,
                  fontSize: 6,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 8,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _noAlerts() {
    final filtered =
        _search.isNotEmpty ||
        _filter != 'ALL';

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        vertical: 35,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: navy,
        borderRadius:
            BorderRadius.circular(9),
        border: Border.all(
          color: borderSoft,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: safe.withAlpha(12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: safe,
              size: 25,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            filtered
                ? 'NO MATCHING EVENTS'
                : 'NO ACTIVE RISK EVENTS',
            style: const TextStyle(
              color: white,
              fontSize: 12,
              fontWeight:
                  FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            filtered
                ? 'Try another city or risk filter.'
                : 'The monitored motorway network currently has no active risk events.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: muted,
              fontSize: 8,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PANEL
  // ============================================================

  Widget _dashboardPanel({
    required Widget child,
    EdgeInsetsGeometry padding =
        const EdgeInsets.all(13),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: panel,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: borderSoft,
        ),
      ),
      child: child,
    );
  }

  Widget _panelHeading({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    String? trailing,
  }) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withAlpha(12),
            borderRadius:
                BorderRadius.circular(7),
          ),
          child: Icon(
            icon,
            color: color,
            size: 15,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: white,
                  fontSize: 9,
                  fontWeight:
                      FontWeight.w900,
                  letterSpacing: .4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  color: muted2,
                  fontSize: 6.5,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null)
          _smallBadge(
            trailing,
            color,
          ),
      ],
    );
  }

  Widget _smallBadge(
    String text,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(14),
        borderRadius:
            BorderRadius.circular(6),
        border: Border.all(
          color: color.withAlpha(50),
        ),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow:
            TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 6.5,
          fontWeight:
              FontWeight.w900,
          letterSpacing: .15,
        ),
      ),
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================

  Widget _footer() {
    return Row(
      children: [
        const Icon(
          Icons.shield_outlined,
          color: cyan,
          size: 14,
        ),
        const SizedBox(width: 7),
        const Expanded(
          child: Text(
            'Smog Risk Prediction System • Motorway Safety Intelligence',
            style: TextStyle(
              color: muted2,
              fontSize: 7,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ),
        Text(
          '${_data.length} records',
          style: const TextStyle(
            color: muted2,
            fontSize: 7,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _loadingView() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, _) {
              final size =
                  58 +
                  (_pulseAnimation.value * 8);

              return Container(
                width: size,
                height: size,
                decoration:
                    BoxDecoration(
                  color:
                      cyan.withAlpha(10),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        cyan.withAlpha(60),
                    width: 2,
                  ),
                ),
                child:
                    const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: cyan,
                ),
              );
            },
          ),
          const SizedBox(height: 17),
          const Text(
            'Loading motorway intelligence...',
            style: TextStyle(
              color: white,
              fontSize: 11,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Preparing risk map and latest conditions',
            style: TextStyle(
              color: muted2,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _errorView() {
    return Center(
      child: Container(
        margin:
            const EdgeInsets.all(20),
        padding:
            const EdgeInsets.all(23),
        constraints:
            const BoxConstraints(
          maxWidth: 480,
        ),
        decoration: BoxDecoration(
          color: panel,
          borderRadius:
              BorderRadius.circular(13),
          border: Border.all(
            color:
                critical.withAlpha(55),
          ),
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color:
                    critical.withAlpha(12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: critical,
                size: 28,
              ),
            ),
            const SizedBox(height: 13),
            const Text(
              'Risk data could not be loaded',
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: white,
                fontSize: 14,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _error ?? 'Unknown error',
              textAlign:
                  TextAlign.center,
              style: const TextStyle(
                color: muted,
                fontSize: 9,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed:
                  _loadBackendData,
              icon: const Icon(
                Icons.refresh_rounded,
                size: 15,
              ),
              label:
                  const Text('RETRY'),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor: cyan,
                foregroundColor: navy,
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 18,
                  vertical: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ENVIRONMENT MODEL
// ============================================================

class _EnvironmentItem {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  _EnvironmentItem(
    this.title,
    this.value,
    this.unit,
    this.icon,
    this.color,
  );
}

// ============================================================
// DETAIL MODEL
// ============================================================

class _DetailMetric {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  _DetailMetric(
    this.title,
    this.value,
    this.icon,
    this.color,
  );
}