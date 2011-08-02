From: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mlx4: Fix the attribute sq_sig_type value in query qp
Date: Tue, 2 Aug 2011 15:34:39 +0300
Message-ID: <201108021534.39846.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add a missing attribute in query QP over mlx4 device.

Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

---
 drivers/infiniband/hw/mlx4/qp.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 2ec1a60..b087a8f 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2603,6 +2603,9 @@ done:
 	if (qp->flags & MLX4_IB_QP_LSO)
 		qp_init_attr->create_flags |= IB_QP_CREATE_IPOIB_UD_LSO;
 
+	qp_init_attr->sq_sig_type = qp->sq_signal_bits == cpu_to_be32(
+		MLX4_WQE_CTRL_CQ_UPDATE) ? IB_SIGNAL_ALL_WR : IB_SIGNAL_REQ_WR;
+
 out:
 	mutex_unlock(&qp->mutex);
 	return err;
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
