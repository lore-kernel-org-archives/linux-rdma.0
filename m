From: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/1] IB/ipoib: remove the unnecessary memory free
Date: Fri, 10 Feb 2017 01:48:42 -0500
Message-ID: <1486709322-19362-1-git-send-email-yanjun.zhu@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In the function ipoib_cm_nonsrq_init_rx, the memory is not
allocated successfully. It is not necessary to free it.

CC: Joe Jin <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
CC: Junxiao Bi <junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 096c4f6..fd6f97e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -363,7 +363,7 @@ static int ipoib_cm_nonsrq_init_rx(struct net_device *dev, struct ib_cm_id *cm_i
 	t = kmalloc(sizeof *t, GFP_KERNEL);
 	if (!t) {
 		ret = -ENOMEM;
-		goto err_free;
+		goto err_free_1;
 	}
 
 	ipoib_cm_init_rx_wr(dev, &t->wr, t->sge);
@@ -410,6 +410,8 @@ static int ipoib_cm_nonsrq_init_rx(struct net_device *dev, struct ib_cm_id *cm_i
 
 err_free:
 	kfree(t);
+
+err_free_1:
 	ipoib_cm_free_rx_ring(dev, rx->rx_ring);
 
 	return ret;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
