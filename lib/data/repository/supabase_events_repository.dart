import 'package:supabase_flutter/supabase_flutter.dart';
import '../event.dart';
import 'events_repository.dart';

class SupabaseEventsRepository extends EventsRepository {
  SupabaseEventsRepository({SupabaseClient? supabaseClient}) : client = supabaseClient ?? Supabase.instance.client;

  SupabaseClient client;
  final eventsTable = "event";

  @override
  Future<void> deleteEvent(String id) async {
    await client.from(eventsTable).delete().eq("id", id);
  }

  @override
  Future<Event?> getEvent(String id) async {
    final response = await client.from(eventsTable).select().eq('id', id);
    final entry = response.firstOrNull;
    if (entry == null) return null;

    return Event.fromMap(entry);
  }

  @override
  Future<List<Event>> getEvents() async {
    final response = await client.from(eventsTable).select();
    return response.map((e) => Event.fromMap(e)).toList();
  }

  @override
  Future<Event?> insertEvent(Event event) async {
    final data = event.toMap();
    data.remove('id');
    data.remove('user_id');
    data.remove('created_at');
    final result = (await client.from(eventsTable).insert(data).select()).firstOrNull;
    return result != null ? Event.fromMap(result) : null;
  }

  @override
  Future<Event?> updateEvent(Event event) async {
    final data = event.toMap();
    data.remove('user_id');
    data.remove('created_at');
    final result = (await client.from(eventsTable).update(data).eq('id', event.id).select()).firstOrNull;
    return result != null ? Event.fromMap(result) : null;
  }
}
