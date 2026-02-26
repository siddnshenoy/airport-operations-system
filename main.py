from db import execute_query

def test_connection():
    flights = execute_query("SELECT flight_id, flight_number, status FROM Flights LIMIT 5", fetch=True)
    for f in flights:
        print(f)

from passenger_module import passenger_entry_flow

if __name__ == "__main__":
    passenger_entry_flow()