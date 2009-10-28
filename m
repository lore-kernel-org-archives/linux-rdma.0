From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [PATCH] [1/2] split out ibnd_fabric_t fields
	that are only used during a scan
Date: Wed, 28 Oct 2009 16:52:09 -0700
Message-ID: <1256773929.4819.190.camel@auk31.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-gCJ7XOosXKYt85Lj4IBa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-gCJ7XOosXKYt85Lj4IBa
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Split out public parameters from ibnd_fabric_t that are useless b/c they
are only used during the ibnetdiscover scan.

Note that this patch has similarities to a previous patch from Ira,
however it is separate and independent of that patch series.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-gCJ7XOosXKYt85Lj4IBa
Content-Disposition: attachment; filename*0=0001-split-out-ibnd_fabric_t-fields-that-are-only-used-du.pat; filename*1=ch
Content-Type: text/plain; name=0001-split-out-ibnd_fabric_t-fields-that-are-only-used-du.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 27 Oct 2009 16:16:14 -0700
Subject: [PATCH] split out ibnd_fabric_t fields that are only used during a scan


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 .../libibnetdisc/include/infiniband/ibnetdisc.h    |    6 --
 infiniband-diags/libibnetdisc/src/chassis.c        |   68 ++++++++++++--------
 infiniband-diags/libibnetdisc/src/chassis.h        |    2 +-
 infiniband-diags/libibnetdisc/src/ibnetdisc.c      |   60 +++++++++--------
 infiniband-diags/libibnetdisc/src/internal.h       |   10 +++
 5 files changed, 83 insertions(+), 63 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index c55ce00..8303175 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -124,7 +124,6 @@ typedef struct ibnd_chassis {
 } ibnd_chassis_t;
 
 #define HTSZ 137
-#define MAXHOPS		63
 
 /** =========================================================================
  * Fabric
@@ -145,14 +144,9 @@ typedef struct ibnd_fabric {
 	/* internal use only */
 	ibnd_node_t *nodestbl[HTSZ];
 	ibnd_port_t *portstbl[HTSZ];
-	ibnd_node_t *nodesdist[MAXHOPS + 1];
-	ibnd_chassis_t *first_chassis;
-	ibnd_chassis_t *current_chassis;
-	ibnd_chassis_t *last_chassis;
 	ibnd_node_t *switches;
 	ibnd_node_t *ch_adapters;
 	ibnd_node_t *routers;
-	ib_portid_t selfportid;
 } ibnd_fabric_t;
 
 /** =========================================================================
diff --git a/infiniband-diags/libibnetdisc/src/chassis.c b/infiniband-diags/libibnetdisc/src/chassis.c
index 4886cfc..5043f42 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.c
+++ b/infiniband-diags/libibnetdisc/src/chassis.c
@@ -96,7 +96,7 @@ static ibnd_chassis_t *find_chassisnum(ibnd_fabric_t * fabric,
 {
 	ibnd_chassis_t *current;
 
-	for (current = fabric->first_chassis; current; current = current->next) {
+	for (current = fabric->chassis; current; current = current->next) {
 		if (current->chassisnum == chassisnum)
 			return current;
 	}
@@ -214,7 +214,7 @@ static ibnd_chassis_t *find_chassisguid(ibnd_fabric_t * fabric,
 	uint64_t chguid;
 
 	chguid = get_chassisguid(node);
-	for (current = fabric->first_chassis; current; current = current->next) {
+	for (current = fabric->chassis; current; current = current->next) {
 		if (current->chassisguid == chguid)
 			return current;
 	}
@@ -782,19 +782,19 @@ static void voltaire_portmap(ibnd_port_t * port)
 		port->ext_portnum = int2ext_map_slb8[chipnum][portnum];
 }
 
-static int add_chassis(ibnd_fabric_t * fabric)
+static int add_chassis(ibnd_scan_t *ibnd_scan)
 {
-	if (!(fabric->current_chassis = calloc(1, sizeof(ibnd_chassis_t)))) {
+	if (!(ibnd_scan->current_chassis = calloc(1, sizeof(ibnd_chassis_t)))) {
 		IBND_ERROR("OOM: failed to allocate chassis object\n");
 		return (-1);
 	}
 
-	if (fabric->first_chassis == NULL) {
-		fabric->first_chassis = fabric->current_chassis;
-		fabric->last_chassis = fabric->current_chassis;
+	if (ibnd_scan->first_chassis == NULL) {
+		ibnd_scan->first_chassis = ibnd_scan->current_chassis;
+		ibnd_scan->last_chassis = ibnd_scan->current_chassis;
 	} else {
-		fabric->last_chassis->next = fabric->current_chassis;
-		fabric->last_chassis = fabric->current_chassis;
+		ibnd_scan->last_chassis->next = ibnd_scan->current_chassis;
+		ibnd_scan->last_chassis = ibnd_scan->current_chassis;
 	}
 	return (0);
 }
@@ -818,33 +818,35 @@ static void add_node_to_chassis(ibnd_chassis_t * chassis, ibnd_node_t * node)
 	Returns:
 	0 on success, -1 on failure
 */
-int group_nodes(ibnd_fabric_t * fabric)
+int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *ibnd_scan)
 {
 	ibnd_node_t *node;
 	int dist;
 	int chassisnum = 0;
 	ibnd_chassis_t *chassis;
+	ibnd_chassis_t *ch, *ch_next;
 
-	fabric->first_chassis = NULL;
-	fabric->current_chassis = NULL;
+	ibnd_scan->first_chassis = NULL;
+	ibnd_scan->current_chassis = NULL;
+	ibnd_scan->last_chassis = NULL;
 
 	/* first pass on switches and build for every Voltaire node */
 	/* an appropriate chassis record (slotnum and position) */
 	/* according to internal connectivity */
 	/* not very efficient but clear code so... */
 	for (dist = 0; dist <= fabric->maxhops_discovered; dist++) {
-		for (node = fabric->nodesdist[dist]; node; node = node->dnext) {
+		for (node = ibnd_scan->nodesdist[dist]; node; node = node->dnext) {
 			if (mad_get_field(node->info, 0,
 					  IB_NODE_VENDORID_F) == VTR_VENDOR_ID)
 				if (fill_voltaire_chassis_record(node))
-					return (-1);
+					goto cleanup;
 		}
 	}
 
 	/* separate every Voltaire chassis from each other and build linked list of them */
 	/* algorithm: catch spine and find all surrounding nodes */
 	for (dist = 0; dist <= fabric->maxhops_discovered; dist++) {
-		for (node = fabric->nodesdist[dist]; node; node = node->dnext) {
+		for (node = ibnd_scan->nodesdist[dist]; node; node = node->dnext) {
 			if (mad_get_field(node->info, 0,
 					  IB_NODE_VENDORID_F) != VTR_VENDOR_ID)
 				continue;
@@ -852,18 +854,18 @@ int group_nodes(ibnd_fabric_t * fabric)
 			    || (node->chassis && node->chassis->chassisnum)
 			    || !is_spine(node))
 				continue;
-			if (add_chassis(fabric))
-				return (-1);
-			fabric->current_chassis->chassisnum = ++chassisnum;
-			if (build_chassis(node, fabric->current_chassis))
-				return (-1);
+			if (add_chassis(ibnd_scan))
+				goto cleanup;
+			ibnd_scan->current_chassis->chassisnum = ++chassisnum;
+			if (build_chassis(node, ibnd_scan->current_chassis))
+				goto cleanup;
 		}
 	}
 
 	/* now make pass on nodes for chassis which are not Voltaire */
 	/* grouped by common SystemImageGUID */
 	for (dist = 0; dist <= fabric->maxhops_discovered; dist++) {
-		for (node = fabric->nodesdist[dist]; node; node = node->dnext) {
+		for (node = ibnd_scan->nodesdist[dist]; node; node = node->dnext) {
 			if (mad_get_field(node->info, 0,
 					  IB_NODE_VENDORID_F) == VTR_VENDOR_ID)
 				continue;
@@ -876,12 +878,12 @@ int group_nodes(ibnd_fabric_t * fabric)
 					chassis->nodecount++;
 				else {
 					/* Possible new chassis */
-					if (add_chassis(fabric))
-						return (-1);
-					fabric->current_chassis->chassisguid =
+					if (add_chassis(ibnd_scan))
+						goto cleanup;
+					ibnd_scan->current_chassis->chassisguid =
 					    get_chassisguid((ibnd_node_t *)
 							    node);
-					fabric->current_chassis->nodecount = 1;
+					ibnd_scan->current_chassis->nodecount = 1;
 				}
 			}
 		}
@@ -890,7 +892,7 @@ int group_nodes(ibnd_fabric_t * fabric)
 	/* now, make another pass to see which nodes are part of chassis */
 	/* (defined as chassis->nodecount > 1) */
 	for (dist = 0; dist <= MAXHOPS;) {
-		for (node = fabric->nodesdist[dist]; node; node = node->dnext) {
+		for (node = ibnd_scan->nodesdist[dist]; node; node = node->dnext) {
 			if (mad_get_field(node->info, 0,
 					  IB_NODE_VENDORID_F) == VTR_VENDOR_ID)
 				continue;
@@ -918,6 +920,18 @@ int group_nodes(ibnd_fabric_t * fabric)
 			dist++;
 	}
 
-	fabric->chassis = fabric->first_chassis;
+	fabric->chassis = ibnd_scan->first_chassis;
 	return (0);
+
+cleanup:
+	ch = ibnd_scan->first_chassis;
+	while (ch) {
+		ch_next = ch->next;
+		free(ch);
+		ch = ch_next;
+	}	
+	ibnd_scan->first_chassis = NULL;
+	ibnd_scan->current_chassis = NULL;
+	ibnd_scan->last_chassis = NULL;
+	return (-1);
 }
diff --git a/infiniband-diags/libibnetdisc/src/chassis.h b/infiniband-diags/libibnetdisc/src/chassis.h
index 2191046..7a96b02 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.h
+++ b/infiniband-diags/libibnetdisc/src/chassis.h
@@ -82,6 +82,6 @@ enum ibnd_chassis_type {
 };
 enum ibnd_chassis_slot_type { UNRESOLVED_CS, LINE_CS, SPINE_CS, SRBD_CS };
 
-int group_nodes(struct ibnd_fabric *fabric);
+int group_nodes(struct ibnd_fabric *fabric, ibnd_scan_t *ibnd_scan);
 
 #endif				/* _CHASSIS_H_ */
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 99e44bd..b25c3d0 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -180,20 +180,20 @@ static void retract_dpath(ib_portid_t * path)
 }
 
 static int extend_dpath(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
-			ib_portid_t * portid, int nextport)
+			ibnd_scan_t *ibnd_scan, ib_portid_t * portid, int nextport)
 {
 	int rc = 0;
 
 	if (portid->lid) {
 		/* If we were LID routed we need to set up the drslid */
-		if (!fabric->selfportid.lid)
-			if (ib_resolve_self_via(&fabric->selfportid, NULL, NULL,
+		if (!ibnd_scan->selfportid.lid)
+			if (ib_resolve_self_via(&ibnd_scan->selfportid, NULL, NULL,
 						ibmad_port) < 0) {
 				IBND_ERROR("Failed to resolve self\n");
 				return -1;
 			}
 
-		portid->drpath.drslid = (uint16_t) fabric->selfportid.lid;
+		portid->drpath.drslid = (uint16_t) ibnd_scan->selfportid.lid;
 		portid->drpath.drdlid = 0xFFFF;
 	}
 
@@ -387,17 +387,17 @@ static void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric)
 	}
 }
 
-static void add_to_nodedist(ibnd_node_t * node, ibnd_fabric_t * fabric)
+static void add_to_nodedist(ibnd_node_t * node, ibnd_scan_t * ibnd_scan)
 {
 	int dist = node->dist;
 	if (node->type != IB_NODE_SWITCH)
 		dist = MAXHOPS;	/* special Ca list */
 
-	node->dnext = fabric->nodesdist[dist];
-	fabric->nodesdist[dist] = node;
+	node->dnext = ibnd_scan->nodesdist[dist];
+	ibnd_scan->nodesdist[dist] = node;
 }
 
-static ibnd_node_t *create_node(ibnd_fabric_t * fabric,
+static ibnd_node_t *create_node(ibnd_fabric_t * fabric, ibnd_scan_t * ibnd_scan,
 				ibnd_node_t * temp, ib_portid_t * path,
 				int dist)
 {
@@ -420,7 +420,7 @@ static ibnd_node_t *create_node(ibnd_fabric_t * fabric,
 	fabric->nodes = (ibnd_node_t *) node;
 
 	add_to_type_list(node, fabric);
-	add_to_nodedist(node, fabric);
+	add_to_nodedist(node, ibnd_scan);
 
 	return node;
 }
@@ -480,9 +480,9 @@ static void link_ports(ibnd_node_t * node, ibnd_port_t * port,
 }
 
 static int get_remote_node(struct ibmad_port *ibmad_port,
-			   ibnd_fabric_t * fabric, ibnd_node_t * node,
-			   ibnd_port_t * port, ib_portid_t * path,
-			   int portnum, int dist)
+			   ibnd_fabric_t * fabric, ibnd_scan_t * ibnd_scan,
+			   ibnd_node_t * node, ibnd_port_t * port,
+			   ib_portid_t * path, int portnum, int dist)
 {
 	int rc = 0;
 	ibnd_node_t node_buf;
@@ -500,7 +500,8 @@ static int get_remote_node(struct ibmad_port *ibmad_port,
 	    != IB_PORT_PHYS_STATE_LINKUP)
 		return 1;	/* positive == non-fatal error */
 
-	if (portnum > 0 && extend_dpath(ibmad_port, fabric, path, portnum) < 0)
+	if (portnum > 0 && extend_dpath(ibmad_port, fabric, ibnd_scan,
+					path, portnum) < 0)
 		return -1;
 
 	if (query_node(ibmad_port, fabric, &node_buf, &port_buf, path)) {
@@ -513,7 +514,8 @@ static int get_remote_node(struct ibmad_port *ibmad_port,
 	oldnode = find_existing_node(fabric, &node_buf);
 	if (oldnode)
 		remotenode = oldnode;
-	else if (!(remotenode = create_node(fabric, &node_buf, path, dist + 1))) {
+	else if (!(remotenode = create_node(fabric, ibnd_scan, &node_buf,
+					    path, dist + 1))) {
 		rc = -1;
 		goto error;
 	}
@@ -552,6 +554,7 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 	int dist = 0;
 	ib_portid_t *path;
 	int max_hops = MAXHOPS - 1;	/* default find everything */
+	ibnd_scan_t ibnd_scan;
 
 	if (_check_ibmad_port(ibmad_port) < 0)
 		return (NULL);
@@ -574,6 +577,8 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 
 	memset(fabric, 0, sizeof(*fabric));
 
+	memset(&ibnd_scan, '\0', sizeof(ibnd_scan_t));
+
 	IBND_DEBUG("from %s\n", portid2str(from));
 
 	memset(&node_buf, 0, sizeof(node_buf));
@@ -584,7 +589,7 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 		goto error;
 	}
 
-	node = create_node(fabric, &node_buf, from, 0);
+	node = create_node(fabric, &ibnd_scan, &node_buf, from, 0);
 	if (!node)
 		goto error;
 
@@ -594,7 +599,7 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 	if (!port)
 		goto error;
 
-	rc = get_remote_node(ibmad_port, fabric, node, port, from,
+	rc = get_remote_node(ibmad_port, fabric, &ibnd_scan, node, port, from,
 			     mad_get_field(node->info, 0,
 					   IB_NODE_LOCAL_PORT_F), 0);
 	if (rc < 0)
@@ -604,7 +609,7 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 
 	for (dist = 0; dist <= max_hops; dist++) {
 
-		for (node = fabric->nodesdist[dist]; node; node = node->dnext) {
+		for (node = ibnd_scan.nodesdist[dist]; node; node = node->dnext) {
 
 			path = &node->path_portid;
 
@@ -640,14 +645,14 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 							    IB_NODE_PORT_GUID_F);
 				}
 
-				if (get_remote_node(ibmad_port, fabric, node,
-						    port, path, i, dist) < 0)
+				if (get_remote_node(ibmad_port, fabric, &ibnd_scan,
+						    node, port, path, i, dist) < 0)
 					goto error;
 			}
 		}
 	}
 
-	if (group_nodes(fabric))
+	if (group_nodes(fabric, &ibnd_scan))
 		goto error;
 
 	return ((ibnd_fabric_t *) fabric);
@@ -669,7 +674,6 @@ static void destroy_node(ibnd_node_t * node)
 
 void ibnd_destroy_fabric(ibnd_fabric_t * fabric)
 {
-	int dist = 0;
 	ibnd_node_t *node = NULL;
 	ibnd_node_t *next = NULL;
 	ibnd_chassis_t *ch, *ch_next;
@@ -677,19 +681,17 @@ void ibnd_destroy_fabric(ibnd_fabric_t * fabric)
 	if (!fabric)
 		return;
 
-	ch = fabric->first_chassis;
+	ch = fabric->chassis;
 	while (ch) {
 		ch_next = ch->next;
 		free(ch);
 		ch = ch_next;
 	}
-	for (dist = 0; dist <= MAXHOPS; dist++) {
-		node = fabric->nodesdist[dist];
-		while (node) {
-			next = node->dnext;
-			destroy_node(node);
-			node = next;
-		}
+	node = fabric->nodes;
+	while (node) {
+		next = node->next;
+		destroy_node(node);
+		node = next;
 	}
 	free(fabric);
 }
diff --git a/infiniband-diags/libibnetdisc/src/internal.h b/infiniband-diags/libibnetdisc/src/internal.h
index 21ff476..eac1a29 100644
--- a/infiniband-diags/libibnetdisc/src/internal.h
+++ b/infiniband-diags/libibnetdisc/src/internal.h
@@ -50,4 +50,14 @@
 /* HASH table defines */
 #define HASHGUID(guid) ((uint32_t)(((uint32_t)(guid) * 101) ^ ((uint32_t)((guid) >> 32) * 103)))
 
+#define MAXHOPS         63
+
+typedef struct ibnd_scan {
+	ibnd_node_t *nodesdist[MAXHOPS + 1];
+	ibnd_chassis_t *first_chassis;
+	ibnd_chassis_t *current_chassis;
+	ibnd_chassis_t *last_chassis;
+	ib_portid_t selfportid;
+} ibnd_scan_t;
+
 #endif				/* _INTERNAL_H_ */
-- 
1.5.4.5


--=-gCJ7XOosXKYt85Lj4IBa--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
