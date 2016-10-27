From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 05/12] IB/mlx5: Validate requested RQT size
Date: Thu, 27 Oct 2016 16:36:40 +0300
Message-ID: <1477575407-20562-6-git-send-email-leon@kernel.org>
References: <1477575407-20562-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477575407-20562-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Validate that the requested size of RQT is supported by firmware.

Fixes: c5f9092936fe ('IB/mlx5: Add Receive Work Queue Indirection table operations')
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 5bdf20c..047f7e4 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4817,6 +4817,14 @@ struct ib_rwq_ind_table *mlx5_ib_create_rwq_ind_table(struct ib_device *device,
 				 udata->inlen))
 		return ERR_PTR(-EOPNOTSUPP);
 
+	if (init_attr->log_ind_tbl_size >
+	    MLX5_CAP_GEN(dev->mdev, log_max_rqt_size)) {
+		mlx5_ib_dbg(dev, "log_ind_tbl_size = %d is bigger than supported = %d\n",
+			    init_attr->log_ind_tbl_size,
+			    MLX5_CAP_GEN(dev->mdev, log_max_rqt_size));
+		return ERR_PTR(-EINVAL);
+	}
+
 	min_resp_len = offsetof(typeof(resp), reserved) + sizeof(resp.reserved);
 	if (udata->outlen && udata->outlen < min_resp_len)
 		return ERR_PTR(-EINVAL);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
