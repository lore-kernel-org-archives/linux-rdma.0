From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] libibnetdisc: Avoid pushing same pointer
 to the hash table
Date: Wed, 30 Sep 2015 08:53:51 -0400
Message-ID: <560BDB5F.2040001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dan Ben-Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch avoids pushing the same pointer to the hash table that causes
endless loop during dumping.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibnetdisc/src/ibnetdisc.c       |   39 ++++++++++++++++++++++++++++++++---
 libibnetdisc/src/ibnetdisc_cache.c |   19 ++++++++++++++--
 libibnetdisc/src/internal.h        |    4 +-
 3 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index e0f2d78..938a516 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -353,7 +353,12 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 		port->lmc = node->smalmc;
 	}
 
-	add_to_portguid_hash(port, f_int->fabric.portstbl);
+	int rc1 = add_to_portguid_hash(port, f_int->fabric.portstbl);
+	if (rc1)
+		IBND_ERROR("Error Occurred when trying"
+			   " to insert new port guid 0x%016" PRIx64 " to DB\n",
+			   port->guid);
+
 	add_to_portlid_hash(port, f_int->lid2guid);
 
 	if ((scan->cfg->flags & IBND_CONFIG_MLX_EPI)
@@ -458,7 +463,11 @@ static ibnd_node_t *create_node(smp_engine_t * engine, ib_portid_t * path,
 	rc->path_portid = *path;
 	memcpy(rc->info, node_info, sizeof(rc->info));
 
-	add_to_nodeguid_hash(rc, f_int->fabric.nodestbl);
+	int rc1 = add_to_nodeguid_hash(rc, f_int->fabric.nodestbl);
+	if (rc1)
+		IBND_ERROR("Error Occurred when trying"
+			   " to insert new node guid 0x%016" PRIx64 " to DB\n",
+			   rc->guid);
 
 	/* add this to the all nodes list */
 	rc->next = f_int->fabric.nodes;
@@ -607,20 +616,42 @@ ibnd_node_t *ibnd_find_node_dr(ibnd_fabric_t * fabric, char *dr_str)
 	return rc->node;
 }
 
-void add_to_nodeguid_hash(ibnd_node_t * node, ibnd_node_t * hash[])
+int add_to_nodeguid_hash(ibnd_node_t * node, ibnd_node_t * hash[])
 {
+	int rc = 0;
+	ibnd_node_t *tblnode;
 	int hash_idx = HASHGUID(node->guid) % HTSZ;
 
+	for (tblnode = hash[hash_idx]; tblnode; tblnode = tblnode->htnext) {
+		if (tblnode == node) {
+			IBND_ERROR("Duplicate Node: Node with guid 0x%016"
+				   PRIx64 " already exists in nodes DB\n",
+				   node->guid);
+			return 1;
+		}
+	}
 	node->htnext = hash[hash_idx];
 	hash[hash_idx] = node;
+	return rc;
 }
 
-void add_to_portguid_hash(ibnd_port_t * port, ibnd_port_t * hash[])
+int add_to_portguid_hash(ibnd_port_t * port, ibnd_port_t * hash[])
 {
+	int rc = 0;
+	ibnd_port_t *tblport;
 	int hash_idx = HASHGUID(port->guid) % HTSZ;
 
+	for (tblport = hash[hash_idx]; tblport; tblport = tblport->htnext) {
+		if (tblport == port) {
+			IBND_ERROR("Duplicate Port: Port with guid 0x%016"
+				   PRIx64 " already exists in ports DB\n",
+				   port->guid);
+			return 1;
+		}
+	}
 	port->htnext = hash[hash_idx];
 	hash[hash_idx] = port;
+	return rc;
 }
 
 void create_lid2guid(f_internal_t *f_int)
diff --git a/libibnetdisc/src/ibnetdisc_cache.c b/libibnetdisc/src/ibnetdisc_cache.c
index d4663bf..94dd004 100644
--- a/libibnetdisc/src/ibnetdisc_cache.c
+++ b/libibnetdisc/src/ibnetdisc_cache.c
@@ -515,7 +515,13 @@ static int _fill_port(ibnd_fabric_cache_t * fabric_cache, ibnd_node_t * node,
 	/* achu: needed if user wishes to re-cache a loaded fabric.
 	 * Otherwise, mostly unnecessary to do this.
 	 */
-	add_to_portguid_hash(port_cache->port, fabric_cache->f_int->fabric.portstbl);
+	int rc = add_to_portguid_hash(port_cache->port,
+				      fabric_cache->f_int->fabric.portstbl);
+	if (rc) {
+		IBND_DEBUG("Error Occurred when trying"
+			   " to insert new port guid 0x%016" PRIx64 " to DB\n",
+			   port_cache->port->guid);
+	}
 	return 0;
 }
 
@@ -538,8 +544,15 @@ static int _rebuild_nodes(ibnd_fabric_cache_t * fabric_cache)
 		node->next = fabric_cache->f_int->fabric.nodes;
 		fabric_cache->f_int->fabric.nodes = node;
 
-		add_to_nodeguid_hash(node_cache->node,
-				     fabric_cache->f_int->fabric.nodestbl);
+		int rc = add_to_nodeguid_hash(node_cache->node,
+					      fabric_cache->
+					      f_int->
+					      fabric.nodestbl);
+		if (rc) {
+			IBND_DEBUG("Error Occurred when trying"
+				   " to insert new node guid 0x%016" PRIx64 " to DB\n",
+				   node_cache->node->guid);
+		}
 
 		add_to_type_list(node_cache->node, fabric_cache->f_int);
 
diff --git a/libibnetdisc/src/internal.h b/libibnetdisc/src/internal.h
index a50d2d7..5a32cd2 100644
--- a/libibnetdisc/src/internal.h
+++ b/libibnetdisc/src/internal.h
@@ -106,9 +106,9 @@ int issue_smp(smp_engine_t * engine, ib_portid_t * portid,
 int process_mads(smp_engine_t * engine);
 void smp_engine_destroy(smp_engine_t * engine);
 
-void add_to_nodeguid_hash(ibnd_node_t * node, ibnd_node_t * hash[]);
+int add_to_nodeguid_hash(ibnd_node_t * node, ibnd_node_t * hash[]);
 
-void add_to_portguid_hash(ibnd_port_t * port, ibnd_port_t * hash[]);
+int add_to_portguid_hash(ibnd_port_t * port, ibnd_port_t * hash[]);
 void add_to_portlid_hash(ibnd_port_t * port, GHashTable *htable);
 
 void add_to_type_list(ibnd_node_t * node, f_internal_t * fabric);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
