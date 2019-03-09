From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] infiniband: i40iw: fix potential NULL pointer dereferences
Date: Fri,  8 Mar 2019 23:27:50 -0600
Message-ID: <20190309052750.16139-1-kjlu@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

alloc_ordered_workqueue may fail and return NULL. Let's check
its return value to ensure it is not NULL so as to avoid
potential NULL pointer dereferences.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 206cfb0016f8..ad9b4f235e30 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -3256,9 +3256,21 @@ void i40iw_setup_cm_core(struct i40iw_device *iwdev)
 
 	cm_core->event_wq = alloc_ordered_workqueue("iwewq",
 						    WQ_MEM_RECLAIM);
+	if (!cm_core->event_wq) {
+		i40iw_debug(cm_core->dev,
+				I40IW_DEBUG_CM,
+				"%s allocate event work queue failed\n",
+				__func__);
+	}
 
 	cm_core->disconn_wq = alloc_ordered_workqueue("iwdwq",
 						      WQ_MEM_RECLAIM);
+	if (!cm_core->disconn_wq) {
+		i40iw_debug(cm_core->dev,
+				I40IW_DEBUG_CM,
+				"%s allocate disconnect work queue failed\n",
+				__func__);
+	}
 }
 
 /**
-- 
2.17.1
