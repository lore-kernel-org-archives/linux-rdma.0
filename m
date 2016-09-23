From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 07/13] Pass ancillary files that use paths through cmake substitution
Date: Fri, 23 Sep 2016 13:17:02 -0600
Message-ID: <1474658228-5390-8-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This removes hardwired paths from the documentation and broadly
makes the documentation and scripts match what the C code is now
doing.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/CMakeLists.txt                                      | 2 +-
 ibacm/ibacm.init.in                                       | 2 +-
 ibacm/man/{ibacm_prov.7 => ibacm_prov.7.in}               | 4 ++--
 iwpmd/CMakeLists.txt                                      | 4 ++--
 iwpmd/{iwpmd.1 => iwpmd.1.in}                             | 2 +-
 iwpmd/{iwpmd.conf.5 => iwpmd.conf.5.in}                   | 2 +-
 srp_daemon/man/CMakeLists.txt                             | 2 +-
 srp_daemon/man/{srp_daemon.1 => srp_daemon.1.in}          | 8 ++++----
 srp_daemon/srp_daemon/CMakeLists.txt                      | 4 +++-
 srp_daemon/srp_daemon/{srp_daemon.sh => srp_daemon.sh.in} | 4 ++--
 srp_daemon/srp_daemon/srpd.in                             | 6 +++---
 11 files changed, 21 insertions(+), 19 deletions(-)
 rename ibacm/man/{ibacm_prov.7 => ibacm_prov.7.in} (95%)
 rename iwpmd/{iwpmd.1 => iwpmd.1.in} (98%)
 rename iwpmd/{iwpmd.conf.5 => iwpmd.conf.5.in} (92%)
 rename srp_daemon/man/{srp_daemon.1 => srp_daemon.1.in} (90%)
 rename srp_daemon/srp_daemon/{srp_daemon.sh => srp_daemon.sh.in} (95%)

diff --git a/ibacm/CMakeLists.txt b/ibacm/CMakeLists.txt
index 857a6e82320a..376a3a89ddae 100644
--- a/ibacm/CMakeLists.txt
+++ b/ibacm/CMakeLists.txt
@@ -52,7 +52,7 @@ rdma_man_pages(
   man/ib_acme.1
   man/ibacm.1
   man/ibacm.7
-  man/ibacm_prov.7
+  man/ibacm_prov.7.in
   )
 
 # FIXME: update the .init.in
diff --git a/ibacm/ibacm.init.in b/ibacm/ibacm.init.in
index aea262b6768a..0fb0011f3953 100644
--- a/ibacm/ibacm.init.in
+++ b/ibacm/ibacm.init.in
@@ -19,7 +19,7 @@
 #	host route lookups.
 ### END INIT INFO
 
-pidfile=/var/run/ibacm.pid
+pidfile=@CMAKE_INSTALL_FULL_RUNDIR@/ibacm.pid
 subsys=/var/lock/subsys/ibacm
 
 daemon() { /sbin/daemon   ${1+"$@"}; }
diff --git a/ibacm/man/ibacm_prov.7 b/ibacm/man/ibacm_prov.7.in
similarity index 95%
rename from ibacm/man/ibacm_prov.7
rename to ibacm/man/ibacm_prov.7.in
index d04617e837c8..9e79d58f639e 100644
--- a/ibacm/man/ibacm_prov.7
+++ b/ibacm/man/ibacm_prov.7.in
@@ -12,7 +12,7 @@ To add a provider to the ibacm core service, the provider must
 .TP
 1. be implemented as a shared library;
 .TP
-2. be installed under a configured directory, eg., /usr/lib64/ibacm/;
+2. be installed under a configured directory, eg., @ACM_PROVIDER_DIR@;
 .TP
 3  export a function provider_query() that returns a pointer to its provider info 
 and version info.
@@ -66,7 +66,7 @@ Non-related sections should be ignored.
 .P
 Some helper functions are also exported by the ibacm core. For example, the
 acm_log define (or the acm_write() function) can be used to log messages into
-ibacm's log file (default /var/log/ibacm.log).  For details, refer to
+ibacm's log file (default @CMAKE_INSTALL_FULL_LOCALSTATEDIR@/log/ibacm.log).  For details, refer to
 the acm_prov.h file.
 .SH "NOTES"
 A provider should always set the version in its provider info structure as the
diff --git a/iwpmd/CMakeLists.txt b/iwpmd/CMakeLists.txt
index 21208dd5b82a..89a715128076 100644
--- a/iwpmd/CMakeLists.txt
+++ b/iwpmd/CMakeLists.txt
@@ -1,4 +1,4 @@
 rdma_man_pages(
-  iwpmd.1
-  iwpmd.conf.5
+  iwpmd.1.in
+  iwpmd.conf.5.in
   )
diff --git a/iwpmd/iwpmd.1 b/iwpmd/iwpmd.1.in
similarity index 98%
rename from iwpmd/iwpmd.1
rename to iwpmd/iwpmd.1.in
index a4948c509f3b..88eece7f6522 100644
--- a/iwpmd/iwpmd.1
+++ b/iwpmd/iwpmd.1.in
@@ -51,6 +51,6 @@ to the system message log.
 .P
 SIGTERM/SIGHUP will force iwpmd to exit.
 .SH "FILES"
-/etc/iwpmd.conf
+@CMAKE_INSTALL_FULL_SYSCONFDIR@/iwpmd.conf
 .SH "SEE ALSO"
 rdma_cm(7)
diff --git a/iwpmd/iwpmd.conf.5 b/iwpmd/iwpmd.conf.5.in
similarity index 92%
rename from iwpmd/iwpmd.conf.5
rename to iwpmd/iwpmd.conf.5.in
index 9dfe137d3fab..1baae82b76da 100644
--- a/iwpmd/iwpmd.conf.5
+++ b/iwpmd/iwpmd.conf.5.in
@@ -15,6 +15,6 @@ to communicate with the kernel port map client.  The default is 400MB.
 .SH "EXAMPLES"
 nl_sock_rbuf_size=419430400
 .SH "FILES"
-/etc/iwpmd.conf
+@CMAKE_INSTALL_FULL_SYSCONFDIR@/iwpmd.conf
 .SH "SEE ALSO"
 iwpmd(1)
diff --git a/srp_daemon/man/CMakeLists.txt b/srp_daemon/man/CMakeLists.txt
index f05de60b97aa..cd644a6bd836 100644
--- a/srp_daemon/man/CMakeLists.txt
+++ b/srp_daemon/man/CMakeLists.txt
@@ -1,4 +1,4 @@
 rdma_man_pages(
   ibsrpdm.1
-  srp_daemon.1
+  srp_daemon.1.in
   )
diff --git a/srp_daemon/man/srp_daemon.1 b/srp_daemon/man/srp_daemon.1.in
similarity index 90%
rename from srp_daemon/man/srp_daemon.1
rename to srp_daemon/man/srp_daemon.1.in
index 6117e3679a25..6ee114284780 100644
--- a/srp_daemon/man/srp_daemon.1
+++ b/srp_daemon/man/srp_daemon.1.in
@@ -15,7 +15,7 @@ Each srp_daemon instance operates on one local port. Upon boot it performs a ful
 
 When a new machine joins the fabric, srp_daemon checks if it is a target. When there is a change of capabilities, srp_daemon checks if the machine has turned into a target. When there is an SA change or a timeout expiration, srp_daemon performs a full rescan of the fabric.
 
-For each target srp_daemon finds, it checks if it should connect to this target according to its rules (default rules file is /etc/srp_daemon.conf) and if it is already connected to the local port. If it should connect to this target and if it is not connected yet, srp_daemon can either print the target details or connect to it.
+For each target srp_daemon finds, it checks if it should connect to this target according to its rules (default rules file is @CMAKE_INSTALL_FULL_SYSCONFDIR@/srp_daemon.conf) and if it is already connected to the local port. If it should connect to this target and if it is not connected yet, srp_daemon can either print the target details or connect to it.
 
 .SH OPTIONS
 
@@ -57,7 +57,7 @@ Retries to connect to existing target after \fIretry-Timeout\fR seconds. If -R i
 .TP
 \fB\-f\fR \fIrules-File\fR
 Decide to which targets to connect according to the rules in \fIrules-File\fR. 
-If \fB\-f\fR is not specified, uses the default rules file /etc/srp_daemon.conf.
+If \fB\-f\fR is not specified, uses the default rules file @CMAKE_INSTALL_FULL_SYSCONFDIR@/srp_daemon.conf.
 Each line in the \fIrules-File\fR is a rule which can be either an allow connection or a disallow connection according to 
 the first character in the line (a or d accordingly). The rest of the line is values for id_ext, ioc_guid, dgid, 
 service_id. Please take a look at the example section for an example of the file. srp_daemon decide whether to allow or disallow each target according  to first rule that match the target. If no rule matches the target, the target is allowed and will be connected. In an allow rule it is possible to set attributes for the connection to the target. Supported attributes are max_cmd_per_lun and max_sect.
@@ -72,7 +72,7 @@ Perform \fIretries\fR retries on each send to MAD (default: 3 retries).
 New format - use also initiator_ext in the connection command.
 
 .SH FILES
-/etc/srp_daemon.conf -
+@CMAKE_INSTALL_FULL_SYSCONFDIR@/srp_daemon.conf -
 Default rules configuration file that indicates to which targets to connect. Can be overridden using the \fB\-f\fR \fIrules-File\fR option. 
 Each line in this file is a rule which can be either an allow connection or a disallow connection according to 
 the first character in the line (a or d accordingly). The rest of the line is values for id_ext, ioc_guid, dgid, 
@@ -86,7 +86,7 @@ srp_daemon -o -c -a		    (Prints the connection commands for the targets in the
 srp_daemon -e -f rules.txt	    (Connects to the targets allowed in the rules file rules.txt)
 
 .nf
-An example for a rules configuration file (such as /etc/srp_daemon.conf)
+An example for a rules configuration file (such as @CMAKE_INSTALL_FULL_SYSCONFDIR@/srp_daemon.conf)
 ------------------------------------------------------------------------
 # Rules file example
 # This is a comment
diff --git a/srp_daemon/srp_daemon/CMakeLists.txt b/srp_daemon/srp_daemon/CMakeLists.txt
index 84d74044186a..fe6b41811b92 100644
--- a/srp_daemon/srp_daemon/CMakeLists.txt
+++ b/srp_daemon/srp_daemon/CMakeLists.txt
@@ -15,7 +15,9 @@ target_link_libraries(srp_daemon
 rdma_install_symlink(srp_daemon "${CMAKE_INSTALL_SBINDIR}/ibsrpdm")
 # FIXME: Why?
 rdma_install_symlink(srp_daemon "${CMAKE_INSTALL_SBINDIR}/run_srp_daemon")
-install(FILES srp_daemon.sh DESTINATION "${CMAKE_INSTALL_SBINDIR}")
+rdma_subst_install(FILES "srp_daemon.sh.in"
+  DESTINATION "${CMAKE_INSTALL_SBINDIR}"
+  RENAME "srp_daemon.sh")
 
 install(FILES logrotate-srp_daemon DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/logrotate.d" RENAME "srp_daemon")
 install(FILES rsyslog-srp_daemon.conf DESTINATION "${CMAKE_INSTALL_SYSCONFDIR}/rsyslog.d" RENAME "srp_daemon.conf")
diff --git a/srp_daemon/srp_daemon/srp_daemon.sh b/srp_daemon/srp_daemon/srp_daemon.sh.in
similarity index 95%
rename from srp_daemon/srp_daemon/srp_daemon.sh
rename to srp_daemon/srp_daemon/srp_daemon.sh.in
index 3981a0d4b586..cb0b81efe6e6 100755
--- a/srp_daemon/srp_daemon/srp_daemon.sh
+++ b/srp_daemon/srp_daemon/srp_daemon.sh.in
@@ -30,12 +30,12 @@
 
 shopt -s nullglob
 
-prog=/usr/sbin/srp_daemon
+prog=@CMAKE_INSTALL_FULL_SBINDIR@/srp_daemon
 params=$@
 ibdir="/sys/class/infiniband"
 rescan_interval=60
 pids=""
-pidfile=/var/run/srp_daemon.sh.pid
+pidfile=@CMAKE_INSTALL_FULL_RUNDIR@/srp_daemon.sh.pid
 mypid=$$
 
 trap_handler()
diff --git a/srp_daemon/srp_daemon/srpd.in b/srp_daemon/srp_daemon/srpd.in
index 10692e7e0f05..d77579170a3b 100755
--- a/srp_daemon/srp_daemon/srpd.in
+++ b/srp_daemon/srp_daemon/srpd.in
@@ -4,7 +4,7 @@
 #
 # chkconfig: - 25 75
 # description: Starts/Stops InfiniBand SRP client service
-# config:	/etc/srp_daemon.conf
+# config:	@CMAKE_INSTALL_FULL_SYSCONFDIR@/srp_daemon.conf
 #
 ### BEGIN INIT INFO
 # Provides:       srpd
@@ -32,8 +32,8 @@ fi
 if [ -f $RDMA_CONFIG ]; then
     . $RDMA_CONFIG
 fi
-pidfile=/var/run/srp_daemon.sh.pid
-prog=/usr/sbin/srp_daemon.sh
+pidfile=@CMAKE_INSTALL_FULL_RUNDIR@/srp_daemon.sh.pid
+prog=@CMAKE_INSTALL_FULL_SBINDIR@/srp_daemon.sh
 
 checkpid() {
     [ -e "/proc/$1" ]
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
