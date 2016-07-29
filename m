From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] IB/mlx4: Allocation of CQ resize structure doesn't need to be atomic
Date: Thu, 28 Jul 2016 21:58:43 -0700
Message-ID: <1469768323-8093-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

We allocate a small tracking structure as part of mlx4_ib_resize_cq().
However, we don't need to use GFP_ATOMIC -- immediately after the
allocation, we call mlx4_cq_resize(), which allocates a command
mailbox with GFP_KERNEL and then sleeps on a firmware command, so we
better not be in an atomic context.

This actually has a real impact, because when this GFP_ATOMIC
allocation fails (and GFP_ATOMIC does fail in practice) then a
userspace consumer resizing a CQ will get a spurious failure that we
can easily avoid.

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 9f8b516eb2b0..d6fc8a6e8c33 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -288,7 +288,7 @@ static int mlx4_alloc_resize_buf(struct mlx4_ib_dev *dev, struct mlx4_ib_cq *cq,
 	if (cq->resize_buf)
 		return -EBUSY;
 
-	cq->resize_buf = kmalloc(sizeof *cq->resize_buf, GFP_ATOMIC);
+	cq->resize_buf = kmalloc(sizeof *cq->resize_buf, GFP_KERNEL);
 	if (!cq->resize_buf)
 		return -ENOMEM;
 
@@ -316,7 +316,7 @@ static int mlx4_alloc_resize_umem(struct mlx4_ib_dev *dev, struct mlx4_ib_cq *cq
 	if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd))
 		return -EFAULT;
 
-	cq->resize_buf = kmalloc(sizeof *cq->resize_buf, GFP_ATOMIC);
+	cq->resize_buf = kmalloc(sizeof *cq->resize_buf, GFP_KERNEL);
 	if (!cq->resize_buf)
 		return -ENOMEM;
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
