From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCHv2] infiniband-diags/ibqueryerrors: Add support for
	PortXmitDiscardDetails
Date: Wed, 4 Nov 2009 09:42:19 -0500
Message-ID: <20091104144219.GA7923@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


When --details selected, if PortCounters has transmit discards, then
query PortXmitDiscardDetails. On reset, if --details is selected, then
PortXmitDiscardDetails will also be reset.

Unfortunately, PortSamplesControl:OptionMask can't be trusted to determine
which PortXmitDiscardDetails counters are supported so an option was added
for this.

Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
Better description

diff --git a/infiniband-diags/man/ibqueryerrors.8 b/infiniband-diags/man/ibqueryerrors.8
index 1352246..d5a499e 100644
--- a/infiniband-diags/man/ibqueryerrors.8
+++ b/infiniband-diags/man/ibqueryerrors.8
@@ -1,4 +1,4 @@
-.TH IBQUERYERRORS 8 "Jan 24, 2008" "OpenIB" "OpenIB Diagnostics"
+.TH IBQUERYERRORS 8 "Oct 30, 2009" "OpenIB" "OpenIB Diagnostics"
 
 .SH NAME
 ibqueryerrors.pl \- query and report non-zero IB port counters
@@ -58,6 +58,8 @@ printed or not.  This is because data counters are only \fBprinted\fR on ports
 which have errors.  This means if a port has 0 errors and the \-K option is
 specified the data counters will be cleared without any printed output.
 .TP
+\fB\-\-details\fR include transmit discard details
+.TP
 \fB\-R\fR  (This option is obsolete and does nothing)
 
 .SH COMMON OPTIONS
diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index f83f29e..61a34e4 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
  * Copyright (c) 2007 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2008 Lawrence Livermore National Lab.  All rights reserved.
+ * Copyright (c) 2009 HNR Consulting.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -65,7 +66,7 @@ int sup_total = 0;
 enum MAD_FIELDS *suppressed_fields = NULL;
 char *dr_path = NULL;
 uint8_t node_type_to_print = 0;
-unsigned clear_errors = 0, clear_counts = 0;
+unsigned clear_errors = 0, clear_counts = 0, details = 0;
 
 #define PRINT_SWITCH 0x1
 #define PRINT_CA     0x2
@@ -273,10 +274,35 @@ static int query_cap_mask(ib_portid_t *portid, char *node_name, int portnum,
 	return 0;
 }
 
+static void print_xmitdisc_details(ibnd_node_t * node, char * node_name,
+				   uint8_t * pc, int portnum)
+{
+	char buf[1024];
+	char *str = buf;
+	uint32_t val = 0;
+	int n = 0;
+	int i = 0;
+
+	buf[0] = 0;
+	for (n = 0, i = IB_PC_XMT_INACT_DISC_F; i <= IB_PC_XMT_SW_HOL_DISC_F; i++) {
+		mad_decode_field(pc, i, (void *)&val);
+		if (val)
+			n += snprintf(str + n, 1024 - n, " [%s == %d]",
+				      mad_field_name(i), val);
+	}
+	if (n > 0) {
+		printf("   GUID 0x%" PRIx64 " port %d:%s\n", node->guid,
+		       portnum, str);
+		if (port_config)
+			print_port_config(node_name, node, portnum);
+	}
+}
+
 static void print_port(ib_portid_t * portid, uint16_t cap_mask, char *node_name,
 		       ibnd_node_t * node, int portnum, int *header_printed)
 {
 	uint8_t pc[1024];
+	uint32_t xmtdisc;
 
 	memset(pc, 0, 1024);
 
@@ -292,6 +318,19 @@ static void print_port(ib_portid_t * portid, uint16_t cap_mask, char *node_name,
 		mad_encode_field(pc, IB_PC_XMT_WAIT_F, &foo);
 	}
 	print_results(node_name, node, pc, portnum, header_printed);
+
+	/* If there are PortXmitDiscards, get details (if supported) */
+	mad_decode_field(pc, IB_PC_XMT_DISCARDS_F, &xmtdisc);
+	if (details && xmtdisc) {
+		if (!pma_query_via(pc, portid, portnum, ibd_timeout,
+				   IB_GSI_PORT_XMIT_DISCARD_DETAILS,
+				   ibmad_port)) {
+			IBWARN("IB_GSI_PORT_XMIT_DISCARD_DETAILS query failed on %s, %s port %d",
+			       node_name, portid2str(portid), portnum);
+			return;
+		}
+		print_xmitdisc_details(node, node_name, pc, portnum);
+	}
 }
 
 static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
@@ -318,6 +357,13 @@ static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
 				   IB_GSI_PORT_COUNTERS, ibmad_port))
 		IBERROR("Failed to reset errors %s port %d",
 			node_name, port);
+
+	if (details && clear_errors) {
+		mask = 0xF;
+		performance_reset_via(pc, portid, port, mask, ibd_timeout,
+				      IB_GSI_PORT_XMIT_DISCARD_DETAILS,
+				      ibmad_port);
+	}
 }
 
 void print_node(ibnd_node_t * node, void *user_data)
@@ -428,6 +474,9 @@ static int process_opt(void *context, int ch, char *optarg)
 	case 5:
 		node_type_to_print |= PRINT_ROUTER;
 		break;
+	case 6:
+		details = 1;
+		break;
 	case 'G':
 	case 'S':
 		node_guid_str = optarg;
@@ -484,6 +533,7 @@ int main(int argc, char **argv)
 		{"switch", 3, 0, NULL, "print data for switches only"},
 		{"ca", 4, 0, NULL, "print data for CA's only"},
 		{"router", 5, 0, NULL, "print data for routers only"},
+		{"details", 6, 0, NULL, "include transmit discard details"},
 		{"clear-errors", 'k', 0, NULL,
 		 "Clear error counters after read"},
 		{"clear-counts", 'K', 0, NULL,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
