import pandas as pd
import numpy as np
from collections import deque

INPUT_FILE = "ticks.csv"
OUTPUT_FILE = "flash_moves.csv"
WINDOW_SECONDS = 1
SIGMA_THRESHOLD = 3

def detect_flash_moves():
    df = pd.read_csv(INPUT_FILE, parse_dates=["timestamp"])
    df.sort_values("timestamp", inplace=True)

    prices = df["price"].values
    times = df["timestamp"].values

    moves = []
    window = deque()

    for i in range(1, len(prices)):
        dt = (pd.to_datetime(times[i]) - pd.to_datetime(times[i-1])).total_seconds()
        if dt > WINDOW_SECONDS:
            continue

        pct_move = (prices[i] - prices[i-1]) / prices[i-1]
        window.append(pct_move)
        if len(window) > 100:
            window.popleft()

        if len(window) >= 30:
            std = np.std(window)
            if std > 0 and abs(pct_move) > SIGMA_THRESHOLD * std:
                moves.append({
                    "timestamp": times[i],
                    "percent_change": round(pct_move * 100, 4)
                })

    df_out = pd.DataFrame(moves)
    df_out.to_csv(OUTPUT_FILE, index=False)
    print(f"Total Flash Moves: {len(df_out)}")

if __name__ == "__main__":
    detect_flash_moves()
