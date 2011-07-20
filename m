From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/3] infiniband-diags: libibnetdisc Allow a DR Path partial
 fabric query starting at a CA
Date: Wed, 20 Jul 2011 16:16:55 -0700
Message-ID: <20110720161655.1ed38052.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


The old algorithm would attempt to extend a DR path through the CA and fail.
The new algorithm retracts the path properly.

This does not work when combined routing is used with the CA as a starting
point.  :-(

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 libibnetdisc/src/ibnetdisc.c |   83 ++++++++++++++++++++++++++++++++----------
 libibnetdisc/src/internal.h  |    1 +
 2 files changed, 64 insertions(+), 20 deletions(-)

diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index b7fa75a..07f2a3f 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -56,8 +56,13 @@
 #include "chassis.h"
 
 /* forward declare */
+struct ni_cbdata
+{
+	ibnd_node_t *node;
+	int port_num;
+};
 static int query_node_info(smp_engine_t * engine, ib_portid_t * portid,
-			   ibnd_node_t * node);
+			   struct ni_cbdata * cbdata);
 
 static int recv_switch_info(smp_engine_t * engine, ibnd_smp_t * smp,
 			    uint8_t * mad, void *cb_data)
@@ -87,6 +92,26 @@ static int add_port_to_dpath(ib_dr_path_t * path, int nextport)
 	return path->cnt;
 }
 
+static int retract_dpath(smp_engine_t * engine, ib_portid_t * portid)
+{
+	ibnd_scan_t *scan = engine->user_data;
+	ibnd_fabric_t *fabric = scan->fabric;
+
+	if (scan->cfg->max_hops &&
+	    fabric->maxhops_discovered > scan->cfg->max_hops)
+		return 0;
+
+	/* this may seem wrong but the only time we would retract the path is
+	 * if the user specified a CA for the DR path and we are retracting
+	 * from that to find the node it is connected to.  This counts as a
+	 * positive hop discovered
+	 */
+	fabric->maxhops_discovered++;
+	portid->drpath.p[portid->drpath.cnt] = 0;
+	portid->drpath.cnt--;
+	return 1;
+}
+
 static int extend_dpath(smp_engine_t * engine, ib_portid_t * portid,
 			int nextport)
 {
@@ -115,8 +140,9 @@ static int extend_dpath(smp_engine_t * engine, ib_portid_t * portid,
 		return -1;
 	}
 
-	if ((unsigned) portid->drpath.cnt > fabric->maxhops_discovered)
-		fabric->maxhops_discovered = portid->drpath.cnt;
+	if (((unsigned) portid->drpath.cnt - scan->initial_hops) >
+	    fabric->maxhops_discovered)
+		fabric->maxhops_discovered++;
 
 	return 1;
 }
@@ -202,9 +228,26 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	    == IB_PORT_PHYS_STATE_LINKUP
 	    && ((node->type == IB_NODE_SWITCH && port_num != local_port) ||
 		(node == fabric->from_node && port_num == fabric->from_portnum))) {
+
+		int rc = 0;
 		ib_portid_t path = smp->path;
-		if (extend_dpath(engine, &path, port_num) > 0)
-			query_node_info(engine, &path, node);
+
+		if (node->type != IB_NODE_SWITCH &&
+		    node == fabric->from_node &&
+		    path.drpath.cnt > 1)
+			rc = retract_dpath(engine, &path);
+		else {
+			/* we can't proceed through an HCA with DR */
+			if (path.lid == 0 || node->type == IB_NODE_SWITCH)
+				rc = extend_dpath(engine, &path, port_num);
+		}
+
+		if (rc > 0) {
+			struct ni_cbdata * cbdata = malloc(sizeof(*cbdata));
+			cbdata->node = node;
+			cbdata->port_num = port_num;
+			query_node_info(engine, &path, cbdata);
+		}
 	}
 
 	return 0;
@@ -255,11 +298,6 @@ static ibnd_node_t *create_node(smp_engine_t * engine, ib_portid_t * path,
 	return rc;
 }
 
-static int get_last_port(ib_portid_t * path)
-{
-	return path->drpath.p[path->drpath.cnt];
-}
-
 static void link_ports(ibnd_node_t * node, ibnd_port_t * port,
 		       ibnd_node_t * remotenode, ibnd_port_t * remoteport)
 {
@@ -294,7 +332,9 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	ibnd_fabric_t *fabric = scan->fabric;
 	int i = 0;
 	uint8_t *node_info = mad + IB_SMP_DATA_OFFS;
-	ibnd_node_t *rem_node = cb_data;
+	struct ni_cbdata *ni_cbdata = (struct ni_cbdata *)cb_data;
+	ibnd_node_t *rem_node = NULL;
+	int rem_port_num = 0;
 	ibnd_node_t *node;
 	int node_is_new = 0;
 	uint64_t node_guid = mad_get_field64(node_info, 0, IB_NODE_GUID_F);
@@ -302,6 +342,12 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	int port_num = mad_get_field(node_info, 0, IB_NODE_LOCAL_PORT_F);
 	ibnd_port_t *port = NULL;
 
+	if (ni_cbdata) {
+		rem_node = ni_cbdata->node;
+		rem_port_num = ni_cbdata->port_num;
+		free(ni_cbdata);
+	}
+
 	node = ibnd_find_node_guid(fabric, node_guid);
 	if (!node) {
 		node = create_node(engine, &smp->path, node_info);
@@ -333,8 +379,6 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 		fabric->from_portnum = port_num;
 	} else {
 		/* link ports... */
-		int rem_port_num = get_last_port(&smp->path);
-
 		if (!rem_node->ports[rem_port_num]) {
 			IBND_ERROR("Internal Error; "
 				   "Node(%p) 0x%" PRIx64
@@ -363,11 +407,11 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 }
 
 static int query_node_info(smp_engine_t * engine, ib_portid_t * portid,
-			   ibnd_node_t * node)
+			   struct ni_cbdata * cbdata)
 {
 	IBND_DEBUG("Query Node Info; %s\n", portid2str(portid));
 	return issue_smp(engine, portid, IB_ATTR_NODE_INFO, 0,
-			 recv_node_info, node);
+			 recv_node_info, (void *)cbdata);
 }
 
 ibnd_node_t *ibnd_find_node_guid(ibnd_fabric_t * fabric, uint64_t guid)
@@ -430,8 +474,7 @@ void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric)
 	}
 }
 
-static int set_config(struct ibnd_config *config, struct ibnd_config *cfg,
-		      int initial_hops)
+static int set_config(struct ibnd_config *config, struct ibnd_config *cfg)
 {
 	if (!config)
 		return (-EINVAL);
@@ -445,8 +488,6 @@ static int set_config(struct ibnd_config *config, struct ibnd_config *cfg,
 		config->timeout_ms = DEFAULT_TIMEOUT;
 	if (!config->retries)
 		config->retries = DEFAULT_RETRIES;
-	if (config->max_hops)
-		config->max_hops += initial_hops;
 
 	return (0);
 }
@@ -467,7 +508,7 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
 	if (!from)
 		from = &my_portid;
 
-	if (set_config(&config, cfg, from->drpath.cnt)) {
+	if (set_config(&config, cfg)) {
 		IBND_ERROR("Invalid ibnd_config\n");
 		return NULL;
 	}
@@ -483,6 +524,7 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
 	memset(&scan.selfportid, 0, sizeof(scan.selfportid));
 	scan.fabric = fabric;
 	scan.cfg = &config;
+	scan.initial_hops = from->drpath.cnt;
 
 	if (smp_engine_init(&engine, ca_name, ca_port, &scan, &config)) {
 		free(fabric);
@@ -505,6 +547,7 @@ ibnd_fabric_t *ibnd_discover_fabric(char * ca_name, int ca_port,
 			goto error;
 
 	fabric->total_mads_used = engine.total_smps;
+	fabric->maxhops_discovered += scan.initial_hops;
 
 	if (group_nodes(fabric))
 		goto error;
diff --git a/libibnetdisc/src/internal.h b/libibnetdisc/src/internal.h
index 3c599ec..80918c4 100644
--- a/libibnetdisc/src/internal.h
+++ b/libibnetdisc/src/internal.h
@@ -62,6 +62,7 @@ typedef struct ibnd_scan {
 	ibnd_fabric_t *fabric;
 	struct ibnd_config *cfg;
 	struct ibmad_port *ibmad_port;
+	unsigned initial_hops;
 } ibnd_scan_t;
 
 typedef struct ibnd_smp ibnd_smp_t;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
