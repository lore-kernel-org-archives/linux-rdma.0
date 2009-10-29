From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] libibnetdisc: some cleanups
Date: Thu, 29 Oct 2009 23:47:11 +0200
Message-ID: <20091029214711.GJ20136@me>
References: <1256773929.4819.190.camel@auk31.llnl.gov>
 <20091029213900.GG20136@me>
 <20091029214635.GI20136@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091029214635.GI20136@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Cleanups: kill not needed braces, castings, consolidate flows.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/chassis.c   |  117 ++++++++++++-------------
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |   90 +++++++++----------
 2 files changed, 99 insertions(+), 108 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/chassis.c b/infiniband-diags/libibnetdisc/src/chassis.c
index ffae29b..dd16f20 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.c
+++ b/infiniband-diags/libibnetdisc/src/chassis.c
@@ -57,16 +57,16 @@ char *ibnd_get_chassis_type(ibnd_node_t * node)
 {
 	if (!node) {
 		IBND_DEBUG("node parameter NULL\n");
-		return (NULL);
+		return NULL;
 	}
 
 	/* Currently, only if Voltaire chassis */
 	if (mad_get_field(node->info, 0, IB_NODE_VENDORID_F) != VTR_VENDOR_ID)
-		return (NULL);
+		return NULL;
 	if (!node->chassis)
-		return (NULL);
+		return NULL;
 	if (node->ch_type == UNRESOLVED_CT || node->ch_type > ISR2004_CT)
-		return (NULL);
+		return NULL;
 	return ChassisTypeStr[node->ch_type];
 }
 
@@ -74,21 +74,21 @@ char *ibnd_get_chassis_slot_str(ibnd_node_t * node, char *str, size_t size)
 {
 	if (!node) {
 		IBND_DEBUG("node parameter NULL\n");
-		return (NULL);
+		return NULL;
 	}
 
 	/* Currently, only if Voltaire chassis */
 	if (mad_get_field(node->info, 0, IB_NODE_VENDORID_F) != VTR_VENDOR_ID)
-		return (NULL);
+		return NULL;
 	if (!node->chassis)
-		return (NULL);
+		return NULL;
 	if (node->ch_slot == UNRESOLVED_CS || node->ch_slot > SRBD_CS)
-		return (NULL);
+		return NULL;
 	if (!str)
-		return (NULL);
+		return NULL;
 	snprintf(str, size, "%s %d Chip %d", ChassisSlotTypeStr[node->ch_slot],
 		 node->ch_slotnum, node->ch_anafanum);
-	return (str);
+	return str;
 }
 
 static ibnd_chassis_t *find_chassisnum(ibnd_fabric_t * fabric,
@@ -96,10 +96,9 @@ static ibnd_chassis_t *find_chassisnum(ibnd_fabric_t * fabric,
 {
 	ibnd_chassis_t *current;
 
-	for (current = fabric->chassis; current; current = current->next) {
+	for (current = fabric->chassis; current; current = current->next)
 		if (current->chassisnum == chassisnum)
 			return current;
-	}
 
 	return NULL;
 }
@@ -176,7 +175,7 @@ static uint64_t xsigo_chassisguid(ibnd_node_t * node)
 			return sysimgguid;
 	} else {
 		if (!node->ports || !node->ports[1])
-			return (0);
+			return 0;
 
 		/* Is there a peer port ? */
 		if (!node->ports[1]->remoteport)
@@ -214,10 +213,9 @@ static ibnd_chassis_t *find_chassisguid(ibnd_fabric_t * fabric,
 	uint64_t chguid;
 
 	chguid = get_chassisguid(node);
-	for (current = fabric->chassis; current; current = current->next) {
+	for (current = fabric->chassis; current; current = current->next)
 		if (current->chassisguid == chguid)
 			return current;
-	}
 
 	return NULL;
 }
@@ -372,9 +370,9 @@ static int get_sfb_slot(ibnd_node_t * node, ibnd_port_t * lineport)
 	} else {
 		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64,
 			   node->guid);
-		return (-1);
+		return -1;
 	}
-	return (0);
+	return 0;
 }
 
 static int get_router_slot(ibnd_node_t * n, ibnd_port_t * spineport)
@@ -413,9 +411,9 @@ static int get_router_slot(ibnd_node_t * n, ibnd_port_t * spineport)
 	} else {
 		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64,
 			   spineport->node->guid);
-		return (-1);
+		return -1;
 	}
-	return (0);
+	return 0;
 }
 
 static int get_slb_slot(ibnd_node_t * n, ibnd_port_t * spineport)
@@ -440,9 +438,9 @@ static int get_slb_slot(ibnd_node_t * n, ibnd_port_t * spineport)
 	} else {
 		IBND_ERROR("Unexpected node found: guid 0x%016" PRIx64,
 			   spineport->node->guid);
-		return (-1);
+		return -1;
 	}
-	return (0);
+	return 0;
 }
 
 /* forward declare this */
@@ -459,20 +457,20 @@ static int fill_voltaire_chassis_record(ibnd_node_t * node)
 	ibnd_node_t *remnode = 0;
 
 	if (node->ch_found)	/* somehow this node has already been passed */
-		return (0);
+		return 0;
 	node->ch_found = 1;
 
 	/* node is router only in case of using unique lid */
 	/* (which is lid of chassis router port) */
 	/* in such case node->ports is actually a requested port... */
-	if (is_router(node)) {
+	if (is_router(node))
 		/* find the remote node */
 		for (p = 1; p <= node->numports; p++) {
 			port = node->ports[p];
 			if (port && is_spine(port->remoteport->node))
 				get_router_slot(node, port->remoteport);
 		}
-	} else if (is_spine(node)) {
+	else if (is_spine(node))
 		for (p = 1; p <= node->numports; p++) {
 			port = node->ports[p];
 			if (!port || !port->remoteport)
@@ -486,22 +484,21 @@ static int fill_voltaire_chassis_record(ibnd_node_t * node)
 			if (!node->ch_type)
 				/* we assume here that remoteport belongs to line */
 				if (get_sfb_slot(node, port->remoteport))
-					return (-1);
+					return -1;
 
 			/* we could break here, but need to find if more routers connected */
 		}
 
-	} else if (is_line(node)) {
+	else if (is_line(node))
 		for (p = 1; p <= node->numports; p++) {
 			port = node->ports[p];
 			if (!port || port->portnum > 12 || !port->remoteport)
 				continue;
 			/* we assume here that remoteport belongs to spine */
 			if (get_slb_slot(node, port->remoteport))
-				return (-1);
+				return -1;
 			break;
 		}
-	}
 
 	/* for each port of this node, map external ports */
 	for (p = 1; p <= node->numports; p++) {
@@ -511,7 +508,7 @@ static int fill_voltaire_chassis_record(ibnd_node_t * node)
 		voltaire_portmap(port);
 	}
 
-	return (0);
+	return 0;
 }
 
 static int get_line_index(ibnd_node_t * node)
@@ -520,7 +517,7 @@ static int get_line_index(ibnd_node_t * node)
 
 	if (retval > LINES_MAX_NUM || retval < 1) {
 		IBND_ERROR("Internal error\n");
-		return (-1);
+		return -1;
 	}
 	return retval;
 }
@@ -536,7 +533,7 @@ static int get_spine_index(ibnd_node_t * node)
 
 	if (retval > SPINES_MAX_NUM || retval < 1) {
 		IBND_ERROR("Internal error\n");
-		return (-1);
+		return -1;
 	}
 	return retval;
 }
@@ -546,14 +543,14 @@ static int insert_line_router(ibnd_node_t * node, ibnd_chassis_t * chassis)
 	int i = get_line_index(node);
 
 	if (i < 0)
-		return (i);
+		return i;
 
 	if (chassis->linenode[i])
-		return (0);	/* already filled slot */
+		return 0;	/* already filled slot */
 
 	chassis->linenode[i] = node;
 	node->chassis = chassis;
-	return (0);
+	return 0;
 }
 
 static int insert_spine(ibnd_node_t * node, ibnd_chassis_t * chassis)
@@ -561,14 +558,14 @@ static int insert_spine(ibnd_node_t * node, ibnd_chassis_t * chassis)
 	int i = get_spine_index(node);
 
 	if (i < 0)
-		return (i);
+		return i;
 
 	if (chassis->spinenode[i])
-		return (0);	/* already filled slot */
+		return 0;	/* already filled slot */
 
 	chassis->spinenode[i] = node;
 	node->chassis = chassis;
-	return (0);
+	return 0;
 }
 
 static int pass_on_lines_catch_spines(ibnd_chassis_t * chassis)
@@ -593,10 +590,10 @@ static int pass_on_lines_catch_spines(ibnd_chassis_t * chassis)
 			if (!remnode->ch_found)
 				continue;	/* some error - spine not initialized ? FIXME */
 			if (insert_spine(remnode, chassis))
-				return (-1);
+				return -1;
 		}
 	}
-	return (0);
+	return 0;
 }
 
 static int pass_on_spines_catch_lines(ibnd_chassis_t * chassis)
@@ -618,10 +615,10 @@ static int pass_on_spines_catch_lines(ibnd_chassis_t * chassis)
 			if (!remnode->ch_found)
 				continue;	/* some error - line/router not initialized ? FIXME */
 			if (insert_line_router(remnode, chassis))
-				return (-1);
+				return -1;
 		}
 	}
-	return (0);
+	return 0;
 }
 
 /*
@@ -657,7 +654,7 @@ static int build_chassis(ibnd_node_t * node, ibnd_chassis_t * chassis)
 
 	/* we get here with node = chassis_spine */
 	if (insert_spine((ibnd_node_t *) node, chassis))
-		return (-1);
+		return -1;
 
 	/* loop: pass on all ports of node */
 	for (p = 1; p <= node->numports; p++) {
@@ -673,22 +670,22 @@ static int build_chassis(ibnd_node_t * node, ibnd_chassis_t * chassis)
 	}
 
 	if (pass_on_lines_catch_spines(chassis))
-		return (-1);
+		return -1;
 	/* this pass needed for to catch routers, since routers connected only */
 	/* to spines in slot 1 or 4 and we could miss them first time */
 	if (pass_on_spines_catch_lines(chassis))
-		return (-1);
+		return -1;
 
 	/* additional 2 passes needed for to overcome a problem of pure "in-chassis" */
 	/* connectivity - extra pass to ensure that all related chips/modules */
 	/* inserted into the chassis */
 	if (pass_on_lines_catch_spines(chassis))
-		return (-1);
+		return -1;
 	if (pass_on_spines_catch_lines(chassis))
-		return (-1);
+		return -1;
 	pass_on_spines_interpolate_chguid(chassis);
 
-	return (0);
+	return 0;
 }
 
 /*========================================================*/
@@ -786,7 +783,7 @@ static int add_chassis(ibnd_scan_t *scan)
 {
 	if (!(scan->current_chassis = calloc(1, sizeof(ibnd_chassis_t)))) {
 		IBND_ERROR("OOM: failed to allocate chassis object\n");
-		return (-1);
+		return -1;
 	}
 
 	if (scan->first_chassis == NULL) {
@@ -796,7 +793,7 @@ static int add_chassis(ibnd_scan_t *scan)
 		scan->last_chassis->next = scan->current_chassis;
 		scan->last_chassis = scan->current_chassis;
 	}
-	return (0);
+	return 0;
 }
 
 static void add_node_to_chassis(ibnd_chassis_t * chassis, ibnd_node_t * node)
@@ -834,18 +831,16 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 	/* an appropriate chassis record (slotnum and position) */
 	/* according to internal connectivity */
 	/* not very efficient but clear code so... */
-	for (dist = 0; dist <= fabric->maxhops_discovered; dist++) {
-		for (node = scan->nodesdist[dist]; node; node = node->dnext) {
+	for (dist = 0; dist <= fabric->maxhops_discovered; dist++)
+		for (node = scan->nodesdist[dist]; node; node = node->dnext)
 			if (mad_get_field(node->info, 0,
-					  IB_NODE_VENDORID_F) == VTR_VENDOR_ID)
-				if (fill_voltaire_chassis_record(node))
-					goto cleanup;
-		}
-	}
+					  IB_NODE_VENDORID_F) == VTR_VENDOR_ID
+			    && fill_voltaire_chassis_record(node))
+				goto cleanup;
 
 	/* separate every Voltaire chassis from each other and build linked list of them */
 	/* algorithm: catch spine and find all surrounding nodes */
-	for (dist = 0; dist <= fabric->maxhops_discovered; dist++) {
+	for (dist = 0; dist <= fabric->maxhops_discovered; dist++)
 		for (node = scan->nodesdist[dist]; node; node = node->dnext) {
 			if (mad_get_field(node->info, 0,
 					  IB_NODE_VENDORID_F) != VTR_VENDOR_ID)
@@ -860,11 +855,10 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 			if (build_chassis(node, scan->current_chassis))
 				goto cleanup;
 		}
-	}
 
 	/* now make pass on nodes for chassis which are not Voltaire */
 	/* grouped by common SystemImageGUID */
-	for (dist = 0; dist <= fabric->maxhops_discovered; dist++) {
+	for (dist = 0; dist <= fabric->maxhops_discovered; dist++)
 		for (node = scan->nodesdist[dist]; node; node = node->dnext) {
 			if (mad_get_field(node->info, 0,
 					  IB_NODE_VENDORID_F) == VTR_VENDOR_ID)
@@ -887,7 +881,6 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 				}
 			}
 		}
-	}
 
 	/* now, make another pass to see which nodes are part of chassis */
 	/* (defined as chassis->nodecount > 1) */
@@ -921,7 +914,7 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 	}
 
 	fabric->chassis = scan->first_chassis;
-	return (0);
+	return 0;
 
 cleanup:
 	ch = scan->first_chassis;
@@ -933,5 +926,5 @@ cleanup:
 	scan->first_chassis = NULL;
 	scan->current_chassis = NULL;
 	scan->last_chassis = NULL;
-	return (-1);
+	return -1;
 }
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index d2ec9b2..df6b0cf 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -107,7 +107,7 @@ static int query_node_info(struct ibmad_port *ibmad_port,
 	mad_decode_field(node->info, IB_NODE_TYPE_F, &(node->type));
 	mad_decode_field(node->info, IB_NODE_NPORTS_F, &(node->numports));
 
-	return (0);
+	return 0;
 }
 
 static int query_node(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
@@ -199,9 +199,9 @@ static int extend_dpath(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
 
 	rc = add_port_to_dpath(&portid->drpath, nextport);
 
-	if ((rc != -1) && (portid->drpath.cnt > fabric->maxhops_discovered))
+	if (rc != -1 && portid->drpath.cnt > fabric->maxhops_discovered)
 		fabric->maxhops_discovered = portid->drpath.cnt;
-	return (rc);
+	return rc;
 }
 
 static void dump_endnode(ib_portid_t * path, char *prompt,
@@ -211,7 +211,7 @@ static void dump_endnode(ib_portid_t * path, char *prompt,
 	if (!show_progress)
 		return;
 
-	mad_dump_node_type(type, 64, &(node->type), sizeof(int));
+	mad_dump_node_type(type, 64, &node->type, sizeof(int));
 	printf("%s -> %s %s {%016" PRIx64 "} portnum %d base lid %d-%d\"%s\"\n",
 	       portid2str(path), prompt, type, node->guid,
 	       node->type == IB_NODE_SWITCH ? 0 : port->portnum,
@@ -239,12 +239,12 @@ ibnd_node_t *ibnd_find_node_guid(ibnd_fabric_t * fabric, uint64_t guid)
 
 	if (!fabric) {
 		IBND_DEBUG("fabric parameter NULL\n");
-		return (NULL);
+		return NULL;
 	}
 
 	for (node = fabric->nodestbl[hash]; node; node = node->htnext)
 		if (node->guid == guid)
-			return (ibnd_node_t *) node;
+			return node;
 
 	return NULL;
 }
@@ -253,15 +253,15 @@ static int _check_ibmad_port(struct ibmad_port *ibmad_port)
 {
 	if (!ibmad_port) {
 		IBND_DEBUG("ibmad_port must be specified\n");
-		return (-1);
+		return -1;
 	}
 	if (mad_rpc_class_agent(ibmad_port, IB_SMI_CLASS) == -1
 	    || mad_rpc_class_agent(ibmad_port, IB_SMI_DIRECT_CLASS) == -1) {
 		IBND_DEBUG("ibmad_port must be opened with "
 			   "IB_SMI_CLASS && IB_SMI_DIRECT_CLASS\n");
-		return (-1);
+		return -1;
 	}
-	return (0);
+	return 0;
 }
 
 ibnd_node_t *ibnd_update_node(struct ibmad_port * ibmad_port,
@@ -272,24 +272,24 @@ ibnd_node_t *ibnd_update_node(struct ibmad_port * ibmad_port,
 	int p = 0;
 
 	if (_check_ibmad_port(ibmad_port) < 0)
-		return (NULL);
+		return NULL;
 
 	if (!fabric) {
 		IBND_DEBUG("fabric parameter NULL\n");
-		return (NULL);
+		return NULL;
 	}
 
 	if (!node) {
 		IBND_DEBUG("node parameter NULL\n");
-		return (NULL);
+		return NULL;
 	}
 
 	if (query_node_info(ibmad_port, fabric, node, &(node->path_portid)))
-		return (NULL);
+		return NULL;
 
 	if (!smp_query_via(nd, &(node->path_portid), IB_ATTR_NODE_DESC, 0, 0,
 			   ibmad_port))
-		return (NULL);
+		return NULL;
 
 	/* update all the port info's */
 	for (p = 1; p >= node->numports; p++) {
@@ -303,7 +303,7 @@ ibnd_node_t *ibnd_update_node(struct ibmad_port * ibmad_port,
 	if (!smp_query_via
 	    (portinfo_port0, &(node->path_portid), IB_ATTR_PORT_INFO, 0, 0,
 	     ibmad_port))
-		return (NULL);
+		return NULL;
 
 	node->smalid = mad_get_field(portinfo_port0, 0, IB_PORT_LID_F);
 	node->smalmc = mad_get_field(portinfo_port0, 0, IB_PORT_LMC_F);
@@ -316,7 +316,7 @@ ibnd_node_t *ibnd_update_node(struct ibmad_port * ibmad_port,
 				 &node->smaenhsp0);
 
 done:
-	return (node);
+	return node;
 }
 
 ibnd_node_t *ibnd_find_node_dr(ibnd_fabric_t * fabric, char *dr_str)
@@ -327,13 +327,13 @@ ibnd_node_t *ibnd_find_node_dr(ibnd_fabric_t * fabric, char *dr_str)
 
 	if (!fabric) {
 		IBND_DEBUG("fabric parameter NULL\n");
-		return (NULL);
+		return NULL;
 	}
 
 	rc = fabric->from_node;
 
 	if (str2drpath(&path, dr_str, 0, 0) == -1) {
-		return (NULL);
+		return NULL;
 	}
 
 	for (i = 0; i <= path.cnt; i++) {
@@ -341,16 +341,16 @@ ibnd_node_t *ibnd_find_node_dr(ibnd_fabric_t * fabric, char *dr_str)
 		if (path.p[i] == 0)
 			continue;
 		if (!rc->ports)
-			return (NULL);
+			return NULL;
 
 		remote_port = rc->ports[path.p[i]]->remoteport;
 		if (!remote_port)
-			return (NULL);
+			return NULL;
 
 		rc = remote_port->node;
 	}
 
-	return (rc);
+	return rc;
 }
 
 static void add_to_nodeguid_hash(ibnd_node_t * node, ibnd_node_t * hash[])
@@ -405,7 +405,7 @@ static ibnd_node_t *create_node(ibnd_fabric_t * fabric, ibnd_scan_t * scan,
 	node = malloc(sizeof(*node));
 	if (!node) {
 		IBND_ERROR("OOM: node creation failed\n");
-		return (NULL);
+		return NULL;
 	}
 
 	memcpy(node, temp, sizeof(*node));
@@ -415,7 +415,7 @@ static ibnd_node_t *create_node(ibnd_fabric_t * fabric, ibnd_scan_t * scan,
 
 	/* add this to the all nodes list */
 	node->next = fabric->nodes;
-	fabric->nodes = (ibnd_node_t *) node;
+	fabric->nodes = node;
 
 	add_to_type_list(node, fabric);
 	add_to_nodedist(node, scan, dist);
@@ -427,9 +427,9 @@ static struct ibnd_port *find_existing_port_node(ibnd_node_t * node,
 						 ibnd_port_t * port)
 {
 	if (port->portnum > node->numports || node->ports == NULL)
-		return (NULL);
+		return NULL;
 
-	return (node->ports[port->portnum]);
+	return node->ports[port->portnum];
 }
 
 static struct ibnd_port *add_port_to_node(ibnd_fabric_t * fabric,
@@ -442,7 +442,7 @@ static struct ibnd_port *add_port_to_node(ibnd_fabric_t * fabric,
 		node->ports = calloc(sizeof(*node->ports), node->numports + 1);
 		if (!node->ports) {
 			IBND_ERROR("Failed to allocate the ports array\n");
-			return (NULL);
+			return NULL;
 		}
 	}
 
@@ -453,10 +453,10 @@ static struct ibnd_port *add_port_to_node(ibnd_fabric_t * fabric,
 	}
 
 	memcpy(port, temp, sizeof(*port));
-	port->node = (ibnd_node_t *) node;
+	port->node = node;
 	port->ext_portnum = 0;
 
-	node->ports[temp->portnum] = (ibnd_port_t *) port;
+	node->ports[temp->portnum] = port;
 
 	add_to_portguid_hash(port, fabric->portstbl);
 	return port;
@@ -498,8 +498,8 @@ static int get_remote_node(struct ibmad_port *ibmad_port,
 	    != IB_PORT_PHYS_STATE_LINKUP)
 		return 1;	/* positive == non-fatal error */
 
-	if (portnum > 0 && extend_dpath(ibmad_port, fabric, scan,
-					path, portnum) < 0)
+	if (portnum > 0 && extend_dpath(ibmad_port, fabric, scan, path,
+					portnum) < 0)
 		return -1;
 
 	if (query_node(ibmad_port, fabric, &node_buf, &port_buf, path)) {
@@ -519,9 +519,9 @@ static int get_remote_node(struct ibmad_port *ibmad_port,
 	}
 
 	oldport = find_existing_port_node(remotenode, &port_buf);
-	if (oldport) {
+	if (oldport)
 		remoteport = oldport;
-	} else if (!(remoteport = add_port_to_node(fabric, remotenode,
+	else if (!(remoteport = add_port_to_node(fabric, remotenode,
 						   &port_buf))) {
 		IBND_ERROR("OOM failed to add port to node\n");
 		rc = -1;
@@ -535,7 +535,7 @@ static int get_remote_node(struct ibmad_port *ibmad_port,
 
 error:
 	retract_dpath(path);
-	return (rc);
+	return rc;
 }
 
 ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
@@ -555,7 +555,7 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 	ibnd_scan_t scan;
 
 	if (_check_ibmad_port(ibmad_port) < 0)
-		return (NULL);
+		return NULL;
 
 	/* if not everything how much? */
 	if (hops >= 0) {
@@ -570,7 +570,7 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 
 	if (!fabric) {
 		IBND_ERROR("OOM: failed to malloc ibnd_fabric_t\n");
-		return (NULL);
+		return NULL;
 	}
 
 	memset(fabric, 0, sizeof(*fabric));
@@ -598,12 +598,12 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 		goto error;
 
 	rc = get_remote_node(ibmad_port, fabric, &scan, node, port, from,
-			     mad_get_field(node->info, 0,
-					   IB_NODE_LOCAL_PORT_F), 0);
+			     mad_get_field(node->info, 0, IB_NODE_LOCAL_PORT_F),
+			     0);
 	if (rc < 0)
 		goto error;
 	if (rc > 0)		/* non-fatal error, nothing more to be done */
-		return ((ibnd_fabric_t *) fabric);
+		return fabric;
 
 	for (dist = 0; dist <= max_hops; dist++) {
 
@@ -653,10 +653,10 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 	if (group_nodes(fabric, &scan))
 		goto error;
 
-	return ((ibnd_fabric_t *) fabric);
+	return fabric;
 error:
-	ibnd_destroy_fabric((ibnd_fabric_t *) fabric);
-	return (NULL);
+	ibnd_destroy_fabric(fabric);
+	return NULL;
 }
 
 static void destroy_node(ibnd_node_t * node)
@@ -727,9 +727,8 @@ void ibnd_iter_nodes(ibnd_fabric_t * fabric, ibnd_iter_node_func_t func,
 		return;
 	}
 
-	for (cur = fabric->nodes; cur; cur = cur->next) {
+	for (cur = fabric->nodes; cur; cur = cur->next)
 		func(cur, user_data);
-	}
 }
 
 void ibnd_iter_nodes_type(ibnd_fabric_t * fabric, ibnd_iter_node_func_t func,
@@ -763,7 +762,6 @@ void ibnd_iter_nodes_type(ibnd_fabric_t * fabric, ibnd_iter_node_func_t func,
 		break;
 	}
 
-	for (cur = list; cur; cur = cur->type_next) {
-		func((ibnd_node_t *) cur, user_data);
-	}
+	for (cur = list; cur; cur = cur->type_next)
+		func(cur, user_data);
 }
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
