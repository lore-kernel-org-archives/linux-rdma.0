From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 02/10] IB/mlx5: Return PORT_ERR in Active to Initializing tranisition
Date: Sat,  4 Jun 2016 15:15:29 +0300
Message-ID: <1465042537-26129-3-git-send-email-leon@kernel.org>
References: <1465042537-26129-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465042537-26129-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

FW port-change events are fired on Active <-> non Active port state
transitions only.
When the port state changes from Active to Initializing (Active ->
Down -> Initializing), a single event is fired.
The HCA transitions from Down to Initializing unless prevented from
doing so, hence the driver should also propagate events when the port
state is Initializing to consumers so they'll be aware that the port
is no longer Active and act accordingly.

Fixes: e126ba97dba9e ('mlx5: Add driver for Mellanox Connect-IB...')
Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 83047ef..94a8f91 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1869,14 +1869,11 @@ static void mlx5_ib_event(struct mlx5_core_dev *dev, void *context,
 		break;
 
 	case MLX5_DEV_EVENT_PORT_DOWN:
+	case MLX5_DEV_EVENT_PORT_INITIALIZED:
 		ibev.event = IB_EVENT_PORT_ERR;
 		port = (u8)param;
 		break;
 
-	case MLX5_DEV_EVENT_PORT_INITIALIZED:
-		/* not used by ULPs */
-		return;
-
 	case MLX5_DEV_EVENT_LID_CHANGE:
 		ibev.event = IB_EVENT_LID_CHANGE;
 		port = (u8)param;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
