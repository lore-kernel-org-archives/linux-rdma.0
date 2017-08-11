From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 20/22] IB/mlx4: Check that reserved fields in mlx4_ib_create_qp_rss are zero
Date: Fri, 11 Aug 2017 13:50:01 +0300
Message-ID: <20170811105003.7661-21-leon@kernel.org>
References: <20170811105003.7661-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170811105003.7661-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

According to mlx4 convention, need to fail the command due to a non-zero
value in the user data which is expected to be zero.

Fixes: 3078f5f1bd8b ("IB/mlx4: Add support for RSS QP")
Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 44d2d0a2d5e0..e992251b4ef1 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -792,6 +792,7 @@ static struct ib_qp *_mlx4_ib_create_qp_rss(struct ib_pd *pd,
 	struct mlx4_ib_create_qp_rss ucmd = {};
 	size_t required_cmd_sz;
 	int err;
+	int i;
 
 	if (!udata) {
 		pr_debug("RSS QP with NULL udata\n");
@@ -813,6 +814,10 @@ static struct ib_qp *_mlx4_ib_create_qp_rss(struct ib_pd *pd,
 		return ERR_PTR(-EFAULT);
 	}
 
+	for (i = 0; i < sizeof(ucmd.reserved); i++)
+		if (ucmd.reserved[i])
+			return ERR_PTR(-EOPNOTSUPP);
+
 	if (ucmd.comp_mask || ucmd.reserved1)
 		return ERR_PTR(-EOPNOTSUPP);
 
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
