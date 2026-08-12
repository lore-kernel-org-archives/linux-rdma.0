Received: from mail-m127170.xmail.ntesmail.com (mail-m127170.xmail.ntesmail.com [115.236.127.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C10938F255;
	Wed, 12 Aug 2026 04:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.236.127.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786510362; cv=none; b=REeqTqCzuWeS07ynRBHTI/xHcQBOxHnzaLUaLJmG/k0BPKkfelOWUdMo2SlYoaPZE+IH4lVsSnmfONfUemNSecVKoyrIqXXDVRAkth65vsJK6OWtes6BHRMykxZTkaKZ+BcC1G1/O2rmQZ+QyrVV11qQ41QC+4zg4NexCRssGNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786510362; c=relaxed/simple;
	bh=VPEJL7YIkWNcPVBuCq4QgDhio3VHWBq2UozT0eKnznE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HW+xzoMnomAzNQdmFXz76QcO7J3DKArKhbYf1eIpAXUW937xRGdzPhTdP+ztbhxbHBYCpMDfsiTT3rYFAzSZEXO3w8UO3I3HnY/DKuaSS7wWO5XgzxWUYmITzNDvuyvJjO7z4cKo3hV4gONU7E4TSgfxQAZGnquqaouXRPzLTQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnics.com; spf=pass smtp.mailfrom=resnics.com; arc=none smtp.client-ip=115.236.127.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnics.com
Received: from localhost.localdomain (unknown [125.122.194.151])
	by smtp.qiye.163.com (Hmail) with ESMTP id 49a9ad234;
	Wed, 12 Aug 2026 11:36:56 +0800 (GMT+08:00)
From: Ruizhe Zhou <zhouruizhe@resnics.com>
To: linux-rdma@vger.kernel.org
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-kernel@vger.kernel.org,
	Ruizhe Zhou <zhouruizhe@resnics.com>
Subject: [PATCH 1/2] RDMA/hfi1: Remove obsolete 32-bit DMA mask fallback
Date: Wed, 12 Aug 2026 11:36:46 +0800
Message-Id: <20260812033647.2281547-2-zhouruizhe@resnics.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260812033647.2281547-1-zhouruizhe@resnics.com>
References: <20260812033647.2281547-1-zhouruizhe@resnics.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ff40b6a1303ackunm50c275441ed2ae
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaTU1CVksZTU4aGU1KSk5OTFYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU5VSklJVUpCT1VKTkpZV1kWGg8SFR0UWUFZT0tIVU
	pLSU9PT0hVSktLVUpCS0tZBg++

The DMA API guarantees support for masks of 32 bits or wider and
explicitly identifies retrying a 32-bit mask after a 64-bit request as
incorrect:
https://docs.kernel.org/core-api/dma-api-howto.html#dma-addressing-capabilities

Remove the obsolete fallback while retaining the error check so that a
genuine DMA setup failure is still reported and aborts initialization.

Signed-off-by: Ruizhe Zhou <zhouruizhe@resnics.com>
---
 drivers/infiniband/hw/hfi1/pcie.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pcie.c b/drivers/infiniband/hw/hfi1/pcie.c
index 1154b8cc713c..106bed4932c8 100644
--- a/drivers/infiniband/hw/hfi1/pcie.c
+++ b/drivers/infiniband/hw/hfi1/pcie.c
@@ -53,17 +53,9 @@ int hfi1_pcie_init(struct pci_dev *pdev)
 
 	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (ret) {
-		/*
-		 * If the 64 bit setup fails, try 32 bit.  Some systems
-		 * do not setup 64 bit maps on systems with 2GB or less
-		 * memory installed.
-		 */
-		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (ret) {
-			dev_err(&pdev->dev, "Unable to set DMA mask: %pe\n",
-				ERR_PTR(ret));
-			goto bail;
-		}
+		dev_err(&pdev->dev, "Unable to set DMA mask: %pe\n",
+			ERR_PTR(ret));
+		goto bail;
 	}
 
 	pci_set_master(pdev);
-- 
2.27.0

