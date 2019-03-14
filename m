From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] infiniband: i40iw: fix potential NULL pointer dereferences
Date: Thu, 14 Mar 2019 00:37:34 -0500
Message-ID: <20190314053735.31863-1-kjlu@umn.edu>
References: <9DD61F30A802C4429A01CA4200E302A7A5A6B1A0@fmsmsx124.amr.corp.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7A5A6B1A0@fmsmsx124.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

alloc_ordered_workqueue may fail and return NULL.
The fix captures the failure and handles it properly to avoid
potential NULL pointer dereferences.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
V2: add return value to capture the error code

 drivers/infiniband/hw/i40iw/i40iw.h      |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c   | 19 ++++++++++++++++---
 drivers/infiniband/hw/i40iw/i40iw_main.c |  5 ++++-
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index 2f2b4426ded7..8feec35f95a7 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -552,7 +552,7 @@ enum i40iw_status_code i40iw_obj_aligned_mem(struct i40iw_device *iwdev,
 
 void i40iw_request_reset(struct i40iw_device *iwdev);
 void i40iw_destroy_rdma_device(struct i40iw_ib_device *iwibdev);
-void i40iw_setup_cm_core(struct i40iw_device *iwdev);
+int i40iw_setup_cm_core(struct i40iw_device *iwdev);
 void i40iw_cleanup_cm_core(struct i40iw_cm_core *cm_core);
 void i40iw_process_ceq(struct i40iw_device *, struct i40iw_ceq *iwceq);
 void i40iw_process_aeq(struct i40iw_device *);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 206cfb0016f8..dda24f44239b 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -3237,7 +3237,7 @@ void i40iw_receive_ilq(struct i40iw_sc_vsi *vsi, struct i40iw_puda_buf *rbuf)
  * core
  * @iwdev: iwarp device structure
  */
-void i40iw_setup_cm_core(struct i40iw_device *iwdev)
+int i40iw_setup_cm_core(struct i40iw_device *iwdev)
 {
 	struct i40iw_cm_core *cm_core = &iwdev->cm_core;
 
@@ -3256,9 +3256,20 @@ void i40iw_setup_cm_core(struct i40iw_device *iwdev)
 
 	cm_core->event_wq = alloc_ordered_workqueue("iwewq",
 						    WQ_MEM_RECLAIM);
+	if (!cm_core->event_wq)
+		goto error;
 
 	cm_core->disconn_wq = alloc_ordered_workqueue("iwdwq",
 						      WQ_MEM_RECLAIM);
+	if (!cm_core->disconn_wq)
+		goto error;
+
+	return 0;
+error:
+	i40iw_cleanup_cm_core(&iwdev->cm_core);
+	i40iw_pr_err("fail to setup CM core");
+
+	return return -ENOMEM;
 }
 
 /**
@@ -3278,8 +3289,10 @@ void i40iw_cleanup_cm_core(struct i40iw_cm_core *cm_core)
 		del_timer_sync(&cm_core->tcp_timer);
 	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
 
-	destroy_workqueue(cm_core->event_wq);
-	destroy_workqueue(cm_core->disconn_wq);
+	if (cm_core->event_wq)
+		destroy_workqueue(cm_core->event_wq);
+	if (cm_core->disconn_wq)
+		destroy_workqueue(cm_core->disconn_wq);
 }
 
 /**
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 68095f00d08f..10932baee279 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1641,7 +1641,10 @@ static int i40iw_open(struct i40e_info *ldev, struct i40e_client *client)
 	iwdev = &hdl->device;
 	iwdev->hdl = hdl;
 	dev = &iwdev->sc_dev;
-	i40iw_setup_cm_core(iwdev);
+	if (i40iw_setup_cm_core(iwdev)) {
+		kfree(iwdev->hdl);
+		return -ENOMEM;
+	}
 
 	dev->back_dev = (void *)iwdev;
 	iwdev->ldev = &hdl->ldev;
-- 
2.17.1
