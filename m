From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] infiniband-diags/perfquery: Add support for optional
	PortRcvErrorDetails counter
Date: Thu, 31 Dec 2009 11:58:34 -0500
Message-ID: <20091231165834.GB9123@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/infiniband-diags/man/perfquery.8 b/infiniband-diags/man/perfquery.8
index 4510e7d..56615b9 100644
--- a/infiniband-diags/man/perfquery.8
+++ b/infiniband-diags/man/perfquery.8
@@ -1,4 +1,4 @@
-.TH PERFQUERY 8 "September 21, 2009" "OpenIB" "OpenIB Diagnostics"
+.TH PERFQUERY 8 "Dec 31, 2009" "OpenIB" "OpenIB Diagnostics"
 
 .SH NAME
 perfquery \- query InfiniBand port counters
@@ -6,7 +6,7 @@ perfquery \- query InfiniBand port counters
 .SH SYNOPSIS
 .B perfquery
 [\-d(ebug)] [\-G(uid)] [\-x|\-\-extended] [\-X|\-\-xmtsl] [\-S|\-\-rcvsl]
-[\-D|\-\-xmtdisc]
+[\-D|\-\-xmtdisc] [\-E|\-\-rcverr]
 [-a(ll_ports)] [-l(oop_ports)] [-r(eset_after_read)] [-R(eset_only)]
 [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms] [\-V(ersion)] [\-h(elp)]
 [<lid|guid> [[port] [reset_mask]]]
@@ -42,6 +42,9 @@ show receive data SL counter. This is an optional counter for QoS.
 \fB\-D\fR, \fB\-\-xmtdisc\fR
 show transmit discard details. This is an optional counter.
 .TP
+\fB\-E\fR, \fB\-\-rcverr\fR
+show receive error details. This is an optional counter.
+.TP
 \fB\-a\fR, \fB\-\-all_ports\fR
 show aggregated counters for all ports of the destination lid
 or reset all counters for all ports.  If the destination lid
diff --git a/infiniband-diags/src/perfquery.c b/infiniband-diags/src/perfquery.c
index e659189..2a48c6f 100644
--- a/infiniband-diags/src/perfquery.c
+++ b/infiniband-diags/src/perfquery.c
@@ -344,7 +344,7 @@ static void reset_counters(int extended, int timeout, int mask,
 }
 
 static int reset, reset_only, all_ports, loop_ports, port, extended, xmt_sl,
-    rcv_sl, xmt_disc;
+    rcv_sl, xmt_disc, rcv_err;
 
 static void common_func(ib_portid_t *portid, int port_num, int mask,
 			unsigned query, unsigned reset,
@@ -390,6 +390,13 @@ static void xmt_disc_query(ib_portid_t * portid, int port, int mask)
 		    mad_dump_perfcounters_xmt_disc);
 }
 
+static void rcv_err_query(ib_portid_t * portid, int port, int mask)
+{
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "PortRcvErrorDetails", IB_GSI_PORT_RCV_ERROR_DETAILS,
+		    mad_dump_perfcounters_rcv_err);
+}
+
 static int process_opt(void *context, int ch, char *optarg)
 {
 	switch (ch) {
@@ -405,6 +412,9 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 'D':
 		xmt_disc = 1;
 		break;
+	case 'E':
+		rcv_err = 1;
+		break;
 	case 'a':
 		all_ports++;
 		port = ALL_PORTS;
@@ -444,6 +454,7 @@ int main(int argc, char **argv)
 		{"xmtsl", 'X', 0, NULL, "show Xmt SL port counters"},
 		{"rcvsl", 'S', 0, NULL, "show Rcv SL port counters"},
 		{"xmtdisc", 'D', 0, NULL, "show Xmt Discard Details"},
+		{"rcverr", 'E', 0, NULL, "show Rcv Error Details"},
 		{"all_ports", 'a', 0, NULL, "show aggregated counters"},
 		{"loop_ports", 'l', 0, NULL, "iterate through each port"},
 		{"reset_after_read", 'r', 0, NULL, "reset counters after read"},
@@ -519,6 +530,11 @@ int main(int argc, char **argv)
 		goto done;
 	}
 
+	if (rcv_err) {
+		rcv_err_query(&portid, port, mask);
+		goto done;
+	}
+
 	if (all_ports_loop || (loop_ports && (all_ports || port == ALL_PORTS))) {
 		if (smp_query_via(data, &portid, IB_ATTR_NODE_INFO, 0, 0,
 				  srcport) < 0)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
