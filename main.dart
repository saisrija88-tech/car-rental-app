import 'package:flutter/material.dart';

void main() => runApp(const DriveNowApp());

class DriveNowApp extends StatelessWidget {
  const DriveNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DriveNow Car Rental',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const LoginPage(),
    );
  }
}

class CarInfo {
  final String name, type, fuel, image;
  final int seats;
  final double hourlyPrice, dailyPrice, rating;

  const CarInfo({
    required this.name,
    required this.type,
    required this.seats,
    required this.fuel,
    required this.hourlyPrice,
    required this.dailyPrice,
    required this.rating,
    required this.image,
  });
}

const cars = <CarInfo>[
  CarInfo(name: 'Hyundai i20', type: 'Hatchback', seats: 5, fuel: 'Petrol',
      hourlyPrice: 180, dailyPrice: 2200, rating: 4.5,
      image: 'https://images.unsplash.com/photo-1606152421802-db97b9c7a11b?w=900'),
  CarInfo(name: 'Maruti Swift', type: 'Hatchback', seats: 5, fuel: 'Petrol',
      hourlyPrice: 160, dailyPrice: 2000, rating: 4.4,
      image: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=900'),
  CarInfo(name: 'Honda City', type: 'Sedan', seats: 5, fuel: 'Petrol',
      hourlyPrice: 250, dailyPrice: 3200, rating: 4.7,
      image: 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=900'),
  CarInfo(name: 'Toyota Innova', type: 'MUV', seats: 7, fuel: 'Diesel',
      hourlyPrice: 400, dailyPrice: 5200, rating: 4.8,
      image: 'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=900'),
  CarInfo(name: 'Kia Seltos', type: 'SUV', seats: 5, fuel: 'Petrol',
      hourlyPrice: 320, dailyPrice: 4200, rating: 4.6,
      image: 'https://images.unsplash.com/photo-1511919884226-fd3cad34687c?w=900'),
  CarInfo(name: 'Mahindra Thar', type: 'SUV', seats: 4, fuel: 'Diesel',
      hourlyPrice: 380, dailyPrice: 4800, rating: 4.6,
      image: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=900'),
];

class RentalBooking {
  RentalBooking({
    required this.car,
    required this.bookingType,
    required this.pickup,
    required this.dropoff,
    required this.total,
    required this.payment,
  });

  final CarInfo car;
  final String bookingType;
  final DateTime pickup, dropoff;
  final double total;
  final String payment;
  bool completed = false;
  int? reviewRating;
  String feedback = '';
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void login() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    if (name.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your name and a valid email address.')),
      );
      return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (_) => DriveNowHome(userName: name, email: email),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.directions_car_filled, size: 76, color: Color(0xFF1565C0)),
                      const SizedBox(height: 8),
                      const Text('DriveNow', textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      const Text('Your journey, your way', textAlign: TextAlign.center),
                      const SizedBox(height: 28),
                      TextField(controller: nameController,
                        decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person), border: OutlineInputBorder())),
                      const SizedBox(height: 16),
                      TextField(controller: emailController, keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Email address', prefixIcon: Icon(Icons.email), border: OutlineInputBorder())),
                      const SizedBox(height: 20),
                      FilledButton(onPressed: login, child: const Padding(
                        padding: EdgeInsets.all(12), child: Text('Continue'))),
                      const SizedBox(height: 8),
                      const Text('Demo app: sign-in is stored only while the app is running.',
                        textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DriveNowHome extends StatefulWidget {
  const DriveNowHome({super.key, required this.userName, required this.email});
  final String userName, email;

  @override
  State<DriveNowHome> createState() => _DriveNowHomeState();
}

class _DriveNowHomeState extends State<DriveNowHome> {
  int selectedTab = 0;
  String address = '';
  bool notificationsEnabled = true;
  bool darkMode = false;
  final List<RentalBooking> bookings = [];

  void addBooking(RentalBooking booking) {
    setState(() => bookings.insert(0, booking));
  }

  void logout() {
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      CarsPage(onBook: (car, type) async {
        final booking = await Navigator.push<RentalBooking>(context,
          MaterialPageRoute(builder: (_) => BookingPage(car: car, bookingType: type)));
        if (booking != null) addBooking(booking);
      }),
      HistoryPage(bookings: bookings, onChanged: () => setState(() {})),
      ProfilePage(userName: widget.userName, email: widget.email, address: address,
        onAddressChanged: (value) => setState(() => address = value), onLogout: logout),
      SettingsPage(
        notificationsEnabled: notificationsEnabled,
        darkMode: darkMode,
        address: address,
        onNotificationsChanged: (v) => setState(() => notificationsEnabled = v),
        onDarkModeChanged: (v) => setState(() => darkMode = v),
        onAddressChanged: (v) => setState(() => address = v),
        onLogout: logout,
      ),
      AlertsPage(enabled: notificationsEnabled),
    ];
    return Theme(
      data: Theme.of(context).copyWith(
        brightness: darkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: darkMode ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DriveNow', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            Padding(padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(child: Text(widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : 'U'))),
          ],
        ),
        body: pages[selectedTab],
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedTab,
          onDestinationSelected: (i) => setState(() => selectedTab = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.directions_car), label: 'Cars'),
            NavigationDestination(icon: Icon(Icons.history), label: 'History'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
            NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
            NavigationDestination(icon: Icon(Icons.notifications), label: 'Alerts'),
          ],
        ),
      ),
    );
  }
}

class CarsPage extends StatelessWidget {
  const CarsPage({super.key, required this.onBook});
  final void Function(CarInfo, String) onBook;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF42A5F5)]),
          ),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Find your perfect ride', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text('Choose a car and book in a few easy steps.', style: TextStyle(color: Colors.white)),
          ]),
        ),
        const SizedBox(height: 16),
        const Text('Available cars', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...cars.map((car) => CarCard(car: car, onBook: onBook)),
      ],
    );
  }
}

class CarCard extends StatelessWidget {
  const CarCard({super.key, required this.car, required this.onBook});
  final CarInfo car;
  final void Function(CarInfo, String) onBook;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Image.network(car.image, height: 170, width: double.infinity, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(height: 170, color: Colors.blueGrey.shade100,
            child: const Center(child: Icon(Icons.directions_car, size: 70)))),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(car.name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
              const Icon(Icons.star, color: Colors.amber, size: 19),
              Text(car.rating.toString()),
            ]),
            Text('${car.type} • ${car.seats} seats • ${car.fuel}'),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: Text('₹${car.hourlyPrice.toInt()}/hour\n₹${car.dailyPrice.toInt()}/day',
                style: const TextStyle(fontWeight: FontWeight.w600))),
              OutlinedButton(onPressed: () => onBook(car, 'Pre-Booking'), child: const Text('Pre-book')),
              const SizedBox(width: 8),
              FilledButton(onPressed: () => onBook(car, 'Instant Booking'), child: const Text('Instant')),
            ]),
          ]),
        ),
      ]),
    );
  }
}

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.car, required this.bookingType});
  final CarInfo car;
  final String bookingType;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late DateTime pickupDate;
  late DateTime dropoffDate;
  TimeOfDay pickupTime = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay dropoffTime = const TimeOfDay(hour: 12, minute: 0);
  String payment = 'UPI';

  bool get isInstant => widget.bookingType == 'Instant Booking';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    pickupDate = isInstant ? DateTime(now.year, now.month, now.day) : DateTime(now.year, now.month, now.day + 1);
    dropoffDate = pickupDate;
    pickupTime = isInstant ? TimeOfDay(hour: now.hour, minute: now.minute) : const TimeOfDay(hour: 10, minute: 0);
    dropoffTime = TimeOfDay(hour: (pickupTime.hour + 2) % 24, minute: pickupTime.minute);
  }

  DateTime combine(DateTime date, TimeOfDay time) =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);

  Future<void> chooseDate(bool pickup) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: pickup ? pickupDate : dropoffDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selected != null) {
      setState(() {
        if (pickup) {
          pickupDate = selected;
          if (isInstant) dropoffDate = selected;
          if (dropoffDate.isBefore(pickupDate)) dropoffDate = pickupDate;
        } else {
          if (!isInstant || selected == pickupDate) dropoffDate = selected;
        }
      });
    }
  }

  Future<void> chooseTime(bool pickup) async {
    final selected = await showTimePicker(context: context, initialTime: pickup ? pickupTime : dropoffTime);
    if (selected != null) setState(() {
      if (pickup) pickupTime = selected; else dropoffTime = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final start = combine(pickupDate, pickupTime);
    var end = combine(dropoffDate, dropoffTime);
    if (isInstant) end = combine(pickupDate, dropoffTime);
    final valid = end.isAfter(start);
    final hours = end.difference(start).inMinutes / 60.0;
    final days = end.difference(start).inDays + (end.difference(start).inHours % 24 == 0 ? 0 : 1);
    final total = isInstant
        ? widget.car.hourlyPrice * (hours < 1 ? 1 : hours.ceil())
        : widget.car.dailyPrice * (days < 1 ? 1 : days);

    return Scaffold(
      appBar: AppBar(title: Text(widget.bookingType)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: ListTile(
          leading: const Icon(Icons.directions_car, size: 40),
          title: Text(widget.car.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${widget.car.type} • ${widget.car.seats} seats • ${widget.car.fuel}'),
          trailing: Text('₹${widget.car.dailyPrice.toInt()}/day'),
        )),
        const SizedBox(height: 12),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(isInstant ? 'Instant Booking — same-day rental' : 'Pre-Booking — reserve ahead',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 8),
            const Text('Instant booking uses today and an hourly estimate. Pre-booking starts tomorrow by default and is charged by day.'),
            const SizedBox(height: 12),
            ListTile(contentPadding: EdgeInsets.zero, title: const Text('Pickup date'),
              subtitle: Text('${pickupDate.day}/${pickupDate.month}/${pickupDate.year}'),
              trailing: TextButton(onPressed: () => chooseDate(true), child: const Text('Change'))),
            ListTile(contentPadding: EdgeInsets.zero, title: const Text('Pickup time'),
              subtitle: Text(pickupTime.format(context)),
              trailing: TextButton(onPressed: () => chooseTime(true), child: const Text('Change'))),
            ListTile(contentPadding: EdgeInsets.zero, title: const Text('Drop-off date'),
              subtitle: Text('${dropoffDate.day}/${dropoffDate.month}/${dropoffDate.year}'),
              trailing: TextButton(
                onPressed: isInstant ? null : () => chooseDate(false),
                child: Text(isInstant ? 'Same day' : 'Change')),
            ),
            ListTile(contentPadding: EdgeInsets.zero, title: const Text('Drop-off time'),
              subtitle: Text(dropoffTime.format(context)),
              trailing: TextButton(onPressed: () => chooseTime(false), child: const Text('Change'))),
          ],
        ))),
        const SizedBox(height: 12),
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Payment method', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: payment,
              items: const ['UPI', 'Credit / Debit Card', 'Net Banking', 'Cash on Pickup']
                .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => payment = v ?? 'UPI'),
            ),
            const SizedBox(height: 14),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Estimated total', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('₹${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
            ]),
            if (!valid) const Text('Drop-off must be after pickup.', style: TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: FilledButton.icon(
              onPressed: !valid ? null : () async {
                final confirm = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
                  title: const Text('Confirm booking?'),
                  content: Text('Book ${widget.car.name} for ₹${total.toStringAsFixed(0)} using $payment? This is a demo payment; no real money is charged.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirm')),
                  ],
                ));
                if (confirm == true && mounted) {
                  Navigator.pop(context, RentalBooking(
                    car: widget.car, bookingType: widget.bookingType,
                    pickup: start, dropoff: end, total: total, payment: payment,
                  ));
                }
              },
              icon: const Icon(Icons.check_circle), label: const Text('Confirm Booking'),
            )),
          ],
        ))),
      ]),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, required this.bookings, required this.onChanged});
  final List<RentalBooking> bookings;
  final VoidCallback onChanged;

  String dateText(DateTime d) => '${d.day}/${d.month}/${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) return const Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.history, size: 72, color: Colors.blueGrey),
        SizedBox(height: 12), Text('No bookings yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('Your confirmed bookings will appear here.'),
      ]));
    }
    return ListView(padding: const EdgeInsets.all(16), children: bookings.map((b) => Card(
      child: Padding(padding: const EdgeInsets.all(16), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(b.car.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            Chip(label: Text(b.completed ? 'Completed' : 'Booked')),
          ]),
          Text(b.bookingType),
          const SizedBox(height: 6),
          Text('Pickup: ${dateText(b.pickup)}'),
          Text('Drop-off: ${dateText(b.dropoff)}'),
          Text('Payment: ${b.payment}'),
          Text('Total: ₹${b.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (!b.completed)
            FilledButton.tonalIcon(
              onPressed: () {
                b.completed = true;
                onChanged();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Drive marked as completed.')));
              },
              icon: const Icon(Icons.flag), label: const Text('Mark drive completed'),
            )
          else
            OutlinedButton.icon(
              onPressed: () async {
                final ratingController = TextEditingController(text: b.reviewRating?.toString() ?? '5');
                final feedbackController = TextEditingController(text: b.feedback);
                final saved = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
                  title: const Text('Review your drive'),
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    TextField(controller: ratingController, keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Rating (1–5)')),
                    TextField(controller: feedbackController, maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Feedback')),
                  ]),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save review')),
                  ],
                ));
                if (saved == true) {
                  final parsed = int.tryParse(ratingController.text) ?? 5;
                  b.reviewRating = parsed.clamp(1, 5);
                  b.feedback = feedbackController.text.trim();
                  onChanged();
                }
              },
              icon: const Icon(Icons.rate_review), label: Text(b.reviewRating == null ? 'Add review' : 'Edit review'),
            ),
          if (b.reviewRating != null) ...[
            const SizedBox(height: 6),
            Text('Rating: ${'★' * b.reviewRating!}'),
            if (b.feedback.isNotEmpty) Text('Feedback: ${b.feedback}'),
          ],
        ],
      )),
    )).toList());
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.userName, required this.email,
    required this.address, required this.onAddressChanged, required this.onLogout});
  final String userName, email, address;
  final ValueChanged<String> onAddressChanged;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const SizedBox(height: 20),
    CircleAvatar(radius: 45, child: Text(userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
      style: const TextStyle(fontSize: 34))),
    const SizedBox(height: 12),
    Text(userName, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
    Text(email, textAlign: TextAlign.center),
    const SizedBox(height: 24),
    Card(child: ListTile(leading: const Icon(Icons.location_on), title: const Text('Address'),
      subtitle: Text(address.isEmpty ? 'Add your address' : address),
      trailing: const Icon(Icons.edit),
      onTap: () async {
        final c = TextEditingController(text: address);
        final value = await showDialog<String>(context: context, builder: (ctx) => AlertDialog(
          title: const Text('Edit address'),
          content: TextField(controller: c, maxLines: 3, decoration: const InputDecoration(hintText: 'Enter your address')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, c.text.trim()), child: const Text('Save')),
          ],
        ));
        if (value != null) onAddressChanged(value);
      })),
    const SizedBox(height: 12),
    OutlinedButton.icon(onPressed: onLogout, icon: const Icon(Icons.logout), label: const Text('Logout')),
  ]);
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.notificationsEnabled, required this.darkMode,
    required this.address, required this.onNotificationsChanged, required this.onDarkModeChanged,
    required this.onAddressChanged, required this.onLogout});
  final bool notificationsEnabled, darkMode;
  final String address;
  final ValueChanged<bool> onNotificationsChanged, onDarkModeChanged;
  final ValueChanged<String> onAddressChanged;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [
    SwitchListTile(
      secondary: const Icon(Icons.notifications_active),
      title: const Text('Notifications'), subtitle: const Text('Booking and reminder alerts'),
      value: notificationsEnabled, onChanged: onNotificationsChanged),
    SwitchListTile(
      secondary: const Icon(Icons.dark_mode),
      title: const Text('Dark mode'), subtitle: const Text('Change app appearance'),
      value: darkMode, onChanged: onDarkModeChanged),
    ListTile(leading: const Icon(Icons.location_on), title: const Text('Saved address'),
      subtitle: Text(address.isEmpty ? 'No address saved' : address)),
    const Divider(),
    const ListTile(leading: Icon(Icons.info_outline), title: Text('About DriveNow'),
      subtitle: Text('Car rental demo app. Bookings are stored in memory only.')),
    ListTile(leading: const Icon(Icons.logout), title: const Text('Logout'), onTap: onLogout),
  ]);
}

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key, required this.enabled});
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return const Center(child: Text('Notifications are turned off in Settings.'));
    return ListView(padding: const EdgeInsets.all(16), children: const [
      Card(child: ListTile(leading: Icon(Icons.notifications_active, color: Colors.blue),
        title: Text('Welcome to DriveNow'), subtitle: Text('Book a car for your next journey.'))),
      Card(child: ListTile(leading: Icon(Icons.info_outline, color: Colors.orange),
        title: Text('Demo notifications'), subtitle: Text('Booking reminders would appear here in a full app.'))),
    ]);
  }
}
