import pandas as pd

INPUT_FILE = "ticks.csv"
OUTPUT_FILE = "ohlcv.csv"

def aggregate_ohlcv():
    df = pd.read_csv(INPUT_FILE)

    # Wichtig: sicherstellen, dass die Zeitspalte ein datetime-Objekt ist
    df["timestamp"] = pd.to_datetime(df["timestamp"], utc=True, errors="coerce")

    # Fehlerhafte (nicht konvertierbare) Zeitwerte entfernen
    df = df.dropna(subset=["timestamp"])

    # Zeit als Index setzen (erforderlich für resample)
    df.set_index("timestamp", inplace=True)

    # OHLCV berechnen mit 1-Minuten-Aggregation
    ohlcv = df.resample("15S").agg({
        "price": ["first", "max", "min", "last"],
        "quantity": "sum"
    })

    ohlcv.columns = ["open", "high", "low", "close", "volume"]
    ohlcv.dropna(inplace=True)
    ohlcv.to_csv(OUTPUT_FILE)
    print(f"✅ OHLCV gespeichert in {OUTPUT_FILE}")
    print(ohlcv.tail())

if __name__ == "__main__":
    aggregate_ohlcv()
