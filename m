Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971583CB8E6;
	Wed,  8 Jul 2026 10:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783507659; cv=none; b=LaypSL+5heGQg+CQVc8zu16IXqGT5xI//C9i/8BV7ZHeFhVly8y8kzYA9/9xRK+RkTToHt/HbxmqWdrcykTUyhNWnzPY8DojMCjN6tnJHYLIZFxAbZiocFaeCjToCbbmkoE6uMeJX1Lr/XuBsLP693jPmuY7iIAbgRIxXOf+0/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783507659; c=relaxed/simple;
	bh=8VOxsRkLz4BQOFLpYYKzmnkuVVlMbCtz1cNQAEMdnDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qjeG6xIY24wr6f90kRILGd67Xfe69QHeLVwfcXMiXc5I4KUFg8dMpDK+LnzgothkI3APqRdYlQD1M57Qzhkotqx3OLvPObCO2FudQ55Y9QU0sZhxKox3UrGwzvDFwJrydMgmAg0SPZ8tBbrHKmKOgPb/DEGefAZZtZfZnx8K74g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ng/6mLRp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ng/6mLRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB571F00ACA;
	Wed,  8 Jul 2026 10:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783507647;
	bh=tmfATRrYSxYs5N8QK4kE7v2SyJjcAvU2cOVJlzX73YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ng/6mLRp0H8Zs2qUOZKVI1ed9JhhwIbK3lFvCSCnsEZVPQmlwhB7MZ/WIo/aEyjhf
	 uBFD3skckCInMdqwTa9zPhcxDXHKbunYEQYxPkG2eEC5pfeYCHHEf8wQ7ROKh0K1wL
	 Udg44FlCjZrBImzigpBYvTVAdAItjTT2pT9VNCAyWxhzKFpHo975Yvy9X137eyzcz4
	 +8PXgIBCrA4kn0Jb6W6TBcBeTEqSzYkzO10vUHTifuFAjxpdtAy83voC0+jlHMOfiB
	 2DLg9ixEF2XpsjjIvXRKw9Xg0GtkaiWN3h14GYgCPVeG6Ks0YM4r0ICNcHNB7p/DxE
	 i3UX6t2UJ1W2Q==
From: Leon Romanovsky <leon@kernel.org>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Ira Weiny <iweiny@kernel.org>,
	Doug Ledford <dledford@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Sadanand Warrier <sadanand.warrier@intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	Dean Luick <dean.luick@intel.com>,
	Sebastian Sanchez <sebastian.sanchez@intel.com>,
	Jubin John <jubin.john@intel.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH rdma-next 13/13] RDMA/hfi1: Align probe error unwinding with device removal
Date: Wed,  8 Jul 2026 13:45:51 +0300
Message-ID: <20260708-clean-init-one-hfi1-v1-13-b9e9641268a5@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260708-clean-init-one-hfi1-v1-0-b9e9641268a5@nvidia.com>
References: <20260708-clean-init-one-hfi1-v1-0-b9e9641268a5@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

init_one() defers handling errors from hfi1_init() and
hfi1_register_ib_device() to a combined block. This allows IB registration
to run after device initialization has failed. Cleanup then depends on two
unrelated error values.

The late probe failure path also differs from the common teardown in
remove_one(), even though both release the same initialized hardware and
driver resources. Maintaining separate sequences obscures ownership and
allows the paths to drift whenever initialization changes.

Unwind at each failing stage and keep late probe teardown ordered like
remove_one(), so partial initialization releases exactly the resources it
owns and normal removal remains the reference cleanup flow.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/hfi1/init.c | 45 ++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 9ed7c1ffc93c..f94d896e7212 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1549,18 +1549,14 @@ static void postinit_cleanup(struct hfi1_devdata *dd)
 	hfi1_dev_affinity_clean_up(dd);
 
 	hfi1_pcie_ddcleanup(dd);
-	hfi1_pcie_cleanup(dd->pcidev);
 
 	cleanup_device_data(dd);
-
-	hfi1_free_devdata(dd);
 }
 
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	int ret = 0, pidx, initfail;
+	int ret;
 	struct hfi1_devdata *dd;
-	struct hfi1_pportdata *ppd;
 
 	/* First, lock the non-writable module parameters */
 	HFI1_CAP_LOCK();
@@ -1627,34 +1623,19 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto destroy_workqueues; /* error already printed */
 
 	/* do the generic initialization */
-	initfail = hfi1_init(dd, 0);
+	ret = hfi1_init(dd, 0);
+	if (ret)
+		goto free_rx;
 
 	ret = hfi1_register_ib_device(dd);
+	if (ret)
+		goto free_rx;
 
 	/*
 	 * Now ready for use.  this should be cleared whenever we
 	 * detect a reset, or initiate one.
 	 */
-	if (!initfail && !ret)
-		dd->flags |= HFI1_INITTED;
-
-	if (initfail || ret) {
-		msix_clean_up_interrupts(dd);
-		stop_timers(dd);
-		for (pidx = 0; pidx < dd->num_pports; ++pidx) {
-			hfi1_quiet_serdes(dd->pport + pidx);
-			ppd = dd->pport + pidx;
-			destroy_workqueue(ppd->hfi1_wq);
-			destroy_workqueue(ppd->link_wq);
-		}
-		if (!ret)
-			hfi1_unregister_ib_device(dd);
-		hfi1_free_rx(dd);
-		postinit_cleanup(dd);
-		if (initfail)
-			ret = initfail;
-		return ret;	/* everything already cleaned */
-	}
+	dd->flags |= HFI1_INITTED;
 
 	ret = hfi1_device_create(dd);
 	if (ret)
@@ -1666,6 +1647,12 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+free_rx:
+	hfi1_free_rx(dd);
+	shutdown_device(dd);
+	stop_timers(dd);
+	postinit_cleanup(dd);
+
 destroy_workqueues:
 	destroy_workqueues(dd);
 free_devdata:
@@ -1711,11 +1698,11 @@ static void remove_one(struct pci_dev *pdev)
 	 * clear dma engines, etc.
 	 */
 	shutdown_device(dd);
-	destroy_workqueues(dd);
-
 	stop_timers(dd);
-
 	postinit_cleanup(dd);
+	destroy_workqueues(dd);
+	hfi1_free_devdata(dd);
+	hfi1_pcie_cleanup(pdev);
 }
 
 static void shutdown_one(struct pci_dev *pdev)

-- 
2.54.0

