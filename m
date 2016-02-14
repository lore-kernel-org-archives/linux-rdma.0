From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/2] IB/{core, mlx5}: Fix input len in vendor specific part of create_qp/srq cmd
Date: Sun, 14 Feb 2016 18:35:52 +0200
Message-ID: <1455467752-3170-3-git-send-email-matanb@mellanox.com>
References: <1455467752-3170-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455467752-3170-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently, the inlen field of the vendor's part of the command
doesn't match the command buffer. This happens because the inlen
accommodates ib_uverbs_cmd_hdr which is deducted from the in buffer.
This is problematic since the vendor function could be called either
from the legacy verb (where the input length mismatches the actual
length) or by the extended verb (where the length matches). The vendor
has no idea which function calls it and therefore has no way to know
how the length variable should be treated.

Fixing this by aligning the inlen to the correct length.

All vendor drivers either assumed that inlen >= sizeof(vendor_uhw_cmd)
or just failed wrongly (mlx5) and fixed in this patch.

Fixes: cfb5e088e26a ('IB/mlx5: Add CQE version 1 support to user QPs and SRQs')
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |  9 ++++++---
 drivers/infiniband/hw/mlx5/srq.c     | 11 +++--------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6ffc9c4..6c6fbff 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1970,7 +1970,8 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 		   resp_size);
 	INIT_UDATA(&uhw, buf + sizeof(cmd),
 		   (unsigned long)cmd.response + resp_size,
-		   in_len - sizeof(cmd), out_len - resp_size);
+		   in_len - sizeof(cmd) - sizeof(struct ib_uverbs_cmd_hdr),
+		   out_len - resp_size);
 
 	memset(&cmd_ex, 0, sizeof(cmd_ex));
 	cmd_ex.user_handle = cmd.user_handle;
@@ -3413,7 +3414,8 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 
 	INIT_UDATA(&udata, buf + sizeof cmd,
 		   (unsigned long) cmd.response + sizeof resp,
-		   in_len - sizeof cmd, out_len - sizeof resp);
+		   in_len - sizeof cmd - sizeof(struct ib_uverbs_cmd_hdr),
+		   out_len - sizeof resp);
 
 	ret = __uverbs_create_xsrq(file, ib_dev, &xcmd, &udata);
 	if (ret)
@@ -3439,7 +3441,8 @@ ssize_t ib_uverbs_create_xsrq(struct ib_uverbs_file *file,
 
 	INIT_UDATA(&udata, buf + sizeof cmd,
 		   (unsigned long) cmd.response + sizeof resp,
-		   in_len - sizeof cmd, out_len - sizeof resp);
+		   in_len - sizeof cmd - sizeof(struct ib_uverbs_cmd_hdr),
+		   out_len - sizeof resp);
 
 	ret = __uverbs_create_xsrq(file, ib_dev, &cmd, &udata);
 	if (ret)
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index a1b7122..3b2ddd6 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -88,13 +88,8 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 	int ncont;
 	u32 offset;
 	u32 uidx = MLX5_IB_DEFAULT_UIDX;
-	int drv_data = udata->inlen - sizeof(struct ib_uverbs_cmd_hdr);
 
-	if (drv_data < 0)
-		return -EINVAL;
-
-	ucmdlen = (drv_data < sizeof(ucmd)) ?
-		  drv_data : sizeof(ucmd);
+	ucmdlen = min(udata->inlen, sizeof(ucmd));
 
 	if (ib_copy_from_udata(&ucmd, udata, ucmdlen)) {
 		mlx5_ib_dbg(dev, "failed copy udata\n");
@@ -104,9 +99,9 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 	if (ucmd.reserved0 || ucmd.reserved1)
 		return -EINVAL;
 
-	if (drv_data > sizeof(ucmd) &&
+	if (udata->inlen > sizeof(ucmd) &&
 	    !ib_is_udata_cleared(udata, sizeof(ucmd),
-				 drv_data - sizeof(ucmd)))
+				 udata->inlen - sizeof(ucmd)))
 		return -EINVAL;
 
 	if (is_xrc) {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
