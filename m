From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/6] infiniband-diags: Add FDR10 support to ibnetdiscover
 and libibnetdisc
Date: Fri, 19 Aug 2011 12:54:01 -0400
Message-ID: <4E4E9529.5020304@dev.mellanox.co.il>
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
 libibnetdisc/include/infiniband/ibnetdisc.h |    3 +-
 libibnetdisc/src/ibnetdisc.c                |  148 ++++++++++++++++++++++++++-
 libibnetdisc/src/query_smp.c                |   10 ++
 src/ibnetdiscover.c                         |   21 +++-
 4 files changed, 173 insertions(+), 9 deletions(-)

diff --git a/libibnetdisc/include/infiniband/ibnetdisc.h b/libibnetdisc/include/infiniband/ibnetdisc.h
index 300094e..59c5606 100644
--- a/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -1,7 +1,7 @@
 /*
  * Copyright (c) 2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2008 Lawrence Livermore National Lab.  All rights reserved.
- * Copyright (c) 2010 Mellanox Technologies LTD.  All rights reserved.
+ * Copyright (c) 2010-2011 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -109,6 +109,7 @@ typedef struct ibnd_port {
 	uint8_t lmc;
 	/* use libibmad decoder functions for info */
 	uint8_t info[IB_SMP_DATA_SIZE];
+	uint8_t ext_info[IB_SMP_DATA_SIZE];
 
 	/* internal use only */
 	struct ibnd_port *htnext;
diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
index e9dbaf9..60bd28d 100644
--- a/libibnetdisc/src/ibnetdisc.c
+++ b/libibnetdisc/src/ibnetdisc.c
@@ -170,12 +170,14 @@ static void debug_port(ib_portid_t * portid, ibnd_port_t * port)
 {
 	char width[64], speed[64];
 	int iwidth;
-	int ispeed, espeed;
+	int ispeed, fdr10, espeed;
 	uint8_t *info;
 	uint32_t cap_mask;
 
 	iwidth = mad_get_field(port->info, 0, IB_PORT_LINK_WIDTH_ACTIVE_F);
 	ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
+	fdr10 = mad_get_field(port->ext_info, 0,
+			      IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F);
 
 	if (port->node->type == IB_NODE_SWITCH)
 		info = (uint8_t *)&port->node->ports[0]->info;
@@ -187,15 +189,132 @@ static void debug_port(ib_portid_t * portid, ibnd_port_t * port)
 	else
 		espeed = 0;
 	IBND_DEBUG
-	    ("portid %s portnum %d: base lid %d state %d physstate %d %s %s %s\n",
+	    ("portid %s portnum %d: base lid %d state %d physstate %d %s %s %s %s\n",
 	     portid2str(portid), port->portnum, port->base_lid,
 	     mad_get_field(port->info, 0, IB_PORT_STATE_F),
 	     mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F),
 	     mad_dump_val(IB_PORT_LINK_WIDTH_ACTIVE_F, width, 64, &iwidth),
 	     mad_dump_val(IB_PORT_LINK_SPEED_ACTIVE_F, speed, 64, &ispeed),
+	     (fdr10 & FDR10) ? "FDR10"  : "",
 	     mad_dump_val(IB_PORT_LINK_SPEED_EXT_ACTIVE_F, speed, 64, &espeed));
 }
 
+static int is_mlnx_ext_port_info_supported(ibnd_port_t * port)
+{
+	uint16_t devid = mad_get_field(port->node->info, 0, IB_NODE_DEVID_F);
+
+	if (devid == 0xc738)
+		return 1;
+	if (devid >= 0x1003 && devid <= 0x1010)
+		return 1;
+	return 0;
+}
+
+int mlnx_ext_port_info_err(smp_engine_t * engine, ibnd_smp_t * smp,
+			   uint8_t * mad, void *cb_data)
+{
+	ibnd_fabric_t *fabric = ((ibnd_scan_t *) engine->user_data)->fabric;
+	ibnd_node_t *node = cb_data;
+	ibnd_port_t *port;
+	uint8_t port_num, local_port;
+
+	port_num = (uint8_t) mad_get_field(mad, 0, IB_MAD_ATTRMOD_F);
+	port = node->ports[port_num];
+	if (!port) {
+		IBND_ERROR("Failed to find 0x%" PRIx64 " port %u\n",
+			   node->guid, port_num);
+		return -1;
+	}
+
+	local_port = (uint8_t) mad_get_field(port->info, 0, IB_PORT_LOCAL_PORT_F);
+	debug_port(&smp->path, port);
+
+	if (port_num && mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
+	    == IB_PORT_PHYS_STATE_LINKUP
+	    && ((node->type == IB_NODE_SWITCH && port_num != local_port) ||
+		(node == fabric->from_node && port_num == fabric->from_portnum))) {
+		int rc = 0;
+		ib_portid_t path = smp->path;
+
+		if (node->type != IB_NODE_SWITCH &&
+		    node == fabric->from_node &&
+		    path.drpath.cnt > 1)
+			rc = retract_dpath(engine, &path);
+		else {
+			/* we can't proceed through an HCA with DR */
+			if (path.lid == 0 || node->type == IB_NODE_SWITCH)
+				rc = extend_dpath(engine, &path, port_num);
+		}
+
+		if (rc > 0) {
+			struct ni_cbdata * cbdata = malloc(sizeof(*cbdata));
+			cbdata->node = node;
+			cbdata->port_num = port_num;
+			query_node_info(engine, &path, cbdata);
+		}
+	}
+
+	return 0;
+}
+
+static int recv_mlnx_ext_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
+				   uint8_t * mad, void *cb_data)
+{
+	ibnd_fabric_t *fabric = ((ibnd_scan_t *) engine->user_data)->fabric;
+	ibnd_node_t *node = cb_data;
+	ibnd_port_t *port;
+	uint8_t *ext_port_info = mad + IB_SMP_DATA_OFFS;
+	uint8_t port_num, local_port;
+
+	port_num = (uint8_t) mad_get_field(mad, 0, IB_MAD_ATTRMOD_F);
+	port = node->ports[port_num];
+	if (!port) {
+		IBND_ERROR("Failed to find 0x%" PRIx64 " port %u\n",
+			   node->guid, port_num);
+		return -1;
+	}
+
+	memcpy(port->ext_info, ext_port_info, sizeof(port->ext_info));
+	local_port = (uint8_t) mad_get_field(port->info, 0, IB_PORT_LOCAL_PORT_F);
+	debug_port(&smp->path, port);
+
+	if (port_num && mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
+	    == IB_PORT_PHYS_STATE_LINKUP
+	    && ((node->type == IB_NODE_SWITCH && port_num != local_port) ||
+		(node == fabric->from_node && port_num == fabric->from_portnum))) {
+		int rc = 0;
+		ib_portid_t path = smp->path;
+
+		if (node->type != IB_NODE_SWITCH &&
+		    node == fabric->from_node &&
+		    path.drpath.cnt > 1)
+			rc = retract_dpath(engine, &path);
+		else {
+			/* we can't proceed through an HCA with DR */
+			if (path.lid == 0 || node->type == IB_NODE_SWITCH)
+				rc = extend_dpath(engine, &path, port_num);
+		}
+
+		if (rc > 0) {
+			struct ni_cbdata * cbdata = malloc(sizeof(*cbdata));
+			cbdata->node = node;
+			cbdata->port_num = port_num;
+			query_node_info(engine, &path, cbdata);
+		}
+	}
+
+	return 0;
+}
+
+static int query_mlnx_ext_port_info(smp_engine_t * engine, ib_portid_t * portid,
+				    ibnd_node_t * node, int portnum)
+{
+	IBND_DEBUG("Query MLNX Extended Port Info; %s (0x%" PRIx64 "):%d\n",
+		   portid2str(portid), node->guid, portnum);
+	return issue_smp(engine, portid, IB_ATTR_MLNX_EXT_PORT_INFO, portnum,
+			 recv_mlnx_ext_port_info, node);
+}
+
 static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 			  uint8_t * mad, void *cb_data)
 {
@@ -204,6 +323,9 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	ibnd_port_t *port;
 	uint8_t *port_info = mad + IB_SMP_DATA_OFFS;
 	uint8_t port_num, local_port;
+	int phystate, ispeed, espeed;
+	uint8_t *info;
+	uint32_t cap_mask;
 
 	port_num = (uint8_t) mad_get_field(mad, 0, IB_MAD_ATTRMOD_F);
 	local_port = (uint8_t) mad_get_field(port_info, 0, IB_PORT_LOCAL_PORT_F);
@@ -238,6 +360,28 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 
 	add_to_portguid_hash(port, fabric->portstbl);
 
+	if (is_mlnx_ext_port_info_supported(port)) {
+		phystate = mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F);
+		ispeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F);
+		if (port->node->type == IB_NODE_SWITCH)
+			info = (uint8_t *)&port->node->ports[0]->info;
+		else
+			info = (uint8_t *)&port->info;
+		cap_mask = mad_get_field(info, 0, IB_PORT_CAPMASK_F);
+		if (cap_mask & IB_PORT_CAP_HAS_EXT_SPEEDS)
+			espeed = mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
+		else
+			espeed = 0;
+
+		if (phystate == IB_PORT_PHYS_STATE_LINKUP &&
+		    ispeed == IB_LINK_SPEED_ACTIVE_10 &&
+		    espeed == IB_LINK_SPEED_EXT_ACTIVE_NONE) {	/* LinkUp/QDR */
+			query_mlnx_ext_port_info(engine, &smp->path,
+						 node, port_num);
+			return 0;
+		}
+	}
+
 	debug_port(&smp->path, port);
 
 	if (port_num && mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
diff --git a/libibnetdisc/src/query_smp.c b/libibnetdisc/src/query_smp.c
index 5fb3e18..f4beb39 100644
--- a/libibnetdisc/src/query_smp.c
+++ b/libibnetdisc/src/query_smp.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2010 Lawrence Livermore National Laboratory
+ * Copyright (c) 2011 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -40,6 +41,9 @@
 #include <infiniband/umad.h>
 #include "internal.h"
 
+extern int mlnx_ext_port_info_err(smp_engine_t * engine, ibnd_smp_t * smp,
+				  uint8_t * mad, void *cb_data);
+
 static void queue_smp(smp_engine_t * engine, ibnd_smp_t * smp)
 {
 	smp->qnext = NULL;
@@ -190,10 +194,16 @@ static int process_one_recv(smp_engine_t * engine)
 		IBND_ERROR("umad (%s Attr 0x%x:%u) bad status %d; %s\n",
 			   portid2str(&smp->path), smp->rpc.attr.id,
 			   smp->rpc.attr.mod, status, strerror(status));
+		if (smp->rpc.attr.id == IB_ATTR_MLNX_EXT_PORT_INFO)
+			rc = mlnx_ext_port_info_err(engine, smp, mad,
+						    smp->cb_data);
 	} else if ((status = mad_get_field(mad, 0, IB_DRSMP_STATUS_F))) {
 		IBND_ERROR("mad (%s Attr 0x%x:%u) bad status 0x%x\n",
 			   portid2str(&smp->path), smp->rpc.attr.id,
 			   smp->rpc.attr.mod, status);
+		if (smp->rpc.attr.id == IB_ATTR_MLNX_EXT_PORT_INFO)
+			rc = mlnx_ext_port_info_err(engine, smp, mad,
+						    smp->cb_data);
 	} else
 		rc = smp->cb(engine, smp, mad, smp->cb_data);
 
diff --git a/src/ibnetdiscover.c b/src/ibnetdiscover.c
index 0966217..ed41e0d 100644
--- a/src/ibnetdiscover.c
+++ b/src/ibnetdiscover.c
@@ -100,11 +100,14 @@ char *dump_linkspeed_compat(uint32_t speed)
 	return ("???");
 }
 
-char *dump_linkspeedext_compat(uint32_t espeed, uint32_t speed)
+char *dump_linkspeedext_compat(uint32_t espeed, uint32_t speed, uint32_t fdr10)
 {
 	switch (espeed) {
 	case 0:
-		return dump_linkspeed_compat(speed);
+		if (fdr10 & FDR10)
+			return ("FDR10");
+		else
+			return dump_linkspeed_compat(speed);
 		break;
 	case 1:
 		return ("FDR");
@@ -358,6 +361,8 @@ void out_switch_port(ibnd_port_t * port, int group, char *out_prefix)
 					IB_PORT_LINK_WIDTH_ACTIVE_F);
 	uint32_t ispeed = mad_get_field(port->info, 0,
 					IB_PORT_LINK_SPEED_ACTIVE_F);
+	uint32_t fdr10 = mad_get_field(port->ext_info, 0,
+				       IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F);
 	uint32_t cap_mask, espeed;
 
 	DEBUG("port %p:%d remoteport %p\n", port, port->portnum,
@@ -393,7 +398,7 @@ void out_switch_port(ibnd_port_t * port, int group, char *out_prefix)
 		dump_linkwidth_compat(iwidth),
 		(ispeed != 4 && !espeed) ?
 			dump_linkspeed_compat(ispeed) :
-			dump_linkspeedext_compat(espeed, ispeed));
+			dump_linkspeedext_compat(espeed, ispeed, fdr10));
 
 	if (full_info)
 		fprintf(f, " s=%d w=%d", ispeed, iwidth);
@@ -415,6 +420,8 @@ void out_ca_port(ibnd_port_t * port, int group, char *out_prefix)
 					IB_PORT_LINK_WIDTH_ACTIVE_F);
 	uint32_t ispeed = mad_get_field(port->info, 0,
 					IB_PORT_LINK_SPEED_ACTIVE_F);
+	uint32_t fdr10 = mad_get_field(port->ext_info, 0,
+				       IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F);
 	uint32_t cap_mask, espeed;
 
 	fprintf(f, "%s[%d]", out_prefix ? out_prefix : "", port->portnum);
@@ -447,7 +454,7 @@ void out_ca_port(ibnd_port_t * port, int group, char *out_prefix)
 		dump_linkwidth_compat(iwidth),
 		(ispeed != 4 && !espeed) ?
 			dump_linkspeed_compat(ispeed) :
-			dump_linkspeedext_compat(espeed, ispeed));
+			dump_linkspeedext_compat(espeed, ispeed, fdr10));
 
 	if (full_info)
 		fprintf(f, " s=%d w=%d", ispeed, iwidth);
@@ -671,7 +678,7 @@ void dump_ports_report(ibnd_node_t * node, void *user_data)
 	/* for each port */
 	for (p = node->numports, port = node->ports[p]; p > 0;
 	     port = node->ports[--p]) {
-		uint32_t iwidth, ispeed, espeed, cap_mask;
+		uint32_t iwidth, ispeed, fdr10, espeed, cap_mask;
 		uint8_t *info;
 		if (port == NULL)
 			continue;
@@ -689,6 +696,8 @@ void dump_ports_report(ibnd_node_t * node, void *user_data)
 					       IB_PORT_LINK_SPEED_EXT_ACTIVE_F);
 		else
 			espeed = 0;
+		fdr10 = mad_get_field(port->ext_info, 0,
+				      IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F);
 		nodename = remap_node_name(node_name_map,
 					   port->node->guid,
 					   port->node->nodedesc);
@@ -700,7 +709,7 @@ void dump_ports_report(ibnd_node_t * node, void *user_data)
 			dump_linkwidth_compat(iwidth),
 			(ispeed != 4 && !espeed) ?
 				dump_linkspeed_compat(ispeed) :
-				dump_linkspeedext_compat(espeed, ispeed));
+				dump_linkspeedext_compat(espeed, ispeed, fdr10));
 		if (port->remoteport) {
 			rem_nodename = remap_node_name(node_name_map,
 					      port->remoteport->node->guid,
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
