From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibqueryerrors: Use remap'ed node name in
 clear port error message
Date: Tue, 27 Oct 2009 10:22:39 -0700
Message-ID: <20091027102239.9fd7690e.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 27 Oct 2009 10:22:36 -0700
Subject: [PATCH] infiniband-diags/ibqueryerrors: Use remap'ed node name in clear port error message


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/src/ibqueryerrors.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index 625bd8e..a29e649 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -295,7 +295,7 @@ static void print_port(ib_portid_t * portid, uint16_t cap_mask, char *node_name,
 }
 
 static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
-		       ibnd_node_t * node, int port)
+		       char * node_name, int port)
 {
 	uint8_t pc[1024];
 	/* bits defined in Table 228 PortCounters CounterSelect and
@@ -317,7 +317,7 @@ static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
 	if (!performance_reset_via(pc, portid, port, mask, ibd_timeout,
 				   IB_GSI_PORT_COUNTERS, ibmad_port))
 		IBERROR("Failed to reset errors %s port %d",
-			node->nodedesc, port);
+			node_name, port);
 }
 
 void print_node(ibnd_node_t * node, void *user_data)
@@ -329,6 +329,7 @@ void print_node(ibnd_node_t * node, void *user_data)
 	int all_port_sup = 0;
 	ib_portid_t portid = { 0 };
 	uint16_t cap_mask = 0;
+	char *node_name = NULL;
 
 	switch (node->type) {
 	case IB_NODE_SWITCH:
@@ -348,9 +349,10 @@ void print_node(ibnd_node_t * node, void *user_data)
 	if (node->type == IB_NODE_SWITCH && node->smaenhsp0)
 		startport = 0;
 
+	node_name = remap_node_name(node_name_map, node->guid,
+				    node->nodedesc);
+
 	for (p = startport; p <= node->numports; p++) {
-		char *node_name = remap_node_name(node_name_map, node->guid,
-						  node->nodedesc);
 		if (node->ports[p]) {
 			if (node->type == IB_NODE_SWITCH)
 				ib_portid_set(&portid, node->smalid, 0, 0);
@@ -367,13 +369,14 @@ void print_node(ibnd_node_t * node, void *user_data)
 			print_port(&portid, cap_mask, node_name, node, p,
 				   &header_printed);
 			if (!all_port_sup)
-				clear_port(&portid, cap_mask, node, p);
+				clear_port(&portid, cap_mask, node_name, p);
 		}
-		free(node_name);
 	}
 
 	if (all_port_sup)
-		clear_port(&portid, cap_mask, node, 0xFF);
+		clear_port(&portid, cap_mask, node_name, 0xFF);
+
+	free(node_name);
 }
 
 static void add_suppressed(enum MAD_FIELDS field)
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
