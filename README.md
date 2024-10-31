# Event Countdown Flutter App

## Overview

The Event Countdown Flutter App is a user-friendly application that allows users to create, manage, and track events with a countdown timer. Users must log in to access the events page, where they can view upcoming events, add new events, and manage existing ones. The app is designed to be responsive, adapting to different screen sizes, and utilizes notifications to remind users of their events.

## Features

- **User Authentication**: Secure login using Supabase for user management.
- **Events Page**: Displays a list of events with countdown timers.
- **Responsive Design**: Adapts to different screen sizes, switching to a grid layout on wider screens.
- **Event Management**: 
  - Add new events via a dialog with fields for title, description, date, and time.
  - Edit and delete events from the event cards.
- **Countdown Timer**: Displays the remaining time until each event in the format of `days:hours:minutes:seconds`.
- **Notifications**: Schedules notifications to alert users 15 minutes before and at the time of the event.
- **Menu Options**: Access a menu with options to reload the events list or log out.

## Usage

1. **Login**: Upon launching the app, users will be prompted to log in.
2. **Events Page**: After logging in, users will be directed to the events page.
3. **Add Event**: Click the Floating Action Button (FAB) to open a dialog for adding a new event.
4. **Event Cards**: Each event is displayed as a card showing the title and countdown timer.
5. **Manage Events**: Click the menu button on an event card to edit or delete the event.
6. **Menu Options**: Access the app bar menu to reload the events list or log out.

## Technical Information

- **State Management**: Utilizes the GetX package for state management and dependency injection.
- **Backend**: Supabase is used for authentication and database management.
- **Responsive Layout**: The app is designed to be adaptive, providing a seamless experience across various devices.

## Build Instructions

### Prerequisites

- Flutter SDK installed on your machine.
- An active Supabase account with a project set up.

### Configuration

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd event_countdown_app
   ```

2. Create the database:
   - Navigate to the `database` folder in the project directory.
   - Use the provided schema to create a new database in your Supabase project.
   - Apply the database policies as specified in the same directory.

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Set up Supabase:
   - Compile time environment variables should be provided using the `--dart-define` flag. Run the following command, replacing the placeholders with your actual Supabase URL and anon key:
     ```bash
     flutter run --dart-define=SUPABASE_URL=<your-supabase-url> --dart-define=SUPABASE_ANON_KEY=<your-supabase-anon-key>
     ```

## Screenshots

<img src="https://github.com/user-attachments/assets/a7e4b88c-85aa-4798-9504-79dee59b09a3" width="200"/> <img src="https://github.com/user-attachments/assets/39e0b03b-cd24-4033-9338-9a7f1ef4a7f4" width="200"/> <img src="https://github.com/user-attachments/assets/62018f4f-619f-44d5-88bf-cd2b2590eac9" width="200"/> <img src="https://github.com/user-attachments/assets/17cfaf3c-4cad-4f61-9272-b0d7fa353b7d" width="200"/> <img src="https://github.com/user-attachments/assets/6a1cdb31-c68d-4e84-9913-4740e6bbf6f8" width="200"/> <img src="https://github.com/user-attachments/assets/2c87b9f3-8687-4cb0-80bb-49d8b4914aa8" width="200"/> <img src="https://github.com/user-attachments/assets/1d102908-eb10-418f-a0c1-6843923c6a38" width="200"/> 
