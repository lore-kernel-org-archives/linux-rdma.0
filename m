From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibqueryerrors: Add support for optional
	PortRcvErrorDetails counter
Date: Thu, 31 Dec 2009 14:10:54 -0500
Message-ID: <20091231191054.GA27874@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


to --details option

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
diff --git a/infiniband-diags/man/ibqueryerrors.8 b/infiniband-diags/man/ibqueryerrors.8
index 83a2b5a..e7feea8 100644
--- a/infiniband-diags/man/ibqueryerrors.8
+++ b/infiniband-diags/man/ibqueryerrors.8
@@ -1,4 +1,4 @@
-.TH IBQUERYERRORS 8 "Oct 30, 2009" "OpenIB" "OpenIB Diagnostics"
+.TH IBQUERYERRORS 8 "Dec 31, 2009" "OpenIB" "OpenIB Diagnostics"
 
 .SH NAME
 ibqueryerrors \- query and report non-zero IB port counters
@@ -58,7 +58,7 @@ printed or not.  This is because data counters are only \fBprinted\fR on ports
 which have errors.  This means if a port has 0 errors and the \-K option is
 specified the data counters will be cleared without any printed output.
 .TP
-\fB\-\-details\fR include transmit discard details
+\fB\-\-details\fR include receive error and transmit discard details
 .TP
 \fB\-R\fR  (This option is obsolete and does nothing)
 
diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index 47bd2af..ceacc58 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -205,24 +205,31 @@ static void report_suppressed(void)
 	printf("\n");
 }
 
-static int print_xmitdisc_details(char *buf, size_t size, ib_portid_t * portid,
-				  ibnd_node_t * node, char *node_name,
-				  int portnum)
+static int print_details(char *buf, size_t size, ib_portid_t * portid,
+			 ibnd_node_t * node, char *node_name, int portnum,
+			 int j)
 {
 	uint8_t pc[1024];
 	uint32_t val = 0;
 	int i, n;
 
+	if (j != IB_PC_ERR_RCV_F && j!= IB_PC_XMT_DISCARDS_F)
+		return 0;
+
 	memset(pc, 0, 1024);
 
 	if (!pma_query_via(pc, portid, portnum, ibd_timeout,
-			   IB_GSI_PORT_XMIT_DISCARD_DETAILS, ibmad_port)) {
-		IBWARN("IB_GSI_PORT_XMIT_DISCARD_DETAILS query failed on %s, "
-		       "%s port %d", node_name, portid2str(portid), portnum);
+			   (j == IB_PC_ERR_RCV_F ? IB_GSI_PORT_RCV_ERROR_DETAILS : IB_GSI_PORT_XMIT_DISCARD_DETAILS),
+			   ibmad_port)) {
+		IBWARN("%s query failed on %s, %s port %d",
+			(j == IB_PC_ERR_RCV_F ? "IB_GSI_PORT_RCV_ERROR_DETAILS" : "IB_GSI_PORT_XMIT_DISCARD_DETAILS"),
+			node_name, portid2str(portid), portnum);
 		return 0;
 	}
 
-	for (n = 0, i = IB_PC_XMT_INACT_DISC_F; i <= IB_PC_XMT_SW_HOL_DISC_F;
+	for (n = 0,
+	     i = (j == IB_PC_ERR_RCV_F ? IB_PC_RCV_LOCAL_PHY_ERR_F : IB_PC_XMT_INACT_DISC_F);
+	     i <= (j == IB_PC_ERR_RCV_F ? IB_PC_RCV_LOOPING_ERR_F : IB_PC_XMT_SW_HOL_DISC_F);
 	     i++) {
 		mad_decode_field(pc, i, (void *)&val);
 		if (val)
@@ -254,10 +261,14 @@ static void print_results(ib_portid_t * portid, char *node_name,
 			n += snprintf(str + n, 1024 - n, " [%s == %u]",
 				      mad_field_name(i), val);
 
+		/* If there are PortRcvErrors, get details (if supported) */
+		if (i == IB_PC_ERR_RCV_F && details && val) {
+			n += print_details(str + n, 1024 - n, portid,
+					   node, node_name, portnum, i);
 		/* If there are PortXmitDiscards, get details (if supported) */
-		if (i == IB_PC_XMT_DISCARDS_F && details && val) {
-			n += print_xmitdisc_details(str + n, 1024 - n, portid,
-						    node, node_name, portnum);
+		} else if (i == IB_PC_XMT_DISCARDS_F && details && val) {
+			n += print_details(str + n, 1024 - n, portid,
+					   node, node_name, portnum, i);
 		}
 	}
 
@@ -364,6 +375,10 @@ static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
 		performance_reset_via(pc, portid, port, mask, ibd_timeout,
 				      IB_GSI_PORT_XMIT_DISCARD_DETAILS,
 				      ibmad_port);
+		mask = 0x3F;
+		performance_reset_via(pc, portid, port, mask, ibd_timeout,
+				      IB_GSI_PORT_RCV_ERROR_DETAILS,
+				      ibmad_port);
 	}
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
