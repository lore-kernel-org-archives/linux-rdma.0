From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/17] IB/hfi1: Add shared ASIC structure
Date: Sat, 05 Mar 2016 08:49:45 -0800
Message-ID: <20160305164944.32025.80048.stgit@scvm10.sc.intel.com>
References: <20160305164725.32025.99686.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160305164725.32025.99686.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Create a shared structure to exist between devices that share the
same ASIC.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   28 +++++++++++++++++++++++++---
 drivers/infiniband/hw/hfi1/hfi.h  |    9 +++++++++
 drivers/infiniband/hw/hfi1/init.c |   20 ++++++++++++++++++++
 3 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 0874287..686cadf 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -13800,15 +13800,20 @@ void hfi1_start_cleanup(struct hfi1_devdata *dd)
 	((dev)->base_guid & ~(1ULL << GUID_HFI_INDEX_SHIFT))
 
 /*
+ * Information can be shared between the two HFIs on the same ASIC
+ * in the same OS.  This function finds the peer device and sets
+ * up a shared structure.
+ *
  * Certain chip functions need to be initialized only once per asic
  * instead of per-device. This function finds the peer device and
  * checks whether that chip initialization needs to be done by this
  * device.
  */
-static void asic_should_init(struct hfi1_devdata *dd)
+static int init_asic_data(struct hfi1_devdata *dd)
 {
 	unsigned long flags;
 	struct hfi1_devdata *tmp, *peer = NULL;
+	int ret = 0;
 
 	spin_lock_irqsave(&hfi1_devs_lock, flags);
 	/* Find our peer device */
@@ -13826,7 +13831,22 @@ static void asic_should_init(struct hfi1_devdata *dd)
 	 */
 	if (!peer || !(peer->flags & HFI1_DO_INIT_ASIC))
 		dd->flags |= HFI1_DO_INIT_ASIC;
+
+	if (peer) {
+		dd->asic_data = peer->asic_data;
+	} else {
+		dd->asic_data = kzalloc(sizeof(*dd->asic_data), GFP_KERNEL);
+		if (!dd->asic_data) {
+			ret = -ENOMEM;
+			goto done;
+		}
+		mutex_init(&dd->asic_data->asic_resource_mutex);
+	}
+	dd->asic_data->dds[dd->hfi1_id] = dd; /* self back-pointer */
+
+done:
 	spin_unlock_irqrestore(&hfi1_devs_lock, flags);
+	return ret;
 }
 
 /*
@@ -14076,8 +14096,10 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	/* needs to be done before we look for the peer device */
 	read_guid(dd);
 
-	/* should this device init the ASIC block? */
-	asic_should_init(dd);
+	/* set up shared ASIC data with peer device */
+	ret = init_asic_data(dd);
+	if (ret)
+		goto bail_cleanup;
 
 	/* obtain chip sizes, reset chip CSRs */
 	init_chip(dd);
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 9215482..e71a1c2 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -805,6 +805,12 @@ struct hfi1_temp {
 	u8 triggers;      /* temperature triggers */
 };
 
+/* common data between shared ASIC HFIs */
+struct hfi1_asic_data {
+	struct hfi1_devdata *dds[2];	/* back pointers */
+	struct mutex asic_resource_mutex;
+};
+
 /* device data struct now contains only "general per-device" info.
  * fields related to a physical IB port are in a hfi1_pportdata struct.
  */
@@ -880,6 +886,9 @@ struct hfi1_devdata {
 	wait_queue_head_t		  sdma_unfreeze_wq;
 	atomic_t			  sdma_unfreeze_count;
 
+	/* common data between shared ASIC HFIs in this OS */
+	struct hfi1_asic_data *asic_data;
+
 	/* hfi1_pportdata, points to array of (physical) port-specific
 	 * data structs, indexed by pidx (0..n-1)
 	 */
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 37b3ce8..260a8e1 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -974,6 +974,25 @@ void hfi1_free_ctxtdata(struct hfi1_devdata *dd, struct hfi1_ctxtdata *rcd)
 	kfree(rcd);
 }
 
+/*
+ * Release our hold on the shared asic data.  If we are the last one,
+ * free the structure.  Must be holding hfi1_devs_lock.
+ */
+static void release_asic_data(struct hfi1_devdata *dd)
+{
+	int other;
+
+	if (!dd->asic_data)
+		return;
+	dd->asic_data->dds[dd->hfi1_id] = NULL;
+	other = dd->hfi1_id ? 0 : 1;
+	if (!dd->asic_data->dds[other]) {
+		/* we are the last holder, free it */
+		kfree(dd->asic_data);
+	}
+	dd->asic_data = NULL;
+}
+
 void hfi1_free_devdata(struct hfi1_devdata *dd)
 {
 	unsigned long flags;
@@ -981,6 +1000,7 @@ void hfi1_free_devdata(struct hfi1_devdata *dd)
 	spin_lock_irqsave(&hfi1_devs_lock, flags);
 	idr_remove(&hfi1_unit_table, dd->unit);
 	list_del(&dd->list);
+	release_asic_data(dd);
 	spin_unlock_irqrestore(&hfi1_devs_lock, flags);
 	free_platform_config(dd);
 	rcu_barrier(); /* wait for rcu callbacks to complete */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
