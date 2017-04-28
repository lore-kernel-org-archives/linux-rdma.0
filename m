From: Hakon Bugge <Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] IB/mlx4: Change flush logic so it adheres to the variable name
Date: Fri, 28 Apr 2017 13:06:53 +0200
Message-ID: <20170428110654.13176-2-Haakon.Bugge@oracle.com>
References: <20170428110654.13176-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170428110654.13176-1-Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hakon Bugge <Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Change and simplify the code to match the variable name. This is a
non-functional change which improves readability.

Signed-off-by: Håkon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Suggested-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
index d648453..61f63fe 100644
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -414,7 +414,7 @@ void mlx4_ib_cm_paravirt_clean(struct mlx4_ib_dev *dev, int slave)
 	struct rb_root *sl_id_map = &sriov->sl_id_map;
 	struct list_head lh;
 	struct rb_node *nd;
-	int need_flush = 1;
+	int need_flush = 0;
 	struct id_map_entry *map, *tmp_map;
 	/* cancel all delayed work queue entries */
 	INIT_LIST_HEAD(&lh);
@@ -422,13 +422,13 @@ void mlx4_ib_cm_paravirt_clean(struct mlx4_ib_dev *dev, int slave)
 	list_for_each_entry_safe(map, tmp_map, &dev->sriov.cm_list, list) {
 		if (slave < 0 || slave == map->slave_id) {
 			if (map->scheduled_delete)
-				need_flush &= !!cancel_delayed_work(&map->timeout);
+				need_flush |= !cancel_delayed_work(&map->timeout);
 		}
 	}
 
 	spin_unlock(&sriov->id_map_lock);
 
-	if (!need_flush)
+	if (need_flush)
 		flush_scheduled_work(); /* make sure all timers were flushed */
 
 	/* now, remove all leftover entries from databases*/
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
