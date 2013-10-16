From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH net-next 1/7] IB/ipoib: Fix crash in dev_open error flow
Date: Wed, 16 Oct 2013 17:37:47 +0300
Message-ID: <1381934273-29683-2-git-send-email-ogerlitz@mellanox.com>
References: <1381934273-29683-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381934273-29683-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

If napi has never been enabled when calling ipoib_ib_dev_stop,
a kernel crash occurs, because the verbs layer completion handler
(ipoib_ib_completion) calls napi_schedule unconditionally.

If the napi structure passed in the napi_schedule call has not
been initialized, napi will crash.

The cleanest solution is to simply enable napi before calling
ipoib_ib_dev_stop in the dev_open error flow. (dev_stop then
immediately disables napi).

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 196b1d1..c14f949 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -685,15 +685,13 @@ int ipoib_ib_dev_open(struct net_device *dev)
 	ret = ipoib_ib_post_receives(dev);
 	if (ret) {
 		ipoib_warn(priv, "ipoib_ib_post_receives returned %d\n", ret);
-		ipoib_ib_dev_stop(dev, 1);
-		return -1;
+		goto dev_stop;
 	}
 
 	ret = ipoib_cm_dev_open(dev);
 	if (ret) {
 		ipoib_warn(priv, "ipoib_cm_dev_open returned %d\n", ret);
-		ipoib_ib_dev_stop(dev, 1);
-		return -1;
+		goto dev_stop;
 	}
 
 	clear_bit(IPOIB_STOP_REAPER, &priv->flags);
@@ -704,6 +702,11 @@ int ipoib_ib_dev_open(struct net_device *dev)
 		napi_enable(&priv->napi);
 
 	return 0;
+dev_stop:
+	if (!test_and_set_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
+		napi_enable(&priv->napi);
+	ipoib_ib_dev_stop(dev, 1);
+	return -1;
 }
 
 static void ipoib_pkey_dev_check_presence(struct net_device *dev)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
