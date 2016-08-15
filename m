From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [PATCH 17/22] IB/mlx4/mad: Remove deprecated
 create_singlethread_workqueue
Date: Mon, 15 Aug 2016 23:43:10 +0530
Message-ID: <18c4505e94d23ab7a34c2aaa9c4ee9f7ace09cef.1471283718.git.bhaktipriya96@gmail.com>
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

The workqueue "wq" queues work item &ctx->work and the workqueue "ud_wq"
queues work item &dm[i]->work.

Both the workqueues have been identity converted.

WQ_MEM_RECLAIM has been set to ensure forward progress under
memory pressure.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/infiniband/hw/mlx4/mad.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 9c2e53d..35b1260 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -2070,7 +2070,7 @@ static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_dev *dev,
 	}

 	snprintf(name, sizeof name, "mlx4_ibt%d", port);
-	ctx->wq = create_singlethread_workqueue(name);
+	ctx->wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (!ctx->wq) {
 		pr_err("Failed to create tunnelling WQ for port %d\n", port);
 		ret = -ENOMEM;
@@ -2078,7 +2078,7 @@ static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_dev *dev,
 	}

 	snprintf(name, sizeof name, "mlx4_ibud%d", port);
-	ctx->ud_wq = create_singlethread_workqueue(name);
+	ctx->ud_wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (!ctx->ud_wq) {
 		pr_err("Failed to create up/down WQ for port %d\n", port);
 		ret = -ENOMEM;
--
2.1.4
