From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] ibqueryerrors.c: Optimize by querying AllPortSelect first
Date: Thu, 10 Jun 2010 17:34:34 -0700
Message-ID: <20100610173434.890ea8e7.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-n5fQTqcq6rtliZ7u+bvwcg@public.gmane.org>
Date: Thu, 6 May 2010 13:49:55 -0700
Subject: [PATCH] ibqueryerrors.c: Optimize by querying AllPortSelect first

	If errors are seen with AllPortSelect query individual ports for more
	details.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/src/ibqueryerrors.c |   55 +++++++++++++++++++++++----------
 1 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index f04e47f..e0b1c0b 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -245,9 +245,9 @@ static int query_and_dump(char *buf, size_t size, ib_portid_t * portid,
 	return n;
 }
 
-static void print_results(ib_portid_t * portid, char *node_name,
-			  ibnd_node_t * node, uint8_t * pc, int portnum,
-			  int *header_printed)
+static int print_results(ib_portid_t * portid, char *node_name,
+			 ibnd_node_t * node, uint8_t * pc, int portnum,
+			 int *header_printed)
 {
 	char buf[1024];
 	char *str = buf;
@@ -311,11 +311,16 @@ static void print_results(ib_portid_t * portid, char *node_name,
 			*header_printed = 1;
 		}
 
-		printf("   GUID 0x%" PRIx64 " port %d:%s\n", node->guid,
-		       portnum, str);
-		if (port_config)
+		if (portnum == 0xFF)
+			printf("   GUID 0x%" PRIx64 " port ALL:%s\n",
+			       node->guid, str);
+		else
+			printf("   GUID 0x%" PRIx64 " port %d:%s\n",
+			       node->guid, portnum, str);
+		if (portnum != 0xFF && port_config)
 			print_port_config(node_name, node, portnum);
 	}
+	return (n);
 }
 
 static int query_cap_mask(ib_portid_t * portid, char *node_name, int portnum,
@@ -339,8 +344,8 @@ static int query_cap_mask(ib_portid_t * portid, char *node_name, int portnum,
 	return 0;
 }
 
-static void print_port(ib_portid_t * portid, uint16_t cap_mask, char *node_name,
-		       ibnd_node_t * node, int portnum, int *header_printed)
+static int print_port(ib_portid_t * portid, uint16_t cap_mask, char *node_name,
+		      ibnd_node_t * node, int portnum, int *header_printed)
 {
 	uint8_t pc[1024];
 
@@ -350,14 +355,15 @@ static void print_port(ib_portid_t * portid, uint16_t cap_mask, char *node_name,
 			   IB_GSI_PORT_COUNTERS, ibmad_port)) {
 		IBWARN("IB_GSI_PORT_COUNTERS query failed on %s, %s port %d",
 		       node_name, portid2str(portid), portnum);
-		return;
+		return (0);
 	}
 	if (!(cap_mask & 0x1000)) {
 		/* if PortCounters:PortXmitWait not supported clear this counter */
 		uint32_t foo = 0;
 		mad_encode_field(pc, IB_PC_XMT_WAIT_F, &foo);
 	}
-	print_results(portid, node_name, node, pc, portnum, header_printed);
+	return (print_results(portid, node_name, node, pc, portnum,
+			      header_printed));
 }
 
 static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
@@ -425,6 +431,27 @@ void print_node(ibnd_node_t * node, void *user_data)
 
 	node_name = remap_node_name(node_name_map, node->guid, node->nodedesc);
 
+	if (node->type == IB_NODE_SWITCH) {
+		ib_portid_set(&portid, node->smalid, 0, 0);
+		p = 0;
+	} else {
+		for (p = 1; p <= node->numports; p++) {
+			if (node->ports[p]) {
+				ib_portid_set(&portid,
+					      node->ports[p]->base_lid,
+					      0, 0);
+				break;
+			}
+		}
+	}
+	if ((query_cap_mask(&portid, node_name, p, &cap_mask) == 0) &&
+	    (cap_mask & 0x100)) {
+		all_port_sup = 1;
+		if (!print_port(&portid, cap_mask, node_name, node,
+				0xFF, &header_printed))
+			goto clear;
+	}
+
 	for (p = startport; p <= node->numports; p++) {
 		if (node->ports[p]) {
 			if (node->type == IB_NODE_SWITCH)
@@ -433,13 +460,6 @@ void print_node(ibnd_node_t * node, void *user_data)
 				ib_portid_set(&portid, node->ports[p]->base_lid,
 					      0, 0);
 
-			if (query_cap_mask(&portid, node_name, p, &cap_mask) <
-			    0)
-				continue;
-
-			if (cap_mask & 0x100)
-				all_port_sup = 1;
-
 			print_port(&portid, cap_mask, node_name, node, p,
 				   &header_printed);
 			if (!all_port_sup)
@@ -447,6 +467,7 @@ void print_node(ibnd_node_t * node, void *user_data)
 		}
 	}
 
+clear:
 	if (all_port_sup)
 		clear_port(&portid, cap_mask, node_name, 0xFF);
 
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
