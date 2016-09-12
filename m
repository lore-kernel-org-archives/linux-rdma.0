From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 5/7] IB/mlx4: Diagnostic HW counters are not supported in slave mode
Date: Mon, 12 Sep 2016 19:16:22 +0300
Message-ID: <1473696984-6161-6-git-send-email-leon@kernel.org>
References: <1473696984-6161-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473696984-6161-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Modify the mlx4_ib_diag_counters() to avoid the following error in the
hypervisor when the slave tries to query the hardware counters in SR-IOV
mode.

mlx4_core 0000:81:00.0: Unknown command:0x30 accepted from slave:1

Fixes: 3f85f2aaabf7 ("IB/mlx4: Add diagnostic hardware counters")
Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index ac235b5..a1b7fcb 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2262,6 +2262,9 @@ static int mlx4_ib_alloc_diag_counters(struct mlx4_ib_dev *ibdev)
 	bool per_port = !!(ibdev->dev->caps.flags2 &
 		MLX4_DEV_CAP_FLAG2_DIAG_PER_PORT);

+	if (mlx4_is_slave(ibdev->dev))
+		return 0;
+
 	for (i = 0; i < MLX4_DIAG_COUNTERS_TYPES; i++) {
 		/* i == 1 means we are building port counters */
 		if (i && !per_port)
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
