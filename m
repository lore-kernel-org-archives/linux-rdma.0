From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/9] IB/IPoIB: Use kcalloc() in two functions
Date: Fri, 7 Apr 2017 22:57:07 +0200
Message-ID: <b6829c25-7c8b-858d-5cad-0322d6536f44@users.sourceforge.net>
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
Date: Fri, 7 Apr 2017 17:43:51 +0200

Multiplications for the size determination of memory allocations
indicated that array data structures should be processed.
Thus use the corresponding function "kcalloc".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index d1d3fb7a6127..3d3e49fb15b7 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1484,7 +1484,7 @@ static int ipoib_neigh_hash_init(struct ipoib_dev_priv *priv)
 		return -ENOMEM;
 	set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
 	size = roundup_pow_of_two(arp_tbl.gc_thresh3);
-	buckets = kzalloc(size * sizeof(*buckets), GFP_KERNEL);
+	buckets = kcalloc(size, sizeof(*buckets), GFP_KERNEL);
 	if (!buckets) {
 		kfree(htbl);
 		return -ENOMEM;
@@ -1628,7 +1628,7 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 
 	/* Allocate RX/TX "rings" to hold queued skbs */
-	priv->rx_ring =	kzalloc(ipoib_recvq_size * sizeof *priv->rx_ring,
+	priv->rx_ring =	kcalloc(ipoib_recvq_size, sizeof(*priv->rx_ring),
 				GFP_KERNEL);
 	if (!priv->rx_ring)
 		goto out;
-- 
2.12.2
