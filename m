From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH] Correct option names in opensm man page
Date: Thu, 20 Sep 2012 18:27:57 +0200
Message-ID: <505B440D.3010000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Long options have to be preceded by a double dash instead of a single.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 man/opensm.8.in |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/man/opensm.8.in b/man/opensm.8.in
index 79ff6a5..4e61c2e 100644
--- a/man/opensm.8.in
+++ b/man/opensm.8.in
@@ -11,7 +11,7 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
 [\-g(uid) <GUID in hex>]
 [\-l(mc) <LMC>]
 [\-p(riority) <PRIORITY>]
-[\-smkey <SM_Key>]
+[\-\-smkey <SM_Key>]
 [\-\-sm_sl <SL number>]
 [\-r(eassign_lids)]
 [\-R <engine name(s)> | \-\-routing_engine <engine name(s)>]
@@ -34,9 +34,9 @@ opensm \- InfiniBand subnet manager and administration (SM/SA)
 [\-s(weep) <interval>]
 [\-t(imeout) <milliseconds>]
 [\-\-retries <number>]
-[\-maxsmps <number>]
-[\-console [off | local | socket | loopback]]
-[\-console-port <port>]
+[\-\-maxsmps <number>]
+[\-\-console [off | local | socket | loopback]]
+[\-\-console-port <port>]
 [\-i(gnore-guids) <equalize-ignore-guids-file>]
 [\-w | \-\-hop_weights_file <path to file>]
 [\-O | \-\-port_search_ordering_file <path to file>]
@@ -134,7 +134,7 @@ This will effect the handover cases, where master
 is chosen by priority and GUID.  Range goes from 0
 (default and lowest priority) to 15 (highest).
 .TP
-\fB\-smkey\fR <SM_Key value>
+\fB\-\-smkey\fR <SM_Key value>
 This option specifies the SM\'s SM_Key (64 bits).
 This will effect SM authentication.
 Note that OpenSM version 3.2.1 and below used the default value '1'
@@ -263,15 +263,15 @@ for transactions.
 Without --retries, OpenSM defaults to 3 retries
 for transactions.
 .TP
-\fB\-maxsmps\fR <number>
+\fB\-\-maxsmps\fR <number>
 This option specifies the number of VL15 SMP MADs
 allowed on the wire at any one time.
-Specifying -maxsmps 0 allows unlimited outstanding
+Specifying \-\-maxsmps 0 allows unlimited outstanding
 SMPs.
-Without -maxsmps, OpenSM defaults to a maximum of
+Without \-\-maxsmps, OpenSM defaults to a maximum of
 4 outstanding SMPs.
 .TP
-\fB\-console [off | local | loopback | socket]\fR
+\fB\-\-console [off | local | loopback | socket]\fR
 This option brings up the OpenSM console (default off).  Note, loopback and
 socket open a socket which can be connected to WITHOUT CREDENTIALS.  Loopback
 is safer if access to your SM host is controlled.  tcp_wrappers
@@ -279,12 +279,12 @@ is safer if access to your SM host is controlled.  tcp_wrappers
 will only be available if OpenSM was built with --enable-console-loopback
 (default yes) and --enable-console-socket (default no) respectively.
 .TP
-\fB\-console-port\fR <port>
+\fB\-\-console-port\fR <port>
 Specify an alternate telnet port for the socket console (default 10000).
 Note that this option only appears if OpenSM was built with
 --enable-console-socket.
 .TP
-\fB\-i\fR, \fB\-ignore-guids\fR <equalize-ignore-guids-file>
+\fB\-i\fR, \fB\-\-ignore-guids\fR <equalize-ignore-guids-file>
 This option provides the means to define a set of ports
 (by node guid and port number) that will be ignored by the link load
 equalization algorithm.
@@ -320,7 +320,7 @@ listed on a line are assigned to the remaining dimensions, in port
 order.  Anything after a # is a comment.
 .TP
 \fB\-O\fR, \fB\-\-dimn_ports_file\fR <path to file> \fB(DEPRECATED)\fR
-This is a deprecated flag. Please use \fB-port_search_ordering_file\fR instead.
+This is a deprecated flag. Please use \fB\-\-port_search_ordering_file\fR instead.
 This option provides a mapping between hypercube dimensions and ports
 on a per switch basis for the DOR routing engine.  The file consists
 of lines containing a switch node GUID (specified as a 64 bit hex
@@ -409,12 +409,12 @@ option can be used in conjunction with the perfmgr so as to
 run a standalone performance manager without SM/SA.  However,
 this is NOT currently implemented in the performance manager.
 .TP
-\fB\-perfmgr\fR
+\fB\-\-perfmgr\fR
 Enable the perfmgr.  Only takes effect if --enable-perfmgr was specified at
 configure time.  See performance-manager-HOWTO.txt in opensm doc for
 more information on running perfmgr.
 .TP
-\fB\-perfmgr_sweep_time_s\fR <seconds>
+\fB\-\-perfmgr_sweep_time_s\fR <seconds>
 Specify the sweep time for the performance manager in seconds
 (default is 180 seconds).  Only takes
 effect if --enable-perfmgr was specified at configure time.
@@ -962,7 +962,7 @@ port GUID. The latter is supplied by:
 
 -i <equalize-ignore-guids-file>
 .br
--ignore-guids <equalize-ignore-guids-file>
+\-\-ignore-guids <equalize-ignore-guids-file>
           This option provides the means to define a set of ports
           (by guid) that will be ignored by the link load
           equalization algorithm. Note that only endports (CA,
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
