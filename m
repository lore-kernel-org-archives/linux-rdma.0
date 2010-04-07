From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [3/3] support lid and nodedesc diffchecks in
	ibnetdiscover
Date: Wed, 07 Apr 2010 10:06:43 -0700
Message-ID: <1270660003.26381.42.camel@crazyclimber.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-vue/lxCcBrRVhjgbl2/6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org" <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-vue/lxCcBrRVhjgbl2/6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Sasha,

This patch adds lid and node description diff options for --diffcheck in
ibnetdiscover.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-vue/lxCcBrRVhjgbl2/6
Content-Disposition: attachment; filename*0=0003-support-lid-and-nodedesc-diffchecks-in-ibnetdiscover.pat; filename*1=ch
Content-Type: message/rfc822; name=0003-support-lid-and-nodedesc-diffchecks-in-ibnetdiscover.patch

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 31 Mar 2010 11:18:43 -0700
Subject: [PATCH] support lid and nodedesc diffchecks in ibnetdiscover
Message-Id: <1270659341.26381.31.camel-RLKWKRZIcZkVVsCFsIUZTRy+HRzXvqW9@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/man/ibnetdiscover.8 |    3 +-
 infiniband-diags/src/ibnetdiscover.c |  211 ++++++++++++++++++++++++----------
 2 files changed, 154 insertions(+), 60 deletions(-)

diff --git a/infiniband-diags/man/ibnetdiscover.8 b/infiniband-diags/man/ibnetdiscover.8
index e122736..76cfbc8 100644
--- a/infiniband-diags/man/ibnetdiscover.8
+++ b/infiniband-diags/man/ibnetdiscover.8
@@ -68,7 +68,8 @@ channel adapters, routers, and port connections.
 Specify what diff checks should be done in the \fB\-\-diff\fR option above.
 Comma separate multiple diff check key(s).  The available diff checks
 are: \fIsw\fR = switches, \fIca\fR = channel adapters, \fIrouter\fR = routers,
-\fIport\fR = port connections descriptions.  Note that \fIport\fR is
+\fIport\fR = port connections, \fIlid\fR = lids, \fInodedesc\fR = node
+descriptions.  Note that \fIport\fR, \fIlid\fR, and \fInodedesc\fR are
 checked only for the node types that are specified (e.g. \fIsw\fR,
 \fIca\fR, \fIrouter\fR).
 .TP
diff --git a/infiniband-diags/src/ibnetdiscover.c b/infiniband-diags/src/ibnetdiscover.c
index 4435ade..770c589 100644
--- a/infiniband-diags/src/ibnetdiscover.c
+++ b/infiniband-diags/src/ibnetdiscover.c
@@ -61,6 +61,8 @@
 #define DIFF_FLAG_CA               0x00000002
 #define DIFF_FLAG_ROUTER           0x00000004
 #define DIFF_FLAG_PORT_CONNECTION  0x00000008
+#define DIFF_FLAG_LID              0x00000010
+#define DIFF_FLAG_NODE_DESCRIPTION 0x00000020
 
 #define DIFF_FLAG_DEFAULT      (DIFF_FLAG_SWITCH \
 				| DIFF_FLAG_CA \
@@ -233,15 +235,29 @@ uint64_t out_chassis(ibnd_fabric_t * fabric, unsigned char chassisnum)
 	return guid;
 }
 
-void out_switch(ibnd_node_t * node, int group, char *chname, char *out_prefix)
+void out_switch_detail(ibnd_node_t * node, char *sw_prefix)
+{
+	char *nodename = NULL;
+
+	nodename = remap_node_name(node_name_map, node->guid, node->nodedesc);
+
+	fprintf(f, "%sSwitch\t%d %s\t\t# \"%s\" %s port 0 lid %d lmc %d",
+		sw_prefix ? sw_prefix : "",
+		node->numports, node_name(node), nodename,
+		node->smaenhsp0 ? "enhanced" : "base",
+		node->smalid, node->smalmc);
+
+	free(nodename);
+}
+
+void out_switch(ibnd_node_t * node, int group, char *chname, char *id_prefix, char *sw_prefix)
 {
 	char *str;
 	char str2[256];
-	char *nodename = NULL;
 
-	out_ids(node, group, chname, out_prefix);
+	out_ids(node, group, chname, id_prefix);
 	fprintf(f, "%sswitchguid=0x%" PRIx64,
-		out_prefix ? out_prefix : "", node->guid);
+		id_prefix ? id_prefix : "", node->guid);
 	fprintf(f, "(%" PRIx64 ")",
 		mad_get_field64(node->info, 0, IB_NODE_PORT_GUID_F));
 	if (group) {
@@ -253,45 +269,54 @@ void out_switch(ibnd_node_t * node, int group, char *chname, char *out_prefix)
 		if (str)
 			fprintf(f, "%s", str);
 	}
+	fprintf(f, "\n");
 
-	nodename = remap_node_name(node_name_map, node->guid, node->nodedesc);
+	out_switch_detail(node, sw_prefix);
+	fprintf(f, "\n");
+}
 
-	fprintf(f, "\n%sSwitch\t%d %s\t\t# \"%s\" %s port 0 lid %d lmc %d\n",
-		out_prefix ? out_prefix : "",
-		node->numports, node_name(node), nodename,
-		node->smaenhsp0 ? "enhanced" : "base",
-		node->smalid, node->smalmc);
+void out_ca_detail(ibnd_node_t * node, char *ca_prefix)
+{
+	char *node_type;
 
-	free(nodename);
+	switch (node->type) {
+	case IB_NODE_CA:
+		node_type = "Ca";
+		break;
+	case IB_NODE_ROUTER:
+		node_type = "Rt";
+		break;
+	default:
+		node_type = "???";
+		break;
+	}
+
+	fprintf(f, "%s%s\t%d %s\t\t# \"%s\"",
+		ca_prefix ? ca_prefix : "",
+		node_type, node->numports, node_name(node),
+		clean_nodedesc(node->nodedesc));
 }
 
-void out_ca(ibnd_node_t * node, int group, char *chname, char *out_prefix)
+void out_ca(ibnd_node_t * node, int group, char *chname, char *id_prefix, char *ca_prefix)
 {
 	char *node_type;
-	char *node_type2;
 
-	out_ids(node, group, chname, out_prefix);
+	out_ids(node, group, chname, id_prefix);
 	switch (node->type) {
 	case IB_NODE_CA:
 		node_type = "ca";
-		node_type2 = "Ca";
 		break;
 	case IB_NODE_ROUTER:
 		node_type = "rt";
-		node_type2 = "Rt";
 		break;
 	default:
 		node_type = "???";
-		node_type2 = "???";
 		break;
 	}
 
 	fprintf(f, "%s%sguid=0x%" PRIx64 "\n",
-		out_prefix ? out_prefix : "", node_type, node->guid);
-	fprintf(f, "%s%s\t%d %s\t\t# \"%s\"",
-		out_prefix ? out_prefix : "",
-		node_type2, node->numports, node_name(node),
-		clean_nodedesc(node->nodedesc));
+		id_prefix ? id_prefix : "", node_type, node->guid);
+	out_ca_detail(node, ca_prefix);
 	if (group && ibnd_is_xsigo_hca(node->guid))
 		fprintf(f, " (scp)");
 	fprintf(f, "\n");
@@ -406,7 +431,7 @@ static void switch_iter_func(ibnd_node_t * node, void *iter_user_data)
 	    && node->chassis->chassisnum)
 		return;
 
-	out_switch(node, data->group, NULL, NULL);
+	out_switch(node, data->group, NULL, NULL, NULL);
 	for (p = 1; p <= node->numports; p++) {
 		port = node->ports[p];
 		if (port && port->remoteport)
@@ -424,7 +449,7 @@ static void ca_iter_func(ibnd_node_t * node, void *iter_user_data)
 	/* Now, skip chassis based CAs */
 	if (data->group && node->chassis && node->chassis->chassisnum)
 		return;
-	out_ca(node, data->group, NULL, NULL);
+	out_ca(node, data->group, NULL, NULL, NULL);
 
 	for (p = 1; p <= node->numports; p++) {
 		port = node->ports[p];
@@ -443,7 +468,7 @@ static void router_iter_func(ibnd_node_t * node, void *iter_user_data)
 	/* Now, skip chassis based RTs */
 	if (data->group && node->chassis && node->chassis->chassisnum)
 		return;
-	out_ca(node, data->group, NULL, NULL);
+	out_ca(node, data->group, NULL, NULL, NULL);
 	for (p = 1; p <= node->numports; p++) {
 		port = node->ports[p];
 		if (port && port->remoteport)
@@ -502,7 +527,7 @@ int dump_topology(int group, ibnd_fabric_t * fabric)
 			for (n = 1; n <= SPINES_MAX_NUM; n++) {
 				if (ch->spinenode[n]) {
 					out_switch(ch->spinenode[n], group,
-						   chname, NULL);
+						   chname, NULL, NULL);
 					for (p = 1;
 					     p <= ch->spinenode[n]->numports;
 					     p++) {
@@ -519,7 +544,7 @@ int dump_topology(int group, ibnd_fabric_t * fabric)
 			for (n = 1; n <= LINES_MAX_NUM; n++) {
 				if (ch->linenode[n]) {
 					out_switch(ch->linenode[n], group,
-						   chname, NULL);
+						   chname, NULL, NULL);
 					for (p = 1;
 					     p <= ch->linenode[n]->numports;
 					     p++) {
@@ -537,7 +562,8 @@ int dump_topology(int group, ibnd_fabric_t * fabric)
 			for (node = ch->nodes; node;
 			     node = node->next_chassis_node) {
 				if (node->type == IB_NODE_SWITCH) {
-					out_switch(node, group, chname, NULL);
+					out_switch(node, group, chname, NULL,
+						   NULL);
 					for (p = 1; p <= node->numports; p++) {
 						port = node->ports[p];
 						if (port && port->remoteport)
@@ -553,7 +579,8 @@ int dump_topology(int group, ibnd_fabric_t * fabric)
 			for (node = ch->nodes; node;
 			     node = node->next_chassis_node) {
 				if (node->type == IB_NODE_CA) {
-					out_ca(node, group, chname, NULL);
+					out_ca(node, group, chname, NULL,
+					       NULL);
 					for (p = 1; p <= node->numports; p++) {
 						port = node->ports[p];
 						if (port && port->remoteport)
@@ -640,7 +667,8 @@ struct iter_diff_data {
 	ibnd_fabric_t * fabric2;
 	char *fabric1_prefix;
 	char *fabric2_prefix;
-	void (*out_header)(ibnd_node_t *, int, char *, char *);
+	void (*out_header)(ibnd_node_t *, int, char *, char *, char *);
+	void (*out_header_detail)(ibnd_node_t *, char *);
 	void (*out_port)(ibnd_port_t *, int, char *);
 };
 
@@ -649,11 +677,63 @@ static void diff_iter_out_header(ibnd_node_t * node,
 				 int *out_header_flag)
 {
 	if (!(*out_header_flag)) {
-		(*data->out_header)(node, 0, NULL, NULL);
+		(*data->out_header)(node, 0, NULL, NULL, NULL);
 		(*out_header_flag)++;
 	}
 }
 
+static void diff_ports(ibnd_node_t * fabric1_node,
+		       ibnd_node_t * fabric2_node,
+		       int *out_header_flag,
+		       struct iter_diff_data *data)
+{
+	ibnd_port_t *fabric1_port;
+	ibnd_port_t *fabric2_port;
+	int p;
+
+	for (p = 1; p <= fabric1_node->numports; p++) {
+		int fabric1_out = 0, fabric2_out = 0;
+
+		fabric1_port = fabric1_node->ports[p];
+		fabric2_port = fabric2_node->ports[p];
+
+		if (data->diff_flags & DIFF_FLAG_PORT_CONNECTION) {
+			if ((fabric1_port && !fabric2_port)
+			    || ((fabric1_port && fabric2_port)
+				&& (fabric1_port->remoteport && !fabric2_port->remoteport)))
+				fabric1_out++;
+			else if ((!fabric1_port && fabric2_port)
+				 || ((fabric1_port && fabric2_port)
+				     && (!fabric1_port->remoteport && fabric2_port->remoteport)))
+				fabric2_out++;
+			else if ((fabric1_port && fabric2_port)
+				 && ((fabric1_port->guid != fabric2_port->guid)
+				     || ((fabric1_port->remoteport && fabric2_port->remoteport)
+					 && (fabric1_port->remoteport->guid != fabric2_port->remoteport->guid)))) {
+				fabric1_out++;
+				fabric2_out++;
+			}
+		}
+
+		if (data->diff_flags & DIFF_FLAG_LID) {
+			if ((fabric1_port && fabric2_port)
+			    && (fabric1_port->base_lid != fabric2_port->base_lid)) {
+				fabric1_out++;
+				fabric2_out++;
+			}
+		}
+
+		if (fabric1_out) {
+			diff_iter_out_header(fabric1_node, data, out_header_flag);
+			(*data->out_port)(fabric1_port, 0, data->fabric1_prefix);
+		}
+		if (fabric2_out) {
+			diff_iter_out_header(fabric1_node, data, out_header_flag);
+			(*data->out_port)(fabric2_port, 0, data->fabric2_prefix);
+		}
+	}
+}
+
 static void diff_iter_func(ibnd_node_t * fabric1_node, void *iter_user_data)
 {
 	struct iter_diff_data *data = (struct iter_diff_data *)iter_user_data;
@@ -666,16 +746,35 @@ static void diff_iter_func(ibnd_node_t * fabric1_node, void *iter_user_data)
 	fabric2_node = ibnd_find_node_guid (data->fabric2, fabric1_node->guid);
 
 	if (!fabric2_node) {
-		(*data->out_header)(fabric1_node, 0, NULL, data->fabric1_prefix);
+		(*data->out_header)(fabric1_node, 0, NULL, data->fabric1_prefix,
+				    data->fabric1_prefix);
 		for (p = 1; p <= fabric1_node->numports; p++) {
 			fabric1_port = fabric1_node->ports[p];
 			if (fabric1_port && fabric1_port->remoteport)
 				(*data->out_port)(fabric1_port, 0, data->fabric1_prefix);
 		}
 	}
-	else if (data->diff_flags & DIFF_FLAG_PORT_CONNECTION) {
-		ibnd_port_t *fabric2_port;
+	else if (data->diff_flags & DIFF_FLAG_PORT_CONNECTION
+		 || data->diff_flags & DIFF_FLAG_LID
+		 || data->diff_flags & DIFF_FLAG_NODE_DESCRIPTION) {
 		int out_header_flag = 0;
+		int out_header_detail_diff = 0;
+
+		if (data->diff_flags & DIFF_FLAG_LID
+		    && fabric1_node->smalid != fabric2_node->smalid)
+			out_header_detail_diff++;
+
+		if (data->diff_flags & DIFF_FLAG_NODE_DESCRIPTION
+		    && memcmp(fabric1_node->nodedesc, fabric2_node->nodedesc, IB_SMP_DATA_SIZE))
+			out_header_detail_diff++;
+
+		if (out_header_detail_diff) {
+			(*data->out_header)(fabric1_node, 0, NULL, NULL,
+					    data->fabric1_prefix);
+			(*data->out_header_detail)(fabric2_node, data->fabric2_prefix);
+			fprintf(f, "\n");
+			out_header_flag++;
+		}
 
 		if (fabric1_node->numports != fabric2_node->numports) {
 			diff_iter_out_header(fabric1_node, data, &out_header_flag);
@@ -686,30 +785,12 @@ static void diff_iter_func(ibnd_node_t * fabric1_node, void *iter_user_data)
 			return;
 		}
 
-		for (p = 1; p <= fabric1_node->numports; p++) {
-			fabric1_port = fabric1_node->ports[p];
-			fabric2_port = fabric2_node->ports[p];
-			if ((fabric1_port && !fabric2_port)
-			    || ((fabric1_port && fabric2_port)
-				&& (fabric1_port->remoteport && !fabric2_port->remoteport))) {
-				diff_iter_out_header(fabric1_node, data, &out_header_flag);
-				(*data->out_port)(fabric1_port, 0, data->fabric1_prefix);
-			}
-			else if ((!fabric1_port && fabric2_port)
-				 || ((fabric1_port && fabric2_port)
-				     && (!fabric1_port->remoteport && fabric2_port->remoteport))) {
-				diff_iter_out_header(fabric1_node, data, &out_header_flag);
-				(*data->out_port)(fabric2_port, 0, data->fabric2_prefix);
-			}
-			else if ((fabric1_port && fabric2_port)
-				 && ((fabric1_port->guid != fabric2_port->guid)
-				     || ((fabric1_port->remoteport && fabric2_port->remoteport)
-					 && (fabric1_port->remoteport->guid != fabric2_port->remoteport->guid)))) {
-				diff_iter_out_header(fabric1_node, data, &out_header_flag);
-				(*data->out_port)(fabric1_port, 0, data->fabric1_prefix);
-				(*data->out_port)(fabric2_port, 0, data->fabric2_prefix);
-			}
-		}
+		if (data->diff_flags & DIFF_FLAG_PORT_CONNECTION
+		    || data->diff_flags & DIFF_FLAG_LID)
+			diff_ports(fabric1_node,
+				   fabric2_node,
+				   &out_header_flag,
+				   data);
 	}
 }
 
@@ -717,7 +798,8 @@ static int diff_common(ibnd_fabric_t * orig_fabric,
 		       ibnd_fabric_t * new_fabric,
 		       int node_type,
 		       uint32_t diff_flags,
-		       void (*out_header)(ibnd_node_t *, int, char *, char *),
+		       void (*out_header)(ibnd_node_t *, int, char *, char *, char*),
+		       void (*out_header_detail)(ibnd_node_t *, char *),
 		       void (*out_port)(ibnd_port_t *, int, char *))
 {
 	struct iter_diff_data iter_diff_data;
@@ -728,6 +810,7 @@ static int diff_common(ibnd_fabric_t * orig_fabric,
 	iter_diff_data.fabric1_prefix = "< ";
 	iter_diff_data.fabric2_prefix = "> ";
 	iter_diff_data.out_header = out_header;
+	iter_diff_data.out_header_detail = out_header_detail;
 	iter_diff_data.out_port = out_port;
 	ibnd_iter_nodes_type(orig_fabric, diff_iter_func,
 			     node_type, &iter_diff_data);
@@ -741,11 +824,14 @@ static int diff_common(ibnd_fabric_t * orig_fabric,
 	 * orig and new).
 	 */
 	iter_diff_data.diff_flags = diff_flags & ~DIFF_FLAG_PORT_CONNECTION;
+	iter_diff_data.diff_flags &= ~DIFF_FLAG_LID;
+	iter_diff_data.diff_flags &= ~DIFF_FLAG_NODE_DESCRIPTION;
 	iter_diff_data.fabric1 = new_fabric;
 	iter_diff_data.fabric2 = orig_fabric;
 	iter_diff_data.fabric1_prefix = "> ";
 	iter_diff_data.fabric2_prefix = "< ";
 	iter_diff_data.out_header = out_header;
+	iter_diff_data.out_header_detail = out_header_detail;
 	iter_diff_data.out_port = out_port;
 	ibnd_iter_nodes_type(new_fabric, diff_iter_func,
 			     node_type, &iter_diff_data);
@@ -761,6 +847,7 @@ int diff(ibnd_fabric_t * orig_fabric, ibnd_fabric_t * new_fabric)
 			    IB_NODE_SWITCH,
 			    diffcheck_flags,
 			    out_switch,
+			    out_switch_detail,
 			    out_switch_port);
 
 	if (diffcheck_flags & DIFF_FLAG_CA)
@@ -769,6 +856,7 @@ int diff(ibnd_fabric_t * orig_fabric, ibnd_fabric_t * new_fabric)
 			    IB_NODE_CA,
 			    diffcheck_flags,
 			    out_ca,
+			    out_ca_detail,
 			    out_ca_port);
 
 	if (diffcheck_flags & DIFF_FLAG_ROUTER)
@@ -777,6 +865,7 @@ int diff(ibnd_fabric_t * orig_fabric, ibnd_fabric_t * new_fabric)
 			    IB_NODE_ROUTER,
 			    diffcheck_flags,
 			    out_ca,
+			    out_ca_detail,
 			    out_ca_port);
 
 
@@ -814,6 +903,10 @@ static int process_opt(void *context, int ch, char *optarg)
 				diffcheck_flags |= DIFF_FLAG_ROUTER;
 			else if (!strcasecmp(p, "port"))
 				diffcheck_flags |= DIFF_FLAG_PORT_CONNECTION;
+			else if (!strcasecmp(p, "lid"))
+				diffcheck_flags |= DIFF_FLAG_LID;
+			else if (!strcasecmp(p, "nodedesc"))
+				diffcheck_flags |= DIFF_FLAG_NODE_DESCRIPTION;
 			else {
 				fprintf(stderr, "invalid diff check key: %s\n", p);
 				return -1;
-- 
1.5.4.5


--=-vue/lxCcBrRVhjgbl2/6--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
