From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags/perfquery: Add support for extended link
 speeds
Date: Mon, 15 Aug 2011 20:37:15 -0400
Message-ID: <4E49BBBB.5070806@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


PortExtendedSpeedsCounters attribute

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/man/perfquery.8 b/man/perfquery.8
index 7acc60c..8635e41 100644
--- a/man/perfquery.8
+++ b/man/perfquery.8
@@ -1,4 +1,4 @@
-.TH PERFQUERY 8 "Jun 16, 2010" "OpenIB" "OpenIB Diagnostics"
+.TH PERFQUERY 8 "February 19, 2011" "OpenIB" "OpenIB Diagnostics"
 
 .SH NAME
 perfquery \- query InfiniBand port counters
@@ -6,7 +6,7 @@ perfquery \- query InfiniBand port counters
 .SH SYNOPSIS
 .B perfquery
 [\-d(ebug)] [\-G(uid)] [\-x|\-\-extended] [\-X|\-\-xmtsl] [\-S|\-\-rcvsl]
-[\-D|\-\-xmtdisc] [\-E|\-\-rcverr] [\-\-oprcvcounters] [\-\-flowctlcounters]
+[\-D|\-\-xmtdisc] [\-E|\-\-rcverr] [\-T|\-\-extended_speeds][\-\-oprcvcounters] [\-\-flowctlcounters]
 [\-\-vloppackets] [\-\-vlopdata] [\-\-vlxmitflowctlerrors] [\-\-vlxmitcounters]
 [\-\-swportvlcong] [\-\-rcvcc] [\-\-slrcvfecn] [\-\-slrcvbecn] [\-\-xmitcc]
 [\-\-vlxmittimecc] [\-c|\-\-smplctl] [-a(ll_ports)] [-l(oop_ports)]
@@ -17,7 +17,7 @@ perfquery \- query InfiniBand port counters
 .PP
 perfquery uses PerfMgt GMPs to obtain the PortCounters (basic performance
 and error counters), PortExtendedCounters, PortXmitDataSL, PortRcvDataSL,
-PortRcvErrorDetails, PortXmitDiscardDetails, or PortSamplesControl
+PortRcvErrorDetails, PortXmitDiscardDetails, PortExtendedSpeedsCounters, or PortSamplesControl
 from the PMA at the node/port specified. Optionally shows aggregated
 counters for all ports of node.
 Also, optionally, reset after read, or only reset counters.
@@ -51,6 +51,9 @@ show receive error details. This is an optional counter.
 \fB\-D\fR, \fB\-\-xmtdisc\fR
 show transmit discard details. This is an optional counter.
 .TP
+\fB\-T\fR, \fB\-\-extended_speeds\fR
+show extended speeds port counters. This is an optional counter.
+.TP
 \fB\-\-oprcvcounters\fR
 show Rcv Counters per Op code. This is an optional counter.
 .TP
diff --git a/src/perfquery.c b/src/perfquery.c
index 0ea68aa..0dbb80d 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -368,7 +368,7 @@ static void reset_counters(int extended, int timeout, int mask,
 }
 
 static int reset, reset_only, all_ports, loop_ports, port, extended, xmt_sl,
-    rcv_sl, xmt_disc, rcv_err, smpl_ctl, oprcvcounters, flowctlcounters,
+    rcv_sl, xmt_disc, rcv_err, extended_speeds, smpl_ctl, oprcvcounters, flowctlcounters,
     vloppackets, vlopdata, vlxmitflowctlerrors, vlxmitcounters, swportvlcong,
     rcvcc, slrcvfecn, slrcvbecn, xmitcc, vlxmittimecc;
 
@@ -425,6 +425,14 @@ static void rcv_err_query(ib_portid_t * portid, int port, int mask)
 		    mad_dump_perfcounters_rcv_err);
 }
 
+static void extended_speeds_query(ib_portid_t * portid, int port, int mask)
+{
+	common_func(portid, port, mask, !reset_only, (reset_only || reset),
+		    "PortExtendedSpeedsCounters",
+		    IB_GSI_PORT_EXT_SPEEDS_COUNTERS,
+		    mad_dump_port_ext_speeds_counters);
+}
+
 static void oprcvcounters_query(ib_portid_t * portid, int port, int mask)
 {
 	common_func(portid, port, mask, !reset_only, (reset_only || reset),
@@ -541,6 +549,9 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 'E':
 		rcv_err = 1;
 		break;
+	case 'T':
+		extended_speeds = 1;
+		break;
 	case 'c':
 		smpl_ctl = 1;
 		break;
@@ -620,6 +631,7 @@ int main(int argc, char **argv)
 		{"rcvsl", 'S', 0, NULL, "show Rcv SL port counters"},
 		{"xmtdisc", 'D', 0, NULL, "show Xmt Discard Details"},
 		{"rcverr", 'E', 0, NULL, "show Rcv Error Details"},
+		{"extended_speeds", 'T', 0, NULL, "show port extended speeds counters"},
 		{"oprcvcounters", 1, 0, NULL, "show Rcv Counters per Op code"},
 		{"flowctlcounters", 2, 0, NULL, "show flow control counters"},
 		{"vloppackets", 3, 0, NULL, "show packets received per Op code per VL"},
@@ -713,6 +725,11 @@ int main(int argc, char **argv)
 		goto done;
 	}
 
+	if (extended_speeds) {
+		extended_speeds_query(&portid, port, mask);
+		goto done;
+	}
+
 	if (oprcvcounters) {
 		oprcvcounters_query(&portid, port, mask);
 		goto done;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
