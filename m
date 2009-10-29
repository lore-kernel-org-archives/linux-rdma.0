From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibnetdisc: rename ibnd_scan variable to scan
Date: Thu, 29 Oct 2009 23:46:35 +0200
Message-ID: <20091029214635.GI20136@me>
References: <1256773929.4819.190.camel@auk31.llnl.gov>
 <20091029213900.GG20136@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091029213900.GG20136@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Rename 'ibnd_scan' variable to shorter 'scan' to highlight its local
feature.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/chassis.c   |   52 ++++++++++++------------
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |   40 +++++++++---------
 2 files changed, 46 insertions(+), 46 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/chassis.c b/infiniband-diags/libibnetdisc/src/chassis.c
index dcf15b4..ffae29b 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.c
+++ b/infiniband-diags/libibnetdisc/src/chassis.c
@@ -782,19 +782,19 @@ static void voltaire_portmap(ibnd_port_t * port)
 		port->ext_portnum = int2ext_map_slb8[chipnum][portnum];
 }
 
-static int add_chassis(ibnd_scan_t *ibnd_scan)
+static int add_chassis(ibnd_scan_t *scan)
 {
-	if (!(ibnd_scan->current_chassis = calloc(1, sizeof(ibnd_chassis_t)))) {
+	if (!(scan->current_chassis = calloc(1, sizeof(ibnd_chassis_t)))) {
 		IBND_ERROR("OOM: failed to allocate chassis object\n");
 		return (-1);
 	}
 
-	if (ibnd_scan->first_chassis == NULL) {
-		ibnd_scan->first_chassis = ibnd_scan->current_chassis;
-		ibnd_scan->last_chassis = ibnd_scan->current_chassis;
+	if (scan->first_chassis == NULL) {
+		scan->first_chassis = scan->current_chassis;
+		scan->last_chassis = scan->current_chassis;
 	} else {
-		ibnd_scan->last_chassis->next = ibnd_scan->current_chassis;
-		ibnd_scan->last_chassis = ibnd_scan->current_chassis;
+		scan->last_chassis->next = scan->current_chassis;
+		scan->last_chassis = scan->current_chassis;
 	}
 	return (0);
 }
@@ -818,7 +818,7 @@ static void add_node_to_chassis(ibnd_chassis_t * chassis, ibnd_node_t * node)
 	Returns:
 	0 on success, -1 on failure
 */
-int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *ibnd_scan)
+int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 {
 	ibnd_node_t *node;
 	int dist;
@@ -826,16 +826,16 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *ibnd_scan)
 	ibnd_chassis_t *chassis;
 	ibnd_chassis_t *ch, *ch_next;
 
-	ibnd_scan->first_chassis = NULL;
-	ibnd_scan->current_chassis = NULL;
-	ibnd_scan->last_chassis = NULL;
+	scan->first_chassis = NULL;
+	scan->current_chassis = NULL;
+	scan->last_chassis = NULL;
 
 	/* first pass on switches and build for every Voltaire node */
 	/* an appropriate chassis record (slotnum and position) */
 	/* according to internal connectivity */
 	/* not very efficient but clear code so... */
 	for (dist = 0; dist <= fabric->maxhops_discovered; dist++) {
-		for (node = ibnd_scan->nodesdist[dist]; node; node = node->dnext) {
+		for (node = scan->nodesdist[dist]; node; node = node->dnext) {
 			if (mad_get_field(node->info, 0,
 					  IB_NODE_VENDORID_F) == VTR_VENDOR_ID)
 				if (fill_voltaire_chassis_record(node))
@@ -846,7 +846,7 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *ibnd_scan)
 	/* separate every Voltaire chassis from each other and build linked list of them */
 	/* algorithm: catch spine and find all surrounding nodes */
 	for (dist = 0; dist <= fabric->maxhops_discovered; dist++) {
-		for (node = ibnd_scan->nodesdist[dist]; node; node = node->dnext) {
+		for (node = scan->nodesdist[dist]; node; node = node->dnext) {
 			if (mad_get_field(node->info, 0,
 					  IB_NODE_VENDORID_F) != VTR_VENDOR_ID)
 				continue;
@@ -854,10 +854,10 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *ibnd_scan)
 			    || (node->chassis && node->chassis->chassisnum)
 			    || !is_spine(node))
 				continue;
-			if (add_chassis(ibnd_scan))
+			if (add_chassis(scan))
 				goto cleanup;
-			ibnd_scan->current_chassis->chassisnum = ++chassisnum;
-			if (build_chassis(node, ibnd_scan->current_chassis))
+			scan->current_chassis->chassisnum = ++chassisnum;
+			if (build_chassis(node, scan->current_chassis))
 				goto cleanup;
 		}
 	}
@@ -865,7 +865,7 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *ibnd_scan)
 	/* now make pass on nodes for chassis which are not Voltaire */
 	/* grouped by common SystemImageGUID */
 	for (dist = 0; dist <= fabric->maxhops_discovered; dist++) {
-		for (node = ibnd_scan->nodesdist[dist]; node; node = node->dnext) {
+		for (node = scan->nodesdist[dist]; node; node = node->dnext) {
 			if (mad_get_field(node->info, 0,
 					  IB_NODE_VENDORID_F) == VTR_VENDOR_ID)
 				continue;
@@ -878,12 +878,12 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *ibnd_scan)
 					chassis->nodecount++;
 				else {
 					/* Possible new chassis */
-					if (add_chassis(ibnd_scan))
+					if (add_chassis(scan))
 						goto cleanup;
-					ibnd_scan->current_chassis->chassisguid =
+					scan->current_chassis->chassisguid =
 					    get_chassisguid((ibnd_node_t *)
 							    node);
-					ibnd_scan->current_chassis->nodecount = 1;
+					scan->current_chassis->nodecount = 1;
 				}
 			}
 		}
@@ -892,7 +892,7 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *ibnd_scan)
 	/* now, make another pass to see which nodes are part of chassis */
 	/* (defined as chassis->nodecount > 1) */
 	for (dist = 0; dist <= MAXHOPS;) {
-		for (node = ibnd_scan->nodesdist[dist]; node; node = node->dnext) {
+		for (node = scan->nodesdist[dist]; node; node = node->dnext) {
 			if (mad_get_field(node->info, 0,
 					  IB_NODE_VENDORID_F) == VTR_VENDOR_ID)
 				continue;
@@ -920,18 +920,18 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *ibnd_scan)
 			dist++;
 	}
 
-	fabric->chassis = ibnd_scan->first_chassis;
+	fabric->chassis = scan->first_chassis;
 	return (0);
 
 cleanup:
-	ch = ibnd_scan->first_chassis;
+	ch = scan->first_chassis;
 	while (ch) {
 		ch_next = ch->next;
 		free(ch);
 		ch = ch_next;
 	}
-	ibnd_scan->first_chassis = NULL;
-	ibnd_scan->current_chassis = NULL;
-	ibnd_scan->last_chassis = NULL;
+	scan->first_chassis = NULL;
+	scan->current_chassis = NULL;
+	scan->last_chassis = NULL;
 	return (-1);
 }
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 047b705..d2ec9b2 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -180,20 +180,20 @@ static void retract_dpath(ib_portid_t * path)
 }
 
 static int extend_dpath(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
-			ibnd_scan_t *ibnd_scan, ib_portid_t * portid, int nextport)
+			ibnd_scan_t *scan, ib_portid_t * portid, int nextport)
 {
 	int rc = 0;
 
 	if (portid->lid) {
 		/* If we were LID routed we need to set up the drslid */
-		if (!ibnd_scan->selfportid.lid)
-			if (ib_resolve_self_via(&ibnd_scan->selfportid, NULL, NULL,
+		if (!scan->selfportid.lid)
+			if (ib_resolve_self_via(&scan->selfportid, NULL, NULL,
 						ibmad_port) < 0) {
 				IBND_ERROR("Failed to resolve self\n");
 				return -1;
 			}
 
-		portid->drpath.drslid = (uint16_t) ibnd_scan->selfportid.lid;
+		portid->drpath.drslid = (uint16_t) scan->selfportid.lid;
 		portid->drpath.drdlid = 0xFFFF;
 	}
 
@@ -387,16 +387,16 @@ static void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric)
 	}
 }
 
-static void add_to_nodedist(ibnd_node_t * node, ibnd_scan_t * ibnd_scan, int dist)
+static void add_to_nodedist(ibnd_node_t * node, ibnd_scan_t * scan, int dist)
 {
 	if (node->type != IB_NODE_SWITCH)
 		dist = MAXHOPS;	/* special Ca list */
 
-	node->dnext = ibnd_scan->nodesdist[dist];
-	ibnd_scan->nodesdist[dist] = node;
+	node->dnext = scan->nodesdist[dist];
+	scan->nodesdist[dist] = node;
 }
 
-static ibnd_node_t *create_node(ibnd_fabric_t * fabric, ibnd_scan_t * ibnd_scan,
+static ibnd_node_t *create_node(ibnd_fabric_t * fabric, ibnd_scan_t * scan,
 				ibnd_node_t * temp, ib_portid_t * path,
 				int dist)
 {
@@ -418,7 +418,7 @@ static ibnd_node_t *create_node(ibnd_fabric_t * fabric, ibnd_scan_t * ibnd_scan,
 	fabric->nodes = (ibnd_node_t *) node;
 
 	add_to_type_list(node, fabric);
-	add_to_nodedist(node, ibnd_scan, dist);
+	add_to_nodedist(node, scan, dist);
 
 	return node;
 }
@@ -478,7 +478,7 @@ static void link_ports(ibnd_node_t * node, ibnd_port_t * port,
 }
 
 static int get_remote_node(struct ibmad_port *ibmad_port,
-			   ibnd_fabric_t * fabric, ibnd_scan_t * ibnd_scan,
+			   ibnd_fabric_t * fabric, ibnd_scan_t * scan,
 			   ibnd_node_t * node, ibnd_port_t * port,
 			   ib_portid_t * path, int portnum, int dist)
 {
@@ -498,7 +498,7 @@ static int get_remote_node(struct ibmad_port *ibmad_port,
 	    != IB_PORT_PHYS_STATE_LINKUP)
 		return 1;	/* positive == non-fatal error */
 
-	if (portnum > 0 && extend_dpath(ibmad_port, fabric, ibnd_scan,
+	if (portnum > 0 && extend_dpath(ibmad_port, fabric, scan,
 					path, portnum) < 0)
 		return -1;
 
@@ -512,8 +512,8 @@ static int get_remote_node(struct ibmad_port *ibmad_port,
 	oldnode = find_existing_node(fabric, &node_buf);
 	if (oldnode)
 		remotenode = oldnode;
-	else if (!(remotenode = create_node(fabric, ibnd_scan, &node_buf,
-					    path, dist + 1))) {
+	else if (!(remotenode = create_node(fabric, scan, &node_buf, path,
+					    dist + 1))) {
 		rc = -1;
 		goto error;
 	}
@@ -552,7 +552,7 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 	int dist = 0;
 	ib_portid_t *path;
 	int max_hops = MAXHOPS - 1;	/* default find everything */
-	ibnd_scan_t ibnd_scan;
+	ibnd_scan_t scan;
 
 	if (_check_ibmad_port(ibmad_port) < 0)
 		return (NULL);
@@ -575,7 +575,7 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 
 	memset(fabric, 0, sizeof(*fabric));
 
-	memset(&ibnd_scan, '\0', sizeof(ibnd_scan_t));
+	memset(&scan, '\0', sizeof(ibnd_scan_t));
 
 	IBND_DEBUG("from %s\n", portid2str(from));
 
@@ -587,7 +587,7 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 		goto error;
 	}
 
-	node = create_node(fabric, &ibnd_scan, &node_buf, from, 0);
+	node = create_node(fabric, &scan, &node_buf, from, 0);
 	if (!node)
 		goto error;
 
@@ -597,7 +597,7 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 	if (!port)
 		goto error;
 
-	rc = get_remote_node(ibmad_port, fabric, &ibnd_scan, node, port, from,
+	rc = get_remote_node(ibmad_port, fabric, &scan, node, port, from,
 			     mad_get_field(node->info, 0,
 					   IB_NODE_LOCAL_PORT_F), 0);
 	if (rc < 0)
@@ -607,7 +607,7 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 
 	for (dist = 0; dist <= max_hops; dist++) {
 
-		for (node = ibnd_scan.nodesdist[dist]; node; node = node->dnext) {
+		for (node = scan.nodesdist[dist]; node; node = node->dnext) {
 
 			path = &node->path_portid;
 
@@ -643,14 +643,14 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 							    IB_NODE_PORT_GUID_F);
 				}
 
-				if (get_remote_node(ibmad_port, fabric, &ibnd_scan,
+				if (get_remote_node(ibmad_port, fabric, &scan,
 						    node, port, path, i, dist) < 0)
 					goto error;
 			}
 		}
 	}
 
-	if (group_nodes(fabric, &ibnd_scan))
+	if (group_nodes(fabric, &scan))
 		goto error;
 
 	return ((ibnd_fabric_t *) fabric);
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
