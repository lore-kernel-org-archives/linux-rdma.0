From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v2 10/23] RDMA/mlx4: Remove gfp_mask argument from acquire_group call
Date: Tue, 15 Aug 2017 11:54:39 +0300
Message-ID: <20170815085452.3546-11-leon@kernel.org>
References: <20170815085452.3546-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815085452.3546-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

All callers of acquire_group() passed the same gfp_mask to it
and it is safe to remove it.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mcg.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index b73f89700ef9..70eb9f917303 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -808,8 +808,7 @@ static ssize_t sysfs_show_group(struct device *dev,
 		struct device_attribute *attr, char *buf);
 
 static struct mcast_group *acquire_group(struct mlx4_ib_demux_ctx *ctx,
-					 union ib_gid *mgid, int create,
-					 gfp_t gfp_mask)
+					 union ib_gid *mgid, int create)
 {
 	struct mcast_group *group, *cur_group;
 	int is_mgid0;
@@ -825,7 +824,7 @@ static struct mcast_group *acquire_group(struct mlx4_ib_demux_ctx *ctx,
 	if (!create)
 		return ERR_PTR(-ENOENT);
 
-	group = kzalloc(sizeof *group, gfp_mask);
+	group = kzalloc(sizeof(*group), GFP_KERNEL);
 	if (!group)
 		return ERR_PTR(-ENOMEM);
 
@@ -892,7 +891,7 @@ int mlx4_ib_mcg_demux_handler(struct ib_device *ibdev, int port, int slave,
 	case IB_MGMT_METHOD_GET_RESP:
 	case IB_SA_METHOD_DELETE_RESP:
 		mutex_lock(&ctx->mcg_table_lock);
-		group = acquire_group(ctx, &rec->mgid, 0, GFP_KERNEL);
+		group = acquire_group(ctx, &rec->mgid, 0);
 		mutex_unlock(&ctx->mcg_table_lock);
 		if (IS_ERR(group)) {
 			if (mad->mad_hdr.method == IB_MGMT_METHOD_GET_RESP) {
@@ -954,7 +953,7 @@ int mlx4_ib_mcg_multiplex_handler(struct ib_device *ibdev, int port,
 		req->sa_mad = *sa_mad;
 
 		mutex_lock(&ctx->mcg_table_lock);
-		group = acquire_group(ctx, &rec->mgid, may_create, GFP_KERNEL);
+		group = acquire_group(ctx, &rec->mgid, may_create);
 		mutex_unlock(&ctx->mcg_table_lock);
 		if (IS_ERR(group)) {
 			kfree(req);
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
