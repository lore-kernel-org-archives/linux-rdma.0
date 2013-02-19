From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.9 3/3] IB/ipoib: Don't attempt to release resources on error flow
Date: Tue, 19 Feb 2013 17:40:24 +0200
Message-ID: <1361288424-8376-4-git-send-email-ogerlitz@mellanox.com>
References: <1361288424-8376-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361288424-8376-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Itai Garbi <igarbi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Itai Garbi <igarbi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

If the ipoib client info isn't found on the _remove_one callback, we must
not attempt to scan the returned null list, found by Coverity.

Signed-off-by: Itai Garbi <igarbi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index e9ee07b..2548ef8 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1693,6 +1693,8 @@ static void ipoib_remove_one(struct ib_device *device)
 		return;
 
 	dev_list = ib_get_client_data(device, &ipoib_client);
+	if (!dev_list)
+		return;
 
 	list_for_each_entry_safe(priv, tmp, dev_list, list) {
 		ib_unregister_event_handler(&priv->event_handler);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
