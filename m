From: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Subject: [PATCH 23/27] net/mlx4: Use timecounter_reset interface
Date: Fri, 15 Dec 2017 13:08:38 +0530
Message-ID: <1513323522-15021-24-git-send-email-sagar.a.kamble@intel.com>
References: <1513323522-15021-1-git-send-email-sagar.a.kamble@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513323522-15021-1-git-send-email-sagar.a.kamble@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Sagar Arun Kamble <sagar.a.kamble@intel.com>, Richard Cochran <richardcochran@gmail.com>, Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

With new interface timecounter_reset we can update the start time for
timecounter. Update mlx4_en_phc_settime with this new function.

Signed-off-by: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Tariq Toukan <tariqt@mellanox.com>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/mellanox/mlx4/en_clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_clock.c b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
index dd736cc..bfed4ac 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_clock.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_clock.c
@@ -207,7 +207,7 @@ static int mlx4_en_phc_settime(struct ptp_clock_info *ptp,
 
 	/* reset the timecounter */
 	write_seqlock_irqsave(&mdev->clock_lock, flags);
-	timecounter_init(&mdev->clock, ns);
+	timecounter_reset(&mdev->clock, ns);
 	write_sequnlock_irqrestore(&mdev->clock_lock, flags);
 
 	return 0;
-- 
1.9.1
