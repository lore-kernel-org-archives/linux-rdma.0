From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/11] RDMA/nes: stale arp issue fix
Date: Wed, 9 Dec 2009 16:43:44 -0600
Message-ID: <20091209224344.GA128808@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When the remote node's mac addr changes, the connection keeps trying to connect
using old mac address. The connection wil continue failing until the driver
is unloaded and loaded again (eiter reboot or rmmod). Now it is checked before
starting a connection if the mac address of the remote node is same as in system.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |   45 +++++++++++++++++++++++++----------
 1 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 4acf04a..dd4cf58 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1095,15 +1095,18 @@ static inline int mini_cm_accelerated(struct nes_cm_core *cm_core,
 }
 
 
+
 /**
  * nes_addr_resolve_neigh
  */
-static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip)
+
+static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip, int arpindex)
 {
 	struct rtable *rt;
 	struct flowi fl;
 	struct neighbour *neigh;
-	int rc = -1;
+	int rc = arpindex;
+	struct nes_adapter *nesadapter = nesvnic->nesdev->nesadapter;
 
 	memset(&fl, 0, sizeof fl);
 	fl.nl_u.ip4_u.daddr = htonl(dst_ip);
@@ -1117,8 +1120,24 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip)
 	if (neigh) {
 		if (neigh->nud_state & NUD_VALID) {
 			nes_debug(NES_DBG_CM, "Neighbor MAC address for 0x%08X"
-				  " is %pM, Gateway is 0x%08X \n", dst_ip,
-				  neigh->ha, ntohl(rt->rt_gateway));
+				  " is %s, Gateway is 0x%08X \n", dst_ip,
+				  print_mac(mac, neigh->ha), ntohl(rt->rt_gateway));
+
+			if (arpindex >= 0) {
+				if (!memcmp(nesadapter->arp_table[arpindex].mac_addr,
+							neigh->ha, ETH_ALEN)){
+					/* Mac address same as in nes_arp_table */
+					neigh_release(neigh);
+					ip_rt_put(rt);
+					return rc;
+				}
+
+				nes_manage_arp_cache(nesvnic->netdev,
+						nesadapter->arp_table[arpindex].mac_addr,
+						dst_ip, NES_ARP_DELETE);
+			}
+
+
 			nes_manage_arp_cache(nesvnic->netdev, neigh->ha,
 					     dst_ip, NES_ARP_ADD);
 			rc = nes_arp_table(nesvnic->nesdev, dst_ip, NULL,
@@ -1134,7 +1153,6 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip)
 	return rc;
 }
 
-
 /**
  * make_cm_node - create a new instance of a cm node
  */
@@ -1144,6 +1162,7 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 {
 	struct nes_cm_node *cm_node;
 	struct timespec ts;
+	int oldarpindex = 0;
 	int arpindex = 0;
 	struct nes_device *nesdev;
 	struct nes_adapter *nesadapter;
@@ -1197,19 +1216,19 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 	nesadapter = nesdev->nesadapter;
 
 	cm_node->loopbackpartner = NULL;
+
 	/* get the mac addr for the remote node */
 	if (ipv4_is_loopback(htonl(cm_node->rem_addr)))
 		arpindex = nes_arp_table(nesdev, ntohl(nesvnic->local_ipaddr), NULL, NES_ARP_RESOLVE);
-	else
-		arpindex = nes_arp_table(nesdev, cm_node->rem_addr, NULL, NES_ARP_RESOLVE);
+	else {
+		oldarpindex = nes_arp_table(nesdev, cm_node->rem_addr, NULL, NES_ARP_RESOLVE);
+		arpindex = nes_addr_resolve_neigh(nesvnic, cm_info->rem_addr, oldarpindex);
+
+	}
 	if (arpindex < 0) {
-		arpindex = nes_addr_resolve_neigh(nesvnic, cm_info->rem_addr);
-		if (arpindex < 0) {
-			kfree(cm_node);
-			return NULL;
-		}
+		kfree(cm_node);
+		return NULL;
 	}
-
 	/* copy the mac addr to node context */
 	memcpy(cm_node->rem_mac, nesadapter->arp_table[arpindex].mac_addr, ETH_ALEN);
 	nes_debug(NES_DBG_CM, "Remote mac addr from arp table: %pM\n",
-- 
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
