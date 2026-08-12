Received: from mail-m1973184.qiye.163.com (mail-m1973184.qiye.163.com [220.197.31.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8E6388E4D;
	Wed, 12 Aug 2026 04:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786507954; cv=none; b=JUNugbrcbLRHYHNxcqFwLN7zEy1jBCt7BiWNJKBo1DKJXxYwal6lia2ibOl9OJR0QG0xjlpEVHjTm2JmjGkltKCXANPSaWLlqvWI7Cwnxnc3CWCiDgB22PAycWq1wr8WQc/7VtRb0K7Oj3vJbzcbd7zZcbG8Y984NBKZOQHCnPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786507954; c=relaxed/simple;
	bh=iMotWnsy6KTTNE6VBFnFTjhEyN3tRCFhDqO6oAE58cc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nsM/JVEL6uo7m4RhyaCwgeXHzj4x/yOrxmXgTRU6Xh7Oih7HHe2KljRbBSS3byaedCxIhtkldqnnUolNB57DOR0O5bQaSnefQK8Zd3s/ppR7dohldwlXv6u6T94eUrZdufVxxCAhAbjSbN/tIE2cFF/ITClIL2/KhcLIIjyYYxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnics.com; spf=pass smtp.mailfrom=resnics.com; arc=none smtp.client-ip=220.197.31.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnics.com
Received: from localhost.localdomain (unknown [125.122.194.151])
	by smtp.qiye.163.com (Hmail) with ESMTP id 49a9ad23d;
	Wed, 12 Aug 2026 11:36:57 +0800 (GMT+08:00)
From: Ruizhe Zhou <zhouruizhe@resnics.com>
To: linux-rdma@vger.kernel.org
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-kernel@vger.kernel.org,
	Ruizhe Zhou <zhouruizhe@resnics.com>
Subject: [PATCH 2/2] RDMA/mlx5: Remove obsolete 32-bit DMA mask fallback
Date: Wed, 12 Aug 2026 11:36:47 +0800
Message-Id: <20260812033647.2281547-3-zhouruizhe@resnics.com>
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
X-HM-Tid: 0a9ff40b6cb403ackunm50c275441ed2b4
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZHktPVk9CSBkeQkhLGkwfSVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSU5VSklJVUpCT1VKTkpZV1kWGg8SFR0UWUFZT0tIVU
	pLSU9PT0hVSktLVUpCS0tZBg++

The DMA API guarantees support for masks of 32 bits or wider and
explicitly identifies retrying a 32-bit mask after a 64-bit request as
incorrect:
https://docs.kernel.org/core-api/dma-api-howto.html#dma-addressing-capabilities

Remove the obsolete fallback from data direct while retaining the error
check so that a genuine DMA setup failure is still reported and aborts
initialization.

Signed-off-by: Ruizhe Zhou <zhouruizhe@resnics.com>
---
 drivers/infiniband/hw/mlx5/data_direct.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/data_direct.c b/drivers/infiniband/hw/mlx5/data_direct.c
index d57484245c38..93a56ee2c4ef 100644
--- a/drivers/infiniband/hw/mlx5/data_direct.c
+++ b/drivers/infiniband/hw/mlx5/data_direct.c
@@ -65,13 +65,9 @@ static int mlx5_data_direct_set_dma_caps(struct pci_dev *pdev)
 
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (err) {
-		dev_warn(&pdev->dev,
-			 "Warning: couldn't set 64-bit PCI DMA mask, err=%d\n", err);
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev, "Can't set PCI DMA mask, err=%d\n", err);
-			return err;
-		}
+		dev_err(&pdev->dev,
+			"Can't set 64-bit PCI DMA mask, err=%d\n", err);
+		return err;
 	}
 
 	dma_set_max_seg_size(&pdev->dev, SZ_2G);
-- 
2.27.0

