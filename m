From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: ip address print changes
Date: Thu, 27 Oct 2011 11:10:58 -0500
Message-ID: <20111027161058.GA1092@FLATIF-MOBL4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix printing of ip addresses to use %pI4.

Reported-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |   96 +++++++++++++++++++-----------------
 drivers/infiniband/hw/nes/nes_hw.c |    6 +-
 2 files changed, 54 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index dfce9ea..1414168 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -173,6 +173,7 @@ static struct nes_cm_event *create_event(struct nes_cm_node *	cm_node,
 					 enum nes_cm_event_type type)
 {
 	struct nes_cm_event *event;
+	__be32 tmp_loc_addr, tmp_rem_addr;
 
 	if (!cm_node->cm_id)
 		return NULL;
@@ -191,11 +192,14 @@ static struct nes_cm_event *create_event(struct nes_cm_node *	cm_node,
 	event->cm_info.loc_port = cm_node->loc_port;
 	event->cm_info.cm_id = cm_node->cm_id;
 
+	tmp_loc_addr = htonl(cm_node->loc_addr);
+	tmp_rem_addr = htonl(cm_node->rem_addr);
+
 	nes_debug(NES_DBG_CM, "cm_node=%p Created event=%p, type=%u, "
-		  "dst_addr=%08x[%x], src_addr=%08x[%x]\n",
-		  cm_node, event, type, event->cm_info.loc_addr,
-		  event->cm_info.loc_port, event->cm_info.rem_addr,
-		  event->cm_info.rem_port);
+		  "loc_addr=%pI4[%x], rem_addr=%pI4[%x]\n",
+			cm_node, event, type, &tmp_loc_addr,
+			event->cm_info.loc_port, &tmp_rem_addr,
+			event->cm_info.rem_port);
 
 	nes_cm_post_event(event);
 	return event;
@@ -1335,11 +1339,12 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip, int arpi
 	int rc = arpindex;
 	struct net_device *netdev;
 	struct nes_adapter *nesadapter = nesvnic->nesdev->nesadapter;
+	__be32 rem_addr = htonl(dst_ip);
 
-	rt = ip_route_output(&init_net, htonl(dst_ip), 0, 0, 0);
+	rt = ip_route_output(&init_net, rem_addr, 0, 0, 0);
 	if (IS_ERR(rt)) {
-		printk(KERN_ERR "%s: ip_route_output_key failed for 0x%08X\n",
-		       __func__, dst_ip);
+		printk(KERN_ERR "%s: ip_route_output_key failed for %pI4\n",
+		       __func__, &rem_addr);
 		return rc;
 	}
 
@@ -1351,9 +1356,9 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip, int arpi
 	neigh = neigh_lookup(&arp_tbl, &rt->rt_gateway, netdev);
 	if (neigh) {
 		if (neigh->nud_state & NUD_VALID) {
-			nes_debug(NES_DBG_CM, "Neighbor MAC address for 0x%08X"
-				  " is %pM, Gateway is 0x%08X \n", dst_ip,
-				  neigh->ha, ntohl(rt->rt_gateway));
+			nes_debug(NES_DBG_CM, "Neighbor MAC address for %pI4"
+				  " is %pM, Gateway is %pI4\n", &rem_addr,
+				  neigh->ha, &rt->rt_gateway);
 
 			if (arpindex >= 0) {
 				if (!memcmp(nesadapter->arp_table[arpindex].mac_addr,
@@ -1397,6 +1402,7 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 	int arpindex = 0;
 	struct nes_device *nesdev;
 	struct nes_adapter *nesadapter;
+	__be32 tmp_rem_addr;
 
 	/* create an hte and cm_node for this instance */
 	cm_node = kzalloc(sizeof(*cm_node), GFP_ATOMIC);
@@ -1414,9 +1420,11 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 	cm_node->ird_size = IETF_NO_IRD_ORD;
 	cm_node->ord_size = IETF_NO_IRD_ORD;
 
+	tmp_rem_addr = htonl(cm_node->rem_addr);
 	nes_debug(NES_DBG_CM, "Make node addresses : loc = %pI4:%x, rem = %pI4:%x\n",
-		  &cm_node->loc_addr, cm_node->loc_port,
-		  &cm_node->rem_addr, cm_node->rem_port);
+		  &nesvnic->local_ipaddr, cm_node->loc_port,
+		  &tmp_rem_addr, cm_node->rem_port);
+
 	cm_node->listener = listener;
 	cm_node->netdev = nesvnic->netdev;
 	cm_node->cm_id = cm_info->cm_id;
@@ -2198,8 +2206,8 @@ static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
 	struct nes_cm_listener *listener;
 	unsigned long flags;
 
-	nes_debug(NES_DBG_CM, "Search for 0x%08x : 0x%04x\n",
-		  cm_info->loc_addr, cm_info->loc_port);
+	nes_debug(NES_DBG_CM, "Search for %pI4 : 0x%04x\n",
+		  &cm_info->loc_addr, cm_info->loc_port);
 
 	/* cannot have multiple matching listeners */
 	listener = find_listener(cm_core, htonl(cm_info->loc_addr),
@@ -2248,9 +2256,9 @@ static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
 		atomic_inc(&cm_core->listen_node_cnt);
 	}
 
-	nes_debug(NES_DBG_CM, "Api - listen(): addr=0x%08X, port=0x%04x,"
+	nes_debug(NES_DBG_CM, "Api - listen(): addr=%pI4, port=0x%04x,"
 		  " listener = %p, backlog = %d, cm_id = %p.\n",
-		  cm_info->loc_addr, cm_info->loc_port,
+		  &cm_info->loc_addr, cm_info->loc_port,
 		  listener, listener->backlog, listener->cm_id);
 
 	return listener;
@@ -2270,6 +2278,7 @@ static struct nes_cm_node *mini_cm_connect(struct nes_cm_core *cm_core,
 	struct nes_cm_node *loopbackremotenode;
 	struct nes_cm_info loopback_cm_info;
 	u8 *start_buff;
+	__be32 tmp_rem_addr;
 
 	/* create a CM connection node */
 	cm_node = make_cm_node(cm_core, nesvnic, cm_info, NULL);
@@ -2339,21 +2348,22 @@ static struct nes_cm_node *mini_cm_connect(struct nes_cm_core *cm_core,
 	/* send a syn and goto syn sent state */
 	cm_node->state = NES_CM_STATE_SYN_SENT;
 	ret = send_syn(cm_node, 0, NULL);
+	tmp_rem_addr = htonl(cm_node->rem_addr);
 
 	if (ret) {
 		/* error in sending the syn free up the cm_node struct */
 		nes_debug(NES_DBG_CM, "Api - connect() FAILED: dest "
-			  "addr=0x%08X, port=0x%04x, cm_node=%p, cm_id = %p.\n",
-			  cm_node->rem_addr, cm_node->rem_port, cm_node,
+			  "addr=%pI4, port=0x%04x, cm_node=%p, cm_id = %p.\n",
+			  &tmp_rem_addr, cm_node->rem_port, cm_node,
 			  cm_node->cm_id);
 		rem_ref_cm_node(cm_node->cm_core, cm_node);
 		cm_node = NULL;
 	}
 
 	if (cm_node) {
-		nes_debug(NES_DBG_CM, "Api - connect(): dest addr=0x%08X,"
+		nes_debug(NES_DBG_CM, "Api - connect(): dest addr=%pI4,"
 			  "port=0x%04x, cm_node=%p, cm_id = %p.\n",
-			  cm_node->rem_addr, cm_node->rem_port, cm_node,
+			  &tmp_rem_addr, cm_node->rem_port, cm_node,
 			  cm_node->cm_id);
 	}
 
@@ -2503,7 +2513,6 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
 	struct tcphdr *tcph;
 	struct nes_cm_info nfo;
 	int skb_handled = 1;
-	__be32 tmp_daddr, tmp_saddr;
 
 	if (!skb)
 		return 0;
@@ -2518,11 +2527,8 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
 	nfo.rem_addr = ntohl(iph->saddr);
 	nfo.rem_port = ntohs(tcph->source);
 
-	tmp_daddr = cpu_to_be32(iph->daddr);
-	tmp_saddr = cpu_to_be32(iph->saddr);
-
 	nes_debug(NES_DBG_CM, "Received packet: dest=%pI4:0x%04X src=%pI4:0x%04X\n",
-		  &tmp_daddr, tcph->dest, &tmp_saddr, tcph->source);
+		&iph->daddr, tcph->dest, &iph->saddr, tcph->source);
 
 	do {
 		cm_node = find_node(cm_core,
@@ -3187,12 +3193,12 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 
 	cm_node->cm_core->api->accelerated(cm_node->cm_core, cm_node);
 
-	nes_debug(NES_DBG_CM, "QP%u, Destination IP = 0x%08X:0x%04X, local = "
-		  "0x%08X:0x%04X, rcv_nxt=0x%08X, snd_nxt=0x%08X, mpa + "
+	nes_debug(NES_DBG_CM, "QP%u, Destination IP = %pI4:0x%04X, local = "
+		  "%pI4:0x%04X, rcv_nxt=0x%08X, snd_nxt=0x%08X, mpa + "
 		  "private data length=%u.\n", nesqp->hwqp.qp_id,
-		  ntohl(cm_id->remote_addr.sin_addr.s_addr),
+		  &cm_id->remote_addr.sin_addr.s_addr,
 		  ntohs(cm_id->remote_addr.sin_port),
-		  ntohl(cm_id->local_addr.sin_addr.s_addr),
+		  &cm_id->local_addr.sin_addr.s_addr,
 		  ntohs(cm_id->local_addr.sin_port),
 		  le32_to_cpu(nesqp->nesqp_context->rcv_nxt),
 		  le32_to_cpu(nesqp->nesqp_context->snd_nxt),
@@ -3290,12 +3296,12 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	if (!(cm_id->local_addr.sin_port) || !(cm_id->remote_addr.sin_port))
 		return -EINVAL;
 
-	nes_debug(NES_DBG_CM, "QP%u, current IP = 0x%08X, Destination IP = "
-		  "0x%08X:0x%04X, local = 0x%08X:0x%04X.\n", nesqp->hwqp.qp_id,
-		  ntohl(nesvnic->local_ipaddr),
-		  ntohl(cm_id->remote_addr.sin_addr.s_addr),
+	nes_debug(NES_DBG_CM, "QP%u, current IP = %pI4, Destination IP = "
+		  "%pI4:0x%04X, local = %pI4:0x%04X.\n", nesqp->hwqp.qp_id,
+		  &nesvnic->local_ipaddr,
+		  &cm_id->remote_addr.sin_addr.s_addr,
 		  ntohs(cm_id->remote_addr.sin_port),
-		  ntohl(cm_id->local_addr.sin_addr.s_addr),
+		  &cm_id->local_addr.sin_addr.s_addr,
 		  ntohs(cm_id->local_addr.sin_port));
 
 	atomic_inc(&cm_connects);
@@ -3372,8 +3378,8 @@ int nes_create_listen(struct iw_cm_id *cm_id, int backlog)
 	nes_debug(NES_DBG_CM, "nesvnic=%p, netdev=%p, %s\n",
 			nesvnic, nesvnic->netdev, nesvnic->netdev->name);
 
-	nes_debug(NES_DBG_CM, "nesvnic->local_ipaddr=0x%08x, sin_addr.s_addr=0x%08x\n",
-			nesvnic->local_ipaddr, cm_id->local_addr.sin_addr.s_addr);
+	nes_debug(NES_DBG_CM, "nesvnic->local_ipaddr=%pI4, sin_addr.s_addr=%pI4\n",
+			&nesvnic->local_ipaddr, &cm_id->local_addr.sin_addr.s_addr);
 
 	/* setup listen params in our api call struct */
 	cm_info.loc_addr = nesvnic->local_ipaddr;
@@ -3506,10 +3512,10 @@ static void cm_event_connected(struct nes_cm_event *event)
 	if (nesqp->destroyed)
 		return;
 	atomic_inc(&cm_connecteds);
-	nes_debug(NES_DBG_CM, "QP%u attempting to connect to  0x%08X:0x%04X on"
+	nes_debug(NES_DBG_CM, "QP%u attempting to connect to  %pI4:0x%04X on"
 		  " local port 0x%04X. jiffies = %lu.\n",
 		  nesqp->hwqp.qp_id,
-		  ntohl(cm_id->remote_addr.sin_addr.s_addr),
+		  &cm_id->remote_addr.sin_addr.s_addr,
 		  ntohs(cm_id->remote_addr.sin_port),
 		  ntohs(cm_id->local_addr.sin_port),
 		  jiffies);
@@ -3640,9 +3646,9 @@ static void cm_event_connect_error(struct nes_cm_event *event)
 	cm_event.private_data = NULL;
 	cm_event.private_data_len = 0;
 
-	nes_debug(NES_DBG_CM, "call CM_EVENT REJECTED, local_addr=%08x, "
-		  "remove_addr=%08x\n", cm_event.local_addr.sin_addr.s_addr,
-		  cm_event.remote_addr.sin_addr.s_addr);
+	nes_debug(NES_DBG_CM, "call CM_EVENT REJECTED, local_addr=%pI4, "
+		  "remove_addr=%pI4\n", &cm_event.local_addr.sin_addr.s_addr,
+		  &cm_event.remote_addr.sin_addr.s_addr);
 
 	ret = cm_id->event_handler(cm_id, &cm_event);
 	nes_debug(NES_DBG_CM, "OFA CM event_handler returned, ret=%d\n", ret);
@@ -3787,10 +3793,10 @@ static void cm_event_mpa_reject(struct nes_cm_event *event)
 	cm_event.private_data = cm_node->mpa_frame_buf;
 	cm_event.private_data_len = (u8)cm_node->mpa_frame_size;
 
-	nes_debug(NES_DBG_CM, "call CM_EVENT_MPA_REJECTED, local_addr=%08x, "
-		  "remove_addr=%08x\n",
-		  cm_event.local_addr.sin_addr.s_addr,
-		  cm_event.remote_addr.sin_addr.s_addr);
+	nes_debug(NES_DBG_CM, "call CM_EVENT_MPA_REJECTED, local_addr=%pI4, "
+		  "remove_addr=%pI4\n",
+		  &cm_event.local_addr.sin_addr.s_addr,
+		  &cm_event.remote_addr.sin_addr.s_addr);
 
 	ret = cm_id->event_handler(cm_id, &cm_event);
 	if (ret)
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 7c0ff19..30b020c 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -112,10 +112,10 @@ static unsigned char *nes_tcp_state_str[] = {
 
 static inline void print_ip(struct nes_cm_node *cm_node)
 {
-	unsigned char *rem_addr;
+	__be32 rem_addr;
 	if (cm_node) {
-		rem_addr = (unsigned char *)&cm_node->rem_addr;
-		printk(KERN_ERR PFX "Remote IP addr: %pI4\n", rem_addr);
+		rem_addr = htonl(cm_node->rem_addr);
+		printk(KERN_ERR PFX "Remote IP addr: %pI4\n", &rem_addr);
 	}
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
