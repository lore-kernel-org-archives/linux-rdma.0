From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.17 3/3] IB/ipoib: Avoid flushing the workqueue from worker context
Date: Tue,  8 Jul 2014 12:45:12 +0300
Message-ID: <1404812712-26187-4-git-send-email-ogerlitz@mellanox.com>
References: <1404812712-26187-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404812712-26187-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The error flow of ipoib_ib_dev_open() invokes ipoib_ib_dev_stop() with
work-queue flushing enabled which would turn into deadlock if the open
procedure itself was called by a worker thread.

Fix that by adding a flush enabled flag to ipoib_ib_dev_open() and set
it accordingly from the locations where such a call is made.

The call trace was the following:

 [<ffffffff81095bc4>] ? flush_workqueue+0x54/0x80
 [<ffffffffa056c657>] ? ipoib_ib_dev_stop+0x447/0x650 [ib_ipoib]
 [<ffffffffa056cc34>] ? ipoib_ib_dev_open+0x284/0x430 [ib_ipoib]
 [<ffffffffa05674a8>] ? ipoib_open+0x78/0x1d0 [ib_ipoib]
 [<ffffffffa05697b8>] ? ipoib_pkey_open+0x38/0x40 [ib_ipoib]
 [<ffffffffa056cf3c>] ? __ipoib_ib_dev_flush+0x15c/0x2c0 [ib_ipoib]
 [<ffffffffa056ce56>] ? __ipoib_ib_dev_flush+0x76/0x2c0 [ib_ipoib]
 [<ffffffffa056d0a0>] ? ipoib_ib_dev_flush_heavy+0x0/0x20 [ib_ipoib]
 [<ffffffffa056d0ba>] ? ipoib_ib_dev_flush_heavy+0x1a/0x20 [ib_ipoib]
 [<ffffffff81094d20>] ? worker_thread+0x170/0x2a0
 [<ffffffff8109b2a0>] ? autoremove_wake_function+0x0/0x40

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib.h      |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c   |    8 ++++----
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 683d23a..3edce61 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -471,7 +471,7 @@ void ipoib_ib_dev_flush_heavy(struct work_struct *work);
 void ipoib_pkey_event(struct work_struct *work);
 void ipoib_ib_dev_cleanup(struct net_device *dev);
 
-int ipoib_ib_dev_open(struct net_device *dev);
+int ipoib_ib_dev_open(struct net_device *dev, int flush);
 int ipoib_ib_dev_up(struct net_device *dev);
 int ipoib_ib_dev_down(struct net_device *dev, int flush);
 int ipoib_ib_dev_stop(struct net_device *dev, int flush);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index be8f971..9dcb2c9 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -664,7 +664,7 @@ static void ipoib_ib_tx_timer_func(unsigned long ctx)
 	drain_tx_cq((struct net_device *)ctx);
 }
 
-int ipoib_ib_dev_open(struct net_device *dev)
+int ipoib_ib_dev_open(struct net_device *dev, int flush)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	int ret;
@@ -705,7 +705,7 @@ int ipoib_ib_dev_open(struct net_device *dev)
 dev_stop:
 	if (!test_and_set_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
 		napi_enable(&priv->napi);
-	ipoib_ib_dev_stop(dev, 1);
+	ipoib_ib_dev_stop(dev, flush);
 	return -1;
 }
 
@@ -916,7 +916,7 @@ int ipoib_ib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 		    (unsigned long) dev);
 
 	if (dev->flags & IFF_UP) {
-		if (ipoib_ib_dev_open(dev)) {
+		if (ipoib_ib_dev_open(dev, 1)) {
 			ipoib_transport_dev_cleanup(dev);
 			return -ENODEV;
 		}
@@ -1033,7 +1033,7 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
 
 	if (level == IPOIB_FLUSH_HEAVY) {
 		ipoib_ib_dev_stop(dev, 0);
-		ipoib_ib_dev_open(dev);
+		ipoib_ib_dev_open(dev, 0);
 	}
 
 	/*
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 35acbd4..1bf994a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -114,7 +114,7 @@ int ipoib_open(struct net_device *dev)
 	if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags))
 		return 0;
 
-	if (ipoib_ib_dev_open(dev))
+	if (ipoib_ib_dev_open(dev, 1))
 		goto err_disable;
 
 	if (ipoib_ib_dev_up(dev))
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
