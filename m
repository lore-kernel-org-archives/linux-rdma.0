From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 11/13] srp_daemon: Add the debian initscripts as an option
Date: Fri, 23 Sep 2016 13:17:06 -0600
Message-ID: <1474658228-5390-12-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Necessary to reproduce the Debian packaging.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 CMakeLists.txt                       |  3 ++
 srp_daemon/srp_daemon/CMakeLists.txt | 29 ++++++++----
 srp_daemon/srptools.default          | 14 ++++++
 srp_daemon/srptools.init             | 89 ++++++++++++++++++++++++++++++++++++
 4 files changed, 126 insertions(+), 9 deletions(-)
 create mode 100644 srp_daemon/srptools.default
 create mode 100644 srp_daemon/srptools.init

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 7ae236f88f67..805b25bb8669 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -69,6 +69,9 @@ else()
   set(CMAKE_INSTALL_FULL_RUNDIR "${CMAKE_INSTALL_RUNDIR}")
 endif()
 
+set(DISTRO_FLAVOUR "None" CACHE
+  STRING "Flavour of distribution to install for. This primarily impacts the init.d scripts installed.")
+
 #-------------------------
 # Load CMake components
 set(BUILDLIB "${CMAKE_SOURCE_DIR}/buildlib")
diff --git a/srp_daemon/srp_daemon/CMakeLists.txt b/srp_daemon/srp_daemon/CMakeLists.txt
index fe6b41811b92..4ad4edaf8c33 100644
--- a/srp_daemon/srp_daemon/CMakeLists.txt
+++ b/srp_daemon/srp_daemon/CMakeLists.txt
@@ -23,12 +23,23 @@ install(FILES logrotate-srp_daemon DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/logr
 install(FILES rsyslog-srp_daemon.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/rsyslog.d" RENAME "srp_daemon.conf")
 install(FILES srp_daemon.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}")
 
-# FIXME: The ib init.d file should really be included in rdma-core as well.
-set(RDMA_SERVICE "openibd" CACHE STRING "init.d file service name to order srpd after")
-# NOTE: These defaults are for CentOS, packagers should override.
-set(SRP_DEFAULT_START "2 3 4 5" CACHE STRING "Default-Start service data for srpd")
-set(SRP_DEFAULT_STOP "0 1 6" CACHE STRING "Default-Stop service data for srpd")
-configure_file(srpd.in "${CMAKE_CURRENT_BINARY_DIR}/srpd")
-install(FILES "${CMAKE_CURRENT_BINARY_DIR}/srpd"
-  DESTINATION "${CMAKE_INSTALL_INITDDIR}"
-  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
+if ("${DISTRO_FLAVOUR}" STREQUAL "Debian")
+  # Debian version of the initscript system
+  install(FILES "srptools.init"
+    DESTINATION "${CMAKE_INSTALL_INITDDIR}"
+    RENAME "srptools"
+    PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
+  install(FILES "srptools.default"
+    DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/default/"
+    RENAME "srptools")
+else()
+  # FIXME: The ib init.d file should really be included in rdma-core as well.
+  set(RDMA_SERVICE "openibd" CACHE STRING "init.d file service name to order srpd after")
+  # NOTE: These defaults are for CentOS, packagers should override.
+  set(SRP_DEFAULT_START "2 3 4 5" CACHE STRING "Default-Start service data for srpd")
+  set(SRP_DEFAULT_STOP "0 1 6" CACHE STRING "Default-Stop service data for srpd")
+  configure_file(srpd.in "${CMAKE_CURRENT_BINARY_DIR}/srpd")
+  install(FILES "${CMAKE_CURRENT_BINARY_DIR}/srpd"
+    DESTINATION "${CMAKE_INSTALL_INITDDIR}"
+    PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
+endif()
diff --git a/srp_daemon/srptools.default b/srp_daemon/srptools.default
new file mode 100644
index 000000000000..81e84f4a5cba
--- /dev/null
+++ b/srp_daemon/srptools.default
@@ -0,0 +1,14 @@
+#How often should srpdeamon  rescan the fabric (seconds)
+RETRIES=60
+
+#Where should srp-deamon log to
+LOG=/var/log/srp_daemon.log
+
+# What ports should srp-deamon be started on.
+# Format is CA:port
+# ALL or NONE will run on all ports on none
+# respectively
+
+PORTS=NONE
+#PORTS=ALL
+#PORTS="mthca0:1 mlx4_0:2"
diff --git a/srp_daemon/srptools.init b/srp_daemon/srptools.init
new file mode 100644
index 000000000000..2c1a140ccbc3
--- /dev/null
+++ b/srp_daemon/srptools.init
@@ -0,0 +1,89 @@
+#!/bin/bash
+### BEGIN INIT INFO
+# Provides:          srptools
+# Required-Start:    $remote_fs $syslog
+# Required-Stop:     $remote_fs $syslog
+# Default-Start:     2 3 4 5
+# Default-Stop:      0 1 6
+# Short-Description: Discovers SRP scsi targets.
+# Description:       Discovers SRP scsi over infiniband targets.
+### END INIT INFO
+
+[ -x /usr/sbin/srp_daemon ] || exit 0
+
+IBDIR=/sys/class/infiniband
+
+PORTS=""
+RETRIES=""
+LOG=""
+
+[ -f /etc/default/srptools ] &&  . /etc/default/srptools
+
+start_daemon () {
+
+if [ "$PORTS" = "NONE" ] ; then
+echo "srptools disabled."
+exit 0
+fi
+
+
+if [ "$PORTS" = "ALL" ]  ; then
+    for HCA_ID in `/bin/ls -1 ${IBDIR}`
+      do
+      for PORT in `/bin/ls -1 ${IBDIR}/${HCA_ID}/ports/`
+        do
+        run_daemon
+      done
+    done
+fi
+
+
+for ADAPTER in $PORTS ; do
+    HCA_ID=`echo $ADAPTER | awk -F: '{print $1}'`
+    PORT=`echo $ADAPTER | awk -F:  '{print $2}'`
+    run_daemon
+done
+}
+
+
+run_daemon() {
+# SRP deamon wedges if we start it on a port which is not up
+
+        STATUS=`/usr/sbin/ibstat $HCA_ID $PORT | grep "State:"`
+
+        if [ "$STATUS" = "State: Active" ] ; then
+            echo "Starting srp on $HCA_ID $PORT"
+
+# srp does not background itself; using the start-stop-daemon background function
+# causes us to lose stdout, which is where it logs to
+            nohup start-stop-daemon --start --quiet -m --pidfile /var/run/srp_daemon.${HCA_ID}.${PORT} \
+            --exec  /usr/sbin/srp_daemon -- -e -c -n -i ${HCA_ID} -p ${PORT} -R ${RETRIES}   >> $LOG 2>&1 &
+            RETVAL=$?
+        fi
+}
+
+stop_daemon () {
+     for HCA_ID in `/bin/ls -1 ${IBDIR}`
+      do
+      for PORT in `/bin/ls -1 ${IBDIR}/${HCA_ID}/ports/`
+        do
+        start-stop-daemon --stop --quiet --oknodo -m --pidfile /var/run/srp_daemon.${HCA_ID}.${PORT}
+        RETVAL=$?
+      done
+    done
+}
+
+
+case "$1" in
+
+start)
+start_daemon
+;;
+stop)
+stop_daemon
+;;
+restart | reload | force-reload )
+stop_daemon
+start_daemon
+;;
+esac
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
