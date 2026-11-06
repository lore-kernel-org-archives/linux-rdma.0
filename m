Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793946613;
	b=fVLv9+mOllFpLZJE4g7KF+bg9ZtC2E67hNHdqx2lSSRJviGOW8wGZBBVH9T00PcFCkZB
	 NPe6MGf64Avzu1OGQHyqEzd3ZK1Inm4T5aEuk3R5gPxbil4iHIdQgOc6GWoHFI2RyS/B4
	 YE4IhT4BqWOTG3CXxvSBLTp9lOLN0XSjNd+5cYIV5kuoeNK+2IOU76F5DGmvvsUeHOZ45
	 dT33p05JN+KMS8moOEdp1ON0ri8yHt3Pw16bY4TOtZ/q4pgEOpo6QmibOkEjYag1rymaI
	 9zDDAQxV1LaDV0FJCB6QuNA3p2t54gey987t16s8ecotWZeJmfjs/tl9bMbOchVOhFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793946613;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=0LK6FWJkqMzmxtPw/jdEfAUhg2YMH8t8lmMIRAvfr6c=;
	b=qcQxt4pm0IKYjmQ+KOwv5jqpZ0eC3a6tOa+/xiFa2nkTCXC9LkRFb5zg6s6qCfyTAM7Z
	 zYRBqXRaMOyBTLY4beqhTRDVrSMtxjaA9aw42bpvuW3J0VBhcxY7+fhOrko6cMdxkKXWY
	 RZkXaOHg2xLTE0ulc/DwQhPgdOfDeR0q2LSG2VHdAY+tP/oK/atidpFzJz8A8XSmfIBLq
	 foZRzujNiQLS2qXTmY8RohNmdrU5Mh6z7OXnxPIfbW4640hhQkBpbjL9XnKokRjcyZccq
	 MCBlmjFmdVnOmNDY5Oepen6Gu33nr6J6JsCzTExcC1Wfpl8cDdC6ATD9hRQRfGSp3nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=jrw4MULE;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B0B3606A329;
	Fri,  6 Nov 2026 06:30:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B0B3606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=jrw4MULE
Received: by linux.microsoft.com (Postfix, from userid 1173)
	id C4DED20B7166; Thu,  5 Nov 2026 22:30:12 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C4DED20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793946612;
	bh=0LK6FWJkqMzmxtPw/jdEfAUhg2YMH8t8lmMIRAvfr6c=;
	h=From:To:Cc:Subject:Date:From;
	b=jrw4MULEbL+lOwWOMmRXNBEKspWXmmugok7L4oJdA1/fwwGIbPaKYDRcwcoBT40Wb
	 rFrABeV1ZK42oY2+dgyZjRzdph5O29c9kfRQvyxJjgvD4nxMCVej2fFwTHWQSL2vLU
	 4rgeMCPF0yuhbFW2u82aa4L4aeE1h2OPmEogz9R8=
From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
To: haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	weh@microsoft.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	gargaditya@linux.microsoft.com,
	mawasthi@linux.microsoft.com,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Sahil Chandna <sahilchandna@linux.microsoft.com>
Subject: [PATCH net-next] net: mana: Allocate queue MSI-X vectors on demand
Date: Thu,  5 Nov 2026 22:30:11 -0800
Message-ID: <20261106063011.43293-1-ernis@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
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

MANA allocates its entire MSI-X budget at probe time, even when the
active event queues (EQs) use only a small part of it. With dynamic
MSI-X, this budget can be num_online_cpus() + 1, leaving unused vectors
that consume interrupt resources.

Remove eager allocation of queue vectors and use mana_gd_get_gic(),
which already allocates a vector when an EQ needs one. Keep the HWC
interrupt available during device initialization.

Assign affinity as each vector is created instead of spreading a
preallocated array. Account for both Ethernet queue limits and RNIC
completion vectors when choosing NUMA-aware or linear placement, since
RNIC can use more vectors than the Ethernet limit. Wrap excess vector
positions over the online CPUs if CPUs have gone offline.

Measured results with one vPort per setup:

vCPUs	IRQs before	IRQs after	Affinity before	Affinity after
128	129		65		Linear		NUMA-aware
192	193		65		Linear		NUMA-aware
372	256		65		NUMA-aware	NUMA-aware

Walk the interrupt-context xarray during PCI teardown rather than using
the preallocated vector count, so sparse, on-demand allocations are
released correctly. Leave CDX's preallocated vector pool unchanged.

Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
Reviewed-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
Reviewed-by: Sahil Chandna <sahilchandna@linux.microsoft.com>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   |  50 +++--
 .../net/ethernet/microsoft/mana/gdma_pci.c    | 174 +++++-------------
 include/net/mana/gdma.h                       |   4 +
 3 files changed, 77 insertions(+), 151 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index ae0ed700b3b9..d33abb5b0a6f 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1802,44 +1802,45 @@ struct gdma_irq_context *mana_gd_get_gic(struct gdma_context *gc,
 	const struct gdma_bus_ops *ops = gc->bus_ops;
 	struct gdma_irq_context *gic;
 	bool dyn_msix = false;
-	int msi, irq, err;
+	int msix_index, irq, err;
 
 	mutex_lock(&gc->gic_mutex);
 
 	if (use_msi_bitmap) {
-		msi = find_first_zero_bit(gc->msi_bitmap, gc->num_msix_usable);
-		if (msi >= gc->num_msix_usable) {
+		msix_index = find_first_zero_bit(gc->msi_bitmap,
+						 gc->num_msix_usable);
+		if (msix_index >= gc->num_msix_usable) {
 			dev_err(gc->dev, "No free MSI vectors available\n");
 			gic = ERR_PTR(-ENOSPC);
 			goto out;
 		}
-		*msi_requested = msi;
+		*msi_requested = msix_index;
 	} else {
-		msi = *msi_requested;
+		msix_index = *msi_requested;
 	}
 
-	gic = xa_load(&gc->irq_contexts, msi);
+	gic = xa_load(&gc->irq_contexts, msix_index);
 	if (gic) {
 		refcount_inc(&gic->refcount);
 		if (use_msi_bitmap) {
 			gic->bitmap_refs++;
-			set_bit(msi, gc->msi_bitmap);
+			set_bit(msix_index, gc->msi_bitmap);
 		}
 		goto out;
 	}
 
-	irq = ops->msix_virq(gc, msi);
+	irq = ops->msix_virq(gc, msix_index);
 	if (irq == -EINVAL) {
 		/* A bus that sizes its vector pool up front has nothing left
 		 * to hand out once every vector has been claimed.
 		 */
 		if (!ops->msix_alloc_at) {
-			dev_err(gc->dev, "No IRQ for MSI %d\n", msi);
+			dev_err(gc->dev, "No IRQ for MSI %d\n", msix_index);
 			gic = ERR_PTR(-ENOENT);
 			goto out;
 		}
 
-		irq = ops->msix_alloc_at(gc, &msi);
+		irq = ops->msix_alloc_at(gc, &msix_index);
 		if (irq < 0) {
 			dev_err(gc->dev, "Failed to alloc irq msi %d err %d\n",
 				*msi_requested, irq);
@@ -1848,19 +1849,19 @@ struct gdma_irq_context *mana_gd_get_gic(struct gdma_context *gc,
 		}
 
 		dyn_msix = true;
-		*msi_requested = msi;
+		*msi_requested = msix_index;
 	}
 
 	gic = kzalloc_obj(*gic);
 	if (!gic) {
 		gic = ERR_PTR(-ENOMEM);
 		if (dyn_msix)
-			ops->msix_free(gc, msi, irq);
+			ops->msix_free(gc, msix_index, irq);
 		goto out;
 	}
 
 	gic->handler = mana_gd_process_eq_events;
-	gic->msi = msi;
+	gic->msi = msix_index;
 	gic->irq = irq;
 	INIT_LIST_HEAD(&gic->eq_list);
 	spin_lock_init(&gic->lock);
@@ -1879,28 +1880,41 @@ struct gdma_irq_context *mana_gd_get_gic(struct gdma_context *gc,
 		kfree(gic);
 		gic = ERR_PTR(err);
 		if (dyn_msix)
-			ops->msix_free(gc, msi, irq);
+			ops->msix_free(gc, msix_index, irq);
 		goto out;
 	}
 
+	if (dyn_msix && ops->setup_dyn_affinity) {
+		err = ops->setup_dyn_affinity(gc, irq, msix_index);
+		if (err) {
+			free_irq(irq, gic);
+			kfree(gic);
+			gic = ERR_PTR(err);
+			ops->msix_free(gc, msix_index, irq);
+			goto out;
+		}
+	}
+
 	gic->dyn_msix = dyn_msix;
 	refcount_set(&gic->refcount, 1);
 	gic->bitmap_refs = use_msi_bitmap ? 1 : 0;
 
-	err = xa_err(xa_store(&gc->irq_contexts, msi, gic, GFP_KERNEL));
+	err = xa_err(xa_store(&gc->irq_contexts, msix_index, gic, GFP_KERNEL));
 	if (err) {
 		dev_err(gc->dev, "Failed to store irq context for msi %d: %d\n",
-			msi, err);
+			msix_index, err);
+		if (dyn_msix)
+			irq_update_affinity_hint(irq, NULL);
 		free_irq(irq, gic);
 		kfree(gic);
 		gic = ERR_PTR(err);
 		if (dyn_msix)
-			ops->msix_free(gc, msi, irq);
+			ops->msix_free(gc, msix_index, irq);
 		goto out;
 	}
 
 	if (use_msi_bitmap)
-		set_bit(msi, gc->msi_bitmap);
+		set_bit(msix_index, gc->msi_bitmap);
 
 out:
 	mutex_unlock(&gc->gic_mutex);
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_pci.c b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
index ed8925296c8a..5aebf57eb412 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_pci.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_pci.c
@@ -299,7 +299,7 @@ static int mana_pci_dev_reset(struct gdma_context *gc)
  */
 
 static int mana_irq_setup_numa_aware(unsigned int *irqs, unsigned int len,
-				     int node, bool skip_first_cpu)
+				     int node, unsigned int skip)
 {
 	const struct cpumask *next, *prev = cpu_none_mask;
 	cpumask_var_t cpus __free(free_cpumask_var);
@@ -317,8 +317,8 @@ static int mana_irq_setup_numa_aware(unsigned int *irqs, unsigned int len,
 				cpumask_andnot(cpus, cpus, topology_sibling_cpumask(cpu));
 				--weight;
 
-				if (unlikely(skip_first_cpu)) {
-					skip_first_cpu = false;
+				if (skip) {
+					skip--;
 					continue;
 				}
 
@@ -336,7 +336,8 @@ static int mana_irq_setup_numa_aware(unsigned int *irqs, unsigned int len,
 }
 
 /* must be called with cpus_read_lock() held */
-static void mana_irq_setup_linear(unsigned int *irqs, unsigned int len)
+static void mana_irq_setup_linear(unsigned int *irqs, unsigned int len,
+				  unsigned int skip)
 {
 	int cpu;
 
@@ -344,96 +345,50 @@ static void mana_irq_setup_linear(unsigned int *irqs, unsigned int len)
 		if (len == 0)
 			break;
 
+		if (skip) {
+			skip--;
+			continue;
+		}
+
 		irq_set_affinity_and_hint(*irqs++, cpumask_of(cpu));
 		len--;
 	}
 }
 
-static int mana_gd_setup_dyn_irqs(struct pci_dev *pdev, int nvec)
+/*
+ * Select NUMA-aware or linear placement using Ethernet and RNIC queue limits.
+ * Use the MSI-X index as the position in the selected placement order. The
+ * NUMA-aware walk reserves its first slot for HWC; the linear queue walk does not.
+ */
+static int mana_pci_setup_dyn_affinity(struct gdma_context *gc,
+				       unsigned int irq, unsigned int msix_index)
 {
-	struct gdma_context *gc = pci_get_drvdata(pdev);
-	struct gdma_irq_context *gic;
-	int *irqs, err, i, msi;
+	unsigned int num_queue_irqs = gc->max_num_queues_vport;
+	unsigned int num_cpus, skip;
+	int err = 0;
 
-	irqs = kmalloc_objs(int, nvec);
-	if (!irqs)
-		return -ENOMEM;
+	if (!gc->msi_sharing)
+		num_queue_irqs *= gc->num_ports;
 
-	/*
-	 * In this function, num_msix_usable = HWC IRQ + Queue IRQ.
-	 * nvec is only Queue IRQ (HWC already setup).
-	 * While processing the next pci irq vector, we start with index 1,
-	 * as IRQ vector at index 0 is already processed for HWC.
-	 * However, the population of irqs array starts with index 0, to be
-	 * further used in mana_irq_setup_numa_aware()
-	 */
-	for (i = 1; i <= nvec; i++) {
-		msi = i;
-		gic = mana_gd_get_gic(gc, false, &msi);
-		if (IS_ERR(gic)) {
-			err = PTR_ERR(gic);
-			goto free_irq;
-		}
+	/* RNIC completion EQs can use more vectors than Ethernet queues. */
+	num_queue_irqs = max(num_queue_irqs, gc->max_num_queues);
 
-		irqs[i - 1] = gic->irq;
-	}
-
-	/*
-	 * When calling mana_irq_setup_numa_aware() for dynamically added IRQs,
-	 * if number of CPUs is more than or equal to allocated MSI-X, we need to
-	 * skip the first CPU sibling group since they are already affinitized to
-	 * HWC IRQ
-	 */
 	cpus_read_lock();
-	if (gc->num_msix_usable <= num_online_cpus()) {
-		err = mana_irq_setup_numa_aware(irqs, nvec, gc->numa_node,
-						true);
-		if (err) {
-			cpus_read_unlock();
-			goto free_irq;
-		}
+	num_cpus = num_online_cpus();
+	if (num_queue_irqs < num_cpus && msix_index < num_cpus) {
+		err = mana_irq_setup_numa_aware(&irq, 1, gc->numa_node, msix_index);
 	} else {
-		/*
-		 * When num_msix_usable are more than num_online_cpus, our
-		 * queue IRQs should be equal to num of online vCPUs.
-		 * We try to make sure queue IRQs spread across all vCPUs.
-		 * In such a case NUMA or CPU core affinity does not matter.
-		 * Note: in this case the total mana IRQ should always be
-		 * num_online_cpus + 1. The first HWC IRQ is already handled
-		 * in HWC setup calls
-		 * However, if CPUs went offline since num_msix_usable was
-		 * computed, queue IRQs will be more than num_online_cpus().
-		 * In such cases remaining extra IRQs will retain their default
-		 * affinity.
-		 */
-		int first_unassigned = num_online_cpus();
-
-		if (nvec > first_unassigned) {
-			char buf[32];
-
-			if (first_unassigned == nvec - 1)
-				snprintf(buf, sizeof(buf), "%d",
-					 first_unassigned);
-			else
-				snprintf(buf, sizeof(buf), "%d-%d",
-					 first_unassigned, nvec - 1);
-
-			dev_dbg(&pdev->dev,
-				"MANA IRQ indices #%s will retain the default CPU affinity\n",
-				buf);
+		skip = msix_index ? msix_index - 1 : 0;
+		/* CPU hotplug can leave more queue vectors than online CPUs. */
+		if (skip >= num_cpus) {
+			dev_dbg(gc->dev, "Wrapping MSI %u affinity over %u CPUs\n",
+				msix_index, num_cpus);
+			skip %= num_cpus;
 		}
-
-		mana_irq_setup_linear(irqs, nvec);
+		mana_irq_setup_linear(&irq, 1, skip);
 	}
-
 	cpus_read_unlock();
-	kfree(irqs);
-	return 0;
 
-free_irq:
-	for (i -= 1; i > 0; i--)
-		mana_gd_put_gic(gc, false, i);
-	kfree(irqs);
 	return err;
 }
 
@@ -478,7 +433,7 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev, int nvec)
 		nvec -= 1;
 	}
 
-	err = mana_irq_setup_numa_aware(irqs, nvec, gc->numa_node, false);
+	err = mana_irq_setup_numa_aware(irqs, nvec, gc->numa_node, 0);
 	if (err) {
 		cpus_read_unlock();
 		goto free_irq;
@@ -523,40 +478,6 @@ static int mana_gd_setup_hwc_irqs(struct pci_dev *pdev)
 	}
 
 	gc->num_msix_usable = nvec;
-	gc->max_num_msix = nvec;
-
-	return 0;
-}
-
-static int mana_gd_setup_remaining_irqs(struct pci_dev *pdev)
-{
-	struct gdma_context *gc = pci_get_drvdata(pdev);
-	struct msi_map irq_map;
-	int max_irqs, i, err;
-
-	if (!pci_msix_can_alloc_dyn(pdev))
-		/* remain irqs are already allocated with HWC IRQ */
-		return 0;
-
-	/* allocate only remaining IRQs*/
-	max_irqs = gc->num_msix_usable - 1;
-
-	for (i = 1; i <= max_irqs; i++) {
-		irq_map = pci_msix_alloc_irq_at(pdev, i, NULL);
-		if (!irq_map.virq) {
-			err = irq_map.index;
-			/* caller will handle cleaning up all allocated
-			 * irqs, after HWC is destroyed
-			 */
-			return err;
-		}
-	}
-
-	err = mana_gd_setup_dyn_irqs(pdev, max_irqs);
-	if (err)
-		return err;
-
-	gc->max_num_msix = gc->max_num_msix + max_irqs;
 
 	return 0;
 }
@@ -564,17 +485,12 @@ static int mana_gd_setup_remaining_irqs(struct pci_dev *pdev)
 static void mana_gd_remove_irqs(struct pci_dev *pdev)
 {
 	struct gdma_context *gc = pci_get_drvdata(pdev);
-	int i;
-
-	if (gc->max_num_msix < 1)
-		return;
-
-	for (i = 0; i < gc->max_num_msix; i++) {
-		if (!xa_load(&gc->irq_contexts, i))
-			continue;
+	struct gdma_irq_context *gic;
+	unsigned long msi;
 
-		mana_gd_put_gic(gc, false, i);
-	}
+	/* Only the vectors an EQ asked for were ever created */
+	xa_for_each(&gc->irq_contexts, msi, gic)
+		mana_gd_put_gic(gc, false, msi);
 
 	WARN_ON(!xa_empty(&gc->irq_contexts));
 
@@ -582,7 +498,6 @@ static void mana_gd_remove_irqs(struct pci_dev *pdev)
 
 	bitmap_free(gc->msi_bitmap);
 	gc->msi_bitmap = NULL;
-	gc->max_num_msix = 0;
 	gc->num_msix_usable = 0;
 }
 
@@ -593,14 +508,6 @@ static int mana_pci_setup_hwc_irqs(struct gdma_context *gc)
 
 static int mana_pci_setup_remaining_irqs(struct gdma_context *gc)
 {
-	int err;
-
-	err = mana_gd_setup_remaining_irqs(to_pci_dev(gc->dev));
-	if (err) {
-		dev_err(gc->dev, "Failed to setup remaining IRQs: %d", err);
-		return err;
-	}
-
 	if (!gc->msi_sharing) {
 		gc->msi_bitmap = bitmap_zalloc(gc->num_msix_usable, GFP_KERNEL);
 		if (!gc->msi_bitmap)
@@ -624,6 +531,7 @@ static const struct gdma_bus_ops mana_pci_bus_ops = {
 	.msix_virq		= mana_pci_msix_virq,
 	.msix_alloc_at		= mana_pci_msix_alloc_at,
 	.msix_free		= mana_pci_msix_free,
+	.setup_dyn_affinity	= mana_pci_setup_dyn_affinity,
 	.msix_vec_count		= mana_pci_msix_vec_count,
 	.setup_hwc_irqs		= mana_pci_setup_hwc_irqs,
 	.setup_remaining_irqs	= mana_pci_setup_remaining_irqs,
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index c610fc1067e0..fc8a0ef6c74e 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -443,6 +443,8 @@ struct gdma_context;
  *	allocate their whole pool up front leave this NULL.
  * @msix_free: Release a vector obtained from @msix_alloc_at. Only needed
  *	by buses that implement @msix_alloc_at.
+ * @setup_dyn_affinity: Place a vector obtained from @msix_alloc_at on a
+ *	CPU. Only needed by buses that implement @msix_alloc_at.
  * @msix_vec_count: Return the number of entries in the device MSI-X table,
  *	used to clamp the vector count the core asks for. Buses that cannot
  *	report a table size leave this NULL and the clamp is skipped.
@@ -465,6 +467,8 @@ struct gdma_bus_ops {
 	int (*msix_virq)(struct gdma_context *gc, int msi);
 	int (*msix_alloc_at)(struct gdma_context *gc, int *msi);
 	void (*msix_free)(struct gdma_context *gc, int msi, int irq);
+	int (*setup_dyn_affinity)(struct gdma_context *gc, unsigned int irq,
+				  unsigned int msix_index);
 	int (*msix_vec_count)(struct gdma_context *gc);
 	int (*setup_hwc_irqs)(struct gdma_context *gc);
 	int (*setup_remaining_irqs)(struct gdma_context *gc);

base-commit: 98c2ad4f5d805dbc1ea436a334ee59311806a48c
-- 
2.34.1
