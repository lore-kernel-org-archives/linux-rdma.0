From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 6/6] IB/mlx4: bug fix for mlx4_ib_add error flow
Date: Thu, 10 May 2012 23:28:09 +0300
Message-ID: <1336681689-16668-7-git-send-email-ogerlitz@mellanox.com>
References: <1336681689-16668-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336681689-16668-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Need to use a different looping index for mlx4_counter_alloc()
and for device_create_file() iterations: the mlx4_counter_alloc()
loop index is used in the error flow to de-allocate counters.

If the same loop index is used for device_create_file() and, say,
the device_create_file() loop fails on the first iteration,
the allocated counters will not be de-allocated.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index bdf7691..c02c75c 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1161,7 +1161,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 {
 	struct mlx4_ib_dev *ibdev;
 	int num_ports = 0;
-	int i;
+	int i, j;
 	int err;
 	struct mlx4_ib_iboe *iboe;
 
@@ -1324,9 +1324,9 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 			goto err_reg;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(mlx4_class_attributes); ++i) {
+	for (j = 0; j < ARRAY_SIZE(mlx4_class_attributes); ++j) {
 		if (device_create_file(&ibdev->ib_dev.dev,
-				       mlx4_class_attributes[i]))
+				       mlx4_class_attributes[j]))
 			goto err_notif;
 	}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
