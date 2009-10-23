From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibqueryerrors.c: use common portid in
 query_cap_mask()
Date: Fri, 23 Oct 2009 18:33:37 +0200
Message-ID: <20091023163337.GB718@me>
References: <20090924235011.a9a16022.weiny2@llnl.gov>
 <f0e08f230909250707t36c1ebc4od5df33e36f6cd38a@mail.gmail.com>
 <20090925093358.f9f747d4.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090925093358.f9f747d4.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Use common portid in query_cap_mask() function instead of generating
this again in this function.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 infiniband-diags/src/ibqueryerrors.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
index 697afd1..fdd9246 100644
--- a/infiniband-diags/src/ibqueryerrors.c
+++ b/infiniband-diags/src/ibqueryerrors.c
@@ -261,23 +261,18 @@ static void print_results(ibnd_node_t * node, uint8_t * pc, int portnum,
 	}
 }
 
-static int query_cap_mask(ibnd_node_t * node, int portnum, uint16_t * cap_mask)
+static int query_cap_mask(ib_portid_t *portid, ibnd_node_t * node, int portnum,
+			  uint16_t * cap_mask)
 {
 	uint8_t pc[1024];
 	uint16_t rc_cap_mask;
-	ib_portid_t portid = { 0 };
-
-	if (node->type == IB_NODE_SWITCH)
-		ib_portid_set(&portid, node->smalid, 0, 0);
-	else
-		ib_portid_set(&portid, node->ports[portnum]->base_lid, 0, 0);
 
 	/* PerfMgt ClassPortInfo is a required attribute */
-	if (!pma_query_via(pc, &portid, portnum, ibd_timeout, CLASS_PORT_INFO,
+	if (!pma_query_via(pc, portid, portnum, ibd_timeout, CLASS_PORT_INFO,
 			   ibmad_port)) {
 		IBWARN("classportinfo query failed on %s, %s port %d",
 		       remap_node_name(node_name_map, node->guid,
-				       node->nodedesc), portid2str(&portid),
+				       node->nodedesc), portid2str(portid),
 		       portnum);
 		return -1;
 	}
@@ -371,18 +366,18 @@ void print_node(ibnd_node_t * node, void *user_data)
 
 	for (p = startport; p <= node->numports; p++) {
 		if (node->ports[p]) {
-			if (query_cap_mask(node, p, &cap_mask) < 0)
-				continue;
-
-			if (cap_mask & 0x100)
-				all_port_sup = 1;
-
 			if (node->type == IB_NODE_SWITCH)
 				ib_portid_set(&portid, node->smalid, 0, 0);
 			else
 				ib_portid_set(&portid, node->ports[p]->base_lid,
 					      0, 0);
 
+			if (query_cap_mask(&portid, node, p, &cap_mask) < 0)
+				continue;
+
+			if (cap_mask & 0x100)
+				all_port_sup = 1;
+
 			print_port(&portid, cap_mask, node, p, &header_printed);
 			if (!all_port_sup)
 				clear_port(&portid, cap_mask, node, p);
-- 
1.6.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
