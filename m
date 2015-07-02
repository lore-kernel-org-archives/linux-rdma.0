From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-4.2 1/1] RDMA/nes: Fix for resolving the neigh
Date: Thu, 2 Jul 2015 12:49:40 -0500
Message-ID: <20150702174940.GA236@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Neighbor resolution doesn't work without this fix

Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 9047af4..8a3ad17 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1520,8 +1520,9 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip, int arpi
 	int rc = arpindex;
 	struct net_device *netdev;
 	struct nes_adapter *nesadapter = nesvnic->nesdev->nesadapter;
+	__be32 dst_ipaddr = htonl(dst_ip);
 
-	rt = ip_route_output(&init_net, htonl(dst_ip), 0, 0, 0);
+	rt = ip_route_output(&init_net, dst_ipaddr, nesvnic->local_ipaddr, 0, 0);
 	if (IS_ERR(rt)) {
 		printk(KERN_ERR "%s: ip_route_output_key failed for 0x%08X\n",
 		       __func__, dst_ip);
@@ -1533,7 +1534,7 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip, int arpi
 	else
 		netdev = nesvnic->netdev;
 
-	neigh = neigh_lookup(&arp_tbl, &rt->rt_gateway, netdev);
+	neigh = dst_neigh_lookup(&rt->dst, &dst_ipaddr);
 
 	rcu_read_lock();
 	if (neigh) {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
