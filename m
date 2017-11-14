From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 27/31] IB/cm: Fix honor address handle attribute init error
Date: Tue, 14 Nov 2017 14:52:14 +0200
Message-ID: <20171114125218.20477-28-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

cm_init_av_by_path depends on ib_init_ah_from_path to initialize ah
attribute and ib_init_ah_from_path() can fail, such error should not
be ignored.

This patch honors ah attribute init error.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 9a60d21ed0c3..d12c50ee2b89 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -494,8 +494,11 @@ static int cm_init_av_by_path(struct sa_path_rec *path, struct cm_av *av,
 		return ret;
 
 	av->port = port;
-	ib_init_ah_from_path(cm_dev->ib_device, port->port_num, path,
-			     &av->ah_attr);
+	ret = ib_init_ah_from_path(cm_dev->ib_device, port->port_num, path,
+				   &av->ah_attr);
+	if (ret)
+		return ret;
+
 	av->timeout = path->packet_life_time + 1;
 
 	spin_lock_irqsave(&cm.lock, flags);
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
