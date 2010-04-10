From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibnetdisc: code cleanups
Date: Sat, 10 Apr 2010 03:55:36 +0300
Message-ID: <20100410005536.GI4808@me>
References: <20100218124931.4d6ef34b.weiny2@llnl.gov>
 <20100410005245.GH4808@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100410005245.GH4808@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Make newly introduced local functions to be static. Remove not needed
braces. Simplify some expressions.

Fix indentations using osm_indent script.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/chassis.c        |    2 +-
 infiniband-diags/libibnetdisc/src/ibnetdisc.c      |  150 +++++++++-----------
 .../libibnetdisc/src/ibnetdisc_cache.c             |    9 +-
 infiniband-diags/libibnetdisc/src/internal.h       |   23 ++--
 infiniband-diags/libibnetdisc/src/query_smp.c      |   68 ++++-----
 5 files changed, 113 insertions(+), 139 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/chassis.c b/infiniband-diags/libibnetdisc/src/chassis.c
index c8f6b6c..1a839d9 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.c
+++ b/infiniband-diags/libibnetdisc/src/chassis.c
@@ -38,7 +38,7 @@
 /*========================================================*/
 
 #if HAVE_CONFIG_H
-#  include <config.h>
+#include <config.h>
 #endif				/* HAVE_CONFIG_H */
 
 #include <stdlib.h>
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index b084373..4780810 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -34,7 +34,7 @@
  */
 
 #if HAVE_CONFIG_H
-#  include <config.h>
+#include <config.h>
 #endif				/* HAVE_CONFIG_H */
 
 #define _GNU_SOURCE
@@ -59,54 +59,41 @@ static int max_smps_on_wire = DEFAULT_MAX_SMP_ON_WIRE;
 int ibdebug;
 
 /* forward declare */
-int query_node_info(smp_engine_t * engine, ib_portid_t * portid,
-		    ibnd_node_t * node);
+static int query_node_info(smp_engine_t * engine, ib_portid_t * portid,
+			   ibnd_node_t * node);
 
-
-static int recv_switch_info(smp_engine_t *engine, ibnd_smp_t * smp,
-			    uint8_t *mad, void *cb_data)
+static int recv_switch_info(smp_engine_t * engine, ibnd_smp_t * smp,
+			    uint8_t * mad, void *cb_data)
 {
 	uint8_t *switch_info = mad + IB_SMP_DATA_OFFS;
-	ibnd_node_t * node = (ibnd_node_t *)cb_data;
+	ibnd_node_t *node = cb_data;
 	memcpy(node->switchinfo, switch_info, sizeof(node->switchinfo));
 	mad_decode_field(node->switchinfo, IB_SW_ENHANCED_PORT0_F,
 			 &node->smaenhsp0);
 	return 0;
 }
+
 static int query_switch_info(smp_engine_t * engine, ib_portid_t * portid,
-		      ibnd_node_t *node)
+			     ibnd_node_t * node)
 {
 	node->smaenhsp0 = 0;	/* assume base SP0 */
-	return (issue_smp(engine, portid, IB_ATTR_SWITCH_INFO, 0, recv_switch_info,
-			  (void *)node));
+	return issue_smp(engine, portid, IB_ATTR_SWITCH_INFO, 0,
+			 recv_switch_info, node);
 }
 
 static int add_port_to_dpath(ib_dr_path_t * path, int nextport)
 {
-	if (path->cnt + 2 >= sizeof(path->p)) {
+	if (path->cnt > sizeof(path->p) - 1)
 		return -1;
-	}
 	++path->cnt;
 	path->p[path->cnt] = (uint8_t) nextport;
 	return path->cnt;
 }
 
-#if 0
-static void retract_dpath(ib_portid_t * path)
-{
-	path->drpath.cnt--;	/* restore path */
-	if (path->drpath.cnt == 0 && path->lid) {
-		/* return to lid based routing on this path */
-		path->drpath.drslid = 0;
-		path->drpath.drdlid = 0;
-	}
-}
-#endif
-
-static int extend_dpath(smp_engine_t * engine, ib_portid_t * portid, int nextport)
+static int extend_dpath(smp_engine_t * engine, ib_portid_t * portid,
+			int nextport)
 {
-	int rc = 0;
-	ibnd_scan_t *scan = (ibnd_scan_t *)engine->user_data;
+	ibnd_scan_t *scan = engine->user_data;
 	ibnd_fabric_t *fabric = scan->fabric;
 
 	if (portid->lid) {
@@ -117,37 +104,39 @@ static int extend_dpath(smp_engine_t * engine, ib_portid_t * portid, int nextpor
 				IBND_ERROR("Failed to resolve self\n");
 				return -1;
 			}
-
 		portid->drpath.drslid = (uint16_t) scan->selfportid.lid;
 		portid->drpath.drdlid = 0xFFFF;
 	}
 
-	rc = add_port_to_dpath(&portid->drpath, nextport);
-	if (rc < 0)
+	if (add_port_to_dpath(&portid->drpath, nextport) < 0) {
 		IBND_ERROR("add port %d to DR path failed; %s\n", nextport,
 			   portid2str(portid));
+		return -1;
+	}
 
-	if (rc != -1 && portid->drpath.cnt > fabric->maxhops_discovered)
+	if (portid->drpath.cnt > fabric->maxhops_discovered)
 		fabric->maxhops_discovered = portid->drpath.cnt;
-	return rc;
+
+	return 1;
 }
 
 static int recv_node_desc(smp_engine_t * engine, ibnd_smp_t * smp,
-			  uint8_t *mad, void *cb_data)
+			  uint8_t * mad, void *cb_data)
 {
 	uint8_t *node_desc = mad + IB_SMP_DATA_OFFS;
-	ibnd_node_t *node = (ibnd_node_t *)cb_data;
+	ibnd_node_t *node = cb_data;
 	memcpy(node->nodedesc, node_desc, sizeof(node->nodedesc));
 	return 0;
 }
 
-int query_node_desc(smp_engine_t * engine, ib_portid_t * portid, ibnd_node_t *node)
+static int query_node_desc(smp_engine_t * engine, ib_portid_t * portid,
+			   ibnd_node_t * node)
 {
-	return (issue_smp(engine, portid, IB_ATTR_NODE_DESC, 0, recv_node_desc,
-			  (void *)node));
+	return issue_smp(engine, portid, IB_ATTR_NODE_DESC, 0,
+			 recv_node_desc, node);
 }
 
-static void debug_port(ib_portid_t *portid, ibnd_port_t * port)
+static void debug_port(ib_portid_t * portid, ibnd_port_t * port)
 {
 	char width[64], speed[64];
 	int iwidth;
@@ -164,11 +153,11 @@ static void debug_port(ib_portid_t *portid, ibnd_port_t * port)
 	     mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64, &ispeed));
 }
 
-static int recv_port_info(smp_engine_t *engine, ibnd_smp_t * smp,
-			  uint8_t *mad, void *cb_data)
+static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
+			  uint8_t * mad, void *cb_data)
 {
-	ibnd_fabric_t *fabric = ((ibnd_scan_t *)engine->user_data)->fabric;
-	ibnd_node_t *node = (ibnd_node_t *)cb_data;
+	ibnd_fabric_t *fabric = ((ibnd_scan_t *) engine->user_data)->fabric;
+	ibnd_node_t *node = cb_data;
 	ibnd_port_t *port;
 	uint8_t *port_info = mad + IB_SMP_DATA_OFFS;
 	uint8_t port_num, local_port;
@@ -205,12 +194,9 @@ static int recv_port_info(smp_engine_t *engine, ibnd_smp_t * smp,
 
 	debug_port(&smp->path, port);
 
-	if (port_num &&
-	    (mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
-	    == IB_PORT_PHYS_STATE_LINKUP)
-		&&
-	    (node->type == IB_NODE_SWITCH || node == fabric->from_node)) {
-
+	if (port_num && mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
+	    == IB_PORT_PHYS_STATE_LINKUP
+	    && (node->type == IB_NODE_SWITCH || node == fabric->from_node)) {
 		ib_portid_t path = smp->path;
 		if (extend_dpath(engine, &path, port_num) != -1)
 			query_node_info(engine, &path, node);
@@ -218,19 +204,20 @@ static int recv_port_info(smp_engine_t *engine, ibnd_smp_t * smp,
 
 	return 0;
 }
-int query_port_info(smp_engine_t * engine, ib_portid_t * portid,
-		    ibnd_node_t *node, int portnum)
+
+static int query_port_info(smp_engine_t * engine, ib_portid_t * portid,
+			   ibnd_node_t * node, int portnum)
 {
 	IBND_DEBUG("Query Port Info; %s (%lx):%d\n", portid2str(portid),
 		   node->guid, portnum);
-	return (issue_smp(engine, portid, IB_ATTR_PORT_INFO, portnum, recv_port_info,
-			  (void *)node));
+	return issue_smp(engine, portid, IB_ATTR_PORT_INFO, portnum,
+			 recv_port_info, node);
 }
 
 static ibnd_node_t *create_node(smp_engine_t * engine, ib_portid_t * path,
-				uint8_t *node_info)
+				uint8_t * node_info)
 {
-	ibnd_fabric_t *fabric = ((ibnd_scan_t *)engine->user_data)->fabric;
+	ibnd_fabric_t *fabric = ((ibnd_scan_t *) engine->user_data)->fabric;
 	ibnd_node_t *rc = calloc(1, sizeof(*rc));
 	if (!rc) {
 		IBND_ERROR("OOM: node creation failed\n");
@@ -238,9 +225,9 @@ static ibnd_node_t *create_node(smp_engine_t * engine, ib_portid_t * path,
 	}
 
 	/* decode just a couple of fields for quicker reference. */
-	mad_decode_field(node_info, IB_NODE_GUID_F, &(rc->guid));
-	mad_decode_field(node_info, IB_NODE_TYPE_F, &(rc->type));
-	mad_decode_field(node_info, IB_NODE_NPORTS_F, &(rc->numports));
+	mad_decode_field(node_info, IB_NODE_GUID_F, &rc->guid);
+	mad_decode_field(node_info, IB_NODE_TYPE_F, &rc->type);
+	mad_decode_field(node_info, IB_NODE_NPORTS_F, &rc->numports);
 
 	rc->ports = calloc(rc->numports + 1, sizeof(*rc->ports));
 	if (!rc->ports) {
@@ -265,8 +252,9 @@ static ibnd_node_t *create_node(smp_engine_t * engine, ib_portid_t * path,
 
 static int get_last_port(ib_portid_t * path)
 {
-	return (path->drpath.p[path->drpath.cnt]);
+	return path->drpath.p[path->drpath.cnt];
 }
+
 static void link_ports(ibnd_node_t * node, ibnd_port_t * port,
 		       ibnd_node_t * remotenode, ibnd_port_t * remoteport)
 {
@@ -278,17 +266,17 @@ static void link_ports(ibnd_node_t * node, ibnd_port_t * port,
 		port->remoteport->remoteport = NULL;
 	if (remoteport->remoteport)
 		remoteport->remoteport->remoteport = NULL;
-	port->remoteport = (ibnd_port_t *) remoteport;
-	remoteport->remoteport = (ibnd_port_t *) port;
+	port->remoteport = remoteport;
+	remoteport->remoteport = port;
 }
 
-static int recv_node_info(smp_engine_t *engine, ibnd_smp_t * smp,
-			  uint8_t *mad, void *cb_data)
+static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
+			  uint8_t * mad, void *cb_data)
 {
-	ibnd_fabric_t *fabric = ((ibnd_scan_t *)engine->user_data)->fabric;
+	ibnd_fabric_t *fabric = ((ibnd_scan_t *) engine->user_data)->fabric;
 	int i = 0;
 	uint8_t *node_info = mad + IB_SMP_DATA_OFFS;
-	ibnd_node_t * rem_node = (ibnd_node_t *)cb_data;
+	ibnd_node_t *rem_node = cb_data;
 	ibnd_node_t *node;
 	int node_is_new = 0;
 	uint64_t node_guid = mad_get_field64(node_info, 0, IB_NODE_GUID_F);
@@ -303,9 +291,8 @@ static int recv_node_info(smp_engine_t *engine, ibnd_smp_t * smp,
 			return -1;
 		node_is_new = 1;
 	}
-	IBND_DEBUG("Found %s node GUID %lx (%s)\n",
-		   (node_is_new) ? "new": "old", node->guid,
-		   portid2str(&smp->path));
+	IBND_DEBUG("Found %s node GUID %lx (%s)\n", node_is_new ? "new" : "old",
+		   node->guid, portid2str(&smp->path));
 
 	port = node->ports[port_num];
 	if (!port) {
@@ -316,7 +303,7 @@ static int recv_node_info(smp_engine_t *engine, ibnd_smp_t * smp,
 	}
 	port->guid = port_guid;
 
-	if (rem_node == NULL) /* this is the start node */
+	if (rem_node == NULL)	/* this is the start node */
 		fabric->from_node = node;
 	else {
 		/* link ports... */
@@ -326,7 +313,7 @@ static int recv_node_info(smp_engine_t *engine, ibnd_smp_t * smp,
 			IBND_ERROR("Internal Error; "
 				   "Node(%p) %lx Port %d no port created!?!?!?\n\n",
 				   rem_node, rem_node->guid, rem_port_num);
-			return (-1);
+			return -1;
 		}
 
 		link_ports(node, port, rem_node, rem_node->ports[rem_port_num]);
@@ -342,19 +329,19 @@ static int recv_node_info(smp_engine_t *engine, ibnd_smp_t * smp,
 
 	/* process all the ports on this node */
 	for (i = (node->type == IB_NODE_SWITCH) ? 0 : 1;
-		i <= node->numports; i++) {
-			query_port_info(engine, &smp->path, node, i);
+	     i <= node->numports; i++) {
+		query_port_info(engine, &smp->path, node, i);
 	}
 
 	return 0;
 }
 
-int query_node_info(smp_engine_t * engine, ib_portid_t * portid,
-		    ibnd_node_t * node)
+static int query_node_info(smp_engine_t * engine, ib_portid_t * portid,
+			   ibnd_node_t * node)
 {
 	IBND_DEBUG("Query Node Info; %s\n", portid2str(portid));
-	return (issue_smp(engine, portid, IB_ATTR_NODE_INFO, 0, recv_node_info,
-			  (void *)node));
+	return issue_smp(engine, portid, IB_ATTR_NODE_INFO, 0,
+			 recv_node_info, node);
 }
 
 ibnd_node_t *ibnd_find_node_guid(ibnd_fabric_t * fabric, uint64_t guid)
@@ -402,9 +389,8 @@ ibnd_node_t *ibnd_find_node_dr(ibnd_fabric_t * fabric, char *dr_str)
 
 	rc = fabric->from_node;
 
-	if (str2drpath(&path, dr_str, 0, 0) == -1) {
+	if (str2drpath(&path, dr_str, 0, 0) == -1)
 		return NULL;
-	}
 
 	for (i = 0; i <= path.cnt; i++) {
 		ibnd_port_t *remote_port = NULL;
@@ -464,7 +450,7 @@ int ibnd_set_max_smps_on_wire(int i)
 	return rc;
 }
 
-ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port *ibmad_port,
+ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 				    ib_portid_t * from, int hops)
 {
 	ibnd_fabric_t *fabric = NULL;
@@ -477,9 +463,8 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port *ibmad_port,
 		return NULL;
 
 	/* if not everything how much? */
-	if (hops >= 0) {
+	if (hops >= 0)
 		max_hops = hops;
-	}
 
 	/* If not specified start from "my" port */
 	if (!from)
@@ -493,17 +478,16 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port *ibmad_port,
 
 	memset(fabric, 0, sizeof(*fabric));
 
-	memset(&(scan.selfportid), 0, sizeof(scan.selfportid));
+	memset(&scan.selfportid, 0, sizeof(scan.selfportid));
 	scan.fabric = fabric;
 
 	smp_engine_init(&engine, ibmad_port, &scan, max_smps_on_wire);
 
 	IBND_DEBUG("from %s\n", portid2str(from));
 
-	if (!query_node_info(&engine, from, NULL)) {
+	if (!query_node_info(&engine, from, NULL))
 		if (process_mads(&engine) != 0)
 			goto error;
-	}
 
 	if (group_nodes(fabric))
 		goto error;
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
index d94b85a..26157d7 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
@@ -34,7 +34,7 @@
  */
 
 #if HAVE_CONFIG_H
-#  include <config.h>
+#include <config.h>
 #endif				/* HAVE_CONFIG_H */
 
 #define _GNU_SOURCE
@@ -377,8 +377,8 @@ static int _load_node(int fd, ibnd_fabric_cache_t * fabric_cache)
 					  &node_cache->port_cache_keys[i].guid);
 			offset +=
 			    _unmarshall8(buf + offset,
-					 &node_cache->port_cache_keys[i].
-					 portnum);
+					 &node_cache->
+					 port_cache_keys[i].portnum);
 		}
 	}
 
@@ -573,8 +573,7 @@ static int _rebuild_ports(ibnd_fabric_cache_t * fabric_cache)
 
 		if (port_cache->remoteport_flag) {
 			if (!(remoteport_cache = _find_port(fabric_cache,
-							    &port_cache->
-							    remoteport_cache_key)))
+							    &port_cache->remoteport_cache_key)))
 			{
 				IBND_DEBUG
 				    ("Cache invalid: cannot find remote port\n");
diff --git a/infiniband-diags/libibnetdisc/src/internal.h b/infiniband-diags/libibnetdisc/src/internal.h
index 61b644d..179eac6 100644
--- a/infiniband-diags/libibnetdisc/src/internal.h
+++ b/infiniband-diags/libibnetdisc/src/internal.h
@@ -60,36 +60,35 @@ typedef struct ibnd_scan {
 	ibnd_fabric_t *fabric;
 } ibnd_scan_t;
 
-
 typedef struct ibnd_smp ibnd_smp_t;
 typedef struct smp_engine smp_engine_t;
-typedef int (*smp_comp_cb_t)(smp_engine_t *engine, ibnd_smp_t * smp,
-			     uint8_t *mad_resp, void *cb_data);
+typedef int (*smp_comp_cb_t) (smp_engine_t * engine, ibnd_smp_t * smp,
+			      uint8_t * mad_resp, void *cb_data);
 struct ibnd_smp {
 	cl_map_item_t on_wire;
-	struct ibnd_smp * qnext;
+	struct ibnd_smp *qnext;
 	smp_comp_cb_t cb;
-	void * cb_data;
+	void *cb_data;
 	ib_portid_t path;
 	ib_rpc_t rpc;
 };
+
 struct smp_engine {
 	struct ibmad_port *ibmad_port;
 	ibnd_smp_t *smp_queue_head;
 	ibnd_smp_t *smp_queue_tail;
-	void * user_data;
+	void *user_data;
 	cl_qmap_t smps_on_wire;
 	int num_smps_outstanding;
 	int max_smps_on_wire;
 };
 
 void smp_engine_init(smp_engine_t * engine, struct ibmad_port *ibmad_port,
-		     void * user_data, int max_smps_on_wire);
-int issue_smp(smp_engine_t *engine, ib_portid_t * portid,
-	      unsigned attrid, unsigned mod,
-	      smp_comp_cb_t cb, void * cb_data);
-int process_mads(smp_engine_t *engine);
-void smp_engine_destroy(smp_engine_t *engine);
+		     void *user_data, int max_smps_on_wire);
+int issue_smp(smp_engine_t * engine, ib_portid_t * portid,
+	      unsigned attrid, unsigned mod, smp_comp_cb_t cb, void *cb_data);
+int process_mads(smp_engine_t * engine);
+void smp_engine_destroy(smp_engine_t * engine);
 
 void add_to_nodeguid_hash(ibnd_node_t * node, ibnd_node_t * hash[]);
 
diff --git a/infiniband-diags/libibnetdisc/src/query_smp.c b/infiniband-diags/libibnetdisc/src/query_smp.c
index 1ace05e..a6878b6 100644
--- a/infiniband-diags/libibnetdisc/src/query_smp.c
+++ b/infiniband-diags/libibnetdisc/src/query_smp.c
@@ -36,8 +36,7 @@
 #include <infiniband/umad.h>
 #include "internal.h"
 
-void
-queue_smp(smp_engine_t *engine, ibnd_smp_t *smp)
+static void queue_smp(smp_engine_t * engine, ibnd_smp_t * smp)
 {
 	smp->qnext = NULL;
 	if (!engine->smp_queue_head) {
@@ -49,8 +48,7 @@ queue_smp(smp_engine_t *engine, ibnd_smp_t *smp)
 	}
 }
 
-ibnd_smp_t *
-get_smp(smp_engine_t *engine)
+static ibnd_smp_t *get_smp(smp_engine_t * engine)
 {
 	ibnd_smp_t *head = engine->smp_queue_head;
 	ibnd_smp_t *tail = engine->smp_queue_tail;
@@ -63,7 +61,7 @@ get_smp(smp_engine_t *engine)
 	return rc;
 }
 
-int send_smp(ibnd_smp_t * smp, struct ibmad_port *srcport)
+static int send_smp(ibnd_smp_t * smp, struct ibmad_port *srcport)
 {
 	int rc = 0;
 	uint8_t umad[1024];
@@ -89,7 +87,7 @@ int send_smp(ibnd_smp_t * smp, struct ibmad_port *srcport)
 	return 0;
 }
 
-static int process_smp_queue(smp_engine_t *engine)
+static int process_smp_queue(smp_engine_t * engine)
 {
 	int rc = 0;
 	ibnd_smp_t *smp;
@@ -98,17 +96,16 @@ static int process_smp_queue(smp_engine_t *engine)
 		if (!smp)
 			return 0;
 
-		cl_qmap_insert(&engine->smps_on_wire, (uint32_t)smp->rpc.trid,
-			       (cl_map_item_t *)smp);
+		cl_qmap_insert(&engine->smps_on_wire, (uint32_t) smp->rpc.trid,
+			       (cl_map_item_t *) smp);
 		if ((rc = send_smp(smp, engine->ibmad_port)) != 0)
 			return rc;
 	}
 	return 0;
 }
 
-int issue_smp(smp_engine_t *engine, ib_portid_t * portid,
-	      unsigned attrid, unsigned mod,
-	      smp_comp_cb_t cb, void * cb_data)
+int issue_smp(smp_engine_t * engine, ib_portid_t * portid,
+	      unsigned attrid, unsigned mod, smp_comp_cb_t cb, void *cb_data)
 {
 	ibnd_smp_t *smp = calloc(1, sizeof *smp);
 	if (!smp) {
@@ -127,22 +124,21 @@ int issue_smp(smp_engine_t *engine, ib_portid_t * portid,
 	smp->rpc.dataoffs = IB_SMP_DATA_OFFS;
 	smp->rpc.trid = mad_trid();
 
-	if ((portid->lid <= 0) ||
-	    (portid->drpath.drslid == 0xffff) ||
-	    (portid->drpath.drdlid == 0xffff))
-		smp->rpc.mgtclass = IB_SMI_DIRECT_CLASS; /* direct SMI */
+	if (portid->lid <= 0 || portid->drpath.drslid == 0xffff ||
+	    portid->drpath.drdlid == 0xffff)
+		smp->rpc.mgtclass = IB_SMI_DIRECT_CLASS;	/* direct SMI */
 	else
-		smp->rpc.mgtclass = IB_SMI_CLASS; /* Lid routed SMI */
+		smp->rpc.mgtclass = IB_SMI_CLASS;	/* Lid routed SMI */
 
 	portid->sl = 0;
 	portid->qp = 0;
 
 	engine->num_smps_outstanding++;
 	queue_smp(engine, smp);
-	return (process_smp_queue(engine));
+	return process_smp_queue(engine);
 }
 
-int process_one_recv(smp_engine_t *engine)
+static int process_one_recv(smp_engine_t * engine)
 {
 	int rc = 0;
 	int status = 0;
@@ -166,12 +162,11 @@ int process_one_recv(smp_engine_t *engine)
 	rc = process_smp_queue(engine);
 
 	mad = umad_get_mad(umad);
-	trid = (uint32_t)mad_get_field64(mad, 0, IB_MAD_TRID_F);
+	trid = (uint32_t) mad_get_field64(mad, 0, IB_MAD_TRID_F);
 
-	smp = (ibnd_smp_t *)cl_qmap_remove(&engine->smps_on_wire, trid);
-	if ((cl_map_item_t *)smp == cl_qmap_end(&engine->smps_on_wire)) {
-		IBND_ERROR("Failed to find matching smp for trid (%x)\n",
-			   trid);
+	smp = (ibnd_smp_t *) cl_qmap_remove(&engine->smps_on_wire, trid);
+	if ((cl_map_item_t *) smp == cl_qmap_end(&engine->smps_on_wire)) {
+		IBND_ERROR("Failed to find matching smp for trid (%x)\n", trid);
 		return -1;
 	}
 
@@ -180,27 +175,25 @@ int process_one_recv(smp_engine_t *engine)
 
 	if ((status = umad_status(umad))) {
 		IBND_ERROR("umad (%s Attr 0x%x:%u) bad status %d; %s\n",
-			portid2str(&smp->path),
-			smp->rpc.attr.id, smp->rpc.attr.mod,
-			status, strerror(status));
+			   portid2str(&smp->path), smp->rpc.attr.id,
+			   smp->rpc.attr.mod, status, strerror(status));
 	} else if ((status = mad_get_field(mad, 0, IB_DRSMP_STATUS_F))) {
-			IBND_ERROR("mad (%s Attr 0x%x:%u) bad status 0x%x\n",
-				   portid2str(&smp->path),
-				   smp->rpc.attr.id, smp->rpc.attr.mod,
-				   status);
+		IBND_ERROR("mad (%s Attr 0x%x:%u) bad status 0x%x\n",
+			   portid2str(&smp->path), smp->rpc.attr.id,
+			   smp->rpc.attr.mod, status);
 	} else
 		rc = smp->cb(engine, smp, mad, smp->cb_data);
 
 error:
 	free(smp);
 	engine->num_smps_outstanding--;
-	return (rc);
+	return rc;
 }
 
 void smp_engine_init(smp_engine_t * engine, struct ibmad_port *ibmad_port,
-		     void * user_data, int max_smps_on_wire)
+		     void *user_data, int max_smps_on_wire)
 {
-	memset(engine, '\0', sizeof(*engine));
+	memset(engine, 0, sizeof(*engine));
 	engine->ibmad_port = ibmad_port;
 	engine->user_data = user_data;
 	cl_qmap_init(&engine->smps_on_wire);
@@ -208,7 +201,7 @@ void smp_engine_init(smp_engine_t * engine, struct ibmad_port *ibmad_port,
 	engine->max_smps_on_wire = max_smps_on_wire;
 }
 
-void smp_engine_destroy(smp_engine_t *engine)
+void smp_engine_destroy(smp_engine_t * engine)
 {
 	cl_map_item_t *item;
 	ibnd_smp_t *smp;
@@ -217,15 +210,14 @@ void smp_engine_destroy(smp_engine_t *engine)
 	smp = get_smp(engine);
 	if (smp)
 		IBND_ERROR("outstanding SMP's\n");
-	for (/* */; smp; smp = get_smp(engine)) {
+	for ( /* */ ; smp; smp = get_smp(engine))
 		free(smp);
-	}
 
 	/* remove smps from the wire queue */
 	item = cl_qmap_head(&engine->smps_on_wire);
 	if (item != cl_qmap_end(&engine->smps_on_wire))
 		IBND_ERROR("outstanding SMP's on wire\n");
-	for (/* */; item != cl_qmap_end(&engine->smps_on_wire);
+	for ( /* */ ; item != cl_qmap_end(&engine->smps_on_wire);
 	     item = cl_qmap_head(&engine->smps_on_wire)) {
 		cl_qmap_remove_item(&engine->smps_on_wire, item);
 		free(item);
@@ -234,7 +226,7 @@ void smp_engine_destroy(smp_engine_t *engine)
 	engine->num_smps_outstanding = 0;
 }
 
-int process_mads(smp_engine_t *engine)
+int process_mads(smp_engine_t * engine)
 {
 	int rc = 0;
 	while (engine->num_smps_outstanding > 0) {
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
