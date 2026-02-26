from db import execute_query
from datetime import datetime, timedelta


def get_flight_by_number(flight_number):
    result = execute_query(
        "SELECT * FROM Flights WHERE flight_number = %s",
        (flight_number,),
        fetch=True
    )
    return result[0] if result else None


def is_seat_taken(flight_id, seat_number):
    result = execute_query(
        "SELECT * FROM Tickets WHERE flight_id = %s AND seat_number = %s",
        (flight_id, seat_number),
        fetch=True
    )
    return len(result) > 0


def create_passenger(name, phone):
    execute_query(
        "INSERT INTO Passengers (full_name, phone, entry_time) VALUES (%s, %s, %s)",
        (name, phone, datetime.now())
    )

    result = execute_query(
        "SELECT LAST_INSERT_ID() as id",
        fetch=True
    )
    return result[0]["id"]


def create_ticket(passenger_id, flight_id, seat_number):
    execute_query(
        "INSERT INTO Tickets (passenger_id, flight_id, seat_number) VALUES (%s, %s, %s)",
        (passenger_id, flight_id, seat_number)
    )


def check_entry_allowed(flight):
    now = datetime.now()
    departure = flight["departure_time"]

    if flight["flight_type"] == "Domestic":
        allowed_time = departure - timedelta(hours=3)
    else:
        allowed_time = departure - timedelta(hours=5)

    if now < allowed_time:
        return False, allowed_time

    return True, allowed_time


def passenger_entry_flow():
    flight_number = input("Enter Flight Number: ")
    flight = get_flight_by_number(flight_number)

    if not flight:
        print("Flight not found.")
        return

    if flight["status"] == "Cancelled":
        print("Flight is cancelled.")
        return

    allowed, allowed_time = check_entry_allowed(flight)

    if not allowed:
        print(f"Entry not open yet. Entry opens at: {allowed_time}")
        return

    name = input("Enter Passenger Name: ")
    phone = input("Enter Phone: ")
    seat = input("Enter Seat Number: ")

    if is_seat_taken(flight["flight_id"], seat):
        print("Seat already taken.")
        return

    passenger_id = create_passenger(name, phone)
    create_ticket(passenger_id, flight["flight_id"], seat)

    print("Passenger entry successful.")
    print("Boarding pass will be generated in next stage.")