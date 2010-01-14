From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] infiniband-diags/perfquery: Add support for
	PortSamplesControl counter
Date: Thu, 14 Jan 2010 09:13:24 -0500
Message-ID: <20100114141324.GB12180@comcast.net>
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
index 56615b9..7e9636e 100644
--- a/infiniband-diags/man/perfquery.8
+++ b/infiniband-diags/man/perfquery.8
@@ -6,7 +6,7 @@ perfquery \- query InfiniBand port counters
 .SH SYNOPSIS
 .B perfquery
 [\-d(ebug)] [\-G(uid)] [\-x|\-\-extended] [\-X|\-\-xmtsl] [\-S|\-\-rcvsl]
-[\-D|\-\-xmtdisc] [\-E|\-\-rcverr]
+[\-D|\-\-xmtdisc] [\-E|\-\-rcverr] [\-c|\-\-smplctl]
 [-a(ll_ports)] [-l(oop_ports)] [-r(eset_after_read)] [-R(eset_only)]
 [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms] [\-V(ersion)] [\-h(elp)]
 [<lid|guid> [[port] [reset_mask]]]
@@ -45,6 +45,12 @@ show transmit discard details. This is an optional counter.
 \fB\-E\fR, \fB\-\-rcverr\fR
 show receive error details. This is an optional counter.
 .TP
+\fB\-D\fR, \fB\-\-xmtdisc\fR
+show transmit discard details. This is an optional counter.
+.TP
+\fB\-c\fR, \fB\-\-smplctl\fR
+show port samples control.
+.TP
 \fB\-a\fR, \fB\-\-all_ports\fR
 show aggregated counters for all ports of the destination lid
 or reset all counters for all ports.  If the destination lid
diff --git a/infiniband-diags/src/perfquery.c b/infiniband-diags/src/perfquery.c
index 2a48c6f..9937e30 100644
--- a/infiniband-diags/src/perfquery.c
+++ b/infiniband-diags/src/perfquery.c
@@ -344,7 +344,7 @@ static void reset_counters(int extended, int timeout, int mask,
 }
 
 static int reset, reset_only, all_ports, loop_ports, port, extended, xmt_sl,
-    rcv_sl, xmt_disc, rcv_err;
+    rcv_sl, xmt_disc, rcv_err, smpl_ctl;
 
 static void common_func(ib_portid_t *portid, int port_num, int mask,
 			unsigned query, unsigned reset,
@@ -397,6 +397,19 @@ static void rcv_err_query(ib_portid_t * portid, int port, int mask)
 		    mad_dump_perfcounters_rcv_err);
 }
 
+void dump_portsamples_control(ib_portid_t * portid, int port)
+{
+	char buf[1024];
+
+	if (!pma_query_via(pc, portid, port, ibd_timeout,
+			   IB_GSI_PORT_SAMPLES_CONTROL, srcport))
+		IBERROR("sampctlquery");
+
+	mad_dump_portsamples_control(buf, sizeof buf, pc, sizeof pc);
+	printf("# PortSamplesControl: %s port %d\n%s", portid2str(portid),
+	       port, buf);
+}
+
 static int process_opt(void *context, int ch, char *optarg)
 {
 	switch (ch) {
@@ -415,6 +428,9 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 'E':
 		rcv_err = 1;
 		break;
+	case 'c':
+		smpl_ctl = 1;
+		break;
 	case 'a':
 		all_ports++;
 		port = ALL_PORTS;
@@ -455,6 +471,7 @@ int main(int argc, char **argv)
 		{"rcvsl", 'S', 0, NULL, "show Rcv SL port counters"},
 		{"xmtdisc", 'D', 0, NULL, "show Xmt Discard Details"},
 		{"rcverr", 'E', 0, NULL, "show Rcv Error Details"},
+		{"smplctl", 'c', 0, NULL, "show samples control"},
 		{"all_ports", 'a', 0, NULL, "show aggregated counters"},
 		{"loop_ports", 'l', 0, NULL, "iterate through each port"},
 		{"reset_after_read", 'r', 0, NULL, "reset counters after read"},
@@ -535,6 +552,11 @@ int main(int argc, char **argv)
 		goto done;
 	}
 
+	if (smpl_ctl) {
+		dump_portsamples_control(&portid, port);
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
