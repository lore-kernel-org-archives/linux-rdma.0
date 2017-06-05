From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] IB/rxe: Protect call to get_link_ksettings with rtnl lock
Date: Mon,  5 Jun 2017 11:12:41 +0300
Message-ID: <20170605081241.17920-3-yuval.shaia@oracle.com>
References: <20170605081241.17920-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170605081241.17920-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The function __ethtool_get_link_ksettings requieres rtnl lock.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index ffd3888..af02478 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -97,7 +97,9 @@ static int rxe_query_port(struct ib_device *dev,
 	if (rxe->ndev->ethtool_ops->get_link_ksettings) {
 		struct ethtool_link_ksettings ks;
 
+		rtnl_lock();
 		rc = rxe->ndev->ethtool_ops->get_link_ksettings(rxe->ndev, &ks);
+		rtnl_unlock();
 		speed = ks.base.speed;
 	} else if (rxe->ndev->ethtool_ops->get_settings) {
 		struct ethtool_cmd cmd;
-- 
2.9.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
