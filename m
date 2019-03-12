From: "Saleem, Shiraz" <shiraz.saleem@intel.com>
Subject: RE: [PATCH] infiniband: i40iw: fix potential NULL pointer
 dereferences
Date: Tue, 12 Mar 2019 15:36:56 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7A5A6B1A0@fmsmsx124.amr.corp.intel.com>
References: <20190309052750.16139-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190309052750.16139-1-kjlu@umn.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: "pakki001@umn.edu" <pakki001@umn.edu>, "Latif, Faisal" <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

>Subject: [PATCH] infiniband: i40iw: fix potential NULL pointer dereferences
>
>alloc_ordered_workqueue may fail and return NULL. Let's check its return value
>to ensure it is not NULL so as to avoid potential NULL pointer dereferences.
>
>Signed-off-by: Kangjie Lu <kjlu@umn.edu>
>---
> drivers/infiniband/hw/i40iw/i40iw_cm.c | 12 ++++++++++++
> 1 file changed, 12 insertions(+)
>
>diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c
>b/drivers/infiniband/hw/i40iw/i40iw_cm.c
>index 206cfb0016f8..ad9b4f235e30 100644
>--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
>+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
>@@ -3256,9 +3256,21 @@ void i40iw_setup_cm_core(struct i40iw_device
>*iwdev)
>
> 	cm_core->event_wq = alloc_ordered_workqueue("iwewq",
> 						    WQ_MEM_RECLAIM);
>+	if (!cm_core->event_wq) {
>+		i40iw_debug(cm_core->dev,
>+				I40IW_DEBUG_CM,
>+				"%s allocate event work queue failed\n",
>+				__func__);
>+	}
>
> 	cm_core->disconn_wq = alloc_ordered_workqueue("iwdwq",
> 						      WQ_MEM_RECLAIM);
>+	if (!cm_core->disconn_wq) {
>+		i40iw_debug(cm_core->dev,
>+				I40IW_DEBUG_CM,
>+				"%s allocate disconnect work queue failed\n",
>+				__func__);
>+	}
> }

Hi Kangjie - Just doing a debug print doesn't suffice. We need to fail the i40iw_open() and unwind correctly.

Perhaps something like this would be required.

diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index 2f2b442..8feec35 100644
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
index 206cfb0..dcc5fea 100644
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
-
+       if (!cm_core->event_wq)
+               goto error;
+       
        cm_core->disconn_wq = alloc_ordered_workqueue("iwdwq",
                                                      WQ_MEM_RECLAIM);
+       if (!cm_core->disconn_wq)
+               goto error;
+
+       return 0;
+error:
+       i40iw_cleanup_cm_core(&iwdev->cm_core);
+       i40iw_pr_err("fail to setup CM core");
+
+       return -ENOMEM;
 }

 /**
@@ -3278,8 +3289,10 @@ void i40iw_cleanup_cm_core(struct i40iw_cm_core *cm_core)
                del_timer_sync(&cm_core->tcp_timer);
        spin_unlock_irqrestore(&cm_core->ht_lock, flags);

-       destroy_workqueue(cm_core->event_wq);
-       destroy_workqueue(cm_core->disconn_wq);
+       if (cm_core->event_wq)
+               destroy_workqueue(cm_core->event_wq);
+       if (cm_core->disconn_wq)
+               destroy_workqueue(cm_core->disconn_wq);
 }

 /**
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 68095f0..10932ba 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1641,7 +1641,10 @@ static int i40iw_open(struct i40e_info *ldev, struct i40e_client *client)
        iwdev = &hdl->device;
        iwdev->hdl = hdl;
        dev = &iwdev->sc_dev;
-       i40iw_setup_cm_core(iwdev);
+       if (i40iw_setup_cm_core(iwdev)) {
+               kfree(iwdev->hdl);
+               return -ENOMEM;
+       }

        dev->back_dev = (void *)iwdev;
        iwdev->ldev = &hdl->ldev;
-- 
1.8.3.1

Shiraz
