From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [PATCH 21/22] IB/ipoib_verbs: Remove deprecated
 create_singlethread_workqueue
Date: Mon, 15 Aug 2016 23:44:47 +0530
Message-ID: <eb1e68a015714b1a566def4c19cc1da6e4193e7d.1471283718.git.bhaktipriya96@gmail.com>
References: <cover.1471283717.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1471283717.git.bhaktipriya96@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Leon Romanovsky <leonro@mellanox.com>, Chuck Lever <chuck.lever@oracle.com>, Mark Bloch <markb@mellanox.com>, Hans Westgaard Ry <hans.westgaard.ry@oracle.com>, Christoph Lameter <cl@linux.com>, Erez Shitrit <erezsh@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Florian Westphal <fw@strlen.de>, Guy Shapiro <guysh@mellanox.com>, Eli Cohen <eli@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Matan Barak <matanb@mellanox.com>, Chien Tin Tung <chien.tin.tung@intel.com>, Mustafa Ismail <mustafa.ismail@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Tatyana Nikolova <tatyana.e.nikolova@intel.com>, Steve Wise <swise@chelsi>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: linux-rdma@vger.kernel.org

alloc_ordered_workqueue() with WQ_MEM_RECLAIM set, replaces
deprecated create_singlethread_workqueue(). This is the identity
conversion.

The workqueue "wq" queues mulitple work items viz &priv->restart_task,
&priv->cm.rx_reap_task, &priv->cm.skb_task, &priv->neigh_reap_task,
&priv->ah_reap_task, &priv->mcast_task and &priv->carrier_on_task.
The work items require strict execution ordering.
Hence, an ordered dedicated workqueue has been used.

WQ_MEM_RECLAIM has been set to ensure forward progress under
memory pressure.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 1e7cbba..5737652 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -156,7 +156,7 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	 * the various IPoIB tasks assume they will never race against
 	 * themselves, so always use a single thread workqueue
 	 */
-	priv->wq = create_singlethread_workqueue("ipoib_wq");
+	priv->wq = alloc_ordered_workqueue("ipoib_wq", WQ_MEM_RECLAIM);
 	if (!priv->wq) {
 		printk(KERN_WARNING "ipoib: failed to allocate device WQ\n");
 		goto out_free_pd;
--
2.1.4
