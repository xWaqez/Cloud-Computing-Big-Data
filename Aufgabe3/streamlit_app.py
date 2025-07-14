import streamlit as st
import subprocess
import pandas as pd
import os

st.set_page_config(page_title="Crypto Tick Analytics", layout="wide")
st.title("📈 Crypto Tick Analytics – Binance BTC/USDT")

TICK_FILE = "ticks.csv"
OHLCV_FILE = "ohlcv.csv"

st.sidebar.header("Aktionen")

# Buttons to run the scripts
if st.sidebar.button("🚀 Starte Tick-Sammlung"):
    with st.spinner("Starte tick_collector.py ..."):
        subprocess.Popen(["python", "tick_collector.py"])
    st.success("Tick-Collector gestartet (läuft im Hintergrund).")

if st.sidebar.button("📊 Aggregiere OHLCV"):
    with st.spinner("Berechne OHLCV aus Ticks..."):
        subprocess.run(["python", "ohlcv_aggregator.py"])
    st.success("OHLCV-Daten gespeichert.")

if st.sidebar.button("⚡ Erkenne Flash-Moves"):
    with st.spinner("Analysiere auf Flash-Moves..."):
        subprocess.run(["python", "volatility_detector.py"])
    st.success("Analyse abgeschlossen – siehe Konsole.")

# Display tick data
st.subheader("📉 Letzte Tickdaten")
if os.path.exists(TICK_FILE):
    df = pd.read_csv(TICK_FILE)
    st.dataframe(df.tail(10))
else:
    st.info("Noch keine Tickdaten vorhanden.")

# Display OHLCV chart
st.subheader("🕯️ OHLCV-Chart (1-min Aggregat)")
if os.path.exists(OHLCV_FILE):
    df_ohlcv = pd.read_csv(OHLCV_FILE, parse_dates=["timestamp"])
    st.line_chart(df_ohlcv.set_index("timestamp")[["open", "high", "low", "close"]])
    st.bar_chart(df_ohlcv.set_index("timestamp")[["volume"]])
else:
    st.info("Noch keine OHLCV-Daten verfügbar. Bitte aggregiere zuerst.")
