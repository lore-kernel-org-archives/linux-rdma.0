From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [PATCH] [2/3] use nodes/switches lists instead
	of nodesdist array in libibnetdiscover
Date: Tue, 17 Nov 2009 10:17:20 -0800
Message-ID: <1258481840.1335.96.camel@auk31.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-mwWX7HSbv3bwOtnuISKa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-mwWX7HSbv3bwOtnuISKa
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Sasha,

I noticed that that 'nodesdist' array was used for going through only
switches or all nodes in the fabric.  Spoke to Ira about it, and he
believes it's b/c in early ibnetdiscover code the 'nodesdist' array was
the only data structure available for iterating over nodes.  Now we can
use the 'nodes' list or 'switches' list, which makes it clearer to
understand what's going on and is probably the "right" data structure to
now use.  It also makes the chassis code section not dependent on the
scan specific chunks of libibnetdiscover.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-mwWX7HSbv3bwOtnuISKa
Content-Disposition: attachment; filename*0=0002-use-nodes-switches-lists-instead-of-nodesdist-array.patc; filename*1=h
Content-Type: text/plain; name=0002-use-nodes-switches-lists-instead-of-nodesdist-array.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Mon, 16 Nov 2009 17:14:56 -0800
Subject: [PATCH] use nodes/switches lists instead of nodesdist array


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/chassis.c |  124 +++++++++++----------------
 1 files changed, 51 insertions(+), 73 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/chassis.c b/infiniband-diags/libibnetdisc/src/chassis.c
index a8b6767..c11fa8d 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.c
+++ b/infiniband-diags/libibnetdisc/src/chassis.c
@@ -816,11 +816,9 @@ static void add_node_to_chassis(ibnd_chassis_t * chassis, ibnd_node_t * node)
 int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 {
 	ibnd_node_t *node;
-	int dist;
 	int chassisnum = 0;
 	ibnd_chassis_t *chassis;
 	ibnd_chassis_t *ch, *ch_next;
-	ibnd_node_scan_t *node_scan;
 
 	scan->first_chassis = NULL;
 	scan->current_chassis = NULL;
@@ -830,91 +828,71 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 	/* an appropriate chassis record (slotnum and position) */
 	/* according to internal connectivity */
 	/* not very efficient but clear code so... */
-	for (dist = 0; dist <= fabric->maxhops_discovered; dist++)
-		for (node_scan = scan->nodesdist[dist]; node_scan; node_scan = node_scan->dnext) {
-			node = node_scan->node;
-
-			if (mad_get_field(node->info, 0,
-					  IB_NODE_VENDORID_F) == VTR_VENDOR_ID
-			    && fill_voltaire_chassis_record(node))
-				goto cleanup;
-		}
+	for (node = fabric->switches; node; node = node->type_next) {
+		if (mad_get_field(node->info, 0,
+				  IB_NODE_VENDORID_F) == VTR_VENDOR_ID
+		    && fill_voltaire_chassis_record(node))
+			goto cleanup;
+	}
 
 	/* separate every Voltaire chassis from each other and build linked list of them */
 	/* algorithm: catch spine and find all surrounding nodes */
-	for (dist = 0; dist <= fabric->maxhops_discovered; dist++)
-		for (node_scan = scan->nodesdist[dist]; node_scan; node_scan = node_scan->dnext) {
-			node = node_scan->node;
-
-			if (mad_get_field(node->info, 0,
-					  IB_NODE_VENDORID_F) != VTR_VENDOR_ID)
-				continue;
-			if (!node->ch_found
-			    || (node->chassis && node->chassis->chassisnum)
-			    || !is_spine(node))
-				continue;
-			if (add_chassis(scan))
-				goto cleanup;
-			scan->current_chassis->chassisnum = ++chassisnum;
-			if (build_chassis(node, scan->current_chassis))
-				goto cleanup;
-		}
+	for (node = fabric->switches; node; node = node->type_next) {
+		if (mad_get_field(node->info, 0,
+				  IB_NODE_VENDORID_F) != VTR_VENDOR_ID)
+			continue;
+		if (!node->ch_found
+		    || (node->chassis && node->chassis->chassisnum)
+		    || !is_spine(node))
+			continue;
+		if (add_chassis(scan))
+			goto cleanup;
+		scan->current_chassis->chassisnum = ++chassisnum;
+		if (build_chassis(node, scan->current_chassis))
+			goto cleanup;
+	}
 
 	/* now make pass on nodes for chassis which are not Voltaire */
 	/* grouped by common SystemImageGUID */
-	for (dist = 0; dist <= fabric->maxhops_discovered; dist++)
-		for (node_scan = scan->nodesdist[dist]; node_scan; node_scan = node_scan->dnext) {
-			node = node_scan->node;
-
-			if (mad_get_field(node->info, 0,
-					  IB_NODE_VENDORID_F) == VTR_VENDOR_ID)
-				continue;
-			if (mad_get_field64(node->info, 0,
-					    IB_NODE_SYSTEM_GUID_F)) {
-				chassis =
-				    find_chassisguid(fabric, node);
-				if (chassis)
-					chassis->nodecount++;
-				else {
-					/* Possible new chassis */
-					if (add_chassis(scan))
-						goto cleanup;
-					scan->current_chassis->chassisguid =
-					    get_chassisguid(node);
-					scan->current_chassis->nodecount = 1;
-				}
+	for (node = fabric->switches; node; node = node->type_next) {
+		if (mad_get_field(node->info, 0,
+				  IB_NODE_VENDORID_F) == VTR_VENDOR_ID)
+			continue;
+		if (mad_get_field64(node->info, 0,
+				    IB_NODE_SYSTEM_GUID_F)) {
+			chassis = find_chassisguid(fabric, node);
+			if (chassis)
+				chassis->nodecount++;
+			else {
+				/* Possible new chassis */
+				if (add_chassis(scan))
+					goto cleanup;
+				scan->current_chassis->chassisguid =
+				    get_chassisguid(node);
+				scan->current_chassis->nodecount = 1;
 			}
 		}
+	}
 
 	/* now, make another pass to see which nodes are part of chassis */
 	/* (defined as chassis->nodecount > 1) */
-	for (dist = 0; dist <= MAXHOPS;) {
-		for (node_scan = scan->nodesdist[dist]; node_scan; node_scan = node_scan->dnext) {
-			node = node_scan->node;
-
-			if (mad_get_field(node->info, 0,
-					  IB_NODE_VENDORID_F) == VTR_VENDOR_ID)
-				continue;
-			if (mad_get_field64(node->info, 0,
-					    IB_NODE_SYSTEM_GUID_F)) {
-				chassis =
-				    find_chassisguid(fabric, node);
-				if (chassis && chassis->nodecount > 1) {
-					if (!chassis->chassisnum)
-						chassis->chassisnum =
-						    ++chassisnum;
-					if (!node->ch_found) {
-						node->ch_found = 1;
-						add_node_to_chassis(chassis,
-								    node);
-					}
+	for (node = fabric->nodes; node; node = node->next) {
+		if (mad_get_field(node->info, 0,
+				  IB_NODE_VENDORID_F) == VTR_VENDOR_ID)
+			continue;
+		if (mad_get_field64(node->info, 0,
+				    IB_NODE_SYSTEM_GUID_F)) {
+			chassis = find_chassisguid(fabric, node);
+			if (chassis && chassis->nodecount > 1) {
+				if (!chassis->chassisnum)
+					chassis->chassisnum =
+					    ++chassisnum;
+				if (!node->ch_found) {
+					node->ch_found = 1;
+					add_node_to_chassis(chassis, node);
 				}
 			}
 		}
-		if (dist == fabric->maxhops_discovered)
-			dist = MAXHOPS;	/* skip to CAs */
-		else
-			dist++;
 	}
 
 	fabric->chassis = scan->first_chassis;
-- 
1.5.4.5


--=-mwWX7HSbv3bwOtnuISKa--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
