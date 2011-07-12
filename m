From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] opensm: Add support for PID file
Date: Tue, 12 Jul 2011 16:27:40 -0700
Message-ID: <20110712162740.29e2d7d1.weiny2@llnl.gov>
References: <20110710120442.GA11284@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110710120442.GA11284-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aleksey Senin <alekseys-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I agree this is an issue.  However, usually the PID is generated from the
startup script so that only the PID which is started by it is stopped.

Specifically, think of the use case of starting multiple SM's on different
ports.  For example a local user may do this to manage 2 subnets from one
node.  Your patch will, by default, overwrite the PID file with each instance.
(yes --pid-file can be specified but this is not very standard.)

I think a better (and more standard) approach is to do the following (untested):

diff --git a/scripts/opensm.init.in b/scripts/opensm.init.in
index 0c84bd3..1e053c4 100644
--- a/scripts/opensm.init.in
+++ b/scripts/opensm.init.in
@@ -42,6 +42,8 @@

 prefix=@prefix@
 exec_prefix=@exec_prefix@
+piddir=@localstatedir@
+PIDFILE=${piddir}/opensm.pid

 # Source function library.
 if [[ -s /etc/init.d/functions ]]; then
@@ -62,7 +64,7 @@ fi

 start () {
     echo -n "Starting opensm: "
-    @sbindir@/opensm --daemon $OPTIONS > /dev/null
+    daemon --pidfile=$PIDFILE @sbindir@/opensm --daemon $OPTIONS > /dev/null
     if [[ $RETVAL -eq 0 ]]; then
         touch /var/lock/subsys/opensm
         success
@@ -74,7 +76,7 @@ start () {

 stop () {
     echo -n "Shutting down opensm: "
-    killproc opensm
+    killproc -p $PIDFILE opensm
     if [[ $RETVAL -eq 0 ]]; then
         rm -f /var/lock/subsys/opensm
         success
@@ -85,7 +87,8 @@ stop () {
 }

 Xstatus () {
-       pid="`pidof opensm`"
+       pid=`cat $PIDFILE`
+       ps -p $pid
        ret=$?
        if [ $ret -eq 0 ] ; then
                echo "OpenSM is running... pid=$pid"
@@ -117,11 +120,11 @@ case "$1" in
        [ -e /var/lock/subsys/opensm ] && restart
        ;;
     resweep)
-       killall -HUP opensm
+       kill -s 1 `cat $PIDFILE`
         RETVAL=$?
        ;;
     rotatelog)
-       killall -USR1 opensm
+       kill -s 10 `cat $PIDFILE`
         RETVAL=$?
        ;;
     *)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
