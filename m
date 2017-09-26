From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc 5/7] Revert "IB/ipoib: Update broadcast object if
 PKey value was changed in index 0"
Date: Tue, 26 Sep 2017 06:06:22 -0700
Message-ID: <20170926130620.31476.82301.stgit@scvm10.sc.intel.com>
References: <20170926130434.31476.81826.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170926130434.31476.81826.stgit@scvm10.sc.intel.com>
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Alex Estrin <alex.estrin@intel.com>

commit 9a9b8112699d will cause core to fail UD QP from being destroyed
on ipoib unload, therefore cause resources leakage.
On pkey change event above patch modifies mgid before calling underlying
driver to detach it from QP. Drivers' detach_mcast() will fail to find
modified mgid it was never given to attach in a first place.
Core qp->usecnt will never go down, so ib_destroy_qp() will fail.

IPoIB driver actually does take care of new broadcast mgid based on new
pkey by destroying an old mcast object in ipoib_mcast_dev_flush())
....
	if (priv->broadcast) {
		rb_erase(&priv->broadcast->rb_node, &priv->multicast_tree);
		list_add_tail(&priv->broadcast->list, &remove_list);
		priv->broadcast = NULL;
	}
...

then in restarted ipoib_macst_join_task() creating a new broadcast mcast
object, sending join request and on completion tells the driver to attach
to reinitialized QP:
...
if (!priv->broadcast) {
...
	broadcast = ipoib_mcast_alloc(dev, 0);
...
	memcpy(broadcast->mcmember.mgid.raw, priv->dev->broadcast + 4,
	       sizeof (union ib_gid));
	priv->broadcast = broadcast;
...

Fixes: 9a9b8112699d ("IB/ipoib: Update broadcast object if PKey value was changed in index 0")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Alex Estrin <alex.estrin@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 2e07537..6cd6163 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -1000,19 +1000,6 @@ static inline int update_parent_pkey(struct ipoib_dev_priv *priv)
 		 */
 		priv->dev->broadcast[8] = priv->pkey >> 8;
 		priv->dev->broadcast[9] = priv->pkey & 0xff;
-
-		/*
-		 * Update the broadcast address in the priv->broadcast object,
-		 * in case it already exists, otherwise no one will do that.
-		 */
-		if (priv->broadcast) {
-			spin_lock_irq(&priv->lock);
-			memcpy(priv->broadcast->mcmember.mgid.raw,
-			       priv->dev->broadcast + 4,
-			sizeof(union ib_gid));
-			spin_unlock_irq(&priv->lock);
-		}
-
 		return 0;
 	}
 
