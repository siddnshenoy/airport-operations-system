from PIL import Image, ImageDraw, ImageFont
from pathlib import Path
from datetime import datetime

OUTPUT_DIR = Path("boarding_passes")
OUTPUT_DIR.mkdir(exist_ok=True)

WIDTH = 1100
HEIGHT = 420

# Color palette
C_BG = "#0A1628"
C_HEADER = "#132240"
C_ACCENT = "#1A73E8"
C_WHITE = "#FFFFFF"
C_MUTED = "#8899AA"
C_ORANGE = "#F39C12"
C_LINE = "#1E3A5F"


def load_font(size, bold=False):
    try:
        if bold:
            return ImageFont.truetype("C:/Windows/Fonts/arialbd.ttf", size)
        return ImageFont.truetype("C:/Windows/Fonts/arial.ttf", size)
    except:
        return ImageFont.load_default()


def generate_boarding_pass(passenger, flight, seat):
    img = Image.new("RGB", (WIDTH, HEIGHT), C_BG)
    draw = ImageDraw.Draw(img)

    # Fonts
    font_title = load_font(32, bold=True)
    font_big = load_font(60, bold=True)
    font_medium = load_font(24, bold=True)
    font_small = load_font(18)
    font_label = load_font(14)

    # Header bar
    draw.rectangle([0, 0, WIDTH, 70], fill=C_HEADER)

    draw.text((30, 18), "AIRPORT BOARDING PASS", font=font_title, fill=C_WHITE)
    draw.text((800, 22), flight["flight_number"], font=font_medium, fill=C_ACCENT)

    # Divider
    draw.line([(0, 70), (WIDTH, 70)], fill=C_LINE, width=2)

    # Route Section
    draw.text((60, 110), str(flight["origin_airport_id"]), font=font_big, fill=C_WHITE)
    draw.text((300, 135), "→", font=load_font(40), fill=C_ACCENT)
    draw.text((380, 110), str(flight["destination_airport_id"]), font=font_big, fill=C_WHITE)

    draw.text((60, 180), "ORIGIN", font=font_label, fill=C_MUTED)
    draw.text((380, 180), "DESTINATION", font=font_label, fill=C_MUTED)

    # Passenger
    draw.text((60, 220), passenger["full_name"].upper(), font=font_medium, fill=C_WHITE)
    draw.text((60, 250), "PASSENGER NAME", font=font_label, fill=C_MUTED)

    # Flight Info
    draw.text((500, 220), f"Gate: {flight['gate']}", font=font_medium, fill=C_WHITE)
    draw.text((500, 250), "GATE", font=font_label, fill=C_MUTED)

    draw.text((500, 280), f"Status: {flight['status']}", font=font_medium, fill=C_ACCENT)
    draw.text((500, 310), "FLIGHT STATUS", font=font_label, fill=C_MUTED)

    # Departure Time
    departure = flight["departure_time"].strftime("%d %b %Y  %H:%M")
    draw.text((60, 300), departure, font=font_medium, fill=C_WHITE)
    draw.text((60, 330), "DEPARTURE TIME", font=font_label, fill=C_MUTED)

    # Seat Box
    draw.rectangle([850, 110, 1050, 260], fill=C_HEADER)
    draw.text((900, 125), "SEAT", font=font_label, fill=C_MUTED)
    draw.text((905, 160), seat, font=load_font(64, bold=True), fill=C_ORANGE)

    # Ticket ID area
    ticket_id_text = f"TICKET ID: {flight['flight_number']}-{seat}"
    draw.line([(60, 360), (WIDTH - 60, 360)], fill=C_LINE, width=2)
    draw.text((60, 370), ticket_id_text, font=font_small, fill=C_MUTED)

    # Save
    filename = OUTPUT_DIR / f"{flight['flight_number']}_{seat}.png"
    img.save(filename)

    return filename