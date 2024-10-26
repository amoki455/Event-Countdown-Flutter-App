import '../event.dart';

abstract class EventsRepository {
  Future<List<Event>> getEvents();

  Future<Event?> getEvent(String id);

  Future<Event?> insertEvent(Event event);

  Future<Event?> updateEvent(Event event);

  Future<void> deleteEvent(String id);
}
