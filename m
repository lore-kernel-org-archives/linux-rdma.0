From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 04/10] IB/cm: cm_init_av_by_path should find a GID by its netdevice
Date: Fri,  7 Aug 2015 16:00:57 +0300
Message-ID: <1438952463-23707-5-git-send-email-matanb@mellanox.com>
References: <1438952463-23707-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438952463-23707-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Previously, the CM has searched the cache for any sgid_index whose
GID matches the path's GID. Since the path record stores the net
device, the CM should now search only for GIDs which originated from
this net device.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 5fdbc55..6fc2de1 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -359,17 +359,21 @@ static int cm_init_av_by_path(struct ib_sa_path_rec *path, struct cm_av *av)
 	unsigned long flags;
 	int ret;
 	u8 p;
+	struct net_device *ndev = ib_get_ndev_from_path(path);
 
 	read_lock_irqsave(&cm.device_lock, flags);
 	list_for_each_entry(cm_dev, &cm.device_list, list) {
 		if (!ib_find_cached_gid(cm_dev->ib_device, &path->sgid,
-					NULL, &p, NULL)) {
+					ndev, &p, NULL)) {
 			port = cm_dev->port[p-1];
 			break;
 		}
 	}
 	read_unlock_irqrestore(&cm.device_lock, flags);
 
+	if (ndev)
+		dev_put(ndev);
+
 	if (!port)
 		return -EINVAL;
 
@@ -382,7 +386,6 @@ static int cm_init_av_by_path(struct ib_sa_path_rec *path, struct cm_av *av)
 	ib_init_ah_from_path(cm_dev->ib_device, port->port_num, path,
 			     &av->ah_attr);
 	av->timeout = path->packet_life_time + 1;
-	memcpy(av->smac, path->smac, sizeof(av->smac));
 
 	av->valid = 1;
 	return 0;
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
