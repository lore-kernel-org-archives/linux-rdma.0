From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: [PATCH 12/22] i40iw_main: Remove deprecated
 create_singlethread_workqueue
Date: Mon, 15 Aug 2016 23:40:09 +0530
Message-ID: <0f01b3a07591a31491f2f026e22f23b0b3e7e88e.1471283717.git.bhaktipriya96@gmail.com>
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

The workqueue "virtchnl_wq" queues work items i40iw_cqp_generic_worker
and i40iw_cqp_manage_hmc_fcn_worker. It has been identity converted.

WQ_MEM_RECLAIM has been set to ensure forward progress under memory
pressure.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 6e90813..798335f 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1613,7 +1613,7 @@ static int i40iw_open(struct i40e_info *ldev, struct i40e_client *client)
 		status = i40iw_hmc_init_pble(&iwdev->sc_dev, iwdev->pble_rsrc);
 		if (status)
 			break;
-		iwdev->virtchnl_wq = create_singlethread_workqueue("iwvch");
+		iwdev->virtchnl_wq = alloc_ordered_workqueue("iwvch", WQ_MEM_RECLAIM);
 		i40iw_register_notifiers();
 		iwdev->init_state = INET_NOTIFIER;
 		status = i40iw_add_mac_ip(iwdev);
--
2.1.4
