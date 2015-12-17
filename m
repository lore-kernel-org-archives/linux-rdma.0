From: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/mlx4: Replace kfree with kvfree in mlx4_ib_destroy_srq
Date: Thu, 17 Dec 2015 10:54:15 +0800
Message-ID: <1450320855-4570-1-git-send-email-wen.gang.wang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Matt-goXnUAHYgFxWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 0ef2f05c7e02ff99c0b5b583d7dee2cd12b053f2 uses vmalloc for WR buffers
when needed and uses kvfree to free the buffers. It missed changing kfree
to kvfree in mlx4_ib_destroy_srq().

Reported-by: Matthew Finaly <matt-goXnUAHYgFxWk0Htik3J/w@public.gmane.org>
Signed-off-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/srq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index 8d133c4..c394376 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -286,7 +286,7 @@ int mlx4_ib_destroy_srq(struct ib_srq *srq)
 		mlx4_ib_db_unmap_user(to_mucontext(srq->uobject->context), &msrq->db);
 		ib_umem_release(msrq->umem);
 	} else {
-		kfree(msrq->wrid);
+		kvfree(msrq->wrid);
 		mlx4_buf_free(dev->dev, msrq->msrq.max << msrq->msrq.wqe_shift,
 			      &msrq->buf);
 		mlx4_db_free(dev->dev, &msrq->db);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
