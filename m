From: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Subject: [PATCH 12/27] net/mlx5: Use timecounter_initialize interface
Date: Fri, 15 Dec 2017 13:08:27 +0530
Message-ID: <1513323522-15021-13-git-send-email-sagar.a.kamble@intel.com>
References: <1513323522-15021-1-git-send-email-sagar.a.kamble@intel.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1513323522-15021-1-git-send-email-sagar.a.kamble@intel.com>
Sender: netdev-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Sagar Arun Kamble <sagar.a.kamble@intel.com>, Richard Cochran <richardcochran@gmail.com>, Saeed Mahameed <saeedm@mellanox.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Eugenia Emantayev <eugenia@mellanox.com>, Eitan Rabin <rabin@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, Miroslav Lichvar <mlichvar@redhat.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

With new interface timecounter_initialize we can initialize timecounter
fields and underlying cyclecounter together. Update mlx5 timecounter
init with this new function.

Signed-off-by: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Matan Barak <matanb@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Eugenia Emantayev <eugenia@mellanox.com>
Cc: Eitan Rabin <rabin@mellanox.com>
Cc: Feras Daoud <ferasda@mellanox.com>
Cc: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 8cb6838..071f78a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -458,6 +458,7 @@ void mlx5_init_clock(struct mlx5_core_dev *mdev)
 	u64 ns;
 	u64 frac = 0;
 	u32 dev_freq;
+	u32 mult, shift;
 
 	dev_freq = MLX5_CAP_GEN(mdev, device_frequency_khz);
 	if (!dev_freq) {
@@ -465,13 +466,16 @@ void mlx5_init_clock(struct mlx5_core_dev *mdev)
 		return;
 	}
 	rwlock_init(&clock->lock);
-	cc->read = read_internal_timer;
-	cc->shift = MLX5_CYCLES_SHIFT;
-	cc->mult = clocksource_khz2mult(dev_freq, cc->shift);
-	clock->nominal_c_mult = cc->mult;
-	cc->mask = CLOCKSOURCE_MASK(41);
-
-	timecounter_init(&clock->tc, ktime_to_ns(ktime_get_real()));
+	shift = MLX5_CYCLES_SHIFT;
+	mult = clocksource_khz2mult(dev_freq, shift);
+	clock->nominal_c_mult = mult;
+
+	timecounter_initialize(&clock->tc,
+			       read_internal_timer,
+			       CLOCKSOURCE_MASK(41),
+			       mult,
+			       shift,
+			       ktime_to_ns(ktime_get_real()));
 
 	/* Calculate period in seconds to call the overflow watchdog - to make
 	 * sure counter is checked at least once every wrap around.
-- 
1.9.1
