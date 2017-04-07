From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/9] IB/IPoIB: Enclose six expressions for the sizeof operator
 by parentheses
Date: Fri, 7 Apr 2017 23:01:57 +0200
Message-ID: <acd5a60c-cf71-e802-94c7-8b85ebe020ef@users.sourceforge.net>
References: <ce4249f2-c7e7-0282-2cff-3f9c3991efa3@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <ce4249f2-c7e7-0282-2cff-3f9c3991efa3@users.sourceforge.net>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, David Ahern <dsa@cumulusnetworks.com>, Doug Ledford <dledford@redhat.com>, Erez Shitrit <erezsh@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leon@kernel.org>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Paolo Abeni <pabeni@redhat.com>, Roi Dayan <roid@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Sean Hefty <sean.hefty@intel.com>, Yuval Shaia <yuval.shaia@oracle.com>, Zhu Yanjun <yanjun.zhu@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 7 Apr 2017 19:54:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" pointed information out like the following.

WARNING: sizeof *… should be sizeof(*…)

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index c5024c6d38e7..446af4ec3d86 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -581,7 +581,7 @@ struct ipoib_path_iter *ipoib_path_iter_init(struct net_device *dev)
 {
 	struct ipoib_path_iter *iter;
 
-	iter = kmalloc(sizeof *iter, GFP_KERNEL);
+	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
 	if (!iter)
 		return NULL;
 
@@ -864,7 +864,7 @@ static struct ipoib_path *path_rec_create(struct net_device *dev, void *gid)
 	if (!priv->broadcast)
 		return NULL;
 
-	path = kzalloc(sizeof *path, GFP_ATOMIC);
+	path = kzalloc(sizeof(*path), GFP_ATOMIC);
 	if (!path)
 		return NULL;
 
@@ -1161,7 +1161,7 @@ static int ipoib_hard_header(struct sk_buff *skb,
 {
 	struct ipoib_header *header;
 
-	header = (struct ipoib_header *) skb_push(skb, sizeof *header);
+	header = (struct ipoib_header *)skb_push(skb, sizeof(*header));
 
 	header->proto = htons(type);
 	header->reserved = 0;
@@ -1329,7 +1329,7 @@ static struct ipoib_neigh *ipoib_neigh_ctor(u8 *daddr,
 {
 	struct ipoib_neigh *neigh;
 
-	neigh = kzalloc(sizeof *neigh, GFP_ATOMIC);
+	neigh = kzalloc(sizeof(*neigh), GFP_ATOMIC);
 	if (!neigh)
 		return NULL;
 
@@ -1633,7 +1633,7 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 	if (!priv->rx_ring)
 		goto out;
 
-	priv->tx_ring = vzalloc(ipoib_sendq_size * sizeof *priv->tx_ring);
+	priv->tx_ring = vzalloc(ipoib_sendq_size * sizeof(*priv->tx_ring));
 	if (!priv->tx_ring)
 		goto out_rx_ring_cleanup;
 
@@ -2132,7 +2132,7 @@ static void ipoib_add_one(struct ib_device *device)
 	int p;
 	int count = 0;
 
-	dev_list = kmalloc(sizeof *dev_list, GFP_KERNEL);
+	dev_list = kmalloc(sizeof(*dev_list), GFP_KERNEL);
 	if (!dev_list)
 		return;
 
-- 
2.12.2

