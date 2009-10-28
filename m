From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [PATCH] [2/2] remove 'dist' field from
	ibnd_node_t, which was virtually not used
Date: Wed, 28 Oct 2009 16:52:11 -0700
Message-ID: <1256773931.4819.192.camel@auk31.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-NXIPpj9/UbZY/n8sXK4O"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-NXIPpj9/UbZY/n8sXK4O
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Remove the 'dist' field from the ibnd_node_t struct and rearch code
appropriately.  It ends up this field was only used to pass a value from
create_node() to add_to_nodedist(), of which create_node() is the only
function that calls add_to_nodedist().  In other words, it served pretty
much no purpose.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-NXIPpj9/UbZY/n8sXK4O
Content-Disposition: attachment; filename=0002-remove-dist-field-from-ibnd_node_t-which-was-virt.patch
Content-Type: text/plain; name=0002-remove-dist-field-from-ibnd_node_t-which-was-virt.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Wed, 28 Oct 2009 16:18:39 -0700
Subject: [PATCH] remove 'dist' field from ibnd_node_t, which was virtually not used


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 .../libibnetdisc/include/infiniband/ibnetdisc.h    |    1 -
 infiniband-diags/libibnetdisc/src/ibnetdisc.c      |    6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index 8303175..a8d290c 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -48,7 +48,6 @@ typedef struct ibnd_node {
 	struct ibnd_node *next;	/* all node list in fabric */
 
 	ib_portid_t path_portid;	/* path from "from_node" */
-	int dist;		/* num of hops from "from_node" */
 	int smalid;
 	int smalmc;
 
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index b25c3d0..047b705 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -387,9 +387,8 @@ static void add_to_type_list(ibnd_node_t * node, ibnd_fabric_t * fabric)
 	}
 }
 
-static void add_to_nodedist(ibnd_node_t * node, ibnd_scan_t * ibnd_scan)
+static void add_to_nodedist(ibnd_node_t * node, ibnd_scan_t * ibnd_scan, int dist)
 {
-	int dist = node->dist;
 	if (node->type != IB_NODE_SWITCH)
 		dist = MAXHOPS;	/* special Ca list */
 
@@ -410,7 +409,6 @@ static ibnd_node_t *create_node(ibnd_fabric_t * fabric, ibnd_scan_t * ibnd_scan,
 	}
 
 	memcpy(node, temp, sizeof(*node));
-	node->dist = dist;
 	node->path_portid = *path;
 
 	add_to_nodeguid_hash(node, fabric->nodestbl);
@@ -420,7 +418,7 @@ static ibnd_node_t *create_node(ibnd_fabric_t * fabric, ibnd_scan_t * ibnd_scan,
 	fabric->nodes = (ibnd_node_t *) node;
 
 	add_to_type_list(node, fabric);
-	add_to_nodedist(node, ibnd_scan);
+	add_to_nodedist(node, ibnd_scan, dist);
 
 	return node;
 }
-- 
1.5.4.5


--=-NXIPpj9/UbZY/n8sXK4O--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
