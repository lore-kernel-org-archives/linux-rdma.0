From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V3] infiniband-diags/src/ibqueryerrors: Add clear errors and
 counters options
Date: Wed, 30 Sep 2009 09:42:44 -0700
Message-ID: <20090930094244.29b55e3b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The only difference is that this now applies to the current master.

There were a couple of changes you made to the previous patches I submitted so I thought I would make it easy on you and send a version which applies cleanly.

Thanks,
Ira

From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 24 Sep 2009 20:39:29 -0700
Subject: [PATCH] infiniband-diags/src/ibqueryerrors: Add clear errors and counters options

	V2 add check for XMT_WAIT support on clear

	Add -k and -K options to clear errors and counters.  If both are
	specified they will both be cleared.

	Update man page

	In addition fix 2 bugs
	fix the printing of Xmt Wait errors
	properly skip the counter select field.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/man/ibqueryerrors.8 |   20 +++++--
 infiniband-diags/src/ibqueryerrors.c |   94 ++++++++++++++++++++++++++++++----
 2 files changed, 97 insertions(+), 17 deletions(-)

diff --git a/infiniband-diags/man/ibqueryerrors.8 b/infiniband-diags/man/ibqueryerrors.8
index a85082c..1352246 100644
--- a/infiniband-diags/man/ibqueryerrors.8
+++ b/infiniband-diags/man/ibqueryerrors.8
@@ -6,15 +6,14 @@ ibqueryerrors.pl \- query and report non-zero IB port counters
 .SH SYNOPSIS
 .B ibqueryerrors.pl
 [-s <err1,err2,...> -c -r -C <ca_name> -P <ca_port> -G <node_guid>
--D <direct_route> -d]
+-D <direct_route> -d -k -K]
 
 .SH DESCRIPTION
 .PP
-ibqueryerrors.pl reports the port counters of switches.  This is similar to
-ibcheckerrors with the additional ability to filter out selected errors,
-include the optional transmit and receive data counters, report actions to
-remedy a non-zero count, and report full link information for the link
-reported.
+ibqueryerrors.pl reports port counters.  This is similar to ibcheckerrors with
+the additional ability to filter out selected errors, include the optional
+transmit and receive data counters, and report full link information for the
+link reported.
 
 .SH OPTIONS
 
@@ -50,6 +49,15 @@ Include the optional transmit and receive data counters.
 .TP
 \fB\-\-router\fR  print data for routers only
 .TP
+\fB\-\-clear\-errors\fR \fB\-k\fR Clear error counters after read.
+\-k and \-K can be used together to clear both errors and counters.
+.TP
+\fB\-\-clear\-counts\fR \fB\-K\fR Clear data counters after read.
+\fBCAUTION\fR clearing data counters will occur regardless of if they are
+printed or not.  This is because data counters are only \fBprinted\fR on ports
+which have errors.  This means if a port has 0 errors and the \-K option is
+specified the data counters will be cleared without any printed output.
+.TP
 \fB\-R\fR  (This option is obsolete and does nothing)
 
 .SH COMMON OPTIONS
diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index e67d338..9ae41ee 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -65,6 +65,8 @@ int sup_total = 0;
 enum MAD_FIELDS *suppressed_fields = NULL;
 char *dr_path = NULL;
 uint8_t node_type_to_print = 0;
+int clear_errors = 0;
+int clear_counts = 0;
 
 #define PRINT_SWITCH 0x1
 #define PRINT_CA     0x2
@@ -222,6 +224,10 @@ static void print_results(ibnd_node_t * node, uint8_t * pc, int portnum,
 		if (suppress(i))
 			continue;
 
+		/* this is not a counter, skip it */
+		if (i == IB_PC_COUNTER_SELECT2_F)
+			continue;
+
 		mad_decode_field(pc, i, (void *)&val);
 		if (val)
 			n += snprintf(str + n, 1024 - n, " [%s == %d]",
@@ -232,7 +238,7 @@ static void print_results(ibnd_node_t * node, uint8_t * pc, int portnum,
 		mad_decode_field(pc, IB_PC_XMT_WAIT_F, (void *)&val);
 		if (val)
 			n += snprintf(str + n, 1024 - n, " [%s == %d]",
-				      mad_field_name(i), val);
+				      mad_field_name(IB_PC_XMT_WAIT_F), val);
 	}
 
 	/* if we found errors. */
@@ -264,13 +270,11 @@ static void print_results(ibnd_node_t * node, uint8_t * pc, int portnum,
 	}
 }
 
-static void print_port(ibnd_node_t * node, int portnum, int *header_printed)
+static int query_cap_mask(ibnd_node_t * node, int portnum, uint16_t * cap_mask)
 {
 	uint8_t pc[1024];
-	uint16_t cap_mask;
+	uint16_t rc_cap_mask;
 	ib_portid_t portid = { 0 };
-	char *nodename =
-	    remap_node_name(node_name_map, node->guid, node->nodedesc);
 
 	if (node->type == IB_NODE_SWITCH)
 		ib_portid_set(&portid, node->smalid, 0, 0);
@@ -281,16 +285,31 @@ static void print_port(ibnd_node_t * node, int portnum, int *header_printed)
 	if (!pma_query_via(pc, &portid, portnum, ibd_timeout, CLASS_PORT_INFO,
 			   ibmad_port)) {
 		IBWARN("classportinfo query failed on %s, %s port %d",
-		       nodename, portid2str(&portid), portnum);
-		goto cleanup;
+		       remap_node_name(node_name_map, node->guid,
+		       node->nodedesc), portid2str(&portid), portnum);
+		return (-1);
 	}
+
 	/* ClassPortInfo should be supported as part of libibmad */
-	memcpy(&cap_mask, pc + 2, sizeof(cap_mask));	/* CapabilityMask */
+	memcpy(&rc_cap_mask, pc + 2, sizeof(rc_cap_mask));	/* CapabilityMask */
+
+	*cap_mask = ntohs(rc_cap_mask);
+	return (0);
+}
+
+static void print_port(ib_portid_t * portid, uint16_t cap_mask,
+		       ibnd_node_t * node, int portnum, int *header_printed)
+{
+	uint8_t pc[1024];
+	char *nodename =
+	    remap_node_name(node_name_map, node->guid, node->nodedesc);
+
+	memset(pc, 0, 1024);
 
-	if (!pma_query_via(pc, &portid, portnum, ibd_timeout,
+	if (!pma_query_via(pc, portid, portnum, ibd_timeout,
 			   IB_GSI_PORT_COUNTERS, ibmad_port)) {
 		IBWARN("IB_GSI_PORT_COUNTERS query failed on %s, %s port %d\n",
-		       nodename, portid2str(&portid), portnum);
+		nodename, portid2str(portid), portnum);
 		goto cleanup;
 	}
 	if (!(cap_mask & 0x1000)) {
@@ -304,12 +323,41 @@ cleanup:
 	free(nodename);
 }
 
+static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
+			      ibnd_node_t * node, int port)
+{
+	uint8_t pc[1024];
+	/* bits defined in Table 228 PortCounters CounterSelect and
+	 * CounterSelect2
+	 */
+	uint32_t mask = 0;
+
+	if (!clear_errors && !clear_counts)
+		return;
+
+	if (clear_errors) {
+		mask |= 0xFFF;
+		if (cap_mask & 0x1000)
+			mask |= 0x10000;
+	}
+	if (clear_counts)
+		mask |= 0xF000;
+
+	if (!performance_reset_via(pc, portid, port, mask, ibd_timeout,
+				   IB_GSI_PORT_COUNTERS, ibmad_port))
+		IBERROR("Failed to reset errors %s port %d",
+			node->nodedesc, port);
+}
+
 void print_node(ibnd_node_t * node, void *user_data)
 {
 	int header_printed = 0;
 	int p = 0;
 	int startport = 1;
 	int type = 0;
+	int all_port_sup = 0;
+	ib_portid_t portid = { 0 };
+	uint16_t cap_mask = 0;
 
 	switch (node->type) {
 	case IB_NODE_SWITCH:
@@ -331,9 +379,25 @@ void print_node(ibnd_node_t * node, void *user_data)
 
 	for (p = startport; p <= node->numports; p++) {
 		if (node->ports[p]) {
-			print_port(node, p, &header_printed);
+			if (query_cap_mask(node, p, &cap_mask) < 0)
+				continue;
+
+			if (cap_mask & 0x100)
+				all_port_sup = 1;
+
+			if (node->type == IB_NODE_SWITCH)
+				ib_portid_set(&portid, node->smalid, 0, 0);
+			else
+				ib_portid_set(&portid, node->ports[p]->base_lid, 0, 0);
+
+			print_port(&portid, cap_mask, node, p, &header_printed);
+			if (!all_port_sup)
+				clear_port(&portid, cap_mask, node, p);
 		}
 	}
+
+	if (all_port_sup)
+		clear_port(&portid, cap_mask, node, 0xFF);
 }
 
 static void add_suppressed(enum MAD_FIELDS field)
@@ -400,6 +464,12 @@ static int process_opt(void *context, int ch, char *optarg)
 		break;
 	case 'R':		/* nop */
 		break;
+	case 'k':
+		clear_errors = 1;
+		break;
+	case 'K':
+		clear_counts = 1;
+		break;
 	default:
 		return -1;
 	}
@@ -437,6 +507,8 @@ int main(int argc, char **argv)
 		{"switch", 3, 0, NULL, "print data for switches only"},
 		{"ca", 4, 0, NULL, "print data for CA's only"},
 		{"router", 5, 0, NULL, "print data for routers only"},
+		{"clear-errors", 'k', 0, NULL, "Clear error counters after read"},
+		{"clear-counts", 'K', 0, NULL, "Clear data counters after read"},
 		{0}
 	};
 	char usage_args[] = "";
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
