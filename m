From: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: [PATCH V2] IB/ipoib: Do not turn on carrier  to a non active port
Date: Mon, 21 Sep 2009 12:42:16 +0300
Message-ID: <4AB74A78.2080108@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vlad <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, OpenFabrics General <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch fixes https://bugs.openfabrics.org/show_bug.cgi?id=1726
Multicast join can succeed even if IB port is down. This happens when OpenSM
runs on the same port with the requesting port. IPoIB on the other hand, calls
netif_carrier_on() when join succeeded without caring about the state of
the IB port. The result is an IPoIB interface in RUNNING state but without
active IB port to support it. If a bonding interface uses this IPoIB interface
as a slave it might not detect that this slave is almost useless and failover
functionality will be damaged.
The fix  checks the state of the IB port in the carrier_task before
calling netif_carrier_on().

Signed-off-by: Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 25874fc..9ace51d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -362,12 +362,19 @@ void ipoib_mcast_carrier_on_task(struct work_struct *work)
 {
 	struct ipoib_dev_priv *priv = container_of(work, struct ipoib_dev_priv,
 						   carrier_on_task);
+	struct ib_port_attr attr;
 
 	/*
 	 * Take rtnl_lock to avoid racing with ipoib_stop() and
 	 * turning the carrier back on while a device is being
 	 * removed.
 	 */
+
+	if (ib_query_port(priv->ca, priv->port, &attr) ||
+		attr.state != IB_PORT_ACTIVE) {
+		ipoib_dbg(priv, "wait with carrier until IB port is active\n");
+		return;
+	}
 	rtnl_lock();
 	netif_carrier_on(priv->dev);
 	rtnl_unlock();
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
