From: Mike Marciniszyn <mike.marciniszyn@intel.com>
Subject: [PATCH v2] IB/hfi1: Protect the global dev_cntr_names and
 port_cntr_names
Date: Tue, 23 May 2017 15:42:29 -0400
Message-ID: <20170523194210.27882.64949.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, stable-commits@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Tadeusz Struk <tadeusz.struk@intel.com>

commit 62eed66e98b4c2286fef2ce5911d8d75b7515f7b upstream.

Protect the global dev_cntr_names and port_cntr_names with the global
mutex as they are allocated and freed in a function called per device.
Otherwise there is a danger of double free and memory leaks.

Cc: stable <stable@vger.kernel.org> # v4.11
Fixes: Commit b7481944b06e ("IB/hfi1: Show statistics counters under IB stats interface")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Reviewed-by: Easwar Hariharan <easwar.hariharan@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
---
v2 - fix upstream commit id
 drivers/infiniband/hw/hfi1/verbs.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 16ef7b1..1c67745 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1524,6 +1524,7 @@ static void hfi1_get_dev_fw_str(struct ib_device *ibdev, char *str,
 	"DRIVER_EgrHdrFull"
 };
 
+static DEFINE_MUTEX(cntr_names_lock); /* protects the *_cntr_names bufers */
 static const char **dev_cntr_names;
 static const char **port_cntr_names;
 static int num_driver_cntrs = ARRAY_SIZE(driver_cntr_names);
@@ -1578,6 +1579,7 @@ static struct rdma_hw_stats *alloc_hw_stats(struct ib_device *ibdev,
 {
 	int i, err;
 
+	mutex_lock(&cntr_names_lock);
 	if (!cntr_names_initialized) {
 		struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 
@@ -1586,8 +1588,10 @@ static struct rdma_hw_stats *alloc_hw_stats(struct ib_device *ibdev,
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
@@ -1601,10 +1605,12 @@ static struct rdma_hw_stats *alloc_hw_stats(struct ib_device *ibdev,
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
@@ -1823,9 +1829,13 @@ void hfi1_unregister_ib_device(struct hfi1_devdata *dd)
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
