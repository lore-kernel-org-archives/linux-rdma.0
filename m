Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238EC432BD4;
	Wed,  8 Jul 2026 10:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783507649; cv=none; b=ifKjBtXsomvfFPFDyvQ8guFiP+U8yog2pCAH9R3fhrr7wnNhERIjAvx5yIaZKyLZNirh59l8HpHuU4qNOWXaj2tX3RXqbukK1Vj3ao3uDRfEkVpF0Us4pWL40wWxIcJDSQ5WT0wwK0t+RPMCof8Cz/K/TMHYCoRV7akJ5Ha+VaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783507649; c=relaxed/simple;
	bh=fZoIUbwyzu59+aoWoDBAyI4b8/xUqIXRf7K2KBssjQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mClVasINrD2e0KBRub0AS4B4xmuO7pjhw0VhRqtg0ZxwV7RuHF/Fmo+2zs9NIW5ZibWZmtfb8Z1Jjjr8EBJTfbzFBXJLJtyJLsFWXTUYth90O9+28Lg1xNqpLcarmnYaMP8eQM1ERxQXwZdiM4weNg6DHs6hUoBNNXHIuZ/R8yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G043pz/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G043pz/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6461F00A3D;
	Wed,  8 Jul 2026 10:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783507638;
	bh=QOJefBkQrZQemfPw8AyqjQ/g4B4jomkBbiDtgm3KAas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G043pz/qVjY+bvxWDcnCqCH8cAsg2Q8qYtGQtjKtV+a1JgqFufaMa8EtXHPu7lgnc
	 927Dz7RBjRdO1c84QtG4FexBAAVwYB9q6ByEHe+DUwRQVSLaD2oylky6Cdpep6xggj
	 H/PVWLyPOzkVt/+WrzdAd1nRpBGLUrbd6RpzH4L0T/+0Lu8YAkWGH695h8AbxmRQXg
	 K8/M/cWWHe6mzHtqXbAjGoWq+mDhj8/Jys1wN+JEY3l+isz5uBHEsOwYcHGJiYT0Vv
	 XHJWGqwoAHz0ChMV2fxyzrDng2+9Hk5ANids+22CHh63LyNq4QwmcLrt6RZmNVLfs+
	 CV01R3d99dijQ==
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
Subject: [PATCH rdma-next 11/13] RDMA/hfi1: Defer device creation until probe succeeds
Date: Wed,  8 Jul 2026 13:45:49 +0300
Message-ID: <20260708-clean-init-one-hfi1-v1-11-b9e9641268a5@nvidia.com>
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

init_one() creates the character device before checking whether generic or
IB initialization failed, only to remove it immediately while unwinding.
Moreover, user_add() already calls user_remove() when device creation
fails.

Move hfi1_device_create() after the initialization failure path,
immediately before starting SDMA. The failure path then has no character
device to remove, and hfi1_device_create() continues to unwind its own
failures.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/hfi1/init.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 6c642b68ad86..d17f319ad9f2 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1558,7 +1558,7 @@ static void postinit_cleanup(struct hfi1_devdata *dd)
 
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	int ret = 0, j, pidx, initfail;
+	int ret = 0, pidx, initfail;
 	struct hfi1_devdata *dd;
 	struct hfi1_pportdata *ppd;
 
@@ -1633,9 +1633,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/*
 	 * Now ready for use.  this should be cleared whenever we
-	 * detect a reset, or initiate one.  If earlier failure,
-	 * we still create devices, so diags, etc. can be used
-	 * to determine cause of problem.
+	 * detect a reset, or initiate one.
 	 */
 	if (!initfail && !ret) {
 		dd->flags |= HFI1_INITTED;
@@ -1643,10 +1641,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		hfi1_dbg_ibdev_init(&dd->verbs_dev);
 	}
 
-	j = hfi1_device_create(dd);
-	if (j)
-		dd_dev_err(dd, "Failed to create /dev devices: %d\n", -j);
-
 	if (initfail || ret) {
 		msix_clean_up_interrupts(dd);
 		stop_timers(dd);
@@ -1656,8 +1650,6 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			destroy_workqueue(ppd->hfi1_wq);
 			destroy_workqueue(ppd->link_wq);
 		}
-		if (!j)
-			hfi1_device_remove(dd);
 		if (!ret)
 			hfi1_unregister_ib_device(dd);
 		hfi1_free_rx(dd);
@@ -1667,6 +1659,11 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return ret;	/* everything already cleaned */
 	}
 
+	ret = hfi1_device_create(dd);
+	if (ret)
+		dd_dev_err(dd, "Failed to create /dev devices: %pe\n",
+			   ERR_PTR(ret));
+
 	sdma_start(dd);
 
 	return 0;

-- 
2.54.0

