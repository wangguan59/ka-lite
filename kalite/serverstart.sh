if [ -f "runwsgiserver.pid" ];
then
    pid=`cat runwsgiserver.pid`
    echo "(Warning: Web server may still be running; attempting to stop old process ($pid) first)"
    kill $pid 2> /dev/null
    rm runwsgiserver.pid
fi

pids=`ps -f -a | grep runwsgiserver | awk '{print $2}'`
if [ "$pids" ]; then
    echo "(Warning: Web server seems to have been started elsewhere; stopping all processes ($pids))"
    kill $pids
fi

echo "Running the web server on port 8008."
python manage.py runwsgiserver host=0.0.0.0 port=8008 threads=50 daemonize=true pidfile=runwsgiserver.pid
