import asyncio
import json
import websockets
import csv
from datetime import datetime

SYMBOL = "btcusdt"
WS_URL = f"wss://stream.binance.com:9443/ws/{SYMBOL}@trade"
OUTPUT_FILE = "ticks.csv"

async def collect_ticks():
    async with websockets.connect(WS_URL) as ws:
        print(f"Connected to Binance stream for {SYMBOL}")
        with open(OUTPUT_FILE, mode='w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(["timestamp", "price", "quantity"])

            while True:
                msg = await ws.recv()
                data = json.loads(msg)
                ts = datetime.utcfromtimestamp(data['T'] / 1000).isoformat()
                price = float(data['p'])
                quantity = float(data['q'])
                writer.writerow([ts, price, quantity])
                print(f"[{ts}] Price: {price}, Quantity: {quantity}")

if __name__ == "__main__":
    asyncio.run(collect_ticks())
