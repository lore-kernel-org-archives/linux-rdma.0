From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH rdma-core 1/5] srp_daemon.sh: Improve robustness
Date: Mon, 15 May 2017 15:47:23 -0700
Message-ID: <20170515224733.29586-2-bart.vanassche@sandisk.com>
References: <20170515224733.29586-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170515224733.29586-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Surround expansions of shell variables that can contain spaces with
double quotes. Use arrays instead of a space-separated strings to
store lists to avoid that strings that contain whitespace get split
when iterating over a list.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 srp_daemon/srp_daemon.sh.in | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/srp_daemon/srp_daemon.sh.in b/srp_daemon/srp_daemon.sh.in
index cb0b81ef..75e8a31b 100755
--- a/srp_daemon/srp_daemon.sh.in
+++ b/srp_daemon/srp_daemon.sh.in
@@ -31,35 +31,35 @@
 shopt -s nullglob
 
 prog=@CMAKE_INSTALL_FULL_SBINDIR@/srp_daemon
-params=$@
+params=("$@")
 ibdir="/sys/class/infiniband"
 rescan_interval=60
-pids=""
-pidfile=@CMAKE_INSTALL_FULL_RUNDIR@/srp_daemon.sh.pid
+pids=()
+pidfile="@CMAKE_INSTALL_FULL_RUNDIR@/srp_daemon.sh.pid"
 mypid=$$
 
 trap_handler()
 {
-    if [ -n "$pids" ]; then
-        kill -15 $pids > /dev/null 2>&1
-        wait $pids
+    if [ "${#pids[@]}" ]; then
+        kill -15 "${pids[@]}" > /dev/null 2>&1
+        wait "${pids[@]}"
     fi
-    logger -i -t "$(basename $0)" "killing $prog."
-    /bin/rm -f $pidfile
+    logger -i -t "$(basename "$0")" "killing $prog."
+    /bin/rm -f "$pidfile"
     exit 0
 }
 
 # Check if there is another copy running of srp_daemon.sh
-if [ -f $pidfile ]; then
-    if [ -e /proc/$(cat $pidfile 2>/dev/null)/status ]; then
-        echo "$(basename $0) is already running. Exiting."
+if [ -f "$pidfile" ]; then
+    if [ -e "/proc/$(cat "$pidfile" 2>/dev/null)/status" ]; then
+        echo "$(basename "$0") is already running. Exiting."
         exit 1
     else
-        /bin/rm -f $pidfile
+        /bin/rm -f "$pidfile"
     fi
 fi
 
-if ! echo $mypid > $pidfile; then
+if ! echo $mypid > "$pidfile"; then
     echo "Creating $pidfile for pid $mypid failed"
     exit 1
 fi
@@ -72,12 +72,12 @@ do
 done
 
 for d in ${ibdir}_mad/umad*; do
-    hca_id="$(<$d/ibdev)"
-    port="$(<$d/port)"
+    hca_id="$(<"$d/ibdev")"
+    port="$(<"$d/port")"
     add_target="${ibdir}_srp/srp-${hca_id}-${port}/add_target"
     if [ -e "${add_target}" ]; then
-        ${prog} -e -c -n -i ${hca_id} -p ${port} -R ${rescan_interval} ${params} >/dev/null 2>&1 &
-        pids="$pids $!"
+        ${prog} -e -c -n -i "${hca_id}" -p "${port}" -R "${rescan_interval}" "${params[@]}" >/dev/null 2>&1 &
+        pids+=($!)
     fi
 done
 
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
