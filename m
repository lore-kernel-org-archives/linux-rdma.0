From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 04/11] net/mlx5: Clock, Use async events chain
Date: Tue, 20 Nov 2018 14:12:21 -0800
Message-ID: <20181120221228.18365-5-saeedm@mellanox.com>
References: <20181120221228.18365-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181120221228.18365-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Remove the explicit call to mlx5_pps_event on MLX5_EVENT_TYPE_PPS_EVENT
and let clock logic to register its own handler when its ready.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  4 ----
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 24 +++++++++++++------
 .../ethernet/mellanox/mlx5/core/lib/clock.h   |  3 ---
 include/linux/mlx5/driver.h                   |  4 +++-
 4 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 8aabd23d2166..e5fcce9ca107 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -417,10 +417,6 @@ static irqreturn_t mlx5_eq_async_int(int irq, void *eq_ptr)
 			mlx5_port_module_event(dev, eqe);
 			break;
 
-		case MLX5_EVENT_TYPE_PPS_EVENT:
-			mlx5_pps_event(dev, eqe);
-			break;
-
 		case MLX5_EVENT_TYPE_TEMP_WARN_EVENT:
 			mlx5_temp_warning_event(dev, eqe);
 			break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 0d90b1b4a3d3..d27c239e7d6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -33,6 +33,7 @@
 #include <linux/clocksource.h>
 #include <linux/highmem.h>
 #include <rdma/mlx5-abi.h>
+#include "lib/eq.h"
 #include "en.h"
 #include "clock.h"
 
@@ -439,16 +440,17 @@ static void mlx5_get_pps_caps(struct mlx5_core_dev *mdev)
 	clock->pps_info.pin_caps[7] = MLX5_GET(mtpps_reg, out, cap_pin_7_mode);
 }
 
-void mlx5_pps_event(struct mlx5_core_dev *mdev,
-		    struct mlx5_eqe *eqe)
+static int mlx5_pps_event(struct notifier_block *nb,
+			  unsigned long type, void *data)
 {
-	struct mlx5_clock *clock = &mdev->clock;
+	struct mlx5_clock *clock = mlx5_nb_cof(nb, struct mlx5_clock, pps_nb);
+	struct mlx5_core_dev *mdev = clock->mdev;
 	struct ptp_clock_event ptp_event;
-	struct timespec64 ts;
-	u64 nsec_now, nsec_delta;
 	u64 cycles_now, cycles_delta;
+	u64 nsec_now, nsec_delta, ns;
+	struct mlx5_eqe *eqe = data;
 	int pin = eqe->data.pps.pin;
-	s64 ns;
+	struct timespec64 ts;
 	unsigned long flags;
 
 	switch (clock->ptp_info.pin_config[pin].func) {
@@ -463,6 +465,7 @@ void mlx5_pps_event(struct mlx5_core_dev *mdev,
 		} else {
 			ptp_event.type = PTP_CLOCK_EXTTS;
 		}
+		/* TODOL clock->ptp can be NULL if ptp_clock_register failes */
 		ptp_clock_event(clock->ptp, &ptp_event);
 		break;
 	case PTP_PF_PEROUT:
@@ -481,8 +484,11 @@ void mlx5_pps_event(struct mlx5_core_dev *mdev,
 		write_sequnlock_irqrestore(&clock->lock, flags);
 		break;
 	default:
-		mlx5_core_err(mdev, " Unhandled event\n");
+		mlx5_core_err(mdev, " Unhandled clock PPS event, func %d\n",
+			      clock->ptp_info.pin_config[pin].func);
 	}
+
+	return NOTIFY_OK;
 }
 
 void mlx5_init_clock(struct mlx5_core_dev *mdev)
@@ -567,6 +573,9 @@ void mlx5_init_clock(struct mlx5_core_dev *mdev)
 			       PTR_ERR(clock->ptp));
 		clock->ptp = NULL;
 	}
+
+	MLX5_NB_INIT(&clock->pps_nb, mlx5_pps_event, PPS_EVENT);
+	mlx5_eq_notifier_register(mdev, &clock->pps_nb);
 }
 
 void mlx5_cleanup_clock(struct mlx5_core_dev *mdev)
@@ -576,6 +585,7 @@ void mlx5_cleanup_clock(struct mlx5_core_dev *mdev)
 	if (!MLX5_CAP_GEN(mdev, device_frequency_khz))
 		return;
 
+	mlx5_eq_notifier_unregister(mdev, &clock->pps_nb);
 	if (clock->ptp) {
 		ptp_clock_unregister(clock->ptp);
 		clock->ptp = NULL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
index 263cb6e2aeee..31600924bdc3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
@@ -36,7 +36,6 @@
 #if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
 void mlx5_init_clock(struct mlx5_core_dev *mdev);
 void mlx5_cleanup_clock(struct mlx5_core_dev *mdev);
-void mlx5_pps_event(struct mlx5_core_dev *dev, struct mlx5_eqe *eqe);
 
 static inline int mlx5_clock_get_ptp_index(struct mlx5_core_dev *mdev)
 {
@@ -60,8 +59,6 @@ static inline ktime_t mlx5_timecounter_cyc2time(struct mlx5_clock *clock,
 #else
 static inline void mlx5_init_clock(struct mlx5_core_dev *mdev) {}
 static inline void mlx5_cleanup_clock(struct mlx5_core_dev *mdev) {}
-static inline void mlx5_pps_event(struct mlx5_core_dev *dev, struct mlx5_eqe *eqe) {}
-
 static inline int mlx5_clock_get_ptp_index(struct mlx5_core_dev *mdev)
 {
 	return -1;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f41e6713df10..99a23db9a929 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -50,6 +50,7 @@
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/doorbell.h>
 #include <linux/mlx5/srq.h>
+#include <linux/mlx5/eq.h>
 #include <linux/timecounter.h>
 #include <linux/ptp_clock_kernel.h>
 
@@ -671,6 +672,8 @@ struct mlx5_pps {
 };
 
 struct mlx5_clock {
+	struct mlx5_core_dev      *mdev;
+	struct mlx5_nb             pps_nb;
 	seqlock_t                  lock;
 	struct cyclecounter        cycles;
 	struct timecounter         tc;
@@ -678,7 +681,6 @@ struct mlx5_clock {
 	u32                        nominal_c_mult;
 	unsigned long              overflow_period;
 	struct delayed_work        overflow_work;
-	struct mlx5_core_dev      *mdev;
 	struct ptp_clock          *ptp;
 	struct ptp_clock_info      ptp_info;
 	struct mlx5_pps            pps_info;
-- 
2.19.1
