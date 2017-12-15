From: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Subject: [PATCH 24/27] net/mlx5: Use timecounter_reset interface
Date: Fri, 15 Dec 2017 13:08:39 +0530
Message-ID: <1513323522-15021-25-git-send-email-sagar.a.kamble@intel.com>
References: <1513323522-15021-1-git-send-email-sagar.a.kamble@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513323522-15021-1-git-send-email-sagar.a.kamble@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Sagar Arun Kamble <sagar.a.kamble@intel.com>, Richard Cochran <richardcochran@gmail.com>, Saeed Mahameed <saeedm@mellanox.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Eugenia Emantayev <eugenia@mellanox.com>, Eitan Rabin <rabin@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

With new interface timecounter_reset we can update the start time for
timecounter. Update mlx5_ptp_settime with this new function.

Signed-off-by: Sagar Arun Kamble <sagar.a.kamble@intel.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Matan Barak <matanb@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Eugenia Emantayev <eugenia@mellanox.com>
Cc: Eitan Rabin <rabin@mellanox.com>
Cc: Feras Daoud <ferasda@mellanox.com>
Cc: Tariq Toukan <tariqt@mellanox.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 071f78a..e490522 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -122,7 +122,7 @@ static int mlx5_ptp_settime(struct ptp_clock_info *ptp,
 	unsigned long flags;
 
 	write_lock_irqsave(&clock->lock, flags);
-	timecounter_init(&clock->tc, ns);
+	timecounter_reset(&clock->tc, ns);
 	write_unlock_irqrestore(&clock->lock, flags);
 
 	return 0;
-- 
1.9.1
