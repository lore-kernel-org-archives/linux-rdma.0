From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [RFC] IB/core: Remove create_workqueue
Date: Tue, 7 Jun 2016 23:40:06 +0530
Message-ID: <20160607181005.GA6233@Karyakshetra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Matan Barak <matanb@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Or Gerlitz <ogerlitz@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Tejun Heo <tj@kernel.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

alloc_workqueue replaces deprecated create_workqueue().

A dedicated workqueue has been used since cm.wq has workitem
&cm_id_priv->timewait_info->work.work (maps to cm_work_handler) is
involved in normal device operation. When a cm mad is received, it is
queued to a cm workqueue for processing. The queued work item references
the port and device on which the mad was received. WQ_MEM_RECLAIM has been
set to ensure forward progress under memory pressure.
Since there are only a fixed number of work
items, explicit concurrency limit is unnecessary here.

Is the workqueue being used on a memory reclaim path?
Does it require WQ_MEM_RECLAIM?

Thanks.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---

 drivers/infiniband/core/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 1d92e09..e335d0b 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -4004,7 +4004,7 @@ static int __init ib_cm_init(void)
 		goto error1;
 	}

-	cm.wq = create_workqueue("ib_cm");
+	cm.wq = alloc_workqueue("ib_cm", WQ_MEM_RECLAIM, 0);
 	if (!cm.wq) {
 		ret = -ENOMEM;
 		goto error2;
