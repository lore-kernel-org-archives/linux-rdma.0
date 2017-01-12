From: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/1] IB/ipoib: function interface change
Date: Thu, 12 Jan 2017 02:39:01 -0500
Message-ID: <1484206741-15218-1-git-send-email-yanjun.zhu@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shan.hai-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The ipoib_ib_dev_down/ipoib_ib_dev_stop return zero unconditionally
and the callers never check the returned values,
change the return type to void and remove the redundant return values.

Reviewed-by: Shan Hai <shan.hai-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h    | 4 ++--
 drivers/infiniband/ulp/ipoib/ipoib_ib.c | 8 ++------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index da12717..949cb09 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -501,8 +501,8 @@ void ipoib_ib_dev_cleanup(struct net_device *dev);
 
 int ipoib_ib_dev_open(struct net_device *dev);
 int ipoib_ib_dev_up(struct net_device *dev);
-int ipoib_ib_dev_down(struct net_device *dev);
-int ipoib_ib_dev_stop(struct net_device *dev);
+void ipoib_ib_dev_down(struct net_device *dev);
+void ipoib_ib_dev_stop(struct net_device *dev);
 void ipoib_pkey_dev_check_presence(struct net_device *dev);
 
 int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 5038f9d..6f443f7 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -771,7 +771,7 @@ int ipoib_ib_dev_up(struct net_device *dev)
 	return ipoib_mcast_start_thread(dev);
 }
 
-int ipoib_ib_dev_down(struct net_device *dev)
+void ipoib_ib_dev_down(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
@@ -784,8 +784,6 @@ int ipoib_ib_dev_down(struct net_device *dev)
 	ipoib_mcast_dev_flush(dev);
 
 	ipoib_flush_paths(dev);
-
-	return 0;
 }
 
 static int recvs_pending(struct net_device *dev)
@@ -840,7 +838,7 @@ void ipoib_drain_cq(struct net_device *dev)
 	local_bh_enable();
 }
 
-int ipoib_ib_dev_stop(struct net_device *dev)
+void ipoib_ib_dev_stop(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ib_qp_attr qp_attr;
@@ -913,8 +911,6 @@ int ipoib_ib_dev_stop(struct net_device *dev)
 	ipoib_flush_ah(dev);
 
 	ib_req_notify_cq(priv->recv_cq, IB_CQ_NEXT_COMP);
-
-	return 0;
 }
 
 int ipoib_ib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
