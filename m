Received: from mail-m49245.qiye.163.com (mail-m49245.qiye.163.com [45.254.49.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40A0468C04;
	Thu,  3 Sep 2026 09:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788426027; cv=none; b=EvcLZWe6blIqTklHjNYHTnkf6NfCylRXYBpn8PoyfMULvOyx6vBt0l0kwKWFVLLeElbwHnQZ18jdXhkD9NttdQGPEZm/TiXVxrHq0U8GJZq6m4vaXLP6IHMWHpw29HURAZJ4asuO+8H7kFWveX/0xH1+W+KJ+a81mDn8HYjgAN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788426027; c=relaxed/simple;
	bh=k2s24Epr8d2og4QKDEVuBNYGvZenuKZ2ntwRcgkp3nc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ATPhnZmrBY5ZpRU+woxOmOZa/nurFHuuwaTsRgtaPhx4bioxuWfXhUdmtllK6+piediNuEQ/+4C2Ogs/BzB/J+J/jXdXiZylMme8/4QjVRz37+ltU1bPSX/MK3wX+IyYWOpvDm9D5WeybJ66VdtYvPAkwOox49F4GJQ68wTKlN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnics.com; spf=pass smtp.mailfrom=resnics.com; arc=none smtp.client-ip=45.254.49.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnics.com
Received: from localhost.localdomain (unknown [115.220.204.6])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4c65c5abb;
	Thu, 3 Sep 2026 16:44:53 +0800 (GMT+08:00)
From: Ruizhe Zhou <zhouruizhe@resnics.com>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ruizhe Zhou <zhouruizhe@resnics.com>,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next 09/14] net/mlx5: Remove obsolete 32-bit DMA mask fallback
Date: Thu,  3 Sep 2026 16:43:34 +0800
Message-Id: <20260903084339.870562-10-zhouruizhe@resnics.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260903084339.870562-1-zhouruizhe@resnics.com>
References: <20260903084339.870562-1-zhouruizhe@resnics.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa06671431d03ackunm85c9d55b5cc50
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQ0wZVkJJSEoaSkxOTx5LSFYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSk5VSUlLVUlLT1VNWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+

The DMA API guarantees support for masks of 32 bits or wider and
explicitly identifies retrying a 32-bit mask after a 64-bit request as
incorrect:
https://docs.kernel.org/core-api/dma-api-howto.html#dma-addressing-capabilities

Remove the obsolete fallback while retaining the error check so that a
genuine DMA setup failure is still reported and aborts initialization.

Signed-off-by: Ruizhe Zhou <zhouruizhe@resnics.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 5f28d906c35b..3a3b0ec4aad1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -184,12 +184,8 @@ static int set_dma_caps(struct pci_dev *pdev)
 
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
 	if (err) {
-		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI DMA mask\n");
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev, "Can't set PCI DMA mask, aborting\n");
-			return err;
-		}
+		dev_err(&pdev->dev, "Can't set PCI DMA mask, aborting\n");
+		return err;
 	}
 
 	dma_set_max_seg_size(&pdev->dev, 2u * 1024 * 1024 * 1024);
-- 
2.27.0

