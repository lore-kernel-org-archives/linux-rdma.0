From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2] infiniband-diags/libibnetdisc/ibnetdisc.c: Changes for
 extended link speeds
Date: Tue, 16 Aug 2011 09:44:37 -0400
Message-ID: <4E4A7445.8080906@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index 9800c9d..e9dbaf9 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -2,7 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
  * Copyright (c) 2007 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2008 Lawrence Livermore National Laboratory
- * Copyright (c) 2010 Mellanox Technologies LTD.  All rights reserved.
+ * Copyright (c) 2010-2011 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -55,7 +55,7 @@
 #include "internal.h"
 #include "chassis.h"
 
-/* forward declare */
+/* forward declarations */
 struct ni_cbdata
 {
 	ibnd_node_t *node;
@@ -63,6 +63,9 @@ struct ni_cbdata
 };
 static int query_node_info(smp_engine_t * engine, ib_portid_t * portid,
 			   struct ni_cbdata * cbdata);
+static int query_port_info(smp_engine_t * engine, ib_portid_t * portid,
+			   ibnd_node_t * node, int portnum);
+ibnd_port_t *ibnd_find_port_dr(ibnd_fabric_t * fabric, char *dr_str);
 
 static int recv_switch_info(smp_engine_t * engine, ibnd_smp_t * smp,
 			    uint8_t * mad, void *cb_data)
@@ -167,17 +170,30 @@ static void debug_port(ib_portid_t * portid, ibnd_port_t * port)
 {
 	char width[64], speed[64];
 	int iwidth;
-	int ispeed;
+	int ispeed, espeed;
+	uint8_t *info;
+	uint32_t cap_mask;
 
 	iwidth = mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
 	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
+
+	if (port->node->type == IB_NODE_SWITCH)
+		info = (uint8_t *)&port->node->ports[0]->info;
+	else
+		info = (uint8_t *)&port->info;
+	cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
+	if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
+		espeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
+	else
+		espeed = 0;
 	IBND_DEBUG
-	    ("portid %s portnum %d: base lid %d state %d physstate %d %s %s\n",
+	    ("portid %s portnum %d: base lid %d state %d physstate %d %s %s %s\n",
 	     portid2str(portid), port->portnum, port->base_lid,
 	     mad_get_field(port->info, 0, IB_PORT_STATE_F),
 	     mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F),
 	     mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64, &iwidth),
-	     mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64, &ispeed));
+	     mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64, &ispeed),
+	     mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F, speed, 64, &espeed));
 }
 
 static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
@@ -253,13 +269,27 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	return 0;
 }
 
+static int recv_port0_info(smp_engine_t * engine, ibnd_smp_t * smp,
+			   uint8_t * mad, void *cb_data)
+{
+	ibnd_node_t *node = cb_data;
+	int i, status;
+
+	status = recv_port_info(engine, smp, mad, cb_data);
+	/* Query PortInfo on switch external/physical ports */
+	for (i = 1; i <= node->numports; i++)
+		query_port_info(engine, &smp->path, node, i);
+
+	return status;
+}
+
 static int query_port_info(smp_engine_t * engine, ib_portid_t * portid,
 			   ibnd_node_t * node, int portnum)
 {
 	IBND_DEBUG("Query Port Info; %s (0x%" PRIx64 "):%d\n",
 		   portid2str(portid), node->guid, portnum);
 	return issue_smp(engine, portid, IB_ATTR_PORT_INFO, portnum,
-			 recv_port_info, node);
+			 portnum ? recv_port_info : recv_port0_info, node);
 }
 
 static ibnd_node_t *create_node(smp_engine_t * engine, ib_portid_t * path,
@@ -330,7 +360,6 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 {
 	ibnd_scan_t *scan = engine->user_data;
 	ibnd_fabric_t *fabric = scan->fabric;
-	int i = 0;
 	uint8_t *node_info = mad + IB_SMP_DATA_OFFS;
 	struct ni_cbdata *ni_cbdata = (struct ni_cbdata *)cb_data;
 	ibnd_node_t *rem_node = NULL;
@@ -395,8 +424,8 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 
 		if (node->type == IB_NODE_SWITCH) {
 			query_switch_info(engine, &smp->path, node);
-			for (i = 0; i <= node->numports; i++)
-				query_port_info(engine, &smp->path, node, i);
+			/* Query PortInfo on Switch Port 0 first */
+			query_port_info(engine, &smp->path, node, 0);
 		}
 	}
 
@@ -431,9 +460,6 @@ ibnd_node_t *ibnd_find_node_guid(ibnd_fabric_t * fabric, uint64_t guid)
 	return NULL;
 }
 
-/* forward declare */
-ibnd_port_t *ibnd_find_port_dr(ibnd_fabric_t * fabric, char *dr_str);
-
 ibnd_node_t *ibnd_find_node_dr(ibnd_fabric_t * fabric, char *dr_str)
 {
 	ibnd_port_t *rc = ibnd_find_port_dr(fabric, dr_str);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
