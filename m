From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] IB/IPoIB: Delete an error message for a failed memory
 allocation in ipoib_dev_init_default()
Date: Fri, 12 May 2017 22:34:20 +0200
Message-ID: <cceafed0-9dd5-259a-634e-b93dae57e92b@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, Don Hiatt <don.hiatt@intel.com>, Doug Ledford <dledford@redhat.com>, Erez Shitrit <erezsh@mellanox.com>, Feras Daoud <ferasda@mellanox.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, Mark Bloch <markb@mellanox.com>, Paolo Abeni <pabeni@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Shamir Rabinovitch <shamir.rabinovitch@oracle.com>, Zhu Yanjun <yanjun.zhu@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 12 May 2017 22:22:43 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 2869d1adb1de..e31237af2d57 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1618,11 +1618,8 @@ static int ipoib_dev_init_default(struct net_device *dev)
 		goto out;
 
 	priv->tx_ring = vzalloc(ipoib_sendq_size * sizeof *priv->tx_ring);
-	if (!priv->tx_ring) {
-		printk(KERN_WARNING "%s: failed to allocate TX ring (%d entries)\n",
-		       priv->ca->name, ipoib_sendq_size);
+	if (!priv->tx_ring)
 		goto out_rx_ring_cleanup;
-	}
 
 	/* priv->tx_head, tx_tail & tx_outstanding are already 0 */
 
-- 
2.12.3

