From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibnetdiscover: Fix handling of CA ports
	in recv_port_info
Date: Wed, 25 Aug 2010 14:08:02 -0400
Message-ID: <20100825180802.GA12192@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


When multiple ports on the same CA are connected to the same subnet and
an ibnetdiscover is initiated from one of them, the discovery continues
past the other CA port and an error occurs.

The error is:
src/query_smp.c:188; umad (DR path slid 0; dlid 0; 0,1,20,2 Attr0x11:0) bad status 110; Connection timed out

Fix this by saving the initiating port number in the fabric structure
and using that rather than local_port for the comparison in
recv_port_info.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index cfd3bbe..935e427 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2009 Voltaire, Inc. All rights reserved.
  * Copyright (c) 2008 Lawrence Livermore National Lab.  All rights reserved.
+ * Copyright (c) 2010 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -149,6 +150,8 @@ typedef struct ibnd_fabric {
 	 * or by default the node you ar running on
 	 */
 	ibnd_node_t *from_node;
+	int from_portnum;
+
 	/* NULL term list of all nodes in the fabric */
 	ibnd_node_t *nodes;
 	/* NULL terminated list of all chassis found in the fabric */
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index f525d71..79dd98e 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -2,6 +2,7 @@
  * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
  * Copyright (c) 2007 Xsigo Systems Inc.  All rights reserved.
  * Copyright (c) 2008 Lawrence Livermore National Laboratory
+ * Copyright (c) 2010 Mellanox Technologies LTD.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -199,7 +200,7 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	if (port_num && mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
 	    == IB_PORT_PHYS_STATE_LINKUP
 	    && ((node->type == IB_NODE_SWITCH && port_num != local_port) ||
-		(node == fabric->from_node && port_num == local_port))) {
+		(node == fabric->from_node && port_num == fabric->from_portnum))) {
 		ib_portid_t path = smp->path;
 		if (extend_dpath(engine, &path, port_num) > 0)
 			query_node_info(engine, &path, node);
@@ -324,9 +325,10 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 		dump_endnode(&smp->path, node_is_new ? "new" : "known",
 			     node, port);
 
-	if (rem_node == NULL)	/* this is the start node */
+	if (rem_node == NULL) {	/* this is the start node */
 		fabric->from_node = node;
-	else {
+		fabric->from_portnum = port_num;
+	} else {
 		/* link ports... */
 		int rem_port_num = get_last_port(&smp->path);
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
