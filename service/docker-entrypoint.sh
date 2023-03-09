#!/bin/sh

shutdown() {
  echo "shutting down container"
  for _srv in $(ls -1 /etc/service); do
    sv force-stop $_srv
  done
  kill -HUP $RUNSVDIR
  wait $RUNSVDIR
  sleep 0.5
  for _pid  in $(ps -eo pid | grep -v PID  | tr -d ' ' | grep -v '^1$' | head -n -6); do
    timeout -t 5 /bin/sh -c "kill $_pid && wait $_pid || kill -9 $_pid"
  done
  exit
}
exec runsvdir -P /etc/service &
RUNSVDIR=$!
echo "Started runsvdir, PID is $RUNSVDIR"
echo "wait for processes to start...."
sleep 5
for _srv in $(ls -1 /etc/service); do
    sv status $_srv
done
trap shutdown SIGTERM SIGHUP SIGQUIT SIGINT
wait $RUNSVDIR

shutdown