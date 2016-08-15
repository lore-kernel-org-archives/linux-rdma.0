From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [PATCH 16/22] IB/mlx4: Remove deprecated
 create_singlethread_workqueue
Date: Mon, 15 Aug 2016 23:42:48 +0530
Message-ID: <0fd56271e4fd6518141f3af078c0f16c8107711f.1471283717.git.bhaktipriya96@gmail.com>
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

The workqueue "wq" queues work items &dm[i]->work, &ew->work.
It has been identity converted.

WQ_MEM_RECLAIM has been set to ensure forward progress under
memory pressure.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/infiniband/hw/mlx4/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 42a4607..f3876b79 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -3023,7 +3023,7 @@ static int __init mlx4_ib_init(void)
 {
 	int err;

-	wq = create_singlethread_workqueue("mlx4_ib");
+	wq = alloc_ordered_workqueue("mlx4_ib", WQ_MEM_RECLAIM);
 	if (!wq)
 		return -ENOMEM;

--
2.1.4
