From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags/src/ibqueryerrors.c: Remove --all option
 and replace it with --switch, --ca, --router
Date: Wed, 23 Sep 2009 15:09:23 -0700
Message-ID: <20090923150923.a5281107.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: OpenFabrics <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 23 Sep 2009 11:38:11 -0700
Subject: [PATCH] infiniband-diags/src/ibqueryerrors.c: Remove --all option and replace it with --switch, --ca, --router

	By default ibqueryerrors should print errors for all node types.
	Adding the other options allows for the limitation of this output.

	Also change the --switch option to be --node-guid which is really more
	accurate and use "-G" for better compliance with other utilities.  "-S"
	is left in for backward compatibility for the time being.

	Update the man page

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/man/ibqueryerrors.8 |   62 +++++++++++++++++++-----------
 infiniband-diags/src/ibqueryerrors.c |   70 +++++++++++++++++++++++++---------
 2 files changed, 92 insertions(+), 40 deletions(-)

diff --git a/infiniband-diags/man/ibqueryerrors.8 b/infiniband-diags/man/ibqueryerrors.8
index a327f3b..8f83a7b 100644
--- a/infiniband-diags/man/ibqueryerrors.8
+++ b/infiniband-diags/man/ibqueryerrors.8
@@ -5,7 +5,7 @@ ibqueryerrors.pl \- query and report non-zero IB port counters
 
 .SH SYNOPSIS
 .B ibqueryerrors.pl
-[-a -c -r -R -C <ca_name> -P <ca_port> -s <err1,err2,...> -S <switch_guid>
+[-s <err1,err2,...> -c -r -C <ca_name> -P <ca_port> -s <err1,err2,...> -G <node_guid>
 -D <direct_route> -d]
 
 .SH DESCRIPTION
@@ -20,41 +20,59 @@ reported.
 
 .PP
 .TP
-\fB\-a\fR
-Report an action to take.  Some of the counters are not errors in and of
-themselves.  This reports some more information on what the counters mean and
-what actions can/should be taken if they are non-zero.
+\fB\-s <err1,err2,...>\fR
+Suppress the errors listed in the comma separated list provided.
 .TP
 \fB\-c\fR
 Suppress some of the common "side effect" counters.  These counters usually do
 not indicate an error condition and can be usually be safely ignored.
 .TP
+\fB\-G <node_guid>\fR
+Report results only for the node guid specified.
+.TP
+\fB\-S <node_guid>\fR
+\-S is provided only for backward compatibility and works the same as "-G"
+.TP
+\fB\-D <direct_route>\fR
+Report results only for the switch specified by the direct route path.
+.TP
 \fB\-r\fR
 Report the port information.  This includes LID, port, external port (if
 applicable), link speed setting, remote GUID, remote port, remote external port
 (if applicable), and remote node description information.
 .TP
-\fB\-R\fR
-Recalculate the ibnetdiscover information, ie do not use the cached
-information.  This option is slower but should be used if the diag tools have
-not been used for some time or if there are other reasons to believe that
-the fabric has changed.
+\fB\-\-data\fR
+Include the optional transmit and receive data counters.
 .TP
-\fB\-s <err1,err2,...>\fR
-Suppress the errors listed in the comma separated list provided.
+\fB\-\-switch\fR  print data for switches only
 .TP
-\fB\-S <switch_guid>\fR
-Report results only for the switch specified. (hex format)
+\fB\-\-ca\fR  print data for CA's only
 .TP
-\fB\-D <direct_route>\fR
-Report results only for the switch specified by the direct route path.
+\fB\-\-router\fR  print data for routers only
 .TP
-\fB\-d\fR
-Include the optional transmit and receive data counters.
-.TP
-\fB\-C <ca_name>\fR    use the specified ca_name for the search.
-.TP
-\fB\-P <ca_port>\fR    use the specified ca_port for the search.
+\fB\-R\fR  (This option is obsolete and does nothing)
+
+.SH COMMON OPTIONS
+.PP
+\-d      raise the IB debugging level.
+        May be used several times (-ddd or -d -d -d).
+.PP
+\-e      show send and receive errors (timeouts and others)
+.PP
+\-h      show the usage message
+.PP
+\-v      increase the application verbosity level.
+        May be used several times (-vv or -v -v -v)
+.PP
+\-V      show the version info.
+
+# Other common flags:
+.PP
+\-C <ca_name>    use the specified ca_name.
+.PP
+\-P <ca_port>    use the specified ca_port.
+.PP
+\-t <timeout_ms> override the default timeout for the solicited mads.
 
 
 .SH AUTHOR
diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index f73ca6f..ecfd662 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -59,12 +59,17 @@ static char *node_name_map_file = NULL;
 static nn_map_t *node_name_map = NULL;
 int data_counters = 0;
 int port_config = 0;
-uint64_t switch_guid = 0;
-char *switch_guid_str = NULL;
+uint64_t node_guid = 0;
+char *node_guid_str = NULL;
 int sup_total = 0;
 enum MAD_FIELDS *suppressed_fields = NULL;
 char *dr_path = NULL;
-int all_nodes = 0;
+
+#define PRINT_ALL 0xFF /* all nodes default flag */
+uint8_t node_type_to_print = PRINT_ALL;
+#define PRINT_SWITCH 0x1
+#define PRINT_CA     0x2
+#define PRINT_ROUTER 0x4
 
 static unsigned int get_max(unsigned int num)
 {
@@ -304,8 +309,21 @@ void print_node(ibnd_node_t * node, void *user_data)
 	int header_printed = 0;
 	int p = 0;
 	int startport = 1;
+	int type = 0;
+
+	switch (node->type) {
+	case IB_NODE_SWITCH:
+		type = PRINT_SWITCH;
+		break;
+	case IB_NODE_CA:
+		type = PRINT_CA;
+		break;
+	case IB_NODE_ROUTER:
+		type = PRINT_ROUTER;
+		break;
+	}
 
-	if (!all_nodes && node->type != IB_NODE_SWITCH)
+	if ((type & node_type_to_print) == 0)
 		return;
 
 	if (node->type == IB_NODE_SWITCH && node->smaenhsp0)
@@ -361,11 +379,24 @@ static int process_opt(void *context, int ch, char *optarg)
 		data_counters++;
 		break;
 	case 3:
-		all_nodes++;
+		if (node_type_to_print == PRINT_ALL)
+			node_type_to_print = 0;
+		node_type_to_print |= PRINT_SWITCH;
+		break;
+	case 4:
+		if (node_type_to_print == PRINT_ALL)
+			node_type_to_print = 0;
+		node_type_to_print |= PRINT_CA;
+		break;
+	case 5:
+		if (node_type_to_print == PRINT_ALL)
+			node_type_to_print = 0;
+		node_type_to_print |= PRINT_ROUTER;
 		break;
+	case 'G':
 	case 'S':
-		switch_guid_str = optarg;
-		switch_guid = strtoull(optarg, 0, 0);
+		node_guid_str = optarg;
+		node_guid = strtoull(optarg, 0, 0);
 		break;
 	case 'D':
 		dr_path = strdup(optarg);
@@ -399,8 +430,9 @@ int main(int argc, char **argv)
 		{"suppress-common", 'c', 0, NULL,
 		 "suppress some of the common counters"},
 		{"node-name-map", 1, 1, "<file>", "node name map file"},
-		{"switch", 'S', 1, "<switch_guid>",
-		 "query only <switch_guid> (hex format)"},
+		{"node-guid", 'G', 1, "<node_guid>", "query only <node_guid>"},
+		{"", 'S', 1, "<node_guid>",
+		 "Same as \"-G\" for backward compatibility"},
 		{"Direct", 'D', 1, "<dr_path>",
 		 "query only switch specified by <dr_path>"},
 		{"report-port", 'r', 0, NULL,
@@ -408,7 +440,9 @@ int main(int argc, char **argv)
 		{"GNDN", 'R', 0, NULL,
 		 "(This option is obsolete and does nothing)"},
 		{"data", 2, 0, NULL, "include the data counters in the output"},
-		{"all", 3, 0, NULL, "output all nodes (not just switches)"},
+		{"switch", 3, 0, NULL, "print data for switches only"},
+		{"ca", 4, 0, NULL, "print data for CA's only"},
+		{"router", 5, 0, NULL, "print data for routers only"},
 		{0}
 	};
 	char usage_args[] = "";
@@ -438,13 +472,13 @@ int main(int argc, char **argv)
 					       NULL, ibmad_port)) < 0)
 			IBWARN("Failed to resolve %s; attempting full scan\n",
 			       dr_path);
-	} else if (switch_guid_str) {
+	} else if (node_guid_str) {
 		if ((resolved =
-		     ib_resolve_portid_str_via(&portid, switch_guid_str,
+		     ib_resolve_portid_str_via(&portid, node_guid_str,
 					       IB_DEST_GUID, ibd_sm_id,
 					       ibmad_port)) >= 0)
 			IBWARN("Failed to resolve %s; attempting full scan\n",
-			       switch_guid_str);
+			       node_guid_str);
 	}
 
 	if (resolved >= 0)
@@ -463,13 +497,13 @@ int main(int argc, char **argv)
 
 	report_suppressed();
 
-	if (switch_guid_str) {
-		ibnd_node_t *node = ibnd_find_node_guid(fabric, switch_guid);
+	if (node_guid_str) {
+		ibnd_node_t *node = ibnd_find_node_guid(fabric, node_guid);
 		if (node)
 			print_node(node, NULL);
 		else
 			fprintf(stderr, "Failed to find node: %s\n",
-				switch_guid_str);
+				node_guid_str);
 	} else if (dr_path) {
 		ibnd_node_t *node = ibnd_find_node_dr(fabric, dr_path);
 		uint8_t ni[IB_SMP_DATA_SIZE];
@@ -477,9 +511,9 @@ int main(int argc, char **argv)
 		if (!smp_query_via(ni, &portid, IB_ATTR_NODE_INFO, 0,
 				   ibd_timeout, ibmad_port))
 			return -1;
-		mad_decode_field(ni, IB_NODE_GUID_F, &(switch_guid));
+		mad_decode_field(ni, IB_NODE_GUID_F, &(node_guid));
 
-		node = ibnd_find_node_guid(fabric, switch_guid);
+		node = ibnd_find_node_guid(fabric, node_guid);
 		if (node)
 			print_node(node, NULL);
 		else
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
