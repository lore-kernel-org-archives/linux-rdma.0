From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/6] IB/ipoib: Update broadcast record values after each successful join request
Date: Thu,  2 Apr 2015 13:39:01 +0300
Message-ID: <1427971145-26943-3-git-send-email-ogerlitz@mellanox.com>
References: <1427971145-26943-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427971145-26943-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Update the cached broadcast record in the priv object after every new
join of this broadcast domain group.

These values are needed for the port configuration (MTU size) and to
all the new multicast (non-broadcast) join requests initial parameters.

For example, SM starts with 2K MTU for all the fabric, and after that it
restarts (or handover to new SM) with new port configuration of 4K MTU.
Without using the new values, the driver will keep its old configuration
of 2K and will not apply the new configuration of 4K.

Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 3203ebe..c83c958 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -226,7 +226,23 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 			spin_unlock_irq(&priv->lock);
 			return -EAGAIN;
 		}
-		priv->mcast_mtu = IPOIB_UD_MTU(ib_mtu_enum_to_int(priv->broadcast->mcmember.mtu));
+		/*update priv member according to the new mcast*/
+		priv->broadcast->mcmember.qkey = mcmember->qkey;
+		priv->broadcast->mcmember.mtu = mcmember->mtu;
+		priv->broadcast->mcmember.traffic_class = mcmember->traffic_class;
+		priv->broadcast->mcmember.rate = mcmember->rate;
+		priv->broadcast->mcmember.sl = mcmember->sl;
+		priv->broadcast->mcmember.flow_label = mcmember->flow_label;
+		priv->broadcast->mcmember.hop_limit = mcmember->hop_limit;
+		/* assume if the admin and the mcast are the same both can be changed */
+		if (priv->mcast_mtu == priv->admin_mtu)
+			priv->admin_mtu =
+			priv->mcast_mtu =
+			IPOIB_UD_MTU(ib_mtu_enum_to_int(priv->broadcast->mcmember.mtu));
+		else
+			priv->mcast_mtu =
+			IPOIB_UD_MTU(ib_mtu_enum_to_int(priv->broadcast->mcmember.mtu));
+
 		priv->qkey = be32_to_cpu(priv->broadcast->mcmember.qkey);
 		spin_unlock_irq(&priv->lock);
 		priv->tx_wr.wr.ud.remote_qkey = priv->qkey;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
