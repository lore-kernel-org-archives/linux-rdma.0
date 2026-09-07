Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E3D4921B7;
	Mon,  7 Sep 2026 18:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788806723; cv=none; b=lUYemSNjKebgMvLQAaa9jqi6B+Row/sIriixnUVyYsIuWGxcUuBF4SJqVueJhW5lryMTF8gz753oWBHkynNn1cA1bzi0cTtj8wV2iBk/wO7UTt2qQd6PJUx1EZoBtanzauXlIw0jxVO7N8qRrdqj+tmr2nFCJxg9EGENz97dmfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788806723; c=relaxed/simple;
	bh=9NJgpOYOdQm4pw4vP48Tc2j2HUsgGIDWGi3W5M/VjSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m1Wv1YdkXgBWR6S3I14hCqXC9PqmCeothMRs1tGGOKCP69nqdNVRseHGd6kasgLJmagoab1N5ebi9JLgsGemY8KKI6s44RSZjNcFvb8Nrhk7/XbNm/RELAjnfLAl0g8WovrH0XGZWwmphySL13ul9xxsHgu4IsAapXxWwfC4lCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtZ2xv69; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtZ2xv69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC6C1F00A3E;
	Mon,  7 Sep 2026 18:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788806701;
	bh=mV/a3PsZh7IcLP4sv99OQkPWwIBpdIi9GVTR2L9hKas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XtZ2xv69oHMuvLOpFTbkL4wy8c8g7tyxgZXk3tImdKjFwPGtdd3cTywQ+JovPegBx
	 WiWw3ErLsLs+70p6rsUFI/rX0tHoyaM2IVqHAq1LMKqXIoD5+7MyU6GXwpNQ6SJrLB
	 ER2aKtRy2UVmx/oUAUsWB5V6u+vellPbDB2mR3WbHo1elSiu6/Y7AE0BafVkp6r2Y+
	 ukHpSKxKgcNsW7UPPKXETKPCRgweQ3hIcYq/C8MMfX/j/kYk91fl2q6QokwBlE2PdY
	 8nXYJfDuFVPPUWnEYfGHe+43KYrYwi/IVksvQhGEnmxOCriG5t68KbEtrzH6rQfF9/
	 V1gTCA4+VJX3w==
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
Subject: [PATCH rdma-next 2/2] RDMA/efa: Keep EQ resources alive while IRQ is registered
Date: Mon,  7 Sep 2026 21:44:47 +0300
Message-ID: <20260907-use-after-free-of-admin-queue-struct-v1-2-dd9d9267fbf4@nvidia.com>
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

The completion IRQ handler accesses the EQ state and DMA buffer. Its IRQ was
registered before that state was initialized, while teardown released the
buffer before free_irq() synchronized the handler.

Initialize the EQ without arming it, register the IRQ, and then arm it.
Reverse the resource order during teardown by freeing the IRQ before
destroying the EQ.

Fixes: 2a152512a155 ("RDMA/efa: CQ notifications")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/efa/efa_com.c  |  3 +--
 drivers/infiniband/hw/efa/efa_com.h  |  1 +
 drivers/infiniband/hw/efa/efa_main.c | 18 ++++++++++--------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index cb2d448db2d7..04c6d63c449e 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -1252,7 +1252,7 @@ static void efa_com_destroy_eq(struct efa_com_dev *edev,
 				      err);
 }
 
-static void efa_com_arm_eq(struct efa_com_dev *edev, struct efa_com_eq *eeq)
+void efa_com_arm_eq(struct efa_com_dev *edev, struct efa_com_eq *eeq)
 {
 	u32 val = 0;
 
@@ -1341,7 +1341,6 @@ int efa_com_eq_init(struct efa_com_dev *edev, struct efa_com_eq *eeq,
 	eeq->phase = 1;
 	eeq->depth = params.depth;
 	eeq->cb = cb;
-	efa_com_arm_eq(edev, eeq);
 
 	return 0;
 
diff --git a/drivers/infiniband/hw/efa/efa_com.h b/drivers/infiniband/hw/efa/efa_com.h
index 0341704d0921..98fb6a42a6cb 100644
--- a/drivers/infiniband/hw/efa/efa_com.h
+++ b/drivers/infiniband/hw/efa/efa_com.h
@@ -169,6 +169,7 @@ int efa_com_admin_init(struct efa_com_dev *edev,
 void efa_com_admin_destroy(struct efa_com_dev *edev);
 int efa_com_eq_init(struct efa_com_dev *edev, struct efa_com_eq *eeq,
 		    efa_eqe_handler cb, u16 depth, u8 msix_vec);
+void efa_com_arm_eq(struct efa_com_dev *edev, struct efa_com_eq *eeq);
 void efa_com_eq_destroy(struct efa_com_dev *edev, struct efa_com_eq *eeq);
 int efa_com_dev_reset(struct efa_com_dev *edev,
 		      enum efa_regs_reset_reason_types reset_reason);
diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
index b1df9bb8fac2..753ed8430b69 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -302,28 +302,30 @@ static void efa_set_host_info(struct efa_dev *dev)
 
 static void efa_destroy_eq(struct efa_dev *dev, struct efa_eq *eq)
 {
-	efa_com_eq_destroy(&dev->edev, &eq->eeq);
 	efa_free_irq(dev, &eq->irq);
+	efa_com_eq_destroy(&dev->edev, &eq->eeq);
 }
 
 static int efa_create_eq(struct efa_dev *dev, struct efa_eq *eq, u32 msix_vec)
 {
 	int err;
 
-	efa_setup_comp_irq(dev, eq, msix_vec);
-	err = efa_request_irq(dev, &eq->irq);
+	err = efa_com_eq_init(&dev->edev, &eq->eeq, efa_process_eqe,
+			      dev->dev_attr.max_eq_depth, msix_vec);
 	if (err)
 		return err;
 
-	err = efa_com_eq_init(&dev->edev, &eq->eeq, efa_process_eqe,
-			      dev->dev_attr.max_eq_depth, msix_vec);
+	efa_setup_comp_irq(dev, eq, msix_vec);
+	err = efa_request_irq(dev, &eq->irq);
 	if (err)
-		goto err_free_comp_irq;
+		goto err_destroy_eq;
+
+	efa_com_arm_eq(&dev->edev, &eq->eeq);
 
 	return 0;
 
-err_free_comp_irq:
-	efa_free_irq(dev, &eq->irq);
+err_destroy_eq:
+	efa_com_eq_destroy(&dev->edev, &eq->eeq);
 	return err;
 }
 

-- 
2.55.0

