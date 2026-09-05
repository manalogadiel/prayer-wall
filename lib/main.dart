import 'package:flutter/material.dart';

void main() => runApp(const PrayerWallApp());

const _ink = Color(0xFF24202A);
const _violet = Color(0xFF6956C9);
const _lavender = Color(0xFFF1EEFF);
const _rose = Color(0xFFFFF0F2);

class PrayerWallApp extends StatelessWidget {
  const PrayerWallApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Prayer Wall',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: _violet, brightness: Brightness.light),
          scaffoldBackgroundColor: const Color(0xFFFCFBFE),
          textTheme: const TextTheme(
            displaySmall: TextStyle(fontWeight: FontWeight.w800, color: _ink),
            headlineSmall: TextStyle(fontWeight: FontWeight.w800, color: _ink),
            titleLarge: TextStyle(fontWeight: FontWeight.w800, color: _ink),
            titleMedium: TextStyle(fontWeight: FontWeight.w700, color: _ink),
            bodyLarge: TextStyle(color: _ink, height: 1.45),
            bodyMedium: TextStyle(color: Color(0xFF655F6C), height: 1.4),
          ),
        ),
        home: const AuthGate(),
      );
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool joined = false;
  @override
  Widget build(BuildContext context) => joined
      ? const HomeShell()
      : WelcomePage(onContinue: () => setState(() => joined = true));
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, required this.onContinue});
  final VoidCallback onContinue;
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool signIn = true;
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 18),
                    const Center(child: BrandMark(size: 74)),
                    const SizedBox(height: 24),
                    Text(signIn ? 'Welcome back.' : 'You belong here.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displaySmall),
                    const SizedBox(height: 10),
                    Text(
                        signIn
                            ? 'A sacred place to pray with others.'
                            : 'Join a community that carries each other in prayer.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 34),
                    _Input(
                        controller: email,
                        label: 'Email address',
                        icon: Icons.mail_outline,
                        type: TextInputType.emailAddress),
                    const SizedBox(height: 14),
                    _Input(
                        controller: password,
                        label: 'Password',
                        icon: Icons.lock_outline,
                        obscure: true),
                    if (signIn)
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {},
                              child: const Text('Forgot password?'))),
                    const SizedBox(height: 10),
                    FilledButton(
                      onPressed: widget.onContinue,
                      style: FilledButton.styleFrom(
                          backgroundColor: _violet,
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                      child: Text(signIn ? 'Sign in' : 'Create account'),
                    ),
                    const SizedBox(height: 18),
                    Row(children: const [
                      Expanded(child: Divider()),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('or')),
                      Expanded(child: Divider())
                    ]),
                    const SizedBox(height: 18),
                    OutlinedButton.icon(
                        onPressed: widget.onContinue,
                        icon: const Icon(Icons.g_mobiledata_rounded, size: 26),
                        label: const Text('Continue with Google'),
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)))),
                    const SizedBox(height: 18),
                    TextButton(
                        onPressed: () => setState(() => signIn = !signIn),
                        child: Text(signIn
                            ? 'New to Prayer Wall? Create an account'
                            : 'Already have an account? Sign in')),
                    const SizedBox(height: 18),
                    const Text(
                        'By continuing, you agree to nurture a kind, respectful community.',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF8A8491))),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input(
      {required this.controller,
      required this.label,
      required this.icon,
      this.obscure = false,
      this.type});
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final TextInputType? type;
  @override
  Widget build(BuildContext context) => TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: type,
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE8E3EB))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE8E3EB)))));
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int tab = 0;
  final posts = <PrayerPost>[
    PrayerPost(
        name: 'Maya R.',
        initials: 'MR',
        time: '18 min',
        text:
            'Please pray for peace in my family. We are navigating a hard conversation this week, and I am asking for soft hearts and wise words.',
        count: 38,
        topic: 'Family'),
    PrayerPost(
        name: 'Anonymous',
        initials: '✦',
        time: '42 min',
        text:
            'Thankful today for a new beginning. God made a way when I could not see one.',
        count: 92,
        topic: 'Thanksgiving',
        thanks: true),
    PrayerPost(
        name: 'David K.',
        initials: 'DK',
        time: '1 hr',
        text:
            'I have an important medical appointment tomorrow. Please pray for courage, clarity, and good news.',
        count: 67,
        topic: 'Healing'),
  ];
  void addPost(PrayerPost post) => setState(() => posts.insert(0, post));
  @override
  Widget build(BuildContext context) {
    final pages = [
      WallPage(posts: posts, onAdd: addPost),
      const DiscoverPage(),
      JournalPage(posts: posts),
      const ProfilePage()
    ];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (v) => setState(() => tab = v),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Wall'),
            NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore),
                label: 'Discover'),
            NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book),
                label: 'Journal'),
            NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Me')
          ]),
    );
  }
}

class WallPage extends StatefulWidget {
  const WallPage({super.key, required this.posts, required this.onAdd});
  final List<PrayerPost> posts;
  final ValueChanged<PrayerPost> onAdd;
  @override
  State<WallPage> createState() => _WallPageState();
}

class _WallPageState extends State<WallPage> {
  String filter = 'For you';
  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final post = await showModalBottomSheet<PrayerPost>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const Composer());
              if (post != null) widget.onAdd(post);
            },
            backgroundColor: _violet,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Share')),
        body: CustomScrollView(slivers: [
          SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 8),
                  child: Row(children: [
                    const BrandMark(size: 42),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text('Prayer Wall',
                              style: Theme.of(context).textTheme.titleLarge),
                          const Text('Carry one another')
                        ])),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none_rounded))
                  ]))),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                children: [
                  'For you',
                  'Following',
                  'Healing',
                  'Family',
                  'Thanksgiving'
                ]
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(e),
                            selected: filter == e,
                            onSelected: (_) => setState(() => filter = e),
                            selectedColor: _lavender,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 110),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => PrayerCard(
                          post: widget.posts[index],
                          onChanged: () => setState(() {})),
                      childCount: widget.posts.length))),
        ]),
      );
}

class PrayerPost {
  PrayerPost(
      {required this.name,
      required this.initials,
      required this.time,
      required this.text,
      required this.count,
      required this.topic,
      this.thanks = false,
      this.prayed = false});
  String name, initials, time, text, topic;
  int count;
  bool thanks, prayed;
}

class PrayerCard extends StatelessWidget {
  const PrayerCard({super.key, required this.post, required this.onChanged});
  final PrayerPost post;
  final VoidCallback onChanged;
  @override
  Widget build(BuildContext context) => Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Color(0xFFF0ECF2))),
      child: Padding(
          padding: const EdgeInsets.all(18),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              _Avatar(label: post.initials, thanks: post.thanks),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(post.name,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    Text(
                        '${post.time} · ${post.thanks ? 'Thanksgiving' : 'Prayer'}',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF8A8491)))
                  ])),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
            ]),
            const SizedBox(height: 15),
            if (post.thanks)
              const _Pill(label: '✦  THANKSGIVING', color: _rose),
            if (post.thanks) const SizedBox(height: 10),
            Text(post.text, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Row(children: [
              const Icon(Icons.local_offer_outlined, size: 16, color: _violet),
              const SizedBox(width: 5),
              Text(post.topic,
                  style: const TextStyle(
                      color: _violet,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              const Spacer(),
              Text('${post.count} praying',
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF8A8491)))
            ]),
            const Divider(height: 28),
            Row(children: [
              Expanded(
                  child: TextButton.icon(
                      onPressed: () {
                        post.prayed = !post.prayed;
                        post.count += post.prayed ? 1 : -1;
                        onChanged();
                      },
                      icon: Icon(
                          post.prayed ? Icons.favorite : Icons.favorite_border,
                          color: post.prayed ? const Color(0xFFE85E75) : _ink),
                      label: Text(post.prayed ? 'Prayed' : 'I prayed',
                          style: TextStyle(
                              color:
                                  post.prayed ? const Color(0xFFE85E75) : _ink,
                              fontWeight: FontWeight.w700)))),
              Expanded(
                  child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.chat_bubble_outline, color: _ink),
                      label: const Text('Amen',
                          style: TextStyle(
                              color: _ink, fontWeight: FontWeight.w700))))
            ]),
          ])));
}

class Composer extends StatefulWidget {
  const Composer({super.key});
  @override
  State<Composer> createState() => _ComposerState();
}

class _ComposerState extends State<Composer> {
  bool anonymous = false, thanks = false;
  String topic = 'General';
  final text = TextEditingController();
  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                        height: 4,
                        width: 42,
                        decoration: BoxDecoration(
                            color: const Color(0xFFD9D2DE),
                            borderRadius: BorderRadius.circular(4)))),
                const SizedBox(height: 18),
                Text('Share with the wall',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 14),
                SegmentedButton<bool>(segments: const [
                  ButtonSegment(
                      value: false,
                      icon: Icon(Icons.volunteer_activism_outlined),
                      label: Text('Prayer')),
                  ButtonSegment(
                      value: true,
                      icon: Icon(Icons.auto_awesome),
                      label: Text('Thanksgiving'))
                ], selected: {
                  thanks
                }, onSelectionChanged: (v) => setState(() => thanks = v.first)),
                const SizedBox(height: 14),
                TextField(
                    controller: text,
                    onChanged: (_) => setState(() {}),
                    maxLines: 5,
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: thanks
                            ? 'What are you grateful for?'
                            : 'How can we pray for you?',
                        filled: true,
                        fillColor: const Color(0xFFFAF8FB),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none))),
                const SizedBox(height: 12),
                Wrap(
                    spacing: 8,
                    children: ['General', 'Healing', 'Family', 'Guidance']
                        .map((e) => ChoiceChip(
                            label: Text(e),
                            selected: topic == e,
                            onSelected: (_) => setState(() => topic = e)))
                        .toList()),
                SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: anonymous,
                    onChanged: (v) => setState(() => anonymous = v),
                    title: const Text('Post anonymously'),
                    subtitle: const Text('Your name will be hidden'),
                    secondary: const Icon(Icons.visibility_off_outlined)),
                SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: text.text.trim().isEmpty
                            ? null
                            : () => Navigator.pop(
                                context,
                                PrayerPost(
                                    name: anonymous ? 'Anonymous' : 'You',
                                    initials: anonymous ? '✦' : 'YO',
                                    time: 'now',
                                    text: text.text.trim(),
                                    count: 0,
                                    topic: topic,
                                    thanks: thanks)),
                        style: FilledButton.styleFrom(
                            backgroundColor: _violet,
                            padding: const EdgeInsets.all(16)),
                        child: const Text('Share with care'))),
              ])));
}

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});
  @override
  Widget build(BuildContext context) => _BasicPage(
      title: 'Discover',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Find a place to pray.',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text(
            'Explore prayer circles and topics that meet you where you are.'),
        const SizedBox(height: 26),
        ...['Healing & Hope', 'Families', 'Anxiety & Peace', 'Gratitude'].map(
            (e) => Card(
                child: ListTile(
                    leading: const CircleAvatar(
                        backgroundColor: _lavender,
                        child: Icon(Icons.groups_2_outlined, color: _violet)),
                    title: Text(e),
                    subtitle: const Text('A gentle community of prayer'),
                    trailing: const Icon(Icons.chevron_right))))
      ]));
}

class JournalPage extends StatelessWidget {
  const JournalPage({super.key, required this.posts});
  final List<PrayerPost> posts;
  @override
  Widget build(BuildContext context) => _BasicPage(
      title: 'My journal',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Your prayer journey',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('A private place to remember what you brought to God.'),
        const SizedBox(height: 28),
        Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: _lavender, borderRadius: BorderRadius.circular(20)),
            child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Today’s reflection',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, color: _violet)),
                  SizedBox(height: 8),
                  Text('“Be still, and know that I am God.”',
                      style:
                          TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                  SizedBox(height: 5),
                  Text('Psalm 46:10')
                ]))
      ]));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => _BasicPage(
      title: 'My profile',
      child: Column(children: [
        const SizedBox(height: 18),
        const _Avatar(label: 'YO', size: 84),
        const SizedBox(height: 14),
        Text('Your prayer space',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        const Text('Growing in faith, one prayer at a time.'),
        const SizedBox(height: 26),
        Row(children: const [
          Expanded(child: _Stat(number: '12', label: 'shared')),
          Expanded(child: _Stat(number: '148', label: 'prayed')),
          Expanded(child: _Stat(number: '9', label: 'saved'))
        ]),
        const SizedBox(height: 30),
        const ListTile(
            leading: Icon(Icons.bookmark_outline),
            title: Text('Saved prayers'),
            trailing: Icon(Icons.chevron_right)),
        const ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Settings'),
            trailing: Icon(Icons.chevron_right))
      ]));
}

class _BasicPage extends StatelessWidget {
  const _BasicPage({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => SafeArea(
      child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 26),
            child
          ])));
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 48});
  final double size;
  @override
  Widget build(BuildContext context) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: _violet, borderRadius: BorderRadius.circular(size * .31)),
      child: Icon(Icons.volunteer_activism_rounded,
          color: Colors.white, size: size * .58));
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.label, this.thanks = false, this.size = 40});
  final String label;
  final bool thanks;
  final double size;
  @override
  Widget build(BuildContext context) => CircleAvatar(
      radius: size / 2,
      backgroundColor: thanks ? const Color(0xFFFFE5B5) : _lavender,
      child: Text(label,
          style: TextStyle(
              color: thanks ? const Color(0xFF9B6500) : _violet,
              fontWeight: FontWeight.w800,
              fontSize: size * .31)));
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(99)),
      child: Text(label,
          style: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.w800, color: _ink)));
}

class _Stat extends StatelessWidget {
  const _Stat({required this.number, required this.label});
  final String number, label;
  @override
  Widget build(BuildContext context) => Column(children: [
        Text(number,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        Text(label, style: const TextStyle(color: Color(0xFF8A8491)))
      ]);
}
