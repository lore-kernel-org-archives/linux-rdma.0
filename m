From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/8] i40iw: Fix order of cleanup in close
Date: Fri, 23 Jun 2017 16:03:55 -0500
Message-ID: <20170623210402.19988-2-henry.orosco@intel.com>
References: <20170623210402.19988-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170623210402.19988-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The order for calling i40iw_destroy_pble_pool is incorrect.
Also, add PBLE_CHUNK_MEM init state to track pble pool
creation and destruction.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index a3f18a2..904fe80 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1474,6 +1474,9 @@ static void i40iw_deinit_device(struct i40iw_device *iwdev, bool reset)
 			unregister_inet6addr_notifier(&i40iw_inetaddr6_notifier);
 		}
 		/* fallthrough */
+	case PBLE_CHUNK_MEM:
+		i40iw_destroy_pble_pool(dev, iwdev->pble_rsrc);
+		/* fallthrough */
 	case CEQ_CREATED:
 		i40iw_dele_ceqs(iwdev, reset);
 		/* fallthrough */
@@ -1489,9 +1492,6 @@ static void i40iw_deinit_device(struct i40iw_device *iwdev, bool reset)
 	case CCQ_CREATED:
 		i40iw_destroy_ccq(iwdev, reset);
 		/* fallthrough */
-	case PBLE_CHUNK_MEM:
-		i40iw_destroy_pble_pool(dev, iwdev->pble_rsrc);
-		/* fallthrough */
 	case HMC_OBJS_CREATED:
 		i40iw_del_hmc_objects(dev, dev->hmc_info, true, reset);
 		/* fallthrough */
@@ -1670,6 +1670,7 @@ static int i40iw_open(struct i40e_info *ldev, struct i40e_client *client)
 		status = i40iw_hmc_init_pble(&iwdev->sc_dev, iwdev->pble_rsrc);
 		if (status)
 			break;
+		iwdev->init_state = PBLE_CHUNK_MEM;
 		iwdev->virtchnl_wq = alloc_ordered_workqueue("iwvch", WQ_MEM_RECLAIM);
 		i40iw_register_notifiers();
 		iwdev->init_state = INET_NOTIFIER;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
