From: "Saleem, Shiraz" <shiraz.saleem@intel.com>
Subject: RE: [PATCH] infiniband: i40iw: fix potential NULL pointer
 dereferences
Date: Thu, 14 Mar 2019 18:31:25 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7A5A6FAA8@fmsmsx124.amr.corp.intel.com>
References: <9DD61F30A802C4429A01CA4200E302A7A5A6B1A0@fmsmsx124.amr.corp.intel.com>
 <20190314053735.31863-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190314053735.31863-1-kjlu@umn.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: "pakki001@umn.edu" <pakki001@umn.edu>, "Latif, Faisal" <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

>Subject: [PATCH] infiniband: i40iw: fix potential NULL pointer dereferences
>
>alloc_ordered_workqueue may fail and return NULL.
>The fix captures the failure and handles it properly to avoid potential NULL pointer
>dereferences.
>
>Signed-off-by: Kangjie Lu <kjlu@umn.edu>
>---
>V2: add return value to capture the error code
>
> drivers/infiniband/hw/i40iw/i40iw.h      |  2 +-
> drivers/infiniband/hw/i40iw/i40iw_cm.c   | 19 ++++++++++++++++---
> drivers/infiniband/hw/i40iw/i40iw_main.c |  5 ++++-
> 3 files changed, 21 insertions(+), 5 deletions(-)
[....]

>a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
>index 206cfb0016f8..dda24f44239b 100644
>--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
>+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
>@@ -3237,7 +3237,7 @@ void i40iw_receive_ilq(struct i40iw_sc_vsi *vsi, struct
>i40iw_puda_buf *rbuf)
>  * core
>  * @iwdev: iwarp device structure
>  */
>-void i40iw_setup_cm_core(struct i40iw_device *iwdev)
>+int i40iw_setup_cm_core(struct i40iw_device *iwdev)
> {
> 	struct i40iw_cm_core *cm_core = &iwdev->cm_core;
>
>@@ -3256,9 +3256,20 @@ void i40iw_setup_cm_core(struct i40iw_device *iwdev)
>
> 	cm_core->event_wq = alloc_ordered_workqueue("iwewq",
> 						    WQ_MEM_RECLAIM);
>+	if (!cm_core->event_wq)
>+		goto error;
>
> 	cm_core->disconn_wq = alloc_ordered_workqueue("iwdwq",
> 						      WQ_MEM_RECLAIM);
>+	if (!cm_core->disconn_wq)
>+		goto error;
>+
>+	return 0;
>+error:
>+	i40iw_cleanup_cm_core(&iwdev->cm_core);
>+	i40iw_pr_err("fail to setup CM core");
>+
>+	return return -ENOMEM;

please fix :)

> }
>
