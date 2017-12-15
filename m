From: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Subject: [PATCH 11/27] net/mlx4: Use timecounter_initialize interface
Date: Fri, 15 Dec 2017 13:08:26 +0530
Message-ID: <1513323522-15021-12-git-send-email-sagar.a.kamble@intel.com>
References: <1513323522-15021-1-git-send-email-sagar.a.kamble@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513323522-15021-1-git-send-email-sagar.a.kamble@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Sagar Arun Kamble <sagar.a.kamble@intel.com>, Richard Cochran <richardcochran@gmail.com>, Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

With new interface timecounter_initialize we can initialize timecounter
fields and underlying cyclecounter together. Update mlx4 timecounter
init with this new function.

Signed-off-by: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Tariq Toukan <tariqt@mellanox.com>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/mellanox/mlx4/en_clock.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_clock.c b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
index 35987b5..dd736cc 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_clock.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
@@ -264,6 +264,7 @@ void mlx4_en_init_timestamp(struct mlx4_en_dev *mdev)
 {
 	struct mlx4_dev *dev = mdev->dev;
 	unsigned long flags;
+	u32 mult, shift;
 
 	/* mlx4_en_init_timestamp is called for each netdev.
 	 * mdev->ptp_clock is common for all ports, skip initialization if
@@ -274,17 +275,17 @@ void mlx4_en_init_timestamp(struct mlx4_en_dev *mdev)
 
 	seqlock_init(&mdev->clock_lock);
 
-	memset(&mdev->clock.cc, 0, sizeof(mdev->clock.cc));
-	mdev->clock.cc.read = mlx4_en_read_clock;
-	mdev->clock.cc.mask = CLOCKSOURCE_MASK(48);
-	mdev->clock.cc.shift = freq_to_shift(dev->caps.hca_core_clock);
-	mdev->clock.cc.mult =
-		clocksource_khz2mult(1000 * dev->caps.hca_core_clock,
-				     mdev->clock.cc.shift);
+	shift = freq_to_shift(dev->caps.hca_core_clock);
+	mult = clocksource_khz2mult(1000 * dev->caps.hca_core_clock, shift);
 	mdev->nominal_c_mult = mdev->clock.cc.mult;
 
 	write_seqlock_irqsave(&mdev->clock_lock, flags);
-	timecounter_init(&mdev->clock, ktime_to_ns(ktime_get_real()));
+	timecounter_initialize(&mdev->clock,
+			       mlx4_en_read_clock,
+			       CLOCKSOURCE_MASK(48),
+			       mult,
+			       shift,
+			       ktime_to_ns(ktime_get_real()));
 	write_sequnlock_irqrestore(&mdev->clock_lock, flags);
 
 	/* Configure the PHC */
-- 
1.9.1
