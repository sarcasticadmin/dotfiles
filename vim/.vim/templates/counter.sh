# Simple counter with timout
MAX_CHECK=5
SLEEP_INTERVAL=2
COUNT=0
while true; do
  if [ $COUNT -gt $MAX_CHECK ]; then
    echo "[FAILED] Timed out"
    exit 1
  fi
  echo "Count is at: ${COUNT}" 
  sleep ${SLEEP_INTERVAL}
  let COUNT=COUNT+1
done
