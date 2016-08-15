From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [PATCH 18/22] IB/mlx4/mcg: Remove deprecated
 create_singlethread_workqueue
Date: Mon, 15 Aug 2016 23:43:35 +0530
Message-ID: <4045f5014733b227e085c76f00f9ecf7f6266803.1471283718.git.bhaktipriya96@gmail.com>
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

The workqueue "mcg_wq" queues work items &group->work
and &group->timeout_work.

The workqueue "clean_wq" queues work item mcg_clean_task.

Both have been identity converted.

WQ_MEM_RECLAIM has been set to ensure forward progress under
memory pressure.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/infiniband/hw/mlx4/mcg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index 8f7ad07..7d30be0 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -1045,7 +1045,7 @@ int mlx4_ib_mcg_port_init(struct mlx4_ib_demux_ctx *ctx)

 	atomic_set(&ctx->tid, 0);
 	sprintf(name, "mlx4_ib_mcg%d", ctx->port);
-	ctx->mcg_wq = create_singlethread_workqueue(name);
+	ctx->mcg_wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (!ctx->mcg_wq)
 		return -ENOMEM;

@@ -1246,7 +1246,7 @@ void clean_vf_mcast(struct mlx4_ib_demux_ctx *ctx, int slave)

 int mlx4_ib_mcg_init(void)
 {
-	clean_wq = create_singlethread_workqueue("mlx4_ib_mcg");
+	clean_wq = alloc_ordered_workqueue("mlx4_ib_mcg", WQ_MEM_RECLAIM);
 	if (!clean_wq)
 		return -ENOMEM;

--
2.1.4
