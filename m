From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 03/11] net/mlx5: FPGA, Use async events chain
Date: Tue, 20 Nov 2018 14:12:20 -0800
Message-ID: <20181120221228.18365-4-saeedm@mellanox.com>
References: <20181120221228.18365-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181120221228.18365-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Remove the explicit call to mlx5_fpga_event on
MLX5_EVENT_TYPE_FPGA_ERROR or MLX5_EVENT_TYPE_FPGA_QP_ERROR
let fpga core to register its own handler when its ready.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  5 ---
 .../ethernet/mellanox/mlx5/core/fpga/core.c   | 38 ++++++++++++++++---
 .../ethernet/mellanox/mlx5/core/fpga/core.h   | 11 +++---
 3 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index c7c436b0ed2e..8aabd23d2166 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -421,11 +421,6 @@ static irqreturn_t mlx5_eq_async_int(int irq, void *eq_ptr)
 			mlx5_pps_event(dev, eqe);
 			break;
 
-		case MLX5_EVENT_TYPE_FPGA_ERROR:
-		case MLX5_EVENT_TYPE_FPGA_QP_ERROR:
-			mlx5_fpga_event(dev, eqe->type, &eqe->data.raw);
-			break;
-
 		case MLX5_EVENT_TYPE_TEMP_WARN_EVENT:
 			mlx5_temp_warning_event(dev, eqe);
 			break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
index 436a8136f26f..27c5f6c7d36a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
@@ -36,6 +36,7 @@
 
 #include "mlx5_core.h"
 #include "lib/mlx5.h"
+#include "lib/eq.h"
 #include "fpga/core.h"
 #include "fpga/conn.h"
 
@@ -145,6 +146,22 @@ static int mlx5_fpga_device_brb(struct mlx5_fpga_device *fdev)
 	return 0;
 }
 
+static int mlx5_fpga_event(struct mlx5_fpga_device *, unsigned long, void *);
+
+static int fpga_err_event(struct notifier_block *nb, unsigned long event, void *eqe)
+{
+	struct mlx5_fpga_device *fdev = mlx5_nb_cof(nb, struct mlx5_fpga_device, fpga_err_nb);
+
+	return mlx5_fpga_event(fdev, event, eqe);
+}
+
+static int fpga_qp_err_event(struct notifier_block *nb, unsigned long event, void *eqe)
+{
+	struct mlx5_fpga_device *fdev = mlx5_nb_cof(nb, struct mlx5_fpga_device, fpga_qp_err_nb);
+
+	return mlx5_fpga_event(fdev, event, eqe);
+}
+
 int mlx5_fpga_device_start(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_fpga_device *fdev = mdev->fpga;
@@ -185,6 +202,11 @@ int mlx5_fpga_device_start(struct mlx5_core_dev *mdev)
 	if (err)
 		goto out;
 
+	MLX5_NB_INIT(&fdev->fpga_err_nb, fpga_err_event, FPGA_ERROR);
+	MLX5_NB_INIT(&fdev->fpga_qp_err_nb, fpga_qp_err_event, FPGA_QP_ERROR);
+	mlx5_eq_notifier_register(fdev->mdev, &fdev->fpga_err_nb);
+	mlx5_eq_notifier_register(fdev->mdev, &fdev->fpga_qp_err_nb);
+
 	err = mlx5_fpga_conn_device_init(fdev);
 	if (err)
 		goto err_rsvd_gid;
@@ -201,6 +223,8 @@ int mlx5_fpga_device_start(struct mlx5_core_dev *mdev)
 	mlx5_fpga_conn_device_cleanup(fdev);
 
 err_rsvd_gid:
+	mlx5_eq_notifier_unregister(fdev->mdev, &fdev->fpga_err_nb);
+	mlx5_eq_notifier_unregister(fdev->mdev, &fdev->fpga_qp_err_nb);
 	mlx5_core_unreserve_gids(mdev, max_num_qps);
 out:
 	spin_lock_irqsave(&fdev->state_lock, flags);
@@ -256,6 +280,9 @@ void mlx5_fpga_device_stop(struct mlx5_core_dev *mdev)
 	}
 
 	mlx5_fpga_conn_device_cleanup(fdev);
+	mlx5_eq_notifier_unregister(fdev->mdev, &fdev->fpga_err_nb);
+	mlx5_eq_notifier_unregister(fdev->mdev, &fdev->fpga_qp_err_nb);
+
 	max_num_qps = MLX5_CAP_FPGA(mdev, shell_caps.max_num_qps);
 	mlx5_core_unreserve_gids(mdev, max_num_qps);
 }
@@ -283,9 +310,10 @@ static const char *mlx5_fpga_qp_syndrome_to_string(u8 syndrome)
 	return "Unknown";
 }
 
-void mlx5_fpga_event(struct mlx5_core_dev *mdev, u8 event, void *data)
+static int mlx5_fpga_event(struct mlx5_fpga_device *fdev,
+			   unsigned long event, void *eqe)
 {
-	struct mlx5_fpga_device *fdev = mdev->fpga;
+	void *data = ((struct mlx5_eqe *)eqe)->data.raw;
 	const char *event_name;
 	bool teardown = false;
 	unsigned long flags;
@@ -303,9 +331,7 @@ void mlx5_fpga_event(struct mlx5_core_dev *mdev, u8 event, void *data)
 		fpga_qpn = MLX5_GET(fpga_qp_error_event, data, fpga_qpn);
 		break;
 	default:
-		mlx5_fpga_warn_ratelimited(fdev, "Unexpected event %u\n",
-					   event);
-		return;
+		return NOTIFY_DONE;
 	}
 
 	spin_lock_irqsave(&fdev->state_lock, flags);
@@ -326,4 +352,6 @@ void mlx5_fpga_event(struct mlx5_core_dev *mdev, u8 event, void *data)
 	 */
 	if (teardown)
 		mlx5_trigger_health_work(fdev->mdev);
+
+	return NOTIFY_OK;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.h b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.h
index 3e2355c8df3f..7e2e871dbf83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.h
@@ -35,11 +35,16 @@
 
 #ifdef CONFIG_MLX5_FPGA
 
+#include <linux/mlx5/eq.h>
+
+#include "lib/eq.h"
 #include "fpga/cmd.h"
 
 /* Represents an Innova device */
 struct mlx5_fpga_device {
 	struct mlx5_core_dev *mdev;
+	struct mlx5_nb fpga_err_nb;
+	struct mlx5_nb fpga_qp_err_nb;
 	spinlock_t state_lock; /* Protects state transitions */
 	enum mlx5_fpga_status state;
 	enum mlx5_fpga_image last_admin_image;
@@ -82,7 +87,6 @@ int mlx5_fpga_init(struct mlx5_core_dev *mdev);
 void mlx5_fpga_cleanup(struct mlx5_core_dev *mdev);
 int mlx5_fpga_device_start(struct mlx5_core_dev *mdev);
 void mlx5_fpga_device_stop(struct mlx5_core_dev *mdev);
-void mlx5_fpga_event(struct mlx5_core_dev *mdev, u8 event, void *data);
 
 #else
 
@@ -104,11 +108,6 @@ static inline void mlx5_fpga_device_stop(struct mlx5_core_dev *mdev)
 {
 }
 
-static inline void mlx5_fpga_event(struct mlx5_core_dev *mdev, u8 event,
-				   void *data)
-{
-}
-
 #endif
 
 #endif /* __MLX5_FPGA_CORE_H__ */
-- 
2.19.1
