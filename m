From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] opensm: update performance manager documentation
Date: Thu, 8 Nov 2012 08:22:37 -0800
Message-ID: <20121108082237.74d8a7fe8b310be6cbfd68a0@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 doc/performance-manager-HOWTO.txt |   35 ++++++++---------------------------
 1 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/doc/performance-manager-HOWTO.txt b/doc/performance-manager-HOWTO.txt
index 11f4185..7471c6f 100644
--- a/doc/performance-manager-HOWTO.txt
+++ b/doc/performance-manager-HOWTO.txt
@@ -45,23 +45,13 @@ Using the Performance Manager consists of 3 steps:
 Step 1: Compile in support for the Performance Manager
 ------------------------------------------------------
 
-Because of the performance manager's experimental status, it is not enabled at
-compile time by default.  (This will hopefully soon change as more people use
-it and confirm that it does not break things...  ;-)  The configure option is
-"--enable-perf-mgr".
-
 At this time it is really best to enable the console socket option as well.
-OpenSM can be run in an "interactive" mode.  But with the console socket option
-turned on one can also make a connection to a running OpenSM.  The console
-option is "--enable-console-socket".  This option requires the use of
-tcp_wrappers to ensure security.  Please be aware of your configuration for
-tcp_wrappers as the commands presented in the console can affect the operation
-of your subnet.
-
-The following configure line includes turning on the performance manager as
-well as the console:
-
-	./configure --enable-perf-mgr --enable-console-socket
+OpenSM can be run in an "interactive" mode.  But with the console socket
+option turned on one can also make a connection to a running OpenSM.  By
+default only "loopback" is enabled with the console with socket being a
+compile time option.  Regardless, please be aware of your network security
+configuration for as the commands presented in the console can affect the
+operation of your subnet.
 
 
 Step 2: Enable the perfmgr and console in opensm.conf
@@ -83,23 +73,14 @@ the opensm.conf config file.  (Default location is
 Also enable the console socket and configure the port for it to listen to if
 desired.
 
-	# console [off|local|socket]
+	# console [off|local|loopback]
 	console socket
 
 	# Telnet port for console (default 10000)
 	console_port 10000
 
-As noted above you also need to set up tcp_wrappers to prevent unauthorized
-users from connecting to the console.[*]
-
-	[*] As an alternate you can use the loopback mode but I noticed when
-	writing this (OpenSM v3.1.10; OFED 1.3) that there are some bugs in
-	specifying the loopback mode in the opensm.conf file.  Look for this to
-	be fixed in newer versions.
+	"local" is only useful if you run OpenSM in the foreground.
 
-	[**] Also you could use "local" but this is only useful if you run
-	OpenSM in the foreground of a terminal.  As OpenSM is usually started
-	as a daemon I left this out as an option.
 
 Step 3: retrieve data which has been collected
 ----------------------------------------------
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
