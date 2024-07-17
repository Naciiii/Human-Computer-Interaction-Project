import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:studierendenwerk_app/components/navigation_bar.dart';
import 'package:studierendenwerk_app/user_data/user_data.dart';
import 'home_screen.dart';
import 'feedback_screen.dart'; // Fügen Sie diesen Import hinzu

int? currentUser;

class EventDetailsScreen extends StatefulWidget {
  final EventItem eventItem;
  const EventDetailsScreen({super.key, required this.eventItem});
  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final int _selectedIndex = 1;
  bool bookingExists = false;

  List<Widget> generateRows() {
    return widget.eventItem.properties.values.map((property) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(property),
          ],
        ),
      );
    }).toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _navigate(index);
    });
  }

  void _navigate(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, "/plan");
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, "/profile");
    } else {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialisieren Sie die bookingExists Variable in initState
    bookingExists = UserData().containsByTitle(widget.eventItem.title);
    currentUser = widget.eventItem.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventItem.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ListView(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Image.asset(
                widget.eventItem.thumbnailAsset,
                height: 200,
                width: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 5.0),
              child: Text('Details: ${widget.eventItem.title}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              color: Colors.white,
              child: Column(
                children: [
                  Text("Kategorie: ${widget.eventItem.category}"),
                  Text("Beschreibung: ${widget.eventItem.description}"),
                  Text("Datum: ${widget.eventItem.dateTime.toString()} "),
                  Text("Preis: ${widget.eventItem.price.toString()} €"),
                  Text(
                      "Belegte Plätze: ${currentUser.toString()}/ ${widget.eventItem.maxUser.toString()}"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FeedbackScreen(eventItem: widget.eventItem),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll<Color>(Colors.blue),
              foregroundColor:
                  const WidgetStatePropertyAll<Color>(Colors.white),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              )),
            ),
            child: const Text("Feedback"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (bookingExists) {
                await database().conn!.execute(
                    "Delete from Booking where Booking.titel='${widget.eventItem.title}' and Booking.benutzername='${UserData().username}'");
                await database().conn!.execute(
                    "Update Event set currentuser = currentuser - 1 where titel='${widget.eventItem.title}'");
                setState(() {
                  UserData().eventBookings.remove(widget.eventItem);
                  bookingExists = false;
                  currentUser =
                      (currentUser ?? widget.eventItem.currentUser) - 1;
                });
                MotionToast.success(
                  description: const Text("Erfolgreich abgemeldet"),
                  title: const Text("Erfolg"),
                  toastDuration: const Duration(seconds: 1),
                ).show(context);
              } else {
                await database().conn!.execute(
                    "Insert into Booking(Titel, Benutzername) values('${widget.eventItem.title}','${UserData().username}')");
                await database().conn!.execute(
                    "Update Event set currentuser = currentuser + 1 where titel='${widget.eventItem.title}'");
                setState(() {
                  UserData().eventBookings.add(widget.eventItem);
                  bookingExists = true;
                  currentUser =
                      (currentUser ?? widget.eventItem.currentUser) + 1;
                });
                MotionToast.success(
                  description: const Text("Erfolgreich angemeldet"),
                  title: const Text("Erfolg"),
                  toastDuration: const Duration(seconds: 1),
                ).show(context);
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  const WidgetStatePropertyAll<Color>(Colors.purple),
              foregroundColor:
                  const WidgetStatePropertyAll<Color>(Colors.white),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              )),
            ),
            child: Text(bookingExists ? "Abmelden" : "Anmelden"),
          ),
        ],
      ),
    );
  }
}
