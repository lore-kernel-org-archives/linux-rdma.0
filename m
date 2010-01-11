From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] ib/ipoib: remove TX moderation from the ethtool related code
Date: Mon, 11 Jan 2010 11:20:13 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1001111118260.27317@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

As of commit f56bcd8 "IPoIB: Use separate CQ for UD send completions",
there are no TX interrupts at the main code path. Change the ethtool
related code to comply with this, such the users will not be misleaded
to assume they can control TX interrupt moderation. Was pointed by
Alex Vainman <alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org>

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index e9795f6..d10b4ec 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -55,9 +55,7 @@ static int ipoib_get_coalesce(struct net_device *dev,
 	struct ipoib_dev_priv *priv = netdev_priv(dev);

 	coal->rx_coalesce_usecs = priv->ethtool.coalesce_usecs;
-	coal->tx_coalesce_usecs = priv->ethtool.coalesce_usecs;
 	coal->rx_max_coalesced_frames = priv->ethtool.max_coalesced_frames;
-	coal->tx_max_coalesced_frames = priv->ethtool.max_coalesced_frames;

 	return 0;
 }
@@ -69,10 +67,8 @@ static int ipoib_set_coalesce(struct net_device *dev,
 	int ret;

 	/*
-	 * Since IPoIB uses a single CQ for both rx and tx, we assume
-	 * that rx params dictate the configuration.  These values are
-	 * saved in the private data and returned when ipoib_get_coalesce()
-	 * is called.
+	 * These values are saved in the private data and returned
+	 * when ipoib_get_coalesce() is called
 	 */
 	if (coal->rx_coalesce_usecs       > 0xffff ||
 	    coal->rx_max_coalesced_frames > 0xffff)
@@ -85,8 +81,6 @@ static int ipoib_set_coalesce(struct net_device *dev,
 		return ret;
 	}

-	coal->tx_coalesce_usecs       = coal->rx_coalesce_usecs;
-	coal->tx_max_coalesced_frames = coal->rx_max_coalesced_frames;
 	priv->ethtool.coalesce_usecs       = coal->rx_coalesce_usecs;
 	priv->ethtool.max_coalesced_frames = coal->rx_max_coalesced_frames;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
