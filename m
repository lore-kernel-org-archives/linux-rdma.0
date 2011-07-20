From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/3] infiniband-diags: libibnetdisc add port interface
Date: Wed, 20 Jul 2011 16:16:54 -0700
Message-ID: <20110720161654.406e442b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Add ability to find port's based on PortGUID and DRPath

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 libibnetdisc/include/infiniband/ibnetdisc.h |   11 +++
 libibnetdisc/libibnetdisc.ver               |    2 +-
 libibnetdisc/src/ibnetdisc.c                |  112 ++++++++++++++++++++-------
 libibnetdisc/src/libibnetdisc.map           |    3 +
 4 files changed, 98 insertions(+), 30 deletions(-)

diff --git a/libibnetdisc/include/infiniband/ibnetdisc.h b/libibnetdisc/include/infiniband/ibnetdisc.h
index 7b42026..300094e 100644
--- a/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -213,6 +213,17 @@ IBND_EXPORT void ibnd_iter_nodes_type(ibnd_fabric_t * fabric,
 				     int node_type, void *user_data);
 
 /** =========================================================================
+ * Port operations
+ */
+IBND_EXPORT ibnd_port_t *ibnd_find_port_guid(ibnd_fabric_t * fabric,
+					uint64_t guid);
+IBND_EXPORT ibnd_port_t *ibnd_find_port_dr(ibnd_fabric_t * fabric,
+					char *dr_str);
+typedef void (*ibnd_iter_port_func_t) (ibnd_port_t * port, void *user_data);
+IBND_EXPORT void ibnd_iter_ports(ibnd_fabric_t * fabric,
+				ibnd_iter_port_func_t func, void *user_data);
+
+/** =========================================================================
  * Chassis queries
  */
 IBND_EXPORT uint64_t ibnd_get_chassis_guid(ibnd_fabric_t * fabric,
diff --git a/libibnetdisc/libibnetdisc.ver b/libibnetdisc/libibnetdisc.ver
index 27f922f..8ff2d35 100644
--- a/libibnetdisc/libibnetdisc.ver
+++ b/libibnetdisc/libibnetdisc.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=5:1:0
+LIBVERSION=6:0:1
diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index 4a4f33b..b7fa75a 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -387,37 +387,13 @@ ibnd_node_t *ibnd_find_node_guid(ibnd_fabric_t * fabric, uint64_t guid)
 	return NULL;
 }
 
+/* forward declare */
+ibnd_port_t *ibnd_find_port_dr(ibnd_fabric_t * fabric, char *dr_str);
+
 ibnd_node_t *ibnd_find_node_dr(ibnd_fabric_t * fabric, char *dr_str)
 {
-	int i = 0;
-	ibnd_node_t *rc;
-	ib_dr_path_t path;
-
-	if (!fabric) {
-		IBND_DEBUG("fabric parameter NULL\n");
-		return NULL;
-	}
-
-	rc = fabric->from_node;
-
-	if (str2drpath(&path, dr_str, 0, 0) == -1)
-		return NULL;
-
-	for (i = 0; i <= path.cnt; i++) {
-		ibnd_port_t *remote_port = NULL;
-		if (path.p[i] == 0)
-			continue;
-		if (!rc->ports)
-			return NULL;
-
-		remote_port = rc->ports[path.p[i]]->remoteport;
-		if (!remote_port)
-			return NULL;
-
-		rc = remote_port->node;
-	}
-
-	return rc;
+	ibnd_port_t *rc = ibnd_find_port_dr(fabric, dr_str);
+	return rc->node;
 }
 
 void add_to_nodeguid_hash(ibnd_node_t * node, ibnd_node_t * hash[])
@@ -632,3 +608,81 @@ void ibnd_iter_nodes_type(ibnd_fabric_t * fabric, ibnd_iter_node_func_t func,
 	for (cur = list; cur; cur = cur->type_next)
 		func(cur, user_data);
 }
+
+ibnd_port_t *ibnd_find_port_guid(ibnd_fabric_t * fabric, uint64_t guid)
+{
+	int hash = HASHGUID(guid) % HTSZ;
+	ibnd_port_t *port;
+
+	if (!fabric) {
+		IBND_DEBUG("fabric parameter NULL\n");
+		return NULL;
+	}
+
+	for (port = fabric->portstbl[hash]; port; port = port->htnext)
+		if (port->guid == guid)
+			return port;
+
+	return NULL;
+}
+
+ibnd_port_t *ibnd_find_port_dr(ibnd_fabric_t * fabric, char *dr_str)
+{
+	int i = 0;
+	ibnd_node_t *cur_node;
+	ibnd_port_t *rc;
+	ib_dr_path_t path;
+
+	if (!fabric) {
+		IBND_DEBUG("fabric parameter NULL\n");
+		return NULL;
+	}
+
+	if (!dr_str) {
+		IBND_DEBUG("dr_str parameter NULL\n");
+		return NULL;
+	}
+
+	cur_node = fabric->from_node;
+
+	if (str2drpath(&path, dr_str, 0, 0) == -1)
+		return NULL;
+
+	for (i = 0; i <= path.cnt; i++) {
+		ibnd_port_t *remote_port = NULL;
+		if (path.p[i] == 0)
+			continue;
+		if (!cur_node->ports)
+			return NULL;
+
+		remote_port = cur_node->ports[path.p[i]]->remoteport;
+		if (!remote_port)
+			return NULL;
+
+		rc = remote_port;
+		cur_node = remote_port->node;
+	}
+
+	return rc;
+}
+
+void ibnd_iter_ports(ibnd_fabric_t * fabric, ibnd_iter_port_func_t func,
+			void *user_data)
+{
+	int i = 0;
+	ibnd_port_t *cur = NULL;
+
+	if (!fabric) {
+		IBND_DEBUG("fabric parameter NULL\n");
+		return;
+	}
+
+	if (!func) {
+		IBND_DEBUG("func parameter NULL\n");
+		return;
+	}
+
+	for (i = 0; i<HTSZ; i++)
+		for (cur = fabric->portstbl[i]; cur; cur = cur->htnext)
+			func(cur, user_data);
+}
diff --git a/libibnetdisc/src/libibnetdisc.map b/libibnetdisc/src/libibnetdisc.map
index 8a56fbb..1c42e7b 100644
--- a/libibnetdisc/src/libibnetdisc.map
+++ b/libibnetdisc/src/libibnetdisc.map
@@ -14,5 +14,8 @@ IBNETDISC_1.0 {
 		ibnd_get_chassis_slot_str;
 		ibnd_iter_nodes;
 		ibnd_iter_nodes_type;
+		ibnd_find_port_guid;
+		ibnd_find_port_dr;
+		ibnd_iter_ports;
 	local: *;
 };
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
