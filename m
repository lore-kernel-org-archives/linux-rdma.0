From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 4/9] IB/mlx5: Simplify mlx5_ib_destroy_srq
Date: Wed, 23 Oct 2013 09:53:16 +0300
Message-ID: <1382511201-7061-5-git-send-email-eli@mellanox.com>
References: <1382511201-7061-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382511201-7061-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make use of destroy_srq_kernel() to clear SRQ resouces.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/srq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 0aa478b..f1e5845 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -390,9 +390,7 @@ int mlx5_ib_destroy_srq(struct ib_srq *srq)
 		mlx5_ib_db_unmap_user(to_mucontext(srq->uobject->context), &msrq->db);
 		ib_umem_release(msrq->umem);
 	} else {
-		kfree(msrq->wrid);
-		mlx5_buf_free(&dev->mdev, &msrq->buf);
-		mlx5_db_free(&dev->mdev, &msrq->db);
+		destroy_srq_kernel(dev, msrq);
 	}
 
 	kfree(srq);
-- 
1.8.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
