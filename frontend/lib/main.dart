import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const SenegalistApp());

// ─── COULEURS ────────────────────────────────────────────────────────────────
const kVert = Color(0xFF003F2D);
const kBleu = Color(0xFF0B5FFF);
const kOr = Color(0xFFF5A623);
const kNuit = Color(0xFF1A1A2E);
const kSurf = Color(0xFFF7F8FC);
const kBorder = Color(0xFFE5E7EB);
const kMuted = Color(0xFF6B7280);

// ─── DONNÉES ─────────────────────────────────────────────────────────────────
const List<Map<String, dynamic>> kDocuments = [
  {
    'titre': 'Impact du changement climatique au Sahel',
    'auteur': 'Diallo, A.',
    'source': 'UCAD',
    'type': 'Thèse',
    'annee': 2024,
    'bg': Color(0xFFEBF3FF),
    'color': Color(0xFF185FA5),
  },
  {
    'titre': 'Politiques agricoles au Sénégal 2000–2020',
    'auteur': 'Ndiaye, M.',
    'source': 'ANSD',
    'type': 'Rapport',
    'annee': 2023,
    'bg': Color(0xFFE6F4F1),
    'color': Color(0xFF1D9E75),
  },
  {
    'titre': "Systèmes de santé en Afrique de l'Ouest",
    'auteur': 'Sow, F.',
    'source': 'LIENS',
    'type': 'Article',
    'annee': 2024,
    'bg': Color(0xFFFBEAF0),
    'color': Color(0xFF993556),
  },
  {
    'titre': 'Droit constitutionnel sénégalais',
    'auteur': 'Fall, I.',
    'source': 'UCAD',
    'type': 'Thèse',
    'annee': 2022,
    'bg': Color(0xFFEEEDFE),
    'color': Color(0xFF534AB7),
  },
  {
    'titre': 'Économie numérique en Afrique',
    'auteur': 'Ba, O.',
    'source': 'ScholarvOx',
    'type': 'Article',
    'annee': 2025,
    'bg': Color(0xFFFEF3E2),
    'color': Color(0xFFBA7517),
  },
  {
    'titre': 'Démographie et urbanisation au Sénégal',
    'auteur': 'Diop, K.',
    'source': 'ANSD',
    'type': 'Rapport',
    'annee': 2024,
    'bg': Color(0xFFE6F4F1),
    'color': Color(0xFF0F6E56),
  },
];

const List<Map<String, dynamic>> kSources = [
  {'nom': 'ISFAD-UCAD', 'docs': 235, 'color': Color(0xFF185FA5)},
  {'nom': 'LIENS UCAD', 'docs': 144, 'color': Color(0xFFE24B4A)},
  {'nom': 'ANSD', 'docs': 58, 'color': Color(0xFF1A5276)},
  {'nom': 'ScholarvOx', 'docs': 30, 'color': Color(0xFF1D9E75)},
  {'nom': 'Autres', 'docs': 20, 'color': Color(0xFF534AB7)},
];

const List<Map<String, dynamic>> kBarData = [
  {'mois': 'Jan', 'val': 18},
  {'mois': 'Fév', 'val': 22},
  {'mois': 'Mar', 'val': 29},
  {'mois': 'Avr', 'val': 25},
  {'mois': 'Mai', 'val': 31},
  {'mois': 'Jun', 'val': 34},
];

const List<String> kChips = [
  'changement climatique',
  'agriculture',
  'économie numérique',
  'santé',
  'constitution',
];

const Map<String, Map<String, Color>> kPillColors = {
  'Thèse': {'color': Color(0xFF185FA5), 'bg': Color(0xFFEBF3FF)},
  'Article': {'color': Color(0xFF993556), 'bg': Color(0xFFFBEAF0)},
  'Rapport': {'color': Color(0xFF1D9E75), 'bg': Color(0xFFE6F4F1)},
};

// ─── APP ─────────────────────────────────────────────────────────────────────
class SenegalistApp extends StatelessWidget {
  const SenegalistApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Senegalist',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: kBleu),
      ),
      home: const HomePage(),
    );
  }
}

// ─── HOME PAGE ───────────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _filter = 'Tous';

  List<Map<String, dynamic>> get _filtered => kDocuments.where((d) {
    final q = _query.toLowerCase();
    final matchQ =
        q.isEmpty ||
        d['titre'].toString().toLowerCase().contains(q) ||
        d['auteur'].toString().toLowerCase().contains(q) ||
        d['source'].toString().toLowerCase().contains(q);
    final matchF = _filter == 'Tous' || d['type'] == _filter;
    return matchQ && matchF;
  }).toList();

  void _setQuery(String q) {
    setState(() {
      _query = q;
      _searchCtrl.text = q;
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurf,
      body: Column(
        children: [
          _Navbar(query: _query),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _Hero(
                    onSearch: (q) => setState(() => _query = q),
                    onChip: _setQuery,
                    controller: _searchCtrl,
                  ),
                  _KpiRow(),
                  _DashboardBody(
                    docs: _filtered,
                    filter: _filter,
                    query: _query,
                    onFilter: (f) => setState(() => _filter = f),
                    onClearQuery: () => setState(() {
                      _query = '';
                      _searchCtrl.clear();
                    }),
                  ),
                  _Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── NAVBAR ──────────────────────────────────────────────────────────────────
class _Navbar extends StatelessWidget {
  final String query;
  const _Navbar({required this.query});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: kBorder)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Row(
        children: [
          // Logo MESRI
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: kNuit, width: 2),
            ),
            child: const Text(
              'MESRI',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Senegalist',
                style: TextStyle(
                  color: kBleu,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              Text(
                'Recherche multi-dépôts',
                style: TextStyle(color: kMuted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(width: 20),
          _NavBtn(label: 'Rechercher', active: true),
          _NavBtn(label: 'Auteurs'),
          _NavBtn(label: 'Sources'),
          _NavBtn(label: 'Statistiques'),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF3FF),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFB5D4F4)),
            ),
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: '487 ',
                    style: TextStyle(
                      color: kBleu,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  TextSpan(
                    text: 'documents indexés',
                    style: TextStyle(color: kNuit, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.vpn_key_outlined, size: 15),
            label: const Text('Connexion'),
            style: OutlinedButton.styleFrom(
              foregroundColor: kNuit,
              side: const BorderSide(color: kBorder),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final String label;
  final bool active;
  const _NavBtn({required this.label, this.active = false});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: active ? kBleu : kMuted,
        backgroundColor: active ? const Color(0xFFEBF3FF) : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          fontSize: 13,
        ),
      ),
    );
  }
}

// ─── HERO ────────────────────────────────────────────────────────────────────
class _Hero extends StatelessWidget {
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onChip;
  final TextEditingController controller;
  const _Hero({
    required this.onSearch,
    required this.onChip,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF003F2D), Color(0xFF1A1A2E), Color(0xFF0B3F8F)],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PORTAIL NATIONAL DE LA RECHERCHE',
            style: TextStyle(
              color: kOr,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 14),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.2,
              ),
              children: [
                TextSpan(text: 'Explorez '),
                TextSpan(
                  text: '487 documents',
                  style: TextStyle(color: kOr),
                ),
                TextSpan(text: '\ninstitutionnels sénégalais'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Thèses, rapports, articles scientifiques — recherche sémantique sur\nl\'ensemble des archives académiques et institutionnelles du Sénégal.',
            style: TextStyle(
              color: Color(0x99FFFFFF),
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          // Search bar
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Icon(Icons.search, color: Color(0xFFAAAAAA), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onSubmitted: onSearch,
                      decoration: const InputDecoration(
                        hintText:
                            'Thèse, article, rapport... ex: agriculture, numérique, santé',
                        hintStyle: TextStyle(
                          color: Color(0xFFBBBBBB),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 46,
                    color: const Color(0xFFEEEEEE),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: 'Tous les dépôts',
                        items:
                            [
                                  'Tous les dépôts',
                                  'UCAD',
                                  'ANSD',
                                  'CORAF',
                                  'LIENS',
                                ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () => onSearch(controller.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kOr,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                      ),
                      child: const Text(
                        'Rechercher',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: kChips
                .map(
                  (c) => InkWell(
                    onTap: () => onChip(c),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        c,
                        style: const TextStyle(
                          color: Color(0xCCFFFFFF),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ─── KPI ROW ─────────────────────────────────────────────────────────────────
class _KpiRow extends StatefulWidget {
  @override
  State<_KpiRow> createState() => _KpiRowState();
}

class _KpiRowState extends State<_KpiRow> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 28, 40, 0),
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Row(
          children: [
            _KpiCard(
              label: 'Documents indexés',
              val: (487 * _anim.value).round(),
              sub: '7 archives connectées',
              accent: kBleu,
              icon: Icons.folder_copy_outlined,
            ),
            const SizedBox(width: 16),
            _KpiCard(
              label: 'Auteurs référencés',
              val: (312 * _anim.value).round(),
              sub: 'Chercheurs et institutions',
              accent: const Color(0xFF1D9E75),
              icon: Icons.people_outline,
            ),
            const SizedBox(width: 16),
            _KpiCard(
              label: 'Thèses & Rapports',
              val: (218 * _anim.value).round(),
              sub: 'Documents primaires',
              accent: kOr,
              icon: Icons.school_outlined,
            ),
            const SizedBox(width: 16),
            _KpiCard(
              label: 'Ajouts ce mois',
              val: (34 * _anim.value).round(),
              sub: 'Juin 2026',
              accent: const Color(0xFFE24B4A),
              icon: Icons.trending_up_rounded,
              prefix: '+',
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label, sub;
  final int val;
  final Color accent;
  final IconData icon;
  final String prefix;
  const _KpiCard({
    required this.label,
    required this.val,
    required this.sub,
    required this.accent,
    required this.icon,
    this.prefix = '',
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorder),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // top accent bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(height: 3, color: accent),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: kMuted,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$prefix$val',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: kNuit,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      sub,
                      style: const TextStyle(fontSize: 12, color: kMuted),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 18,
                top: 18,
                child: Icon(icon, size: 34, color: kNuit.withOpacity(0.07)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── DASHBOARD BODY ──────────────────────────────────────────────────────────
class _DashboardBody extends StatelessWidget {
  final List<Map<String, dynamic>> docs;
  final String filter, query;
  final ValueChanged<String> onFilter;
  final VoidCallback onClearQuery;

  const _DashboardBody({
    required this.docs,
    required this.filter,
    required this.query,
    required this.onFilter,
    required this.onClearQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT
          Expanded(
            child: _Panel(
              header: Row(
                children: [
                  const Text(
                    'DOCUMENTS RÉCENTS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: kMuted,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${docs.length} résultat${docs.length != 1 ? 's' : ''}',
                    style: const TextStyle(fontSize: 12, color: kMuted),
                  ),
                  if (query.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1F5EE),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF9FE1CB)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            query,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0F6E56),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: onClearQuery,
                            child: const Icon(
                              Icons.close,
                              size: 13,
                              color: Color(0xFF0F6E56),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              subHeader: _FilterRow(filter: filter, onFilter: onFilter),
              child: docs.isEmpty
                  ? const _EmptyState()
                  : Column(
                      children: docs.map((d) => _DocCard(doc: d)).toList(),
                    ),
            ),
          ),
          const SizedBox(width: 20),
          // RIGHT SIDEBAR
          SizedBox(
            width: 360,
            child: Column(
              children: [
                _Panel(
                  header: const Text(
                    'RÉPARTITION PAR ARCHIVE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: kMuted,
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      SizedBox(width: 190, height: 190, child: _DonutChart()),
                      const SizedBox(height: 18),
                      ...kSources.map(
                        (s) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: s['color'] as Color,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  s['nom'],
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              Text(
                                '${s['docs']}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: s['color'] as Color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _Panel(
                  header: const Text(
                    'CROISSANCE MENSUELLE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: kMuted,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _BarChart(),
                  ),
                ),
                const SizedBox(height: 20),
                _Panel(
                  header: const Text(
                    'PARCOURIR PAR SOURCE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: kMuted,
                    ),
                  ),
                  child: Column(
                    children: kSources
                        .map(
                          (s) => Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: kBorder.withOpacity(0.5),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: s['docs'] as int > 0
                                      ? s['color'] as Color
                                      : kBorder,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    s['nom'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: s['docs'] as int > 0
                                          ? kNuit
                                          : kMuted,
                                    ),
                                  ),
                                ),
                                if (s['docs'] as int > 0)
                                  Text(
                                    '${s['docs']}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: s['color'] as Color,
                                    ),
                                  )
                                else
                                  const Text(
                                    'bientôt',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: kMuted,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.open_in_new,
                                  size: 14,
                                  color: s['docs'] as int > 0
                                      ? s['color'] as Color
                                      : kBorder,
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PANEL ───────────────────────────────────────────────────────────────────
class _Panel extends StatelessWidget {
  final Widget header, child;
  final Widget? subHeader;
  const _Panel({required this.header, required this.child, this.subHeader});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 14),
            child: header,
          ),
          if (subHeader != null) ...[
            const Divider(height: 1, color: kBorder),
            subHeader!,
          ],
          const Divider(height: 1, color: kBorder),
          Padding(padding: const EdgeInsets.all(22), child: child),
        ],
      ),
    );
  }
}

// ─── FILTER ROW ──────────────────────────────────────────────────────────────
class _FilterRow extends StatelessWidget {
  final String filter;
  final ValueChanged<String> onFilter;
  const _FilterRow({required this.filter, required this.onFilter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      child: Row(
        children: ['Tous', 'Thèse', 'Article', 'Rapport'].map((f) {
          final on = filter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => onFilter(f),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: on ? const Color(0xFFEBF3FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: on ? const Color(0xFFB5D4F4) : kBorder,
                  ),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: on ? FontWeight.w700 : FontWeight.w400,
                    color: on ? kBleu : kMuted,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── DOC CARD ────────────────────────────────────────────────────────────────
class _DocCard extends StatelessWidget {
  final Map<String, dynamic> doc;
  const _DocCard({required this.doc});

  @override
  Widget build(BuildContext context) {
    final pc =
        kPillColors[doc['type']] ??
        {'color': kMuted, 'bg': const Color(0xFFF1EFE8)};
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorder)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: doc['bg'] as Color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.article_outlined,
              color: doc['color'] as Color,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['titre'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kNuit,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    Text(
                      doc['auteur'],
                      style: const TextStyle(fontSize: 12, color: kMuted),
                    ),
                    _Pill(
                      label: doc['type'],
                      color: pc['color']!,
                      bg: pc['bg']!,
                    ),
                    _Pill(
                      label: doc['source'],
                      color: const Color(0xFF5F5E5A),
                      bg: const Color(0xFFF1EFE8),
                    ),
                    Text(
                      '${doc['annee']}',
                      style: const TextStyle(fontSize: 12, color: kMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download_outlined),
            color: kMuted,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color, bg;
  const _Pill({required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ─── EMPTY STATE ─────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 40,
            color: kMuted.withOpacity(0.4),
          ),
          const SizedBox(height: 12),
          const Text(
            'Aucun document trouvé.',
            style: TextStyle(fontSize: 14, color: kMuted),
          ),
          const Text(
            'Essayez un autre terme de recherche.',
            style: TextStyle(fontSize: 13, color: kMuted),
          ),
        ],
      ),
    );
  }
}

// ─── DONUT CHART ─────────────────────────────────────────────────────────────
class _DonutChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DonutPainter(),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total', style: TextStyle(fontSize: 11, color: kMuted)),
            Text(
              '487',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: kNuit,
                height: 1,
              ),
            ),
            Text('docs', style: TextStyle(fontSize: 11, color: kMuted)),
          ],
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = min(size.width, size.height) / 2 - 8;
    const segments = [
      {'val': 235.0, 'color': Color(0xFF185FA5)},
      {'val': 144.0, 'color': Color(0xFFE24B4A)},
      {'val': 58.0, 'color': Color(0xFF1A5276)},
      {'val': 30.0, 'color': Color(0xFF1D9E75)},
      {'val': 20.0, 'color': Color(0xFF534AB7)},
    ];
    const total = 487.0;
    double start = -pi / 2;
    for (final seg in segments) {
      final sweep = 2 * pi * (seg['val'] as double) / total;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r - 14),
        start,
        sweep - 0.05,
        false,
        Paint()
          ..color = seg['color'] as Color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 32
          ..strokeCap = StrokeCap.butt,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── BAR CHART ───────────────────────────────────────────────────────────────
class _BarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const maxVal = 34.0;
    const barH = 110.0;
    return SizedBox(
      height: barH + 28,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: kBarData.asMap().entries.map((e) {
          final i = e.key;
          final d = e.value;
          final isLast = i == kBarData.length - 1;
          final frac = (d['val'] as int) / maxVal;
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isLast)
                  Text(
                    '+${d['val']}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: kBleu,
                    ),
                  )
                else
                  const SizedBox(height: 16),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(5),
                    ),
                    child: Container(
                      height: barH * frac,
                      color: isLast ? kBleu : const Color(0xFFB5D4F4),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  d['mois'],
                  style: const TextStyle(fontSize: 11, color: kMuted),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── FOOTER ──────────────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: kVert,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 40),
      child: const Text(
        '© 2026 — Centre National de Documentation Scientifique et Technique · Tous droits réservés',
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0x88FFFFFF), fontSize: 12),
      ),
    );
  }
}
