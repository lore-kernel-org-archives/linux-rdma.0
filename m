From: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] IB/mlx5: give back valid speed/width even without plugged in SFP module
Date: Fri, 27 Oct 2017 14:30:11 +0200
Message-ID: <20171027123011.10454-1-tbogendoerfer@suse.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If there is no SFP module plugged into a port of mlx5 cards
'cat /sys/class/infniband/mlx5_X/ports/1/rate' returns Invalid argument.
This causes tools like 'ibstat' to malfunction. This change adjusts mlx5
to all other RoCE/iWarp drivers, which always return valid speed/width.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 260f8be1d0ed..4388618e3434 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -246,7 +246,10 @@ static int translate_eth_proto_oper(u32 eth_proto_oper, u8 *active_speed,
 		*active_speed = IB_SPEED_EDR;
 		break;
 	default:
-		return -EINVAL;
+		/* Unknown */
+		*active_width = IB_WIDTH_1X;
+		*active_speed = IB_SPEED_SDR;
+		break;
 	}
 
 	return 0;
-- 
2.12.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
