From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH] IB/ipoib: fix ipoib_start_xmit()'s return type
Date: Tue, 24 Apr 2018 15:15:47 +0200
Message-ID: <20180424131549.2859-1-luc.vanoostenryck@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Alex Vesker <valex@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>, Erez Shitrit <erezsh@mellanox.com>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Feras Daoud <ferasda@mellanox.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, but the implementation in this
driver returns an 'int'.

Fix this by returning 'netdev_tx_t' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 161ba8c76..cf291f90b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1094,7 +1094,7 @@ static void unicast_arp_send(struct sk_buff *skb, struct net_device *dev,
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct rdma_netdev *rn = netdev_priv(dev);
-- 
2.17.0
