From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 06/20] IB/ipoib: drop useless LIST_HEAD
Date: Sun, 23 Dec 2018 09:57:01 +0100
Message-ID: <1545555435-24576-7-git-send-email-Julia.Lawall@lip6.fr>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: kernel-janitors@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Drop LIST_HEAD where the variable it declares is never used.

Commit 31c02e215700 ("IPoIB: Avoid using stale last_send counter
when reaping AHs") removed the uses, but not the declaration.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
@@
- LIST_HEAD(x);
  ... when != x
// </smpl>

Fixes: 31c02e215700 ("IPoIB: Avoid using stale last_send counter when reaping AHs")
Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Successfully 0-day tested on 151 configurations.

 drivers/infiniband/ulp/ipoib/ipoib_ib.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 6d35570092d6..78fa777c87b1 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -669,7 +669,6 @@ static void __ipoib_reap_ah(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 	struct ipoib_ah *ah, *tah;
-	LIST_HEAD(remove_list);
 	unsigned long flags;
 
 	netif_tx_lock_bh(dev);
