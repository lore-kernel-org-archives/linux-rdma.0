From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/2] libibnetdisc: Convert to a multi-smp algorithm
Date: Tue, 2 Feb 2010 16:45:34 -0800
Message-ID: <20100202164534.07ea7556.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Fri, 22 Jan 2010 17:33:30 -0800
Subject: [PATCH] libibnetdisc: Convert to a multi-smp algorithm

	Allow for multiple SMP's to be on the wire at a single time.  This
	algorithm splits the processing of SMP's to a small smp engine which
	may be useful to split out in the future.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/libibnetdisc/Makefile.am     |    2 +-
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |  626 ++++++++++---------------
 infiniband-diags/libibnetdisc/src/internal.h  |   39 ++-
 infiniband-diags/libibnetdisc/src/query_smp.c |  249 ++++++++++
 4 files changed, 535 insertions(+), 381 deletions(-)
 create mode 100644 infiniband-diags/libibnetdisc/src/query_smp.c

diff --git a/infiniband-diags/libibnetdisc/Makefile.am b/infiniband-diags/libibnetdisc/Makefile.am
index a46dbc8..f30d3cc 100644
--- a/infiniband-diags/libibnetdisc/Makefile.am
+++ b/infiniband-diags/libibnetdisc/Makefile.am
@@ -23,7 +23,7 @@ libibnetdisc_version_script =
 endif
 
 libibnetdisc_la_SOURCES = src/ibnetdisc.c src/ibnetdisc_cache.c src/chassis.c \
-			  src/chassis.h src/internal.h
+			  src/chassis.h src/internal.h src/query_smp.c
 libibnetdisc_la_CFLAGS = -Wall $(DBGFLAGS)
 libibnetdisc_la_LDFLAGS = -version-info $(ibnetdisc_api_version) \
 	-export-dynamic $(libibnetdisc_version_script) \
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index d0c97a1..7a9adbc 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -57,100 +57,32 @@
 static int show_progress = 0;
 int ibdebug;
 
-int query_port_info(struct ibmad_port *ibmad_port, ib_portid_t * portid,
-		    int portnum, ibnd_port_t * port)
-{
-	char width[64], speed[64];
-	int iwidth;
-	int ispeed;
-
-	if (!smp_query_via(port->info, portid, IB_ATTR_PORT_INFO,
-			   portnum, 0, ibmad_port))
-		return -1;
-
-	port->base_lid = (uint16_t) mad_get_field(port->info, 0, IB_PORT_LID_F);
-	port->lmc = (uint8_t) mad_get_field(port->info, 0, IB_PORT_LMC_F);
-	port->portnum = portnum;
-
-	iwidth = mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
-	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
-	IBND_DEBUG
-	    ("portid %s portnum %d: base lid %d state %d physstate %d %s %s\n",
-	     portid2str(portid), portnum, port->base_lid,
-	     mad_get_field(port->info, 0, IB_PORT_STATE_F),
-	     mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F),
-	     mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64, &iwidth),
-	     mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64, &ispeed));
+/* forward declare */
+int query_node_info(smp_engine_t * engine, ib_portid_t * portid,
+		    ibnd_node_t * node);
 
-	return 0;
-}
 
-static int query_node_info(struct ibmad_port *ibmad_port,
-			   ibnd_fabric_t * fabric, ibnd_node_t * node,
-			   ib_portid_t * portid)
+static int recv_switch_info(smp_engine_t *engine, ibnd_smp_t * smp,
+			    uint8_t *mad, void *cb_data)
 {
-	if (!smp_query_via(&(node->info), portid, IB_ATTR_NODE_INFO, 0, 0,
-			   ibmad_port))
-		return -1;
-
-	/* decode just a couple of fields for quicker reference. */
-	mad_decode_field(node->info, IB_NODE_GUID_F, &(node->guid));
-	mad_decode_field(node->info, IB_NODE_TYPE_F, &(node->type));
-	mad_decode_field(node->info, IB_NODE_NPORTS_F, &(node->numports));
-
+	uint8_t *switch_info = mad + IB_SMP_DATA_OFFS;
+	ibnd_node_t * node = (ibnd_node_t *)cb_data;
+	memcpy(node->switchinfo, switch_info, sizeof(node->switchinfo));
+	mad_decode_field(node->switchinfo, IB_SW_ENHANCED_PORT0_F,
+			 &node->smaenhsp0);
 	return 0;
 }
-
-static int query_node(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
-		      ibnd_node_t * node, ibnd_port_t * port,
-		      ib_portid_t * portid)
+static int query_switch_info(smp_engine_t * engine, ib_portid_t * portid,
+		      ibnd_node_t *node)
 {
-	int rc = 0;
-	void *nd = node->nodedesc;
-
-	if ((rc = query_node_info(ibmad_port, fabric, node, portid)) != 0)
-		return rc;
-
-	if (!smp_query_via(nd, portid, IB_ATTR_NODE_DESC, 0, 0, ibmad_port))
-		return -1;
-
-	if ((rc = query_port_info(ibmad_port, portid, 0, port)) != 0)
-		return rc;
-
-	port->portnum = mad_get_field(node->info, 0, IB_NODE_LOCAL_PORT_F);
-	port->guid = mad_get_field64(node->info, 0, IB_NODE_PORT_GUID_F);
-
-	if (node->type != IB_NODE_SWITCH)
-		return 0;
-
-	node->smalid = port->base_lid;
-	node->smalmc = port->lmc;
-
-	/* after we have the sma information find out the "real" PortInfo for
-	 * the external port */
-	if ((rc =
-	     query_port_info(ibmad_port, portid, port->portnum, port)) != 0)
-		return rc;
-
-	port->base_lid = (uint16_t) node->smalid;	/* LID is still defined by port 0 */
-	port->lmc = (uint8_t) node->smalmc;
-
-	if (!smp_query_via(node->switchinfo, portid, IB_ATTR_SWITCH_INFO, 0, 0,
-			   ibmad_port))
-		node->smaenhsp0 = 0;	/* assume base SP0 */
-	else
-		mad_decode_field(node->switchinfo, IB_SW_ENHANCED_PORT0_F,
-				 &node->smaenhsp0);
-
-	IBND_DEBUG("portid %s: got switch node %" PRIx64 " '%s'\n",
-		   portid2str(portid), node->guid, node->nodedesc);
-	return 0;
+	node->smaenhsp0 = 0;	/* assume base SP0 */
+	return (issue_smp(engine, portid, IB_ATTR_SWITCH_INFO, 0, recv_switch_info,
+			  (void *)node));
 }
 
 static int add_port_to_dpath(ib_dr_path_t * path, int nextport)
 {
 	if (path->cnt + 2 >= sizeof(path->p)) {
-		IBND_ERROR("DR path has grown too long\n");
 		return -1;
 	}
 	++path->cnt;
@@ -158,6 +90,7 @@ static int add_port_to_dpath(ib_dr_path_t * path, int nextport)
 	return path->cnt;
 }
 
+#if 0
 static void retract_dpath(ib_portid_t * path)
 {
 	path->drpath.cnt--;	/* restore path */
@@ -167,17 +100,19 @@ static void retract_dpath(ib_portid_t * path)
 		path->drpath.drdlid = 0;
 	}
 }
+#endif
 
-static int extend_dpath(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
-			ibnd_scan_t * scan, ib_portid_t * portid, int nextport)
+static int extend_dpath(smp_engine_t * engine, ib_portid_t * portid, int nextport)
 {
 	int rc = 0;
+	ibnd_scan_t *scan = (ibnd_scan_t *)engine->user_data;
+	ibnd_fabric_t *fabric = scan->fabric;
 
 	if (portid->lid) {
 		/* If we were LID routed we need to set up the drslid */
 		if (!scan->selfportid.lid)
 			if (ib_resolve_self_via(&scan->selfportid, NULL, NULL,
-						ibmad_port) < 0) {
+						engine->ibmad_port) < 0) {
 				IBND_ERROR("Failed to resolve self\n");
 				return -1;
 			}
@@ -187,38 +122,238 @@ static int extend_dpath(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
 	}
 
 	rc = add_port_to_dpath(&portid->drpath, nextport);
+	if (rc < 0)
+		IBND_ERROR("add port %d to DR path failed; %s\n", nextport,
+			   portid2str(portid));
 
 	if (rc != -1 && portid->drpath.cnt > fabric->maxhops_discovered)
 		fabric->maxhops_discovered = portid->drpath.cnt;
 	return rc;
 }
 
-static void dump_endnode(ib_portid_t * path, char *prompt,
-			 ibnd_node_t * node, ibnd_port_t * port)
+static int recv_node_desc(smp_engine_t * engine, ibnd_smp_t * smp,
+			  uint8_t *mad, void *cb_data)
 {
-	char type[64];
-	if (!show_progress)
-		return;
+	uint8_t *node_desc = mad + IB_SMP_DATA_OFFS;
+	ibnd_node_t *node = (ibnd_node_t *)cb_data;
+	memcpy(node->nodedesc, node_desc, sizeof(node->nodedesc));
+	return 0;
+}
+
+int query_node_desc(smp_engine_t * engine, ib_portid_t * portid, ibnd_node_t *node)
+{
+	return (issue_smp(engine, portid, IB_ATTR_NODE_DESC, 0, recv_node_desc,
+			  (void *)node));
+}
+
+static void debug_port(ib_portid_t *portid, ibnd_port_t * port)
+{
+	char width[64], speed[64];
+	int iwidth;
+	int ispeed;
+
+	iwidth = mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
+	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
+	IBND_DEBUG
+	    ("portid %s portnum %d: base lid %d state %d physstate %d %s %s\n",
+	     portid2str(portid), port->portnum, port->base_lid,
+	     mad_get_field(port->info, 0, IB_PORT_STATE_F),
+	     mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F),
+	     mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64, &iwidth),
+	     mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64, &ispeed));
+}
+
+static int recv_port_info(smp_engine_t *engine, ibnd_smp_t * smp,
+			  uint8_t *mad, void *cb_data)
+{
+	ibnd_fabric_t *fabric = ((ibnd_scan_t *)engine->user_data)->fabric;
+	ibnd_node_t *node = (ibnd_node_t *)cb_data;
+	ibnd_port_t *port;
+	uint8_t *port_info = mad + IB_SMP_DATA_OFFS;
+	uint8_t port_num, local_port;
+
+	port_num = mad_get_field(mad, 0, IB_MAD_ATTRMOD_F);
+	local_port = mad_get_field(port_info, 0, IB_PORT_LOCAL_PORT_F);
+
+	/* this may have been created before */
+	port = node->ports[port_num];
+	if (!port) {
+		port = node->ports[port_num] = calloc(1, sizeof(*port));
+		if (!port) {
+			IBND_ERROR("Failed to allocate port\n");
+			return -1;
+		}
+	}
+
+	memcpy(port->info, port_info, sizeof(port->info));
+	port->node = node;
+	port->portnum = port_num;
+	port->ext_portnum = 0;
+	port->base_lid = (uint16_t) mad_get_field(port->info, 0, IB_PORT_LID_F);
+	port->lmc = (uint8_t) mad_get_field(port->info, 0, IB_PORT_LMC_F);
+
+	if (port_num == 0) {
+		node->smalid = port->base_lid;
+		node->smalmc = port->lmc;
+	} else if (node->type == IB_NODE_SWITCH) {
+		port->base_lid = node->smalid;
+		port->lmc = node->smalmc;
+	}
+
+	add_to_portguid_hash(port, fabric->portstbl);
+
+	debug_port(&smp->path, port);
 
-	mad_dump_node_type(type, 64, &node->type, sizeof(int));
-	printf("%s -> %s %s {%016" PRIx64 "} portnum %d base lid %d-%d\"%s\"\n",
-	       portid2str(path), prompt, type, node->guid,
-	       node->type == IB_NODE_SWITCH ? 0 : port->portnum,
-	       port->base_lid,
-	       port->base_lid + (1 << port->lmc) - 1, node->nodedesc);
+	if (port_num &&
+	    (mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
+	    == IB_PORT_PHYS_STATE_LINKUP)
+		&&
+	    (node->type == IB_NODE_SWITCH || node == fabric->from_node)) {
+
+		ib_portid_t path = smp->path;
+		if (extend_dpath(engine, &path, port_num) != -1)
+			query_node_info(engine, &path, node);
+	}
+
+	return 0;
+}
+int query_port_info(smp_engine_t * engine, ib_portid_t * portid,
+		    ibnd_node_t *node, int portnum)
+{
+	IBND_DEBUG("Query Port Info; %s (%lx):%d\n", portid2str(portid),
+		   node->guid, portnum);
+	return (issue_smp(engine, portid, IB_ATTR_PORT_INFO, portnum, recv_port_info,
+			  (void *)node));
 }
 
-static ibnd_node_t *find_existing_node(ibnd_fabric_t * fabric,
-				       ibnd_node_t * new)
+static ibnd_node_t *create_node(smp_engine_t * engine, ib_portid_t * path,
+				uint8_t *node_info)
 {
-	int hash = HASHGUID(new->guid) % HTSZ;
+	ibnd_fabric_t *fabric = ((ibnd_scan_t *)engine->user_data)->fabric;
+	ibnd_node_t *rc = calloc(1, sizeof(*rc));
+	if (!rc) {
+		IBND_ERROR("OOM: node creation failed\n");
+		return NULL;
+	}
+
+	/* decode just a couple of fields for quicker reference. */
+	mad_decode_field(node_info, IB_NODE_GUID_F, &(rc->guid));
+	mad_decode_field(node_info, IB_NODE_TYPE_F, &(rc->type));
+	mad_decode_field(node_info, IB_NODE_NPORTS_F, &(rc->numports));
+
+	rc->ports = calloc(rc->numports + 1, sizeof(*rc->ports));
+	if (!rc->ports) {
+		free(rc);
+		IBND_ERROR("OOM: Failed to allocate the ports array\n");
+		return NULL;
+	}
+
+	rc->path_portid = *path;
+	memcpy(rc->info, node_info, sizeof(rc->info));
+
+	add_to_nodeguid_hash(rc, fabric->nodestbl);
+
+	/* add this to the all nodes list */
+	rc->next = fabric->nodes;
+	fabric->nodes = rc;
+
+	add_to_type_list(rc, fabric);
+
+	return rc;
+}
+
+static int get_last_port(ib_portid_t * path)
+{
+	return (path->drpath.p[path->drpath.cnt]);
+}
+static void link_ports(ibnd_node_t * node, ibnd_port_t * port,
+		       ibnd_node_t * remotenode, ibnd_port_t * remoteport)
+{
+	IBND_DEBUG("linking: 0x%" PRIx64 " %p->%p:%u and 0x%" PRIx64
+		   " %p->%p:%u\n", node->guid, node, port, port->portnum,
+		   remotenode->guid, remotenode, remoteport,
+		   remoteport->portnum);
+	if (port->remoteport)
+		port->remoteport->remoteport = NULL;
+	if (remoteport->remoteport)
+		remoteport->remoteport->remoteport = NULL;
+	port->remoteport = (ibnd_port_t *) remoteport;
+	remoteport->remoteport = (ibnd_port_t *) port;
+}
+
+static int recv_node_info(smp_engine_t *engine, ibnd_smp_t * smp,
+			  uint8_t *mad, void *cb_data)
+{
+	ibnd_fabric_t *fabric = ((ibnd_scan_t *)engine->user_data)->fabric;
+	int i = 0;
+	uint8_t *node_info = mad + IB_SMP_DATA_OFFS;
+	ibnd_node_t * rem_node = (ibnd_node_t *)cb_data;
 	ibnd_node_t *node;
+	int node_is_new = 0;
+	uint64_t node_guid = mad_get_field64(node_info, 0, IB_NODE_GUID_F);
+	uint64_t port_guid = mad_get_field64(node_info, 0, IB_NODE_PORT_GUID_F);
+	int port_num = mad_get_field(node_info, 0, IB_NODE_LOCAL_PORT_F);
+	ibnd_port_t *port = NULL;
 
-	for (node = fabric->nodestbl[hash]; node; node = node->htnext)
-		if (node->guid == new->guid)
-			return node;
+	node = ibnd_find_node_guid(fabric, node_guid);
+	if (!node) {
+		node = create_node(engine, &smp->path, node_info);
+		if (!node)
+			return -1;
+		node_is_new = 1;
+	}
+	IBND_DEBUG("Found %s node GUID %lx (%s)\n",
+		   (node_is_new) ? "new": "old", node->guid,
+		   portid2str(&smp->path));
 
-	return NULL;
+	port = node->ports[port_num];
+	if (!port) {
+		/* If we have not see this port before create a shell for it */
+		port = node->ports[port_num] = calloc(1, sizeof(*port));
+		port->node = node;
+		port->portnum = port_num;
+	}
+	port->guid = port_guid;
+
+	if (rem_node == NULL) /* this is the start node */
+		fabric->from_node = node;
+	else {
+		/* link ports... */
+		int rem_port_num = get_last_port(&smp->path);
+
+		if (!rem_node->ports[rem_port_num]) {
+			IBND_ERROR("Internal Error; "
+				   "Node(%p) %lx Port %d no port created!?!?!?\n\n",
+				   rem_node, rem_node->guid, rem_port_num);
+			return (-1);
+		}
+
+		link_ports(node, port, rem_node, rem_node->ports[rem_port_num]);
+	}
+
+	if (!node_is_new)
+		return 0;
+
+	query_node_desc(engine, &smp->path, node);
+
+	if (node->type == IB_NODE_SWITCH)
+		query_switch_info(engine, &smp->path, node);
+
+	/* process all the ports on this node */
+	for (i = (node->type == IB_NODE_SWITCH) ? 0 : 1;
+		i <= node->numports; i++) {
+			query_port_info(engine, &smp->path, node, i);
+	}
+
+	return 0;
+}
+
+int query_node_info(smp_engine_t * engine, ib_portid_t * portid,
+		    ibnd_node_t * node)
+{
+	IBND_DEBUG("Query Node Info; %s\n", portid2str(portid));
+	return (issue_smp(engine, portid, IB_ATTR_NODE_INFO, 0, recv_node_info,
+			  (void *)node));
 }
 
 ibnd_node_t *ibnd_find_node_guid(ibnd_fabric_t * fabric, uint64_t guid)
@@ -321,205 +456,13 @@ void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric)
 	}
 }
 
-static int add_to_nodedist(ibnd_node_t * node, ibnd_scan_t * scan,
-			   ib_portid_t * path, int dist)
-{
-	ibnd_node_scan_t *node_scan;
-
-	node_scan = malloc(sizeof(*node_scan));
-	if (!node_scan) {
-		IBND_ERROR("OOM: node scan creation failed\n");
-		return -1;
-	}
-	node_scan->node = node;
-
-	if (node->type != IB_NODE_SWITCH)
-		dist = MAXHOPS;	/* special Ca list */
-
-	node_scan->dnext = scan->nodesdist[dist];
-	scan->nodesdist[dist] = node_scan;
-
-	return 0;
-}
-
-static ibnd_node_t *create_node(ibnd_fabric_t * fabric, ibnd_scan_t * scan,
-				ibnd_node_t * temp, ib_portid_t * path,
-				int dist)
-{
-	ibnd_node_t *node;
-
-	node = malloc(sizeof(*node));
-	if (!node) {
-		IBND_ERROR("OOM: node creation failed\n");
-		return NULL;
-	}
-
-	memcpy(node, temp, sizeof(*node));
-	node->path_portid = *path;
-
-	add_to_nodeguid_hash(node, fabric->nodestbl);
-
-	/* add this to the all nodes list */
-	node->next = fabric->nodes;
-	fabric->nodes = node;
-
-	add_to_type_list(node, fabric);
-
-	if (add_to_nodedist(node, scan, path, dist) < 0) {
-		free(node);
-		return NULL;
-	}
-
-	return node;
-}
-
-static struct ibnd_port *find_existing_port_node(ibnd_node_t * node,
-						 ibnd_port_t * port)
-{
-	if (port->portnum > node->numports || node->ports == NULL)
-		return NULL;
-
-	return node->ports[port->portnum];
-}
-
-static struct ibnd_port *add_port_to_node(ibnd_fabric_t * fabric,
-					  ibnd_node_t * node,
-					  ibnd_port_t * temp)
-{
-	ibnd_port_t *port;
-
-	if (node->ports == NULL) {
-		node->ports = calloc(sizeof(*node->ports), node->numports + 1);
-		if (!node->ports) {
-			IBND_ERROR("Failed to allocate the ports array\n");
-			return NULL;
-		}
-	}
-
-	port = malloc(sizeof(*port));
-	if (!port) {
-		IBND_ERROR("Failed to allocate port\n");
-		return NULL;
-	}
-
-	memcpy(port, temp, sizeof(*port));
-	port->node = node;
-	port->ext_portnum = 0;
-
-	node->ports[temp->portnum] = port;
-
-	add_to_portguid_hash(port, fabric->portstbl);
-	return port;
-}
-
-static void link_ports(ibnd_node_t * node, ibnd_port_t * port,
-		       ibnd_node_t * remotenode, ibnd_port_t * remoteport)
-{
-	IBND_DEBUG("linking: 0x%" PRIx64 " %p->%p:%u and 0x%" PRIx64
-		   " %p->%p:%u\n", node->guid, node, port, port->portnum,
-		   remotenode->guid, remotenode, remoteport,
-		   remoteport->portnum);
-	if (port->remoteport)
-		port->remoteport->remoteport = NULL;
-	if (remoteport->remoteport)
-		remoteport->remoteport->remoteport = NULL;
-	port->remoteport = (ibnd_port_t *) remoteport;
-	remoteport->remoteport = (ibnd_port_t *) port;
-}
-
-static int get_remote_node(struct ibmad_port *ibmad_port,
-			   ibnd_fabric_t * fabric, ibnd_scan_t * scan,
-			   ibnd_node_t * node, ibnd_port_t * port,
-			   ib_portid_t * path, int portnum, int dist)
-{
-	int rc = 0;
-	ibnd_node_t node_buf;
-	ibnd_port_t port_buf;
-	ibnd_node_t *remotenode, *oldnode;
-	ibnd_port_t *remoteport, *oldport;
-
-	memset(&node_buf, 0, sizeof(node_buf));
-	memset(&port_buf, 0, sizeof(port_buf));
-
-	IBND_DEBUG("handle node %p port %p:%d dist %d\n", node, port, portnum,
-		   dist);
-
-	if (mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
-	    != IB_PORT_PHYS_STATE_LINKUP)
-		return 1;	/* positive == non-fatal error */
-
-	if (portnum > 0 && extend_dpath(ibmad_port, fabric, scan, path,
-					portnum) < 0)
-		return -1;
-
-	if (query_node(ibmad_port, fabric, &node_buf, &port_buf, path)) {
-		IBND_ERROR("Query remote node (%s) failed, skipping port\n",
-			   portid2str(path));
-		retract_dpath(path);
-		return 1;	/* positive == non-fatal error */
-	}
-
-	oldnode = find_existing_node(fabric, &node_buf);
-	if (oldnode)
-		remotenode = oldnode;
-	else if (!(remotenode = create_node(fabric, scan, &node_buf, path,
-					    dist + 1))) {
-		rc = -1;
-		goto error;
-	}
-
-	oldport = find_existing_port_node(remotenode, &port_buf);
-	if (oldport)
-		remoteport = oldport;
-	else if (!(remoteport = add_port_to_node(fabric, remotenode,
-						 &port_buf))) {
-		IBND_ERROR("OOM failed to add port to node\n");
-		rc = -1;
-		goto error;
-	}
-
-	dump_endnode(path, oldnode ? "known remote" : "new remote",
-		     remotenode, remoteport);
-
-	link_ports(node, port, remotenode, remoteport);
-
-error:
-	retract_dpath(path);
-	return rc;
-}
-
-static void ibnd_scan_destroy(ibnd_scan_t * scan)
-{
-	int dist = 0;
-	int max_hops = MAXHOPS - 1;
-	ibnd_node_scan_t *node_scan;
-	ibnd_node_scan_t *next;
-
-	for (dist = 0; dist <= max_hops; dist++) {
-		node_scan = scan->nodesdist[dist];
-		while (node_scan) {
-			next = node_scan->dnext;
-			free(node_scan);
-			node_scan = next;
-		}
-	}
-}
-
 ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port *ibmad_port,
 				    ib_portid_t * from, int hops)
 {
-	int rc = 0;
 	ibnd_fabric_t *fabric = NULL;
 	ib_portid_t my_portid = { 0 };
-	ibnd_node_t node_buf;
-	ibnd_port_t port_buf;
-	ibnd_node_t *node;
-	ibnd_node_scan_t *node_scan;
-	ibnd_port_t *port;
-	int i;
-	int dist = 0;
-	ib_portid_t *path;
 	int max_hops = MAXHOPS - 1;	/* default find everything */
+	smp_engine_t engine;
 	ibnd_scan_t scan;
 
 	if (_check_ibmad_port(ibmad_port) < 0)
@@ -534,100 +477,33 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port *ibmad_port,
 	if (!from)
 		from = &my_portid;
 
-	fabric = malloc(sizeof(*fabric));
-
+	fabric = calloc(1, sizeof(*fabric));
 	if (!fabric) {
-		IBND_ERROR("OOM: failed to malloc ibnd_fabric_t\n");
+		IBND_ERROR("OOM: failed to calloc ibnd_fabric_t\n");
 		return NULL;
 	}
 
 	memset(fabric, 0, sizeof(*fabric));
 
-	memset(&scan, '\0', sizeof(ibnd_scan_t));
-
-	IBND_DEBUG("from %s\n", portid2str(from));
-
-	memset(&node_buf, 0, sizeof(node_buf));
-	memset(&port_buf, 0, sizeof(port_buf));
+	memset(&(scan.selfportid), 0, sizeof(scan.selfportid));
+	scan.fabric = fabric;
 
-	if (query_node(ibmad_port, fabric, &node_buf, &port_buf, from)) {
-		IBND_DEBUG("can't reach node %s\n", portid2str(from));
-		goto error;
-	}
-
-	node = create_node(fabric, &scan, &node_buf, from, 0);
-	if (!node)
-		goto error;
+	smp_engine_init(&engine, ibmad_port, &scan, DEFAULT_MAX_SMP_ON_WIRE);
 
-	fabric->from_node = (ibnd_node_t *) node;
-
-	port = add_port_to_node(fabric, node, &port_buf);
-	if (!port)
-		goto error;
+	IBND_DEBUG("from %s\n", portid2str(from));
 
-	rc = get_remote_node(ibmad_port, fabric, &scan, node, port, from,
-			     mad_get_field(node->info, 0, IB_NODE_LOCAL_PORT_F),
-			     0);
-	if (rc < 0)
-		goto error;
-	if (rc > 0)		/* non-fatal error, nothing more to be done */
-		return fabric;
-
-	for (dist = 0; dist <= max_hops; dist++) {
-
-		for (node_scan = scan.nodesdist[dist]; node_scan;
-		     node_scan = node_scan->dnext) {
-			node = node_scan->node;
-
-			path = &node->path_portid;
-
-			IBND_DEBUG("dist %d node %p\n", dist, node);
-			dump_endnode(path, "processing", node, port);
-
-			for (i = 1; i <= node->numports; i++) {
-				if (i == mad_get_field(node->info, 0,
-						       IB_NODE_LOCAL_PORT_F))
-					continue;
-
-				if (query_port_info(ibmad_port, path, i,
-						    &port_buf)) {
-					IBND_ERROR
-					    ("can't reach node %s port %d\n",
-					     portid2str(path), i);
-					continue;
-				}
-
-				port = find_existing_port_node(node, &port_buf);
-				if (port)
-					continue;
-
-				port =
-				    add_port_to_node(fabric, node, &port_buf);
-				if (!port)
-					goto error;
-
-				/* If switch, set port GUID to node port GUID */
-				if (node->type == IB_NODE_SWITCH) {
-					port->guid =
-					    mad_get_field64(node->info, 0,
-							    IB_NODE_PORT_GUID_F);
-				}
-
-				if (get_remote_node(ibmad_port, fabric, &scan,
-						    node, port, path, i,
-						    dist) < 0)
-					goto error;
-			}
-		}
+	if (!query_node_info(&engine, from, NULL)) {
+		if (process_mads(&engine) != 0)
+			goto error;
 	}
 
 	if (group_nodes(fabric))
 		goto error;
 
-	ibnd_scan_destroy(&scan);
+	smp_engine_destroy(&engine);
 	return fabric;
 error:
-	ibnd_scan_destroy(&scan);
+	smp_engine_destroy(&engine);
 	ibnd_destroy_fabric(fabric);
 	return NULL;
 }
diff --git a/infiniband-diags/libibnetdisc/src/internal.h b/infiniband-diags/libibnetdisc/src/internal.h
index 348bd0f..49803fd 100644
--- a/infiniband-diags/libibnetdisc/src/internal.h
+++ b/infiniband-diags/libibnetdisc/src/internal.h
@@ -39,6 +39,7 @@
 #define _INTERNAL_H_
 
 #include <infiniband/ibnetdisc.h>
+#include <complib/cl_qmap.h>
 
 #define	IBND_DEBUG(fmt, ...) \
 	if (ibdebug) { \
@@ -52,16 +53,44 @@
 
 #define MAXHOPS         63
 
-typedef struct ibnd_node_scan {
-	ibnd_node_t *node;
-	struct ibnd_node_scan *dnext;	/* nodesdist next */
-} ibnd_node_scan_t;
+#define DEFAULT_MAX_SMP_ON_WIRE 4
 
 typedef struct ibnd_scan {
-	ibnd_node_scan_t *nodesdist[MAXHOPS + 1];
 	ib_portid_t selfportid;
+	ibnd_fabric_t *fabric;
 } ibnd_scan_t;
 
+
+typedef struct ibnd_smp ibnd_smp_t;
+typedef struct smp_engine smp_engine_t;
+typedef int (*smp_comp_cb_t)(smp_engine_t *engine, ibnd_smp_t * smp,
+			     uint8_t *mad_resp, void *cb_data);
+struct ibnd_smp {
+	cl_map_item_t on_wire;
+	struct ibnd_smp * qnext;
+	smp_comp_cb_t cb;
+	void * cb_data;
+	ib_portid_t path;
+	ib_rpc_t rpc;
+};
+struct smp_engine {
+	struct ibmad_port *ibmad_port;
+	ibnd_smp_t *smp_queue_head;
+	ibnd_smp_t *smp_queue_tail;
+	void * user_data;
+	cl_qmap_t smps_on_wire;
+	int num_smps_outstanding;
+	int max_smps_on_wire;
+};
+
+void smp_engine_init(smp_engine_t * engine, struct ibmad_port *ibmad_port,
+		     void * user_data, int max_smps_on_wire);
+int issue_smp(smp_engine_t *engine, ib_portid_t * portid,
+	      unsigned attrid, unsigned mod,
+	      smp_comp_cb_t cb, void * cb_data);
+int process_mads(smp_engine_t *engine);
+void smp_engine_destroy(smp_engine_t *engine);
+
 void add_to_nodeguid_hash(ibnd_node_t * node, ibnd_node_t * hash[]);
 
 void add_to_portguid_hash(ibnd_port_t * port, ibnd_port_t * hash[]);
diff --git a/infiniband-diags/libibnetdisc/src/query_smp.c b/infiniband-diags/libibnetdisc/src/query_smp.c
new file mode 100644
index 0000000..5571314
--- /dev/null
+++ b/infiniband-diags/libibnetdisc/src/query_smp.c
@@ -0,0 +1,249 @@
+/*
+ * Copyright (c) 2010 Lawrence Livermore National Laboratory
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#include <errno.h>
+#include <infiniband/ibnetdisc.h>
+#include <infiniband/umad.h>
+#include "internal.h"
+
+void
+queue_smp(smp_engine_t *engine, ibnd_smp_t *smp)
+{
+	smp->qnext = NULL;
+	if (!engine->smp_queue_head) {
+		engine->smp_queue_head = smp;
+		engine->smp_queue_tail = smp;
+	} else {
+		engine->smp_queue_tail->qnext = smp;
+		engine->smp_queue_tail = smp;
+	}
+}
+
+ibnd_smp_t *
+get_smp(smp_engine_t *engine)
+{
+	ibnd_smp_t *head = engine->smp_queue_head;
+	ibnd_smp_t *tail = engine->smp_queue_tail;
+	ibnd_smp_t *rc = head;
+	if (head) {
+		if (tail == head)
+			engine->smp_queue_tail = NULL;
+		engine->smp_queue_head = head->qnext;
+	}
+	return rc;
+}
+
+int send_smp(ibnd_smp_t * smp, struct ibmad_port *srcport)
+{
+	int rc = 0;
+	uint8_t umad[1024];
+	ib_rpc_t *rpc = &smp->rpc;
+
+	memset(umad, 0, umad_size() + IB_MAD_SIZE);
+
+	if ((rc = mad_build_pkt(umad, &smp->rpc, &smp->path, NULL, NULL))
+	    < 0) {
+		IBND_ERROR("mad_build_pkt failed; %d", rc);
+		return rc;
+	}
+
+	if ((rc = umad_send(mad_rpc_portid(srcport),
+			    mad_rpc_class_agent(srcport, rpc->mgtclass),
+			    umad, IB_MAD_SIZE,
+			    mad_get_timeout(srcport, rpc->timeout),
+			    mad_get_retries(srcport))) < 0) {
+		IBND_ERROR("send failed; %d", rc);
+		return rc;
+	}
+
+	return 0;
+}
+
+static int process_smp_queue(smp_engine_t *engine)
+{
+	int rc = 0;
+	ibnd_smp_t *smp;
+	while (cl_qmap_count(&engine->smps_on_wire) < engine->max_smps_on_wire) {
+		smp = get_smp(engine);
+		if (!smp)
+			return 0;
+
+		cl_qmap_insert(&engine->smps_on_wire, (uint32_t)smp->rpc.trid,
+			       (cl_map_item_t *)smp);
+		if ((rc = send_smp(smp, engine->ibmad_port)) != 0)
+			return rc;
+	}
+	return 0;
+}
+
+int issue_smp(smp_engine_t *engine, ib_portid_t * portid,
+	      unsigned attrid, unsigned mod,
+	      smp_comp_cb_t cb, void * cb_data)
+{
+	ibnd_smp_t *smp = calloc(1, sizeof *smp);
+	if (!smp) {
+		IBND_ERROR("OOM");
+		return -ENOMEM;
+	}
+
+	smp->cb = cb;
+	smp->cb_data = cb_data;
+	smp->path = *portid;
+	smp->rpc.method = IB_MAD_METHOD_GET;
+	smp->rpc.attr.id = attrid;
+	smp->rpc.attr.mod = mod;
+	smp->rpc.timeout = mad_get_timeout(engine->ibmad_port, 0);
+	smp->rpc.datasz = IB_SMP_DATA_SIZE;
+	smp->rpc.dataoffs = IB_SMP_DATA_OFFS;
+	smp->rpc.trid = mad_trid();
+
+	if ((portid->lid <= 0) ||
+	    (portid->drpath.drslid == 0xffff) ||
+	    (portid->drpath.drdlid == 0xffff))
+		smp->rpc.mgtclass = IB_SMI_DIRECT_CLASS; /* direct SMI */
+	else
+		smp->rpc.mgtclass = IB_SMI_CLASS; /* Lid routed SMI */
+
+	portid->sl = 0;
+	portid->qp = 0;
+
+	engine->num_smps_outstanding++;
+	queue_smp(engine, smp);
+	return (process_smp_queue(engine));
+}
+
+int process_one_recv(smp_engine_t *engine)
+{
+	int rc = 0;
+	int status = 0;
+	ibnd_smp_t *smp;
+	uint8_t *mad;
+	uint32_t trid;
+	uint8_t umad[umad_size() + IB_MAD_SIZE];
+	int length = umad_size() + IB_MAD_SIZE;
+
+	memset(umad, 0, sizeof(umad));
+
+	/* wait for the next message */
+	if ((rc = umad_recv(mad_rpc_portid(engine->ibmad_port), umad, &length,
+			    0)) < 0) {
+		if (rc == -EWOULDBLOCK)
+			return 0;
+		IBND_ERROR("umad_recv failed: %d\n", rc);
+		return -1;
+	}
+
+	rc = process_smp_queue(engine);
+
+	mad = umad_get_mad(umad);
+	trid = (uint32_t)mad_get_field64(mad, 0, IB_MAD_TRID_F);
+
+	smp = (ibnd_smp_t *)cl_qmap_remove(&engine->smps_on_wire, trid);
+	if ((cl_map_item_t *)smp == cl_qmap_end(&engine->smps_on_wire)) {
+		IBND_ERROR("Failed to find matching smp for trid (%x)\n",
+			   trid);
+		return -1;
+	}
+
+	if (rc)
+		goto error;
+
+	if ((status = umad_status(umad))) {
+		IBND_ERROR("umad (%s Attr 0x%x:%u) bad status %d; %s\n",
+			portid2str(&smp->path),
+			smp->rpc.attr.id, smp->rpc.attr.mod,
+			status, strerror(status));
+	} else if ((status = mad_get_field(mad, 0, IB_DRSMP_STATUS_F))) {
+			IBND_ERROR("mad (%s Attr 0x%x:%u) bad status 0x%x\n",
+				   portid2str(&smp->path),
+				   smp->rpc.attr.id, smp->rpc.attr.mod,
+				   status);
+	} else
+		rc = smp->cb(engine, smp, mad, smp->cb_data);
+
+error:
+	free(smp);
+	engine->num_smps_outstanding--;
+	return (rc);
+}
+
+void smp_engine_init(smp_engine_t * engine, struct ibmad_port *ibmad_port,
+		     void * user_data, int max_smps_on_wire)
+{
+	memset(engine, '\0', sizeof(*engine));
+	engine->ibmad_port = ibmad_port;
+	engine->user_data = user_data;
+	cl_qmap_init(&engine->smps_on_wire);
+	engine->num_smps_outstanding = 0;
+	engine->max_smps_on_wire = max_smps_on_wire;
+}
+
+void smp_engine_destroy(smp_engine_t *engine)
+{
+	cl_map_item_t *item;
+	ibnd_smp_t *smp;
+
+	/* remove queued smps */
+	smp = get_smp(engine);
+	if (smp)
+		IBND_ERROR("outstanding SMP's\n");
+	for (/* */; smp; smp = get_smp(engine)) {
+		free(smp);
+	}
+
+	/* remove smps from the wire queue */
+	item = cl_qmap_head(&engine->smps_on_wire);
+	if (item != cl_qmap_end(&engine->smps_on_wire))
+		IBND_ERROR("outstanding SMP's on wire\n");
+	for (/* */; item != cl_qmap_end(&engine->smps_on_wire);
+	     item = cl_qmap_head(&engine->smps_on_wire)) {
+		cl_qmap_remove_item(&engine->smps_on_wire, item);
+		free(item);
+	}
+
+	engine->num_smps_outstanding = 0;
+}
+
+int process_mads(smp_engine_t *engine)
+{
+	int rc = 0;
+	while (engine->num_smps_outstanding > 0) {
+		if ((rc = process_smp_queue(engine)) != 0)
+			return rc;
+		while (!cl_is_qmap_empty(&engine->smps_on_wire))
+			if ((rc = process_one_recv(engine)) != 0)
+				return rc;
+	}
+	return 0;
+}
+
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
