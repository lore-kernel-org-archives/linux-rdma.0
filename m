From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] IB/mlx5: Verify reserved fields are cleared
Date: Wed, 15 Jan 2014 14:56:44 +0200
Message-ID: <20140115125644.GA31478@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Verify that reserved fields in struct mlx5_ib_resize_cq are cleared before
continuing execution of the verb. This is required to allow making use of this
area in futural revisions.

Change-Id: I5c9c5da2562ab2b04767d0e5cb1d78e960aa73c2
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 50b03a8..b1705ce 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -877,8 +877,12 @@ static int resize_user(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 	int npages;
 	struct ib_ucontext *context = cq->buf.umem->context;
 
-	if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd)))
-		return -EFAULT;
+	err = ib_copy_from_udata(&ucmd, udata, sizeof(ucmd));
+	if (err)
+		return err;
+
+	if (ucmd.reserved0 || ucmd.reserved1)
+		return -EINVAL;
 
 	umem = ib_umem_get(context, ucmd.buf_addr, entries * ucmd.cqe_size,
 			   IB_ACCESS_LOCAL_WRITE, 1);
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
