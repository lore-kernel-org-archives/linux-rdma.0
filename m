From: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] i40iw: Fix for LAN handler removal
Date: Wed,  9 Nov 2016 21:27:02 -0600
Message-ID: <20161110032702.2752-1-henry.orosco@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If i40iw_open() fails for any reason, the LAN handler
is not being removed. Modify i40iw_deinit_device()
to always remove the handler.

Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 078d784..79808cc 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1404,12 +1404,11 @@ static enum i40iw_status_code i40iw_save_msix_info(struct i40iw_device *iwdev,
  * i40iw_deinit_device - clean up the device resources
  * @iwdev: iwarp device
  * @reset: true if called before reset
- * @del_hdl: true if delete hdl entry
  *
  * Destroy the ib device interface, remove the mac ip entry and ipv4/ipv6 addresses,
  * destroy the device queues and free the pble and the hmc objects
  */
-static void i40iw_deinit_device(struct i40iw_device *iwdev, bool reset, bool del_hdl)
+static void i40iw_deinit_device(struct i40iw_device *iwdev, bool reset)
 {
 	struct i40e_info *ldev = iwdev->ldev;
 
@@ -1472,8 +1471,7 @@ static void i40iw_deinit_device(struct i40iw_device *iwdev, bool reset, bool del
 		break;
 	}
 
-	if (del_hdl)
-		i40iw_del_handler(i40iw_find_i40e_handler(ldev));
+	i40iw_del_handler(i40iw_find_i40e_handler(ldev));
 	kfree(iwdev->hdl);
 }
 
@@ -1635,7 +1633,7 @@ static int i40iw_open(struct i40e_info *ldev, struct i40e_client *client)
 	} while (0);
 
 	i40iw_pr_err("status = %d last completion = %d\n", status, iwdev->init_state);
-	i40iw_deinit_device(iwdev, false, false);
+	i40iw_deinit_device(iwdev, false);
 	return -ERESTART;
 }
 
@@ -1680,7 +1678,7 @@ static void i40iw_close(struct i40e_info *ldev, struct i40e_client *client, bool
 
 	iwdev = &hdl->device;
 	destroy_workqueue(iwdev->virtchnl_wq);
-	i40iw_deinit_device(iwdev, reset, true);
+	i40iw_deinit_device(iwdev, reset);
 }
 
 /**
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
