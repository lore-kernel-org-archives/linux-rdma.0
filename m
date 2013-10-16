From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH net-next 7/7] IB/ipoib: Start multicast join process only on active ports
Date: Wed, 16 Oct 2013 17:37:53 +0300
Message-ID: <1381934273-29683-8-git-send-email-ogerlitz@mellanox.com>
References: <1381934273-29683-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381934273-29683-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The driver starts the mcast_join task whenever the netdev interface is
UP without relation to the underlying IB port state.

Till the port state is ACTIVE all the join requests are irrelevant, and the
IB core returns -EINVAL. So the user will see errors such as: "multicast join
failed for ff12:401b:... , status -22".

Instead, have ipoib_mcast_join_task() to return when the port is not active.

It will be called again when the port state is changed and the low-level driver
triggers the IB_EVENT_PORT_ACTIVE event or the IB_EVENT_CLIENT_REREGISTER event.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 780a2a0..d4e0057 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -518,10 +518,18 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	struct ipoib_dev_priv *priv =
 		container_of(work, struct ipoib_dev_priv, mcast_task.work);
 	struct net_device *dev = priv->dev;
+	struct ib_port_attr port_attr;
 
 	if (!test_bit(IPOIB_MCAST_RUN, &priv->flags))
 		return;
 
+	if (ib_query_port(priv->ca, priv->port, &port_attr) ||
+	    port_attr.state != IB_PORT_ACTIVE) {
+		ipoib_dbg(priv, "port state is not ACTIVE (state = %d) suspending join task\n",
+			  port_attr.state);
+		return;
+	}
+
 	if (ib_query_gid(priv->ca, priv->port, 0, &priv->local_gid))
 		ipoib_warn(priv, "ib_query_gid() failed\n");
 	else
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
