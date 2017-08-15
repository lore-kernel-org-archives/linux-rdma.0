From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v2 17/23] IB/mlx4: Fix struct mlx4_ib_create_wq alignment
Date: Tue, 15 Aug 2017 11:54:46 +0300
Message-ID: <20170815085452.3546-18-leon@kernel.org>
References: <20170815085452.3546-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815085452.3546-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The mlx4 ABI defines to have structures with alignment of 64B.

Fixes: 400b1ebcfe31 ("IB/mlx4: Add support for WQ related verbs")
Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 9 ++++-----
 include/uapi/rdma/mlx4-abi.h    | 1 -
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 603a0bf49576..44d2d0a2d5e0 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1047,9 +1047,8 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		}
 
 		if (src == MLX4_IB_RWQ_SRC) {
-			if (ucmd.wq.comp_mask || ucmd.wq.reserved1 ||
-			    ucmd.wq.reserved[0] || ucmd.wq.reserved[1] ||
-			    ucmd.wq.reserved[2]) {
+			if (ucmd.wq.comp_mask || ucmd.wq.reserved[0] ||
+			    ucmd.wq.reserved[1] || ucmd.wq.reserved[2]) {
 				pr_debug("user command isn't supported\n");
 				err = -EOPNOTSUPP;
 				goto err;
@@ -4153,8 +4152,8 @@ struct ib_wq *mlx4_ib_create_wq(struct ib_pd *pd,
 	if (!(udata && pd->uobject))
 		return ERR_PTR(-EINVAL);
 
-	required_cmd_sz = offsetof(typeof(ucmd), reserved) +
-			  sizeof(ucmd.reserved);
+	required_cmd_sz = offsetof(typeof(ucmd), comp_mask) +
+			  sizeof(ucmd.comp_mask);
 	if (udata->inlen < required_cmd_sz) {
 		pr_debug("invalid inlen\n");
 		return ERR_PTR(-EINVAL);
diff --git a/include/uapi/rdma/mlx4-abi.h b/include/uapi/rdma/mlx4-abi.h
index 21cce1a4c4dd..0e10102861b5 100644
--- a/include/uapi/rdma/mlx4-abi.h
+++ b/include/uapi/rdma/mlx4-abi.h
@@ -121,7 +121,6 @@ struct mlx4_ib_create_wq {
 	__u8	log_range_size;
 	__u8	reserved[3];
 	__u32   comp_mask;
-	__u32   reserved1;
 };
 
 struct mlx4_ib_modify_wq {
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
