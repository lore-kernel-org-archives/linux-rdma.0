From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH FIXES for 3.8] mlx4: Fix advertizement of wrong PF context behaviour
Date: Thu, 10 Jan 2013 17:18:35 +0200
Message-ID: <1357831115-10603-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Commit 08ff32352 "mlx4: 64-byte CQE/EQE support" introduced a regression under
which older guest VF drivers failed to load even when 64-byte EQEs/CQEs are
disabled, since the PF wrongly advertizes the new context behaviour anyway,
here's the failure:

mlx4_core 0000:00:07.0: Unknown pf context behaviour
mlx4_core 0000:00:07.0: Failed to obtain slave caps
mlx4_core: probe of 0000:00:07.0 failed with error -38

Fix that by basing this advertizement on dev->caps.flags which is the
operational capabilities being looked by the QUERY_FUNC_CAP command
wrapper, while dev_cap->flags holds the firmware capabilities.

Reported-by: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index e1bafff..9a84c75 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -380,7 +380,7 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 		}
 	}
 
-	if ((dev_cap->flags &
+	if ((dev->caps.flags &
 	    (MLX4_DEV_CAP_FLAG_64B_CQE | MLX4_DEV_CAP_FLAG_64B_EQE)) &&
 	    mlx4_is_master(dev))
 		dev->caps.function_caps |= MLX4_FUNC_CAP_64B_EQE_CQE;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
