From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ibnetdiscover: fix error when discovery started on node with
 more that one port
Date: Mon, 04 Oct 2010 12:12:05 +0200
Message-ID: <4CA9A875.4050604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


When discovery is started on a node with more than one active port
it tries to send mads from second Hca port and fails.
ibnetdiscover should not try and extend_path from Hca except for starting point.

Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 .../libibnetdisc/include/infiniband/ibnetdisc.h    |    1 +
 infiniband-diags/libibnetdisc/src/ibnetdisc.c      |    7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
index cfd3bbe..fe953e6 100644
--- a/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
+++ b/infiniband-diags/libibnetdisc/include/infiniband/ibnetdisc.h
@@ -149,6 +149,7 @@ typedef struct ibnd_fabric {
 	 * or by default the node you ar running on
 	 */
 	ibnd_node_t *from_node;
+	int from_port;
 	/* NULL term list of all nodes in the fabric */
 	ibnd_node_t *nodes;
 	/* NULL terminated list of all chassis found in the fabric */
diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc.c b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
index f525d71..64e1c60 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc.c
@@ -199,7 +199,7 @@ static int recv_port_info(smp_engine_t * engine, ibnd_smp_t * smp,
 	if (port_num && mad_get_field(port->info, 0, IB_PORT_PHYS_STATE_F)
 	    == IB_PORT_PHYS_STATE_LINKUP
 	    && ((node->type == IB_NODE_SWITCH && port_num != local_port) ||
-		(node == fabric->from_node && port_num == local_port))) {
+		(node == fabric->from_node && port_num == fabric->from_port))) {
 		ib_portid_t path = smp->path;
 		if (extend_dpath(engine, &path, port_num) > 0)
 			query_node_info(engine, &path, node);
@@ -324,9 +324,10 @@ static int recv_node_info(smp_engine_t * engine, ibnd_smp_t * smp,
 		dump_endnode(&smp->path, node_is_new ? "new" : "known",
 			     node, port);
 
-	if (rem_node == NULL)	/* this is the start node */
+	if (rem_node == NULL) {	/* this is the start node */
 		fabric->from_node = node;
-	else {
+		fabric->from_port = port_num;
+	} else {
 		/* link ports... */
 		int rem_port_num = get_last_port(&smp->path);
 
-- 
1.7.2.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
