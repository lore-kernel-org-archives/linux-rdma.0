From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 22/31] IB/core: Removed unused function
Date: Tue, 14 Nov 2017 14:52:09 +0200
Message-ID: <20171114125218.20477-23-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

rdma_addr_find_smac_by_sgid() is exported symbol not used by any kernel
module. Therefore its removed.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/addr.c | 23 -----------------------
 include/rdma/ib_addr.h         |  1 -
 2 files changed, 24 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 6679dd43fe08..e0086901d64c 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -793,29 +793,6 @@ int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
 	return 0;
 }
 
-int rdma_addr_find_smac_by_sgid(union ib_gid *sgid, u8 *smac, u16 *vlan_id)
-{
-	int ret = 0;
-	struct rdma_dev_addr dev_addr;
-	union {
-		struct sockaddr     _sockaddr;
-		struct sockaddr_in  _sockaddr_in;
-		struct sockaddr_in6 _sockaddr_in6;
-	} gid_addr;
-
-	rdma_gid2ip(&gid_addr._sockaddr, sgid);
-
-	memset(&dev_addr, 0, sizeof(dev_addr));
-	dev_addr.net = &init_net;
-	ret = rdma_translate_ip(&gid_addr._sockaddr, &dev_addr, vlan_id);
-	if (ret)
-		return ret;
-
-	memcpy(smac, dev_addr.src_dev_addr, ETH_ALEN);
-	return ret;
-}
-EXPORT_SYMBOL(rdma_addr_find_smac_by_sgid);
-
 static int netevent_callback(struct notifier_block *self, unsigned long event,
 	void *ctx)
 {
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index d5c3bbb84608..3d17073ea338 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -131,7 +131,6 @@ void rdma_copy_addr(struct rdma_dev_addr *dev_addr,
 
 int rdma_addr_size(struct sockaddr *addr);
 
-int rdma_addr_find_smac_by_sgid(union ib_gid *sgid, u8 *smac, u16 *vlan_id);
 int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
 				 const union ib_gid *dgid,
 				 u8 *dmac, const struct net_device *ndev,
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
