From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [infiniband-diags] [PATCH] [2/2] split out scan specific data
	from ibnd_node_t
Date: Mon, 02 Nov 2009 13:11:56 -0800
Message-ID: <1257196316.580.33.camel@auk31.llnl.gov>
References: <1257190401.580.31.camel@auk31.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ZnlYBEQ3AcafzuG697Rs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1257190401.580.31.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-ZnlYBEQ3AcafzuG697Rs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Sasha,

Oops.  I forgot to free the newly created memory.  Here's a new patch.

Al

On Mon, 2009-11-02 at 11:33 -0800, Al Chu wrote:
> Hey Sasha,
> 
> This splits out some scan specific data from ibnd_node_t that doesn't
> need to be in the public struct.
> 
> Al
> 
-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-ZnlYBEQ3AcafzuG697Rs
Content-Disposition: attachment; filename=0002-split-out-scan-specific-data-from-ibnd_node_t.patch
Content-Type: text/plain; name=0002-split-out-scan-specific-data-from-ibnd_node_t.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 29 Oct 2009 18:59:26 -0700
Subject: [PATCH] split out scan specific data from ibnd_node_t


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 .../libibnetdisc/include/infiniband/ibnetdisc.h    |    2 -
 infiniband-diags/libibnetdisc/src/chassis.c        |   18 +++++--
 infiniband-diags/libibnetdisc/src/ibnetdisc.c      |   51 +++++++++++++++++---
 infiniband-diags/libibnetdisc/src/internal.h       |    8 +++-
 4 files changed, 65 insertions(+), 14 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index 6120453..f1cb00c 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -48,7 +48,6 @@ struct ibnd_port;		/* forward declare */
 typedef struct ibnd_node {
 	struct ibnd_node *next;	/* all node list in fabric */
 
-	ib_portid_t path_portid;	/* path from "from_node" */
 	int smalid;
 	int smalmc;
 
@@ -81,7 +80,6 @@ typedef struct ibnd_node {
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
index ffa35e4..233654c 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -332,13 +332,26 @@ static void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric)
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
+	node_scan->path_portid = *path;
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
@@ -354,7 +367,6 @@ static ibnd_node_t *create_node(ibnd_fabric_t * fabric, ibnd_scan_t * scan,
 	}
 
 	memcpy(node, temp, sizeof(*node));
-	node->path_portid = *path;
 
 	add_to_nodeguid_hash(node, fabric->nodestbl);
 
@@ -363,7 +375,11 @@ static ibnd_node_t *create_node(ibnd_fabric_t * fabric, ibnd_scan_t * scan,
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
@@ -483,6 +499,23 @@ error:
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
@@ -492,6 +525,7 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 	ibnd_node_t node_buf;
 	ibnd_port_t port_buf;
 	ibnd_node_t *node;
+	ibnd_node_scan_t *node_scan;
 	ibnd_port_t *port;
 	int i;
 	int dist = 0;
@@ -552,9 +586,10 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 
 	for (dist = 0; dist <= max_hops; dist++) {
 
-		for (node = scan.nodesdist[dist]; node; node = node->dnext) {
+		for (node_scan = scan.nodesdist[dist]; node_scan; node_scan = node_scan->dnext) {
+			node = node_scan->node;
 
-			path = &node->path_portid;
+			path = &node_scan->path_portid;
 
 			IBND_DEBUG("dist %d node %p\n", dist, node);
 			dump_endnode(path, "processing", node, port);
@@ -598,8 +633,10 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
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
index eac1a29..d8bcf87 100644
--- a/infiniband-diags/libibnetdisc/src/internal.h
+++ b/infiniband-diags/libibnetdisc/src/internal.h
@@ -52,8 +52,14 @@
 
 #define MAXHOPS         63
 
+typedef struct ibnd_node_scan {
+	ibnd_node_t *node;
+	ib_portid_t path_portid;	/* path from "from_node" */
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


--=-ZnlYBEQ3AcafzuG697Rs--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
