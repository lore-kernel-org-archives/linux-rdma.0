From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/hfi1: Protect the global dev_cntr_names and
 port_cntr_names
Date: Tue, 23 May 2017 15:20:00 -0400
Message-ID: <20170523192000.23809.10271.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

commit d5483feda85a8f39ee2e940e279547c686aac30c upstream.

Protect the global dev_cntr_names and port_cntr_names with the global
mutex as they are allocated and freed in a function called per device.
Otherwise there is a danger of double free and memory leaks.

Cc: stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.10
Fixes: Commit b7481944b06e ("IB/hfi1: Show statistics counters under IB stats interface")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/verbs.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 6002aa9..5105b95 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1605,6 +1605,7 @@ static void hfi1_get_dev_fw_str(struct ib_device *ibdev, char *str,
 	"DRIVER_EgrHdrFull"
 };
 
+static DEFINE_MUTEX(cntr_names_lock); /* protects the *_cntr_names bufers */
 static const char **dev_cntr_names;
 static const char **port_cntr_names;
 static int num_driver_cntrs = ARRAY_SIZE(driver_cntr_names);
@@ -1659,6 +1660,7 @@ static struct rdma_hw_stats *alloc_hw_stats(struct ib_device *ibdev,
 {
 	int i, err;
 
+	mutex_lock(&cntr_names_lock);
 	if (!cntr_names_initialized) {
 		struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 
@@ -1667,8 +1669,10 @@ static struct rdma_hw_stats *alloc_hw_stats(struct ib_device *ibdev,
 				      num_driver_cntrs,
 				      &num_dev_cntrs,
 				      &dev_cntr_names);
-		if (err)
+		if (err) {
+			mutex_unlock(&cntr_names_lock);
 			return NULL;
+		}
 
 		for (i = 0; i < num_driver_cntrs; i++)
 			dev_cntr_names[num_dev_cntrs + i] =
@@ -1682,10 +1686,12 @@ static struct rdma_hw_stats *alloc_hw_stats(struct ib_device *ibdev,
 		if (err) {
 			kfree(dev_cntr_names);
 			dev_cntr_names = NULL;
+			mutex_unlock(&cntr_names_lock);
 			return NULL;
 		}
 		cntr_names_initialized = 1;
 	}
+	mutex_unlock(&cntr_names_lock);
 
 	if (!port_num)
 		return rdma_alloc_hw_stats_struct(
@@ -1903,9 +1909,13 @@ void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
 	del_timer_sync(&dev->mem_timer);
 	verbs_txreq_exit(dev);
 
+	mutex_lock(&cntr_names_lock);
 	kfree(dev_cntr_names);
 	kfree(port_cntr_names);
+	dev_cntr_names = NULL;
+	port_cntr_names = NULL;
 	cntr_names_initialized = 0;
+	mutex_unlock(&cntr_names_lock);
 }
 
 void hfi1_cnp_rcv(struct hfi1_packet *packet)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
