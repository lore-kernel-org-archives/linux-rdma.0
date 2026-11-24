Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795534875;
	b=YVmj9aegRyjq263xarzKKphbZmc6MB0RWmaPSZC9JaEloeTa3IX09aOmfx1HyX9Hvghc
	 cQp2NXm7vYwaDBboxSIC0Fw6+zbM15Wk2B987STUg4DMsJWN0039ZypL6EuyOXSLuPGq2
	 p9QzdqTpu6+3euNEIZpSBfgtP7V5+Ln40Nvq55wn0LAwBZtiDt2YA6P6xvkQU9/GynaZu
	 aNoAWokB59aWB6UkmSe7pm4FGFMKyDHFn8BETE0r6vt9XTv1Qik0xH/8H/U+DsCvx3/EB
	 uIjXxQbzZEhSIdrMnrh+4FmG1gmcRmhZNuMlcYes6OcQ/C9v4XlOV2Q5ChmaBUWZJmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795534875;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=cx/197fJqD9mKnSUWOaqWkmYO/Nkgu1VEXJ0Jt6DjI4=;
	b=pzXQnSCg2rZmVNRSlmR/gr7Lf+4vpz/H3mBmezmrYD/6cG+bPKe0LiNEmmHzXW538WlH
	 bilpEpnYLyWQva7hYL59X0OAWtI4Qhm0gA3Tw88cFltv2vrn1XkajWfqN3bMUq9HbGhgu
	 0oCSgBOwNEckS3iHdHm6CuQVq+dh4CV+570tg4/msu8uOYP/E08//nnKLjktzawld8sn5
	 c11RCfuVfCOWSuAcqVGx2RJDgiIW0GTh3gKW0zjfhZLPTXLpdfujGKFQOUwDARrIPN2+d
	 OPxpmB+ENInc4SVR9fjxuUuD1Uag7jjd9gQksiU7xVJn5OM/kROAxCJTdxRCrZIK83g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=oRVocWQN;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EFB7606A682;
	Tue, 24 Nov 2026 15:41:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EFB7606A682
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=oRVocWQN
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5E3FB20B716F;
	Tue, 24 Nov 2026 07:41:03 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5E3FB20B716F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795534864;
	bh=cx/197fJqD9mKnSUWOaqWkmYO/Nkgu1VEXJ0Jt6DjI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRVocWQNzGrBpEcubiUs7Utvh/+jB+MGLCSVJQP16C+Uqc3YJGjaIKtR6Ve5+p8JF
	 ehzev612t85Sstx8p6y677t12HMRaGh2ffWIDFQ12e70jzG32B39Uz6csuby3Nl5lh
	 dAJULQhxvki2Gfr3EY5brybOaSeD0ATE8eB0GtQ0=
From: Wei Hu <weh@linux.microsoft.com>
To: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gargaditya@linux.microsoft.com,
	kees+treewide@kernel.org,
	kees@kernel.org,
	mawasthi@linux.microsoft.com,
	weh@microsoft.com,
	edumazet@kernel.org,
	shacharr@microsoft.com
Subject: [PATCH net-next v12 2/5] net: mana: keep HWC queues until the PF acknowledges teardown
Date: Tue, 24 Nov 2026 15:40:55 +0000
Message-ID: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.2@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.0@linux.microsoft.com>
References: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.0@linux.microsoft.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <longli@microsoft.com>
Date: Mon, 7 Sep 2026 20:51:55 -0700

Once ESTABLISH_HWC submits queue addresses, a failed response does not
give the memory back to the driver. Serialize setup and teardown on the
shared mailbox. If DESTROY_HWC fails, stop IRQ callbacks and keep the
queues for another destroy attempt rather than freeing their DMA.

On teardown, withdraw the CQ table and wait for readers before freeing
the HWC queues. Use the same table bound for allocation and dispatch.

A failed PCI probe has no context left to retry the destroy. Do not
start another automatic probe that could lose another set of coherent
allocations. A failed resume can keep the binding and retry in place.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 .../net/ethernet/microsoft/mana/gdma_cdx.c    |   4 +-
 .../net/ethernet/microsoft/mana/gdma_main.c   |  41 +++-
 .../net/ethernet/microsoft/mana/gdma_pci.c    | 132 +++++++++----
 .../net/ethernet/microsoft/mana/hw_channel.c  | 187 +++++++++++++++---
 drivers/net/ethernet/microsoft/mana/mana_en.c |   4 +-
 .../net/ethernet/microsoft/mana/shm_channel.c |  58 +++++-
 include/net/mana/gdma.h                       |   4 +
 include/net/mana/hw_channel.h                 |   8 +
 include/net/mana/shm_channel.h                |  10 +-
 9 files changed, 369 insertions(+), 79 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_cdx.c b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
index 0d01e3d2f0d96f67dda17f40a8266bf663697c0d..2e0dcb902d7e263fad7341a1756441ec10d8339d 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_cdx.c
@@ -279,7 +279,7 @@ unmap_bar:
 	iounmap(bar0_va);
 free_gc:
 	dev_set_drvdata(&cdx_dev->dev, NULL);
-	vfree(gc);
+	mana_gd_free_context(gc);
 clear_master:
 	cdx_clear_master(cdx_dev);
 	return err;
@@ -298,7 +298,7 @@ static int mana_cdx_gd_remove(struct cdx_device *cdx_dev)
 	iounmap(gc->bar0_va);
 
 	dev_set_drvdata(&cdx_dev->dev, NULL);
-	vfree(gc);
+	mana_gd_free_context(gc);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 673a4754c9dd00a8a0b4436e27ce1c433d85c2ff..2d495db51d7463e260d32f9a52870df578ef0bee 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -11,6 +11,7 @@
 #include <linux/irqdomain.h>
 #include <linux/export.h>
 #include <linux/uaccess.h>
+#include <linux/vmalloc.h>
 
 #include <net/mana/mana.h>
 #include <net/mana/hw_channel.h>
@@ -775,9 +776,15 @@ void mana_gd_free_service_wq(struct gdma_context *gc)
 static void mana_gd_schedule_eq_cqs(struct gdma_queue *eq)
 {
 	struct gdma_context *gc = eq->gdma_dev->gdma_context;
+	struct gdma_queue **cq_table;
 	struct gdma_queue *cq;
 	u8 i;
 
+	/* The IRQ's RCU read-side section protects this table snapshot. */
+	cq_table = smp_load_acquire(&gc->cq_table);
+	if (!cq_table)
+		return;
+
 	for (i = 0; i < GDMA_EQ_MAX_CHILD_CQ; i++) {
 		cq = rcu_dereference(eq->eq.child_cq[i]);
 
@@ -785,7 +792,7 @@ static void mana_gd_schedule_eq_cqs(struct gdma_queue *eq)
 			continue;
 
 		if (cq->id >= READ_ONCE(gc->max_num_cqs) ||
-		    !gc->cq_table || gc->cq_table[cq->id] != cq)
+		    READ_ONCE(cq_table[cq->id]) != cq)
 			continue;
 
 		if (cq->cq.callback)
@@ -800,6 +807,7 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
 	union gdma_eqe_info eqe_info;
 	enum gdma_eqe_type type;
 	struct gdma_event event;
+	struct gdma_queue **cq_table;
 	struct gdma_queue *cq;
 	struct gdma_eqe *eqe;
 	u32 cq_id;
@@ -811,11 +819,16 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
 	switch (type) {
 	case GDMA_EQE_COMPLETION:
 		cq_id = eqe->details[0] & 0xFFFFFF;
-		if (WARN_ON_ONCE(cq_id >= gc->max_num_cqs))
+		/* HWC teardown unpublishes this table and waits for these
+		 * RCU readers before freeing it, then fences its own EQ.
+		 */
+		cq_table = smp_load_acquire(&gc->cq_table);
+		if (!cq_table || cq_id >= READ_ONCE(gc->max_num_cqs))
 			break;
 
-		cq = gc->cq_table[cq_id];
-		if (WARN_ON_ONCE(!cq || cq->type != GDMA_CQ || cq->id != cq_id))
+		cq = READ_ONCE(cq_table[cq_id]);
+		if (!cq || WARN_ON_ONCE(cq->type != GDMA_CQ ||
+					cq->id != cq_id))
 			break;
 
 		if (cq->cq.callback)
@@ -1047,23 +1060,32 @@ out:
 	return err;
 }
 
-static void mana_gd_destroy_eq(struct gdma_context *gc, bool flush_evenets,
+static void mana_gd_destroy_eq(struct gdma_context *gc, bool flush_events,
 			       struct gdma_queue *queue)
 {
 	int err;
 
-	if (flush_evenets) {
+	if (queue->eq.msix_index == INVALID_PCI_MSIX_INDEX)
+		return;
+
+	if (flush_events) {
 		err = mana_gd_test_eq(gc, queue);
 		if (err && mana_need_log(gc, err))
 			dev_warn(gc->dev, "Failed to flush EQ: %d\n", err);
 	}
 
 	mana_gd_deregister_irq(queue);
+	queue->eq.msix_index = INVALID_PCI_MSIX_INDEX;
 
 	if (queue->eq.disable_needed)
 		mana_gd_disable_queue(queue);
 }
 
+void mana_gd_fence_eq(struct gdma_context *gc, struct gdma_queue *queue)
+{
+	mana_gd_destroy_eq(gc, false, queue);
+}
+
 static int mana_gd_create_eq(struct gdma_dev *gd,
 			     const struct gdma_queue_spec *spec,
 			     bool create_hwq, struct gdma_queue *queue)
@@ -2136,6 +2158,13 @@ void mana_gd_cleanup(struct gdma_context *gc)
 }
 EXPORT_SYMBOL_NS(mana_gd_cleanup, "NET_MANA");
 
+void mana_gd_free_context(struct gdma_context *gc)
+{
+	mana_hwc_free_retained_channel(gc);
+	vfree(gc);
+}
+EXPORT_SYMBOL_NS(mana_gd_free_context, "NET_MANA");
+
 static int __init gdma_core_init(void)
 {
 	mana_debugfs_root = debugfs_create_dir("mana", NULL);
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_pci.c b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
index 208dadbcf977ca965fb48a37bef0db7b5019d7f1..cec2e548f36ea70bd821bc085f77ac94e78b4541 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_pci.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
@@ -19,7 +19,6 @@
 struct mana_dev_recovery {
 	struct list_head list;
 	struct pci_dev *pdev;
-	enum gdma_eqe_type type;
 };
 
 static struct mana_dev_recovery_work {
@@ -32,49 +31,84 @@ static struct mana_dev_recovery_work {
 
 static int mana_gd_suspend(struct pci_dev *pdev, pm_message_t state);
 static int mana_gd_resume(struct pci_dev *pdev);
+static struct pci_driver mana_driver;
 
 #define MANA_SERVICE_PERIOD 10
 
-static void mana_serv_rescan(struct pci_dev *pdev)
-{
-	struct pci_bus *parent;
+enum mana_rescan_reason {
+	MANA_RESCAN_PROBE,
+	MANA_RESCAN_RESET,
+	MANA_RESCAN_FPGA,
+};
 
-	pci_lock_rescan_remove();
+/* The rescan/remove lock serializes service removals. A synchronous
+ * ->remove() on this task can veto the scan, including for a sibling
+ * removed along with the upstream bridge.
+ */
+static struct task_struct *mana_rescan_task;
 
-	parent = pdev->bus;
-	if (!parent) {
-		dev_err(&pdev->dev, "MANA service: no parent bus\n");
-		goto out;
-	}
+static int mana_check_unbound(struct pci_dev *pdev, void *data)
+{
+	bool *unbound = data;
 
-	pci_stop_and_remove_bus_device(pdev);
-	pci_rescan_bus(parent);
+	if (READ_ONCE(pdev->driver) ||
+	    !pci_match_id(mana_driver.id_table, pdev))
+		return 0;
 
-out:
-	pci_unlock_rescan_remove();
+	*unbound = true;
+	return 1;
 }
 
-static void mana_serv_fpga(struct pci_dev *pdev)
+static void mana_serv_rescan(struct pci_dev *pdev,
+			     enum mana_rescan_reason reason)
 {
-	struct pci_bus *bus, *parent;
+	struct pci_dev *target = pdev;
+	struct pci_bus *parent;
+	bool unbound = false;
 
 	pci_lock_rescan_remove();
-
-	bus = pdev->bus;
-	if (!bus) {
-		dev_err(&pdev->dev, "MANA service: no bus\n");
+	if (!device_is_registered(&pdev->dev))
 		goto out;
+
+	scoped_guard(device, &pdev->dev) {
+		if (reason == MANA_RESCAN_PROBE) {
+			if (pdev->dev.driver)
+				goto out;
+		} else if (pdev->driver != &mana_driver) {
+			goto out;
+		} else if (reason == MANA_RESCAN_FPGA) {
+			struct gdma_context *gc = pci_get_drvdata(pdev);
+
+			/* An unbound sibling cannot veto the bridge rescan in
+			 * ->remove(). Its last probe may have lost HWC DMA.
+			 */
+			target = pci_upstream_bridge(pdev);
+			if (target)
+				pci_walk_bus(target->subordinate,
+					     mana_check_unbound, &unbound);
+			if (unbound) {
+				dev_err(&pdev->dev,
+					"Unbound MANA function, skipping bridge rescan\n");
+				clear_bit(GC_IN_SERVICE, &gc->flags);
+				goto out;
+			}
+		}
 	}
 
-	parent = bus->parent;
-	if (!parent) {
+	if (!target || !target->bus) {
 		dev_err(&pdev->dev, "MANA service: no parent bus\n");
 		goto out;
 	}
 
-	pci_stop_and_remove_bus_device(bus->self);
+	parent = target->bus;
+	WRITE_ONCE(mana_rescan_task, current);
+	pci_stop_and_remove_bus_device(target);
+	if (!READ_ONCE(mana_rescan_task))
+		goto out;
+	WRITE_ONCE(mana_rescan_task, NULL);
 
-	msleep(MANA_SERVICE_PERIOD * 1000);
+	if (reason == MANA_RESCAN_FPGA)
+		msleep(MANA_SERVICE_PERIOD * 1000);
 
 	pci_rescan_bus(parent);
 
@@ -82,19 +116,18 @@ out:
 	pci_unlock_rescan_remove();
 }
 
-static void mana_serv_reset(struct pci_dev *pdev)
+/* Return true if recovery needs to escalate to PCI re-enumeration. */
+static bool mana_serv_reset(struct pci_dev *pdev)
 {
-	struct gdma_context *gc = pci_get_drvdata(pdev);
 	struct hw_channel_context *hwc;
+	struct gdma_context *gc;
 	int ret;
 
-	if (!gc) {
-		/* Perform PCI rescan on device if GC is not set up */
-		dev_err(&pdev->dev, "MANA service: GC not setup, rescanning\n");
-		mana_serv_rescan(pdev);
-		return;
-	}
+	guard(device)(&pdev->dev);
+	if (pdev->driver != &mana_driver)
+		return false;
 
+	gc = pci_get_drvdata(pdev);
 	hwc = gc->hwc.driver_data;
 	if (!hwc) {
 		dev_err(&pdev->dev, "MANA service: no HWC\n");
@@ -114,8 +147,7 @@ static void mana_serv_reset(struct pci_dev *pdev)
 	if (ret == -ETIMEDOUT || ret == -EPROTO) {
 		/* Perform PCI rescan on device if we failed on HWC */
 		dev_err(&pdev->dev, "MANA service: resume failed, rescanning\n");
-		mana_serv_rescan(pdev);
-		return;
+		return true;
 	}
 
 	if (ret)
@@ -125,17 +157,19 @@ static void mana_serv_reset(struct pci_dev *pdev)
 
 out:
 	clear_bit(GC_IN_SERVICE, &gc->flags);
+	return false;
 }
 
 static void mana_do_service(enum gdma_eqe_type type, struct pci_dev *pdev)
 {
 	switch (type) {
 	case GDMA_EQE_HWC_FPGA_RECONFIG:
-		mana_serv_fpga(pdev);
+		mana_serv_rescan(pdev, MANA_RESCAN_FPGA);
 		break;
 
 	case GDMA_EQE_HWC_RESET_REQUEST:
-		mana_serv_reset(pdev);
+		if (mana_serv_reset(pdev))
+			mana_serv_rescan(pdev, MANA_RESCAN_RESET);
 		break;
 
 	default:
@@ -160,7 +194,7 @@ static void mana_recovery_delayed_func(struct work_struct *w)
 		list_del(&dev->list);
 		spin_unlock_irqrestore(&work->lock, flags);
 
-		mana_do_service(dev->type, dev->pdev);
+		mana_serv_rescan(dev->pdev, MANA_RESCAN_PROBE);
 		pci_dev_put(dev->pdev);
 		kfree(dev);
 
@@ -632,8 +666,16 @@ unmap_bar:
 	xa_destroy(&gc->irq_contexts);
 	pci_iounmap(pdev, bar0_va);
 free_gc:
+	/* No binding remains to retry DESTROY. Do not start another probe
+	 * which could abandon another set of coherent allocations.
+	 */
+	if (gc->hwc.driver_data) {
+		dev_err(&pdev->dev,
+			"HWC teardown failed, disabling probe recovery\n");
+		err = -ENOTRECOVERABLE;
+	}
 	pci_set_drvdata(pdev, NULL);
-	vfree(gc);
+	mana_gd_free_context(gc);
 release_region:
 	pci_release_regions(pdev);
 disable_dev:
@@ -658,7 +700,6 @@ disable_dev:
 			return err;
 
 		dev->pdev = pci_dev_get(pdev);
-		dev->type = GDMA_EQE_HWC_RESET_REQUEST;
 
 		spin_lock_irqsave(&mana_dev_recovery_work.lock, flags);
 		list_add_tail(&dev->list, &mana_dev_recovery_work.dev_list);
@@ -682,11 +723,16 @@ static void mana_gd_remove(struct pci_dev *pdev)
 
 	mana_gd_cleanup(gc);
 
+	if (gc->hwc.driver_data && READ_ONCE(mana_rescan_task) == current) {
+		dev_err(gc->dev, "HWC teardown failed, skipping PCI rescan\n");
+		WRITE_ONCE(mana_rescan_task, NULL);
+	}
+
 	xa_destroy(&gc->irq_contexts);
 
 	pci_iounmap(pdev, gc->bar0_va);
 
-	vfree(gc);
+	mana_gd_free_context(gc);
 
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
@@ -714,7 +760,7 @@ static int mana_gd_resume(struct pci_dev *pdev)
 
 	err = mana_gd_setup(gc);
 	if (err)
-		return err;
+		goto check_hwc;
 
 	err = mana_probe(&gc->mana, true);
 	if (err)
@@ -728,6 +774,10 @@ static int mana_gd_resume(struct pci_dev *pdev)
 
 cleanup_gd:
 	mana_gd_cleanup(gc);
+check_hwc:
+	/* Keep the binding and DMA handles for a later DESTROY retry. */
+	if (gc->hwc.driver_data)
+		return -ENOTRECOVERABLE;
 	return err;
 }
 
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 130b249318f208ae8369c98facf5113a3743cfd4..39a0ed32e43c7953885146b647249db6e03fb8bb 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -143,7 +143,7 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 
 		switch (type) {
 		case HWC_INIT_DATA_CQID:
-			hwc->cq->gdma_cq->id = val;
+			WRITE_ONCE(hwc->hwc_init_cq_id, val);
 			break;
 
 		case HWC_INIT_DATA_RQID:
@@ -167,7 +167,11 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 			break;
 
 		case HWC_INIT_DATA_MAX_NUM_CQS:
-			gd->gdma_context->max_num_cqs = val;
+			/* Store only; establish_channel() commits it to
+			 * max_num_cqs once, so a later event cannot grow the
+			 * bound past the allocation; pairs with READ_ONCE().
+			 */
+			WRITE_ONCE(hwc->hwc_init_max_num_cqs, val);
 			break;
 
 		case HWC_INIT_DATA_PDID:
@@ -395,9 +399,43 @@ static void mana_hwc_comp_event(void *ctx, struct gdma_queue *q_self)
 	mana_gd_ring_cq(q_self, SET_ARM_BIT);
 }
 
+static int mana_hwc_publish_cq(struct gdma_context *gc,
+			       struct gdma_queue *cq)
+{
+	struct gdma_queue **cq_table = READ_ONCE(gc->cq_table);
+	u32 id = READ_ONCE(cq->id);
+
+	if (!cq_table || id >= READ_ONCE(gc->max_num_cqs) ||
+	    READ_ONCE(cq_table[id]))
+		return -EINVAL;
+
+	WRITE_ONCE(cq_table[id], cq);
+
+	return 0;
+}
+
+static void mana_hwc_unpublish_cq(struct gdma_context *gc,
+				  struct gdma_queue *cq)
+{
+	struct gdma_queue **cq_table = READ_ONCE(gc->cq_table);
+	u32 id;
+
+	if (!cq_table || !cq)
+		return;
+
+	id = READ_ONCE(cq->id);
+	if (id < READ_ONCE(gc->max_num_cqs) &&
+	    READ_ONCE(cq_table[id]) == cq)
+		WRITE_ONCE(cq_table[id], NULL);
+}
+
 static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
 {
-	kfree(hwc_cq->comp_buf);
+	/* Fence callbacks first, but keep the parent EQ alive until CQ
+	 * destruction has detached its child entry.
+	 */
+	if (hwc_cq->gdma_eq)
+		mana_gd_fence_eq(gc, hwc_cq->gdma_eq);
 
 	if (hwc_cq->gdma_cq)
 		mana_gd_destroy_queue(gc, hwc_cq->gdma_cq);
@@ -405,6 +443,7 @@ static void mana_hwc_destroy_cq(struct gdma_context *gc, struct hwc_cq *hwc_cq)
 	if (hwc_cq->gdma_eq)
 		mana_gd_destroy_queue(gc, hwc_cq->gdma_eq);
 
+	kfree(hwc_cq->comp_buf);
 	kfree(hwc_cq);
 }
 
@@ -687,6 +726,9 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	struct gdma_queue *sq = hwc->txq->gdma_wq;
 	struct gdma_queue *eq = hwc->cq->gdma_eq;
 	struct gdma_queue *cq = hwc->cq->gdma_cq;
+	struct gdma_queue **cq_table;
+	u32 num_cqs;
+	u32 cq_id;
 	int err;
 
 	gc->hwc.doorbell = INVALID_DOORBELL;
@@ -698,7 +740,7 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 				 cq->mem_info.dma_handle,
 				 rq->mem_info.dma_handle,
 				 sq->mem_info.dma_handle,
-				 eq->eq.msix_index);
+				 eq->eq.msix_index, &hwc->setup_active);
 	if (err)
 		return err;
 
@@ -713,15 +755,45 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
 	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
 
-	/* Both were set in mana_hwc_init_event_handler(). */
-	if (WARN_ON(cq->id >= gc->max_num_cqs))
+	/* Snapshot the device-reported count and id once, so the same value
+	 * sizes, bounds and indexes cq_table even across the sleeping
+	 * vcalloc() and a concurrent init event.
+	 */
+	num_cqs = READ_ONCE(hwc->hwc_init_max_num_cqs);
+	cq_id = READ_ONCE(hwc->hwc_init_cq_id);
+
+	/* Both operands come from untrusted HWC bootstrap events; a missing
+	 * MAX_NUM_CQS leaves num_cqs at 0.  Reject rather than WARN_ON() so a
+	 * malformed device response cannot panic a panic_on_warn guest.
+	 */
+	if (cq_id >= num_cqs) {
+		dev_err_ratelimited(hwc->dev,
+				    "HWC: bad CQ id %u >= max %u\n",
+				    cq_id, num_cqs);
 		return -EPROTO;
+	}
+
+	/* Init events remain enabled, so commit the validated CQ ID once. */
+	WRITE_ONCE(cq->id, cq_id);
 
-	gc->cq_table = vcalloc(gc->max_num_cqs, sizeof(struct gdma_queue *));
-	if (!gc->cq_table)
+	cq_table = vcalloc(num_cqs, sizeof(*cq_table));
+	if (!cq_table)
 		return -ENOMEM;
 
-	gc->cq_table[cq->id] = cq;
+	/* Publish the bound and the initialised table together; the release
+	 * pairs with smp_load_acquire() in mana_gd_process_eqe().
+	 */
+	WRITE_ONCE(gc->max_num_cqs, num_cqs);
+	/* Pairs with smp_load_acquire() in mana_gd_process_eqe(). */
+	smp_store_release(&gc->cq_table, cq_table);
+
+	err = mana_hwc_publish_cq(gc, cq);
+	if (err) {
+		dev_err_ratelimited(hwc->dev,
+				    "HWC: failed to publish CQ %u: %d\n",
+				    cq_id, err);
+		return err;
+	}
 
 	return 0;
 }
@@ -770,6 +842,18 @@ out:
 	return err;
 }
 
+static void mana_hwc_clear_cq_table(struct gdma_context *gc)
+{
+	struct gdma_queue **cq_table;
+
+	cq_table = READ_ONCE(gc->cq_table);
+	WRITE_ONCE(gc->max_num_cqs, 0);
+	/* Stop new table readers before waiting for prior RCU readers. */
+	smp_store_release(&gc->cq_table, NULL);
+	synchronize_rcu();
+	vfree(cq_table);
+}
+
 int mana_hwc_create_channel(struct gdma_context *gc)
 {
 	u32 max_req_msg_size, max_resp_msg_size;
@@ -778,6 +862,13 @@ int mana_hwc_create_channel(struct gdma_context *gc)
 	u16 q_depth_max;
 	int err;
 
+	/* Retry a retained context before assigning queues to the PF again. */
+	if (gd->driver_data) {
+		mana_hwc_destroy_channel(gc);
+		if (gd->driver_data)
+			return -ETIMEDOUT;
+	}
+
 	hwc = kzalloc_obj(*hwc);
 	if (!hwc)
 		return -ENOMEM;
@@ -827,25 +918,45 @@ out:
 	return err;
 }
 
+static void mana_hwc_fence_channel(struct gdma_context *gc,
+				   struct hw_channel_context *hwc)
+{
+	if (!hwc->cq)
+		return;
+
+	if (hwc->cq->gdma_eq)
+		mana_gd_fence_eq(gc, hwc->cq->gdma_eq);
+
+	if (hwc->cq->gdma_cq)
+		mana_hwc_unpublish_cq(gc, hwc->cq->gdma_cq);
+}
+
 void mana_hwc_destroy_channel(struct gdma_context *gc)
 {
 	struct hw_channel_context *hwc = gc->hwc.driver_data;
+	int err;
 
 	if (!hwc)
 		return;
 
-	/* gc->max_num_cqs is set in mana_hwc_init_event_handler(). If it's
-	 * non-zero, the HWC worked and we should tear down the HWC here.
+	/* An unacknowledged destroy leaves the PF's mappings live.  Fence
+	 * software dispatch, but retain every PF-visible allocation.
 	 */
-	if (gc->max_num_cqs > 0) {
-		mana_smc_teardown_hwc(&gc->shm_channel, false);
-		WRITE_ONCE(gc->max_num_cqs, 0);
+	err = mana_smc_teardown_hwc(&gc->shm_channel, false,
+				    &hwc->setup_active);
+	if (err) {
+		dev_err(hwc->dev,
+			"HWC teardown failed: %d, retaining PF-visible resources\n",
+			err);
+		mana_hwc_fence_channel(gc, hwc);
+		return;
 	}
 
-	if (hwc->cq)
-		mana_gd_detach_cq(gc, hwc->cq->gdma_cq);
+	mana_hwc_clear_cq_table(gc);
 
-	synchronize_rcu();
+	/* Fence the EQ before releasing the remaining HWC state. */
+	if (hwc->cq)
+		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
 
 	if (hwc->txq)
 		mana_hwc_destroy_wq(hwc, hwc->txq);
@@ -853,9 +964,6 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	if (hwc->rxq)
 		mana_hwc_destroy_wq(hwc, hwc->rxq);
 
-	if (hwc->cq)
-		mana_hwc_destroy_cq(hwc->gdma_dev->gdma_context, hwc->cq);
-
 	kfree(hwc->caller_ctx);
 	hwc->caller_ctx = NULL;
 
@@ -871,9 +979,44 @@ void mana_hwc_destroy_channel(struct gdma_context *gc)
 	kfree(hwc);
 	gc->hwc.driver_data = NULL;
 	gc->hwc.gdma_context = NULL;
+}
 
-	vfree(gc->cq_table);
-	gc->cq_table = NULL;
+static void mana_hwc_free_retained_wq(struct hwc_wq *wq)
+{
+	if (!wq)
+		return;
+
+	kfree(wq->msg_buf);
+	kfree(wq->gdma_wq);
+	kfree(wq);
+}
+
+/* Final disposal after IRQ and service-work teardown, not a retry path.
+ * Free only software state: unacknowledged HWC DMA allocations stay live.
+ */
+void mana_hwc_free_retained_channel(struct gdma_context *gc)
+{
+	struct hw_channel_context *hwc = gc->hwc.driver_data;
+
+	if (!hwc)
+		return;
+
+	gc->hwc.driver_data = NULL;
+	mana_hwc_clear_cq_table(gc);
+
+	if (hwc->cq) {
+		kfree(hwc->cq->gdma_eq);
+		kfree(hwc->cq->gdma_cq);
+		kfree(hwc->cq->comp_buf);
+		kfree(hwc->cq);
+	}
+
+	mana_hwc_free_retained_wq(hwc->txq);
+	mana_hwc_free_retained_wq(hwc->rxq);
+	kfree(hwc->caller_ctx);
+	mana_gd_free_res_map(&hwc->inflight_msg_res);
+	kfree(hwc);
+	gc->hwc.gdma_context = NULL;
 }
 
 int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 7e9223143fc75ff82a45bcdd6f320564b1befa15..744e6ceb7d2b9d88bc9dd3be83a6b280da30b5a5 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2736,8 +2736,8 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 		if (apc->tx_qp[i]->txq.napi_initialized) {
 			/* Detach the CQ only after the WQ object is destroyed,
 			 * so a completion EQE that arrives before then still
-			 * finds the CQ in cq_table[] rather than hitting the
-			 * WARN in mana_gd_process_eqe(). One grace period then
+			 * finds the CQ in cq_table[] rather than being dropped
+			 * by mana_gd_process_eqe(). One grace period then
 			 * covers both mana_gd_intr() and NAPI users.
 			 */
 			mana_gd_detach_cq(gc, apc->tx_qp[i]->tx_cq.gdma_cq);
diff --git a/drivers/net/ethernet/microsoft/mana/shm_channel.c b/drivers/net/ethernet/microsoft/mana/shm_channel.c
index d21b5db06e5092d82249fb1053d07f65aa38490c..df9d05062dd57b465bfab5dba0c476867526ed3b 100644
--- a/drivers/net/ethernet/microsoft/mana/shm_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/shm_channel.c
@@ -125,13 +125,24 @@ static int mana_smc_read_response(struct shm_channel *sc, u32 msg_type,
 void mana_smc_init(struct shm_channel *sc, struct device *dev,
 		   void __iomem *base)
 {
+	/* The first call precedes channel publication. Later calls refresh the
+	 * BAR mapping after reset or resume without reinitializing a live lock.
+	 */
+	if (!sc->transaction_lock_initialized) {
+		mutex_init(&sc->transaction_lock);
+		sc->transaction_lock_initialized = true;
+	}
+
+	mutex_lock(&sc->transaction_lock);
 	sc->dev = dev;
 	sc->base = base;
+	mutex_unlock(&sc->transaction_lock);
 }
 
-int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
-		       u64 cq_addr, u64 rq_addr, u64 sq_addr,
-		       u32 eq_msix_index)
+static int mana_smc_setup_hwc_locked(struct shm_channel *sc, bool reset_vf,
+				     u64 eq_addr, u64 cq_addr, u64 rq_addr,
+				     u64 sq_addr, u32 eq_msix_index,
+				     bool *submitted)
 {
 	union smc_proto_hdr *hdr;
 	u16 all_addr_h4bits = 0;
@@ -144,6 +155,9 @@ int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
 	int err;
 	int i;
 
+	lockdep_assert_held(&sc->transaction_lock);
+	*submitted = false;
+
 	/* Ensure VF already has possession of shared memory */
 	err = mana_smc_poll_register(sc->base, false);
 	if (err) {
@@ -229,6 +243,7 @@ int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
 	/* Write 256-message buffer to shared memory (final 32-bit write
 	 * triggers HW to set possession bit to PF).
 	 */
+	*submitted = true;
 	dword = (u32 *)shm_buf;
 	for (i = 0; i < SMC_APERTURE_DWORDS; i++)
 		writel(*dword++, sc->base + i * SMC_BASIC_UNIT);
@@ -248,11 +263,32 @@ int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
 	return 0;
 }
 
-int mana_smc_teardown_hwc(struct shm_channel *sc, bool reset_vf)
+int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
+		       u64 cq_addr, u64 rq_addr, u64 sq_addr,
+		       u32 eq_msix_index, bool *submitted)
+{
+	int err;
+
+	mutex_lock(&sc->transaction_lock);
+	err = mana_smc_setup_hwc_locked(sc, reset_vf, eq_addr, cq_addr,
+					rq_addr, sq_addr, eq_msix_index,
+					submitted);
+	mutex_unlock(&sc->transaction_lock);
+
+	return err;
+}
+
+static int mana_smc_teardown_hwc_locked(struct shm_channel *sc, bool reset_vf,
+					bool *setup_active)
 {
 	union smc_proto_hdr hdr = {};
 	int err;
 
+	lockdep_assert_held(&sc->transaction_lock);
+
+	if (!*setup_active)
+		return 0;
+
 	/* Ensure already has possession of shared memory */
 	err = mana_smc_poll_register(sc->base, false);
 	if (err) {
@@ -283,5 +319,19 @@ int mana_smc_teardown_hwc(struct shm_channel *sc, bool reset_vf)
 		return err;
 	}
 
+	*setup_active = false;
+
 	return 0;
 }
+
+int mana_smc_teardown_hwc(struct shm_channel *sc, bool reset_vf,
+			  bool *setup_active)
+{
+	int err;
+
+	mutex_lock(&sc->transaction_lock);
+	err = mana_smc_teardown_hwc_locked(sc, reset_vf, setup_active);
+	mutex_unlock(&sc->transaction_lock);
+
+	return err;
+}
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index bde68d6a99f01634f456a9b16eb74fba566e788c..2da086a3b8f721d51827553d78261240c8d69a6f 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -600,6 +600,9 @@ int mana_gd_create_mana_wq_cq(struct gdma_dev *gd,
 
 void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue);
 
+/* Remove an EQ from interrupt dispatch without freeing its queue memory. */
+void mana_gd_fence_eq(struct gdma_context *gc, struct gdma_queue *queue);
+
 int mana_gd_poll_cq(struct gdma_queue *cq, struct gdma_comp *comp, int num_cqe);
 
 void mana_gd_ring_cq(struct gdma_queue *cq, u8 arm_bit);
@@ -1150,6 +1153,7 @@ int mana_gd_verify_vf_version(struct gdma_context *gc);
 int mana_gd_query_max_resources(struct gdma_context *gc);
 int mana_gd_setup(struct gdma_context *gc);
 void mana_gd_cleanup(struct gdma_context *gc);
+void mana_gd_free_context(struct gdma_context *gc);
 int mana_gd_detect_devices(struct gdma_context *gc);
 int mana_gd_init_registers(struct gdma_context *gc);
 irqreturn_t mana_gd_intr(int irq, void *arg);
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 113b01325137bfbab4a0b4c42f1ee883dbcbedb5..fc2c26f809047703244ffd30ff4a7a115c682617 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -185,6 +185,8 @@ struct hw_channel_context {
 	u16 hwc_init_q_depth_max;
 	u32 hwc_init_max_req_msg_size;
 	u32 hwc_init_max_resp_msg_size;
+	u32 hwc_init_max_num_cqs;
+	u32 hwc_init_cq_id;
 
 	int hwc_init_error;
 	struct completion hwc_init_eqe_comp;
@@ -200,11 +202,17 @@ struct hw_channel_context {
 	u32 dest_vrcq_id;
 	u32 hwc_timeout;
 
+	/* Once ESTABLISH_HWC submits the queue addresses, a setup error
+	 * does not release them. The PF may still use the rings and buffers
+	 * until it acknowledges DESTROY_HWC.
+	 */
+	bool setup_active;
 	struct hwc_caller_ctx *caller_ctx;
 };
 
 int mana_hwc_create_channel(struct gdma_context *gc);
 void mana_hwc_destroy_channel(struct gdma_context *gc);
+void mana_hwc_free_retained_channel(struct gdma_context *gc);
 
 int mana_hwc_send_request(struct hw_channel_context *hwc, u32 req_len,
 			  const void *req, u32 resp_len, void *resp);
diff --git a/include/net/mana/shm_channel.h b/include/net/mana/shm_channel.h
index dbabcfb95daf3e87b39a657e3a5f23a1508d4f31..c8daa61fa759e167a97059887fb88a8b9626ed8f 100644
--- a/include/net/mana/shm_channel.h
+++ b/include/net/mana/shm_channel.h
@@ -4,6 +4,8 @@
 #ifndef _SHM_CHANNEL_H
 #define _SHM_CHANNEL_H
 
+#include <linux/mutex.h>
+
 #define SMC_APERTURE_BITS 256
 #define SMC_BASIC_UNIT (sizeof(u32))
 #define SMC_APERTURE_DWORDS (SMC_APERTURE_BITS / (SMC_BASIC_UNIT * 8))
@@ -13,6 +15,9 @@
 struct shm_channel {
 	struct device *dev;
 	void __iomem *base;
+	/* Protects base and complete aperture request/response transactions. */
+	struct mutex transaction_lock;
+	bool transaction_lock_initialized;
 };
 
 void mana_smc_init(struct shm_channel *sc, struct device *dev,
@@ -20,8 +25,9 @@ void mana_smc_init(struct shm_channel *sc, struct device *dev,
 
 int mana_smc_setup_hwc(struct shm_channel *sc, bool reset_vf, u64 eq_addr,
 		       u64 cq_addr, u64 rq_addr, u64 sq_addr,
-		       u32 eq_msix_index);
+		       u32 eq_msix_index, bool *submitted);
 
-int mana_smc_teardown_hwc(struct shm_channel *sc, bool reset_vf);
+int mana_smc_teardown_hwc(struct shm_channel *sc, bool reset_vf,
+			  bool *setup_active);
 
 #endif /* _SHM_CHANNEL_H */
