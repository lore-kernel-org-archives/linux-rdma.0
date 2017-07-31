From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-rc 08/14] RDMA/mlx4: Avoid potential derefence warning
Date: Mon, 31 Jul 2017 10:09:18 +0300
Message-ID: <20170731070924.7193-9-leon@kernel.org>
References: <20170731070924.7193-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170731070924.7193-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The smatch complains about possible dereference, it is unclear from
source how it can occur, since in case of failure to find/allocate
group, the acquire_group() will return error.

Avoid the following error, by changing IS_ERR() to be IS_ERR_OR_NULL().

drivers/infiniband/hw/mlx4/mcg.c:964 mlx4_ib_mcg_multiplex_handler() error:
	potential null dereference 'group'.  (acquire_group returns null)

Fixes: b9c5d6a64358 ("IB/mlx4: Add multicast group (MCG) paravirtualization for SR-IOV")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mcg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index b73f89700ef9..9c26a6837c62 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -956,7 +956,7 @@ int mlx4_ib_mcg_multiplex_handler(struct ib_device *ibdev, int port,
 		mutex_lock(&ctx->mcg_table_lock);
 		group = acquire_group(ctx, &rec->mgid, may_create, GFP_KERNEL);
 		mutex_unlock(&ctx->mcg_table_lock);
-		if (IS_ERR(group)) {
+		if (IS_ERR_OR_NULL(group)) {
 			kfree(req);
 			return PTR_ERR(group);
 		}
--
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
