From: Christian Engelmayer <cengelma-RbZlAiThDcE@public.gmane.org>
Subject: [PATCH] IB/mlx4: Fix potentially uninitialized use of 'is_mcast' in create_iboe_ah()
Date: Sat, 17 May 2014 14:09:27 +0200
Message-ID: <1400328567-4430-1-git-send-email-cengelma@gmx.at>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Engelmayer <cengelma-RbZlAiThDcE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Before commit 297e0da (IB/mlx4: Handle Ethernet L2 parameters for IP based GID
addressing) local variable 'is_mcast' in function create_iboe_ah() was
guaranteed to be set after calling mlx4_ib_resolve_grh(). Since 297e0da
'is_mcast' is set in case of rdma_is_multicast_addr(), but otherwise left
uninitialized. Thus init 'is_mcast' to 0. Detected by Coverity - CID 1164324

Signed-off-by: Christian Engelmayer <cengelma-RbZlAiThDcE@public.gmane.org>
---
Compile tested. Applies against branch for-next in tree
git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git
---
 drivers/infiniband/hw/mlx4/ah.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index 170dca6..2d8c339 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -73,7 +73,7 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 {
 	struct mlx4_ib_dev *ibdev = to_mdev(pd->device);
 	struct mlx4_dev *dev = ibdev->dev;
-	int is_mcast;
+	int is_mcast = 0;
 	struct in6_addr in6;
 	u16 vlan_tag;
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
