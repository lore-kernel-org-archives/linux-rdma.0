From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 09/12] IB/mlx5: Fix fatal error dispatching
Date: Thu, 27 Oct 2016 16:36:44 +0300
Message-ID: <1477575407-20562-10-git-send-email-leon@kernel.org>
References: <1477575407-20562-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477575407-20562-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When an internal error condition is detected, make sure to set the
device inactive after dispatching the event so ULPs can get a
notification of this event.

Fixes: e126ba97dba9 ('mlx5: Add driver for Mellanox Connect-IB adapters')
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mohamad Haj Yahia <mohamad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c6ea25d..88ff2e3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2312,14 +2312,14 @@ static void mlx5_ib_event(struct mlx5_core_dev *dev, void *context,
 {
 	struct mlx5_ib_dev *ibdev = (struct mlx5_ib_dev *)context;
 	struct ib_event ibev;
-
+	bool fatal = false;
 	u8 port = 0;
 
 	switch (event) {
 	case MLX5_DEV_EVENT_SYS_ERROR:
-		ibdev->ib_active = false;
 		ibev.event = IB_EVENT_DEVICE_FATAL;
 		mlx5_ib_handle_internal_error(ibdev);
+		fatal = true;
 		break;
 
 	case MLX5_DEV_EVENT_PORT_UP:
@@ -2371,6 +2371,9 @@ static void mlx5_ib_event(struct mlx5_core_dev *dev, void *context,
 
 	if (ibdev->ib_active)
 		ib_dispatch_event(&ibev);
+
+	if (fatal)
+		ibdev->ib_active = false;
 }
 
 static void get_ext_port_caps(struct mlx5_ib_dev *dev)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
