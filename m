From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 3/4 for opensm] /etc/init.d/opensmd: Improve systemd integration
Date: Fri, 21 Sep 2012 16:44:20 +0200
Message-ID: <505C7D44.9060500@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On recent SLES and openSUSE systems it is necessary to read the
file /lib/lsb/init-functions instead of /etc/rc.status for proper
integration with systemd. Certain implementations of killproc
need a pidfile so make sure that one gets created. Also, correct
the opensm service dependency list.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 configure.in                  |    6 ++++++
 scripts/opensm.init.in        |   26 ++++++++++++++++++--------
 scripts/redhat-opensm.init.in |    2 ++
 3 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/configure.in b/configure.in
index f660a5b..4515ae2 100644
--- a/configure.in
+++ b/configure.in
@@ -11,6 +11,12 @@ AM_INIT_AUTOMAKE
 AC_SUBST(RELEASE, ${RELEASE:-unknown})
 AC_SUBST(TARBALL, ${TARBALL:-${PACKAGE}-${VERSION}.tar.gz})
 
+default_rdma_service=openibd
+AC_ARG_WITH([rdma_service],
+    AC_HELP_STRING([--with-rdma-service=name],
+                   [name of the RDMA service: "rdma" when using /etc/init.d/rdma to start RDMA services; "openibd" when using /etc/init.d/openibd to start RDMA services [default=${default_rdma_service}]]))
+AC_SUBST(RDMA_SERVICE, ${with_rdma_service:-${default_rdma_service}})
+
 if { rpm -q sles-release || rpm -q openSUSE-release; } >/dev/null 2>&1; then
    default_start="2 3 5"
    default_stop="0 1 4 6"
diff --git a/scripts/opensm.init.in b/scripts/opensm.init.in
index 007dae4..ddd1d6b 100644
--- a/scripts/opensm.init.in
+++ b/scripts/opensm.init.in
@@ -7,8 +7,8 @@
 #
 ### BEGIN INIT INFO
 # Provides: opensm
-# Required-Start: $syslog
-# Required-Stop:
+# Required-Start: $syslog @RDMA_SERVICE@
+# Required-Stop: $syslog @RDMA_SERVICE@
 # Default-Start: @DEFAULT_START@
 # Default-Stop: @DEFAULT_STOP@
 # Description:  Manage OpenSM
@@ -42,14 +42,22 @@
 
 prefix=@prefix@
 exec_prefix=@exec_prefix@
+pidfile=/var/run/opensm.pid
 
 # Source function library.
 if [[ -s /etc/init.d/functions ]]; then
+    # RHEL / CentOS / SL / Fedora.
     . /etc/init.d/functions
     rc_status() { :; }
     rc_exit() { exit $RETVAL; }
-fi
-if [[ -s /etc/rc.status ]]; then
+elif [[ -s /lib/lsb/init-functions ]]; then
+    # SLES / openSuSE / Debian.
+    . /lib/lsb/init-functions
+    rc_exit() { exit $RETVAL; }
+    success() { log_success_msg; }
+    failure() { log_failure_msg; }
+elif [[ -s /etc/rc.status ]]; then
+    # Older SuSE systems.
     . /etc/rc.status
     failure() { rc_status -v; }
     success() { rc_status -v; }
@@ -61,10 +69,13 @@ if [[ -s $CONFIG ]]; then
 fi
 
 start () {
+    if [ -e $pidfile ]; then
+	echo Already started
+	return 1
+    fi
     echo -n "Starting opensm: "
-    @sbindir@/opensm --daemon $OPTIONS > /dev/null
+    @sbindir@/opensm --daemon --pidfile $pidfile $OPTIONS > /dev/null
     if [[ $RETVAL -eq 0 ]]; then
-        touch /var/lock/subsys/opensm
         success
     else
         failure
@@ -76,7 +87,6 @@ stop () {
     echo -n "Shutting down opensm: "
     killproc opensm
     if [[ $RETVAL -eq 0 ]]; then
-        rm -f /var/lock/subsys/opensm
         success
     else
         failure
@@ -114,7 +124,7 @@ case "$1" in
 	restart
 	;;
     try-restart | condrestart)
-	[ -e /var/lock/subsys/opensm ] && restart
+	[ -e $pidfile ] && restart
 	;;
     resweep)
 	killall -HUP opensm
diff --git a/scripts/redhat-opensm.init.in b/scripts/redhat-opensm.init.in
index bea0f0d..415ab2f 100755
--- a/scripts/redhat-opensm.init.in
+++ b/scripts/redhat-opensm.init.in
@@ -7,6 +7,8 @@
 #
 ### BEGIN INIT INFO
 # Provides:       opensm
+# Required-Start: $syslog @RDMA_SERVICE@
+# Required-Stop: $syslog @RDMA_SERVICE@
 # Default-Start: @DEFAULT_START@
 # Default-Stop: @DEFAULT_STOP@
 # Description:  Manage OpenSM
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
