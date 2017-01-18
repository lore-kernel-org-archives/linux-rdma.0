From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 7/7] IB/mlx5: Remove deprecated module parameter
Date: Wed, 18 Jan 2017 14:10:36 +0200
Message-ID: <20170118121036.32642-8-leon@kernel.org>
References: <20170118121036.32642-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118121036.32642-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Commit 9603b61de1ee ("mlx5: Move pci device handling from mlx5_ib
to mlx5_core") moved prof_sel module parameter from mlx5_ib to mlx5_core
and marked it as deprecated in 2014.

Three years after deprecation, it is time to remove the deprecated
module parameter.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 6a81f027..fc02f5f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -64,10 +64,6 @@ MODULE_DESCRIPTION("Mellanox Connect-IB HCA IB driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(DRIVER_VERSION);
 
-static int deprecated_prof_sel = 2;
-module_param_named(prof_sel, deprecated_prof_sel, int, 0444);
-MODULE_PARM_DESC(prof_sel, "profile selector. Deprecated here. Moved to module mlx5_core");
-
 static char mlx5_version[] =
 	DRIVER_NAME ": Mellanox Connect-IB Infiniband driver v"
 	DRIVER_VERSION " (" DRIVER_RELDATE ")\n";
@@ -3479,9 +3475,6 @@ static int __init mlx5_ib_init(void)
 {
 	int err;
 
-	if (deprecated_prof_sel != 2)
-		pr_warn("prof_sel is deprecated for mlx5_ib, set it for mlx5_core\n");
-
 	err = mlx5_register_interface(&mlx5_ib_interface);
 
 	return err;
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
