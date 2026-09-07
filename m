Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759413CC9E8;
	Mon,  7 Sep 2026 18:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788806721; cv=none; b=AjAa5m3RA7NigOL2kP8bqzxts1EeiWpSS1Bu8hh0/t9GXjkQfZU1DuvLMB8JeDp/RO5m0VDmIQec+SO1RZxzHcAft4SHOvRDZOCmwrCbU273fnD8ZIBhL/1MU7UJehiN6aZV8YDuPfA8Uvp9nuxbV9ec+usOL2TdRskki8wEtKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788806721; c=relaxed/simple;
	bh=VWbI0Lq48RF0MUVBhw5MfZQW3oTYpvelpaGyKhQcQ28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MUSNbsEFhnkXEDsFxyBrHPkJDzu/Oorg43gZydxRVgsFCnCzUQFJKqhxxX4Sx0SNBMOBWO7y6rkj5CV+gIsKFHP3t3fJIJvGwHE3i4ZwNJYNDzJzbqQ6iLF5xhL1wcR8D6egrrAo9ZapMO4tmi9fBvR+MRjnUEXuypN1iT8rpIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TJU4FDa9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TJU4FDa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453221F00AC4;
	Mon,  7 Sep 2026 18:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788806705;
	bh=5nNjB7tNITzyN4A/hl1C+FjMGV9M7QT/Y7KKPldSYog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TJU4FDa9okpoJHDYPyMUEr0yoInPQRXICDaFQL7ypH+NmSu1tQ4t3jF6h9FFmP4VB
	 l2D/sGq0KgzRjNXKf2taq6P+d1WO0b00JIehDNoFhviD5TM/kKULpCmaHEKilAghHk
	 xYRHPCa5sRve8EzaeoGiYJfpA6cqDjkU0IsIHza5LPxMAjIpk3xHfXhz9ltCGB4fWM
	 5RmIGICV0ReWY3h9ZgMUylhvvKk/g6slhjKBo0yJq2swA9B5qV89Tex51jhzrD7YPc
	 dQbxeBCQqsxFGQmO/ZY8lDkIdwKEUDTFlM3HPOzCgaUs1d3cFNfR+UwwZv1tVfZWKO
	 01gBERA5cpmGg==
From: Leon Romanovsky <leon@kernel.org>
To: Michael Margolin <mrgolin@amazon.com>,
	Gal Pressman <gal.pressman@linux.dev>,
	Yossi Leybovich <sleybo@amazon.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Steve Wise <larrystevenwise@gmail.com>,
	Firas JahJah <firasj@amazon.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 1/2] RDMA/efa: Keep admin queues alive while IRQ is registered
Date: Mon,  7 Sep 2026 21:44:46 +0300
Message-ID: <20260907-use-after-free-of-admin-queue-struct-v1-1-dd9d9267fbf4@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907-use-after-free-of-admin-queue-struct-v1-0-dd9d9267fbf4@nvidia.com>
References: <20260907-use-after-free-of-admin-queue-struct-v1-0-dd9d9267fbf4@nvidia.com>
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

The management IRQ handler accesses both the admin completion queue and the
async event queue. The driver registered the IRQ before constructing these
queues and destroyed them before freeing the IRQ, so the handler's lifetime
was not contained by the resources it accesses.

Initialize the queues with interrupts masked, request the IRQ, and then
switch to interrupt mode. On removal, reset the device and free the IRQ
before destroying the queues. Also reset the device before destroying the
queues if IRQ registration fails, because the device already has their DMA
addresses.

Fixes: b7f5e880f377 ("RDMA/efa: Add the efa module")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/efa/efa_com.c  |  4 +---
 drivers/infiniband/hw/efa/efa_main.c | 15 +++++++++------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 583b1cf0d721..cb2d448db2d7 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -850,7 +850,7 @@ int efa_com_admin_init(struct efa_com_dev *edev,
 
 	aq->dmadev = edev->dmadev;
 	aq->efa_dev = edev->efa_dev;
-	set_bit(EFA_AQ_STATE_POLLING_BIT, &aq->state);
+	efa_com_set_admin_polling_mode(edev, true);
 
 	sema_init(&aq->avail_cmds, aq->depth);
 
@@ -868,8 +868,6 @@ int efa_com_admin_init(struct efa_com_dev *edev,
 	if (err)
 		goto err_destroy_sq;
 
-	efa_com_set_admin_polling_mode(edev, false);
-
 	err = efa_com_admin_init_aenq(edev, aenq_handlers);
 	if (err)
 		goto err_destroy_cq;
diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
index 4cd80727dcd2..b1df9bb8fac2 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -619,18 +619,21 @@ static struct efa_dev *efa_probe_device(struct pci_dev *pdev)
 	edev->aq.msix_vector_idx = dev->admin_msix_vector_idx;
 	edev->aenq.msix_vector_idx = dev->admin_msix_vector_idx;
 
-	err = efa_set_mgmnt_irq(dev);
+	err = efa_com_admin_init(edev, &aenq_handlers);
 	if (err)
 		goto err_disable_msix;
 
-	err = efa_com_admin_init(edev, &aenq_handlers);
+	err = efa_set_mgmnt_irq(dev);
 	if (err)
-		goto err_free_mgmnt_irq;
+		goto err_destroy_admin;
+
+	efa_com_set_admin_polling_mode(edev, false);
 
 	return dev;
 
-err_free_mgmnt_irq:
-	efa_free_irq(dev, &dev->admin_irq);
+err_destroy_admin:
+	efa_com_dev_reset(edev, EFA_REGS_RESET_INIT_ERR);
+	efa_com_admin_destroy(edev);
 err_disable_msix:
 	efa_disable_msix(dev);
 err_reg_read_destroy:
@@ -654,8 +657,8 @@ static void efa_remove_device(struct pci_dev *pdev,
 
 	edev = &dev->edev;
 	efa_com_dev_reset(edev, reset_reason);
-	efa_com_admin_destroy(edev);
 	efa_free_irq(dev, &dev->admin_irq);
+	efa_com_admin_destroy(edev);
 	efa_disable_msix(dev);
 	efa_com_mmio_reg_read_destroy(edev);
 	devm_iounmap(&pdev->dev, edev->reg_bar);

-- 
2.55.0

