From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v2 03/23] RDMA/mlx4: Don't use uninitialized variable
Date: Tue, 15 Aug 2017 11:54:32 +0300
Message-ID: <20170815085452.3546-4-leon@kernel.org>
References: <20170815085452.3546-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815085452.3546-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Avoid usage of uninitialized variable.

Fixes: 3078f5f1bd8b ("IB/mlx4: Add support for RSS QP")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index e42acfb20588..793d77f29d3e 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2034,8 +2034,8 @@ static u8 gid_type_to_qpc(enum ib_gid_type gid_type)
  */
 static int bringup_rss_rwqs(struct ib_rwq_ind_table *ind_tbl, u8 port_num)
 {
+	int err = 0;
 	int i;
-	int err;
 
 	for (i = 0; i < (1 << ind_tbl->log_ind_tbl_size); i++) {
 		struct ib_wq *ibwq = ind_tbl->ind_tbl[i];
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
