From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [PATCH] split out scan specific data from
	ibnd_node_t [attempt #2]
Date: Fri, 13 Nov 2009 09:52:16 -0800
Message-ID: <1258134736.31785.297.camel@auk31.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-fsqaDHzxh1Y4qPyp+38G"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-fsqaDHzxh1Y4qPyp+38G
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This splits out some scan specific data from ibnd_node_t that doesn't
need to be in the public struct.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-fsqaDHzxh1Y4qPyp+38G
Content-Disposition: attachment; filename=0001-split-out-scan-specific-data-from-ibnd_node_t.patch
Content-Type: text/plain; name=0001-split-out-scan-specific-data-from-ibnd_node_t.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

>From 75f819d436218be0c9bab7d0a6e763b4054748dd Mon Sep 17 00:00:00 2001
From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 29 Oct 2009 18:59:26 -0700
Subject: [PATCH] split out scan specific data from ibnd_node_t


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 .../libibnetdisc/include/infiniband/ibnetdisc.h    |    1 -
 infiniband-diags/libibnetdisc/src/chassis.c        |   18 ++++++--
 infiniband-diags/libibnetdisc/src/ibnetdisc.c      |   47 +++++++++++++++++--
 infiniband-diags/libibnetdisc/src/internal.h       |    7 +++-
 4 files changed, 62 insertions(+), 11 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index e8ceff7..8d5ac39 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -86,7 +86,6 @@ typedef struct ibnd_node {
 	/* internal use only */
 	unsigned char ch_found;
 	struct ibnd_node *htnext;	/* hash table list */
-	struct ibnd_node *dnext;	/* nodesdist next */
 	struct ibnd_node *type_next;	/* next based on type */
 } ibnd_node_t;
 
diff --git a/infiniband-diags/libibnetdisc/src/chassis.c b/infiniband-diags/libibnetdisc/src/chassis.c
index 15c17d2..3bd0108 100644
--- a/infiniband-diags/libibnetdisc/src/chassis.c
+++ b/infiniband-diags/libibnetdisc/src/chassis.c
@@ -822,6 +822,7 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 	int chassisnum = 0;
 	ibnd_chassis_t *chassis;
 	ibnd_chassis_t *ch, *ch_next;
+	ibnd_node_scan_t *node_scan;
 
 	scan->first_chassis = NULL;
 	scan->current_chassis = NULL;
@@ -832,16 +833,21 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 	/* according to internal connectivity */
 	/* not very efficient but clear code so... */
 	for (dist = 0; dist <= fabric->maxhops_discovered; dist++)
-		for (node = scan->nodesdist[dist]; node; node = node->dnext)
+		for (node_scan = scan->nodesdist[dist]; node_scan; node_scan = node_scan->dnext) {
+			node = node_scan->node;
+
 			if (mad_get_field(node->info, 0,
 					  IB_NODE_VENDORID_F) == VTR_VENDOR_ID
 			    && fill_voltaire_chassis_record(node))
 				goto cleanup;
+		}
 
 	/* separate every Voltaire chassis from each other and build linked list of them */
 	/* algorithm: catch spine and find all surrounding nodes */
 	for (dist = 0; dist <= fabric->maxhops_discovered; dist++)
-		for (node = scan->nodesdist[dist]; node; node = node->dnext) {
+		for (node_scan = scan->nodesdist[dist]; node_scan; node_scan = node_scan->dnext) {
+			node = node_scan->node;
+
 			if (mad_get_field(node->info, 0,
 					  IB_NODE_VENDORID_F) != VTR_VENDOR_ID)
 				continue;
@@ -859,7 +865,9 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 	/* now make pass on nodes for chassis which are not Voltaire */
 	/* grouped by common SystemImageGUID */
 	for (dist = 0; dist <= fabric->maxhops_discovered; dist++)
-		for (node = scan->nodesdist[dist]; node; node = node->dnext) {
+		for (node_scan = scan->nodesdist[dist]; node_scan; node_scan = node_scan->dnext) {
+			node = node_scan->node;
+
 			if (mad_get_field(node->info, 0,
 					  IB_NODE_VENDORID_F) == VTR_VENDOR_ID)
 				continue;
@@ -885,7 +893,9 @@ int group_nodes(ibnd_fabric_t * fabric, ibnd_scan_t *scan)
 	/* now, make another pass to see which nodes are part of chassis */
 	/* (defined as chassis->nodecount > 1) */
 	for (dist = 0; dist <= MAXHOPS;) {
-		for (node = scan->nodesdist[dist]; node; node = node->dnext) {
+		for (node_scan = scan->nodesdist[dist]; node_scan; node_scan = node_scan->dnext) {
+			node = node_scan->node;
+
 			if (mad_get_field(node->info, 0,
 					  IB_NODE_VENDORID_F) == VTR_VENDOR_ID)
 				continue;
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index ec8b70a..7938fdc 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -320,13 +320,25 @@ static void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric)
 	}
 }
 
-static void add_to_nodedist(ibnd_node_t * node, ibnd_scan_t * scan, int dist)
+static int add_to_nodedist(ibnd_node_t * node, ibnd_scan_t * scan,
+			   ib_portid_t * path, int dist)
 {
+	ibnd_node_scan_t *node_scan;
+
+	node_scan = malloc(sizeof(*node_scan));
+	if (!node_scan) {
+		IBND_ERROR("OOM: node scan creation failed\n");
+		return -1;
+	}
+	node_scan->node = node;
+
 	if (node->type != IB_NODE_SWITCH)
 		dist = MAXHOPS;	/* special Ca list */
 
-	node->dnext = scan->nodesdist[dist];
-	scan->nodesdist[dist] = node;
+	node_scan->dnext = scan->nodesdist[dist];
+	scan->nodesdist[dist] = node_scan;
+	
+	return 0;
 }
 
 static ibnd_node_t *create_node(ibnd_fabric_t * fabric, ibnd_scan_t * scan,
@@ -351,7 +363,11 @@ static ibnd_node_t *create_node(ibnd_fabric_t * fabric, ibnd_scan_t * scan,
 	fabric->nodes = node;
 
 	add_to_type_list(node, fabric);
-	add_to_nodedist(node, scan, dist);
+
+	if (add_to_nodedist(node, scan, path, dist) < 0) {
+		free(node);
+		return NULL;
+	}
 
 	return node;
 }
@@ -471,6 +487,23 @@ error:
 	return rc;
 }
 
+static void ibnd_scan_destroy(ibnd_scan_t *scan)
+{
+	int dist = 0;
+	int max_hops = MAXHOPS - 1;
+	ibnd_node_scan_t *node_scan;
+	ibnd_node_scan_t *next;
+
+	for (dist = 0; dist <= max_hops; dist++) {
+		node_scan = scan->nodesdist[dist];
+		while (node_scan) {
+			next = node_scan->dnext;
+			free(node_scan);
+			node_scan = next;
+		}
+	}
+}
+
 ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 				    ib_portid_t * from, int hops)
 {
@@ -480,6 +513,7 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 	ibnd_node_t node_buf;
 	ibnd_port_t port_buf;
 	ibnd_node_t *node;
+	ibnd_node_scan_t *node_scan;
 	ibnd_port_t *port;
 	int i;
 	int dist = 0;
@@ -540,7 +574,8 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 
 	for (dist = 0; dist <= max_hops; dist++) {
 
-		for (node = scan.nodesdist[dist]; node; node = node->dnext) {
+		for (node_scan = scan.nodesdist[dist]; node_scan; node_scan = node_scan->dnext) {
+			node = node_scan->node;
 
 			path = &node->path_portid;
 
@@ -586,8 +621,10 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 	if (group_nodes(fabric, &scan))
 		goto error;
 
+	ibnd_scan_destroy(&scan);
 	return fabric;
 error:
+	ibnd_scan_destroy(&scan);
 	ibnd_destroy_fabric(fabric);
 	return NULL;
 }
diff --git a/infiniband-diags/libibnetdisc/src/internal.h b/infiniband-diags/libibnetdisc/src/internal.h
index eac1a29..6776285 100644
--- a/infiniband-diags/libibnetdisc/src/internal.h
+++ b/infiniband-diags/libibnetdisc/src/internal.h
@@ -52,8 +52,13 @@
 
 #define MAXHOPS         63
 
+typedef struct ibnd_node_scan {
+	ibnd_node_t *node;
+	struct ibnd_node_scan *dnext;	/* nodesdist next */
+} ibnd_node_scan_t;
+
 typedef struct ibnd_scan {
-	ibnd_node_t *nodesdist[MAXHOPS + 1];
+	ibnd_node_scan_t *nodesdist[MAXHOPS + 1];
 	ibnd_chassis_t *first_chassis;
 	ibnd_chassis_t *current_chassis;
 	ibnd_chassis_t *last_chassis;
-- 
1.5.4.5


--=-fsqaDHzxh1Y4qPyp+38G--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
