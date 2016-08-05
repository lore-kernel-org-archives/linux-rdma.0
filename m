From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/core: Fix possible memory leak in cma_resolve_iboe_route()
Date: Fri,  5 Aug 2016 13:46:49 +0000
Message-ID: <1470404809-16658-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

'work' and 'route->path_rec' are malloced in cma_resolve_iboe_route()
and should be freed before leaving from the error handling cases,
otherwise it will cause memory leak.

Fixes: 200298326b27 ('IB/core: Validate route when we init ah')
Signed-off-by: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e6dfa1b..5f65a78 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2462,18 +2462,24 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 
 	if (addr->dev_addr.bound_dev_if) {
 		ndev = dev_get_by_index(&init_net, addr->dev_addr.bound_dev_if);
-		if (!ndev)
-			return -ENODEV;
+		if (!ndev) {
+			ret = -ENODEV;
+			goto err2;
+		}
 
 		if (ndev->flags & IFF_LOOPBACK) {
 			dev_put(ndev);
-			if (!id_priv->id.device->get_netdev)
-				return -EOPNOTSUPP;
+			if (!id_priv->id.device->get_netdev) {
+				ret = -EOPNOTSUPP;
+				goto err2;
+			}
 
 			ndev = id_priv->id.device->get_netdev(id_priv->id.device,
 							      id_priv->id.port_num);
-			if (!ndev)
-				return -ENODEV;
+			if (!ndev) {
+				ret = -ENODEV;
+				goto err2;
+			}
 		}
 
 		route->path_rec->net = &init_net;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
