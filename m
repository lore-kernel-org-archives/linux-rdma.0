From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/mlx5: avoid destroying a NULL mr in reg_user_mr error flow
Date: Tue,  1 Sep 2015 09:41:11 +0300
Message-ID: <1441089671-3390-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The mlx5_ib_reg_user_mr() function will attempt to call clean_mr() in
its error flow even though there is never a case where the error flow
occurs with a valid MR pointer to destroy.

Remove the clean_mr() call and the incorrect comment above it.

Fixes: b4cfe447d47b ("IB/mlx5: Implement on demand paging by adding
support for MMU notifiers")

Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 0dfd379b9bad..54a15b5d336d 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1114,19 +1114,7 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	return &mr->ibmr;
 
 error:
-	/*
-	 * Destroy the umem *before* destroying the MR, to ensure we
-	 * will not have any in-flight notifiers when destroying the
-	 * MR.
-	 *
-	 * As the MR is completely invalid to begin with, and this
-	 * error path is only taken if we can't push the mr entry into
-	 * the pagefault tree, this is safe.
-	 */
-
 	ib_umem_release(umem);
-	/* Kill the MR, and return an error code. */
-	clean_mr(mr);
 	return ERR_PTR(err);
 }
 
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
