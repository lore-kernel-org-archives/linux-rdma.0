From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [PATCH 13/22] i40iw_cm: Remove deprecated
 create_singlethread_workqueue
Date: Mon, 15 Aug 2016 23:40:53 +0530
Message-ID: <a88357097ecff8511185fb899524abd149108470.1471283717.git.bhaktipriya96@gmail.com>
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

The workqueue "event_wq" is involved in event handling and queues
i40iw_cm_event_handler.

The workqueue "disconn_wq" is involved in closing connection and queues
i40iw_disconnect_worker.

Both workqueues have been identity converted.

WQ_MEM_RECLAIM has been set to ensure forward progress under memory
pressure.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index d2fa725..76082b3 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -3166,8 +3166,11 @@ void i40iw_setup_cm_core(struct i40iw_device *iwdev)
 	spin_lock_init(&cm_core->ht_lock);
 	spin_lock_init(&cm_core->listen_list_lock);

-	cm_core->event_wq = create_singlethread_workqueue("iwewq");
-	cm_core->disconn_wq = create_singlethread_workqueue("iwdwq");
+	cm_core->event_wq = alloc_ordered_workqueue("iwewq",
+						    WQ_MEM_RECLAIM);
+
+	cm_core->disconn_wq = alloc_ordered_workqueue("iwdwq",
+						      WQ_MEM_RECLAIM);
 }

 /**
--
2.1.4
