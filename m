From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V6 11/14] IB/mlx5: Implement common uverb objects
Date: Sun, 11 Dec 2016 14:58:05 +0200
Message-ID: <1481461088-56355-12-git-send-email-matanb@mellanox.com>
References: <1481461088-56355-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481461088-56355-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch simply tells mlx5 to use the uverb objects declared by
the common layer.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a10b203..4e739e7 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -51,6 +51,7 @@
 #include <linux/list.h>
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem.h>
+#include <rdma/uverbs_ioctl_cmd.h>
 #include <linux/in.h>
 #include <linux/etherdevice.h>
 #include <linux/mlx5/fs.h>
@@ -2919,8 +2920,6 @@ free:
 	return ARRAY_SIZE(names);
 }
 
-DECLARE_UVERBS_TYPES_GROUP(root, &uverbs_common_types);
-
 static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_ib_dev *dev;
@@ -2929,6 +2928,10 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	const char *name;
 	int err;
 	int i;
+	static const struct uverbs_root_spec root_spec[] = {
+		[0] = {.types = &uverbs_common_types,
+			.group_id = 0},
+	};
 
 	port_type_cap = MLX5_CAP_GEN(mdev, port_type);
 	ll = mlx5_port_type_cap_to_rdma_ll(port_type_cap);
@@ -3131,10 +3134,15 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	if (err)
 		goto err_odp;
 
-	dev->ib_dev.specs_root = (struct uverbs_root *)&root;
+	dev->ib_dev.specs_root =
+		uverbs_alloc_spec_tree(ARRAY_SIZE(root_spec),
+				       root_spec);
+	if (IS_ERR(dev->ib_dev.specs_root))
+		goto err_q_cnt;
+
 	err = ib_register_device(&dev->ib_dev, NULL);
 	if (err)
-		goto err_q_cnt;
+		goto err_alloc_spec_tree;
 
 	err = create_umr_res(dev);
 	if (err)
@@ -3157,6 +3165,9 @@ err_umrc:
 err_dev:
 	ib_unregister_device(&dev->ib_dev);
 
+err_alloc_spec_tree:
+	uverbs_specs_free(dev->ib_dev.specs_root);
+
 err_q_cnt:
 	mlx5_ib_dealloc_q_counters(dev);
 
@@ -3188,6 +3199,7 @@ static void mlx5_ib_remove(struct mlx5_core_dev *mdev, void *context)
 
 	mlx5_remove_roce_notifier(dev);
 	ib_unregister_device(&dev->ib_dev);
+	uverbs_specs_free(dev->ib_dev.specs_root);
 	mlx5_ib_dealloc_q_counters(dev);
 	destroy_umrc_res(dev);
 	mlx5_ib_odp_remove_one(dev);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
