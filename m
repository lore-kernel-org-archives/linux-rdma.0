From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/2] infiniband-diags/libibnetdisc: Remove nearly duplicate
 "get_node_info" function
Date: Tue, 10 Nov 2009 14:01:35 -0800
Message-ID: <20091110140135.0853ca2d.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Date: Tue, 10 Nov 2009 13:51:41 -0800
Subject: [PATCH] infiniband-diags/libibnetdisc: Remove nearly duplicate "get_node_info" function

	Fold remaining functionality into "query_port_info"

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/libibnetdisc/src/ibnetdisc.c |   33 ++++++++----------------
 1 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index 3f62f3f..688382a 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -60,32 +60,20 @@ int ibdebug;
 int query_port_info(struct ibmad_port *ibmad_port, ib_portid_t * portid,
 		    int portnum, ibnd_port_t * port)
 {
+	char width[64], speed[64];
+	int iwidth;
+	int ispeed;
+
 	if (!smp_query_via(port->info, portid, IB_ATTR_PORT_INFO,
 			   portnum, 0, ibmad_port))
 		return -1;
 
 	port->base_lid = (uint16_t) mad_get_field(port->info, 0, IB_PORT_LID_F);
 	port->lmc = (uint8_t) mad_get_field(port->info, 0, IB_PORT_LMC_F);
-
-	return 0;
-}
-
-static int get_port_info(struct ibmad_port *ibmad_port,
-			 ibnd_fabric_t * fabric, ibnd_port_t * port,
-			 int portnum, ib_portid_t * portid)
-{
-	int rc = 0;
-	char width[64], speed[64];
-	int iwidth;
-	int ispeed;
-
 	port->portnum = portnum;
+
 	iwidth = mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
 	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
-
-	if ((rc = query_port_info(ibmad_port, portid, portnum, port)) != 0)
-		return rc;
-
 	IBND_DEBUG
 	    ("portid %s portnum %d: base lid %d state %d physstate %d %s %s\n",
 	     portid2str(portid), portnum, port->base_lid,
@@ -93,6 +81,7 @@ static int get_port_info(struct ibmad_port *ibmad_port,
 	     mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F),
 	     mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64, &iwidth),
 	     mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64, &ispeed));
+
 	return 0;
 }
 
@@ -122,15 +111,15 @@ static int query_node(struct ibmad_port *ibmad_port, ibnd_fabric_t * fabric,
 	if ((rc = query_node_info(ibmad_port, fabric, node, portid)) != 0)
 		return rc;
 
-	port->portnum = mad_get_field(node->info, 0, IB_NODE_LOCAL_PORT_F);
-	port->guid = mad_get_field64(node->info, 0, IB_NODE_PORT_GUID_F);
-
 	if (!smp_query_via(nd, portid, IB_ATTR_NODE_DESC, 0, 0, ibmad_port))
 		return -1;
 
 	if ((rc = query_port_info(ibmad_port, portid, 0, port)) != 0)
 		return rc;
 
+	port->portnum = mad_get_field(node->info, 0, IB_NODE_LOCAL_PORT_F);
+	port->guid = mad_get_field64(node->info, 0, IB_NODE_PORT_GUID_F);
+
 	if (node->type != IB_NODE_SWITCH)
 		return 0;
 
@@ -563,8 +552,8 @@ ibnd_fabric_t *ibnd_discover_fabric(struct ibmad_port * ibmad_port,
 						       IB_NODE_LOCAL_PORT_F))
 					continue;
 
-				if (get_port_info(ibmad_port, fabric,
-						  &port_buf, i, path)) {
+				if (query_port_info(ibmad_port, path, i,
+						    &port_buf)) {
 					IBND_ERROR
 					    ("can't reach node %s port %d\n",
 					     portid2str(path), i);
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
