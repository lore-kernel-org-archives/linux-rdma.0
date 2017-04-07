From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 5/9] IB/IPoIB: Combine substrings for three messages
Date: Fri, 7 Apr 2017 23:05:23 +0200
Message-ID: <8267b19e-d6a6-ac77-6b0e-e184e690db9b@users.sourceforge.net>
References: <ce4249f2-c7e7-0282-2cff-3f9c3991efa3@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <ce4249f2-c7e7-0282-2cff-3f9c3991efa3@users.sourceforge.net>
Content-Language: en-GB
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, David Ahern <dsa@cumulusnetworks.com>, Doug Ledford <dledford@redhat.com>, Erez Shitrit <erezsh@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Paolo Abeni <pabeni@redhat.com>, Roi Dayan <roid@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Sean Hefty <sean.hefty@intel.com>, Yuval Shaia <yuval.shaia@oracle.com>, Zhu Yanjun <yanjun.zhu@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 7 Apr 2017 21:06:08 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: quoted string split across lines

Thus fix affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 55581417eb43..43aef0ca53ad 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -226,8 +226,9 @@ static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
 	priv->admin_mtu = new_mtu;
 
 	if (priv->mcast_mtu < priv->admin_mtu)
-		ipoib_dbg(priv, "MTU must be smaller than the underlying "
-				"link layer MTU - 4 (%u)\n", priv->mcast_mtu);
+		ipoib_dbg(priv,
+			  "MTU must be smaller than the underlying link layer MTU - 4 (%u)\n",
+			  priv->mcast_mtu);
 
 	dev->mtu = min(priv->mcast_mtu, priv->admin_mtu);
 
@@ -480,8 +481,8 @@ int ipoib_set_mode(struct net_device *dev, const char *buf)
 	/* flush paths if we switch modes so that connections are restarted */
 	if (IPOIB_CM_SUPPORTED(dev->dev_addr) && !strcmp(buf, "connected\n")) {
 		set_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags);
-		ipoib_warn(priv, "enabling connected mode "
-			   "will cause multicast packet drops\n");
+		ipoib_warn(priv,
+			   "enabling connected mode will cause multicast packet drops\n");
 		netdev_update_features(dev);
 		dev_set_mtu(dev, ipoib_cm_max_mtu(dev));
 		rtnl_unlock();
@@ -1855,8 +1856,8 @@ void ipoib_set_umcast(struct net_device *ndev, int umcast_val)
 
 	if (umcast_val > 0) {
 		set_bit(IPOIB_FLAG_UMCAST, &priv->flags);
-		ipoib_warn(priv, "ignoring multicast groups joined directly "
-				"by userspace\n");
+		ipoib_warn(priv,
+			   "ignoring multicast groups joined directly by userspace\n");
 	} else
 		clear_bit(IPOIB_FLAG_UMCAST, &priv->flags);
 }
-- 
2.12.2
