From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 06/11] net/mlx5: FWPage, Use async events chain
Date: Tue, 20 Nov 2018 14:12:23 -0800
Message-ID: <20181120221228.18365-7-saeedm@mellanox.com>
References: <20181120221228.18365-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181120221228.18365-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Remove the explicit call to mlx5_core_req_pages_handler on
MLX5_EVENT_TYPE_PAGE_REQUEST and let FW page logic  to register its own
handler when its ready.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 11 -----
 .../net/ethernet/mellanox/mlx5/core/main.c    | 27 ++++++------
 .../ethernet/mellanox/mlx5/core/pagealloc.c   | 44 +++++++++++++------
 include/linux/mlx5/driver.h                   |  5 ++-
 4 files changed, 47 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 7c8b2d89645b..7f6a644700eb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -398,17 +398,6 @@ static irqreturn_t mlx5_eq_async_int(int irq, void *eq_ptr)
 			mlx5_eq_cq_event(eq, cqn, eqe->type);
 			break;
 
-		case MLX5_EVENT_TYPE_PAGE_REQUEST:
-			{
-				u16 func_id = be16_to_cpu(eqe->data.req_pages.func_id);
-				s32 npages = be32_to_cpu(eqe->data.req_pages.num_pages);
-
-				mlx5_core_dbg(dev, "page request for func 0x%x, npages %d\n",
-					      func_id, npages);
-				mlx5_core_req_pages_handler(dev, func_id, npages);
-			}
-			break;
-
 		case MLX5_EVENT_TYPE_PORT_MODULE_EVENT:
 			mlx5_port_module_event(dev, eqe);
 			break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 91022f141855..9e4cd2757ea8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -916,16 +916,10 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 		goto reclaim_boot_pages;
 	}
 
-	err = mlx5_pagealloc_start(dev);
-	if (err) {
-		dev_err(&pdev->dev, "mlx5_pagealloc_start failed\n");
-		goto reclaim_boot_pages;
-	}
-
 	err = mlx5_cmd_init_hca(dev, sw_owner_id);
 	if (err) {
 		dev_err(&pdev->dev, "init hca failed\n");
-		goto err_pagealloc_stop;
+		goto reclaim_boot_pages;
 	}
 
 	mlx5_set_driver_version(dev);
@@ -953,6 +947,8 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 		goto err_get_uars;
 	}
 
+	mlx5_pagealloc_start(dev);
+
 	err = mlx5_eq_table_create(dev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to create EQs\n");
@@ -1039,6 +1035,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	mlx5_eq_table_destroy(dev);
 
 err_eq_table:
+	mlx5_pagealloc_stop(dev);
 	mlx5_put_uars_page(dev, priv->uar);
 
 err_get_uars:
@@ -1052,9 +1049,6 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 		goto out_err;
 	}
 
-err_pagealloc_stop:
-	mlx5_pagealloc_stop(dev);
-
 reclaim_boot_pages:
 	mlx5_reclaim_startup_pages(dev);
 
@@ -1100,16 +1094,18 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev, struct mlx5_priv *priv,
 	mlx5_fpga_device_stop(dev);
 	mlx5_fw_tracer_cleanup(dev->tracer);
 	mlx5_eq_table_destroy(dev);
+	mlx5_pagealloc_stop(dev);
 	mlx5_put_uars_page(dev, priv->uar);
+
 	if (cleanup)
 		mlx5_cleanup_once(dev);
 	mlx5_stop_health_poll(dev, cleanup);
+
 	err = mlx5_cmd_teardown_hca(dev);
 	if (err) {
 		dev_err(&dev->pdev->dev, "tear_down_hca failed, skip cleanup\n");
 		goto out;
 	}
-	mlx5_pagealloc_stop(dev);
 	mlx5_reclaim_startup_pages(dev);
 	mlx5_core_disable_hca(dev, 0);
 	mlx5_cmd_cleanup(dev);
@@ -1186,12 +1182,14 @@ static int init_one(struct pci_dev *pdev,
 		goto close_pci;
 	}
 
-	mlx5_pagealloc_init(dev);
+	err = mlx5_pagealloc_init(dev);
+	if (err)
+		goto err_pagealloc_init;
 
 	err = mlx5_load_one(dev, priv, true);
 	if (err) {
 		dev_err(&pdev->dev, "mlx5_load_one failed with error code %d\n", err);
-		goto clean_health;
+		goto err_load_one;
 	}
 
 	request_module_nowait(MLX5_IB_MOD);
@@ -1205,8 +1203,9 @@ static int init_one(struct pci_dev *pdev,
 
 clean_load:
 	mlx5_unload_one(dev, priv, true);
-clean_health:
+err_load_one:
 	mlx5_pagealloc_cleanup(dev);
+err_pagealloc_init:
 	mlx5_health_cleanup(dev);
 close_pci:
 	mlx5_pci_close(dev, priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index e36d3e3675f9..a83b517b0714 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -37,6 +37,7 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/cmd.h>
 #include "mlx5_core.h"
+#include "lib/eq.h"
 
 enum {
 	MLX5_PAGES_CANT_GIVE	= 0,
@@ -433,15 +434,28 @@ static void pages_work_handler(struct work_struct *work)
 	kfree(req);
 }
 
-void mlx5_core_req_pages_handler(struct mlx5_core_dev *dev, u16 func_id,
-				 s32 npages)
+static int req_pages_handler(struct notifier_block *nb,
+			     unsigned long type, void *data)
 {
 	struct mlx5_pages_req *req;
-
+	struct mlx5_core_dev *dev;
+	struct mlx5_priv *priv;
+	struct mlx5_eqe *eqe;
+	u16 func_id;
+	s32 npages;
+
+	priv = mlx5_nb_cof(nb, struct mlx5_priv, pg_nb);
+	dev  = container_of(priv, struct mlx5_core_dev, priv);
+	eqe  = data;
+
+	func_id = be16_to_cpu(eqe->data.req_pages.func_id);
+	npages  = be32_to_cpu(eqe->data.req_pages.num_pages);
+	mlx5_core_dbg(dev, "page request for func 0x%x, npages %d\n",
+		      func_id, npages);
 	req = kzalloc(sizeof(*req), GFP_ATOMIC);
 	if (!req) {
 		mlx5_core_warn(dev, "failed to allocate pages request\n");
-		return;
+		return NOTIFY_DONE;
 	}
 
 	req->dev = dev;
@@ -449,6 +463,7 @@ void mlx5_core_req_pages_handler(struct mlx5_core_dev *dev, u16 func_id,
 	req->npages = npages;
 	INIT_WORK(&req->work, pages_work_handler);
 	queue_work(dev->priv.pg_wq, &req->work);
+	return NOTIFY_OK;
 }
 
 int mlx5_satisfy_startup_pages(struct mlx5_core_dev *dev, int boot)
@@ -524,29 +539,32 @@ int mlx5_reclaim_startup_pages(struct mlx5_core_dev *dev)
 	return 0;
 }
 
-void mlx5_pagealloc_init(struct mlx5_core_dev *dev)
+int mlx5_pagealloc_init(struct mlx5_core_dev *dev)
 {
 	dev->priv.page_root = RB_ROOT;
 	INIT_LIST_HEAD(&dev->priv.free_list);
+	dev->priv.pg_wq = create_singlethread_workqueue("mlx5_page_allocator");
+	if (!dev->priv.pg_wq)
+		return -ENOMEM;
+
+	return 0;
 }
 
 void mlx5_pagealloc_cleanup(struct mlx5_core_dev *dev)
 {
-	/* nothing */
+	destroy_workqueue(dev->priv.pg_wq);
 }
 
-int mlx5_pagealloc_start(struct mlx5_core_dev *dev)
+void mlx5_pagealloc_start(struct mlx5_core_dev *dev)
 {
-	dev->priv.pg_wq = create_singlethread_workqueue("mlx5_page_allocator");
-	if (!dev->priv.pg_wq)
-		return -ENOMEM;
-
-	return 0;
+	MLX5_NB_INIT(&dev->priv.pg_nb, req_pages_handler, PAGE_REQUEST);
+	mlx5_eq_notifier_register(dev, &dev->priv.pg_nb);
 }
 
 void mlx5_pagealloc_stop(struct mlx5_core_dev *dev)
 {
-	destroy_workqueue(dev->priv.pg_wq);
+	mlx5_eq_notifier_unregister(dev, &dev->priv.pg_nb);
+	flush_workqueue(dev->priv.pg_wq);
 }
 
 int mlx5_wait_for_vf_pages(struct mlx5_core_dev *dev)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 99a23db9a929..61088ad33500 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -564,6 +564,7 @@ struct mlx5_priv {
 	struct mlx5_eq_table	*eq_table;
 
 	/* pages stuff */
+	struct mlx5_nb          pg_nb;
 	struct workqueue_struct *pg_wq;
 	struct rb_root		page_root;
 	int			fw_pages;
@@ -962,9 +963,9 @@ int mlx5_core_alloc_pd(struct mlx5_core_dev *dev, u32 *pdn);
 int mlx5_core_dealloc_pd(struct mlx5_core_dev *dev, u32 pdn);
 int mlx5_core_mad_ifc(struct mlx5_core_dev *dev, const void *inb, void *outb,
 		      u16 opmod, u8 port);
-void mlx5_pagealloc_init(struct mlx5_core_dev *dev);
+int mlx5_pagealloc_init(struct mlx5_core_dev *dev);
 void mlx5_pagealloc_cleanup(struct mlx5_core_dev *dev);
-int mlx5_pagealloc_start(struct mlx5_core_dev *dev);
+void mlx5_pagealloc_start(struct mlx5_core_dev *dev);
 void mlx5_pagealloc_stop(struct mlx5_core_dev *dev);
 void mlx5_core_req_pages_handler(struct mlx5_core_dev *dev, u16 func_id,
 				 s32 npages);
-- 
2.19.1
