From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/9] ib/mlx4: use GID change event on IBoE code
Date: Wed, 15 Jun 2011 17:40:29 +0300
Message-ID: <alpine.LRH.2.00.1106151739530.15844@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1106151733410.15844-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As IBoE doesn't use LIDs, use the GID change event to
update the IB core cache for addition/deletion of GIDs.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/infiniband/hw/mlx4/main.c
===================================================================
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -816,7 +816,7 @@ static void update_gids_task(struct work
 		memcpy(gw->dev->iboe.gid_table[gw->port - 1], gw->gids, sizeof gw->gids);
 		event.device = &gw->dev->ib_dev;
 		event.element.port_num = gw->port;
-		event.event    = IB_EVENT_LID_CHANGE;
+		event.event    = IB_EVENT_GID_CHANGE;
 		ib_dispatch_event(&event);
 	}


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
