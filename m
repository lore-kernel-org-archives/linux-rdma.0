From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [PATCH 19/22] IB/nes: Remove deprecated create_singlethread_workqueue
Date: Mon, 15 Aug 2016 23:44:03 +0530
Message-ID: <f1904095c510faad8c81799826e9782618d8754d.1471283718.git.bhaktipriya96@gmail.com>
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

alloc_ordered_workqueue() replaces deprecated
create_singlethread_workqueue().

The workqueue "event_wq" queues work item &event->event_work and the
workqueue "disconn_wq" queues work item work (maps to
g_cm_core->disconn_wq).

WQ_MEM_RECLAIM has not been set since the workqueues are not being used
on a memory reclaim path.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/infiniband/hw/nes/nes_cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 7f0aa23..57db9b3 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -2692,12 +2692,12 @@ static struct nes_cm_core *nes_cm_alloc_core(void)
 	nes_debug(NES_DBG_CM, "Init CM Core completed -- cm_core=%p\n", cm_core);

 	nes_debug(NES_DBG_CM, "Enable QUEUE EVENTS\n");
-	cm_core->event_wq = create_singlethread_workqueue("nesewq");
+	cm_core->event_wq = alloc_ordered_workqueue("nesewq", 0);
 	if (!cm_core->event_wq)
 		goto out_free_cmcore;
 	cm_core->post_event = nes_cm_post_event;
 	nes_debug(NES_DBG_CM, "Enable QUEUE DISCONNECTS\n");
-	cm_core->disconn_wq = create_singlethread_workqueue("nesdwq");
+	cm_core->disconn_wq = alloc_ordered_workqueue("nesdwq", 0);
 	if (!cm_core->disconn_wq)
 		goto out_free_wq;

--
2.1.4
