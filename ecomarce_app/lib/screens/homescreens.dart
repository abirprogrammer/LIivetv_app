
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/authprovider.dart';

class HomeScreen extends StatefulWidget {
const HomeScreen({super.key});

@override
State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
int currentBanner = 0;

final List<String> banners = [
'assets/images/banner1.jpg',
'assets/images/banner2.jpg',
'assets/images/banner3.jpg',
];

final List<Map<String, dynamic>> categories = [
{
'title': 'Chest',
'icon': Icons.accessibility_new,
'color': Colors.red,
},
{
'title': 'Back',
'icon': Icons.fitness_center,
'color': Colors.blue,
},
{
'title': 'Legs',
'icon': Icons.directions_run,
'color': Colors.orange,
},
{
'title': 'Shoulder',
'icon': Icons.sports_gymnastics,
'color': Colors.purple,
},
{
'title': 'Arms',
'icon': Icons.fitness_center,
'color': Colors.green,
},
{
'title': 'Abs',
'icon': Icons.accessibility,
'color': Colors.teal,
},
{
'title': 'Cardio',
'icon': Icons.directions_run,
'color': Colors.pink,
},
{
'title': 'Stretch',
'icon': Icons.self_improvement,
'color': Colors.indigo,
},
];

final List<Map<String, dynamic>> workouts = [
{
'name': 'Bench Press',
'muscle': 'Chest',
'sets': '4 Sets',
'reps': '12 Reps',
'image': 'assets/images/bench_press.jpg',
'color': Colors.red,
},
{
'name': 'Barbell Squat',
'muscle': 'Legs',
'sets': '4 Sets',
'reps': '10 Reps',
'image': 'assets/images/squat.jpg',
'color': Colors.orange,
},
{
'name': 'Pull Up',
'muscle': 'Back',
'sets': '3 Sets',
'reps': '12 Reps',
'image': 'assets/images/pull_up.jpg',
'color': Colors.blue,
},
{
'name': 'Shoulder Press',
'muscle': 'Shoulder',
'sets': '4 Sets',
'reps': '10 Reps',
'image': 'assets/images/shoulder_press.jpg',
'color': Colors.purple,
},
];

@override
Widget build(BuildContext context) {
final theme = Theme.of(context);
final authProvider = context.watch<AuthProvider>();

final userName = authProvider.userName?.trim().isNotEmpty == true
? authProvider.userName!.trim()
    : 'Fitness User';

return Scaffold(
backgroundColor: theme.scaffoldBackgroundColor,

// =================================================
// DRAWER
// =================================================

drawer: _buildDrawer(context, authProvider),

body: SafeArea(
child: RefreshIndicator(
color: Colors.red,
onRefresh: () async {
await Future.delayed(
const Duration(milliseconds: 800),
);
},
child: CustomScrollView(
physics: const AlwaysScrollableScrollPhysics(),
slivers: [
// =================================================
// HEADER
// =================================================

SliverToBoxAdapter(
child: Padding(
padding: const EdgeInsets.fromLTRB(
20,
18,
20,
8,
),
child: Row(
children: [
// MENU BUTTON
Builder(
builder: (context) {
return GestureDetector(
onTap: () {
Scaffold.of(context).openDrawer();
},
child: Container(
height: 48,
width: 48,
decoration: BoxDecoration(
color: theme.cardColor,
borderRadius:
BorderRadius.circular(15),
border: Border.all(
color: Colors.grey.withOpacity(0.12),
),
),
child: const Icon(
Icons.menu_rounded,
),
),
);
},
),

const SizedBox(width: 13),

// PROFILE PIC + GREETING
Expanded(
child: Row(
children: [
_buildProfileAvatar(
authProvider.userImage,
radius: 25,
),

const SizedBox(width: 11),

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
'Good Morning 👋',
style: TextStyle(
fontSize: 12,
color: Colors.grey.shade600,
fontWeight: FontWeight.w500,
),
),
const SizedBox(height: 3),
Text(
userName,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
fontSize: 19,
fontWeight: FontWeight.bold,
),
),
],
),
),
],
),
),

// NOTIFICATION
Container(
height: 48,
width: 48,
decoration: BoxDecoration(
color: theme.cardColor,
borderRadius: BorderRadius.circular(15),
border: Border.all(
color: Colors.grey.withOpacity(0.12),
),
),
child: Stack(
children: [
const Center(
child: Icon(
Icons.notifications_none_rounded,
size: 27,
),
),
Positioned(
top: 11,
right: 11,
child: Container(
height: 8,
width: 8,
decoration: const BoxDecoration(
color: Colors.red,
shape: BoxShape.circle,
),
),
),
],
),
),
],
),
),
),

// =================================================
// WELCOME TEXT
// =================================================

SliverToBoxAdapter(
child: Padding(
padding: const EdgeInsets.fromLTRB(
20,
18,
20,
12,
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
const Text(
'Ready to train?',
style: TextStyle(
fontSize: 27,
fontWeight: FontWeight.w800,
),
),
const SizedBox(height: 5),
Text(
'Let’s make today stronger than yesterday.',
style: TextStyle(
color: Colors.grey.shade600,
fontSize: 14,
),
),
],
),
),
),

// =================================================
// BANNER
// =================================================

SliverToBoxAdapter(
child: CarouselSlider.builder(
itemCount: banners.length,
itemBuilder: (
context,
index,
realIndex,
) {
return _buildBanner(
banners[index],
index,
);
},
options: CarouselOptions(
height: 205,
viewportFraction: 0.90,
enlargeCenterPage: true,
enlargeFactor: 0.18,
autoPlay: true,
autoPlayInterval:
const Duration(seconds: 4),
autoPlayAnimationDuration:
const Duration(milliseconds: 800),
onPageChanged: (index, reason) {
setState(() {
currentBanner = index;
});
},
),
),
),

// =================================================
// INDICATORS
// =================================================

SliverToBoxAdapter(
child: Padding(
padding: const EdgeInsets.only(
top: 12,
),
child: Row(
mainAxisAlignment:
MainAxisAlignment.center,
children: List.generate(
banners.length,
(index) {
final active =
currentBanner == index;

return AnimatedContainer(
duration: const Duration(
milliseconds: 300,
),
margin:
const EdgeInsets.symmetric(
horizontal: 3,
),
height: 6,
width: active ? 24 : 6,
decoration: BoxDecoration(
color: active
? Colors.red
    : Colors.grey.shade400,
borderRadius:
BorderRadius.circular(20),
),
);
},
),
),
),
),

// =================================================
// TODAY WORKOUT
// =================================================

SliverToBoxAdapter(
child: Padding(
padding: const EdgeInsets.only(
top: 28,
),
child: _sectionHeader(
'Today’s Workout',
'Start Now',
() {},
),
),
),

SliverToBoxAdapter(
child: Padding(
padding: const EdgeInsets.fromLTRB(
20,
4,
20,
0,
),
child: _buildTodayWorkout(context),
),
),

// =================================================
// CATEGORIES
// =================================================

SliverToBoxAdapter(
child: Padding(
padding: const EdgeInsets.only(
top: 30,
),
child: _sectionHeader(
'Workout Categories',
'View All',
() {},
),
),
),

SliverToBoxAdapter(
child: SizedBox(
height: 116,
child: ListView.builder(
scrollDirection: Axis.horizontal,
padding: const EdgeInsets.fromLTRB(
20,
5,
20,
5,
),
itemCount: categories.length,
itemBuilder: (context, index) {
return _buildCategory(
context,
categories[index],
);
},
),
),
),

// =================================================
// QUICK STATS
// =================================================

SliverToBoxAdapter(
child: Padding(
padding: const EdgeInsets.fromLTRB(
20,
18,
20,
0,
),
child: _buildQuickStats(context),
),
),

// =================================================
// PROGRESS
// =================================================

SliverToBoxAdapter(
child: Padding(
padding: const EdgeInsets.only(
top: 30,
),
child: _sectionHeader(
'Your Progress',
'Details',
() {},
),
),
),

SliverToBoxAdapter(
child: Padding(
padding: const EdgeInsets.fromLTRB(
20,
4,
20,
0,
),
child: _buildProgressCard(context),
),
),

// =================================================
// RECOMMENDED
// =================================================

SliverToBoxAdapter(
child: Padding(
padding: const EdgeInsets.only(
top: 30,
),
child: _sectionHeader(
'Recommended For You',
'See All',
() {},
),
),
),

SliverPadding(
padding: const EdgeInsets.fromLTRB(
20,
5,
20,
35,
),
sliver: SliverList(
delegate: SliverChildBuilderDelegate(
(context, index) {
return _buildWorkoutCard(
context,
workouts[index],
);
},
childCount: workouts.length,
),
),
),
],
),
),
),
);
}

// =====================================================
// PROFILE AVATAR
// =====================================================

Widget _buildProfileAvatar(
String? imageUrl, {
double radius = 25,
}) {
if (imageUrl != null &&
imageUrl.trim().isNotEmpty) {
return CircleAvatar(
radius: radius,
backgroundColor: Colors.red.shade50,
backgroundImage:
NetworkImage(imageUrl),
onBackgroundImageError:
(_, __) {},
);
}

return CircleAvatar(
radius: radius,
backgroundColor: Colors.red.shade50,
child: Icon(
Icons.person_rounded,
color: Colors.red,
size: radius * 1.05,
),
);
}

// =====================================================
// BANNER
// =====================================================

Widget _buildBanner(
String image,
int index,
) {
return Container(
width: double.infinity,
decoration: BoxDecoration(
borderRadius:
BorderRadius.circular(24),
boxShadow: [
BoxShadow(
color:
Colors.black.withOpacity(0.16),
blurRadius: 18,
offset: const Offset(0, 8),
),
],
),
child: ClipRRect(
borderRadius:
BorderRadius.circular(24),
child: Stack(
fit: StackFit.expand,
children: [
Image.asset(
image,
fit: BoxFit.cover,
errorBuilder:
(context, error, stackTrace) {
return Container(
decoration:
const BoxDecoration(
gradient: LinearGradient(
colors: [
Color(0xffE53935),
Color(0xff8E0000),
],
),
),
child: const Icon(
Icons.fitness_center,
color: Colors.white,
size: 65,
),
);
},
),

// DARK GRADIENT
Container(
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment.bottomCenter,
end: Alignment.topCenter,
colors: [
Colors.black.withOpacity(0.82),
Colors.black.withOpacity(0.05),
],
),
),
),

Positioned(
left: 22,
right: 22,
bottom: 20,
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Container(
padding:
const EdgeInsets.symmetric(
horizontal: 10,
vertical: 5,
),
decoration: BoxDecoration(
color: Colors.red,
borderRadius:
BorderRadius.circular(8),
),
child: const Text(
'FITNESS',
style: TextStyle(
color: Colors.white,
fontSize: 10,
fontWeight:
FontWeight.bold,
letterSpacing: 1,
),
),
),
const SizedBox(height: 8),
const Text(
'BUILD YOUR\nBEST VERSION',
style: TextStyle(
color: Colors.white,
fontSize: 24,
height: 1.05,
fontWeight:
FontWeight.w900,
),
),
const SizedBox(height: 6),
const Text(
'Train harder. Get stronger.',
style: TextStyle(
color: Colors.white70,
fontSize: 13,
),
),
],
),
),
],
),
),
);
}

// =====================================================
// SECTION HEADER
// =====================================================

Widget _sectionHeader(
String title,
String buttonText,
VoidCallback onTap,
) {
return Padding(
padding: const EdgeInsets.symmetric(
horizontal: 20,
),
child: Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [
Text(
title,
style: const TextStyle(
fontSize: 20,
fontWeight: FontWeight.w800,
),
),
TextButton(
onPressed: onTap,
child: Text(
buttonText,
style: const TextStyle(
color: Colors.red,
fontWeight: FontWeight.w700,
),
),
),
],
),
);
}

// =====================================================
// TODAY WORKOUT
// =====================================================

Widget _buildTodayWorkout(
BuildContext context,
) {
return Container(
padding: const EdgeInsets.all(18),
decoration: BoxDecoration(
gradient: const LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color(0xffF44336),
Color(0xffB71C1C),
],
),
borderRadius:
BorderRadius.circular(24),
boxShadow: [
BoxShadow(
color:
Colors.red.withOpacity(0.25),
blurRadius: 20,
offset: const Offset(0, 9),
),
],
),
child: Column(
children: [
Row(
children: [
Container(
height: 70,
width: 70,
decoration: BoxDecoration(
color:
Colors.white.withOpacity(0.16),
borderRadius:
BorderRadius.circular(20),
),
child: const Icon(
Icons.fitness_center_rounded,
color: Colors.white,
size: 36,
),
),

const SizedBox(width: 15),

const Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
'Full Body Workout',
style: TextStyle(
color: Colors.white,
fontSize: 19,
fontWeight:
FontWeight.bold,
),
),
SizedBox(height: 7),
Text(
'8 Exercises • 35 Minutes',
style: TextStyle(
color: Colors.white70,
fontSize: 13,
),
),
],
),
),

Container(
height: 48,
width: 48,
decoration:
const BoxDecoration(
color: Colors.white,
shape: BoxShape.circle,
),
child: const Icon(
Icons.play_arrow_rounded,
color: Colors.red,
size: 30,
),
),
],
),

const SizedBox(height: 18),

Row(
children: [
_todayInfo(
Icons.local_fire_department,
'320 kcal',
),
const SizedBox(width: 10),
_todayInfo(
Icons.timer_outlined,
'35 min',
),
const SizedBox(width: 10),
_todayInfo(
Icons.fitness_center,
'8 exercises',
),
],
),
],
),
);
}

Widget _todayInfo(
IconData icon,
String text,
) {
return Expanded(
child: Container(
padding:
const EdgeInsets.symmetric(
vertical: 9,
),
decoration: BoxDecoration(
color:
Colors.white.withOpacity(0.12),
borderRadius:
BorderRadius.circular(12),
),
child: Row(
mainAxisAlignment:
MainAxisAlignment.center,
children: [
Icon(
icon,
color: Colors.white,
size: 16,
),
const SizedBox(width: 5),
Flexible(
child: Text(
text,
overflow:
TextOverflow.ellipsis,
style: const TextStyle(
color: Colors.white,
fontSize: 11,
fontWeight:
FontWeight.w600,
),
),
),
],
),
),
);
}

// =====================================================
// CATEGORY
// =====================================================

Widget _buildCategory(
BuildContext context,
Map<String, dynamic> item,
) {
final Color color = item['color'];

return Container(
width: 82,
margin:
const EdgeInsets.only(right: 13),
child: Column(
children: [
Container(
height: 68,
width: 68,
decoration: BoxDecoration(
color:
color.withOpacity(0.11),
borderRadius:
BorderRadius.circular(20),
border: Border.all(
color:
color.withOpacity(0.08),
),
),
child: Icon(
item['icon'],
color: color,
size: 30,
),
),
const SizedBox(height: 9),
Text(
item['title'],
textAlign: TextAlign.center,
style: const TextStyle(
fontSize: 12,
fontWeight:
FontWeight.w700,
),
),
],
),
);
}

// =====================================================
// QUICK STATS
// =====================================================

Widget _buildQuickStats(
BuildContext context,
) {
final theme = Theme.of(context);

return Row(
children: [
Expanded(
child: _statCard(
context,
icon: Icons.local_fire_department,
title: 'Calories',
value: '1,420',
color: Colors.orange,
),
),
const SizedBox(width: 10),
Expanded(
child: _statCard(
context,
icon: Icons.timer_outlined,
title: 'Workout',
value: '3h 45m',
color: Colors.blue,
),
),
const SizedBox(width: 10),
Expanded(
child: _statCard(
context,
icon: Icons.emoji_events_outlined,
title: 'Streak',
value: '12 Days',
color: Colors.green,
),
),
],
);
}

Widget _statCard(
BuildContext context, {
required IconData icon,
required String title,
required String value,
required Color color,
}) {
return Container(
padding: const EdgeInsets.all(13),
decoration: BoxDecoration(
color: Theme.of(context).cardColor,
borderRadius:
BorderRadius.circular(18),
border: Border.all(
color:
Colors.grey.withOpacity(0.10),
),
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Container(
height: 32,
width: 32,
decoration: BoxDecoration(
color:
color.withOpacity(0.10),
borderRadius:
BorderRadius.circular(10),
),
child: Icon(
icon,
color: color,
size: 18,
),
),
const SizedBox(height: 9),
Text(
title,
style: TextStyle(
color: Colors.grey.shade600,
fontSize: 10,
),
),
const SizedBox(height: 3),
Text(
value,
maxLines: 1,
overflow:
TextOverflow.ellipsis,
style: const TextStyle(
fontSize: 13,
fontWeight:
FontWeight.bold,
),
),
],
),
);
}

// =====================================================
// PROGRESS CARD
// =====================================================

Widget _buildProgressCard(
BuildContext context,
) {
return Container(
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(
color: Theme.of(context).cardColor,
borderRadius:
BorderRadius.circular(23),
border: Border.all(
color:
Colors.grey.withOpacity(0.10),
),
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
height: 45,
width: 45,
decoration: BoxDecoration(
color:
Colors.red.withOpacity(0.10),
borderRadius:
BorderRadius.circular(14),
),
child: const Icon(
Icons.trending_up_rounded,
color: Colors.red,
),
),
const SizedBox(width: 12),
const Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
'Weekly Goal',
style: TextStyle(
fontSize: 17,
fontWeight:
FontWeight.bold,
),
),
SizedBox(height: 3),
Text(
'Keep pushing forward!',
style: TextStyle(
color: Colors.grey,
fontSize: 12,
),
),
],
),
),
Container(
padding:
const EdgeInsets.symmetric(
horizontal: 10,
vertical: 6,
),
decoration: BoxDecoration(
color:
Colors.green.withOpacity(0.10),
borderRadius:
BorderRadius.circular(10),
),
child: const Text(
'+12%',
style: TextStyle(
color: Colors.green,
fontWeight:
FontWeight.bold,
fontSize: 12,
),
),
),
],
),

const SizedBox(height: 22),

Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [
const Text(
'Workout completed',
style: TextStyle(
fontWeight:
FontWeight.w600,
),
),
Text(
'4 / 6 days',
style: TextStyle(
color:
Colors.grey.shade700,
fontWeight:
FontWeight.bold,
),
),
],
),

const SizedBox(height: 10),

ClipRRect(
borderRadius:
BorderRadius.circular(20),
child:
const LinearProgressIndicator(
value: 0.66,
minHeight: 10,
backgroundColor:
Color(0xffEEEEEE),
valueColor:
AlwaysStoppedAnimation(
Colors.red,
),
),
),

const SizedBox(height: 16),

Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [
_progressInfo(
'🔥 1,420',
'Calories',
Colors.orange,
),
_progressInfo(
'3h 45m',
'Duration',
Colors.blue,
),
_progressInfo(
'4',
'Workouts',
Colors.green,
),
],
),
],
),
);
}

Widget _progressInfo(
String value,
String title,
Color color,
) {
return Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
value,
style: TextStyle(
color: color,
fontWeight:
FontWeight.bold,
fontSize: 13,
),
),
const SizedBox(height: 3),
Text(
title,
style: const TextStyle(
color: Colors.grey,
fontSize: 10,
),
),
],
);
}

// =====================================================
// WORKOUT CARD
// =====================================================

Widget _buildWorkoutCard(
BuildContext context,
Map<String, dynamic> workout,
) {
final Color color =
workout['color'];

return Container(
margin:
const EdgeInsets.only(bottom: 14),
padding:
const EdgeInsets.all(10),
decoration: BoxDecoration(
color: Theme.of(context).cardColor,
borderRadius:
BorderRadius.circular(21),
border: Border.all(
color:
Colors.grey.withOpacity(0.10),
),
),
child: Row(
children: [
ClipRRect(
borderRadius:
BorderRadius.circular(16),
child: Image.asset(
workout['image'],
height: 88,
width: 88,
fit: BoxFit.cover,
errorBuilder:
(context, error, stackTrace) {
return Container(
height: 88,
width: 88,
color:
color.withOpacity(0.12),
child: Icon(
Icons.fitness_center,
color: color,
size: 34,
),
);
},
),
),

const SizedBox(width: 14),

Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
workout['name'],
style: const TextStyle(
fontSize: 16,
fontWeight:
FontWeight.bold,
),
),

const SizedBox(height: 5),

Text(
workout['muscle'],
style: TextStyle(
color: color,
fontWeight:
FontWeight.w700,
fontSize: 12,
),
),

const SizedBox(height: 9),

Row(
children: [
_smallInfo(
workout['sets'],
),
const SizedBox(width: 7),
_smallInfo(
workout['reps'],
),
],
),
],
),
),

Container(
height: 40,
width: 40,
decoration: BoxDecoration(
color:
color.withOpacity(0.10),
shape: BoxShape.circle,
),
child: Icon(
Icons.arrow_forward_ios_rounded,
size: 15,
color: color,
),
),
],
),
);
}

Widget _smallInfo(
String text,
) {
return Container(
padding:
const EdgeInsets.symmetric(
horizontal: 8,
vertical: 5,
),
decoration: BoxDecoration(
color:
Colors.grey.withOpacity(0.08),
borderRadius:
BorderRadius.circular(8),
),
child: Text(
text,
style: const TextStyle(
fontSize: 10,
fontWeight:
FontWeight.w600,
),
),
);
}

// =====================================================
// DRAWER
// =====================================================

Widget _buildDrawer(
BuildContext context,
AuthProvider authProvider,
) {
final theme = Theme.of(context);

final name =
authProvider.userName?.isNotEmpty == true
? authProvider.userName!
    : 'Fitness User';

final email =
authProvider.userEmail ?? '';

final phone =
authProvider.userPhone ?? '';

return Drawer(
child: SafeArea(
child: Column(
children: [
// PROFILE HEADER
Container(
width: double.infinity,
padding:
const EdgeInsets.fromLTRB(
20,
25,
20,
22,
),
decoration:
const BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color(0xffF44336),
Color(0xffB71C1C),
],
),
),
child: Column(
children: [
_buildProfileAvatar(
authProvider.userImage,
radius: 43,
),

const SizedBox(height: 12),

Text(
name,
textAlign:
TextAlign.center,
style: const TextStyle(
color: Colors.white,
fontSize: 20,
fontWeight:
FontWeight.bold,
),
),

if (email.isNotEmpty) ...[
const SizedBox(height: 5),
Text(
email,
textAlign:
TextAlign.center,
style: const TextStyle(
color: Colors.white70,
fontSize: 12,
),
),
],

if (phone.isNotEmpty) ...[
const SizedBox(height: 3),
Text(
phone,
style: const TextStyle(
color: Colors.white70,
fontSize: 12,
),
),
],
],
),
),

const SizedBox(height: 8),

_drawerItem(
context,
icon: Icons.home_rounded,
title: 'Home',
selected: true,
onTap: () {
Navigator.pop(context);
},
),

_drawerItem(
context,
icon:
Icons.fitness_center_rounded,
title: 'My Workouts',
onTap: () {},
),

_drawerItem(
context,
icon:
Icons.restaurant_menu_rounded,
title: 'Nutrition',
onTap: () {},
),

_drawerItem(
context,
icon:
Icons.bar_chart_rounded,
title: 'My Progress',
onTap: () {},
),



_drawerItem(
context,
icon: Icons.settings_outlined,
title: 'Settings',
onTap: () {},
),

_drawerItem(
context,
icon:
Icons.info_outline_rounded,
title: 'About App',
onTap: () {},
),


const Spacer(),

const Padding(
padding:
EdgeInsets.symmetric(
horizontal: 18,
),
child: Divider(),
),

_drawerItem(
context,
icon: Icons.logout_rounded,
title: 'Logout',
color: Colors.red,
onTap: () async {
await context
    .read<AuthProvider>()
    .logout();

if (!context.mounted) return;

Navigator.pushNamedAndRemoveUntil(
context,
'/login',
(route) => false,
);
},
),

const SizedBox(height: 12),
],
),
),
);
}

Widget _drawerItem(
BuildContext context, {
required IconData icon,
required String title,
required VoidCallback onTap,
bool selected = false,
Color? color,
}) {
final itemColor =
color ??
(selected ? Colors.red : null);

return Padding(
padding:
const EdgeInsets.symmetric(
horizontal: 10,
vertical: 2,
),
child: ListTile(
shape: RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(14),
),
tileColor: selected
? Colors.red.withOpacity(0.08)
    : null,
leading: Icon(
icon,
color: itemColor,
),
title: Text(
title,
style: TextStyle(
color: itemColor,
fontWeight: selected
? FontWeight.bold
    : FontWeight.w500,
),
),
trailing: selected
? const Icon(
Icons.chevron_right_rounded,
color: Colors.red,
)
    : null,
onTap: onTap,
),
);
}
}

