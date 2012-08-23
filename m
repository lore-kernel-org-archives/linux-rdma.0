From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 4/4] net/mlx4_core: Remove annoying debug message in the resource tracker
Date: Thu, 23 Aug 2012 17:09:05 +0300
Message-ID: <1345730945-1843-5-git-send-email-ogerlitz@mellanox.com>
References: <1345730945-1843-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345730945-1843-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This innocent print makes it very hard to actually use the mlx4 core
debug messages -- for example, the module load sequence of a device with
two VFs yielded 3200 debug prints, with 2800 of them being this
exact one, remove it.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 94ceddd..9ddb751 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -359,8 +359,6 @@ static int get_res(struct mlx4_dev *dev, int slave, u64 res_id,
 
 	r->from_state = r->state;
 	r->state = RES_ANY_BUSY;
-	mlx4_dbg(dev, "res %s id 0x%llx to busy\n",
-		 ResourceType(type), r->res_id);
 
 	if (res)
 		*((struct res_common **)res) = r;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
