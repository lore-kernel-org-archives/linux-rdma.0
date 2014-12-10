From: roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] RDMA/nes: remove unnecessary RCU lock
Date: Wed, 10 Dec 2014 17:24:31 +0800
Message-ID: <1418203471-14784-1-git-send-email-roy.qing.li@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The neigh returned from neigh_lookup has its ref added, not need
to hold RCU lock

and move neigh_release to avoid to check if neigh is NULL again.

Signed-off-by: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 6f09a72..d9e3b4b 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1510,7 +1510,6 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip, int arpi
 
 	neigh = neigh_lookup(&arp_tbl, &rt->rt_gateway, netdev);
 
-	rcu_read_lock();
 	if (neigh) {
 		if (neigh->nud_state & NUD_VALID) {
 			nes_debug(NES_DBG_CM, "Neighbor MAC address for 0x%08X"
@@ -1535,12 +1534,9 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip, int arpi
 		} else {
 			neigh_event_send(neigh, NULL);
 		}
-	}
 out:
-	rcu_read_unlock();
-
-	if (neigh)
 		neigh_release(neigh);
+	}
 
 	ip_rt_put(rt);
 	return rc;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
