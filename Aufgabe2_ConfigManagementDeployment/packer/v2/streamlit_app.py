import streamlit as st
import subprocess
import pandas as pd
import os
import altair as alt

st.set_page_config(page_title="Crypto Tick Analytics", layout="wide")
st.title("📈 Crypto Tick Analytics – Binance BTC/USDT")

# Datei-Pfade
TICK_FILE = "ticks.csv"
OHLCV_FILE = "ohlcv.csv"
FLASH_FILE = "flash_moves.csv"

st.sidebar.header("Aktionen")

# Tick Collector starten
if st.sidebar.button("🚀 Starte Tick-Sammlung"):
    with st.spinner("Starte tick_collector.py ..."):
        subprocess.Popen(["python", "tick_collector.py"])
    st.success("Tick-Collector gestartet (läuft im Hintergrund).")

# OHLCV Aggregation
if st.sidebar.button("📊 Aggregiere OHLCV"):
    with st.spinner("Berechne OHLCV aus Ticks..."):
        subprocess.run(["python", "ohlcv_aggregator.py"])
    st.success("OHLCV-Daten gespeichert.")

# Flash-Move Detection
if st.sidebar.button("⚡ Erkenne Flash-Moves"):
    with st.spinner("Analysiere auf Flash-Moves..."):
        subprocess.run(["python", "volatility_detector.py"])
    st.success("Analyse abgeschlossen – siehe Konsole.")

# Tickdaten anzeigen
st.subheader("📉 Letzte Tickdaten")
if os.path.exists(TICK_FILE):
    df_ticks = pd.read_csv(TICK_FILE)
    st.dataframe(df_ticks.tail(10))
else:
    st.info("Noch keine Tickdaten vorhanden.")

# OHLCV-Chart anzeigen
st.subheader("🕯️ OHLCV-Chart")

if os.path.exists(OHLCV_FILE):
    df_ohlcv = pd.read_csv(OHLCV_FILE, parse_dates=["timestamp"])
    df_ohlcv.set_index("timestamp", inplace=True)

    df_ohlcv = df_ohlcv.resample("15S").agg({
        "open": "first",
        "high": "max",
        "low": "min",
        "close": "last",
        "volume": "sum"
    }).dropna().reset_index()

    # Werte für Preis-Chart vorbereiten
    df_melt = df_ohlcv.melt(
        id_vars=["timestamp"],
        value_vars=["open", "high", "low", "close"],
        var_name="Type",
        value_name="Price"
    )

    # Interaktives Zooming (x + y separat)
    zoom = alt.selection_interval(bind='scales')

    # Farben nach Typ
    farben = alt.Scale(
        domain=["open", "high", "low", "close"],
        range=["#888", "#1a9850", "#d73027", "#4575b4"]
    )

    # Preis-Chart
    chart = alt.Chart(df_melt).mark_line(interpolate='monotone', strokeWidth=2).encode(
        x=alt.X('timestamp:T', title='Zeit'),
        y=alt.Y('Price:Q', title='Preis (BTC/USDT)', scale=alt.Scale(nice=False)),
        color=alt.Color('Type:N', scale=farben),
        tooltip=['timestamp:T', 'Type:N', 'Price:Q']
    ).properties(
        width=900,
        height=400
    ).add_params(zoom)

    st.altair_chart(chart, use_container_width=True)

    # Optional: Volumen anzeigen
    st.subheader("📊 Handelsvolumen (15s Aggregat)")
    st.bar_chart(df_ohlcv.set_index("timestamp")[["volume"]])

else:
    st.info("Noch keine OHLCV-Daten verfügbar. Bitte zuerst aggregieren.")

# Flash-Move Events anzeigen
st.subheader("⚡ Flash-Move Events (3σ Regel)")

if os.path.exists(FLASH_FILE):
    df_flash = pd.read_csv(FLASH_FILE, parse_dates=["timestamp"])
    st.dataframe(df_flash.tail(20))

    st.line_chart(
        df_flash.set_index("timestamp")[["percent_change"]]
    )
else:
    st.info("Noch keine Flash-Move-Daten verfügbar. Bitte zuerst analysieren.")
