import pandas as pd
import numpy as np
from collections import deque
from datetime import datetime

INPUT_FILE = "ticks.csv"
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
            if abs(pct_move) > SIGMA_THRESHOLD * std:
                print(f"⚡ FLASH MOVE detected at {times[i]}: {pct_move*100:.2f}%")
                moves.append((times[i], pct_move))

    print(f"Total Flash Moves: {len(moves)}")

if __name__ == "__main__":
    detect_flash_moves()
