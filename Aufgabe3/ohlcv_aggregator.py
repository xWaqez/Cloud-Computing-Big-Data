import pandas as pd
from datetime import datetime

INPUT_FILE = "ticks.csv"
OUTPUT_FILE = "ohlcv.csv"

def aggregate_ohlcv():
    df = pd.read_csv(INPUT_FILE, parse_dates=["timestamp"])
    df.set_index("timestamp", inplace=True)

    ohlcv = df.resample("1Min").agg({
        "price": ["first", "max", "min", "last"],
        "quantity": "sum"
    })
    ohlcv.columns = ["open", "high", "low", "close", "volume"]
    ohlcv.dropna(inplace=True)
    ohlcv.to_csv(OUTPUT_FILE)
    print(f"Saved OHLCV data to {OUTPUT_FILE}")
    print(ohlcv.tail())

if __name__ == "__main__":
    aggregate_ohlcv()
