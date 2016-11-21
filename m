From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/3] IPoIB: Avoid reading an uninitialized member variable
Date: Mon, 21 Nov 2016 10:21:41 -0800
Message-ID: <fd4a2913-545e-bf2f-e352-a47fd50a954f@sandisk.com>
References: <94eb11fc-b558-b994-c933-da784caefc53@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <94eb11fc-b558-b994-c933-da784caefc53-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch avoids that Coverity reports the following:

    Using uninitialized value port_attr.state when calling printk

Fixes: commit 94232d9ce817 ("IPoIB: Start multicast join process only on active ports")
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 1909dd2..fddff40 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -575,8 +575,11 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags))
 		return;
 
-	if (ib_query_port(priv->ca, priv->port, &port_attr) ||
-	    port_attr.state != IB_PORT_ACTIVE) {
+	if (ib_query_port(priv->ca, priv->port, &port_attr)) {
+		ipoib_dbg(priv, "ib_query_port() failed\n");
+		return;
+	}
+	if (port_attr.state != IB_PORT_ACTIVE) {
 		ipoib_dbg(priv, "port state is not ACTIVE (state = %d) suspending join task\n",
 			  port_attr.state);
 		return;
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
