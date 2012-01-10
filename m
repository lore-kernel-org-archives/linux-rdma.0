From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH, RFC] nes: Add missing rcu_read_unlock() call
Date: Tue, 10 Jan 2012 16:58:45 +0000
Message-ID: <7025497.ASMhoMrTFM@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Sparse complains about nes_addr_resolve_neigh(). Does the patch below make sense ?

---
 drivers/infiniband/hw/nes/nes_cm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 425065b..1b2ccc7 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1360,6 +1360,7 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip, int arpi
 				if (!memcmp(nesadapter->arp_table[arpindex].mac_addr,
 					    neigh->ha, ETH_ALEN)) {
 					/* Mac address same as in nes_arp_table */
+					rcu_read_unlock();
 					ip_rt_put(rt);
 					return rc;
 				}
-- 
1.7.7


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
