From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/6] RDMA/nes: Fix for incorrect resolving the loopback MAC
 address
Date: Thu, 20 Sep 2012 14:23:14 -0500
Message-ID: <20120920192314.GA8068@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Loopback code changes to fix incorrect resolving of loopback MAC address.

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |   32 +++++++-------------------------
 1 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 020e95c..49a9383 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1356,7 +1356,7 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip, int arpi
 	else
 		netdev = nesvnic->netdev;
 
-	neigh = dst_neigh_lookup(&rt->dst, &dst_ip);
+	neigh = neigh_lookup(&arp_tbl, &rt->rt_gateway, netdev);
 
 	rcu_read_lock();
 	if (neigh) {
@@ -1465,12 +1465,8 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 	cm_node->loopbackpartner = NULL;
 
 	/* get the mac addr for the remote node */
-	if (ipv4_is_loopback(htonl(cm_node->rem_addr))) {
-		arpindex = nes_arp_table(nesdev, ntohl(nesvnic->local_ipaddr), NULL, NES_ARP_RESOLVE);
-	} else {
-		oldarpindex = nes_arp_table(nesdev, cm_node->rem_addr, NULL, NES_ARP_RESOLVE);
-		arpindex = nes_addr_resolve_neigh(nesvnic, cm_info->rem_addr, oldarpindex);
-	}
+	oldarpindex = nes_arp_table(nesdev, cm_node->rem_addr, NULL, NES_ARP_RESOLVE);
+	arpindex = nes_addr_resolve_neigh(nesvnic, cm_info->rem_addr, oldarpindex);
 	if (arpindex < 0) {
 		kfree(cm_node);
 		return NULL;
@@ -3153,11 +3149,7 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	nesqp->nesqp_context->tcpPorts[1] =
 		cpu_to_le16(ntohs(cm_id->remote_addr.sin_port));
 
-	if (ipv4_is_loopback(cm_id->remote_addr.sin_addr.s_addr))
-		nesqp->nesqp_context->ip0 =
-			cpu_to_le32(ntohl(nesvnic->local_ipaddr));
-	else
-		nesqp->nesqp_context->ip0 =
+	nesqp->nesqp_context->ip0 =
 			cpu_to_le32(ntohl(cm_id->remote_addr.sin_addr.s_addr));
 
 	nesqp->nesqp_context->misc2 |= cpu_to_le32(
@@ -3182,10 +3174,7 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	memset(&nes_quad, 0, sizeof(nes_quad));
 	nes_quad.DstIpAdrIndex =
 		cpu_to_le32((u32)PCI_FUNC(nesdev->pcidev->devfn) << 24);
-	if (ipv4_is_loopback(cm_id->remote_addr.sin_addr.s_addr))
-		nes_quad.SrcIpadr = nesvnic->local_ipaddr;
-	else
-		nes_quad.SrcIpadr = cm_id->remote_addr.sin_addr.s_addr;
+	nes_quad.SrcIpadr = cm_id->remote_addr.sin_addr.s_addr;
 	nes_quad.TcpPorts[0] = cm_id->remote_addr.sin_port;
 	nes_quad.TcpPorts[1] = cm_id->local_addr.sin_port;
 
@@ -3538,11 +3527,7 @@ static void cm_event_connected(struct nes_cm_event *event)
 		cpu_to_le16(ntohs(cm_id->local_addr.sin_port));
 	nesqp->nesqp_context->tcpPorts[1] =
 		cpu_to_le16(ntohs(cm_id->remote_addr.sin_port));
-	if (ipv4_is_loopback(cm_id->remote_addr.sin_addr.s_addr))
-		nesqp->nesqp_context->ip0 =
-			cpu_to_le32(ntohl(nesvnic->local_ipaddr));
-	else
-		nesqp->nesqp_context->ip0 =
+	nesqp->nesqp_context->ip0 =
 			cpu_to_le32(ntohl(cm_id->remote_addr.sin_addr.s_addr));
 
 	nesqp->nesqp_context->misc2 |= cpu_to_le32(
@@ -3571,10 +3556,7 @@ static void cm_event_connected(struct nes_cm_event *event)
 
 	nes_quad.DstIpAdrIndex =
 		cpu_to_le32((u32)PCI_FUNC(nesdev->pcidev->devfn) << 24);
-	if (ipv4_is_loopback(cm_id->remote_addr.sin_addr.s_addr))
-		nes_quad.SrcIpadr = nesvnic->local_ipaddr;
-	else
-		nes_quad.SrcIpadr = cm_id->remote_addr.sin_addr.s_addr;
+	nes_quad.SrcIpadr = cm_id->remote_addr.sin_addr.s_addr;
 	nes_quad.TcpPorts[0] = cm_id->remote_addr.sin_port;
 	nes_quad.TcpPorts[1] = cm_id->local_addr.sin_port;
 
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
