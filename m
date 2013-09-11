From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fixes-3.12 06/15] IB/mlx5: Avoid async events on invalid port number
Date: Wed, 11 Sep 2013 16:35:27 +0300
Message-ID: <1378906536-6925-7-git-send-email-ogerlitz@mellanox.com>
References: <1378906536-6925-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378906536-6925-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, elic-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

On a single ported Connect-IB, its possible for the firmware to issue events on
the non-existing 2nd port. Make sure to ignore events generated for such ports.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 3f831de..e59761e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1006,6 +1006,11 @@ static void mlx5_ib_event(struct mlx5_core_dev *dev, enum mlx5_dev_event event,
 	ibev.device	      = &ibdev->ib_dev;
 	ibev.element.port_num = port;
 
+	if (port < 1 || port > ibdev->num_ports) {
+		mlx5_ib_warn(ibdev, "warning: event on port %d\n", port);
+		return;
+	}
+
 	if (ibdev->ib_active)
 		ib_dispatch_event(&ibev);
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
