From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 1/9] IB/mlx5: Fix check of number of entries in create CQ
Date: Wed, 23 Oct 2013 09:53:13 +0300
Message-ID: <1382511201-7061-2-git-send-email-eli@mellanox.com>
References: <1382511201-7061-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382511201-7061-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Verify that the value is non negative before rounding up to power of 2.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 344ab03..e7c64c5 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -653,8 +653,11 @@ struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev, int entries,
 	int eqn;
 	int err;
 
+	if (entries < 0)
+		return ERR_PTR(-EINVAL);
+
 	entries = roundup_pow_of_two(entries + 1);
-	if (entries < 1 || entries > dev->mdev.caps.max_cqes)
+	if (entries > dev->mdev.caps.max_cqes)
 		return ERR_PTR(-EINVAL);
 
 	cq = kzalloc(sizeof(*cq), GFP_KERNEL);
-- 
1.8.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
