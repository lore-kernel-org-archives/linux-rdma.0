From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 10/20] IB/hfi1: Protect the global dev_cntr_names and
 port_cntr_names
Date: Mon, 20 Mar 2017 17:25:35 -0700
Message-ID: <20170321002534.28538.96859.stgit@scvm10.sc.intel.com>
References: <20170321001900.28538.38175.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170321001900.28538.38175.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Protect the global dev_cntr_names and port_cntr_names with the global
mutex as they are allocated and freed in a function called per device.
Otherwise there is a danger of double free and memory leaks.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/verbs.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 815cb44..8d71654 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1540,6 +1540,7 @@ static void hfi1_get_dev_fw_str(struct ib_device *ibdev, char *str,
 	"DRIVER_EgrHdrFull"
 };
 
+static DEFINE_MUTEX(cntr_names_lock); /* protects the *_cntr_names bufers */
 static const char **dev_cntr_names;
 static const char **port_cntr_names;
 static int num_driver_cntrs = ARRAY_SIZE(driver_cntr_names);
@@ -1594,6 +1595,7 @@ static int init_cntr_names(const char *names_in,
 {
 	int i, err;
 
+	mutex_lock(&cntr_names_lock);
 	if (!cntr_names_initialized) {
 		struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 
@@ -1602,8 +1604,10 @@ static int init_cntr_names(const char *names_in,
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
@@ -1617,10 +1621,12 @@ static int init_cntr_names(const char *names_in,
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
@@ -1839,9 +1845,13 @@ void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
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
