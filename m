From: Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/core: replace memcpy with ether_addr_copy
Date: Thu, 24 Aug 2017 21:11:47 +0530
Message-ID: <1503589307-10457-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Use ether_addr_copy to copy an ethernet address of size ETH_ALEN
instead of memcpy.

Signed-off-by: Himanshu Jha <himanshujha199640-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/addr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 437522c..fc5bf11 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -798,7 +798,7 @@ int rdma_addr_find_l2_eth_by_grh(const union ib_gid *sgid,
 	if (ret)
 		return ret;
 
-	memcpy(dmac, dev_addr.dst_dev_addr, ETH_ALEN);
+	ether_addr_copy(dmac, dev_addr.dst_dev_addr);
 	dev = dev_get_by_index(&init_net, dev_addr.bound_dev_if);
 	if (!dev)
 		return -ENODEV;
@@ -831,7 +831,7 @@ int rdma_addr_find_smac_by_sgid(union ib_gid *sgid, u8 *smac, u16 *vlan_id)
 	if (ret)
 		return ret;
 
-	memcpy(smac, dev_addr.src_dev_addr, ETH_ALEN);
+	ether_addr_copy(smac, dev_addr.src_dev_addr);
 	return ret;
 }
 EXPORT_SYMBOL(rdma_addr_find_smac_by_sgid);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
